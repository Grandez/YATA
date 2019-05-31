source("R/IND_MA.R")

IND_SMA <- R6Class("IND_SMA", inherit=IND_MA,
   public = list(
       # Es mas comodo sobreescribir las variables
        name="Media movil simple"
       ,symbol="SMA"
       ,initialize = function(parms=NULL) { super$initialize(parms) }
       ,calculate = function(TSession) {
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
       }
       ,plot = function(p, xAxis) {
           browser()
           # val = private$model %>% fitted.values()
           line.attr=list( color=self$plot.attr[["colors"]][1]
                           , width=self$plot.attr[["sizes"]][1])
           p = p %>% add_trace(x=xAxis, y=private$dfData[,1], line=line.attr, type="scatter", mode="lines")
           p
       }

   )
   ,private = list(

   )

)


