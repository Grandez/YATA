TBLCTC = R6::R6Class("TBLCTC", inherit=YATATable,
     public = list(
          PRTY   = "PRTY"
         ,SYMBOL = "SYMBOL"
         ,NAME   = "NAME"
         ,ACTIVE = "ACTIVE"
         ,DECIMALS   = "DECIMALS"
         ,initialize = function() {
             self$name="Currencies";
             self$table = "CURRENCIES_CTC";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
          }
     )
     ,private = list (
     )
)
