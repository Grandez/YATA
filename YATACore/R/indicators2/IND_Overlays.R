#' # Overlays are best characterized by their scale.
#' # Overlays typically have the same or similar scale to the
#' # underlying asset and are meant to be laid over to chart of price history
#'
#' #Common examples are the simple
#' #moving average, Bollinger Bands, and volume-weighted average price
#'
#' # Single mobile average
#' #' @export
#' SMA    <- function(data, ind, columns, n=7) {
#'     res = rollapply(data$df[,data$PRICE],n,mean,fill=NA, align="right")
#'     df = as.data.frame(res)
#'     colnames(df) = columns
#'     df
#' }
#' BBands <- function(data, ind, columns, n, sd) {
#'     xt=.getXTS(data)
#'     res = TTR::BBands(xt,n, "SMA", sd)
#'     .setDF(res, columns)
#' }
#' ALMA   <- function(data, ind, columns, n, offset, sigma) {
#'     xt=.getXTS(data)
#'     res = TTR::ALMA(xt,n,offset,sigma)
#'     .setDF(res, columns)
#' }
#' EMA    <- function(data, ind, columns, n, wilder=FALSE) {
#'     xt=.getXTS(data)
#'     res = TTR::EMA(xt,n,wilder)
#'     .setDF(res, columns)
#' }
#' DEMA   <- function(data, ind, columns, n, v, wilder=FALSE) {
#'     xt=.getXTS(data)
#'     res = TTR::DEMA(xt,n,v,wilder)
#' }
#'
#' .getXTS <- function(data) {
#'     df = data$getData()
#'     xts::xts(df[,data$PRICE], order.by = df[,data$DATE])
#' }
#'
#' .setDF <- function(res, columns) {
#'     df = as.data.frame(res)
#'     colnames(df) = columns
#'     df
#' }
