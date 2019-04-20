DB_CASES      = "Cases"
TCASES_CASES  = "Cases"

TBLCases2 <- R6Class("TBLCases", inherit=YATATable,
   public = list(
       ID        = "idTest"
      ,NAME      = "Name"
      ,SUMMARY   = "Summary"
      ,DETAIL    = "Detail"
      ,INFO      = "Info"
      ,PROFILE   = "Profile"
      ,SCOPE     = "Scope"
      ,CAPITAL   = "Capital"
      ,OTRO      = "Otro"
      ,FROM      = "From"
      ,TO        = "To"
      ,START     = "Start"
      ,PERIOD    = "Period"
      ,INTERVAL  = "Interval"
      ,MODEL     = "Model"
      ,END       = "End"
      ,SYM_NAME  = "SymName"
      ,SYM_SYM   = "Symbol"
      ,LBL_PARMS = "lblParms"
      ,LBL_THRES = "lblThres"        
      ,GRP_PARMS      = "Parm"
      ,GRP_THRESHOLDS = "Thre"
      ,refresh        = function()      { super$refresh("loadCases", self$name) }
      ,filterByID     = function(ids)   { self$df = self$dfa %>% filter(self$dfa$idTest %in% ids) }
      ,getGroups      = function()      { private$groups                       }
      ,getGroupFields = function(group) { idx = match(group, private$groups)
                                          if (is.na(idx)) return(c())
                                          paste0(private$groups[idx],seq(private$numGroups[idx]))
                                        }
      ,getGroupSize   = function(group) { r = match(group, private$groups)
                                         if (is.na(r)) return(NA)
                                         private$numGroups[r]
                                       }
      ,initialize   = function(tbName="NoName") {
          self$name         = tbName
          private$groups    = c(self$GRP_PARMS, self$GRP_THRESHOLDS)
          private$numGroups = c(5,5)
          self$refresh()
      }
   )
   ,private = list(
       fields = c()
      ,groups = c()
      ,numGroups=c()
   )
)

createDBCases <- function() {
    DBCases = YATADB$new(DB_CASES)
    tCase = TBLCases2$new(TCASES_CASES)
    DBCases$addTables(c(tCase))
}
