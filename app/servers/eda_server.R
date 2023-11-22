# servers/eda_server.R

# Define the server logic
 server_module3 <- function(input, output, session) {
  # Reactive expression for selected dataframe
  selected_df <- reactive({
    dataframes_list[[input$dataframe]]
  })

  # Display the entire dataset in the table
  output$table <- renderDT({
    df_head <- selected_df()
    datatable(df_head, options = list(lengthMenu = c(5, 10, 15), pageLength = 5))
  })

  # Create correlation heatmap
  output$correlation_heatmap <- renderPlot({
    df <- selected_df()

    # Exclude non-numeric columns
    numeric_cols <- sapply(df, is.numeric)
    df_numeric <- df[, numeric_cols]

    # Check if there are at least two numeric columns and enough non-missing rows for correlation
    if (sum(numeric_cols) >= 2 && sum(complete.cases(df_numeric)) >= 2) {
      correlations <- cor(df_numeric, use = "complete.obs")
      corrplot(correlations, method = "color", type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)
    } else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), main = "Correlation Heatmap", xlab = "", ylab = "")
      text(0.5, 0.5, "Not enough numeric columns or rows for correlation", cex = 1.2)
    }
  })

  # Display histogram
  output$histogram <- renderPlot({
    df <- selected_df()
    numeric_var <- input$numeric_var
    
    # Check if a numerical variable is selected and the data is non-NULL
    if (!is.null(df[[numeric_var]]) && is.numeric(df[[numeric_var]])) {
      graphics::hist(df[[numeric_var]], main = paste("Histogram of", numeric_var), xlab = numeric_var, col = "skyblue", border = "black")
    } else {
      # If the data is NULL or not numeric, display a message or a default plot
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), main = "Histogram", xlab = "", ylab = "")
      text(0.5, 0.5, "Invalid data for histogram", cex = 1.2)
    }
  })
  

  # Update the choices for the numeric variable dropdown based on the selected dataframe
  observe({
    df <- selected_df()
    numeric_cols <- names(df)[sapply(df, is.numeric)]
    default_var <- ifelse(length(numeric_cols) > 0, numeric_cols[1], "")

    updateSelectInput(session, "numeric_var", choices = numeric_cols, selected = default_var)
  })
}
