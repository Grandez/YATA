# Crea el df de indicadores con los datos comunes

indBase <- function(data, modelo) {
    d = data[,c("orden","Date",modelo$col.precio,"Volume")]
    colnames(d) <- c("orden", "fecha", "precio", "volumen")
    d$fecha = as.Date(d$fecha)
    d$pmm = 0
    d$oper = 0
    v0 <- rollapply(d$precio, 2
                    , function(x) return (((x[2] / x[1]) - 1) * 100)
                    , fill=NA, align="right")
    
    cbind(d, v0)
}
