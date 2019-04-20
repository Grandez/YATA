YATAPortfolio <- R6Class("YATAPortfolio",
     public = list(
         initialize          = function(currency="EUR", active = NULL) {
             if (!is.null(active) && !("YATAActive" %in% c(class(active)))) {
                  stop(MSG_BAD_CLASS("YATAActive"))
             }
             self$addActive(YATAActive$new(currency))
             private$position = TBLPosition$new(currency, active$name)
         }
         ,getActive          = function(moneda=NULL) {
             if (is.null(moneda)) moneda = private$moneda
             if (!(moneda %in% names(private$activos))) return (NULL)
             return (private$activos[[moneda]])
         }
         ,addActive          = function(active = NULL) {
             if (is.null(active))                         stop(MSG_BAD_CLASS("NULL"))
             if (!("YATAActive" %in% c(class(active))))   stop(MSG_BAD_CLASS("YATAActive"))
             #if (active$idName %in% names(private$activos)) return (invisible(self))

             nm <- names(private$activos)

             if(is.null(nm)) {
                 nm = active$name
             }
             else {
                 nm = c(nm, active$name)
             }
             private$activos <- c(private$activos, active)
             names(private$activos) = nm
             # El activo por defecto es el ultimo
             private$moneda       = active$name
             private$position$CTC = active$name
             invisible(self)
         }
         ,flowFIAT           = function(fecha = NULL, uds = NULL) {
             private$flowCapital(fecha, uds)
         }
         ,flowTrade          = function(oper=NULL) {
             if (is.null(oper))              return(oper)
             if (oper$status == OP_EXECUTED) return(oper)
             active = self$getActive()

             if (is.null(active)) self$addActive(Active$new(oper$currency))

             oper$order = active$addFlow(oper$operDate, oper$units, oper$price)
             private$flowCapital(oper$operDate, oper$amount)
             oper$status = OP_EXECUTED
             active$getOperations()
         }
         ,updatePosition     = function(case) {
             if (case$current == 0) return (NULL)
             reg = case$getCurrentTicker()
             aa  = self$getActive()            # Monedas
             ee  = self$getActive(case$config$currency)    # Euros
             pp  = aa$position * reg[1,DF_PRICE]
             bb  = ee$balance + pp
             private$position$add(reg[1,DF_DATE], ee$balance, aa$position, bb)
             self$getPositionHistory()
         }
         ,getPosition        = function (value) {
             if (!missing(value)) stop(MSG_METHOD_READ_ONLY("Position"))
             private$position$getPosition()
         }
         ,getPositionHistory = function (value) {
             if (!missing(value)) stop(MSG_METHOD_READ_ONLY("Position"))
             private$position
         }
         ,saldo              = function (value) { if (!missing(value)) stop(MSG_METHOD_READ_ONLY("Saldo"))
             self$getActive(CURRENCY)$position
         }
         ,getBalance         = function (value) {
             if (!missing(value)) stop(MSG_METHOD_READ_ONLY("Balance"))
             if (is.null(private$activos)) return(0)
             sum(sapply(private$activos, function(x) { x$balance }))
         }
         ,getTrading         = function(currency = NULL) {
             self$getActive(currency)$getOperations()
         }
         ,operNum            = function(moneda) {
             private$activos[[moneda]]$operNum()
         }
         ,print              = function() {
             if (length(private$activos) == 0) return(MSG_NO_ACTIVES())
             for (a in private$activos) {
                  cat(a$print())
             }
         }
     )
     ,private = list(moneda = NULL, activos = list()
          ,position = NULL
          ,flowCapital = function(fecha, uds) {
              private$activos[[CURRENCY]]$addFlow(fecha, uds, 1)
          }
     )
)
