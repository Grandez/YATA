.makeIntervals <- function(symbol, TBCases, ...) {
    prms = list(...)[[1]]

    data = loadSymbolData(symbol)
    beg=as.Date(ifelse(is.na(prms[[CASE_START]]), data[1,CTC_DATE], as.character(prms[[CASE_START]])))
    
    last= as.Date(as.character(data[nrow(data),CTC_DATE]))

    prf   = .expandNumber(prms[[CASE_PROFILE]])
    per   = .expandNumber(prms[[CASE_PERIOD]])
    start = .expandMonth(beg,last,prms[[CASE_INTERVAL]])
    cols  = list(prf, start, per)
    colNames = c(CASE_PROFILE, CASE_START, CASE_PERIOD)

    parms = TBCases$getGroupFields(CASE_GRP_PARMS)
    for (parm in parms) {
        if (is.na(prms[[parm]])) break;
        prm   = .expandNumber(prms[[parm]])
        cols = list.append(cols, prm)
        colNames = c(colNames, parm)
    }
    
    gr = expand.grid(cols)
    df = data.frame(gr)
    colnames(df) = colNames
    
    # El calculo de la fecha fin se debe hacer cuando ya esta expandido
    colEnd = as.mondate(eval(TBCases$fieldExpr(CASE_START))) + eval(TBCases$fieldExpr(CASE_PERIOD))
    df = add_column(df, End = as.Date(colEnd), .after = CASE_START)
    df
}
.expandNumber <- function(num) {
    toks=strsplit(as.character(num), ";")[[1]]
    toks = as.integer(toks)
    if (length(toks) == 1) toks = c(toks, toks)
    if (length(toks)  < 3) toks = c(toks, 1)
    seq(from=toks[1],to=toks[2], by=toks[3])
}

.expandMonth <- function(beg, end, interval) {
    if (interval == 0) return(beg)
    seq(from=beg, to=end, by=paste(interval, "months"))
}

.createProfile <- function(record) {
    profile = YATAProfile$new()
    profile$name = "Batch"
    profile$profile = record[1,CASE_PROFILE]
    profile$scope=record[1,CASE_SCOPE]
    profile$saldo=record[1,CASE_CAPITAL]
    profile
}

.createConfig <- function(record) {
    config = YATAConfig$new()
    config$symbol  = record[1,CASE_SYM_SYM]
    config$from    = record[1,CASE_START]
    config$to      = record[1,CASE_END]
    config$initial = record[1,CASE_CAPITAL]
    config
}

.createData <- function(record) {
    data = YATAData$new()
    data$name   = record[1,CASE_SYM_NAME]
    data$symbol = record[1,CASE_SYM_SYM]
    data$start  = record[1,CASE_START]
    data$end    = record[1,CASE_END]

    df = loadSymbolData(data$symbol)
    tgt = df %>% filter(Date >= data$start, Date <= data$end)

    # Verificar rango de datos
    if ((nrow(tgt) / (record[1,CASE_PERIOD] * 30)) < MIN_PERCENTAGE) return (NULL)
    data$dfa = df
    data
}

.createModel <- function(record) {
    name=record[1,CASE_MODEL]
    if (!is.na(record[1,CASE_VERSION])) name = paste(name,record[1,CASE_VERSION],sep=".")
    model = loadModel(name)
    model$setParameters(as.vector(record[1, grep(CASE_GRP_PARMS, colnames(record))]))
    model
    
#    base=eval(parse(.makeDir(DIRS["models"],"Model_Base.R")))
#    file=.makeDir(DIRS["models"], paste(paste("Model_",name,sep=""),"R",sep="."))
#    mod=eval(parse(file))
#    model = eval(parse(text=paste(MODEL_PREFIX, name, "$new()", sep="")))
#    model     
}

