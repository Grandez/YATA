TBLFiat = R6::R6Class("TBLFiat", inherit=YATATable,
     public = list(
         # Column names
          ID  = "ID"
         ,NAME   = "NAME"
         ,SYMBOL = "SYMBOL"
         ,ACTIVE = "ACTIVE"
         ,DECIMALS   = "DECIMALS"
         ,initialize = function() {
             self$name="FIAT";
             self$table = "FIAT";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
         }
         ,getDecimals = function(fiat) { self$df[self$df$SYMBOL == fiat, self$DECIMALS ]}
     )
     ,private = list (
     )
)
