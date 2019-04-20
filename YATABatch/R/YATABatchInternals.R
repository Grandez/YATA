# Clase base de los ficheros


prepareCases <- function(ids, dbCases) {
   dfTotal = NULL
   tbCases = dbCases$getTable(TCASES_CASES)
   tbIndex = DBCTC$getTable(TCTC_INDEX)

   if (!is.null(ids)) { tbCases$filterByID(ids) }

   for (iCase in 1:nrow(tbCases$df)) {
       tbIndex$setRange(tbCases$df[iCase,tbCases$FROM], tbCases$df[iCase,tbCases$TO])
       for (iCurrency in 1:nrow(tbIndex$df)) {
           df = .makeIntervals(tbIndex$df[iCurrency, tbIndex$SYMBOL], tbCases, iCase) 
           df[,"Name"]     = tbIndex$df[iCurrency, tbIndex$NAME]
           df[,"Symbol"]   = tbIndex$df[iCurrency, tbIndex$SYMBOL]
           df[,"idTest"]   = tbCases$df[iCase,     tbCases$ID]
           df[,"Capital"]  = tbCases$df[iCase,     tbCases$CAPITAL]
           df[,"Model"]    = tbCases$df[iCase,     tbCases$MODEL]

           if (is.null(dfTotal)) {
               dfTotal = df
           }
           else {
               dfTotal = rbind(dfTotal, df)
           }
       }
   }
   dfTotal
}

.makeIntervals <- function(symbol, tbCases, idx) { # ...) {
    # prms = list(...)[[1]]

    tbTickers = TBLTickers$new(symbol)
    beg       = as.date(tbTickers$getField("FIRST", tbTickers$DATE))
    last      = as.date(tbTickers$getField("LAST",  tbTickers$DATE))
    
    if(!is.na(tbCases$df[idx,tbCases$START])) beg=as.date(tbCases$df[idx,tbCases$START])

    prf   = .expandNumber(tbCases$df[idx,tbCases$PROFILE])
    per   = .expandNumber(tbCases$df[idx,tbCases$PERIOD])
    start = .expandMonth (beg,last,tbCases$df[idx,tbCases$INTERVAL])
    
    cols  = list(prf, start, per)
    colNames = c(tbCases$PROFILE, tbCases$START, tbCases$PERIOD)

    if(!is.na(tbCases$df[idx,tbCases$LBL_PARMS])) {
       parms  = tbCases$getGroupFields(tbCases$GRP_PARMS)
       pNames = strsplit(tbCases$df[idx,tbCases$LBL_PARMS], ";")[[1]]

       iPrm = 1
       for (nPrm in pNames) {
           prm   = .expandNumber(tbCases$df[idx, parms[[iPrm]]])
           cols = list.append(cols, prm)
           colNames = c(colNames, paste0(tbCases$GRP_PARMS,nPrm))
           iPrm = iPrm + 1
       }
    }
    
    if(!is.na(tbCases$df[idx,tbCases$LBL_THRES])) {
       thres  = tbCases$getGroupFields(tbCases$GRP_THRES)
       pThres = strsplit(tbCases$df[idx,tbCases$LBL_THRES], ";")[[1]]

       iThr = 1
       for (nThr in pThres) {
           thr   = .expandNumber(tbCases$df[idx, thres[[iThr]]])
           cols = list.append(cols, thr)
           colNames = c(colNames, paste0(tbCases$GRP_THRES,nThr))
           iThr = iThr + 1
       }
    }
    
    gr = expand.grid(cols)
    df = data.frame(gr)
    colnames(df) = colNames
    
    # El calculo de la fecha fin se debe hacer cuando ya esta expandido
    colEnd = as.mondate(eval(tbCases$asExpr(tbCases$START))) + eval(tbCases$asExpr(tbCases$PERIOD))
    df = add_column(df, End = as.date(colEnd), .after = tbCases$START)
    df
}
.expandNumber <- function(num) {
    toks=strsplit(as.character(num), ";")[[1]]
    toks = as.numeric(toks)
    if (length(toks) == 1) toks = c(toks, toks)
    if (length(toks)  < 3) toks = c(toks, 1)
    seq(from=toks[1],to=toks[2], by=toks[3])
}

.expandMonth <- function(beg, end, interval) {
    if (interval == 0) return(beg)
    seq(from=beg, to=end, by=paste(interval, "months"))
}

