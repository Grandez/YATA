files.trading = list.files("ui/partials/modTrading", pattern="*UI.R$", full.names=TRUE)
sapply(files.trading,source)

modTradingInput <- function(id) {
   ns = NS(id)
   useShinyjs()

   tabsetPanel(id=ns("tabs"), type="pills"
      ,tabPanel("Open", value="open", modOpenInput(paste0(ns(""), "open")))               
      ,tabPanel("Buy",  value="buy",  modBuyInput(paste0(ns(""), "buy")))
      #JGG Cuando activo estos se jode la cosa
#      ,tabPanel("Sell", value="sell", modSellInput(paste0(ns(""), "sell")))

      ,tabPanel("XFer", value="xfer", modXFerInput(paste0(ns(""), "xfer")))
   )
}

