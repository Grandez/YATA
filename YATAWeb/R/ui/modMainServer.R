initSimulation <- function() {
    gc()
    xlcFreeMemory()
    shinyjs::runjs("YATAMenu(0);")

    vars$clicks=1
    # vars = reactiveValues(
    #     lstData = NULL
    #     ,fila = 0
    #     ,clicks = 1
    #     ,numOpers = 0
    #     ,buy = 0
    #     ,sell = 0
    #     ,trading = NULL
    #     ,posicion=NULL
    #     ,estado=0 # 0 = Inactivo
    #     ,mode = case$config$mode
    #     ,dfd = case$data$dfd   # Datos
    #     ,dfi = case$data$dfi   # Datos con indicadores
    #     ,dfc = NULL   # Datos vistos
    #     ,dfp = NULL
    #     ,dft = NULL
    #     ,sessions=NULL
        
    #)
}    

advanceSimulation <- function(input, output, session) {
    res       = nextTicker(case, portfolio) 
    vars$fila = case$current
    
    if (vars$fila <= case$numTickers()) {
        vars$dfc  = case$getCurrentData()
        vars$dfp = portfolio$updatePosition(case$data$dfi[vars$fila,])    
    }
    else {
        vars$fila = vars$fila - 1
    }
    
    updateEstado(input, output, session)
    
    if (res == OP_EXECUTED) {
        vars$dft = portfolio$trading()
        vars$numOpers = vars$numOpers + 1
        if (case$oper$units > 0) vars$buy  = vars$buy + 1
        if (case$oper$units < 0) vars$sell = vars$sell + 1
        
    }    

    if (res != OP_PROPOSED) {
        shinyjs::show("btnStop")
        if (case$config$mode != MODE_MANUAL) {
           if (vars$fila <= case$numTickers()) {
               session$sendCustomMessage("handler1", vars$fila)
           }
           else {
              createSummary()
              shinyjs::hide("btnStop")
           }
        }    
    }    
    
    if (res == OP_PROPOSED) {
       showModal(dlgOper(input, output, session, case$oper)) 
    }
    res
}

nextCycle <- function(input, output, session, fila) {

    action = caso$model$calculateAction(portfolio, caso)
    
    if (action == 0) return(OP_NONE)
    caso$oper = caso$model$calculateOperation(portfolio, caso, action)
    if (is.null(caso$oper)) return(OP_NONE)
    
    if (caso$mode == MODE_AUTOMATIC) {
        vars$trading = cartera$flowTrade(caso$oper)
        if (caso$oper$units > 0) vars$buy  = vars$buy + 1
        if (caso$oper$units < 0) vars$sell = vars$sell + 1
        return (OP_EXECUTED)
    }    
    
    #    callModule(modDlgVerify, "dlgVerify")
    shinyjs::addClass("lblOperCapital", "shiny-bound-input")
    shinyjs::removeClass("lblOperCapital", "shiny-bound-output")
    output$lblOperCapital = renderText("0")

    showModal(dlgOper(input, output, session, caso$oper)) 
    OP_PROPOSED
}

updateEstado <- function(input, output, session) {
    output$lblPosFiat   = renderText({portfolio$getActive(CURRENCY)$position})
    output$lblPosMoneda = renderText({portfolio$getActive()$position})
    output$lblPosTotal  = renderText({portfolio$balance()})
    
    output$lblResMov  = renderText(vars$fila)
    output$lblResOper = renderText(vars$numOpers)
    output$lblResC    = renderText(vars$buy)
    output$lblResV    = renderText(vars$sell)
}    


#modMain <- function(input, output, session, action) {
#    browser()
    shinyjs::hide("btnStop")
    
    #Sys.sleep(1)
    #    shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
    # Hide the loading message when the rest of the server function has executed
    #    loading(FALSE)
    
    ################################################################################
    # Dialogo de validar operacion
    ################################################################################

    vars$clicks = 0
    vars$pos = portfolio$position()    
    observeEvent(input$btnOperESC, { removeModal()
                                     advanceSimulation(input, output, session) })
    observeEvent(input$btnOperOK,  {
        #op2 = Operation$new(input$)
        removeModal()
        portfolio$flowTrade(caso$oper)
        vars$opers = vars$oper + 1
        if (caso$oper$units > 0) vars$buy  = vars$buy  + 1
        if (caso$oper$units < 0) vars$sell = vars$sell + 1
        vars$dft = portfolio$trading()
        advanceSimulation(input, output, session)
    })
    

    ################################################################################
    # Observers para la simulacion
    ################################################################################
    
    
    observeEvent(input$btnSimulate, { vars$clicks = vars$clicks + 1
                                      vars$estado = switch(vars$estado + 1, 1,2,1) 
                                      updateActionButton(session, "btnSimulate", label=changeButtonLabel(vars$estado))
                                      if (vars$estado == 1) advanceSimulation(input, output, session)
                                    }
    )
    observeEvent(input$btnSave,     { saveSession(input, output, session)})
    observeEvent(input$btnNext,     { if (vars$estado == 1) advanceSimulation(input, output, session)})
    observeEvent(input$btnStop,     { shinyjs::hide("btnStop")
                                      vars$estado = 0
                                      vars$fila = 0
                                      updateActionButton(session, "btnSimulate", label=changeButtonLabel(0))
                                    })
    
    # trigger <- reactivePoll(1000, session, checkFunc=function() {vars$fila}, valueFunc=function() {caso$dfi})
    tblOptions = list(searching = FALSE, rownames = F)
    #output$tblData = DT::renderDataTable({ caso$dfi[1:vars$fila,]},options = lstOptions)

    
    output$tblBodyData  = DT::renderDataTable({.prepareDTTickers(vars$dfc)})
    output$tblBodyPos   = DT::renderDataTable({prepareTable(.makeDT(vars$dfp),        c("EUR", "Moneda", "Balance"))}) 
    output$tblBodyTrade = DT::renderDataTable({.prepareDTTrade(vars$dft)}) 

    output$plotMain <- renderPlotly({

        vars$dfi = case$data$dfi
        vars$clicks
        if (vars$clicks == 0) return(NULL)
        if (is.null(vars$dfi)) return(NULL)
        
        df = vars$dfi
        df$date = as.POSIXct(df$date)
        p1 = basePlot1(df) + theme(legend.position="none")
        p2 = basePlot2(df) + theme(legend.position="none")
        
        p1 = p1 + geom_vline(xintercept=df[vars$fila, "date"], color="red")

        p1$elementId = NULL
        p2$elementId = NULL
        
        plots = case$model$plotIndicatorsPrimary(list(p1,p2))
        plots = case$model$plotIndicatorsSecundary(plots)
        plots = case$model$plotIndicatorsTerciary(plots)

        
        # pp= grid.arrange(plots[1][[1]],plots[2][[1]],heights=c(6,4))
        # p1
        #t0 = basicTheme()
        
        #ggplot(vars$dfi,aes(x=date, y=price)) + geom_line()
        #p1
        subplot(plots[1][[1]],plots[2][[1]],nrows=2, shareX=T)
        #ggplotly(p1)
    })
    
#}
    
    makeDTTrading = function(data) {
        if (is.null(data)) return(NULL)

        row.names(data) = data[,1]
        datatable(data[,-1], callback = 
                  JS("createdRow(row, data, dataIndex) { $(row).addClass((data['uds'] < 0 ? 'tradingSell' : 'tradingBuy'))}")
        )
    }
    prepareTable = function(data, numbers) {
        if (is.null(data)) return(NULL)
        data %>% formatRound(numbers, digits = 2) 
            #formatRound('v0',     digits = 1) 
        
    }
    
    changeButtonLabel = function(estado) {
        if (case$config$mode != MODE_MANUAL) {
            return (switch(estado + 1, "Simulate", "Pause", "Continue"))
        }
        return("Next")
    }
    .prepareDTTickers = function(data) {
        dt = .makeDT(data)
        if (is.null(dt)) return(NULL)
        dt %>% prepareTable(c(DFI_PRICE, "v0"))
    }    
    
    .prepareDTTrade = function(data) {
        dt = .makeDT(data)
        if (is.null(dt)) return(NULL)
        dt %>% prepareTable(c("uds", "price", "total","pmm","position")) %>%
                 formatStyle('uds', target='row', backgroundColor = styleInterval(0, c('red', 'green')))
    }
    .makeDT = function(data) {
        if (is.null(data)) return(NULL)
        row.names(data) = data[,1]
        datatable(data[,-1])
    }
    