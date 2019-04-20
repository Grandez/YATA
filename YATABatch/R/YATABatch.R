detach("package:YATA", unload=T)

library(R6)
library(dplyr)
library(rlist)
library(tibble)
library(XLConnect)
library(lubridate)
library(mondate)
library(zoo)

library(YATA)

options( DT.options = list(dom = "t",rownames = FALSE)
        ,java.parameters = "-Xmx2048m"
       )
file.sources = list.files("R", pattern="(YATABatch).+\\.R$", full.names=TRUE, ignore.case=F)
sapply(file.sources,source)

MIN_PERCENTAGE=0.75 # Minimo rango de datos que se deben cumplir
summFileName = paste("batch", strftime(Sys.time(),format="%Y%m%d"), strftime(Sys.time(),format="%H%M%S"), sep="_")
#nCases = 0  # Used to detect first case or not

#' Prueba
#'
#' @import YATACore
#'
YATABatch <- function(ids=NULL) {
  createEnvironment()
  dbCases = createDBCases()
  dfCases = prepareCases(ids, dbCases)

  cat(sprintf("%d casos preparados\n", nrow(dfCases)))
  nCases = .executeCases(dfCases, dbCases)
  cat(sprintf("%d casos ejecutados\n", nCases))
    
}
.executeCases <- function(dfCases, dbCases) {
    nCases = 0
    for (iCase in 1:nrow(dfCases)) {
       xlcFreeMemory()
       gc()

       case = as.list(dfCases[iCase,])
       tbTickers = TBLTickers$new(dfCases[iCase, "Symbol"])
       tbTickers$filterByDate(case[["Start"]], case[["End"]])
       
       # Verificar rango de datos
       if ((tbTickers$nrow() / (case[["Period"]] * 30)) < MIN_PERCENTAGE) next

       case = .createCase(dfCases[iCase,], tbTickers, dbCases)

       nCases = nCases + 1
       cat(sprintf("Executing case %6d (%06d) ", nCases, iCase))

       tBeg = proc.time()
       portfolio = YATA::executeSimulation(case)
       tEnd = proc.time()

       elapsed = tEnd["elapsed"] - tBeg["elapsed"]
       .addSummary(iCase, elapsed, dfCases[iCase,], case, portfolio)
       cat(sprintf(" - %3.0f\n", elapsed))
    }
    nCases
}


.addSummary <- function(index, elapsed, record, case, portfolio) {
    modelName  = record[1,"Model"]
    idTest = paste(modelName, round(as.numeric(Sys.time())), sep="_")

    lPrfx  = list(date=Sys.Date(), id=idTest, elapsed=round(elapsed, 2))
    lCase  = list(record[1,]) 
    lParms = case$model$getParameters()
    lThres = case$model$getThresholds()
    lPos   = list(portfolio$getPosition()[3:5])
    rec    = portfolio$getActive()$getLastTrading()
    lPM    = as.list(rec[1, grep("^PM", colnames(rec))])
    
    num = lPos[[1]][1]
    if (length(lPM) > 0) { # Hay operaciones?
        num   = num + (lPos[[1]][2] * lPM[2])    
    }
    else {
        lPM=list(PMM=0,PMC=0)
    }
    
    den   = lCase[[1]]["Capital"]
    res   = round(((num /den) - 1) * 100, 2)
    angle = round(case$tickers$getTrendAngle(),0)

    lista  = list.append(lPrfx, lCase, lParms, Trend=angle, lPos, lPM, Res=res[1,1])
    
    reg = as.data.frame(lista)
    if (index > 1) {
        appendSummary(reg, NULL, summFileName)
    }
    else {
        writeSummary(reg, NULL, summFileName)
    }
}

.loadCurrenciesList = function(from, to) {
   tIdx = DBCTC$getTable(TCTC_INDEX)    
   df = tIdx$df %>% filter(eval(parse(text=tIdx$SYMBOL)) >= from)
   df = df      %>% filter(eval(parse(text=tIdx$SYMBOL)) <= to)
        df      %>% arrange(tIdx$SYMBOL)
}

.createCase = function(rCase, tbTickers, dbCases) {
    tbCases = dbCases$getTable(TCASES_CASES)
    
    profile         = YATAProfile$new()
    profile$name    = "Batch"
    profile$profile = rCase[1,"Profile"]
    profile$scope   = rCase[1,"Scope"]
    profile$capital = rCase[1,"Capital"]
    
    config = YATAConfig$new()
    config$symbol  = rCase[1,"Symbol"]
    config$from    = rCase[1,"Start"]
    config$to      = rCase[1,"End"]

    model = loadModel(DBModels, rCase[1,"Model"])
    
    prmNames = grep(paste0("^",tbCases$GRP_PARMS),colnames(rCase), value=T)
    if (length(prmNames) > 0) {
        vars = as.vector(rCase[1, prmNames])
        names(vars) = prmNames
        model$setParametersA(vars, tbCases$GRP_PARMS)
    }

    thrNames = grep(paste0("^",tbCases$GRP_THRESHOLDS),colnames(rCase), value=T)
    if (length(thrNames) > 0) {
        vars = as.vector(rCase[1, thrNames])
        names(vars) = thrNames
        model$setThresholdsA(vars, tbCases$GRP_THRESHOLDS)
    }
    
    rCase = YATACase$new()
    rCase$tickers = tbTickers
    rCase$config  = config
    rCase$model   = model
    rCase$profile = profile
    rCase
}