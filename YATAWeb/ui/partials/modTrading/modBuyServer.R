modBuy <- function(input, output, session, id) {
  useShinyjs()
  vars <- reactiveValues( 
     loaded = F
    ,opers = YATAOperation$new()
  )
  
  #######################################################################
  # Private Code
  #######################################################################
  
  loadPage = function() {
    updateSelectInput(session, "cboCamera", choices=comboClearings(FALSE))
    updateSelectInput(session, "cboCTC",    choices=comboCurrencies())
  } 
  
  validateForm = function() {
    NULL
  }
  
  cleanForm = function() {
  }
  
  #######################################################################
  # Server Code
  #######################################################################

  if (!vars$loaded) loadPage()
  
  observeEvent(input$cboCamera, {
      if (nchar(input$cboCamera) == 0) return (NULL)
      updateSelectInput(session, "cboBase", choices=comboBases(input$cboCamera))
  })
  
  observeEvent(input$btnOK,     {
    msg = validateForm()
    if (!is.null(msg)) {
      output$lblStatus <- renderText(paste("<span class='msgErr'>", msg, "</span>"))
      return (NULL)
    }
    browser()
    idOper = vars$opers$add(10, input$cboCamera, input$cboBase, input$cboCTC, input$impAmount
                              ,  input$impProposal,  input$impLimit,    input$impStop)  
    output$lblStatus = renderText(paste("<span class='msgOK'>", getMessage("OK.OPER", idOper), "</span>"))
  })
  
  
}