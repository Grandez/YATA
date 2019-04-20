
library(R.utils)
library(lubridate)
library(XLConnect)
library(stringr)
library(zoo)
library(RMariaDB)
library(YATAProviders)
library(rlist)
library(plyr)

YATAVARS <- R6::R6Class("YATAVARS"
    ,public = list(
         SQLConn = list()
        ,lastErr = NULL
        ,tmpConn = NULL
        ,msg     = NULL
        ,addConn = function (SQLConn = NULL) {
            if (is.null(SQLConn)) SQLConn = openConnection()
            self$SQLConn = c(SQLConn, self$SQLConn)
            SQLConn
        }
        ,getConn = function() {
            tmp = NULL
            if (length(self$SQLConn) > 0) tmp = self$SQLConn[[1]]
            tmp
        }
        ,removeConn = function(disc = T) {
            if (length(self$SQLConn) == 0) return (NULL)
            tmp = self$SQLConn[[1]]
            if (disc) closeConnection(tmp)
            self$SQLConn = self$SQLConn[-1]
        }
    )

)

coreVars = YATAVARS$new()

#' Create the global object YATAENV
#'
#' @note This function should be called before any process
#'
#' @param cases If TRUE also create the object DBCases
#' @export
createEnvironment <- function() {

    # if (!exists("YATAENV")) {
        YATAENV  <<- YATAEnvironment$new()
        # DBCTC    <<- createDBCurrencies()
        # DBModels <<- createDBModels()
    # }
}

#' @export
cleanEnvironment = function() {

    tmp = coreVars$getConn()
    while (!is.null(tmp)) {
        closeConnection(tmp)
        tmp = coreVars$getConn()
    }
}

#' @export
getMessage = function(code, ...) {
    # Lazy Loading
    if (is.null(coreVars$msg)) coreVars$msg = TBLMessages$new()
    coreVars$msg$getMessage(code)
}

#' Clase de configuracion general
#'
#' @export
#'
###################################   AQUI ################################################
executeSimulation <- function(case=NULL) {
    if (is.null(case)) stop(MSG_NO_CASE())
    xlcFreeMemory()
    gc()

    portfolio = YATAPortfolio$new()
    a=YATAActive$new(case$config$symbol)
    portfolio$addActive(a)
    portfolio$flowFIAT(case$config$from, case$profile$capital)
    calculateIndicators(case)


    while (case$hasNext()) {
        nextTicker(case, portfolio)
        portfolio$updatePosition(case)
    }

    portfolio
}

#' @export
nextTicker <- function(case, portfolio) {
    case$current = case$current + 1
    action = case$model$calculateAction(case, portfolio)
    if (action[1] == 0) return(OP_NONE)

    case$oper = case$model$calculateOperation(portfolio, case, action)
    if (is.null(case$oper)) return(OP_NONE)

    if (case$config$mode == MODE_AUTOMATIC) {
        portfolio$flowTrade(case$oper)
        return (OP_EXECUTED)
    }
    return (OP_PROPOSED)
}

#' @export
calculateIndicators <- function(case) {
    model           = case$model
    tIndex          = DBCTC$getTable(TCTC_INDEX)
    case$config$dec = tIndex$select(case$config$symbol)[1,tIndex$DECIMAL]
    case$trend      = case$tickers$getTrend()

    model$calculateIndicatorsGlobal(case$tickers)

}


