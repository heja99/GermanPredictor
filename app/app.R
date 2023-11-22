# app.R

# library(shiny)
# library(caret)
# library(rattle)
# library(corrplot)
# library(DT)

# Load UI and server modules
source("global.R")
source("ui.R")
source("server.R")

# Run the Shiny app
shinyApp(ui = shinyUI, server = shinyServer)