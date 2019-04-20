TBLPairs = R6::R6Class("TBLPairs", inherit=YATATable,
     public = list(
         # Column names
          BASE    = "SRC"
         ,COUNTER = "TGT"
         ,LAST    = "LAST"
         ,initialize    = function() { super$initialize(name="Pairs");
                                       TNames = TBLCurrencies$new()
                                       private$names = TNames$df[,c(TNames$SYMBOL, TNames$NAME)]
                                     }
         ,getBases      = function() { unique(self$df$SRC) }
         ,getCounters   = function() { unique(self$df$TGT) }
         ,getCombo = function(base = NULL) {
             dfb = NULL
             if (is.null(base) || nchar(base) == 0) {
                 dfb  = data.frame(ID=unique(self$df$SRC), stringsAsFactors = F)
             }
             else {
                 dfb = self$df[self$df$SRC == base,]
                 dfb  = data.frame(ID=unique(dfb$TGT), stringsAsFactors = F)
             }
             dfn = merge(dfb, private$names, by.x = "ID", by.y = "SYMBOL")
             setNames(dfn$ID, dfn$NAME)
         }
     )
     ,private = list (names  = NULL
     )
)
