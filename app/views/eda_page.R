# views/eda_page.R
library(DT)

# Define a list of built-in dataframes in R
dataframes_list <- list(
  "mtcars" = mtcars,
  "iris" = iris,
  "airquality" = airquality
)

# Define the UI
ui <- fluidPage(
  h1(tags$span(icon("magnifying-glass-chart"), "Exploratory Data Analysis (EDA)"), class = "titlePanel"),
  selectInput("dataframe", "Choose a dataframe", choices = names(dataframes_list)),
  DTOutput("table"),
  br(),
  plotOutput("correlation_heatmap"),
  br(),
  selectInput("numeric_var", "Choose a numerical variable for histogram", ""),
  plotOutput("histogram")
)

