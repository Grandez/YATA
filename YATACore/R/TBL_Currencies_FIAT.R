TBLFiat = R6::R6Class("TBLFiat", inherit=YATATable,
     public = list(
          SYMBOL = "SYMBOL"
         ,NAME   = "NAME"
         ,ACTIVE = "ACTIVE"
         ,DECIMALS   = "DECIMALS"
         ,initialize = function() {
             self$name="Currencies";
             self$table = "CURRENCIES_FIAT";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
          }
     )
     ,private = list (
     )
)
