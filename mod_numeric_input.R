# mod_numeric_input.R
library(shinyFeedback)


# UI module for numeric input with parameters and exclusion options
mod_numeric_input_ui <- function(id, label = "Enter a number", min = -Inf, help_text = NULL) {
  ns <- NS(id)
  tagList(
    useShinyFeedback(),
    numericInput(ns("num"), label, value = min, min = min),
    if (!is.null(help_text)) helpText(help_text),
    textOutput(ns("result"))
  )
}

# Helper function for validation with exclusion options
is_invalid_num <- function(x, exclude_zero = FALSE, exclude_negative = FALSE) {
  is.null(x) || is.na(x) || is.infinite(x) || is.nan(x) ||
    (exclude_zero && x == 0) || (exclude_negative && x < 0)
}

# Server module with exclusion options
mod_numeric_input_server <- function(id, scenario) {
  moduleServer(id, function(input, output, session) {
    observe({
      # Defensive checks before numeric comparison
      if (is.null(input$num) || is.na(input$num) || is.infinite(input$num) || is.nan(input$num)) {
        invalid <- TRUE
      } else if (scenario == "ge0" && input$num < 0) {
        invalid <- TRUE
      } else if (scenario == "ge1" && input$num < 1) {
        invalid <- TRUE
      } else {
        invalid <- FALSE
      }
      msg <- NULL
      if (invalid) {
        if (scenario == "ge0" && !is.null(input$num) && !is.na(input$num) && input$num < 0) {
          msg <- "Negative numbers are not allowed. Value must be ≥ 0"
        } else if (scenario == "ge1" && !is.null(input$num) && !is.na(input$num) && input$num < 1) {
          msg <- "Value must be ≥ 1"
        } else if (scenario == "ge0") {
          msg <- "Value must be ≥ 0"
        } else if (scenario == "ge1") {
          msg <- "Value must be ≥ 1"
        } else {
          msg <- "Invalid value"
        }
      }
      feedbackDanger(
        inputId = "num",
        show = invalid,
        text = msg
      )
    })
    output$result <- renderText({
      # Defensive checks before numeric comparison
      valid <- TRUE
      if (is.null(input$num) || is.na(input$num) || is.infinite(input$num) || is.nan(input$num)) {
        valid <- FALSE
      } else if (scenario == "ge0" && input$num < 0) {
        valid <- FALSE
      } else if (scenario == "ge1" && input$num < 1) {
        valid <- FALSE
      }
      validate(
        need(valid, if (scenario == "ge0") "Value must be ≥ 0" else "Value must be ≥ 1")
      )
      paste("You entered:", input$num)
    })
  })
}
