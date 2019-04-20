modXFer <- function(input, output, session, id) {
  ns <- session$ns    
  useShinyjs()
  vars <- reactiveValues( 
    loaded = F
    ,opers = YATAOperation$new()
  )

  #######################################################################
  # Private Code
  #######################################################################
  
  loadSources = function(cash=TRUE) {
    choices = comboClearings(TRUE)
    updateSelectInput(session, "cboFrom", choices=choices)
    updateSelectInput(session, "cboTo"  , choices=choices)
  } 
  
  validateForm = function() {
    res = FALSE
    if (input$cboFrom == input$cboTo) return (getMessage("SAME.CLEARING"))
    if (input$txtAmount <= 0)         return (getMessage("INVALID.AMOUNT"))
    NULL
  }
  
  cleanForm = function() {
    updateNumericInput(session, "txtAmount", value=0)

  }
  
  #######################################################################
  # Server Code
  #######################################################################
  
  if (!vars$loaded) {
    loadSources()
    vars$loaded = T
  }   
  observeEvent(input$cboFrom,     {
    vars$source = input$cboFrom
    loadCboCurrency()
  })
  observeEvent(input$cboCurrencies,  {
    vars$ctc = input$cboCurrencies
    loadSaldo()
  })
  observeEvent(input$btnCancel, {  
    cleanFormXfer() 
  })
  observeEvent(input$btnOK,     {
     msg = validateForm()
     if (!is.null(msg)) {
         output$lblStatus <- renderText(paste("<span class='msgErr'>", msg, "</span>"))
         return (NULL)
     }
     vars$opers$transfer(input$cboXferFrom, input$cboXferTo, input$cboXferCurrencies, input$txtXferAmount)
     output$lblStatus = renderText(paste("<span class='msgOK'>", getMessage("OK.OPER"), "</span>"))
  })
}  