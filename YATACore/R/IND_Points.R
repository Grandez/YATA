MAXMIN <- function(data, extreme=T) {
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

.detect_max_min <- function(x) {
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

process_inf <- function(data, Mm, rows, align) {
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

MaxMin2 <- function(data) {
    data$Mm = rollapply(c(data$precio, data$Mm),4,function(x, y) {detect_max_min(x)}
                        ,fill=0,align="right",by.column=T)
    data
}


