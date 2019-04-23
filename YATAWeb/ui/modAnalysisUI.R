                                 
modAnalysisInput <- function(id) {
    ns = NS(id)
    useShinyjs()
    panelLeft = tagList()
    panelMain = tagList(#box( width=NULL, solidHeader = T,status = "primary"
                             tabsetPanel(id=ns("tabs"), type="pills"
                                          #  ,tabPanel("Largo", value = "4",
                                          #            column(12, id=ns("pnlLong")
                                          #            # ,fluidRow(plotlyOutput(ns("plotLong"), width="100%",height="500px"))
                                          #            ,fluidRow(DT::dataTableOutput(ns("tblLong")))
                                          #            )
                                          #   )
                                          #  ,tabPanel("Intermedio", value="2"
                                          #            ,column(12, id=ns("pnlMedium")
                                          #            # ,fluidRow(plotlyOutput(ns("plotMedium"), width="100%",height="500px"))
                                          #            ,fluidRow(DT::dataTableOutput(ns("tblMedium")))
                                          #            )
                                          #  )
                                          #  ,tabPanel("Corto", value="1"
                                          #            ,column(12, id=ns("pnlShort")
                                          #            # ,fluidRow(plotlyOutput(ns("plotShort"), width="100%",height="500px"))
                                          #            ,fluidRow(DT::dataTableOutput(ns("tblShort")))
                                          #            )
                                          # )
                               )
                       # ,column(2
                       #         ,dateInput("dtCurrent", "Date:", value = "2012-02-29", format = "dd/mm/yy", startview = "year")
                       #         ,box( width=NULL, title = "Position", solidHeader = T, status = "primary"
                       #                        ,withTags({ table(class = "boxTable",
                       #                                          tr(td("Euro"),   td(colspan="2", class="lblData", textOutput(ns("lblPosFiat"))))
                       #                                          ,tr(td(textOutput(ns("lblMoneda"))), td(colspan="2", class="lblData", textOutput(ns("lblPosMoneda"))))
                       #                                          ,tr(td("Total"),  td(colspan="2", class="lblData", textOutput(ns("lblPosTotal"))))
                       #                                          ,tr(td("Estado"), td( img(id=ns("resDown"), icon("triangle-bottom", class = "rojo", lib="glyphicon"))
                       #                                                                ,img(id=ns("resUp"),   icon("triangle-top",   class = "verde", lib="glyphicon")))
                       #                                              ,td(             class="lblData", textOutput(ns("lblEstado"))))
                       #                                          ,tr(td("Tickers"),td(colspan="2", class="lblData", textOutput(ns("lblResMov"))))
                       #                                          ,tr(td("Opers"),  td(             class="lblData", textOutput(ns("lblResC")))
                       #                                              ,td(             class="lblData", textOutput(ns("lblResV"))))
                       #                                          ,tr(td("Date"),   td(colspan="2", class="lblData", textOutput(ns("lblPosDate"))))
                       #                                          ,tr(td("Trend"),   td(colspan="2", class="lblData", textOutput(ns("lblTrend"))))
                       #
                       #                        )
                       #
                       #                        }))
                       #  )
    )
    panelRight = tagList(
      
    )
    
#     panelTool = box(width=NULL
#                     , title = p("Toolbox",actionButton( ns("SBLClose"), "",icon = icon("remove"), class = "btn-xs"))
#     )
# #    panelLeft = getPanelLeft(id)
# 
#     #source("ui/partials/panelRight.R")
#     panelRight = box( width=NULL
#                       ,title = p("Config",actionButton( ns("SBRClose"), "",icon = icon("remove"), class = "btn-xs"))
#                       ,solidHeader = T
#                       ,status = "primary"
#                       ,wellPanel(radioButtons(ns("rdoPlot"), label="Graph",selected = PLOT_LINEAR
#                                               , choices = list( "Linear"  = PLOT_LINEAR
#                                                                 ,"Log"     = PLOT_LOG
#                                                                 ,"Candles" = PLOT_CANDLE)
#                       ))
#                       ,wellPanel(checkboxGroupInput(ns("chkIndicators"), label = NULL)
#                                  ,checkboxInput(ns("chkShowInd"),   label=LBL.SHOW_IND,    value = TRUE)                                 
#                                  ,wellPanel(radioButtons(ns("rdoProcess"), label="Mode",selected = MODE_AUTOMATIC
#                                                          ,choices = list( "Automatic" = MODE_AUTOMATIC
#                                                                           ,"Inquiry"   = MODE_INQUIRY
#                                                                           ,"Manual"    = MODE_MANUAL)))
#                                  
#                       )
#     )
#     
#     tagList(fluidRow( #hidden(column(id=ns("pnlLeft"),  panelLeft,  width=2))
#                             column(id=ns("pnlMain"),  panelMain,  width=12)
#                      ,hidden(column(id=ns("pnlRight"), panelRight, width=2))
#                       
#     ))
#
    makePage(id, left=panelLeft, main=panelMain, right=panelRight)
}