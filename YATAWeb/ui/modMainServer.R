vars <- reactiveValues(lstData = NULL
                       ,fila = 1
                       ,clicks = 0
                       ,numOpers = 0
                       ,buy = 0
                       ,sell = 0
                       ,trading = NULL
                       ,posicion=NULL
                       ,estado=0 # 0 = Inactivo
                       ,mode = 0
                       ,dfd = NULL   # Datos
                       ,dfi = NULL   # Datos con indicadores
                       ,dfc = NULL   # Datos vistos
                       ,dfp = NULL
                       ,dft = NULL
                       ,sessions=NULL
)

# layoutTickers = TBLTickers$new("Tickers")

advanceSimulation <- function(input, output, session) {
    res       = nextTicker(case, portfolio)
    vars$fila = case$current

    if (case$current > case$getNumTickers()) {
        vars$fila = vars$fila - 1
        vars$estado = 0
        return (OP_EXECUTED)
    }    

    vars$dfc = case$getCurrentData(asClass=T)$df
    vars$dfp = portfolio$updatePosition(case)$df

    updateEstado(input, output, session)

    if (res == OP_EXECUTED) {
        vars$dft = portfolio$getTrading()$df
        vars$numOpers = vars$numOpers + 1
        if (case$oper$units > 0) vars$buy  = vars$buy + 1
        if (case$oper$units < 0) vars$sell = vars$sell + 1

    }

    if (res != OP_PROPOSED) {
        #shinyjs::show("btnStop")
        if (case$config$mode != MODE_MANUAL) {
           if (vars$fila <= case$getNumTickers()) {
               session$sendCustomMessage("handler1", vars$fila)
           }
           else {
              #createSummary()
         #     shinyjs::hide("btnStop")
           }
        }
    }

    if (res == OP_PROPOSED) {
       showModal(dlgOper(input, output, session, case$oper))
    }
    Sys.sleep(case$config$delay)
    res
}
nextCycle         <- function(input, output, session, fila) {

    action = caso$model$calculateAction(portfolio, caso)
    
    if (action[1] == 0) return(OP_NONE)
    
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
updateEstado      <- function(input, output, session) {
    # Update page
    output$lblMoneda    = renderText(portfolio$getActive()$name)
    output$lblPosFiat   = renderText(format(portfolio$getActive(CURRENCY)$position, nsmall=0))
    output$lblPosMoneda = renderText(format(portfolio$getActive()$position, nsmall=6))
    output$lblPosTotal  = renderText(format(portfolio$getBalance(), nsmall=0))
    output$lblPosDate   = renderText(format(case$tickers$df[vars$fila,case$tickers$DATE], "%d/%m/%Y"))
    output$lblResMov    = renderText(case$current)
    output$lblTrend     = renderText(case$trend * (nrow(case$tickers$df)))
    
    res = 0
    if(case$config$initial != 0) res = ((portfolio$getBalance() / case$config$initial) - 1) * 100
    output$lblEstado  = renderText(sprintf("%.2f%%", res))
    .updateHTMLEstado(res)

    output$lblResOper = renderText(vars$numOpers)
    output$lblResC    = renderText(vars$buy)
    output$lblResV    = renderText(vars$sell)
}        

modMain           <- function(input, output, session, parent, changed) {

    #J updateEstado(input, output, session)    
    #J session$sendCustomMessage("hndlButtons", paste(case$config$mode, vars$estado, sep=","))
    #J 
    #J plots = case$model$getIndicatorsName()
    #J updateCheckboxGroupInput(session, "chkPlots1", choices=plots, selected=plots)
    #J 
    #J output$lblResInicio = renderText({case$config$initial})

    ################################################################################
    # Dialogo de validar operacion
    ################################################################################

    vars$clicks = 0
    ## vars$pos = portfolio$getPosition()    
    observeEvent(input$btnOperESC, { removeModal(); advanceSimulation(input, output, session) })
    observeEvent(input$btnOperOK,  {
        removeModal()
        portfolio$flowTrade(caso$oper)
        vars$opers = vars$oper + 1
        if (caso$oper$units > 0) vars$buy  = vars$buy  + 1
        if (caso$oper$units < 0) vars$sell = vars$sell + 1
        vars$dft = portfolio$trading()$df
        advanceSimulation(input, output, session)
    })
    
    ################################################################################
    # Observers para la simulacion
    ################################################################################
    
    observeEvent(input$btnSimulate, { vars$clicks = vars$clicks + 1
                                      vars$estado = switch(vars$estado + 1, 1,2,1) 
                                      session$sendCustomMessage("hndlButtons", paste(case$config$mode, vars$estado, sep=","))
                                      if (vars$estado == 1) advanceSimulation(input, output, session)
                                    }
    )
    observeEvent(input$btnSave,     { saveSession(input, output, session)})
    observeEvent(input$btnNext,     { if (vars$estado == 1) advanceSimulation(input, output, session)})
    observeEvent(input$btnStop,     { shinyjs::toggle("btnStop")
                                      vars$estado = 0
                                      vars$fila = 0
                                      session$sendCustomMessage("hndlButtons", paste(case$config$mode, vars$estado, sep=","))
                                    })
    
    observeEvent(vars$dfc, { 
                 output$tblBodyData  = DT::renderDataTable({.prepareTable(vars$dfc, case$getCurrentData(asClass=T)) })
                 output$tblBodyPos   = DT::renderDataTable({.prepareTable(vars$dfp, portfolio$getPositionHistory()) })
                 output$tblBodyTrade = DT::renderDataTable({.prepareTableTrading(vars$dft, portfolio$getTrading())  }) 
                })
    # trigger <- reactivePoll(1000, session, checkFunc=function() {vars$fila}, valueFunc=function() {caso$dfi})
    tblOptions = list(searching = FALSE, rownames = F)
    #output$tblData = DT::renderDataTable({ caso$dfi[1:vars$fila,]},options = lstOptions)

    
    # output$tblBodyData  = DT::renderDataTable({.prepareTable(vars$dfc, case$getCurrentData(asClass=T)) })
    # output$tblBodyPos   = DT::renderDataTable({browser(); .prepareTable(vars$dfp, portfolio$getPositionHistory()) })
    # output$tblBodyTrade = DT::renderDataTable({browser(); .prepareTable(vars$dft, portfolio$getTrading())         }) 

    output$plotMain <- renderPlotly({ 
       df = case$tickers$df
       plots = plotData(vars$clicks, case$tickers, case$model, T, input$chkPlots1) 
       if (is.null(plots)) return (NULL)
       
       shapes = list()
       shapes = list.append( shapes
                            ,vline(as.Date(df[vars$fila, DF_DATE]))
    #                       ,zone(vars$df[vars$fila, "Date"], df[nrow(df),"Date"])
                           )

       trading = portfolio$getTrading()
       if (!is.null(trading$df)) {
           for (idx in 1:nrow(trading$df)) {
               colour=ifelse(trading$df[idx,trading$TYPE] == OP_BUY, "green", "red")
               shapes = list.append(shapes, vline(as.Date(trading$df[idx,DF_DATE]),color=colour))
           }
       }
       plots[[1]] = plots[[1]] %>% layout(xaxis = axis, shapes=shapes)
       plots[[2]] = plots[[2]] %>% layout(shapes=shapes)
       
        sp = subplot(hide_legend(plots[[1]]), hide_legend(plots[[2]]), nrows = 2, shareX=T, heights=c(0.75,0.25))
        sp$elementId = NULL
        sp
  })
    
    # output$plotMain <- renderPlotly({
    #     vars$df = case$data$getData()
    #     # vars$clicksn
    #     
    #     # if (vars$clicks == 0) return(NULL)
    #     if (is.null(vars$df)) return(NULL)
    #     
    #     p1 <- plot_ly(vars$df, x = ~Date, y = ~Price,  type = 'scatter', mode = 'lines')
    #     p1$elementId = NULL
    # 
    #     p2 <- plot_ly(vars$df, x = ~Date, y = ~Volume, type = 'bar')
    #     p2$elementId = NULL
    # 
    #     plots = list(p1, p2)
    #     
    #     plots = case$model$plotIndicators  (plots, case$data, input$chkPlots1)
    # 
    #     shapes = list()
    #     shapes = list.append( shapes
    #                          ,vline(vars$df[vars$fila, "Date"])
    #     #                     ,zone(vars$df[vars$fila, "Date"], df[nrow(df),"Date"])
    #                          )
    #     
    #     plots[[1]] = plots[[1]] %>% layout(xaxis = axis, shapes=shapes)
    #     plots[[2]] = plots[[2]] %>% layout(shapes=shapes)
    #     
    #     sp = subplot(hide_legend(plots[[1]]), hide_legend(plots[[2]]), nrows = 2, shareX=T, heights=c(0.75,0.25))
    #     sp$elementId = NULL
    #     sp
    # })
    
}
    
    
    changeButtonLabel = function(estado) {
        if (case$config$mode != MODE_MANUAL) {
            return (switch(estado + 1, "Simulate", "Pause", "Continue"))
        }
        return("Next")
    }
# .prepareTableTrading = function(df, data) {
#     df = data$df
#     if (is.null(df)) return(NULL)
# 
#     # Prepara datos
#     df[,DF_DATE] = as.Date(df[,DF_DATE])
#     
#     dt = datatable( df[,-c(1,2)]
#                    # ,callback = JS("createdRow(  row, data, dataIndex) { 
#                    #                              $(row).addClass((data['Uds'] < 0 ? 'tradingSell' : 'tradingBuy'))
#                    #                            }")
#                    )
#     
#     dt = dt %>% formatRound(data$getDecimals(), digits = case$config$dec)
#     dt = dt %>% formatRound(data$getCoins(),    digits = 0) 
#     dt
# }
.updateHTMLEstado = function(res)  {
    if (res == 0) {
        jqui_remove_class("sim-lblEstado", c("rojo","verde"))
        # jqui_hide("#sim-resDown","blind")
        # jqui_hide("#sim-resUp","blind")
        return()
    }
    
    if (res > 0) {
        jqui_switch_class('#sim-lblEstado', "rojo", "verde")
        # jqui_hide ("#sim-resDown","blind")
        # jqui_show ("#sim-resUp","blind")
        return()
    }
    jqui_switch_class('#sim-lblEstado', "verde", "rojo")
    # jqui_hide("#sim-resUp","blind")
    # jqui_show("#sim-resDown","blind")

}
