# Overlays are best characterized by their scale.
# Overlays typically have the same or similar scale to the
# underlying asset and are meant to be laid over to chart of price history

#Common examples are the simple
#moving average, Bollinger Bands, and volume-weighted average price

# Single mobile average
#' @export
SMA <- function(data,interval=7) {
    res = rollapply(data$df[,data$PRICE],interval,mean,fill=NA, align="right")
    as.data.frame(res)
}


#' @description Calculate the best spline line for the data
#' @param data    Values to spline
#' @param ind     Not used
#' @param columns Not used
SPLINE <- function(data=NULL, ind=NULL, columns=NULL) {
  res1 = supsmu(data$df[,data$ORDER], data$df[,data$PRICE])
  res2 = supsmu(data$df[,data$ORDER], data$df[,data$VOLUME])
  list(list(res1[["y"]]), list(res2[["y"]]))
}
