library(redditor)
library(future)
library(httr)
library(jsonlite)
library(openxlsx)


options(shiny.sanitize.errors = FALSE)
con <- postgres_connector()
reddit <- reddit_connector()
# reddit_con <- reddit_connector()
LENOVO <- Sys.getenv("LENOVO")
# curl -X GET "http://127.0.0.1:9798/get_summary" -H  "accept: application/json"

build_datatable <- function(the_datatable) {
  datatable(the_datatable,
            extensions = c("Buttons", "Scroller"),
            options = list(
              scrollY = 650,
              scrollX = 500,
              deferRender = TRUE,
              scroller = TRUE,
              fixedColumns = TRUE,
              # paging = TRUE,
              # pageLength = 25,
              buttons = list( #' excel',
                list(extend = "colvis", targets = 0, visible = FALSE)
              ),
              dom = "lBfrtip",
              fixedColumns = TRUE
            ),
            rownames = FALSE
  )
}

ui <- dashboardPage(
  dashboardHeader(title = "NDEXReddit"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Search", tabName = "search", icon = icon("th")),
      menuItem("Permalink", tabName = "permalink", icon = icon("th"))
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
        )
      ),
      tabItem(
        tabName = "search",
        fluidRow(
          checkboxInput("removensfw", "Remove NSFW", TRUE),
          textInput(inputId = "search_value", label = "Query Data", 
                           value = "Natural Language Processing", 
                           placeholder = "Natural Language Processing"),
          downloadButton("downloadData", "Download"), width=12
        ),
        fluidRow(
          column(dataTableOutput("search_data"), width = 12)
        ),
        fluidRow(
          column(uiOutput("imageOutput"), width=12)
        )
      ),
      tabItem(
        tabName = "permalink",
        fluidRow(
          textInput(inputId = 'permalink', label = 'Permalink', value = '/r/SeriousConversation/comments/gteetu/you_know_what_would_significantly_impact_police/'),
          column(dataTableOutput("permalink_summary"), width = 12),
          column(dataTableOutput("permalink_data"), width = 12)
        )
      )
    )
  )
)

server <- function(input, output) {
  resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "meta_statistics"))
  meta_statistics <- fromJSON(fromJSON(content(resp, "text"))$data)
  resp <- GET(url = glue("http://ndexr.com/api/get_summary"), query = list(table_name = "counts_by_minute"))
  counts_by_second <- fromJSON(fromJSON(content(resp, "text"))$data)

  elastic_results <- reactive({
    data <- find_posts(search_term = input$search_value, limit = 100, table_name = "submissions")
    if(input$removensfw) {
     data <-  data[!as.logical(data$over_18),]
    }
    data <-
      data %>%
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
      "Authors Discovered", comma(filter(
        as.data.frame(meta_statistics),
        type == "authors"
      )$value),
      icon = icon("list"),
      color = "purple"
    )
  })

  output$all_time_submissions <- renderPlot({
    counts_by_second %>%
      mutate(
        created_utc = floor_date(ymd_hms(created_utc), unit = "minutes"),
        created_utc = with_tz(created_utc, tzone = "America/Denver"),
        n_observations = as.numeric(n_observations)
      ) %>%
      # group_by(created_utc) %>%
      # summarise(n_observations = sum(n_observations)) %>%
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
    response <- response %>%
      rename_all(function(x) {
        x %>%
          str_replace_all("_", " ") %>%
          str_to_title()
      })

    build_datatable(response)
  })
  
  output$imageOutput <- renderUI({
    
    images_to_show <- elastic_results()$url
    print(images_to_show[!str_detect(images_to_show, 'www.reddit.com')])
    images_to_show <- images_to_show[!str_detect(images_to_show, 'www.reddit.com')]
    
    map(unique(images_to_show), ~ box(tags$a(
      href=., 
      tags$img(src=., 
               title="Example Image Link", 
               width="100%")
    ), width = 3))
  })
  
  current_permalink <- reactive({
    reddit_con <- reddit_connector()
    response <-
      build_submission_stack(permalink = input$permalink)
    
    response
  })
  

  
  output$permalink_summary <- renderDataTable({
    
    summarise_thread_stack(current_permalink()) %>%
      arrange(desc(engagement_ratio)) 
    # build_datatable
  })
  
  
  output$permalink_data <- renderDataTable({
    
    response <- 
      current_permalink() %>% 
      select(thread_number, created_utc, author, body, everything())
    
    build_datatable(response)
  })
  
  
  
}

shinyApp(ui, server)
