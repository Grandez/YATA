TREND <- function(data=NULL, ind=NULL, columns=NULL) {
  modLM = lm(Price ~ Order, data=data$df)
  pred = predict(modLM, data$df)
  list(list(pred))
}
