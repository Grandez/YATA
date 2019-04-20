modPortfolio <- function(input, output, session) {
    vars <- reactiveValues( loaded = F
            ,tab = "General"
            ,plot = 2
            ,TPortfolio = NULL 
                            ,TSession  = NULL
                            ,nDays = 60
                            ,symbols = NULL
                            ,tickers = list()
                            ,vars    = list()
                            ,last    = NULL
                            ,plots = c()       # Index de los graficos
                            ,tabs=c("general")
    )
    
    plotTypes = list("Linear" = 1, "Log" = 2, "Bar" = 3, "Candle" = 4)
    
    ########################################################################################
    ### PRIVATE CODE 
    ########################################################################################
    
    # panelMain <- function(pref) {
    #     ns = NS(pref)
    #     useShinyjs()
    #     panelMain = tagList(fluidRow(
    #         checkboxGroupInput(ns("variable2"), "Variables to show:",
    #                            c("Cylinders2" = "cyl",
    #                              "Transmission2" = "am",
    #                              "Gears2" = "gear"))
    #     )
    #     ,fluidRow(plotlyOutput(ns("plotPortfolio"), width="100%",height="500px"))   
    #     ,fluidRow(DT::dataTableOutput(ns("tblPortfolio")))
    #     ,fluidRow(actionButton(ns("BotonXXX"), "BotonXXX"))
    #     )
    #     panelMain
    # }
    # 
    # panelLeft <- function(ctc) {
    #     tagList(
    #         tags$div(id=session$ns("left-ctc")
    #                  ,radioButtons(session$ns(paste0(ctc, "-swPlt1S")), "Primary"  , selected = 1, choices = list("Price" = 1, "Volume" = 2))
    #                  ,radioButtons(session$ns(paste0(ctc, "-swPlt2S")), "Secondary", selected = 2, choices = list("Price" = 1, "Volume" = 2))
    #                  ,radioButtons(session$ns(paste0(ctc, "-swPlt3S")), "Terciary" , selected = 4, choices = list("None"  = 4, "Variation" = 3, "Volume" = 2))
    #                  ,selectInput(session$ns(paste0(ctc, "-swPlt1T")),  "Tipo Primary", selected = 1, choices =  plotTypes)
    #                  ,selectInput(session$ns(paste0(ctc, "-swPlt2T")),  "Tipo Primary", selected = 3, choices =  plotTypes)
    #                  ,selectInput(session$ns(paste0(ctc, "-swPlt3T")),  "Tipo Primary", selected = 1, choices =  plotTypes)
    #                  ,hr()
    #                  ,bsButton(session$ns(paste0(ctc, "-btnConfig")), "JGGMoneda", icon = icon("check"), style = "primary")
    #         )
    #     )    
    # }    

    addClearings = function() {
        TClearing = TBLClearing$new()        
        names  = c("General", TClearing$df[,TClearing$NAME])
        values = c("General", TClearing$df[,TClearing$ID])
        updateMenuTab(session, "tabs", choiceNames=names, choiceValues=values)
        # apply(TClearing$df, 1, function(x) { 
        #       appendTab(inputId = "tabs", tabPanel(x[TClearing$NAME], value=x[TClearing$ID]))}
        #       )
    }
    loader = function() {
      browser()
       addClearings()
       vars$TPortfolio = TBLPortfolio$new()
       vars$symbols = vars$TPortfolio$getCTCSymbols()

        # updateRadioGroupButtons(session, "clearings", choices=TClearing$getCombo(), status="success")
        # browser()
        for (sym in vars$symbols) {
            tmp = TBLSession$new(sym, TBL_DAY, YATAENV$currency)
            tmp$filterByRows(vars$nDays * -1)
            tmpVar = TBLSession$new(source=tmp)
            tlast = tmp$filterByRows(nrow(tmp$df),nrow(tmp$df))
            pos <- which(names(tlast)==tmpVar$DATE)
            tlast = data.frame(tlast[1:pos],Counter=tmp$symbol,tlast[(pos+1):ncol(tlast)])
            vars$last = rbind(vars$last, tlast)
            vars$tickers        = list.append(vars$tickers, tmp)
            vars$vars           = list.append(vars$vars, tmpVar)
        }
        names(vars$tickers) = vars$symbols
        names(vars$vars)    = vars$symbols
        
        renderPlot()
        output$tblSessions  = DT::renderDataTable({ renderTable() })
    }
    renderPlot = function() { 
        titles = c("Prices (linear mode)", "Prices (log mode)", "Volume (Linear mode)", "Volume (Log mode)")
        output$txtMainPlot   = renderPrint({ cat(titles[vars$plot]) })
        
        p = renderSessions()
        if (!is.null(p)) { # Caso no hay datos
          p %>% layout (legend = list(orientation = 'h', xanchor="center", x=0.5))
          output$plotSessions = renderPlotly({ p })
        }
    }
    renderSessions = function() {
        
        if (input$swValue == 0) lData = vars$tickers else lData = vars$vars
        if (is.null(lData) || length(lData) == 0) return (NULL)
        
        tsample = lData[[1]]
        value  = ifelse (input$swSource == 0, tsample$PRICE, tsample$VOLUME)
        
        p <- plot_ly(source="X")
        
        for (idx in 1:length(lData)) {
            ticker = lData[[idx]]
            df = ticker$df
            if (nrow(df) == 0) {
                browser()
            }
            x = df[,ticker$DATE]
            y = df[,value]
            if (input$swPlot == 1) p = YATACore::plotLine (p, x, y,  hoverText=ticker$symbol)
            if (input$swPlot == 2) p = YATACore::plotLog  (p, x, y,  hoverText=ticker$symbol)
            if (input$swPlot == 3) p = YATACore::plotBar  (p, x, y,  hoverText=ticker$symbol)
            if (input$swPlot == 4 && input$swSource == 0) {
                p = YATACore::plotCandle  (p, x, 
                                           df[,ticker$OPEN], df[,ticker$CLOSE], df[,ticker$HIGH],df[,ticker$LOW], 
                                           hoverText=ticker$symbol)
            }
        }
        p
        
        # ax <- list(title = "",zeroline = FALSE,showline = FALSE,showticklabels = FALSE,showgrid = FALSE)
        # m  <- list(l = 2,r = 2,b = 2,t = 2,pad = 1)  
        # if (main) vars$plots = isolate(c())
        # 
        # p <- plot_ly(source=ifelse(main, "X", type))
        # 
        # index = 1
        # for (ticker in vars$tickers) {
        #     df = ticker$df
        #     if (nrow(df) > 1) {
        #         if (main) vars$plots = isolate(c(vars$plots, index))
        #         if (type == 1) p = YATACore::plotLine (p, df[,ticker$DATE], df[,ticker$PRICE],  hoverText=ticker$symbol)
        #         if (type == 2) p = YATACore::plotLog  (p, df[,ticker$DATE], df[,ticker$PRICE],  hoverText=ticker$symbol)     
        #         if (type == 3) p = YATACore::plotLine (p, df[,ticker$DATE], df[,ticker$VOLUME], hoverText=ticker$symbol)     
        #         if (type == 4) p = YATACore::plotLog  (p, df[,ticker$DATE], df[,ticker$VOLUME], hoverText=ticker$symbol)
        #     }
        #     index = index + 1
        # }
        # 
        # # Quitar ejes
        # if (!main) p = p %>% layout(xaxis= ax, yaxis = ax, showlegend=F, margin=m)
        # p
    }
    
    makeTableSession = function(df) {
        # Remove auxiliar column: PRICE
        p=which(colnames(df) == "Price")
        if (length(p) > 0) tmp = df[,-p[1]]
        
        tblHead = .makeHead(df)
        
        dt = datatable(df, container = tblHead, rownames = FALSE)
        dt = .formatColumns(df, dt)
        
        dt
    }    
    renderTable = function() {
        makeTableSession(vars$last)
    }
    
    renderData = function() {
        browser()
       clearing = vars$tab
       if(vars$tab == "General") clearing = NULL
       df = vars$TPortfolio$getClearingPosition(clearing)
    }
    ########################################################################################
    ### OBSERVERS 
    ########################################################################################
    
    
    observeEvent(input$btnConfig, {
        browser()
        print("Update")
    })
    observeEvent(input$tabs, { 
        browser()
        vars$tab = input$tabs
        renderData()
        lbar = paste0(session$ns(""), "left-")
        if (input$tabs != "General") {
        #    htmlwidgets::JS("iconNavJS(0)")
            shinyjs::runjs(paste0("toggleSideBar('", lbar, "ctc', '", lbar, "main')"))
            callModule(modCurrency, input$tabs, input$tabs)
        }
        else {
            #htmlwidgets::JS("iconNavJS(1)")
            shinyjs::runjs(paste0("toggleSideBar('", lbar, "main', '", lbar, "ctc')"))
        }
    })
    # observeEvent(event_data("plotly_click", source = "1"), { vars$plot = 1; plotDefault() })
    # observeEvent(event_data("plotly_click", source = "2"), { vars$plot = 2; plotDefault() })
    # observeEvent(event_data("plotly_click", source = "3"), { vars$plot = 3; plotDefault() })
    # observeEvent(event_data("plotly_click", source = "4"), { vars$plot = 4; plotDefault() })
    observeEvent(event_data("plotly_click", source = "X"), { 
        d = event_data("plotly_click", source = "X") 
        ctc = vars$symbols[d$curveNumber + 1]
        if (ctc %in% vars$tabs) {
            updateTabsetPanel(session, "tabs", selected = ctc)
        }
        else {
            ns = session$ns("")
            vars$tabs = c(vars$tabs, ctc)
            
            appendTab(inputId = "tabs", select = TRUE,
                      tabPanel(HTML(paste('<i class="fa fa-close" onclick=\"alert(\'HALA\')\"></i>',ctc))
                               ,id=paste0(session$ns(""), ctc), value=ctc
                               ,modCurrencyUI(paste0(session$ns(""), ctc)))
            )
            insertUI(selector = "#prf-left", immediate = TRUE, ui=panelLeft(ctc))
        }
    })
    
    #################################################################
    ### PRIVATE FUNCTIONS                                         ###
    #################################################################
    

    
    #################################################################
    ### SERVER CODE                                               ###
    #################################################################
    
    
    if (is.null(vars$TPortfolio)) loader()
    
    observeEvent(input$btnConfig, {
        output$plotSessions = renderPlotly({renderSessions()})
    })
}    