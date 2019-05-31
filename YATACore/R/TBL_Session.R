TBLSession = R6::R6Class("TBLSession", inherit=YATATable,
     public = list(
          provider = NULL
         ,base   = NULL
         ,counter = NULL
         ,BASE   =  "BASE"
         ,COUNTER = "COUNTER"
         ,TMS    = "TMS"
         ,OPEN   = "OPEN"
         ,CLOSE  = "CLOSE"
         ,HIGH   = "HIGH"
         ,LOW    = "LOW"
         ,VOLUME = "VOLUME"
         ,AVERAGE  = "AVERAGE"
         ,initialize       = function(period, provider="POL") {
             super$initialize(F, paste("Poloniex", period), paste("SESSION", provider, period, sep="_"))
         }
         ,getDateColumn      = function()     { self$TMS }
         ,getTargetColByName = function(name) {
             ucols = toupper(colnames(self$dfa))
             which(ucols == toupper(name))
          }
         ,getPairs = function() {
             qry = paste("select BASE, COUNTER, MAX(TMS) AS TMS FROM", self$table, " GROUP BY BASE, COUNTER")
             self$df = YATACore::executeQuery(qry)
             self$df
         }
         ,getSessionDataInterval = function(base, counter, from, to) {
             self$base = base
             self$counter = counter
             qry = paste("SELECT * FROM", self$table, " WHERE BASE = ? AND COUNTER = ? AND TMS BETWEEN ? AND ?")
             self$dfa = YATACore::executeQuery(qry, parms = list(base, counter, from - months(1), to))
             self$df = self$dfa %>% filter(self$dfa$TMS >= from)
         }
         # ,refresh          = function()    {
         #     if (is.null(self$dfa)) {
         #         self$dfa = loadSessions(self$symbol, self$table, self$fiat)
         #         self$dfa$Change = rollapplyr(self$dfa[,self$VALUE], 2, FUN = calculateChange, fill = 0)
         #         self$dfa = private$adjustTypes(self$dfa)
         #     }
         #     self$df  = self$dfa
         #     if (nrow(self$df) > 0) self$df[,self$PRICE] = self$df[,self$VALUE]
         #
         #     invisible(self)
         # }
         # ,reverse          = function() {
         #     tmp = self$df[seq(dim(self$df)[1],1),]
         #     private$adjustTypes(tmp)
         # }
         # ,getRange         = function(rng=0) {
         #     beg     = self$dfa[1,self$DATE]
         #     start   = beg
         #     last    = self$dfa[nrow(self$dfa), self$DATE]
         #     current = Sys.Date()
         #     year(start)  = year(current)
         #     month(start) = 1
         #     if (month(current) < 6) {year(start) = year(start) - 1 ; month(start) = 6}
         #
         #     if (start <= beg) start = beg
         #     # if (rng > 0 && nrow(self$dfa) > rng) {
         #     #         start = as.Date(self$dfa[nrow(self$dfa) - rng, self$DATE])
         #     # }
         #     c(beg, last, start)
         #  }
         # ,filterByDate     = function(from, to)   { private$makeDF(self$dfa %>% filter(Date >= from, Date <= to)) }
         # ,filterByRows     = function(from, to=0) { if (to   == 0) to = nrow(self$dfa)
         #                                          if (from <  0) from = to + from + 1
         #                                          if (from <= 0) from = 1
         #                                          private$makeDF(self$dfa[from:to,])
         #                                        }
         # ,getTrend         = function()         { lm(self$df[,self$PRICE] ~ c(1:nrow(self$df)))$coefficients[2] }
         # ,getTrendAngle    = function()         { atan(self$getTrend() * nrow(self$df)) * 180 / pi        }
         # ,getData          = function()         { self$df                                                 }
         # ,getBaseData      = function()         { self$df[,self$DATE, self$PRICE]   }
         # ,getCurrentData   = function(regs)     {
         #     tmp = self$clone()
         #     tmp$filterByRows(1,regs)
         #     tmp
         # }
         # ,getCurrentTicker = function(reg)            { self$df[reg,]    }
     )
     ,private = list(
         #  makeDF      = function(dfa) {
         #     self$df = dfa
         #     self$df = private$adjustTypes(self$df)
         #     self$df[,self$PRICE] = dfa[,self$VALUE]
         #     self$df
         # }
         # ,adjustTypes = function(df) {
         #     df[,self$DATE]   = as.dated(df[,self$DATE])
         #     df[,self$OPEN]   = as.fiat(df[,self$OPEN])
         #     df[,self$CLOSE]  = as.fiat(df[,self$CLOSE])
         #     df[,self$HIGH]   = as.fiat(df[,self$HIGH])
         #     df[,self$LOW]    = as.fiat(df[,self$LOW])
         #     df[,self$VOLUME] = as.long(df[,self$VOLUME])
         #     df
         # }
         # ,calculateVariation = function() {
         #     for (col in colnames(self$df)) {
         #         if ("numeric" %in% class(self$df[,col])) {
         #             self$df[,col] = rollapplyr(self$df[,col], 2, calculateChange, fill = 0)
         #             self$df[,col] = as.percentage(self$df[,col])
         #         }
         #     }
         # }
     )
)
