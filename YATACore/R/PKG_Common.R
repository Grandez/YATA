# Aplica el threshold si procede
# threshold esta en 0-100 (pasar a porc)
# Si DARED no se mira

applyThreshold = function(prf, var, threshold) {
    tipo = ifelse(var > 1, -1, 1)
    if (prf == PRF_DARED) return(c(tipo,0,0))
    if (var > 1) var = var - 1
    if (var < 1) var = 1 - var

    if (var < threshold) return (c(0,0,0))
    tipo = tipo * cut(var / threshold, breaks=c(0.9,1.5,2,3,4,+Inf ), labels=FALSE)
    return (c(tipo,0,0))
}

SplineSmooth <- function(formula, data, weights, span = 0.5, ...) {
   pred <- smooth.spline(data$x, data$y, df = length(data$y)*span,...)$y
   # print(pred[1:10])
   model <- list(x = data$x, pred = pred)
   class(model) <- "my_smooth"
   model
}
predictdf.my_smooth <- function(model, xseq, se, level) {
   data.frame(x = model$x, y = model$pred)
}

calculateChange <- function(x) {
    if (x[1] == 0) return (0)
    return ((x[2] / x[1]) - 1)
}
