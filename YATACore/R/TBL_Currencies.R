TBLCurrencies = R6::R6Class("TBLCurrencies", inherit=YATATable,
     public = list(
         # Column names
          ID  = "ID"
         ,NAME   = "NAME"
         ,SYMBOL = "SYMBOL"
         ,ACTIVE = "ACTIVE"
         ,DECIMALS   = "DECIMALS"
         ,initialize = function() {
             self$name="Currencies";
             self$table = "CURRENCIES";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
          }
     )
     ,private = list (
     )
)
