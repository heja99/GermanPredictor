# views/eda_page.R

# Define a list of built-in dataframes in R
dataframes_list <- list(
  "mtcars" = mtcars,
  "iris" = iris,
  "airquality" = airquality
)

# Define the UI
ui <- fluidPage(
  # Page title with a magnifying glass icon
  h1(
    tags$span(icon("magnifying-glass-chart"), "Exploratory Data Analysis (EDA)"),
    class = "titlePanel"
  ),
  
  # First row with an explanation box
  fluidRow(
    div(
      class = "explanation-box",
      box(
        title = "How to use this function?",
        width = NULL,
        "Exploratory Data Analysis (EDA) is a data analysis approach that involves visually exploring and summarizing data to identify patterns, trends, and insights, aiding in a better understanding of the dataset's characteristics before formal modeling. On this page you can find three ways to explore the three provided dataset. Choose the model you're interested in, and you'll be able to visualize the dataset, analyze feature correlations, and examine the overall distribution of predictors."
      )
    )
  ),
  
  # Dropdown to choose a dataframe
  selectInput("dataframe", "Choose a dataframe", choices = names(dataframes_list)),
  
  # DataTable output for displaying datasets
  DTOutput("table"),
  br(),
  
  # Output for displaying a correlation heatmap
  plotOutput("correlation_heatmap"),
  br(),
  
  # Dropdown to choose a numerical variable for histogram
  selectInput("numeric_var", "Choose a numerical variable for histogram", ""),
  
  # Output for displaying a histogram
  plotOutput("histogram")
)
