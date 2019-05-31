TBLModels = R6::R6Class("TBLModels", inherit=YATATable,
     public = list(
         # Column names
          ID     = "ID_MODEL"
         ,PARENT = "ID_PARENT"
         ,NAME   = "NAME"
         ,ACTIVE = "ACTIVE"
         ,SCOPE  = "FLG_SCOPE"
         ,DESCR  = "DESCR"
         ,initialize = function() {
             self$name="Models";
             self$table = "MODELS";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
         }
         ,getCombo    = function(item=NULL) { setNames(self$dfa[, self$ID], self$dfa[,self$NAME])   }
     )
     ,private = list (
     )
)
