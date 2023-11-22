list.of.packages <-
  c(
    "shiny",
    "shinydashboard",
    "caret",
    "rattle",
    "corrplot",
    "DT"
  )

new.packages <-
  list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if (length(new.packages))
  install.packages(new.packages)

library(shiny)
library(shinydashboard)
library(caret)
library(rattle)
library(corrplot)
library(DT)