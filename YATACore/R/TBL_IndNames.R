TBLIndNames = R6::R6Class("TBLIndNames", inherit=YATATable,
     public = list(
         # Column names
          ID_GRP = "ID_GROUP"
         ,ID     = "ID_IND"
         ,PARENT = "ID_PARENT"
         ,NAME   = "NAME"
         ,ACTIVE = "ACTIVE"
         ,DESCR  = "DESCR"
         ,initialize = function() {
             self$name="Indicators";
             self$table = "IND_INDS";
             super$refresh()
             self$dfa$ACTIVE = as.logical(self$dfa$ACTIVE)
             self$dfa = self$dfa[self$dfa$ACTIVE == TRUE,]
             self$df = self$dfa
             self$df$ACTIVE  = as.logical(self$df$ACTIVE)
         }
         ,getCombo    = function(group) {
             self$df = self$dfa %>% filter( self$dfa$ID_GROUP == group)
             setNames(self$df[, self$ID], self$df[,self$NAME])
         }
         ,getIndNameByID = function(id) {
             id = as.integer(id)
             tmp = self$dfa[self$dfa$ID_IND == id,]
             tmp[1,self$NAME]
         }
     )
     ,private = list (
     )
)
