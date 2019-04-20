
btnLoad_click <- function(input, output, session) {
#    if (validate()) return(showModal(dataError()))

    shinyjs::runjs("YATAMenu(0);")
    Sys.sleep(0.5)
    initObjects(input)    

    # Update page
    output$lblPosFiat   = renderText({portfolio$getActive(CURRENCY)$position})
    output$lblPosMoneda = renderText({portfolio$getActive()$position})
    output$lblPosTotal  = renderText({portfolio$balance()})
    
    output$lblResInicio = renderText({case$config$initial})

    # reactive({
    #    vars$sessions = reactiveVal(loadSummary(case$config$symbol, case$model$symbolBase, case$model$symbol))
    #    vars$mode = case$config$mode
    #    vars$dfi = case$data$dfi
    #    vars$clicks = vars$clicks + 1
    # })
}


cboMonedas_load <- function() {
    data = loadCurrencies()
    data = data[order(data$Name),]
    setNames(data$Symbol,data$Name)
}

cboModelos_load <- function() {
    df = loadModels()
    setNames(df$Model, df$Name)
}

initObjects <- function(input) {
    
    # Create user profile
    profile         = YATAProfile$new()
    profile$name    = input$txtPrfName
    profile$profile = input$rdoPrfProfile
    profile$saldo   = input$txtPrfImpInitial
    profile$scope   = input$rdoPrfScope
    
    # Create configuration for case
    config = YATAConfig$new()
    config$symbol   = input$moneda
    config$initial  = input$txtPrfImpInitial
    config$from     = input$dtFrom
    config$to       = input$dtTo
    config$mode     = input$rdoProcess

    
    # Create Data
    case$data$symbol = input$moneda
    case$data$start  = input$dtFrom
    case$data$end    = input$dtTo

    # Initialize case
    
    case$investor = profile
    case$config   = config
    case$current  = 0
    case$oper     = NULL    

    case$config$summFileName = setSummaryFileName(case)
    case$config$summFileData = setSummaryFileData(case)

    case = calculateIndicators(case)
    
    # Create Portofolio
    portfolio <<- YATAPortfolio$new()
    portfolio$addActive(YATAActive$new(input$moneda))
    portfolio$flowFIAT(case$data$start, config$initial)

}