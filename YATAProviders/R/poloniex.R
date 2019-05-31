pol.api = NULL

.POLGetHistorical = function(base, counter, from, to, period) {

    end = as.POSIXct(Sys.time())
    if (!is.null(to)) end = to
    if (is.null(pol.api)) pol.api = PoloniexR::PoloniexPublicAPI()

    data = PoloniexR::ReturnChartData( theObject = pol.api
                           ,pair = paste(base, counter, sep="_")
                           ,from=from + 1
                           ,to=end
                           ,period=period)

    if (is.null(data)) return (NULL)

    # El tipo devuelve todo como factores
    cols = colnames(data)
    for (col in cols) {
      if (is.factor(data[,col])) data[,col] = as.numeric(levels(data[,col]))
    }

    df = as.data.frame(data)

    df$TMS     = zoo::index(data)
    df$BASE    = base
    df$COUNTER = counter

    row.names(df) = NULL
    df
}

POL.GetTickers = function() {
  df = tryCatch({
      if (is.null(pol.api)) pol.api = PoloniexR::PoloniexPublicAPI()
      data = PoloniexR::ReturnTicker(pol.api)

      # El tipo devuelve todo como factores
      cols = colnames(data)
      for (col in cols) {
        if (is.factor(data[,col])) data[,col] = as.numeric(as.vector(data[,col]))
      }

      df = as.data.frame(data)
      l = strsplit(row.names(data), "_")
      m = sapply(l, c)

      df$Base = m[1,]
      df$CTC  = m[2,]
      df$TMS  = Sys.time()

      # Remover inactivos (not trading and last = 0)
      df = df %>% filter (last > 0, isFrozen == 0)
      # Seleccionar las columnas con nombre
      df = df[,c("TMS", "Base", "CTC", "last", "lowestAsk","highestBid","percentChange","baseVolume", "high24hr","low24hr")]
      colnames(df) = c("TMS","BASE", "COUNTER", "LAST", "ASK", "BID","CHANGE","VOLUME", "HIGH","LOW")
      rownames(df) = NULL
      df

    }
    ,error=function(e) {
      e$message
  })
  df
}
