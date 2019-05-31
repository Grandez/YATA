if ("YATAModels" %in% (.packages()))    detach("package:YATAModels", unload=T, force=T)
if ("YATACore"   %in% (.packages()))    detach("package:YATACore", unload=T, force=T)

# if ("YATAProviders" %in% (.packages())) detach("package:YATAProviders", unload=T)

# Shiny

library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)
# library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
# library(shinyjqui)
# library(V8)

library(htmltools)
library(htmlwidgets)

# General
library(dplyr)
library(data.table)
library(stringr)
library(rlist)
library(R6)
library(readr)
library(knitr)

# Plots
library(ggplot2)
library(gridExtra)
library(plotly)
library(RColorBrewer)

# Quant
library(lubridate)
library(zoo)

# YATA 
library(YATAModels)
library(YATACore)

# shhh(library(XLConnect,quietly = T))

# shhh(library(knitr    ,quietly = T))
# shhh(library(chron    ,quietly = T))


library(DT)


library(markdown)

# shhh(library(readr    ,quietly = T))
# shhh(library(gsubfn   ,quietly = T))

#require(YATAModels)
#require(YATAProviders)
require(YATACore)

rm(list=ls())
.globals <- new.env(parent = emptyenv())

options( warn = -1
        ,DT.options = list(dom = "t", bPaginate = FALSE, rownames = FALSE, scrollX = F)
#        ,java.parameters = "-Xmx2048m"
         # ,shiny.reactlog=TRUE
         # ,shiny.trace=TRUE
       )

plotly::config(plot_ly(), displaylogo = FALSE, collaborate = FALSE, displayModeBar = FALSE, responsive=TRUE)

files.widgets = list.files("widgets", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
sapply(files.widgets,source)

# Codigo auxiiar
files.r = list.files("R", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
sapply(files.r, source)

# Modulos de interfaz UI
files.sources = list.files("ui", pattern="*\\.R$", full.names=TRUE, ignore.case=F)
sapply(files.sources,source)

# source("locale/messages_ES.R", local=T)

# Datos globales
# SQLConn <<- NULL
# Create YATAENV as Global
YATACore::createEnvironment()
YATAENV$dataSourceDBName = "CTC"
# YATAENV$dataSourceDBType = IO_SQL
# YATAENV$modelsDBType     = IO_SQL

# case         = YATACore::YATACase$new()
# case$profile = YATACore::TBLProfile$new()

#JGG addResourcePath("man", "d:/R/YATA/YATAManualUser")


######################################
### Paneles
######################################

PNL_TST   = "tst"
PNL_OL   = "ol"
PNL_PRF  = "prf"
PNL_TRAD = "trad"
PNL_ANA  = "ana"
PNL_SIM  = "sim"
PNL_CONF = "conf"
PNL_HELP = "manual"
PNL_SYS  = "sys"
PNL_IND  = "ind"
PNL_MAN_USR   = "user"
PNL_MAN_TECH  = "tech"

onStop(function() {
  cat("Doing application cleanup\n")
  #cleanEnvironment()
})

# onSessionEnded(function() {
#   #called after the client has disconnected.
#   cat("Doing application cleanup\n")
# })