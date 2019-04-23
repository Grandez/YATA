if("YATACore" %in% (.packages()))
    detach(name="package:YATACore", unload=T, character.only = T, force = T)
if("YATAProviders" %in% (.packages()))
    detach(name="package:YATAProviders", unload=T, character.only = T, force = T)

# Common
library("dplyr")
library("lubridate")

library("YATACore")
library("YATAProviders")

#' @export
#' @param pairs Intenta recuperar todas las combinaciones
#'              Por defecto solo las activas
#' @param provider Indica el proveedor, por defecto todos

retrieveSessions = function(all.pairs = F, provider=NULL) {
    providers = provider
    if (is.null(providers)) {
      TProviders = TBLProviders$new()
      providers = TProviders$df[, TProviders$SYMBOL]
      for (provider in providers) {
        if (provider == "POL") .getSessionByProvider(provider, all.pairs)
      }
    }
}

#' @export
groupSessions = function() {
  loadWeeks()
  loadMonths()
}
.getSessionByProvider = function(provider, all.pairs) {
    TPairs = .getPairs(provider, all.pairs)
    .loadSessions(provider, TPairs)
    groupSessions()
}

.getPairs = function(provider, all.pairs) {
    TPairs = TBLPairs$new()
    pairs = TPairs$getByClearing(provider)

    if (all.pairs) {
       TFiat = TBLFiat$new()
       TCTC  = TBLCTC$new()
       pairsAll = merge(TFiat$df[,TFiat$SYMBOL],TCTC$df[,TCTC$SYMBOL],all=TRUE)
       colnames(pairsAll) = c("BASE", "COUNTER")
       pairsAll$CLEARING = provider
       pairs = merge(pairs, pairsAll, by=c("CLEARING", "BASE", "COUNTER"), all.x=T)
    }
    TPairs$df = pairs
    TPairs
}

.loadSessions = function(provider, TPairs) {
     reg = 0

     while (reg < nrow(TPairs$df)) {
       reg     = reg + 1
       base    = TPairs$df[reg, TPairs$BASE]
       counter = TPairs$df[reg, TPairs$COUNTER]
       tms     = TPairs$df[reg, TPairs$LAST_UPD]

       cat(sprintf("%s - Retrieving %s/%s\n", format(Sys.time(), "%X"), base, counter))
       YATACore::beginTrx(T)
       maxTMS = tms
       tms = tms + 1

       for (per in c("2H", "4H", "D")) {
           if (per == "2H") table = "POL_TICKERSH2"
           if (per == "4H") table = "POL_TICKERSH4"
           if (per == "D")  table = "POL_TICKERSD1"

           df = YATAProviders::getHistorical(base=base,counter=counter,from=tms,period=per)
           if (!is.null(df) && nrow(df) > 0) {
               tmpTMS = max(df$TMS)
               if (tmpTMS > maxTMS) maxTMS = tmpTMS
               YATACore::writeTable(table, df, FALSE)
         }
       }


       #JGG Pendiente de ver el alor de TMS cuando es nuevo
       if (is.na(tms)) {
         names = c(TPairs$CLEARING, TPairs$BASE, TPairs$COUNTER, TPairs$LAST_UPD)
         values = list(provider, base, counter, maxTMS)
         names(values) = names
         TPairs$insert(values, isolated=FALSE)
       }
       else {
         values = list(maxTMS)
         names(values) = c(TPairs$LAST_UPD)
         names = c(TPairs$CLEARING, TPairs$BASE, TPairs$COUNTER)
         keys = list(provider, base, counter)
         names(keys) = names
         TPairs$update(values, keys, isolated=FALSE)
       }
       YATACore::commitTrx(T)
       Sys.sleep(05)
   }
}

#' @export
adjustTimestamp = function() {

    YATACore::openConnection(global = T)
    dfPairs = YATACore::loadTable("PAIRS")
    # for (per in c("2H", "4H", "D")) {
    #     if (per == "2H") table = "POL_TICKERSH2"
    #     if (per == "4H") table = "POL_TICKERSH4"
    #     if (per == "D")  table = "POL_TICKERSD1"

        qry = c( "SELECT A.BASE, A.COUNTER, LEAST(A.LAST, B.TMS) AS TMS"
                 ,        "FROM PAIRS AS A "
                 ,        "JOIN (SELECT BASE, CTC, MAX(TMS) AS TMS  FROM "
#                 , table
                 ,"POL_TICKERSD1"
                 ,"GROUP BY BASE, CTC) AS B "
                 ,"ON A.BASE = B.BASE AND A.COUNTER = B.CTC")

        query = ""
        for (cc in qry) query = paste(query, cc)

        df = YATACore::executeQuery(query)
        if (nrow(df) > 0) {
            for (idx in 1:nrow(df)) {
              cat(paste(idx, df[idx, "BASE"], df[idx, "COUNTER"], "\n"))
                qry = "UPDATE PAIRS SET LAST = ? WHERE BASE = ? AND COUNTER = ?"
                YATACore::executeUpdate(qry, list(df[idx, "TMS"], df[idx, "BASE"], df[idx, "COUNTER"]))
            }
        }

    # }
    YATACore::closeConnection()
}

# Para cada par de datos en D1
#   1.- Obtenemos el domingo anterior o igual a hoy (D2)
#   2.- Obtenemos los pares de D1
#   3.- Obtenemos el maximo de W1 por par (D1)

#' @export
loadWeeks = function() {

   today = today()
   nDays = wday(today) - 1
   maxDay = today - days(nDays)

   TDay  = TBLSession$new("POL", "D1")
   TWeek = TBLSession$new("POL", "W1")
   TWork = TBLSession$new("POL", "D1")

   TDay$getPairs()
   TDay$df$TMS = maxDay
   TWeek$getPairs()
   TWeek$df$TMS = TWeek$df$TMS + days(1)

   dfPairs = merge(x=TDay$df, y=TWeek$df, by=c(TDay$BASE, TDay$COUNTER), all.x=T, all.y=F)

   reg = 0
   while (reg < nrow(dfPairs)) {
      reg = reg + 1
      base    = dfPairs[reg, TDay$BASE]
      counter = dfPairs[reg, TDay$COUNTER]
      from    = dfPairs[reg, paste0(TDay$TMS, ".y")]
      to      = dfPairs[reg, paste0(TDay$TMS, ".x")]
      cat(sprintf("Grouping weeks for %s-%s\n", base, counter))

      dfw = TWork$getSessionDataInterval(base, counter,from, to)
      if (nrow(dfw) == 0) next
      df = dfw %>% group_by(BASE,COUNTER,YEAR=year(TMS),WEEK=isoweek(TMS)) %>%
                   summarise(OPEN   = first(OPEN),   CLOSE   = last(CLOSE),
                             LOW    = min(LOW),     HIGH    = max(HIGH),
                             VOLUME = mean(VOLUME), AVERAGE = mean(AVERAGE))

      df$TMS = as.POSIXct.Date(as.Date(paste(df$YEAR,df$WEEK,7,sep="-"),"%Y-%U-%u"))
      df$TMS = update(df$TMS, hours=0, minutes=0, seconds=0)
      df = df[, -which(names(df) %in% c("YEAR", "WEEK"))]
      YATACore::beginTrx(T)
      YATACore::writeTable("SESSION_POL_W1", df, isolated=F)
      YATACore::commitTrx(T)
   }

}

#' @export
loadMonths = function() {

  today = today()
  day(today) = 1
  today = today - months(1)
  day(today) = days_in_month(today)


  TDay   = TBLSession$new("POL", "D1")
  TMonth = TBLSession$new("POL", "M1")
  TWork  = TBLSession$new("POL", "D1")

  TDay$getPairs()
  TDay$df$TMS = today
  TMonth$getPairs()
  TMonth$df$TMS = TMonth$df$TMS + days(1)

  dfPairs = merge(x=TDay$df, y=TMonth$df, by=c(TDay$BASE, TDay$COUNTER), all.x=T, all.y=F)

  reg = 0
  while (reg < nrow(dfPairs)) {
    reg = reg + 1
    base    = dfPairs[reg, TDay$BASE]
    counter = dfPairs[reg, TDay$COUNTER]
    from    = dfPairs[reg, paste0(TDay$TMS, ".y")]
    to      = dfPairs[reg, paste0(TDay$TMS, ".x")]
    cat(sprintf("Grouping months for %s-%s\n", base, counter))

    dfw = TWork$getSessionDataInterval(base, counter,from, to)
    if (nrow(dfw) == 0) next
    df = dfw %>% group_by(BASE,COUNTER,YEAR=year(TMS),MONTH=month(TMS)) %>%
      summarise(OPEN   = first(OPEN),   CLOSE   = last(CLOSE),
                LOW    = min(LOW),     HIGH    = max(HIGH),
                VOLUME = mean(VOLUME), AVERAGE = mean(AVERAGE), TMS=max(TMS))

    df$TMS = update(df$TMS, hours=0, minutes=0, seconds=0)
    df = df[, -which(names(df) %in% c("YEAR", "MONTH"))]
    YATACore::beginTrx(T)
    YATACore::writeTable("SESSION_POL_M1", df, isolated=F)
    YATACore::commitTrx(T)
  }

}
# Calcula la media ponderada por segmentos
# como suma de grupo * numero de grupo

wma = function(x) {
    if (length(x) < 3) return ((sum(x) / length(x)))
    if (length(x) >  2) g = 2
    if (length(x) >  4) g = 3
    if (length(x) >  7) g = 4

    ss = split(x, cut(x, g))
    y = x
    for (i in 2:length(ss)) {
        for (j in i:length(ss)) {
            y = c(y, ss[[j]])
        }
    }
    return (sum(y) / length(y))
}


.getData = function(table, base, counter, tms) {
    beg = .getBegin(group, table)
    sql = paste0("SELECT * FROM ", table, " WHERE CTC = ? AND EXC = ? AND TMS > ? ORDER BY TMS")
    .SQLDataFrame(sql, list(group[1, "CTC"],group[1, "EXC"], beg))

}

.getBegin = function(group, table) {
    dfm = .SQLDataFrame(paste0("SELECT MAX(TMS) FROM ", table, " WHERE CTC = ? AND EXC = ?"),
                        list(group[1, "CTC"],group[1, "EXC"]))
#    beg = dfm[1,1]
#    if (is.na(beg))
    beg =  as.POSIXct(strptime("1970-01-01 00:00:00", "%Y-%m-%d %H:%M:%S"),tz="UTC")
    beg
}

.selectColumns = function(df) {
    ungroup(df) %>% select(BASE, COUNTER, TMS, OPEN, CLOSE, HIGH, LOW, VOLUME, AVERAGE)
}

