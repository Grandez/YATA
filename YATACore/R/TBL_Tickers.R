# Implementa la tabla de cambios: last, ask, bid, etc.
TBLTickers = R6::R6Class("TBLTickers", inherit=YATATable,
     public = list(
          symbol = NULL
         ,TMS     = "TMS"
         ,BASE     = "EXC"
         ,CTC     = "CTC"
         ,HIGH    = "High"
         ,LOW     = "Low"
         ,LAST    = "Last"
         ,VOLUME  = "Volume"
         ,ASK     = "Ask"
         ,BID     = "Bid"
         ,CHANGE  = "Change"
         ,base    = NULL
         ,refresh       = function()    {
             if (is.null(private$bases)) {
                 private$firstTime()
                 return (invisible(self))
             }

             tmp = private$getTickers()
             if (nrow(tmp) == 0) return (invisible(self))
             private$makeLast(tmp)

             # Append data for graph
             for (base in private$bases) {
                  df = tmp %>% filter(EXC == base)
                  private$dfList[[which(private$bases == base)]] =
                  rbind(private$dfList[[which(private$bases == base)]], df)
             }
             invisible(self)
         }

         ,getData     = function()     { self$df           }
         ,getBases    = function()     { private$bases     }
         ,getLast     = function()     { private$dfLast[[which(private$bases == self$base)]] }
         ,setBase     = function(base) { self$base = base; self$df = private$dfList[[which(private$bases == base)]] }
         ,initialize  = function() {
             browser()
             self$name = "Tickers"
             super$initialize(refresh=FALSE);
             private$firstTime()
         }
     )

     ,private = list(
          bases = NULL
         ,dfFirst = NULL
         ,dfLast  = list()
         ,dfList = list()
         ,dfSession = NULL
         ,firstTime  = function() {
             private$dfFirst = private$getTickers()
             if (nrow(private$dfFirst) == 0) return (invisible(self))
             private$bases = unique(private$dfFirst$EXC)

             dfSes = getLastSessions()
             private$dfSession = dfSes[,c("CTC", "EXC", "CLOSE")]
             private$dfSession = plyr::join( private$dfSession
                                            ,private$dfFirst[,c("CTC", "EXC", "Last")]
                                            ,by = c("CTC", "EXC"))
             colnames(private$dfSession) = c("CTC", "EXC", "Close", "Session")

             for (base in private$bases) {
                 df = private$dfFirst %>% filter(EXC == base)
                 private$dfList = list.append(private$dfList, df)
             }
             private$makeLast(private$dfFirst)
         }
         ,makeLast   = function(last) {
             last = plyr::join(last, private$dfSession, by = c("CTC", "EXC"))

             last = private$adjustTypes(last)
             last[,"Close"]   = as.fiat(last[,"Close"])
             last[,"Session"] = as.fiat(last[,"Session"])
             columns = c("TMS", "EXC", "CTC", "Last", "Ask", "Bid", "High", "Low", "Volume", "Change", "Session", "Close")
             last = last[,columns]

             private$dfLast = list()
             for (base in private$bases) {
                 df = last %>% filter(EXC == base)
                 private$dfLast = list.append(private$dfLast, df)
             }
         }
         ,getTickers = function() {
             tmp = YATAProviders::getTickers()
             private$adjustTypes(tmp)
         }
         # ,calculateChange = function(last) {
         #     tmp = join( private$dfSession, last[,c("EXC","CTC", "Last")],by = c("CTC", "EXC"))
         #     tmp$Session = (tmp[,4] / tmp[,3]) - 1
         #     tmp[,3:4] = NULL
         #     tmp = replace(tmp, is.na(tmp), 0)
         #     df = merge(last, tmp, by = c("CTC", "EXC"))
         #     df
         # }
         # ,calculateChangeDay = function(last) {
         #     browser()
         #     tmp = join( private$dfSession[,c("EXC","CTC", "Close")]
         #                 ,last[,c("EXC","CTC", "Last")]
         #                 ,by = c("CTC", "EXC"))
         #     tmp$Session = (tmp[,4] / tmp[,3]) - 1
         #     tmp[,3:4] = NULL
         #     tmp = replace(tmp, is.na(tmp), 0)
         #     df = merge(last, tmp, by = c("CTC", "EXC"))
         #     df
         #
         #
         # }
         ,adjustTypes = function(tmp) {
             tmp[,self$TMS]    = as.datet(tmp[,self$TMS])
             tmp[,self$HIGH]   = as.fiat(tmp[,self$HIGH])
             tmp[,self$LOW]    = as.fiat(tmp[,self$LOW])
             tmp[,self$LAST]   = as.fiat(tmp[,self$LAST])
             tmp[,self$ASK]    = as.fiat(tmp[,self$ASK])
             tmp[,self$BID]    = as.fiat(tmp[,self$BID])
             tmp[,self$CHANGE] = as.percentage(tmp[,self$CHANGE])
             tmp[,self$VOLUME] = as.long(tmp[,self$VOLUME])
             tmp
         }
     )
)
