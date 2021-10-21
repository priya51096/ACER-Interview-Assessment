library(shiny)
library(readxl)
library(readr)
library(visdat)

# Define UI for data upload app ----
ui <- fluidPage(
  img(src = "acer_logo.jpg", height = 190, width = 1008, align = "center"),
  
  # App title ----
  titlePanel("Please Select & Upload your file"),
  p("This application provides an user interface to select an Excel file or CSV file and display the contents of the selected file.",
    style="text-align:justify;font-size:18px;color:black;background-color:papayawhip;padding:5px;border-radius:5px"),
  
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Selecting the type of file to choose
      radioButtons(inputId = "filetype_input",
        label = h3("Choose File type"),
        choices = list("csv file" = 1, 
                       "excel file" = 2),
        selected = 1,
        inline = TRUE),
      
      # Input: Select a file ----
      fileInput(inputId = "file1", 
                label = "Choose your File",
                multiple = FALSE,
                accept = c(".csv", ".xlsx")),
      
      helpText(a("If you enjoyed using my application, Click Here and Contact Me:)",     
                 href="https://www.linkedin.com/in/priya-dingorkar/")
      ),
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      tabsetPanel(type = "tabs", 
                  tabPanel("Data", tableOutput("contents"))),
      
    )
    
  )
  
)

# Define server logic to read selected file ----
server <- function(input, output, session) {
  
  data <- reactive({
    
    req(input$file1)
    
    ext <- tools::file_ext(input$file1$name)
    
    switch(ext,
           csv = read.csv(input$file1$datapath),
           xlsx = readxl::read_excel(input$file1$datapath),
           validate("Invalid file; Please upload a CSV file or an Excel file only")
    )
  })
  
  output$contents <- renderTable({
    
   data()
    
  })
  
  
  
}

# Create Shiny app ----
shinyApp(ui, server)