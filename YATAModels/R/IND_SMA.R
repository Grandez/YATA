source("R/IND_MA.R")

IND_SMA <- R6Class("IND_SMA", inherit=IND_MA,
   public = list(
         name="Media movil simple"
        ,symbol="SMA"
        ,initialize = function() {
           super$initialize(list(window=7))
           ind1 = YATAIndicator$new( self$name, self$symbol, type=IND_LINE, blocks=3
                                    ,parms=list(window=7))
           private$addIndicators(ind1)
        }
       ,calculate = function(data, ind) {
           browser()
           if (ind$name != self$symbol) return (super$calculate(data, ind))
           xt=private$getXTS(data)
           n      = private$parameters[["window"]]
           res1 = TTR::SMA(xt[,data$PRICE] ,n)
           res2 = TTR::SMA(xt[,data$VOLUME],n)

           list(list(private$setDF(res1, ind$columns)), list(private$setDF(res2, paste0(ind$columns, "_v"))))
        }
   )

)


