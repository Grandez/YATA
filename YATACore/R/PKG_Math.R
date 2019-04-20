#' @description Calcula la distancia de un punto a una recta
#' @export
#'


dist <- function(recta, punto) {
    num = abs((recta[2] * punto[1]) - punto[2] + recta[1])
    den = sqrt(recta[2]^2 + 1)
    num /den
}
