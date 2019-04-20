IND_EMA <- R6Class("IND_EMA", inherit=IND_MA,
    public = list(
       name="Media movil Exponencial"
       ,symbol="EMA"
       ,initialize = function() { super$initialize() }
       ,calculate = function(TTickers, date) {
           window = self$getParameter("window")
           xt     = private$getXTS(TTickers, pref=window)
           if (nrow(xt) < window) return (NULL)
           EMA = TTR::EMA(xt[,TTickers$PRICE], n=window, wilder=FALSE)
           private$data = as.data.frame(EMA[(window + 1):nrow(EMA),])
           private$calcVariation("EMA")
           private$setColNames()
       }
       ,plot = function(p, TTickers) {
           if (nrow(private$data) == 0) return(p)
           col1 = private$setColNames(self$symbol)
           YATACore::plotLine(p, TTickers$df[,self$xAxis], private$data[,col1],hoverText=self$symbol)
       }

   )
)
