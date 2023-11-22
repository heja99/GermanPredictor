# views/home_page.R

# homePageUI function definition
homePageUI <- function() {
  # Define the UI for the home page
  fluidPage(
    # First row
    fluidRow(
      # Welcome Title
      h1("Welcome to the German Predictor!", class = "welcome-title"),  # Main title
      h2("Efficient, Precise and Always on Time.", class = "welcome-subtitle"),  # Subtitle
      
      # Three infoboxes
      infoBox(
        "Information about car models.",
        "Dataset 1: mtcars",
        icon = icon("car"),
        fill = TRUE,
        color = "purple",
      ),      
      infoBox(
        "Measurements of iris flowers.",
        "Dataset 2: iris",
        icon = icon("plant-wilt"),
        fill = TRUE,
        color = "purple",
      ),
      infoBox(
        "NY Air Quality Measurements.",
        "Dataset 3: airquality",
        icon = icon("wind"),
        fill = TRUE,
        color = "purple",
      )
    ),
    
    # Second row
    fluidRow(
      # Info box
      div(
        class = "explanation-box",
        box(
          title = "App Description",
          width = NULL,
          "Check out our new app, the German Predictor! It's like a GPS for navigating the wild world of predictive modeling. No need to get stuck in the math maze or drown in lines of code – we keep it simple. With three cool functions – Exploratory Data Analysis (EDA), Linear Regression, and K-Nearest Neighbors (KNN) – you can play around with these models on three ready-to-go datasets. It's like having a modeling party without the headache. Whether you're a data whiz or just getting started, German Predictor makes predictive modeling a breeze. Give it a spin now and see how predicting the future can be as easy as ordering a pizza!"
        )
      )
    ),
    
    # Third row
    fluidRow(
      # Three columns with boxes
      column(width = 4,
             box(
               title = "Exploratory Data Analysis (EDA)",
               width = NULL,
               "Investigate the data you use for predictions.",
               status = "primary",
               solidHeader = TRUE,
               img(src = "EDA.png", width = "100%")  # Image for EDA
             )
      ),
      column(width = 4,
             box(
               title = "Linear Regression",
               width = NULL,
               "Linear approach for predictions.",
               status = "primary",
               solidHeader = TRUE,
               img(src = "Linear_Regression.png", width = "100%")  # Image for Linear Regression
             )
      ),
      column(width = 4,
             box(
               title = "K-Nearest Neighbor",
               width = NULL,
               "Non-linear approach for predictions.",
               status = "primary",
               solidHeader = TRUE,
               img(src = "KNN.png", width = "100%")  # Image for KNN
             )
      )
    )
  )
}
