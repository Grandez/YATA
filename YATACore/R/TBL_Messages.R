TBLMessages = R6::R6Class("TBLMessages", inherit=YATATable,
     public = list(
         # Column names
          LANG   = "XX"
         ,REGION = "XX"
         ,initialize = function() {
             self$name="Messages";
         }
         ,getMessage = function(code) {
             msg = private$cache[[code]]
             if (!is.null(msg)) return(msg)
             msg = private$getMSG(code)
             if (length(private$cache) == private$cacheSize) {
                 private$cache = private$cache[-1]
             }
             nm = c(names(private$cache), code)
             private$cache = c(private$cache, msg)
             names(private$cache) = nm
             msg
        }
     )
     ,private = list (
          cache = list()
         ,cacheSize = 10
         ,getMSG = function(code) {
             df = getMessageLocale(code, "XX", "XX")
             df[1, "MSG"]
         }
     )
)
