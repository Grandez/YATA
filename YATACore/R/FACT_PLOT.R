# Plot type
FACT_PLOT <- R6::R6Class("FACT_PLOT",
    public = list(
        value  = 0
        ,name   = "None"
        ,select = TRUE  # Para el combo, acepta cambiar el target
        ,size   =  5
        ,NONE   =  0
        ,LINE   =  1
        ,LOG    =  2
        ,CANDLE =  3
        ,BAR    =  4
        ,POINT  =  5
        ,names  = c("Line", "Log", "Candle", "Bar", "Point")
        ,initialize = function(tgt = 0) { self$value = as.integer(tgt) }
        ,print = function() { cat(self$value) }
        ,setValue = function (val) {
            nVal       = as.integer(val)
            self$value = nVal
            self$name  = self$names[nVal]
        }
        ,getName = function(id = 0) {
            if (id == 0) id = self$value
            self$names[id]
        }
        ,getCombo = function(none = F) {
            start = ifelse(none, 0, 1)
            nm = self$names
            if (none) nm = c("None", nm)
            values = seq(start, self$size)
            names(values) = nm
            values
        }
    )
)


