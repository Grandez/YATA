TBLPortfolio = R6::R6Class("TBLPortfolio", inherit=YATATable,
     public = list(
         # Column names
          CLEARING   = "ID_CLEARING"
         ,CTC        = "CURRENCY"
         ,ACTIVE     = "ACTIVE"
         ,POSITION   = "POS"
         ,AVAILABLE  = "AVAILABLE"
         ,LAST_OPER  = "LAST_OP"
         ,LAST_VALUE = "LAST_VALUE"
         ,LAST_TMS   = "LAST_TMS"
         ,initialize = function() {
             self$name="Portfolio";
             self$table = "PORTFOLIO";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
          }
         ,getCTCSymbols = function(all = F) {
             tmp = self$dfa
             if (!all) tmp = self$dfa[self$dfa$ACTIVE == T,]
             tmp[,self$CTC]
         }
         ,getClearingPosition  = function(clearing=NULL) {
             qry1 = paste("SELECT", self$CTC, ", SUM(", self$POSITION,  ") AS ", self$POSITION
                          , ", SUM(", self$AVAILABLE, ") AS ", self$AVAILABLE
                          , ", MAX(", self$LAST_TMS,  ") AS ", self$LAST_TMS)
             qry1 = paste(qry1, "FROM ", self$table)
             qry2 = paste(qry1, "WHERE", self$CLEARING, " = ?")
             qry3 = paste( "GROUP BY ", self$CTC)
             qry   = qry1
             parms = NULL
             if (!is.null(clearing)) {
                 qry = qry2
                 parms = list(clearing)
             }
             qry = paste(qry, qry3)
             df = executeQuery(qry, parms)
             if (!is.null(df)) {
                 df[,self$POSITION]  = as.fiat(df[,self$POSITION])
                 df[,self$AVAILABLE] = as.fiat(df[,self$AVAILABLE])
                 df[,self$LAST_TMS]  = as.dated(df[,self$LAST_TMS])
             }
             df
          }
         ,getAvailable = function(currency,clearing=NULL) {
             tmp = private$getPos(currency, clearing)
             res = as.numeric(tmp[1,self$AVAILABLE])
             as.ctc(res)
         }
         ,updatePosition = function(idOper, clearing, currency, amount, date, executed) {
             pos = self$getClearingPosition(clearing)
             if (!is.null(pos)) {
                 pos = pos %>% filter(CURRENCY == currency)
                 if (nrow(pos) == 0) pos = NULL
             }

             if (is.null(pos)) {
                 fields = c( self$CLEARING, self$CTC,        self$ACTIVE,     self$POSITION
                            ,self$AVAILABLE, self$LAST_OPER, self$LAST_VALUE, self$LAST_TMS)
                 values = list(clearing, currency, 1, amount, amount, idOper, amount, date)
                 names(values) = fields
                 self$insert(values)
             }
             else {
                 newVal = pos[1, self$POSITION] + amount
                 available = pos[1, self$AVAILABLE]
                 if (executed) available = available + amount
                 fields = c(self$POSITION, self$AVAILABLE, self$LAST_OPER, self$LAST_VALUE, self$LAST_TMS)
                 values = list(newVal, available, idOper, amount, date)
                 names(values) = fields
                 keys = list(clearing, currency)
                 names(keys) = c(self$CLEARING, self$CTC)
                 self$update(values, keys)
             }
         }
     )
     ,private = list (
         getClearingPos = function(clearing) {
         }
        ,getPos = function(currency, clearing) {
             browser()
             tmp = self$df %>% filter(self$df$CURRENCY == currency)
             if (!is.null(clearing)) tmp = tmp %>% filter(tmp$ID_CLEARING == clearing)
             tmp = tmp %>% group_by(CURRENCY=tmp$CURRENCY) %>%
                           summarise(POS=sum(tmp$POS), AVAILABLE=sum(tmp$AVAILABLE), LAST_TMS=max(LAST_TMS))
             if (nrow(tmp) == 0) {
                 tmp = data.frame("CURRENCY"=character(), "POS"=numeric(),"AVAILABLE"=numeric(),"LAST_TMS"=as.Date(character()))
                 cols = colnames(tmp)
                 tmp = rbind(tmp, list(currency, 0.0, 0.0, Sys.Date()))
                 colnames(tmp) = cols
             }
             tmp
        }
        ,addRecord = function(clearing, currency, amount, date, executed, conn) {
            sql = paste("INSERT INTO", self$table, "(")
            sql = paste(sql, self$CLEARING,  ",", self$CTC, self$ACTIVE, ",", self$POSITION, ",")
            sql = paste(sql, self$AVAILABLE, ",", self$LAST_OPER, ",", self$LAST_VALUE, ",", self$LAST_TMS, ")")
            sql = paste(sql, " VALUES (?, ?, ?, ?, ?, ?, ?, ?)")
            parms = list(clearing, currency, 1, amount, amount, date, amount, date)
            executeUpdate(sql, parms, conn)

        }
        ,updateRecord = function(clearing, currency, amount, available, date, executed, conn) {
            parms = NULL
            sql = paste("UPDATE", self$table, "SET")
            sql = paste(sql,      self$POSITION, "= ?")
            sql = paste(sql, ",", self$AVAILABLE,  " = ?")
            sql = paste(sql, ",", self$LAST_OPER,  " = ?")
            sql = paste(sql, ",", self$LAST_VALUE, " = ?")
            sql = paste(sql, ",", self$LAST_TMS,   " = ?")
            sql = paste(sql, ") WHERE ", self$CLEARING, " = ? AND", self$CTC, " = ?")
            parms = list(amount, available, date, amount, date, clearing, currency)
            executeUpdate(sql, parms, conn)
        }

     )
)
