# views/linear_regression_page.R

# Define a list of built-in dataframes in R
dataframes_list_2 <- list(
  "mtcars" = mtcars,
  "swiss" = swiss,
  "airquality" = airquality
)

# Define the UI for the Linear Regression page
ui <- fluidPage(
  h1(tags$span(icon("timeline"), "Linear Regression"), class = "titlePanel"),
  
  # First row with an explanation box
  fluidRow(
    div(
      class = "explanation-box",
      box(
        title = "How to use this function?",
        width = NULL,
        "To initiate the desired prediction, you must first select one of the three datasets. Depending on the chosen dataset, the appropriate set of variables will be displayed. From these, you can then select the variable you want to predict (dependent variable) and any number of predictors. Accordingly, in the case of only one predictor, the plot will be displayed, and in any case, a statistical summary of the entire process will be provided. Finally, the Mean Absolute Error (MAE) will be presented, which indicates on average how much our prediction deviates from the actual value."
      )
    )
  ),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    box(
      # Dropdown to choose a dataframe
      selectInput("dataframe_2", "Choose a Dataframe", choices = names(dataframes_list_2)),
      
      # Dynamic UI for selecting the dependent variable
      uiOutput("dependent_var_ui_2"),
      
      # Dynamic UI for selecting independent variables
      uiOutput("independent_vars_ui_2"),
      
      # Text output for informational messages
      textOutput("message"),
      width = 3,
      style = "background: transparent; padding: 15px;"
    ),
    
    # Main panel with output elements
    mainPanel(
      # Scatter plot for Linear Regression
      plotOutput("scatter_plot"),
      br(),
      
      # Verbatim text output for statistical summary
      verbatimTextOutput("summary"),
      br(),
      
      # Text output for Mean Absolute Error (MAE)
      htmlOutput("MAE"),
      br(),
      
      # Table output
      htmlOutput("my_table"),
      width = 9 
    )
  )
)