TBLPairs = R6::R6Class("TBLPairs", inherit=YATATable,
     public = list(
          CLEARING = "CLEARING"
         ,BASE     = "BASE"
         ,COUNTER  = "COUNTER"
         ,LAST_UPD = "LAST_UPD"
         ,initialize = function() {
             self$name="Pairs";
             self$table = "CURRENCIES_CLEARING";
             super$refresh()
         }
         ,getByClearing = function(clearing) {
             self$df %>% filter(self$df$CLEARING == clearing)
         }
         ,getBases = function(clearing) {
             df = self$getByClearing(clearing)
             unique(df$BASE)
         }
     )
     ,private = list (
     )
)
