TBLProviders = R6::R6Class("TBLProviders", inherit=YATATable,
     public = list(
          SYMBOL   = "SYMBOL"
         ,NAME     = "NAME"
         ,ACTIVE   = "ACTIVE"
         ,LAST_UPD = "LAST_UPD"
         ,initialize = function() {
             self$name="Providers";
             self$table = "Providers";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
          }
     )
     ,private = list (
     )
)
