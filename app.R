library(shiny)
source("mod_numeric_input.R")

ui <- fluidPage(
  useShinyFeedback(),
  h4("Scenario A (Allowed: ≥ 0)"),
  mod_numeric_input_ui("numA", label = "Enter a number (≥ 0)", min = 0),
  h4("Scenario B (Allowed: ≥ 1)"),
  mod_numeric_input_ui("numB", label = "Enter a number (≥ 1)", min = 1)
)

server <- function(input, output, session) {
  mod_numeric_input_server("numA", scenario = "ge0")
  mod_numeric_input_server("numB", scenario = "ge1")
}

shinyApp(ui, server)