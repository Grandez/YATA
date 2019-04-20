library(shinyjs)

modTrading <- function(input, output, session, parent) {
    ns <- session$ns    
    useShinyjs()
    vars <- reactiveValues( loaded = F
           ,tab = ""   
           ,source    = NULL
           ,ctc       = NULL
           ,portfolio = NULL
           ,opers     = YATAOperation$new()
           ,accounts = NULL
           ,pairs    = NULL
           ,portfolio = NULL
           ,clearing  = NULL
    )

    if (!vars$loaded) {
      files.trading = list.files("ui/partials/modTrading", pattern="*\\Server.R$", full.names=TRUE)
      sapply(files.trading,source)
      files.trading = list.files("ui/partials/modTrading", pattern="dlg*.R$", full.names=TRUE)
      sapply(files.trading,source)
      
      vars$loaded = T      
    }
    
    #######################################################################
    # Private Code
    #######################################################################

    # loadSources = function() {
    #   TClearing = TBLClearing$new()        
    #   names  = c("Cash", TClearing$df[,TClearing$NAME])
    #   values = c("Cash", TClearing$df[,TClearing$ID])
    #   names(values) = names
    #   updateSelectInput(session, "cboXferFrom" , choices=values)
    #   updateSelectInput(session, "cboXferTo"   , choices=values)
    # } 
    # 
    # loadCboCurrency = function() {
    #   ctc = c("Euro"="EUR", "Dollar"="USD")
    #   if (vars$source != "Cash" && vars$source != "None") {
    #     vars$portfolio = TBLPortfolio$new()
    #     df = vars$portfolio$getClearingPosition(vars$source)
    #     if (is.null(df)) {
    #       ctc = c("No data"="None")
    #     }
    #   }
    #   updateSelectInput(session, "cboXferCurrencies" , choices=ctc)
    # }
    # 
    # loadSaldo = function() {
    #   saldo = 0.0
    #   if (!is.null(vars$source) && vars$source != "Cash" && vars$source != "None") {
    #     df = vars$portfolio$getClearingPosition(vars$source)
    #     if (!is.null(df)) {
    #       
    #     }
    #   }
    #   verbatimTextOutput("lblXferSaldo", saldo)
    # }
    
    #######################################################################
    # Server Code
    #######################################################################
    
    observeEvent(input$tabs,   {
      if (input$tabs == "buy")  callModule(modBuy,  input$tabs)
      if (input$tabs == "sell") callModule(modSell, input$tabs)
      if (input$tabs == "open") callModule(modOpen, input$tabs)
      if (input$tabs == "xfer") callModule(modXFer, input$tabs)
    })
    
    # if (!vars$loaded) {
    #   loadSources()
    #    vars$loaded = T
    # }   
    
    # 
    # observeEvent(input$opType, {
    #     names = c("oper", "oper", "transfer")
    #     pos = as.integer(input$opType)
    #     shinyjs::hide(names[vars$act])
    #     shinyjs::show(names[pos])
    #     vars$act = pos
    # })
    # 
    # observeEvent(input$cboBase,   {
    #     if (nchar(input$cboBase) > 0) {
    #         data = vars$portfolio$getPosition(input$cboBase, input$cboCamara)
    #         output$lblBasePos = renderText({as.character(data)})
    #         updateSelectInput(session, "cboCTC",  choices=makeCombo(TBLPairs, input$cboBase))
    #     }
    # })
    # observeEvent(input$cboCTC,   {
    #     if (nchar(input$cboCTC) > 0) {
    #         data = vars$portfolio$getPosition(input$cboCTC, input$cboCamara)
    #         output$lblCTCPos = renderText({as.character(data)})
    #     }
    # })
    
#     # Control la carga
#     LOADED          =  7
#     LOAD_MONEDA     =  1  # Carga los tickers
#     LOAD_MODELO     =  2  # Carga el modelo sin indicadores
#     LOAD_INDICATORS =  4  # Si hay tickers y modelo, carga indicadores
#     LOAD_ALL    = 15
# 
#     updateSelectInput(session, "cboMonedas", choices=cboMonedas_load(),selected=NULL)
#     updateSelectInput(session, "cboModels" , choices=cboModels_load())
#     
#     observeEvent(input$SBLOpen,  { print("event SBLOpen"); adjustPanel(F, T, vars); })
#     observeEvent(input$SBROpen,  { print("event SBROpen"); adjustPanel(F, F, vars); })
#     observeEvent(input$SBLClose, { print("event SBLClose");adjustPanel(T, T, vars); })
#     observeEvent(input$SBRClose, { print("event SBRClose");adjustPanel(T, F, vars); })
#     observeEvent(input$btnToolbox, { print("event btnToolBolx");adjustToolbox(as.integer(input$tabTrading))})
# 
#     observeEvent(input$tabTrading, { if (vars$loaded > 0) updateData(input, EQU(vars$loaded, LOADED)) })
#     observeEvent(input$cboMonedas, { print("event moneda");
#         if (input$cboMonedas == 0) { vars$loaded = bitwAnd(vars$loaded, LOAD_ALL - LOAD_MONEDA); return (NULL) }
#         updateActionButton(session, "tradTitle", label = input$cboMonedas)
# 
#         shinyjs::enable("btnSave")
#         vars$tickers = YATAData$new(case$profile$scope, input$cboMonedas)
#         rng = vars$tickers$getRange(YATAENV$getRangeInterval())
#         vars$pendingDTFrom = T
#         vars$pendingDTTo   = T
#         updateDateInput(session, "dtFrom", min=rng[1], max=rng[2], value=rng[3])
#         updateDateInput(session, "dtTo",   min=rng[1], max=rng[2], value=rng[2])
#         vars$tickers$filterByDate(rng[3], rng[2])
#         vars$loaded = bitwOr(vars$loaded, LOAD_MONEDA)
#         if (AND(vars$loaded, LOAD_MODELO)) {
#             case$model  = loadIndicators(case$model, vars$tickers$scopes)
#             vars$loaded = bitwOr(vars$loaded, LOAD_INDICATORS)
#         }
#         updateData(input, EQU(vars$loaded, LOADED))
#        # vars$dfd = vars$tickers$df
#     }, ignoreNULL=T, ignoreInit = T)
# 
#     
#     observeEvent(input$cboModels,   { print("event Models")
#         shinyjs::enable("btnSave")
#         if (input$cboModels == 0) { vars$loaded = bitwAnd(vars$loaded, LOAD_ALL - LOAD_MODELO); return(NULL) }
#         case$model  = YATAModels::loadModel(input$cboModels)
#         vars$loaded = bitwOr(vars$loaded, LOAD_MODELO)
#         if (AND(vars$loaded, LOAD_MONEDA)) {
#             case$model  = loadIndicators(case$model, vars$tickers$scopes)
#             vars$loaded = bitwOr(vars$loaded, LOAD_INDICATORS)
#         }
#         updateData(input, EQU(vars$loaded, LOADED))
#     }, ignoreNULL=T, ignoreInit = T)
#     
# 
#     # observeEvent(input$chkShowInd,  {if (input$chkShowInd) {
#     #                                      case$model$setParameters(getNumericGroup(input,vars$parms))
#     #                                      #JGG Revisar, no es una lista al uso
#     #                                      #case$model$setThresholds(getNumericGroup(input,vars$thres))
#     #                                      ##case$model$calculateIndicatorsGlobal(vars$tickers) 
#     #                                  }})                                
#     observeEvent(input$dtFrom,      {if (vars$pendingDTFrom) { vars$pendingDTFrom = F; return (NULL) }
#                                      if (AND(vars$loaded, LOAD_MONEDA)) {print("event dtFrom"); 
#                                          vars$tickers$filterByDate(input$dtFrom, input$dtTo)
#                                          case$model$calculated = FALSE
#                                          updateData(input, EQU(vars$loaded,LOADED))
#                                      }
#                                     }, ignoreNULL=F, ignoreInit = T) 
#     observeEvent(input$dtTo,        { if (vars$pendingDTTo) { vars$pendingDTTo = F; return (NULL) }
#                                       if (AND(vars$loaded, LOAD_MONEDA)) { print("event dtTo");  
#                                           vars$tickers$filterByDate(input$dtFrom, input$dtTo)
#                                           case$model$calculated = FALSE
#                                           updateData(input, EQU(vars$loaded,LOADED))
#                                        }
#                                     }, ignoreNULL=F, ignoreInit = T) 
#     observeEvent(input$btnSave,     { 
#         updateParameter(PARM_CURRENCY, input$cboMoneda)
#         updateParameter(PARM_MODEL,    input$cboModel)
#         shinyjs::disable("btnSave")
#     })
#     
#     # First time
#     if (vars$loaded == 0) {
#         if (!is.na(case$profile$getCTC()))   updateSelectInput(session, "cboMonedas", selected = case$profile$getCTC())
#         if (!is.na(case$profile$getModel())) updateSelectInput(session, "cboModels", selected = case$profile$getModel())
#     }
# ###################################################################################################
# ### PRIVATE CODE
# ###################################################################################################
# 
#     updateData <- function(input, calculate) {
#         print("Update Data")
#         panel = as.integer(input$tabTrading)
#         if (calculate) {case$model$calculateIndicators(vars$tickers, force=T)}
#         
#         plot = renderPlot(vars, case$model, panel,  input, calculate)
#         tbl  = DT::renderDataTable({ makeTable(panel, vars, case$model) })
#         
#         if (panel == TERM_SHORT)  { output$plotShort  = renderPlotly({plot}); output$tblShort  = tbl }
#         if (panel == TERM_MEDIUM) { output$plotMedium = renderPlotly({plot}); output$tblMedium = tbl }
#         if (panel == TERM_LONG)   { output$plotLong   = renderPlotly({plot}); output$tblLong   = tbl }
#     }
# 
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
}

