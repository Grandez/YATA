TBLINDGroups = R6::R6Class("TBLINDGroups", inherit=YATATable,
     public = list(
         # Column names
          ID  = "ID_GROUP"
         ,NAME   = "NAME"
         ,ACTIVE = "ACTIVE"
         ,initialize = function() {
             self$name="Groups";
             self$table = "IND_GROUPS";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
          }
     )
     ,private = list (
     )
)
