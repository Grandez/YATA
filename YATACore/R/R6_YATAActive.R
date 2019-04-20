YATAActive <- R6Class("YATAActive",
     private = list( opers    = NULL    # Operaciones
     ),
     public = list(
          name     = NULL    # Name looks like launch print
         ,position = 0.0     # Unidades
         ,balance  = 0       # Valor
         ,last     = 0.0     # Ultimo precio
         ,initialize     = function(name) {
             if (missing(name)) stop(MSG_NO_NAME("Active"))
             self$name = name
             private$opers = TBLOperation$new()
         }
         ,addFlow        = function(date = NULL, uds = NULL, price = NULL) {
             if (is.null(date) || is.null(uds) || is.null(price)) stop(MSG_BAD_ARGS())
             private$opers$add(date, uds, price);
             self$position = self$position + uds
             self$balance  = self$position * price
             invisible(self)
         }
         ,getOperations  = function(value) {
             if (!missing(value)) stop(MSG_METHOD_READ_ONLY("Operations"))
             private$opers
         }
         ,getLastTrading = function(value) {
             if (!missing(value)) stop(MSG_METHOD_READ_ONLY("getLastTrading"))
             private$opers$getLast()
         }
         ,print          = function() {
             cat(sprintf("%s:\t %f\n",self$name, self$position))
         }
     )
     ,active = list(
         movimientos = function(value) {
             if (!missing(value))  stop(MSG_METHOD_READ_ONLY("Flows"))
             as.data.frame(private$.opers[-1,])
         }
     )
)
