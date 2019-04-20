library(stringr)

YATACOUNT = 1

#' @export
getYATAID = function() {
    YATACOUNT = YATACOUNT + 1
    base = as.numeric(Sys.time()) * 1000
    base + (YATACOUNT %% 1000)
}
#' @export
AND = function(a, b) { (bitwAnd(a, b) > 0)  }
EQU = function(a, b) { (bitwAnd(a, b) == b) }

#' @export
as.column = function(name) { return(eval(parse(text=name))) }

#' @export
setDataType <- function(type, value) {
    l = list()
    for (i in 1:length(type)) {
        if (type[i] == TYPE_STR)  l = c(l, value[i])
        if (type[i] == TYPE_DEC)  l = c(l, as.numeric(value[i]))
        if (type[i] == TYPE_INT)  l = c(l, as.integer(value[i]))
        if (type[i] == TYPE_LONG) l = c(l, as.integer(value[i]))
    }
    if (length(l) == 1) return (l[[1]])
    l
}

getDataType <- function(value) {
    type = TYPE_STR
    if ("integer" %in% class(value)) type = TYPE_INT
    if ("numeric" %in% class(value)) type = TYPE_DEC
    type
}

#' @export
linearTrend = function(data) {
    lm(data ~ c(1:nrow(data)))$coefficients[2]
}

#' @export
angleTrend = function(data) {
    atan(linearTrend(data) * nrow(data)) * 180 / pi
}

#' @export
calculateTrendAngle = function(data, window) {
    browser()
    rollapply(data, window, angleTrend, fill=0, align="right")
}

as.date = function (item) {
    as.Date(item, tz="CET")
}
#' @export
filePath <- function(..., name=NULL,ext=NULL) {
    args=list(...)[[1]]
    if (length(args>0)) txt=args[1]
    i=1
    while (i < length(args)) {
        txt = paste(txt,args[i],sep="/")
        i = i +1
    }
    if (!is.null(name)) txt=paste(txt,name,sep="/")
    if (!is.null(ext))  txt=paste(txt,ext ,sep=".")
    txt
}

.translateText <- function(text,case) {
    res = str_match(text, "#.+#")
    if (is.na(res[1,1])) return(text)
    toks =unlist(strsplit(res[1,1],","))
    toks = unique(unlist(lapply(toks, trimws)))
    tmp = text
    for (i in 1:length(toks)) {
        tmp = .replaceText(tmp, toks[1], case)
    }
    tmp
}

.replaceText <- function(text, tok, case) {
    word = switch( gsub("#","",tok)
                  ,"MODEL" = case$model$symbolBase
                  ,"SYM" = case$config$symbol
                  )
    gsub(tok,word,text)
}
