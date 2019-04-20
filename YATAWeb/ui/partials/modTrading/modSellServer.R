modSell <- function(input, output, session, id, type) {
  useShinyjs()
  vars <- reactiveValues( 
    loaded = F
  )
  
  #######################################################################
  # Private Code
  #######################################################################
  
  loadPage = function() {
    browser()
    updateSelectInput(session, "cboCamera", choices=comboClearings(FALSE))
    updateSelectInput(session, "cboCamera", choices=comboClearings(FALSE))
  } 
  
  #######################################################################
  # Server Code
  #######################################################################

  if (!vars$loaded) loadPage()
  
  observeEvent(input$cboCamera, {
    browser()
      if (nchar(input$cboCamera) == 0) return (NULL)
      updateSelectInput(session, "cboBase", choices=comboBases(input$cboCamera))
  })
  
  
  
}