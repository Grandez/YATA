TBLClearing = R6::R6Class("TBLClearing", inherit=YATATable,
     public = list(
         # Column names
          ID     = "ID_CLEARING"
         ,NAME   = "NAME"
         ,ACTIVE = "ACTIVE"
         ,MAKER  = "MAKER"
         ,TAKER  = "TAKER"
         ,initialize = function() {
             self$name="Clearing";
             self$table = "CLEARINGS";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
         }
         ,getCombo    = function(item=NULL) { setNames(self$dfa[, self$ID], self$dfa[,self$NAME])   }
         ,setClearing = function(clearing)  { self$df = self$dfa[self$dfa$ID_CLEARING == clearing,] }
         ,getFeeMaker = function()          { as.numeric(paste0("0.", self$df[1, self$MAKER]))      }
         ,getFeeTaker = function()          { as.numeric(paste0("0.", self$df[1, self$TAKER]))      }
         ,getName     = function()          { as.chracter(self$df[1, self$NAME])                    }
     )
     ,private = list (
     )
)
