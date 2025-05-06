library(shiny)
source("mod_numeric_input.R")

ui <- fluidPage(
  useShinyFeedback(),
  h4("Scenario A (Allowed: ≥ 0)"),
  mod_numeric_input_ui("numA", label = "Enter a number (≥ 0)", min = 0),
  h4("Scenario B (Allowed: ≥ 1)"),
  mod_numeric_input_ui("numB", label = "Enter a number (≥ 1)", min = 1),
  actionButton("show_modal", "Open Modal")
)

server <- function(input, output, session) {
  mod_numeric_input_server("numA", scenario = "ge0")
  mod_numeric_input_server("numB", scenario = "ge1")

  observeEvent(input$show_modal, {
    showModal(
      modalDialog(
        mod_numeric_input_ui("modal_num", label = "Enter a number (Modal)", min = 0),
        footer = modalButton("Close")
      )
    )
    mod_numeric_input_server("modal_num", scenario = "ge0")
  })
}

shinyApp(ui, server)