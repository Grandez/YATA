library(shinyjs)

modAnalysis <- function(input, output, session, parent) {
    shinyjs::runjs(paste0("YATAPanels('", session$ns(""), "')"))
    # Control la carga
    # LOADED          =  7
    # LOAD_MONEDA     =  1  # Carga los tickers
    # LOAD_MODELO     =  2  # Carga el modelo sin indicadores
    # LOAD_INDICATORS =  4  # Si hay tickers y modelo, carga indicadores
    # LOAD_ALL    = 15
    plotItems = list("None" = 0, "Price" = 1, "Volume" = 2, "MACD" = 3) 
    vars <- reactiveValues( loaded = F
        ,tab      = 2
        ,provider = "POL"
        ,base     = "USDT"
        ,counter  = "BTC"
        ,scope    = 0
        ,sessions = list()
        ,session  = NULL            # Current
        ,plots    = c(1,2,0)
        ,plotTypes = c(1,2,0)
        ,dtTo     = Sys.Date()
      # dfd = NULL   # Datos
      #      ,loaded = 0  # 1 - Moneda, 2 - Modelo, 4 - Otro                   
      #      # Tabla de tickers, se inicializa para que exista en init 
      #      ,tickers = NULL   # TBLTickers$new("Tickers") # Tabla de tickers
      #      ,changed = FALSE
      #      ,parms = NULL
      #      ,thres = NULL
      #      ,clicks = 0
      #      ,mainSize = 12
      #      ,pendingDTFrom = F
      #      ,pendingDTTo = F
      #      ,toolbox = c(F,F,F,F)
           
    )
    ########################################################################################
    ### PRIVATE CODE 
    ########################################################################################

    updateData <- function(calculate = F) {

       # lapply(vars$sessions, function(x) { 
       #        eval(x)$getSessionDataInterval(vars$base, vars$counter, input$dtFrom, input$dtTo)})
       session = vars$sessions[[vars$tab]]
       session$getSessionDataInterval(vars$base, vars$counter, input$dtFrom, vars$dtTo)

      # ,getSessionDataInterval = function(base, counter, from, to) {
        # print("Update Data")
        # panel = as.integer(input$tabTrading)
        if (calculate) {case$model$calculateIndicators(vars$tickers, force=T)}
# browser()
         #plot = renderPlot(vars, case$model, panel,  input, calculate)
#         tbl  = DT::renderDataTable({ makeTable(panel, vars, case$model) })
# 
#         if (panel == TERM_SHORT)  { output$plotShort  = renderPlotly({plot}); output$tblShort  = tbl }
#         if (panel == TERM_MEDIUM) { output$plotMedium = renderPlotly({plot}); output$tblMedium = tbl }
#         if (panel == TERM_LONG)   { output$plotLong   = renderPlotly({plot}); output$tblLong   = tbl }
    }

    renderInfo = function() {
      session = vars$sessions[[vars$tab]]
      textOuput("lblHeader", paste(session$base, session/counter, sep="/"))
      output$plot  = renderPlotly({renderPlot(session)})
      
      # if (is.null(session) || is.null(session$df)) return (NULL)
      # vars$plots
      # heights = list(c(1.0), c(0.6, 0.4), c(0.5, 0.25, 0.25), c(0.4, 0.2, 0.2, 0.2))
      # DT::renderDataTable({ renderTable() })
      # items = length(sources)
      # plots = list()
      # df    = tickers$df
      # 
      # idx = 0
      # while (idx < items) {
      #   idx = idx + 1
      #   p = plot_ly()
      #   
      #   if (!is.null(sources[idx]) && !is.na(sources[idx])) {
      #     p = YATACore::plotBase(p, types[idx], x=df[,tickers$DATE]
      #                            , y=df[,sources[idx]]
      #                            , open      = df[,tickers$OPEN]
      #                            , close     = df[,tickers$CLOSE]
      #                            , high      = df[,tickers$HIGH]
      #                            , low       = df[,tickers$LOW]
      #                            , hoverText = tickers$symbol) 
      #     if (!is.null(p)) plots = list.append(plots, plotly_build(hide_legend(p)))
      #   }
      # }
      # 
      # rows = items - sum(is.na(sources))
    }    
    
    renderPlot = function (session) {
      
       heights = list(c(1.0), c(0.6, 0.4), c(0.5, 0.25, 0.25), c(0.4, 0.2, 0.2, 0.2))
       numPlots = 0
       plots = list() 
       #browser()
       for (idx in 1:length(vars$plots)) {
           if (vars$plots[[idx]] == 0) next
           numPlots = numPlots + 1
         
           yData = switch(as.integer(vars$plots[[idx]]), session$df[,session$CLOSE], session$df[,session$VOLUME])
           p = plot_ly()
           p = YATACore::plotBase(p, as.integer(vars$plotTypes[[idx]])
                                   , x=session$df[,session$TMS]
                                   , y=yData
                                   , open      = session$df[,tickers$OPEN]
                                   , close     = session$df[,tickers$CLOSE]
                                   , high      = session$df[,tickers$HIGH]
                                   , low       = session$df[,tickers$LOW]
                                   , hoverText = session$counter) 
           if (!is.null(p)) plots = list.append(plots, plotly_build(hide_legend(p)))
       }
       sp = subplot( plots, nrows = numPlots, shareX=T, heights=heights[[numPlots]]) %>% config(displayModeBar=F)
       sp$elementId = NULL
       sp
       
    }
    ########################################################################################
    ### OBSERVERS 
    ########################################################################################
    
    
    observeEvent(input$tabs,  { 
      vars$tab = as.integer(input$tabs)
      renderInfo()
      #click("btnSave")
    })    
    
    observeEvent(input$cboPlot1, {
      if (input$cboPlot1 == input$cboPlot2) updateSelectInput(session, "cboPlot2", selected = vars$plots[1])
      if (input$cboPlot1 == input$cboPlot3) updateSelectInput(session, "cboPlot3", selected = vars$plots[1])
      vars$plots[1] = input$cboPlot1
      updateSelectInput(session, "cboType1", label=names(plotItems)[as.integer(input$cboPlot1)])
    })
    observeEvent(input$cboPlot2, {
      if (input$cboPlot2 == input$cboPlot1) updateSelectInput(session, "cboPlot1", selected = vars$plots[2])
      if (input$cboPlot2 == input$cboPlot3) updateSelectInput(session, "cboPlot3", selected = vars$plots[2])
      vars$plots[2] = input$cboPlot2
      updateSelectInput(session, "cboType2", label=names(plotItems)[as.integer(input$cboPlot2)])
    })
    observeEvent(input$cboPlot3, {
      if (input$cboPlot3 == input$cboPlot1) updateSelectInput(session, "cboPlot1", selected = vars$plots[3])
      if (input$cboPlot3 == input$cboPlot2) updateSelectInput(session, "cboPlot2", selected = vars$plots[3])
      vars$plots[3] = input$cboPlot3
      updateSelectInput(session, "cboType3", label=names(plotItems)[as.integer(input$cboPlot3)])
    })
    observeEvent(input$cboType1, { vars$plotTypes[1] = input$cboType1 })
    observeEvent(input$cboType2, { vars$plotTypes[2] = input$cboType2 })
    observeEvent(input$cboType3, { vars$plotTypes[3] = input$cboType3 })

    # observeEvent(input$cboScope, {
    #   browser()
    #   per = c("W1", "D1", "H8")
    #   if (input$cboScope == 1) per = c("D1", "H8", "H2") # Intraday
    #   if (input$cboScope == 2) per = c("W1", "D1", "H8") # Day
    #   if (input$cboScope == 3) per = c("M1", "W1", "D1") # Week
    #   if (input$cboScope == 4) per = c("M1", "W1", "D1") # Month
    #   vars$sessions = list(TBLSession$new(per[1]),TBLSession$new(per[2]),TBLSession$new(per[3]))
    # })
    observeEvent(input$btnSave, { 
      browser()
        shinyjs::runjs("YATAToggleSideBar(1, 0)")
        # if (input$cboMonedas == 0) { vars$loaded = bitwAnd(vars$loaded, LOAD_ALL - LOAD_MONEDA); return (NULL) }
        # updateActionButton(session, "tradTitle", label = input$cboMonedas)
        vars$base    = input$cboBases
        vars$counter = input$cboMonedas
        vars$scope   = input$cboScope
        
        updateData()
    })
    
    # updateSelectInput(session, "cboMonedas", choices=cboMonedas_load(),selected=NULL)
    # updateSelectInput(session, "cboModels" , choices=cboModels_load())
    # 
    # observeEvent(input$tabTrading, { if (vars$loaded > 0) updateData(input, EQU(vars$loaded, LOADED)) })
    # observeEvent(input$cboMonedas, { print("event moneda");
    #     if (input$cboMonedas == 0) { vars$loaded = bitwAnd(vars$loaded, LOAD_ALL - LOAD_MONEDA); return (NULL) }
    #     updateActionButton(session, "tradTitle", label = input$cboMonedas)
    # 
    #     shinyjs::enable("btnSave")
    #     vars$tickers = YATAData$new(case$profile$scope, input$cboMonedas)
    #     rng = vars$tickers$getRange(YATAENV$getRangeInterval())
    #     vars$pendingDTFrom = T
    #     vars$pendingDTTo   = T
    #     updateDateInput(session, "dtFrom", min=rng[1], max=rng[2], value=rng[3])
    #     updateDateInput(session, "dtTo",   min=rng[1], max=rng[2], value=rng[2])
    #     vars$tickers$filterByDate(rng[3], rng[2])
    #     vars$loaded = bitwOr(vars$loaded, LOAD_MONEDA)
    #     if (AND(vars$loaded, LOAD_MODELO)) {
    #         case$model  = loadIndicators(case$model, vars$tickers$scopes)
    #         vars$loaded = bitwOr(vars$loaded, LOAD_INDICATORS)
    #     }
    #     updateData(input, EQU(vars$loaded, LOADED))
    #    # vars$dfd = vars$tickers$df
    # }, ignoreNULL=T, ignoreInit = T)
    # 
    # 
    # observeEvent(input$cboModels,   { print("event Models")
    #     shinyjs::enable("btnSave")
    #     if (input$cboModels == 0) { vars$loaded = bitwAnd(vars$loaded, LOAD_ALL - LOAD_MODELO); return(NULL) }
    #     case$model  = YATAModels::loadModel(input$cboModels)
    #     vars$loaded = bitwOr(vars$loaded, LOAD_MODELO)
    #     if (AND(vars$loaded, LOAD_MONEDA)) {
    #         case$model  = loadIndicators(case$model, vars$tickers$scopes)
    #         vars$loaded = bitwOr(vars$loaded, LOAD_INDICATORS)
    #     }
    #     updateData(input, EQU(vars$loaded, LOADED))
    # }, ignoreNULL=T, ignoreInit = T)
    # 
    # 
    # # observeEvent(input$chkShowInd,  {if (input$chkShowInd) {
    # #                                      case$model$setParameters(getNumericGroup(input,vars$parms))
    # #                                      #JGG Revisar, no es una lista al uso
    # #                                      #case$model$setThresholds(getNumericGroup(input,vars$thres))
    # #                                      ##case$model$calculateIndicatorsGlobal(vars$tickers) 
    # #                                  }})                                
    # observeEvent(input$dtFrom,      {if (vars$pendingDTFrom) { vars$pendingDTFrom = F; return (NULL) }
    #                                  if (AND(vars$loaded, LOAD_MONEDA)) {print("event dtFrom"); 
    #                                      vars$tickers$filterByDate(input$dtFrom, input$dtTo)
    #                                      case$model$calculated = FALSE
    #                                      updateData(input, EQU(vars$loaded,LOADED))
    #                                  }
    #                                 }, ignoreNULL=F, ignoreInit = T) 
    # observeEvent(input$dtTo,        { if (vars$pendingDTTo) { vars$pendingDTTo = F; return (NULL) }
    #                                   if (AND(vars$loaded, LOAD_MONEDA)) { print("event dtTo");  
    #                                       vars$tickers$filterByDate(input$dtFrom, input$dtTo)
    #                                       case$model$calculated = FALSE
    #                                       updateData(input, EQU(vars$loaded,LOADED))
    #                                    }
    #                                 }, ignoreNULL=F, ignoreInit = T) 
    # observeEvent(input$btnSave,     { 
    #     updateParameter(PARM_CURRENCY, input$cboMoneda)
    #     updateParameter(PARM_MODEL,    input$cboModel)
    #     shinyjs::disable("btnSave")
    # })
    # 
    # # First time
###################################################################################################
### PRIVATE CODE
###################################################################################################

#     makeTable = function(panel, vars, model) {
#         df = vars$tickers$getTickers(panel)$df
#         if (!is.null(case$model) && EQU(vars$loaded, LOADED)) {
#             for (ind in case$model$getIndicators(panel)) {
#                 cols = ind$getData()
#                 if (!is.null(cols)) df = cbind(df,cols)
#             }
#         }
#         .prepareTable(df)
#     }
# 
#     adjustToolbox = function(tabId) {
#         browser()
#         pnlIds = c("pnlShort", "pnlMedium", "pnlEmpty", "pnlLong")
#         tbIds  = c("tbShort",  "tbMedium",  "tbEmpty",  "tbLong")
#         print("entra en adjust")
#         newSize = "col-sm-10"
#         oldSize = "col-sm-12"
#         if (vars$toolbox[tabId]) {
#             newSize = "col-sm-12"
#             oldSize = "col-sm-10"
#         }
#         shinyjs::removeCssClass    (id=pnlIds[tabId], oldSize)
#         shinyjs::toggle(id = tbIds[tabId]) 
#         vars$toolbox[tabId] = !(vars$toolbox[tabId])
#         shinyjs::addCssClass    (id=pnlIds[tabId], newSize)
#     }
#     
#     # Lo devuelve cada vez que entra aqui
#     return(reactive({vars$changed}))
# }
# 
# 
# btnLoad_click      <- function(input, output, session, vars) {
# #    if (validate()) return(showModal(dataError()))
# 
#     # Create user profile
#     profile         = YATAProfile$new()
#     profile$name    = input$txtPrfName
#     profile$profile = input$rdoPrfProfile
#     profile$capital = input$txtPrfImpInitial
#     profile$scope   = input$rdoPrfScope
#     
#     # Create configuration for case
#     config = YATAConfig$new()
#     config$symbol   = input$moneda
#     config$initial  = input$txtPrfImpInitial
#     config$from     = input$dtFrom
#     config$to       = input$dtTo
#     config$mode     = input$rdoProcess
#     config$delay    = input$processDelay
#     
#     # Initialize case
#     case$profile  = profile
#     case$config   = config
#     case$tickers  = vars$tickers
#     case$current  = 0
#     case$oper     = NULL    
# 
#     case$config$summFileName = setSummaryFileName(case)
#     case$config$summFileData = setSummaryFileData(case)
# 
#     calculateIndicators(case)
#     
#     # Create Portofolio
#     portfolio <<- YATAPortfolio$new()
#     portfolio$addActive(YATAActive$new(input$moneda))
#     portfolio$flowFIAT(config$from, config$initial)
# }
# cboMonedas_load    <- function() {
#     print("Load Monedas")
#     tIdx = DBCTC$getTable(TCTC_INDEX)
#     data = tIdx$df %>% arrange(Name)
#     setNames(c(0, data[,tIdx$SYMBOL]),c("  ", data[,tIdx$NAME]))
# }
# cboModels_load <- function() {
#     print("Load Modelos")
#     df = YATACore::loadModelsByScope(case$profile$getScope())
#     setNames(c(0, df$ID_MODEL), c("   ", df$DESCR))
# }
# 
# updateManual       <- function(input, output, session, model) {
#     fp = paste(YATAENV$modelsMan, model$doc, sep="/")
# 
#     if (file.exists(fp)) {
#         output$modelDoc = renderUI({
#             HTML(markdown::markdownToHTML(knit(fp, quiet = TRUE),fragment.only = TRUE))
#             })
#     }   
#     else {
#        output$modelDoc = renderUI({"<h2>No hay documentacion</h2>"})
#     }    
# }
# 
# setParmsGroup = function(parms) {
#       if (length(parms) == 0) return (NULL)
# 
#       LL <- vector("list",length(parms))       
#       nm = names(parms)
#       for(i in 1:length(vars$parms)){
#             LL[[i]] <- list(numericInput(ns(paste0("txt", nm[i])), label = nm[i], value = parms[[i]]))
#       }
#       return(LL)
# 
# }
# getNumericGroup = function(input, parms) {
# 
#     if (length(parms) == 0) return (NULL)
#     ll <- vector("list",length(parms))
#     nm = names(parms)
# 
#     for(i in 1:length(parms)) {
#         # cat(eval(parse(text=paste0("input$txt", nm[i]))), "\n")
#         ll[[i]][1] = eval(parse(text=paste0("input$txt", nm[i])))
#     }
#     names(ll) = nm
#     ll    
# }
# 
# loadTickers = function(scope, moneda) {
#     pos = which(SCOPES == scope)
#     YATACore::openConnection()
#     t1 = NULL
#     t3 = NULL
#     if (pos > 1)              t1 = TBLTickers$new(SCOPES[pos - 1], moneda)
#                               t2 = TBLTickers$new(SCOPES[pos],     moneda)
#     if (pos < length(SCOPES)) t3 = TBLTickers$new(SCOPES[pos + 1], moneda)
#                         
#     YATACore::closeConnection()                              
#     list(t1,t2,t3)
# }
# 
# adjustPanel = function(expand, left, vars) {
#     shinyjs::removeCssClass    (id="pnlMain", paste0("col-sm-", vars$mainSize))
#     if (expand)  vars$mainSize = vars$mainSize + 2
#     if (!expand) vars$mainSize = vars$mainSize - 2
#     shinyjs::addCssClass    (id="pnlMain", paste0("col-sm-", vars$mainSize))
#     if (left) {
#         shinyjs::toggle(id = "pnlLeft") 
#         shinyjs::toggle(id = "SBLOpen")
#     }
#     else {
#         shinyjs::toggle(id = "pnlRight") 
#         shinyjs::toggle(id = "SBROpen")
#     }
# }

    if (!vars$loaded) {
      updateSelectInput(session, "cboProvider", choices=comboClearings(), selected="POL")
      updateSelectInput(session, "cboBases",    choices=comboBases(NULL), selected="USDT")
      updateSelectInput(session, "cboMonedas",  choices=comboCounters(),  selected="BTC")
      updateDateInput(session,   "dtFrom",      value = Sys.Date() - months(3))
      updateDateInput(session,   "dtTo",        value = Sys.Date())
      
      per = c("W1", "D1", "H8")
      vars$sessions = list(TBLSession$new(per[1]),TBLSession$new(per[2]),TBLSession$new(per[3]))
      
      vars$loaded = T
      updateData(F)
    }
    
    
}