# Tickers no es una tabla

YATATickers = R6::R6Class("YATATickers",
     public = list(
          TMS     = "TMS"
         ,BASE    = "Base"
         ,CTC     = "CTC"
         ,HIGH    = "High"
         ,LOW     = "Low"
         ,LAST    = "Last"
         ,VOLUME  = "Volume"
         ,ASK     = "Ask"
         ,BID     = "Bid"
         ,CHANGE  = "Change"
         ,VAR     = "Var"
         ,SESSION = "Session"
         ,CLOSE   = "Close"
         ,points  = 0
         ,inError = FALSE
         ,lastError = ""
         ,df        = NULL
         #######################################################33
         ,refresh       = function() {
             # Por logica de programa se llama tras initialize
             if (private$first) {
                 private$first = FALSE
             }
             else {
                curr = private$getLastTickers()
                if (is.null(curr)) return (NULL)

                private$dfTickers = rbind(private$dfTickers, curr)
                private$calculateAll(curr)
                private$dfLast  = curr
             }
         }
         ,initialize    = function() {
             dfSes = getLastSessions()

             private$dfSession           = dfSes[,c("TMS", "BASE", "CTC", "CLOSE", "VOLUME")]
             colnames(private$dfSession) =        c("TMS", "Base", "CTC", "Close", "Volume")

             dfAct = private$getLastTickers()
             if (!is.null(dfAct)) {
                 private$dfTickers = dfAct
                 private$dfFirst   = dfAct
                 private$dfLast    = dfAct

                 private$calculateAll(private$dfFirst)
                 private$bases = unique(private$dfFirst$Base)
             }
             self$setBase(private$bases[1])
         }
         ,getBases      = function() { private$bases       }
         ,getCounters   = function() {unique(self$df$CTC)  }
         ,setBase       = function(base) {
             private$base = base
             self$df =  private$dfTickers %>% filter(Base == private$base)
          }
         ,getTickers    = function(reverse = T) { private$getDF(private$dfTickers,    reverse) }
         ,getVarFirst   = function(reverse = T) { private$getDF(private$dfVarFirst,   reverse) }
         ,getVarLast    = function(reverse = T) { private$getDF(private$dfVarLast,    reverse) }
         ,getVarSession = function(reverse = T) { private$getDF(private$dfVarSession, reverse) }
         ,getLast       = function()            { private$dfLast %>% filter(Base == private$base) }
         ,getRange      = function()            {
             df = private$dfTickers %>% filter(Base == private$base)
          }
         ,setPoints     = function(points)      { self$points = points                            }
         ,print         = function()            { print(private$base)  }
     )
     ,private = list(first = TRUE
         ,dfSession      = NULL
         ,dfFirst        = NULL
         ,dfLast         = NULL
         ,dfTickers      = NULL
         ,dfVarLast      = NULL
         ,dfVarFirst     = NULL
         ,dfVarSession   = NULL
         ,bases          = NULL
         ,base           = NULL
         ,getDF          = function(df, reverse) {
             tmp = df %>% filter(Base == private$base)
             # column 1 es TMS
             if (reverse) tmp = tmp[seq(dim(tmp)[1],1),]
             tmp
         }
         ,getLastTickers = function() {
             tmp = YATAProviders::getTickers()
             # Control de error
             if ("character" %in% class(tmp)) {
                 self$inError = TRUE
                 self$lastError = tmp
                 return (NULL)
             }
             tmp$Change = tmp$Change * 100
             # A veces hay discrepancias entre la sesion y los tickers
             # solo tratamos aquellos datos de los que tenemos cierre
             dfm = merge(tmp, private$dfSession[, c("Base", "CTC")])
             dfm = private$calcVarTickers(dfm)
             private$adjustTypes(dfm)
         }
         ,calculateAll   = function(curr) {
             # Variacion respecto al ultimo ticker
             dfvar = private$calculateVar(curr, private$dfLast)
             private$dfVarLast = rbind(private$dfVarLast, dfvar)

             # Variacion respecto al inicio de sesion
             dfvar = private$calculateVar(curr, private$dfFirst)
             private$dfVarFirst = rbind(private$dfVarFirst, dfvar)

             # Variacion respecto al cierre anterior
             dfX = curr[,c("TMS", "Base", "CTC", "Last", "Volume")]
             tmp = private$calculateVar(dfX, private$dfSession)
             private$dfVarSession = rbind(private$dfVarSession, tmp)
         }
         ,calculateVar   = function(curr, prev) {
             last = curr

             # Merge para que no haya problemas de dimensiones

             tmp = merge(last, prev, by.x=c("Base","CTC"), by.y=c("Base","CTC"))
             colsT = colnames(tmp)
             colsX = colsT[grepl(".x", colsT)]

             for (col in colsX) {
                 colbase = substr(col, 1, nchar(col) - 2)
                 cols = c(paste0(colbase, ".x"), paste0(colbase, ".y"), colbase)
                 if (is.numeric(tmp[,cols[1]])) tmp[,cols[3]] = ((tmp[,cols[1]] / tmp[,cols[2]]) - 1) * 100
             }
             tmp = replace(tmp, is.na(tmp), 0)

             colnames(tmp) = sub("TMS.x", "TMS", colnames(tmp))
             colsDot = grepl(".[xy]", colnames(tmp))
             tmp[, !colsDot]
         }
         ,calcVarTickers = function(act) {
             dfa = act
             if (is.null(private$dfFirst)) {
                 dfa$Var     = 0.0
                 dfa$Session = 0.0
             }
             else {
                 dfa$Var  = private$calcVarField(dfa[,c("Base", "CTC", "Last")], private$dfLast[,c("Base", "CTC", "Last")])
                 dfa$Session = private$calcVarField(dfa[,c("Base", "CTC", "Last")], private$dfFirst[,c("Base", "CTC", "Last")])
             }

             dfs = private$dfSession[,c("Base", "CTC", "Close")]
             dft = dfa[,c("Base", "CTC", "Last")]
             dfm = merge(dfa, dfs)
             dfm$Close = ((dfm[,"Last"] / dfm[,"Close"]) - 1) * 100
             dfa$Close = dfm$Close
             dfa
         }
         ,calcVarField   = function(dfx, dfy) {
             dfm = merge(dfx, dfy, by.x=c("Base", "CTC"), by.y=c("Base", "CTC"))
             dfm$var = ((dfm[,"Last.x"] / dfm[,"Last.y"]) - 1) * 100
             dfm$var
         }
         ,adjustTypes    = function(tmp) {
             tmp[,self$TMS]     = as.datet(tmp[,self$TMS])
             tmp[,self$HIGH]    = as.fiat(tmp[,self$HIGH])
             tmp[,self$LOW]     = as.fiat(tmp[,self$LOW])
             tmp[,self$LAST]    = as.fiat(tmp[,self$LAST])
             tmp[,self$ASK]     = as.fiat(tmp[,self$ASK])
             tmp[,self$BID]     = as.fiat(tmp[,self$BID])
             tmp[,self$CHANGE]  = as.percentage(tmp[,self$CHANGE])
             tmp[,self$VAR]     = as.percentage(tmp[,self$VAR])
             tmp[,self$SESSION] = as.percentage(tmp[,self$SESSION])
             tmp[,self$CLOSE]   = as.percentage(tmp[,self$CLOSE])
             tmp[,self$VOLUME]  = as.long(tmp[,self$VOLUME])
             tmp
         }
     )
)
