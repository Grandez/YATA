# Implementa la tabla de cambios: last, ask, bid, etc.
TBLOperation = R6::R6Class("TBLOperation", inherit=YATATable,
     public = list(
          ID           = "ID_OPER"
         ,TYPE         = "TYPE"
         ,CLEARING     = "CLEARING"
         ,BASE         = "BASE"
         ,COUNTER      = "COUNTER"
         ,AMOUNT       = "AMOUNT"
         ,IN_PROPOSAL  = "IN_PROPOSAL"
         ,IN_EXECUTED  = "IN_EXECUTED"
         ,IN_REASON    = "IN_REASON"
         ,STOP         = "OPSTOP"
         ,LIMIT        = "OPLIMIT"
         ,OUT_PROPOSAL = "OUT_PROPOSAL"
         ,OUT_EXECUTED = "OUT_EXECUTED"
         ,OUT_REASON   = "OUT_REASON"
         ,TMS_IN       = "TMS_IN"
         ,TMS_OUT      = "TMS_OUT"
         ,TMS_LAST     = "TMS_LAST"
         ,PRICE        = "PRICE"
         ,initialize  = function() {
             self$name = "Operations"
             self$table = "Operations"
         }

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
         ,add = function(id, type, clearing, base, counter, amount, proposal, stop, limit) {
             fields = c( self$ID       ,self$TYPE,        self$CLEARING ,self$BASE  ,self$COUNTER
                        ,self$AMOUNT   ,self$IN_PROPOSAL ,self$STOP     ,self$LIMIT
                        ,self$TMS_IN   ,self$TMS_LAST)
             values = list( id         ,type             ,clearing      ,base       ,counter
                           ,amount     ,proposal         ,stop          ,limit
                           ,Sys.time(), Sys.time())
             names(values) = fields
             self$insert(values)
         }
         ,getOpenPending = function() {
             qry = paste("SELECT * FROM ", self$table, " WHERE ", self$IN_EXECUTED, "IS NULL")
             self$df = executeQuery(qry)
             self$df
         }
         ,print       = function()     { print(self$name)  }
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
             private$dfSession = join( private$dfSession
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
             last = join(last, private$dfSession, by = c("CTC", "EXC"))

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
