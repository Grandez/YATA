library(R6)
library(zoo)

#' Es un wrapper para los diferentes fuentes de datos

openConnection  = function(DB="CTC") {
    conn = .SQLDBConnect(DB)
    conn
}
closeConnection = function(conn=NULL) {
    # cnx = conn
    # if (is.null(conn) && !is.null(vars$SQLConn)) cnx = vars$SQLConn
    # .SQLDBDisconnect(cnx)
    # if (is.null(conn) && !is.null(vars$SQLConn)) vars$SQLConn = NULL
    if (!is.null(conn)) .SQLDBDisconnect(conn)
}
beginTrx        = function(newConn = F) { .SQLTran(1, newConn) }
commitTrx       = function(newConn = F) { .SQLTran(2, newConn) }
rollbackTrx     = function(newConn = F) { .SQLTran(3, newConn) }
executeQuery    = function(stmt, parms=NULL, isolated=F) { .SQLDataFrame(stmt, parms, isolated) }
executeUpdate   = function(stmt, parms=NULL, isolated=F) { .SQLExecute  (stmt, parms, isolated) }
getMetadata     = function(table)       { .SQLMetadata(table) }
#################################################
# Carga Tablas
#################################################
#' @export
loadTable <- function (table) {
    .SQLLoadTable(table, isolated=F)
}
#' @export
writeTable <- function (table, data) {
    .SQLWriteTable(table, data, isolated=T)
}

#' @export
loadParameters <- function() {
    .SQLloadParameters()
}

loadProvider <- function(provider) {
    .SQLLoadProvider(provider)
}
#' @export
loadCTCPairs <- function(source=NA, target=NA) {
    .SQLGetCurrencyPairs(source,target)
}

#' @export
loadModelsByScope <- function(scope) {
    sc = scope
    if (sc == SCOPE_NONE) sc = SCOPE_ALL
    df = .SQLLoadModels()
    subset(df, bitwAnd(df$FLG_SCOPE, sc) > 0)
}

#################################################
# Recupera datos
#################################################

getMessageLocale = function(code, lang, region) {
    msg = .SQLGetMessage(code, lang, region)
}
#' @export
getModel <- function(idModel) {
    .SQLGetModel(idModel)
}

#' @export
getModelIndicators <- function(idModel) {
    .SQLGetModelIndicators(idModel)
}

getLastSessions <- function() {
    .SQLGetLastSessions()
}
loadProfile <- function(tableName) {
    .SQLLoadProfile()
}
#' @export
loadModelIndicators <- function(idModel, idScope) {
    .SQLLoadModelIndicators(scope)
}


#' @export
getIndicator <- function(idIndicator) {
    .SQLGetIndicator(idIndicator)
}

#' @export
getIndicatorParameters <- function(idInd, scope, term) {
    .SQLGetIndicatorParameters(idInd, scope, term)
}

#' @export
loadModelGroups <- function(tbName) {
    if (YATAENV$modelsDBType == IO_CSV) .CSVLoadModelGroups(tbName)
    .XLSLoadModelGroups(tbName)
}
#' @export
loadModelModels <- function(tbName) {
     if (YATAENV$modelsDBType == IO_CSV) .CSVLoadModelModels(tbName)
    .XLSLoadModelModels(tbName)
}
#' @export
loadCTCIndex <- function(tbName) {
    if (YATAENV$dataSourceDBType == IO_CSV) df = .CSVLoadCTCIndex(tbName)
    if (YATAENV$dataSourceDBType == IO_SQL) df = .SQLLoadCTCIndex(tbName)
    if (YATAENV$dataSourceDBType == IO_XLS) df = .XLSLoadCTCIndex(tbName)
    df
}
# Carga los tickers de latabla asociada y para la moneda indicada
#' @export
loadSessions <- function(symbol, source, fiat) {
    if (YATAENV$dataSourceDBType == IO_CSV) df = .CSVLoadSessions(symbol, source, fiat)
    if (YATAENV$dataSourceDBType == IO_XLS) df = .XLSLoadSessions(symbol, source, fiat)
    if (YATAENV$dataSourceDBType == IO_SQL) df = .SQLLoadSessions(symbol, source, fiat)

    if (!is.null(df)) df = df %>% arrange(df$Date)
    df
}

#' @export
loadCurrency <- function(symbol) {
    if (YATAENV$sourceType == SRC_XLS) return(.XLSLoadCurrency(symbol))
}

#' @export
updateParameters <- function(key, value) {
    .SQLUpdateParameters(key, value)
}

loadCases <- function(cases) {
    .XLSloadCases()
}


#' @export
writeSummary <- function(data, container, component) {
    # Defecto XLS
    #if (YATAENV$outputType == IO_CSV) return(.CSVWriteSummary(data, container, component))
    #if (YATAENV$outputType == IO_XLS) return(.CSVWriteSummary(container, component))
    return(.CSVWriteData(data, container, component))
}
#' @export
appendSummary <- function(data, container, component) {
    # Defecto XLS
    #if (YATAENV$outputType == IO_CSV) return(.CSVWriteSummary(data, container, component))
    #if (YATAENV$outputType == IO_XLS) return(.CSVWriteSummary(container, component))
    return(.CSVAppendData(data, container, component))
}


.createModel <- function(record) {
    name=record[1,CASE_MODEL]
    if (!is.na(record[1,CASE_VERSION])) name = paste(name,record[1,CASE_VERSION],sep=".")

    base=eval(parse(.makeDir(DIRS["models"],"Model_Base.R")))
    file=.makeDir(DIRS["models"], paste(paste("Model_",name,sep=""),"R",sep="."))
    mod=eval(parse(file))
    model = eval(parse(text=paste(MODEL_PREFIX, name, "$new()", sep="")))
    model
}


setSummaryFileName <- function(case) {
    .XLSsetSummaryFileName(case)
}
setSummaryFileData <- function(case) {
    .XLSsetSummaryFileData(case)
}

.createModel <- function(record) {
    name=record[1,CASE_MODEL]
    if (!is.na(record[1,CASE_VERSION])) name = paste(name,record[1,CASE_VERSION],sep=".")

    base=eval(parse(.makeDir(DIRS["models"],"Model_Base.R")))
    file=.makeDir(DIRS["models"], paste(paste("Model_",name,sep=""),"R",sep="."))
    mod=eval(parse(file))
    model = eval(parse(text=paste(MODEL_PREFIX, name, "$new()", sep="")))
    model
}

.createTableTickers <- function(name) {
    TBLTickers = R6::R6Class("TBLTickers", inherit=YATATable,
       public = list(
           DATE="Date"
          ,OPEN="Open"
          ,HIGH="High"
          ,LOW="Low"
          ,CLOSE="Close"
          ,VOLUME="Volume"
          ,CAP="MarketCap"
          ,refresh  = function() { super$refresh(".loadCTCTickers", self$name) }
       )
    )
    TBLTickers$new(name)
}
