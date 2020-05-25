library(redditor)
library(future)

options(shiny.sanitize.errors = FALSE)
con <- postgres_connector()

get_count <- function(table_name = "submissions",
                      min_date = "2020-05-03",
                      max_date = Sys.Date(), cache = TRUE) {
  con <- postgres_connector()
  on.exit(dbDisconnect(conn = con))

  table_name <-
    tbl(con, in_schema("public", table_name)) %>%
    count(name = "n_observations") %>%
    my_collect()

  write_rds(table_name, "table_name.rda")

  total_sum <- table_name$n_observations

  total_sum
}



ui <- dashboardPage(
  dashboardHeader(title = "NDEXR"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Search", tabName = "search", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "dashboard",
        fluidRow(
          # Dynamic infoBoxes
          infoBoxOutput("progressBox", width = 12)
        ),
        fluidRow(
          numericInput(inputId = "limit_value", label = "Plot N Seconds", value = 3000, min = 100, max = 1000000)
        ),
        fluidRow(
          # Clicking this will increment the progress amount
          plotOutput("all_time_comments")
        ),
        fluidRow(
          plotOutput("all_time_submissions")
        )
      ),
      tabItem(
        tabName = "search",
        fluidRow(
          box(textInput(inputId = "search_value", label = "Query Data", value = "Natural Language Processing", placeholder = "Natural Language Processing"))
        ),
        fluidRow(
          dataTableOutput("search_data")
        )
      )
    )
  )
)

server <- function(input, output) {
  submissions_count <- get_count("submissions")

  output$progressBox <- renderInfoBox({
    infoBox(
      "Submissions Gathered", submissions_count,
      icon = icon("list"),
      color = "purple"
    )
  })


  output$all_time_comments <- renderPlot({
    future({
      plot_stream(limit = as.numeric(input$limit_value), timezone = "MST", add_hours = 1, table = "comments")
    })
  })

  output$all_time_submissions <- renderPlot({
    future({
      plot_submissions()
    })
  })


  output$search_data <- renderDataTable({
    response <- find_posts(search_term = input$search_value, limit = 30, table_name = "submissions") %>%
      transmute(
        created_utc = as_date(created_utc),
        days_ago = as.numeric(Sys.Date() - created_utc),
        author, subreddit, title, permalink, shortlink
      ) %>%
      mutate_all(as.character) %>%
      as_tibble()

    response
  })
}

shinyApp(ui, server)
