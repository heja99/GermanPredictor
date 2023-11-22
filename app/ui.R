# ui.R

# Source the UI page files
source("views/home_page.R")

# Create dashboard with shinyDashboard
dashboardPage(
  skin = "purple",
  dashboardHeader(
    title = "German Predictor"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(" Home", tabName = "home", icon = icon("home")),
      menuItem(" Exploratory Data Analysis", tabName = "eda", icon = icon("magnifying-glass-chart")),
      menuItem(" Linear Regression", tabName = "linear-regression", icon = icon("timeline")),
      menuItem(" K-Nearest Neighbors", tabName = "knn", icon = icon("circle-nodes"))
    )
  ),
  dashboardBody(
    # Include custom CSS styles
    includeCSS("www/styles.css"),
    
    tabItems(
      # Home tab
      tabItem(tabName = "home", homePageUI()), 
      
      # EDA tab
      tabItem(tabName = "eda", source("views/eda_page.R")[1]),
      
      # Linear Regression tab
      tabItem(tabName = "linear-regression", source("views/linear_regression_page.R")[1]),
      
      # KNN tab
      tabItem(tabName = "knn", source("views/knn_page.R")[1])
    )
  )
)
