
saveSession <- function(input, output, session) {
    xlsName = eval(parse(text=CFG$XLSSummaryBook))
    wb = loadWorkbook(xlsName,T)
    cat(xlsName)
}    

loadSummary <- function(sym, base, model) {
#    sFileName = CFG$setSummaryFileName(sym, base)
#    sFileData = CFG$setSummaryFileData(sym, model)
#    loadSessionSummary(sFileName, sFileData)
}

createSummary <- function() {

    cfg = case$config
    model = case$model
    #opers = isolate()
    d = list( User=case$investor$name, Date=Sys.Date(),Time=format(Sys.time(),format="%H:%M:%S"), Profile=case$investor$profile
             ,Moneda=cfg$symbol,Start=cfg$from,End=cfg$to,Days=cfg$to-cfg$from,Trend=trunc(case$trend,digits=2)
             ,Model=model$symbolBase, Submodel=model$symbol
             #,Opers=vars$numOpers, Buy=vars$buy,Sell=vars$sell
             ,Opers=0, Buy=1,Sell=2
             ,Initial=cfg$initial, Final=trunc(portfolio$balance()), Res = trunc(((portfolio$balance() / cfg$initial) - 1) * 100,digits=2)
            )
    #session$addSimulation(d)
    shinyjs::runjs("YATAMenu(2);")
 #   vars$sessions = session$getSimulations()
}