YATAProvider <- R6Class("YATAProvider",
    public = list(
       name   = NULL
      ,prefix = NULL
      ,initialize = function(provider) {
         self$name = provider
         self$prefix = "POL"
      }
   )
)
