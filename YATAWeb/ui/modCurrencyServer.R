
modCurrency <- function(input, output, session, symbol) {
    plotTypes   = c(PLOT_LINEAR, PLOT_LOG, PLOT_BAR, PLOT_CANDLE)
    plotSources = c("Price", "Volume", "Variation", NA)
    vars <- reactiveValues( loaded = F
                            ,nDays = 60
    )
    print("Entra en el modulo")

    makeTableSession = function(df) {
        # Remove auxiliar column: PRICE
        p=which(colnames(df) == "Price")
        if (length(p) > 0) tmp = df[,-p[1]]
        
        tblHead = .makeHead(df)
        
        dt = datatable(df, container = tblHead, rownames = FALSE)
        dt = .formatColumns(df, dt)
        
        dt
    }    
    
    renderTableData = function() {
        dt = makeTableSession(vars$tickers$reverse())
        output$tblCTC  = DT::renderDataTable({ dt })
    }
    renderTablePos = function() {
        df = data.frame(CTC=symbol, Position=3000, PM1=3000, PM2=3000)
        output$tblPos  = DT::renderDataTable({ as.data.table(df) })
    }
    
    renderPlot = function() {
        
        tmp = TBLSession$new(symbol, TBL_DAY, YATAENV$currency)
        tmp$filterByRows(vars$nDays * -1)
        vars$tickers = tmp
        sources = c( plotSources[as.integer(input$swPlt1S)]
                     ,plotSources[as.integer(input$swPlt2S)]
                     ,plotSources[as.integer(input$swPlt3S)])
        types   = c(  plotTypes[as.integer(input$swPlt1T)]
                      ,plotTypes[as.integer(input$swPlt2T)]
                      ,plotTypes[as.integer(input$swPlt3T)])
        
        output$plotCTC = renderPlotly({renderPlotSession(vars$tickers, sources, types)})
    }
    
    observeEvent(input$btnConfig, { print("Parate")})
    observeEvent(input$btnPlots, { renderPlot() })
    

    if (!vars$loaded) {
        vars$loaded = T
        renderPlot()
        renderTableData()
        renderTablePos()
    }
    
    
}    