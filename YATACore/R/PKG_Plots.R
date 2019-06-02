plotLineTypes = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot")

plotToolbar = function(p) {
    p %>% config(displaylogo = FALSE, collaborate = FALSE
           # ,modeBarButtonsToRemove = c(
           #      'sendDataToCloud'
           #     ,'autoScale2d'
           #     ,'resetScale2d'
           #     ,'toggleSpikelines'
           #     ,'hoverClosestCartesian'
           #     ,'hoverCompareCartesian'
           #     ,'zoom2d'
           #     ,'pan2d'
           #     ,'select2d'
           #     ,'lasso2d'
           #     ,'zoomIn2d'
           #     ,'zoomOut2d'
           # )
          )
}
.hoverlbl = function(title, x, y) {
    paste('<b>', title, '</b><br>'
               , 'Date: ', as.Date(x, format="%d/%m/%Y")
               , '<br>Value: ', round(y, digits=0))
}

#' @export
plotBase = function(plot, type, x, y=NULL, title=NULL, attr=NULL, ...) {
    if (is.null(y) || is.na(y)) return (NULL)
    PLOT = FACT_PLOT$new()

    if (type == PLOT$LOG)    return (plotLog (plot, x, y, ...))
    if (type == PLOT$BAR)    return (plotBar (plot, x, y, ...))
    if (type == PLOT$CANDLE) {
        p = list(...)
        return (plotCandle(plot, x, p$open, p$close, p$high, p$low, ...))
    }
    #if (type == PLOT$LINE)   return (
        plotLine(plot, x, y, title, attr, ...)
}


#' @export
plotLine = function(plot, x, y, title=NULL, attr=NULL, ...) {
    name = title

    l=list(width=0.75, dash="solid")
    if (!is.null(attr)) l = attr

    add_trace(plot, x=x, y=y, type = "scatter", mode = "lines"
               , line=l
               , name = title
               , hoverinfo = 'text'
               , text = ~.hoverlbl(title, x, y)
    )
}
#' @export
plotMarker = function(plot, x, y, hover=c(""), line=NULL, ...) {
    title = hover[1]
    if (length(hover) > 1) title = paste0(title, " (", hover[2], ")")

    p = add_trace(plot, x=x, y=y, type = "scatter", mode = "lines+markers"
                  , line=list(width=0.75, dash=lType)
                  , name = title
                  , hoverinfo = 'text'
                  , text = ~.hoverlbl(title, x, y)
    )
    p
}

#' @export
plotLines = function(plot, x, data, hoverText) {

    cols = ncol(data)
    if (cols > 2) lTypes = c(plotLineTypes[2], plotLineTypes[3], plotLineTypes[2])
    if (cols > 4) lTypes = c(plotLineTypes[4], lTypes,           plotLineTypes[4])

    for (i in 1:cols) {
        title = hoverText[1]
        if (length(hoverText) > 1) title = paste0(hoverText[1], " (", hoverText[i+1], ")")
        plot = plotLine(plot, x, as.vector(data[,i]), cols[((i-1) %% cols) + 1], hoverText = title)
    }
    plot
}

#' @export
plotBar = function(plot, x, y, ...) {
    colors = c('rgba(0,0,255,1)', 'rgba(0,255,0,1)', 'rgba(255,0,0,1)')
    FUN=function(x) {
        if (length(x) != 2) return (1)
        if (is.na(x[1]) || is.na(x[2])) return (1)
        if (x[1] == x[2])           return (1)
        if (x[2] == 0)              return (1)
        vv = x[1]/x[2];
        if ( vv > 1.03) rr = 3
        else { if (vv < .97) rr = 2
                else rr = 1
        }
        rr
    }

    cc = rollapply(y, 2, FUN, fill=0, align="right")
    add_trace(plot, x=x, y=y, type='bar', orientation='v'
                  , marker=list(color=colors[cc])
                  # , hoverinfo = 'text'
                  # , name = hoverText
                  # , text = ~.hoverlbl(hoverText, x, y)
    )

}

#' @export
plotCandle = function(plot, x, open, close, high, low, ...) {
    p = list(...)
    title = p$hover[1]
    if (length(p$hover) > 1) title = paste0(title, " (", p$hover[2], ")")

    add_trace(plot, type = "candlestick"
              , x=x, open=open, close=close, high=high, low=low
              , line=list(width=0.75)
              ,alist(attrs)
              , name = title
              , hoverinfo = 'text'
              , text = ~.hoverlbl(title, x, close)
    ) %>% layout(xaxis = list(rangeslider = list(visible = F)))
}


#' @export
plotLog = function(plot, x, y, lType="solid", hoverText) {
    title = hoverText[1]
    if (length(hoverText) > 1) title = paste0(title, " (", hoverText[2], ")")

    plot = add_trace(plot, x=x, y=y, type = "scatter", mode = "lines"
                         , line=list(width=0.75, dash=lType)
                         , name = title
                         , hoverinfo = 'text'
                         , text = ~.hoverlbl(title, x, y)
                     )
    plotly::layout(plot, yaxis = list(type = "log"))
}

#' @export
plotLogs = function(plot, x, data, hoverText) {

    cols = ncol(data)
    if (cols > 2) lTypes = c(plotLineTypes[2], plotLineTypes[3], plotLineTypes[2])
    if (cols > 4) lTypes = c(plotLineTypes[4], lTypes,           plotLineTypes[4])

    for (i in 1:cols) {
        title = hoverText[1]
        if (length(hoverText) > 1) title = paste0(hoverText[1], " (", hoverText[i+1], ")")
        plot = plotLog(plot, x, as.vector(data[,i]), cols[((i-1) %% cols) + 1], hoverText = title)
    }
    plot
}

# Tipo de lineas
# Sets the dash style of lines.
# Set to a dash type string ("solid", "dot", "dash", "longdash", "dashdot", or "longdashdot")
# or a dash length list in px (eg "5px,10px,2px,2px").



# plotLine = function(data, indicator, plots) {
#     for (iList in 1:length(indicator$result)) {
#         ind = indicator$result[[iList]]
#         for (idx in 1:length(ind)) {
#            cName = indicator$columns[[idx]]
#            df = .plotMakeDF(data, ind[[idx]], cName)
#            plots[[iList]] = add_trace(plots[[iList]],x=df[,1],y=df[,2],name=cName,type="scatter",mode="lines")
#         }
#     }
#     plots
# }


plotSegment = function(data, indicator, plots) {
    res = indicator$result[[1]]
    inter = res$coefficients[1]
    slope = res$coefficients[2]

    plots[[1]] = add_segments(plots[[1]], x = data$df[1,"Date"], xend = data$df[nrow(data$df),"Date"]
                                        , y = inter,             yend = inter + (nrow(data$df) * slope))
    plots
}

plotTrend = function(data, indicator, plots) {
    # ticks =   data$tickers
    # df = ticks$getData()
    # res = indicator$result
    # inter = res$coefficients[1]
    # slope = res$coefficients[2]
    #
    # x=c(df[1,ticks$DATE], df[nrow(df),ticks$DATE])
    # y = c(inter, nrow(df) * slope)
    # plots[[1]] = add_trace(plots[[1]], x=x, y=y, mode="lines")
    plots
}

plotOverlay = function(data, indicator, plots) {

    styles = list( list(width = 1,   dash = 'solid')
                  ,list(width = 0.6, dash = 'dash' )
                  ,list(width = 0.3, dash = 'dot'  ))

    for (idx in 1:length(indicator$result)) {
        groups = round(length(indicator$columns))

        df = cbind(data$df[,data$DATE],indicator$result[[idx]])
        colnames(df) = c(data$DATE, indicator$columns)

        nCol = 1
        for (col in indicator$columns) {
            plots[[idx]] = add_trace(plots[[idx]], x=df[,data$DATE], y=df[,col], name=col
                                         ,type="scatter", mode="lines", line=styles[[(nCol %% groups)+1]])
            nCol = nCol + 1
        }
    }
    plots
}

plotOverlay2 = function(data, indicator, plots) {
    styles = list( list(width = 1,   dash = 'solid')
                  ,list(width = 0.6, dash = 'dash' )
                  ,list(width = 0.3, dash = 'dot'  ))

    for (idx in 1:length(indicator$result)) {
        groups = round(length(indicator$columns))

        df = cbind(data$df[,data$DATE],indicator$result[[idx]])
        colnames(df) = c(data$DATE, indicator$columns)

        nCol = 1
        for (col in indicator$columns) {
            plots[[idx]] = add_trace(plots[[idx]], x=df[,data$DATE], y=df[,col], name=col
                                         ,type="scatter", mode="lines", line=styles[[(nCol %% groups)+1]])
            nCol = nCol + 1
        }
    }
    plots
}

plotMaxMin = function(data, indicator, plots) {
    dfr = as.data.frame(indicator$result)
    dfb = data$df
    col = parse(text=paste0("dfb$",data$PRICE))
    names(dfr) = "MaxMin"

    max = dfr %>% group_by(MaxMin) %>% summarise(veces=n()) %>% arrange(desc(MaxMin)) %>% head(n=3)
    dfM = dfb[eval(col) %in% c(max$MaxMin),]
    plots[[1]] = add_trace(plots[[1]], data=dfM, x=~Date, y=~Price, mode="markers", marker=list(color="green"))

    min = dfr %>% group_by(MaxMin) %>% summarise(veces=n()) %>% arrange(desc(MaxMin)) %>% head(n=3)
    min$MaxMin = min$MaxMin * -1
    dfm = dfb[eval(col) %in% c(min$MaxMin),]
    plots[[1]] = add_trace(plots[[1]], data=dfm, x=~Date, y=~Price, mode="markers", marker=list(color="red"))
    plots
}

.plotMakeDF = function(data, ind, colName) {
    df = as.data.frame(data$df[,data$DATE])
    df = cbind(df, ind)
    colnames(df) = c(data$DATE, colName)
    df
}

.plotAttr = function(...) {
    p = eval(substitute(alist(...)))
    eval(p$title, env=parent.env(parent.frame()))
    p = list(...)
    res = list()

    if (!is.null(p$hover)) {
        title = p$hover[1]
        if (length(p$hover) > 1) title = paste0(title, " (", p$hover[2], ")")
        res = list.append(res, name=title)
        res = list.append(res, hoverinfo = 'text')
        res = list.append(res, text = quote(~.hoverlbl(title, x, y)))
    }
    if (!is.null(p$title)) res = list.append(res, name=p$title)
    res
}
