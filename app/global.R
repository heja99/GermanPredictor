# global.R

# List of packages to be installed if not already installed
list.of.packages <- c(
  "shiny",
  "shinydashboard",
  "caret",
  "rattle",
  "corrplot",
  "DT"
)

# Identify new packages that are not yet installed
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]

# Install new packages if necessary
if (length(new.packages))
  install.packages(new.packages)

# Load necessary libraries
library(shiny)
library(shinydashboard)
library(caret)
library(rattle)
library(corrplot)
library(DT)