# Accumulators depend on the value of itself in past periods to calculate future values.
# This is different from most indicators that depend only on price history, not indicator history.
# They have the advantage of being windowlengthindependent in that the user does not specify any n periods
# in the past to be computed. This is an advantage purely on the level of robustness and mathematical elegance.
# They are very often volume-oriented.
# Examples are On-Balance Volume, Negative Volume Index, and the Accumulation/Distribution Line.
# Rule sets typically concentrate on the relationship between the accumulator and an average or
# maximum of itself. Here’s an example: If the Negative Volume Index crosses above a moving average of itself,
# buy the stock at market price.

# LM <- function(data,interval=7) {
#     res = rollapply(data$df[,data$PRICE],interval,mean,fill=NA, align="right")
#     as.data.frame(res)
# }
