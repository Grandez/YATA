detach("package:YATA", unload=T)

library(R6)
library(dplyr)
library(rlist)
library(XLConnect)
library(lubridate)
library(mondate)
library(zoo)

library(YATA)

ENV=YATAEnv$new()

# options(java.parameters = "-Xmx1024m") 
# files.config = list.files("D:/prj/R/YATA/YATAConfig/R", pattern="*.R$", full.names=TRUE, ignore.case=F)
# sapply(files.config,source,.GlobalEnv)
# 
# files.layout = list.files("D:/prj/R/YATA/YATAData/R", pattern="*.R$", full.names=TRUE, ignore.case=F)
# sapply(files.layout,source) # ,.GlobalEnv)

# XLS_CASES="d:/prj/R/YATA/YATAData/in/cases.xlsx"

MIN_PERCENTAGE=0.75 # Minimo rango de datos que se deben cumplir
dfSumm = NULL

#' Prueba
#'
#' @import YATACore
#'
YATABatch <- function(ids=NULL) {

  createEnvironment(cases=T)
  cases = .prepareCases(ids)

  cat(sprintf("%d casos preparados\n", nrow(cases)))
  nCases = .executeCases(cases)
  cat(sprintf("%d casos ejecutados\n", nCases))
  tNow=Sys.time()
  summFileName = paste("batch", strftime(tNow,format="%Y%m%d"), strftime(tNow,format="%H%M%S"), sep="_")
  writeSummary(dfSumm, NULL, summFileName)
#  sh = .loadCases(1)
#  prf = .makeProfile(sh)
#  print(sh)
}

.prepareCases <- function(ids) {
   dfTotal = NULL
   TBCases = DBCases$getTable(TBL_CASES)
   dfCases = loadCases(DBCases$name, TBCases$name)
   
   if (!is.null(ids)) {
       #idLst=eval(parse(text=paste("rep(",ids,")",sep="")))
       dfCases = dfCases %>% filter(eval(parse(text=CASE_ID)) %in% ids)
   }
   
   for (iCase in 1:nrow(dfCases)) {
       dfIndex = loadCurrencies(dfCases[iCase,CASE_FROM], dfCases[iCase,CASE_TO])
       for (iCurrency in 1:nrow(dfIndex)) {
           df = .makeIntervals(dfIndex[iCurrency,IDX_SYMBOL], TBCases, as.list(dfCases[iCase,]))
           df[,IDX_NAME]     = dfIndex[iCurrency, IDX_NAME]
           df[,IDX_SYMBOL]   = dfIndex[iCurrency, IDX_SYMBOL]
           df[,CASE_ID]      = dfCases[iCase,     CASE_ID]
           df[,CASE_CAPITAL] = dfCases[iCase,     CASE_CAPITAL]
           df[,CASE_MODEL]   = dfCases[iCase,     CASE_MODEL]
           df[,CASE_VERSION] = dfCases[iCase,     CASE_VERSION]
           if (is.null(dfTotal)) {
               dfTotal = df
           }
           else {
               dfTotal = rbind(dfTotal, df)
           }
       }
   }
   dfTotal
}

.executeCases <- function(cases) {
    nCases = 0
    for (iCase in 1:nrow(cases)) {
       xlcFreeMemory()
       gc()
        
       record = cases[iCase,]
       profile = .createProfile(record)
       config  = .createConfig(record)
       model   = .createModel(record)
       data    = .createData(record)
       if (!is.null(data)) {
           nCases = nCases + 1
           cat(sprintf("Executing case %6d (%06d) ", nCases, iCase))
           tBeg = proc.time()
           case    = YATACase$new(profile, data, model, config)
           portfolio = YATA::executeSimulation(case)
           tEnd = proc.time()

           elapsed = tEnd["elapsed"] - tBeg["elapsed"]
           .addSummary(iCase, elapsed, record, case, portfolio)
           cat(sprintf(" - %3.0f\n", elapsed))
       }
    }
    nCases
}


.addSummary <- function(index, elapsed, record, case, portfolio) {
    idTest = paste(record[1,CASE_MODEL], as.numeric(Sys.Date()), sep="_")
    model  = record[1,CASE_MODEL]
    if (!is.na(record[1,CASE_VERSION])) model = paste(model, record[1,CASE_VERSION], sep='.')
    lPrfx = list(date=Sys.Date(), orden=index, id=idTest, elapsed=elapsed)
    lCase = list(record[1,])
    lPos  = list(portfolio$position())
    lista = list.append(lPrfx, lCase, Trend=case$trend,lPos)
    
    summRec = as.data.frame(lista)
    if (is.null(dfSumm)) {
        dfSumm <<- summRec
    }
    else {
        dfSumm <<- rbind(dfSumm, summRec)
    }
}

.makeIntervals <- function(symbol, TBCases, ...) {
    prms = list(...)[[1]]

    data = loadData(symbol)
    beg=as.Date(ifelse(is.na(prms[[CASE_START]]), data[1,CTC_DATE], as.character(prms[[CASE_START]])))
    
    last= as.Date(as.character(data[nrow(data),CTC_DATE]))

    prf   = .expandNumber(prms[[CASE_PROFILE]])
    per   = .expandNumber(prms[[CASE_PERIOD]])
    start = .expandMonth(beg,last,prms[[CASE_INTERVAL]])
    end   = as.mondate(start) + per
    end   = as.Date(end)
    cols  = list(prf, start, per, end)
    colNames = c(CASE_PROFILE, CASE_START, CASE_PERIOD, CASE_END)

    parms = TBCases$getGroupFields(CASE_GRP_PARMS)
    for (parm in parms) {
        if (is.na(prms[[parm]])) break;
        prm   = .expandNumber(prms[[parm]])
        cols = list.append(cols, prm)
        colNames = c(colNames, parm)
    }
    
    gr = expand.grid(cols)
    df = data.frame(gr)
    colnames(df) <- colNames
    df
}
.expandNumber <- function(num) {
    toks=strsplit(as.character(num), ":")[[1]]
    if (length(toks) == 1) toks = c(toks, toks)
    seq(from=toks[1],to=toks[2])
}

.expandMonth <- function(beg, end, interval) {
    if (interval == 0) return(beg)
    seq(from=beg, to=end, by=paste(interval, "months"))
}

.createProfile <- function(record) {
    profile = YATAProfile$new()
    profile$name = "Batch"
    profile$profile = record[1,CASE_PROFILE]
    profile$scope=record[1,CASE_SCOPE]
    profile$saldo=record[1,CASE_CAPITAL]
    profile
}

.createConfig <- function(record) {
    config = YATAConfig$new()
    config$symbol  = record[1,CASE_SYM_SYM]
    config$from    = record[1,CASE_START]
    config$to      = record[1,CASE_END]
    config$initial = record[1,CASE_CAPITAL]
    config
}

.createData <- function(record) {
    data = YATAData$new()
    data$name   = record[1,CASE_SYM_NAME]
    data$symbol = record[1,CASE_SYM_SYM]
    data$start  = record[1,CASE_START]
    data$end    = record[1,CASE_END]

    df = loadData(data$symbol)
    tgt = df %>% filter(Date >= data$start, Date <= data$end)

    # Verificar rango de datos
    if ((nrow(tgt) / (record[1,CASE_PERIOD] * 30)) < MIN_PERCENTAGE) return (NULL)
    data$dfa = df
    data
}

.createModel <- function(record) {
    name=record[1,CASE_MODEL]
    if (!is.na(record[1,CASE_VERSION])) name = paste(name,record[1,CASE_VERSION],sep=".")
    model = loadModel(name)
    model$setParameters(as.vector(record[1, grep(CASE_GRP_PARMS, colnames(record))]))
    model
    
#    base=eval(parse(.makeDir(DIRS["models"],"Model_Base.R")))
#    file=.makeDir(DIRS["models"], paste(paste("Model_",name,sep=""),"R",sep="."))
#    mod=eval(parse(file))
#    model = eval(parse(text=paste(MODEL_PREFIX, name, "$new()", sep="")))
#    model     
}

