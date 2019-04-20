modOpen <- function(input, output, session, id) {
  useShinyjs()
  vars <- reactiveValues( 
    loaded = F
    ,oper = NULL
  )

  myModal <- function(session) {
    ns <- session$ns
    modalDialog(
      textInput(ns("modalTextInput"), "Show Me What You Got!", "Get Schwifty!"),
      actionButton(ns("closeModalBtn"), "Close Modal")
    )
  }  
  #######################################################################
  # Private Code
  #######################################################################

  renderTable = function() {
    op = vars$oper
    df = op$getOpenPending()
    
    df2 = df[,c(op$CLEARING, op$BASE, op$COUNTER, op$AMOUNT, op$IN_PROPOSAL, op$TMS_LAST)]
    output$tblOpen     = DT::renderDataTable({ DTPrepare(df2) })
  }
  #######################################################################
  # Server Code
  #######################################################################
  
  if (!vars$loaded) {
    vars$oper = TBLOperation$new()
    renderTable()
    vars$loaded = T
  }
  
  observeEvent(input$tblOpen_rows_selected, {
    # showModal(myModal(session))
    showModal(modalDialog(
      title = "Important message",
      "This is an important message!",
      easyClose = TRUE
    ))
  })
  
  observeEvent(input$tblButton, {
    browser()
  })
}