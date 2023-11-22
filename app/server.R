# server.R

library(shiny)
library(caret)
library(rattle)
library(corrplot)
library(DT)

source("servers/linear_regression_server.R")
source("servers/knn_server.R")
source("servers/eda_server.R")

shinyServer(function(input, output, session) {
  server_module1(input, output, session)
  server_module2(input, output, session)
  server_module3(input, output, session)
})


