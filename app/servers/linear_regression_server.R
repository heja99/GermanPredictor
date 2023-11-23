# Define the server logic
server_module1 <- function(input, output, session) {
  
  # Reactive expression for selected dataframe
  selected_df <- reactive({
    dataframes_list_2[[input$dataframe_2]]
  })
  
  # Render dependent variable UI
  output$dependent_var_ui_2 <- renderUI({
    df <- selected_df()
    selectInput("dependent_var", "Choose the Dependent Variable", choices = colnames(df))
  })
  
  # Render independent variables UI
  output$independent_vars_ui_2 <- renderUI({
    df <- selected_df()
    checkboxGroupInput("independent_vars", "Choose the Independent Variables", choices = colnames(df))
  })
  
  # Perform linear regression and display summary & plot
  output_data <- reactive({

    req(input$dependent_var, input$independent_vars)
    df <- selected_df()
    dep_var <- input$dependent_var
    ind_vars <- input$independent_vars
    vars_length <- length(ind_vars)
    
    # Logic to catch error if dependent and independent variables are the same
    if(sum(dep_var == ind_vars) > 0) {
      equal_error = TRUE
    } else {
      equal_error = FALSE
    }
    # Logic to catch error if there is no independent variable
    if (vars_length > 0 && !equal_error) {
      # Filter out any missing values in the selected variables
      filtered_df <- df[complete.cases(df[, c(dep_var, ind_vars)]), ]
      train_ind <- createDataPartition(filtered_df[,1], p = .75, list = FALSE)
      training <- filtered_df[train_ind, ]
      testing <- filtered_df[-train_ind, ]
      
      # Create formula for linear regression
      formula <- as.formula(paste(dep_var, "~", paste(ind_vars, collapse = " + ")))
      
      # Perform linear regression
      lm_model <- lm(formula, data = training)
      predicitons <- predict(lm_model, newdata = testing)
      column_name <- dep_var
      vec <- c(1:3)
      my_examples_pred <- predicitons[vec]
      my_examples_true <- testing[vec, column_name]
      MAE <- predicitons - testing[, column_name]
      
      list(
        summary = capture.output(summary(lm_model)),
        plot_data = list(
          x = training[, ind_vars, drop = FALSE],
          y = training[, dep_var],
          lm_model = lm_model
        ),
        my_examples_pred = my_examples_pred,
        my_examples_true = my_examples_true,
        vars_length = vars_length,
        MAE_lin = (mean(abs(testing[, column_name] - predicitons))),
        indep_variables = ind_vars,
        depend_variable = dep_var,
        equal_error = equal_error
      )
      # if no independent variable is chosen
    } else {
      list(
        summary = "Choose exactly one independent variable for plotting.",
        plot_data = NULL,
        vars_length = vars_length,
        equal_error = equal_error
      )
    }
  })
  
  # Display summary
  output$summary <- renderPrint({
    equal_error = output_data()$equal_error
    if (equal_error == TRUE) {
      print("No Summary available")
    } else {
      cat(output_data()$summary, sep = "\n")
    }
  })
  
  # Create scatter plot with regression line
  output$scatter_plot <- renderPlot({
    plot_data <- output_data()$plot_data
    vars_length <- output_data()$vars_length
    equal_error = output_data()$equal_error
    
    if (vars_length == 1 && equal_error == FALSE) {
      plot(unlist(plot_data$x), plot_data$y, xlab = "Independent Variable", ylab = "Dependent Variable", main = "Scatter plot with Regression Line")
      abline(plot_data$lm_model, col = "red")
    } else if (equal_error == TRUE) {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), xlab = "Independent Variable", ylab = "Dependent Variable", main = "Scatter plot with Regression Line")
      text(0.5, 0.5, "No plot generated. Dependent and Independent Variables are the same", cex = 1.2)
    } else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), xlab = "Independent Variable", ylab = "Dependent Variable", main = "Scatter plot with Regression Line")
      text(0.5, 0.5, "No plot generated. Too many dimensions", cex = 1.2)
    }
  })
  
  # Display MAE
  output$MAE <- renderText({
    equal_error = output_data()$equal_error
    if (equal_error == TRUE) {
      "No MAE calculated"
    } else {
      mae_value <- round(output_data()$MAE_lin, 4)
      formatted_text <- paste("<span style='font-weight: bold; font-size: 16px;'>The Mean Absolute Error is: ", mae_value, "</span>")
      formatted_text
    }
  })
  
  # Display table
  output$my_table <- renderText({
    equal_error = output_data()$equal_error
    if (equal_error == TRUE) {
      "No table available"
    } else {
      data <- data.frame(
        Predicted_Values = output_data()$my_examples_pred,
        True_Values = output_data()$my_examples_true
      )
      
      # Create a character vector 
      formatted_text <- sapply(1:nrow(data), function(i) {
        paste("<b>Example", i, "</b> - Actual Value:", data$True_Values[i], "; Predicted Value:", data$Predicted_Values[i], "<br>")
      }, USE.NAMES = FALSE)
      
      # Concatenate the formatted text
      paste(formatted_text, collapse = "")
    }
  })
}
