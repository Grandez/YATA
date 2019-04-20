modDlgVerify <- function(input, output, session) {
    
    # Dialogo de validar operacion
    observeEvent(input$btnOperESC, { removeModal()
        advanceSimulation(input, output, session) })
    observeEvent(input$btnOperOK,  {
        #op2 = Operation$new(input$)
        removeModal()
        cartera$flowTrade(caso$oper)
    })
    
}

