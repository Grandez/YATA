YATAData = R6::R6Class("YATAData",
     public = list(
         symbol = NULL
         ,name   = "Tickers data"
         ,scopes = c(SCOPE_HOUR04, SCOPE_DAY, SCOPE_WEEK)
         ,getDecimals      = function()    { c(self$OPEN,self$HIGH,self$LOW,self$CLOSE) }
         ,getCoins         = function()    { c(self$VOLUME,self$CAP) }
         ,getDates         = function()    { c(self$DATE) }
         ,setPriceColumn   = function(col) { self$VALUE = col }
         ,getTickers       = function(idx) { i = idx ; if (i == 4) i = 3;
                                             private$adjustDateTypes(private$tickers[[i]], i)
                                           }
         ,getTickersShort  = function()    { self$getTickers(1) }
         ,getTickersMedium = function()    { self$getTickers(2) }
         ,getTickersLong   = function()    { self$getTickers(3) }
         ,refresh          = function()    {
             SQLConn <<- openConnection()
             for (tick in private$tickers) tick$refresh()
             closeConnection(SQLConn)
             invisible(self)
         }
         ,getRange        = function(rng=0)    { private$tickers[[2]]$getRange(rng) }
         ,filterByDate    = function(from, to) {
              if (from != private$from || to != private$to) {
                  for (t in private$tickers) t$filterByDate(from, to)
                  private$from = from
                  private$to   = to
              }
          }
         ,print           = function()         { print(self$name)  }
         ,initialize      = function(scope, symbol, fiat) {
             self$symbol = symbol
             private$setTBNames(scope)
             openConnection()
             for (idx in 1:length(private$tables)) {
                 if (idx > 1) private$tickers = c(private$tickers, NULL)
                 if (!is.null(private$tables[[idx]])) {
                     private$tickers = c(private$tickers, TBLTickers$new(symbol, private$tables[[idx]], fiat))
                 }
             }
             closeConnection()
         }
     )
     ,private = list(
          from       = Sys.Date()
         ,to         = Sys.Date()
         ,tickers    = list()
         ,tables     = list()
         ,adjustDateTypes = function (tickers, i) {
             if (i == 2 || i == 4) {
                 tickers$df$Date = as.dated(tickers$df$Date)
             }
             else {
                 tickers$df$Date = as.datet(tickers$df$Date)
             }
             tickers
         }
         ,setTBNames = function(scope) {
             ##JGG TODO Por ahora solo diarios
             private$tables = c("TICKERSH4", "TICKERSD1", "TICKERSW1")
             # pos = which(SCOPES == scope)
             # sc1 = NULL
             # sc2 = SCOPES[pos]
             # sc3 = NULL
             # if (pos > 2)              sc1 = SCOPES[pos - 2]
             # if (pos < length(SCOPES)) sc3 = SCOPES[pos + 1]
             # for (i in c(sc1,sc2,sc3)) private$tables = c(private$tables, private$mountTBName(i))
             # private$tables = c(private$tables, private$tables[3])
         }
         # ,mountTBName = function(scope) {
         #     base = "TICKERS"
         #     if (scope == SCOPE_HOUR)    return (paste0(base, "H2"))
         #     if (scope == SCOPE_MIDDAY)  return (paste0(base, "H4"))
         #     if (scope == SCOPE_WORKDAY) return (paste0(base, "H8"))
         #     if (scope == SCOPE_DAY)     return (paste0(base, "D1"))
         #     if (scope == SCOPE_WEEK)    return (paste0(base, "W1"))
         #     paste0(base, "M1")
         # }
     )
)
