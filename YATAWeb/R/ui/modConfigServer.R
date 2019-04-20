#modConfig <- function(input, output, session, action) {
    
    updateSelectInput(session, "moneda",  choices=cboMonedas_load(), selected=NULL)
    updateSelectInput(session, "modelos", choices=cboModelos_load(), selected=NULL)
    
    observeEvent(input$modelos, { case$model = loadModel(input$modelos)}, ignoreNULL=F, ignoreInit = T)    
    observeEvent(input$moneda,  { browser(); dfa       = loadData(input$moneda)
                                  case$data = YATAData$new()
                                  case$data$symbol = input$moneda
                                  case$data$dfa    = dfa
                                  rng = c(as.Date(dfa[1,"Date"]), as.Date(dfa[nrow(dfa),"Date"]))    
                                  updateDateInput(session, "dtFrom", min=rng[1], max=rng[2], value=rng[1])
                                  updateDateInput(session, "dtTo",   min=rng[1], max=rng[2], value=rng[2])
                                }, ignoreNULL=F, ignoreInit = T)
    
    observeEvent(input$dtFrom,  { vars$dfd = case$data$filterData(input$dtFrom, input$dtTo)}, ignoreNULL=F, ignoreInit = T)
    observeEvent(input$dtTo,    { vars$dfd = case$data$filterData(input$dtFrom, input$dtTo)}, ignoreNULL=F, ignoreInit = T)
    observeEvent(input$btnLoad, { orden = rep(1:nrow(vars$dfd))
                                  vars$dfd = cbind(orden, vars$dfd)
                                  btnLoad_click(input, output, session)
                                  initSimulation()
                                }
                 )
    
    output$plotConfig <- renderPlotly({
        
        if (is.null(vars$dfd)) return (NULL)
        
        p <- plot_ly(vars$dfd, x = ~Date, y = ~Close, type = 'scatter', mode = 'lines')
        #p <- plot_ly(vars$dfd, x = ~Date, open = ~Open, close = ~Close, high = ~High, low = ~Low, type="candlestick")
        p$elementId <- NULL # Evitar aviso del widget ID
        p
    })


