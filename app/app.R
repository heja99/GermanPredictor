# app.R

# Load UI and server modules as well as global.R
source("global.R")
source("ui.R")
source("server.R")

# Run the Shiny app
shinyApp(ui = shinyUI, server = shinyServer)