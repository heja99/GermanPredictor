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
    
    if (vars_length > 0) {
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
        my_examples_true = my_examples_true
      )
    } else {
      list(
        plot_data = NULL,
        vars_length = vars_length
      )
    }
  })
  
  # Display summary
  output$summary_knn <- renderPrint({
    print(output_data_knn()$knn_model_cv)
  })
  
  # Create scatter plot for KNN
  output$scatter_plot_knn <- renderPlot({
    plot_data <- output_data_knn()$plot_data
    vars_length <- output_data_knn()$vars_length
    knn_model <- output_data_knn()$knn_model_cv
    if (vars_length > 0) {
      plot(knn_model)
    } 
    else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), xlab = "Independent Variable", ylab = "Dependent Variable", main = "Scatter plot with KNN Regression")
      text(0.5, 0.5, "No plot generated. Either too many dimensions or KNN model is NULL", cex = 1.2)
    }
  })
  
  # Display MAE for KNN
  output$MAE_knn <- renderPrint({
    print(paste0("Mean Absolute Error for KNN is: ", output_data_knn()$MAE_KNN))
  })
  
  output$my_table_knn <- renderTable({
    # Creating a sample data frame for demonstration
    data <- data.frame(
      Predicted_Values = output_data_knn()$my_examples_pred,
      True_Values = output_data_knn()$my_examples_true
    )
    data  # Returning the data frame to render as a table
  })
}
