# El Modelo es un conjunto de indicadores que se aplican en tres ambitos:
# Largo - Medio - Corto
# Largo me indica que NO puedo hacer
# Medio me indica si pasar o si hacer lo que me esta permitido
# Corto elige el momento de ejecutar la accion

YATAModel <- R6::R6Class("YATAModel",
    public = list(
         id         = NULL
        ,parent     = 0
        ,name       = "Abstract Base Model"
        ,desc       =  NULL
        ,scope      =  SCOPE_DAY
        ,calculated = FALSE
        ,initialize = function(idModel) { self$id = idModel }

        ,addIndicator  = function(ind, term) {
            if (term == TERM_SHORT)  private$indShort  = c(private$indShort,  ind)
            if (term == TERM_MEDIUM) private$indMedium = c(private$indMedium, ind)
            if (term == TERM_LONG)   private$indLong   = c(private$indLong,   ind)
            invisible(self)
        }
        ,calculateIndicators = function(data, term = TERM_ALL, date = NULL, force=F) {
            if (!self$calculated || force) {
                self$calculated = TRUE
                if (bitwAnd(term, TERM_SHORT)  > 0) private$calcInd(data$getTickers(TERM_SHORT),  date, TERM_SHORT )
                if (bitwAnd(term, TERM_MEDIUM) > 0) private$calcInd(data$getTickers(TERM_MEDIUM), date, TERM_MEDIUM)
                if (bitwAnd(term, TERM_LONG)   > 0) private$calcInd(data$getTickers(TERM_LONG),   date, TERM_LONG  )
            }
            invisible(self)
         }
        ,getIndicators = function(term) {
            lista = list()
            if (term == TERM_SHORT)  lista = private$indShort
            if (term == TERM_MEDIUM) lista = private$indMedium
            if (term == TERM_LONG)   lista = private$indLong
            lista
        }

        ,plotIndicators            = function(term, plots, data, names, hover) {
            if (!self$calculated) self$calculateIndicators(data, term)
            TTickers = data$getTickers(term)
            lista = self$getIndicators(term)
            # for (name in names) {
            #     ind = private$indicators[[name]]
            #     plotFunc = ind$plot
            #     if (is.numeric(plotFunc)) plotFunc = PLOT_FUNC[plotFunc]
            #     plots = do.call(plotFunc, list(data, ind, plots))
            # }
            idx = 1
            while (idx <= length(lista)) {
                ind = lista[[idx]]
                plots[[ind$idPlot]] = ind$plot(plots[[ind$idPlot]], TTickers)
                idx = idx + 1
            }
            plots
        }

        ###############################################################
        # Abstract functions
        ###############################################################

        ,calculateAction    = function(portfolio, case, reg)       { stop("This method is virtual") }
        ,calculateOperation = function(cartera, caso, reg, action) { stop("This method is virtual") }

         ###############################################################
         # Generic functions
         ###############################################################

        ,getParameters     = function()   { private$parameters }
        ,getThresholds     = function()   { private$thresholds }
        ,getIndicatorsName = function()   { nm = unlist(names(private$indicators))
                                           tt = unlist(sapply(private$indicators, function(x) {x$title}))
                                           names(nm) = tt
                                           as.list(nm)
        }

        ,print          = function()      { cat(self$name)  }
        # ,setParameters  = function(parms) { private$parameters = parms }
        # ,setThresholds  = function(thres) { private$thresholds = thres }
        # ,setParametersA = function(parms, pat) {
        #     private$parameters = private$updateList(private$parameters, parms, pat) }
        # ,setThresholdsA = function(thres, pat) {
        #     private$thresholds = private$updateList(private$thresholds, thres, pat) }

    )
   ,private = list(
         indShort  = list()
        ,indMedium = list()
        ,indLong   = list()
        ,indicators = list()

        ###############################################################
        # Private Generic Methods
        ###############################################################
        ,calcInd = function(TTickers, date, term) {
            if (term == TERM_SHORT ) {inds = private$indShort  }
            if (term == TERM_MEDIUM) {inds = private$indMedium }
            if (term == TERM_LONG  ) {inds = private$indLong   }
            ##JGG Todavia me faltan datos
            for (ind in inds)        {
                if (!is.null(TTickers) && nrow(TTickers$df) > 0) ind$calculate(TTickers, date)
            }
        }
        ,addIndicators = function(...) {
            input = list(...)
            names(input) = lapply(input,function(x) {x$name})
            private$indicators = c(private$indicators, input)
        }
        ,calcIndicators = function(data, scope) {
            if (bitwAnd(scope, private$calculated) == 0) {
                for (ind in private$indicators) {
                    if (ind$scope == scope) ind$result = self$calculate(data, ind)
                }
            }
            private$calculated = bitwOr(private$calculated, scope)
        }
        ,updateList = function(l, values, pat) {
            names = gsub(pat, "", names(values))
            for (i in 1:length(values)) {
                l[[names[i]]] = values[[i]]
            }
            l
        }
   )
)

