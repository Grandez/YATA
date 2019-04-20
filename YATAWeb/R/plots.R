axis <- list(
  autotick = TRUE,
  ticks = "outside",
  tick0 = 0,
  dtick = 0.25,
  ticklen = 5,
  tickwidth = 2,
  tickcolor = toRGB("blue")
)        

vline <- function(x = 0, color = "red") {
    list( type = "line"
         ,y0 = 0
         ,y1 = 1
         ,yref = "paper"
         ,x0 = x
         ,x1 = x
         ,line = list(color = color)
    )
}
zone = function(x0, x1) {
    list( type = "rect"
         ,fillcolor = "blue"
         ,line = list(color = "blue")
         ,opacity = 0.2
         ,x0 = x0
         ,x1 = x1
         ,xref = "x"
         ,yref = "paper"
         ,y0 = 0
         ,y1 = 1
    )    
}

#' @description 
#' Genera el plot general de una criptomoneda
#' @param vars Conjunto de vriables reactivas, entre ella tickers
#' @param model Modelo a aplicar 
renderPlotSession = function(tickers, sources, types) {
    if (is.null(tickers) || is.null(tickers$df)) return (NULL)
    
    heights = list(c(1.0), c(0.6, 0.4), c(0.5, 0.25, 0.25), c(0.4, 0.2, 0.2, 0.2))
    DT::renderDataTable({ renderTable() })
    items = length(sources)
    plots = list()
    df    = tickers$df

    idx = 0
    while (idx < items) {
        idx = idx + 1
        p = plot_ly()
        
        if (!is.null(sources[idx]) && !is.na(sources[idx])) {
            p = YATACore::plotBase(p, types[idx], x=df[,tickers$DATE]
                                   , y=df[,sources[idx]]
                                   , open      = df[,tickers$OPEN]
                                   , close     = df[,tickers$CLOSE]
                                   , high      = df[,tickers$HIGH]
                                   , low       = df[,tickers$LOW]
                                   , hoverText = tickers$symbol) 
            if (!is.null(p)) plots = list.append(plots, plotly_build(hide_legend(p)))
        }
    }
    
    rows = items - sum(is.na(sources))
     sp = subplot( plots, nrows = rows, shareX=T, heights=heights[[rows]]) %>% config(displayModeBar=F)
     sp$elementId = NULL
     sp
}    

renderPlot2 = function(vars, model, term, input, showInd) {
    print("Entra en renderPlot")

    if (is.null(vars$tickers)) return (NULL)
    # if (term == 4) {
    #     browser()
    # }

    if (showInd) showInd = input$chkShowInd
    type=PLOT_LINEAR
    if (term == TERM_LONG) type = PLOT_CANDLE
    plots = plotData(vars$clicks, term, vars$tickers, case$model,  showInd, type )   
    if (is.null(plots)) return (NULL)
    
    sp = subplot( hide_legend(plots[[1]])
                 ,hide_legend(plots[[2]])
                 ,hide_legend(plots[[3]])
                 ,nrows = 3
                 ,shareX=T
                 ,heights=c(0.5,0.25, 0.25)) %>% 
         config(displayModeBar=F)
    
    sp$elementId = NULL
    sp
}

plotData = function(flag, term, data, model, showIndicators, type=PLOT_LINEAR) {

    FUN=function(x) {
        if (x[1] == x[2]) return (0)
        if (x[2] == 0)    return (0)
        vv = x[1]/x[2]; 
        if ( vv > 1.03) rr = 1
        else { if (vv < .97) rr = -1 
               else rr = 0
        }
        rr 
    }
    
      if (is.null(data)) return (NULL)

      tickers = data$getTickers(term)
      if (is.null(tickers) || is.null(tickers$df)) return (NULL)
      
      df = tickers$df
      if (nrow(df) == 0) return(NULL)
      if (type == PLOT_LINEAR) {
          p1 <- plot_ly(df, x = df[,tickers$DATE], y = df[,tickers$PRICE], type = 'scatter', mode = 'lines')
          p1 <- layout(p1, xaxis = axis)
      }
      if (type == PLOT_LOG) {
          p1 <- plot_ly(df, x = df[,tickers$DATE], y = df[,tickers$PRICE], type = 'scatter', mode = 'lines')
          p1 <- layout(p1, xaxis = axis, yaxis = list(type = "log"))
      }
      if (type == PLOT_CANDLE) {
          p1 <- plot_ly(df, type="candlestick",x=df[,tickers$DATE]
                                                   ,open=df[,tickers$OPEN]
                                                   ,close=df[,tickers$CLOSE]
                                                   ,high=df[,tickers$HIGH]
                                                   ,low=df[,tickers$LOW])
          p1 <- layout(p1, xaxis = list(rangeslider = list(visible = F)))
      }

      p1$elementId <- NULL # Evitar aviso del widget ID

      cc = rollapply(df[,tickers$VOLUME],2,FUN, fill=0,align="right")
      
      p2 <- plot_ly(df, x = df[,tickers$DATE], y = df[,tickers$VOLUME], type = 'bar', marker=list(color=cc))
      p2$elementId = NULL

      p3 = plot_ly(df)
      
      plots = list(p1, p2, p3)
      if (showIndicators) {
          plots = model$plotIndicators  (term, plots, data, indicators)
      }      
      #if (showIndicators) plots = model$plotIndicators  (term, plots, tickers, indicators)
      plots
#         
#         
# #        plots = case$model$plotIndicatorsSecundary(case$data, plots, input$chkPlots2)
# 
#         shapes = list()
#         shapes = list.append( shapes
#                              ,vline(vars$df[vars$fila, "Date"])
#         #                     ,zone(vars$df[vars$fila, "Date"], df[nrow(df),"Date"])
#                              )
#         
#         plots[[1]] = plots[[1]] %>% layout(xaxis = axis, shapes=shapes)
#         plots[[2]] = plots[[2]] %>% layout(shapes=shapes)
#         

}

basicTheme <- function() {
    t0 = theme( panel.background = element_blank()
                ,axis.text.y=element_text(angle=90)
                ,axis.text.x=element_blank()
                ,panel.border = element_rect(colour = "black", fill=NA, size=1)
                ,legend.position="none"
                
    )
}

basePlot1 <- function(data) {
    t0 = basicTheme()

    p1 = ggplot(data,aes(x=date, y=price)) + 
        geom_line() # + 
        #geom_smooth(method="lm") +
#        ylab("Precio")

    t1 = t0 # + theme(axis.text.x=element_blank(),legend.position="none")
    t1 = t1 + theme(axis.title.x=element_blank(), axis.ticks.x = element_blank())
    p1 + t1
}

basePlot2 <- function(data) {
    t0 = basicTheme()

    tmp = data
    tmp$c = rollapply(df,2,FUN=function(x) { v = x[1]/x[2]; 
                                            if ( v > 1.03) r = 1
                                            else { if (v < .97) r = -1 
                                                   else r = 0
                                                 }
                                            r }, fill=0,align="right")
    
    p2 = ggplot(data,aes(date, volume/1000,fill=c)) + 
        geom_bar(stat="identity") +
        ylab("Volumen (Miles)") #+ 
        #scale_x_date(date_breaks = "1 week", date_labels = "%d/%m/%Y") +
        #scale_fill_continuous(low="red", high="green")
    
    t2 = t0 + theme(axis.text.x=element_text(angle=45, hjust=1)) 
    p2 + t2
}

basicPlot <- function(data) {
    
    p1 = ggplot(data,aes(x=date, y=price)) + 
        geom_line() + 
        geom_smooth(method="lm") +
        ylab("Precio")
    
    p2 = ggplot(data,aes(date, volume/1000,fill=Volume)) + 
        geom_bar(stat="identity") +
        ylab("Volumen (Miles)") + 
        scale_x_date(date_breaks = "1 week", date_labels = "%d/%m/%Y") +
        scale_fill_continuous(low="red", high="green")
    
    t0 = theme( panel.background = element_blank()
                ,axis.text.y=element_text(angle=90)
                ,panel.border = element_rect(colour = "black", fill=NA, size=1)
    )
    
    t1 = t0 + theme(axis.title.x=element_blank(),axis.ticks.x = element_blank())
    t2 = t0 + theme(axis.text.x=element_text(angle=45, hjust=1)) 
    
    p1A = p1 + t1
    p2A = p2 + t2
    grid.arrange(p1A,p2A,heights=c(6,4))
}