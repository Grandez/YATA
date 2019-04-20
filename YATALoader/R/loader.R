if("YATACore" %in% (.packages()))
    detach(name="package:YATACore", unload=T, character.only = T, force = T)
if("YATAProviders" %in% (.packages()))
    detach(name="package:YATAProviders", unload=T, character.only = T, force = T)

if (!require("pacman")) install.packages("pacman")

# Common
#pacman::p_load("zoo")
pacman::p_load("lubridate")

library("YATACore")
library("YATAProviders")

#' @export
retrieveSessions = function() {

    YATAENV <<- YATACore::YATAEnvironment$new()
    YATACore::openConnection(global = T)
    tPairs = .getPairs()

    for (base in unique(tPairs$BASE))
      .loadSource(tPairs[tPairs$BASE == base,])
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
.loadSource = function(pairs) {

    for (idx in 1:nrow(pairs)) {
        cat(sprintf("%s - Retrieving %s/%s\n", format(Sys.time(), "%X"), pairs[idx, "BASE"], pairs[idx, "COUNTER"]))
        YATACore::beginTrx()
        maxTMS = pairs[idx, "LAST"]
        lastTMS = maxTMS
        for (per in c("2H", "4H", "D")) {
            if (per == "2H") table = "POL_TICKERSH2"
            if (per == "4H") table = "POL_TICKERSH4"
            if (per == "D")  table = "POL_TICKERSD1"

            df = YATAProviders::getHistorical( base=pairs[idx, "BASE"]
                                              ,counter=pairs[idx, "COUNTER"]
                                              ,from=lastTMS
                                              ,period=per)
            if (!is.null(df) && nrow(df) > 0) {
                tmpTMS = max(df$TMS)
                if (tmpTMS > maxTMS) maxTMS = tmpTMS
                YATACore::writeTable(table, df)
                qry = "UPDATE PAIRS SET LAST = ? WHERE BASE = ? AND COUNTER = ?"
                YATACore::executeUpdate(qry, list(maxTMS, df[idx, "BASE"], df[idx, "COUNTER"]))
            }
        }
        YATACore::commitTrx()
        Sys.sleep(05)
    }
}

#' @export
loadWeeks = function() {
    groups = .SQLDataFrame("select CTC, EXC FROM POL_TICKERSD1 GROUP BY CTC, EXC")
    for (reg in 1:nrow(groups)) {
        pars=sprintf("%s-%s", groups[reg, "CTC"],groups[reg, "EXC"])
        print(pars)
        df  = .getData(groups[reg,], "POL_TICKERSD1")
        if (nrow(df) > 0) {
            df = df %>% group_by(CTC,EXC,YEAR=year(TMS),WEEK=isoweek(TMS)) %>%
                summarise(OPEN   = first(OPEN),   CLOSE   = last(CLOSE),
                          LOW    = min(LOW),    HIGH    = max(HIGH),
                          VOLUME = mean(VOLUME), QUOTEVOLUME = mean(QUOTEVOLUME),
                          DAYS=n())
            df     = df[df$DAYS == 7,]
            if (nrow(df) > 0) {
                df$TMS = as.POSIXct.Date(as.Date(paste(df$YEAR,df$WEEK,7,sep="-"),"%Y-%U-%u"))
                df$TMS = update(df$TMS, hours=0, minutes=0, seconds=0)
                df$WEIGHTEDAVERAGE = 0
                YATACore::writeTable("POL_TICKERSW1", .selectColumns(df))
            }
        }
    }
}

#' @export
loadMonths = function() {
    groups = .SQLDataFrame("select CTC, EXC FROM POL_TICKERSD1 GROUP BY CTC, EXC")
    for (reg in 1:nrow(groups)) {
        df = .getData(groups[reg,], "POL_TICKERSD1")
        if (nrow(df) > 0) {
            df = df %>% group_by(CTC,EXC,YEAR=year(TMS),MONTH=month(TMS)) %>%
                summarise(OPEN   = wma(OPEN),   CLOSE       = wma(CLOSE),
                          LOW    = min(LOW),    HIGH        = max(HIGH),
                          VOLUME = mean(VOLUME), QUOTEVOLUME = mean(QUOTEVOLUME),
                          DAY=max(day(TMS)))
            df = df[df$DAY >= 28,]
            if (nrow(df) > 0) {
                df$TMS = as.POSIXct(paste(df$YEAR,df$MONTH,df$DAY, sep="/"), tz="UTC", "%Y/%m/%d")
                df$TMS = update(df$TMS, hours=0, minutes=0, seconds=0)
                df = subset(df, select=c(CTC,EXC, TMS, OPEN, CLOSE, LOW, HIGH, VOLUME, QUOTEVOLUME))
                #df$WEIGHTEDAVERAGE = df$VOLUME / df$QUOTEVOLUME
                if (nrow(df) > 0) df$WEIGHTEDAVERAGE = 0
                YATACore::writeTable("POL_TICKERSM1", .selectColumns(df))
            }
        }
    }
}



.getPairs = function() {
    tPairs = YATACore::loadTable("PAIRS")
    tPairs$LAST[tPairs$LAST < 0] = as.POSIXct.numeric(0,origin="1970-01-01", tz = "GMT")
    tPairs
}

loadPairs <- function(src="USDT") {
   .SQLDataFrame("SELECT * FROM PAIRS WHERE src = ?", param=list(src))
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


.getData = function(group, table) {
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
    ungroup(df) %>% select(CTC, EXC, TMS, OPEN, CLOSE, HIGH, LOW, VOLUME, QUOTEVOLUME, WEIGHTEDAVERAGE)
}

