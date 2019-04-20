if (!require("pacman")) install.packages("pacman")
pacman::p_load("zoo")
pacman::p_load("PoloniexR")


lastError = NULL

#' @export
getLastError = function() { lastError }

#' @export
getTickers = function() {
  POL.GetTickers()
}

#' @export
getHistorical = function(base, counter, from, to=NULL, period=NULL) {
  .POLGetHistorical(base, counter, from, to, period)
}
