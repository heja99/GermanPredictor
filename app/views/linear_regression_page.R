# views/linear_regression_page.R

# Define a list of built-in dataframes in R
dataframes_list_2 <- list(
  "mtcars" = mtcars,
  "iris" = iris,
  "airquality" = airquality
)

# Define the UI
ui <- fluidPage(
  h1(tags$span(icon("timeline"), "Linear Regression"), class = "titlePanel"),
  
  fluidRow(
    # Info box
    div(class = "explanation-box",
      box(
        title = "How to use this function?",
        width = NULL,
        "To initiate the desired prediction, you must first select one of the three datasets. Depending on the chosen dataset, the appropriate set of variables will be displayed. From these, you can then select the variable you want to predict (dependent variable) and any number of predictors. Accordingly, in the case of only one predictor, the plot will be displayed, and in any case, a statistical summary of the entire process will be provided. Finally, the Mean Absolute Error (MAE) will be presented, which indicates on average how much our prediction deviates from the actual value.",
      )
    )
  ),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    box(
      selectInput("dataframe_2", "Choose a Dataframe", choices = names(dataframes_list)),
      uiOutput("dependent_var_ui_2"),
      uiOutput("independent_vars_ui_2"),
      textOutput("message"),
      width = 3,  # Set the width of the box
      style = "background: transparent; padding: 15px;"
    ),
    
    mainPanel(
      plotOutput("scatter_plot"),
      br(),
      verbatimTextOutput("summary"),
      br(),
      textOutput("MAE"),
      br(),
      tableOutput("my_table"),
      width = 9
    )
  )
)