source("R/IND_MA.R")

IND_SMA <- R6Class("IND_SMA", inherit=IND_MA,
   public = list(
       # Es mas comodo sobreescribir las variables
        name="Media movil simple"
       ,symbol="SMA"
       ,initialize = function(parms=NULL) { super$initialize(parms) }
       ,calculate  = function(TSession) {
           xt=private$getXTS(TSession)

           name  = toupper(self$target$getName())
           ucols = toupper(colnames(xt))
           pos   = which(ucols == name)
           win   = private$parameters[["window"]]

           sma = TTR::SMA(xt[,pos] ,n=win)
           var = ((xt[,pos] / sma) - 1) * 100
           if (is.null(private$dfData)) {
               private$dfData = as.data.table(sma, keep.rownames = F)
               private$dfVar  = as.data.table(var, keep.rownames = F)

           }
           else {
               private$dfData = cbind(private$dfData, as.data.table(sma, keep.rownames = F))
               private$dfVar  = cbind(private$dfVar,  as.data.table(var, keep.rownames = F))
           }
           private$dfData[, ncol(private$dfData)] = as.fiat(private$dfData[, ncol(private$dfData)])
           private$dfVar [, ncol(private$dfVar)]  = as.percentage(private$dfVar[, ncol(private$dfVar)])
       }
       ,plot = function(p, xAxis) {
           YATACore::plotLine(p, x=xAxis, y=private$dfData[,1], attr=private$line.attr, title = self$symbol)
       }

   )
   ,private = list(
       line.attr = list( color="rgb(22, 96, 167)"
                        ,width = 1
                        ,dash = "dash"
                    )
   )

)


