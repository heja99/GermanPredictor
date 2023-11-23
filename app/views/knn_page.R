# views/knn_page.R

# Define a list of built-in dataframes in R
dataframes_list_1 <- list(
  "mtcars" = mtcars,
  "swiss" = swiss,
  "airquality" = airquality
)

# Define the UI for the K-Nearest Neighbor (KNN) page
ui <- fluidPage(
  h1(tags$span(icon("circle-nodes"), "K-Nearest Neighbor"), class = "titlePanel"),
  
  # First row with an explanation box
  fluidRow(
    div(
      class = "explanation-box",
      box(
        title = "How to use this function?",
        width = NULL,
        "To initiate the desired prediction, you must first select one of the three datasets. Depending on the chosen dataset, the appropriate set of variables will be displayed. From these, you can then select the variable you want to predict (dependent variable) and any number of predictors. Accordingly, a plot and text will be shown in which the process of finding the best k-value is displayed. Finally, the Mean Absolute Error (MAE) will be presented, which indicates on average how much our prediction deviates from the actual value."
      )
    )
  ),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    box(
      # Dropdown to choose a dataframe
      selectInput("dataframe_1", "Choose a dataframe", choices = names(dataframes_list_1)),
      
      # Dynamic UI for selecting the dependent variable
      uiOutput("dependent_var_ui_knn"),
      
      # Dynamic UI for selecting independent variables
      uiOutput("independent_vars_ui_knn"),
      width = 3,
      style = "background: transparent; padding: 15px;"
    ),
    
    # Main panel with output elements
    mainPanel(
      # Scatter plot for KNN
      plotOutput("scatter_plot_knn"),
      br(),
      
      # Verbatim text output for statistical summary
      verbatimTextOutput("summary_knn"),
      br(),
      
      # Text output for Mean Absolute Error (MAE)
      htmlOutput("MAE_knn"),
      br(),
      # Table output
      htmlOutput("my_table_knn"),
      width = 9
    )
  )
)
