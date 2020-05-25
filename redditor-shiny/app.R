library(redditor)
library(future)
library(httr)
library(jsonlite)
library(openxlsx)


options(shiny.sanitize.errors = FALSE)
con <- postgres_connector()
LENOVO = Sys.getenv('LENOVO')
# curl -X GET "http://127.0.0.1:9798/get_summary" -H  "accept: application/json"



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
          infoBoxOutput("submissionsBox", width = 4),
          infoBoxOutput("authorsBox", width = 4),
          infoBoxOutput("subredditsBox", width = 4)
        ),
        # fluidRow(
        #   numericInput(inputId = "limit_value", label = "Plot N Seconds", value = 3000, min = 100, max = 1000000)
        # ),
        fluidRow(
          plotOutput("all_time_submissions")
        ),
        fluidRow(
          plotOutput("submissions_cumulative")
        )
      ),
      tabItem(
        tabName = "search",
        fluidRow(
          box(textInput(inputId = "search_value", label = "Query Data", value = "Natural Language Processing", placeholder = "Natural Language Processing")),
          downloadButton("downloadData", "Download")
        ),
        fluidRow(
          dataTableOutput("search_data")
        )
      )
    )
  )
)

server <- function(input, output) {
  resp <- GET(url = glue("http://{LENOVO}/api/get_summary"), query = list(table_name = "meta_statistics"))
  meta_statistics <- fromJSON(fromJSON(content(resp, "text"))$data)
  resp <- GET(url = glue("http://{LENOVO}/api/get_summary"), query = list(table_name = "counts_by_second"))
  counts_by_second <- fromJSON(fromJSON(content(resp, "text"))$data)

  elastic_results <- reactive({
    data <- find_posts(search_term = input$search_value, limit = 100, table_name = "submissions") %>%
      transmute(
        created_utc = as_date(created_utc),
        days_ago = as.numeric(Sys.Date() - created_utc),
        author, subreddit, title, permalink, shortlink
      ) %>%
      mutate_all(as.character) %>%
      as_tibble()

    data
  })

  output$submissionsBox <- renderInfoBox({
    infoBox(
      "Submissions Gathered", comma(filter(as.data.frame(meta_statistics), type == "submissions")$value),
      icon = icon("list"),
      color = "purple"
    )
  })

  output$subredditsBox <- renderInfoBox({
    infoBox(
      "Subreddits Discovered", comma(filter(as.data.frame(meta_statistics), type == "subreddits")$value),
      icon = icon("list"),
      color = "purple"
    )
  })

  output$authorsBox <- renderInfoBox({
    infoBox(
      "Authors Discovered", comma(filter(as.data.frame(meta_statistics), type == "authors")$value),
      icon = icon("list"),
      color = "purple"
    )
  })


  output$submissions_cumulative <- renderPlot({
    cbs <-
      counts_by_second %>%
      arrange(created_utc) %>%
      mutate(
        created_utc = floor_date(ymd_hms(created_utc), unit = "hour"),
        created_utc = with_tz(created_utc, tzone = "America/Denver"),
        n_observations = as.numeric(n_observations)
      ) %>%
      group_by(created_utc) %>%
      summarise(n_observations = sum(n_observations)) %>%
      ungroup()

    cbs$cumsum_amount <- cumsum(cbs$n_observations)

    ggplot(cbs) +
      aes(x = created_utc, y = cumsum_amount) +
      geom_line() +
      xlab("Created At") +
      ylab("Submissions Accumulated")
  })

  output$all_time_submissions <- renderPlot({
    counts_by_second %>%
      head(60 * 60 * 6) %>%
      mutate(
        created_utc = floor_date(ymd_hms(created_utc), unit = "minutes"),
        created_utc = with_tz(created_utc, tzone = "America/Denver"),
        n_observations = as.numeric(n_observations)
      ) %>%
      group_by(created_utc) %>%
      summarise(n_observations = sum(n_observations)) %>%
      ggplot() +
      aes(x = created_utc, y = n_observations) +
      geom_line() +
      xlab("Created At") +
      ylab("Submissions Gathered")
  })



  output$downloadData <- downloadHandler(
    filename = function() {
      paste("output", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(elastic_results(), file, row.names = FALSE)
    }
  )

  output$search_data <- renderDataTable({
    response <- elastic_results()

    datatable(response,
      extensions = "Buttons",

      options = list(
        paging = TRUE,
        searching = TRUE,
        fixedColumns = TRUE,
        autoWidth = TRUE,
        ordering = TRUE,
        dom = "tB"
      ),

      class = "display"
    )
  })
}

shinyApp(ui, server)
