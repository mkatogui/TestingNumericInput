library(shiny)
library(shinyFeedback)
library(shinyjs)

ui <- fluidPage(
  useShinyFeedback(),
  useShinyjs(),
  actionButton("show_modal", "Mostrar modal")
)

server <- function(input, output, session) {
  
  observeEvent(input$show_modal, {
    showModal(
      modalDialog(
        title = "Ingrese un valor numérico",
        numericInput("num_input", "Valor positivo:", value = NULL, min = 0),
        footer = tagList(
          modalButton("Cancelar"),
          actionButton("submit_btn", "Aceptar", class = "btn-primary")
        )
      )
    )
    disable("submit_btn")  # Desactiva al abrir el modal
  })
  
  observe({
    num <- input$num_input
    
    is_valid <- !is.null(num) && !is.na(num) && num >= 0
    
    feedbackDanger(
      inputId = "num_input",
      show = !is_valid,
      text = "Por favor, ingrese un número no negativo."
    )
    
    if (is_valid) {
      enable("submit_btn")
    } else {
      disable("submit_btn")
    }
  })
  
  observeEvent(input$submit_btn, {
    removeModal()
    showNotification(paste("Valor ingresado:", input$num_input), type = "message")
  })
}

shinyApp(ui, server)
