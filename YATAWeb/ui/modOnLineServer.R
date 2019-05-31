
modOnLine <- function(input, output, session) {

    shinyjs::runjs(paste0("YATAPanels('", session$ns(""), "')"))
    sources = c("Last"=1, "Ask"=2, "Bid"=3, "High"=4, "Low"=5, "Volume"=6)
    type    = c("Value"=1, "Last Change"=2, "Session Change"=3, "Day Change"=4)
    vars <- reactiveValues(loaded = F
        ,active   = T   # Is in mode auto update?
        ,interval = 1 # autoupdate in minutes
        ,count    = 0 # Count of minutes
        ,points   = 0
        ,field    = "LAST" 
        ,plot     = 1
        ,tickers  = NULL  # R6YATATickers
        ,dfPlot   = NULL  # Dataframe for plot
        ,bases    = NULL
        ,dfPlot   = NULL  # data for plot by tab
        ,dfTables = NULL
        # Items to show in plot by tab
        ,tab      = NULL
        ,varField = "CLOSE"   # Campo para mostrar mejores/peores
        ,varRows  = 5     # Filas a mostrar
        ,varPrc   = 5     # Porcentaje para highlight
        
        ,baseInfo     = list()
    )
    
    ########################################################################################
    ### PRIVATE CODE 
    ########################################################################################
    
    loader         <- function() {
        vars$tickers = YATATickers$new()
        if (vars$tickers$inError) return(NULL)
        bases = vars$tickers$getBases()
        
        updateMenuTab(session, "olMenu", choices=bases)
        vars$interval = input$mins
        
        # count = 1
        # for (base in bases) {
        #     sel = ifelse (count == 1, TRUE, FALSE)
        #     count = count + 1
        #     appendTab(inputId = "tabs", 
        #               tabPanel(base,id=base,value=base
        #                       #,fluidRow(plotlyOutput(paste0(session$ns(""), "plot",base), width="98%",height="500px"))   
        #                       # ,fluidRow( column(width=6, DT::dataTableOutput(paste0(session$ns(""), "tbl",base)))
        #                       #           ,column(width=3, DT::dataTableOutput(paste0(session$ns(""), "tbl",base, "up")))
        #                       #           ,column(width=3, DT::dataTableOutput(paste0(session$ns(""), "tbl",base, "down")))
        #                       #           )
        #               ), select = sel)
        # }
        output$lblMins   = renderText(vars$count)
        vars$loaded = T
    }
    filterColumns  <- function(df, info) {
        df = df %>% filter(COUNTER %in% info$selected)
        if (!info$showBTC) df = df %>% filter(COUNTER != "BTC")
        if (is.null(info$rangeValue)) {
           info$rangeValue = c(min(df[,vars$tickers$LAST]), max(df[,vars$tickers$LAST]))   
        }
        #JGG Pendiente
        #df = df %>% dplyr::filter(between(Last, info$rangeValue[1], info$rangeValue[2]))
        df
    }
    renderPlot     <- function() {
        p <- plot_ly(source=vars$dfPlot) %>% layout (legend = list(orientation = 'h', xanchor="center", x=0.5))
        cols = colnames(vars$dfPlot)
        for (ctc in cols[-1]) {  # First col is TMS
            p = YATACore::plotMarker (p, vars$dfPlot[,1], vars$dfPlot[,ctc],  hoverText=ctc)    
        }
        p = p %>% layout(margin = list(l=50, r=0, b=5, t=5, pad=0))
        p = YATACore::plotToolbar(p)

        output$plot = renderPlotly({p})
    }
    prepareData    <- function() {
        vars$tickers$setBase(vars$tab)
        
        tickers = vars$tickers
        info    = vars$baseInfo[[vars$tab]]    
        
        if (is.null(info)) info = createInfo(vars$tab)
        
        df = getDataFrame(tickers)
        df = filterColumns(df, info)
        vars$dfPlot = tidyr::spread(df[,c(tickers$TMS, tickers$COUNTER, vars$field)], tickers$COUNTER, vars$field)
        
        # Tabla general
        dfLast = filterColumns(vars$tickers$getLast(), info)
        t1     = makeTableTickers(dfLast, YATAENV$fiat$getDecimals(vars$tab))
        
        # Tabla mejores
        tmp = dfLast[, c("COUNTER", "LAST", vars$varField)]
        colnames(tmp) = c("COUNTER", "LAST", "VAR")
        
        tmp1 = tmp[tmp$VAR >= 0,]
        tmp1 = tmp1[order(-tmp1$VAR),]
        tmp1[,3] = as.percentage(tmp1[,3])
        t2 = datatable(tmp1[1:vars$varRows,], rownames = FALSE)
        t2 = .formatColumns(tmp1, t2, decFiat)
        
        #Tabla peores
        tmp1 = tmp[tmp$VAR <= 0,]
        tmp1 = tmp1[order(tmp1$VAR),]
        tmp1[,3] = as.percentage(tmp1[,3])
        t3 = datatable(tmp1[1:vars$varRows,], rownames = FALSE)
        t3 = .formatColumns(tmp1, t3, decFiat)
        
        vars$dfTables = list(t1,t2,t3)
    }
    renderTab      <- function() {
        prepareData()
        output$lblHeader = renderText(paste("Last update:", Sys.time()))
        renderPlot()
        output$tblData     = DT::renderDataTable({ vars$dfTables[[1]] })
        output$tblDataUp   = DT::renderDataTable({ vars$dfTables[[2]] })
        output$tblDataDown = DT::renderDataTable({ vars$dfTables[[3]] })
        
    }
    getDataFrame   <- function(tickers) {
        df = NULL
        idx = as.integer(input$graph)
        if (idx == 1) df = tickers$getTickers(reverse=F)   
        if (idx == 2) df = tickers$getVarLast(reverse=F)
        if (idx == 3) df = tickers$getVarFirst(reverse=F)   
        if (idx == 4) df = tickers$getVarSession(reverse=F)  
        df
    }
    createInfo     <- function(ctc) {
        counters = vars$tickers$getCounters()
        
        info          = YATAOLInfo$new()
        info$base     = vars$tab     
        info$showBTC  = TRUE
        info$choices  = counters
        info$selected = counters
        
        vars$baseInfo    = list.append(info)
        names(vars$baseInfo) = c(names(vars$baseInfo), ctc)
        info
    }
    updateRightBar <- function() {
        info = vars$baseInfo[[vars$tab]] 
        updateSwitchInput(session, "swBTC",value = info$showBTC)
        updatePickerInput(session, "chkCTC", choices = info$choices, selected = info$selected)
        updateNoUiSliderInput(session, "sldRngVal", value = info$rangeValue)
        updateNoUiSliderInput(session, "sldRngPrc", value = info$rangePercentagge)
    }
    makeTableTickers = function(df, decFiat) {
        ranges = c(vars$varPrc * -1, vars$varPrc)
        colors = c('#FF0000', '', '#00e500')
        tmp = df
        
        # Remove auxiliar columns: EXC, TMS
        tmp[,c("BASE", "TMS")] = NULL
        
        dt = datatable(tmp, rownames = FALSE)
        dt = .formatColumns(tmp, dt, decFiat)
        
        dt = dt %>% formatStyle( 'VAR',     target='cell', backgroundColor = styleInterval(ranges, colors))
        dt = dt %>% formatStyle( 'SESSION', target='cell', backgroundColor = styleInterval(ranges, colors))
        dt = dt %>% formatStyle( 'CLOSE',   target='cell', backgroundColor = styleInterval(ranges, colors))
        dt
    }
    
    if (!vars$loaded) loader()    
    
    ########################################################################################
    ### OBSERVERS 
    ########################################################################################
    
    observeEvent(input$olMenu, {
      if (nchar(input$olMenu) == 0) return (NULL)
      vars$tab = input$olMenu 
      updateRightBar()
      renderTab() 
    })
    observeEvent(input$btnInfo,   { 
        shinyjs::runjs("iconNavJS(1)")
        info          = vars$baseInfo[[input$tabs]]    
        info$selected = input$chkCTC
        info$showBTC  = input$swBTC
        info$rangeValue = input$sldRngVal
        info$rangePercentage = input$sldRngPrc
        
     })
    observeEvent(input$btnConfig, {
        # Hay que guardarlos en las variables por que puede que no se
        # haya pulsado el boton pero si cambiado los valores
        shinyjs::runjs("YATAToggleSideBar(1, 0)")
        vars$interval = input$mins
        vars$tickers$setPoints(input$rows)
        vars$source = input$field
        vars$plot   = input$graph
        vars$varField = input$rdoRange
        vars$varRows  = input$sldRows
        vars$varPrc   = input$sldVar
        renderPlot() 
    })
    observeEvent(input$btnCancel, {
        if (!vars$active) updateButton(session,paste0(session$ns(""),"btnCancel")
                                             ,label = "   Stop subscription"
                                             ,icon  = icon("remove")
                                             ,style = "danger")
        if (vars$active) updateButton(session,paste0(session$ns(""),"btnCancel")
                                              ,label = "   Start subscription"
                                              ,icon  = icon("clock")
                                              ,style = "success")
        vars$active = !vars$active
        shinyjs::runjs(paste0("toggleLabel('", session$ns(""), "main')"))
        shinyjs::runjs("iconNavJS(0)")
        
    })
    observe({
        if(!vars$active) return (NULL)
        invalidateLater(60000, session) # Update each minute
        isolate({
            vars$count = vars$count - 1
            if (vars$count <= 0) {
                vars$tickers$refresh() # Append data
                if (vars$loaded && !is.null(vars$tab)) renderTab()
                vars$count = vars$interval
            }
            output$lblMins   = renderText(as.character(vars$count))
        })
    })
    
}
