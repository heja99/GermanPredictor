# servers/knn_server.R

# Define the server logic
server_module2 <- function(input, output, session) {
  # Reactive expression for selected dataframe
  selected_df <- reactive({
    dataframes_list_1[[input$dataframe_1]]
  })
  
  # Render dependent variable UI
  output$dependent_var_ui_knn <- renderUI({
    df <- selected_df()
    selectInput("dependent_var_1", "Choose the Dependent Variable", choices = colnames(df))
  })
  
  # Render independent variables UI
  output$independent_vars_ui_knn <- renderUI({
    df <- selected_df()
    checkboxGroupInput("independent_vars_1", "Choose the Independent Variables", choices = colnames(df))
  })
  
  # Perform KNN regression and display summary & plot
  output_data_knn <- reactive({
    req(input$dependent_var_1, input$independent_vars_1)
    
    df <- selected_df()
    dep_var <- input$dependent_var_1
    ind_vars <- input$independent_vars_1
    
    vars_length <- length(ind_vars)
    
    if(sum(dep_var == ind_vars)>0)
    {
      equal_error = TRUE
    }
    else
    {
      equal_error = FALSE
    }
    
    if (vars_length && !equal_error) {
      # Filter out any missing values in the selected variables
      filtered_df <- df[complete.cases(df[, c(dep_var, ind_vars)]), ]
      train_ind <- createDataPartition(filtered_df[, 1], p = 0.75, list = FALSE)
      training <- filtered_df[train_ind, ]
      testing <- filtered_df[-train_ind, ]
      
      # Create formula for KNN
      formula <- as.formula(paste(dep_var, "~", paste(ind_vars, collapse = " + ")))
      
      # Set up control parameters for 10-fold cross-validation
      ctrl <- trainControl(method = "cv",  # Cross-validation method
                           number = 10)   # Number of folds
      k_values = 1:20
      knn_model_cv <- train(formula, data = training, method = "knn", trControl =ctrl , preProcess = c("center", "scale"), tuneGrid=data.frame(k=k_values))
      predicitons = predict(knn_model_cv,testing)
      column_name = dep_var
      MAE_KNN= (mean(abs(testing[,column_name]-predicitons)))
      vec = c(1:3)
      my_examples_pred = predicitons[vec]
      my_examples_true = testing[vec,column_name]
      list(
        knn_model_cv = knn_model_cv,
        vars_length = vars_length,
        MAE_KNN = MAE_KNN,
        my_examples_pred = my_examples_pred,
        my_examples_true = my_examples_true,
        equal_error = equal_error
      )
    } else {
      list(
        plot_data = NULL,
        vars_length = vars_length,
        equal_error = equal_error
      )
    }
  })
  
  # Display summary
  output$summary_knn <- renderPrint({
    equal_error = output_data_knn()$equal_error
    if( equal_error == TRUE)
    {
      print("No Summary available")
    }
    else
    {
      print(output_data_knn()$knn_model_cv)
    }

  })
  
  # Create scatter plot for KNN
  output$scatter_plot_knn <- renderPlot({
    plot_data <- output_data_knn()$plot_data
    vars_length <- output_data_knn()$vars_length
    knn_model <- output_data_knn()$knn_model_cv
    equal_error = output_data_knn()$equal_error
    if (vars_length > 0 && !equal_error) {
      plot(knn_model)
    } 
    else if( equal_error == TRUE)
    {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), xlab = "Independent Variable", ylab = "Dependent Variable", main = "Scatter plot with Regression Line")
      text(0.5, 0.5, "No plot generated. Dependent and Independent Variables are the same", cex = 1.2)
    }
    else 
    {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), xlab = "Independent Variable", ylab = "Dependent Variable", main = "Scatter plot with KNN Regression")
      text(0.5, 0.5, "No plot generated. Either too many dimensions or KNN model is NULL", cex = 1.2)
    }
  })
  
  # Display MAE for KNN
  output$MAE_knn <- renderText({
    equal_error = output_data_knn()$equal_error
    if( equal_error == TRUE)
    {
      "No MAE calculated"
    }
    else
    {
      mae_value <- round(output_data_knn()$MAE_KNN, 4)
      formatted_text <- paste("<span style='font-weight: bold; font-size: 16px;'>Mean Absolute Error for KNN is: ", mae_value, "</span>")
      formatted_text
    }
    
  })
  

    
  output$my_table_knn <- renderText({
    equal_error = output_data_knn()$equal_error
    if( equal_error == TRUE)
    {
      "No table available"
    }
    # Creating a sample data frame for demonstration
    else
    {# Creating a sample data frame for demonstration
      data <- data.frame(
        Predicted_Values = output_data_knn()$my_examples_pred,
        True_Values = output_data_knn()$my_examples_true
      )
      
      # Create a character vector with the specified format
      formatted_text <- sapply(1:nrow(data), function(i) {
        paste("<b>Example", i, "</b> - Actual Value:", data$True_Values[i], "; Predicted Value:", data$Predicted_Values[i], "<br>")
      }, USE.NAMES = FALSE)
      
      # Concatenate the formatted text
      paste(formatted_text, collapse = "")}
  })
}
