library(shinymanager);library(RSQLite);library(DBI)

# Security Settings
credentials <- data.frame(
  user = c("shiny", "shinymanager"),
  password = c("shiny", "shinymanager"), stringsAsFactors = FALSE,
  admin = c(FALSE, TRUE))

create_db(credentials_data = credentials,
          sqlite_path = "database.sqlite")

# UI
ui <- fluidPage(
  
  # Application title
  titlePanel("mtcars Hp Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 30,
                  value = 15)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
) 

ui <- secure_app(ui, enable_admin = TRUE)


# Server
server <- function(input, output, session) {
  res_auth <- secure_server(
    check_credentials = check_credentials("database.sqlite"))
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- mtcars$hp
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

shinyApp(ui, server)