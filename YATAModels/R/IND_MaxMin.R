library(R6)
IND_MaxMin <- R6Class("IND_MaxMin", inherit=YATAIndicator,
   public = list(
        name="Max-Min"
       ,symbolBase="MM"
       ,symbol="MM"
       ,calculate = function(data) {
           browser()
       }
       # ,calculateAction    = function(case, portfolio) {
       #     lInd = self$getIndicators()
       #     ind  = lInd[[self$symbol]]
       #     dfi  = as.data.frame(ind$result[[1]])
       #     dft  = case$tickers$df
       #
       #     fila     = case$current
       #     pCurrent = dft[fila, DF_PRICE]
       #     pInd     = dfi[fila, 1]
       #
       #     if (is.na(pInd) || pInd == 0 || pCurrent == pInd) return (c(0,100,100))
       #
       #     var = pCurrent / pInd
       #     if (var == 1) return (c(0,100,100))
       #
       #     prf = case$profile$profile
       #     thres = ifelse(var > 1,private$thresholds[["sell"]],private$thresholds[["buy"]])
       #     action = applyThreshold(prf, var, thres)
       #     action
       # }
       # ,calculateOperation = function(portfolio, case, action) {
       #     reg = case$tickers$df[case$current,]
       #     cap = portfolio$saldo()
       #     pos = portfolio$getActive()$position
       #     sym = case$config$symbol
       #
       #     # Por temas de redondeo, el capital puede ser menor de 0
       #     if (action[1] > 0 && cap  > 1)  return (YATAOperation$new(sym, reg[1,DF_DATE], cap,      reg[1,DF_PRICE]))
       #     if (action[1] < 0 && pos  > 0)  return (YATAOperation$new(sym, reg[1,DF_DATE], pos * -1, reg[1,DF_PRICE]))
       #     NULL
       # }
       ,initialize         = function(parms=NULL,thres=NULL) { super$initialize(parms,thres) }
    )
    ,private = list(
        maxmin = function(data, extreme=T) {
        df = data$df[,data$PRICE]
        Mm = rollapply(df,3,FUN=.detect_max_min,fill=0,align="center")

        # Tratamiento de infinitos
        if (sum(Mm ==  Inf) > 0) Mm <- process_inf(df,Mm,which(Mm ==  Inf), "left")
        if (sum(Mm == -Inf) > 0) Mm <- process_inf(df,Mm,which(Mm == -Inf), "right")
        list(Mm)
        }

# Los maximos son para un rango dado, aquellos por encima del mayor de los minimos
# Lo minimos a la inversa
# Si dos de lostres puntos son iguales, devuelve +/- Inf para procesarlos despues

,.detect_max_min = function(x) {
    if (x[2] > x[1] && x[2] > x[3]) return( x[2])
    if (x[2] < x[1] && x[2] < x[3]) return(-x[2])
    if (x[2] == x[1]) {
        if (x[2] > x[3]) return(+Inf)
        if (x[2] < x[3]) return(-Inf)
    }
    if (x[2] == x[3]) {
        if (x[2] > x[1]) return(+Inf)
        if (x[2] < x[1]) return(-Inf)
    }
    return(0)
}

# Detecta los maximos y minimos relativos
# En caso de alineacion, se marca el especificado en align

,process_inf = function(data, Mm, rows, align) {
    beg = rows[1]
    end = rows[2]
    left = data[beg - 1,1]
    i = 2
    while ( i <= length(rows)) {
        if (i < length(rows) && (rows[i] - rows[i - 1]) == 1) {
            end = rows[i]
        }
        else {
            Mm[beg:end] = 0
            if (rows[i] < length(Mm)) {
                right = data[end + 1,1]
                val = 0
                if (left < data[beg,1] && data[beg,1] > right) val = data[beg,1]
                if (left > data[beg,1] && data[beg,1] < right) val = data[beg,1] * -1
                if (val != 0) {
                    if (align == "left") {
                        Mm[beg] = val
                    }
                    else {
                        Mm[end] = val
                    }
                }
            }
            beg=rows[i]
        }
        i = i + 1
    }
    Mm

}

,MaxMin2 = function(data) {
    data$Mm = rollapply(c(data$precio, data$Mm),4,function(x, y) {detect_max_min(x)}
                        ,fill=0,align="right",by.column=T)
    data
}

    )
)


