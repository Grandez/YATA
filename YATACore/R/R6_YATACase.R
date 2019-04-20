# Caso
# Contiene:
#  - Una configuracion inicial
#  - Un modelo
#  - Una posible operacion pendiente (o ejecutada)
#  - los datos de trabajo
#

YATACase <- R6Class("YATACase",
    public = list(
         profile  = NULL    # Investor attributes
        ,tickers  = NULL    # Data
        ,model    = NULL    # Modelo activo
        ,config   = NULL    # Configuration
        ,oper  = NULL       # Orden a procesar/procesada
        ,current = 0        # Registro actual
        ,trend = 0.0        # Tangente de la linea
        ,date = Sys.Date()  # Execution date
        ,hasNext          = function() { (self$current < self$getNumTickers()) }
        ,getNumTickers    = function() { nrow(self$tickers$df)                 }
        ,getCurrentTicker = function() { self$tickers$df[self$current,]        }
        ,getCurrentData   = function(asClass=F) {
            if (!asClass) return  (self$tickers$df[1,self$current])
            tmp = self$tickers$clone()
            tmp$filterByRows(1,self$current)
            tmp
        }
    )
)
