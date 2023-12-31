# server.R

# Source the server module files
source("servers/linear_regression_server.R")
source("servers/knn_server.R")
source("servers/eda_server.R")

# Define the Shiny server function with input, output, and session parameters
shinyServer(function(input, output, session) {
  server_module1(input, output, session)
  server_module2(input, output, session)
  server_module3(input, output, session)
})


