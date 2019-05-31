# files.trading = list.files("ui/partials/modAnalysis", pattern="*UI.R$", full.names=TRUE)
# sapply(files.trading,source)

# Al ffinal siempre es la misma pagina
modAnalysisInput <- function(id) {
    ns = NS(id)
    useShinyjs()
    plotItems = list("None" = 0, "Price" = 1, "Volume" = 2, "MACD" = 3) 
    plotTypes = list("None" = 0, "Linear" = 1, "Log" = 2, "Candle" = 4, "Bar" = 8) 

    panelLeft = tagList(
         textInput(ns("txtPrfName"), label = "Nombre", value = "Javier")
         ,selectInput(ns("rdoPProfile"), label=NULL, selected = PRF_MODERATE
                      , choices=c("Conservador", "Moderado", "Atrevido", "Arriesgado"))
         ,numericInput(ns("txtPrfImpInitial"), label = "Capital", value=10000, min=1000, step=500)
         ,hr()
         ,selectInput(ns("cboProvider"), label = "Provider", choices = NULL, selected=NULL)         
         ,selectInput(ns("cboBases"), label = "Base", choices = NULL, selected=NULL)
         ,selectInput(ns("cboMonedas"), label = "Moneda", choices = NULL, selected=NULL)
         ,dateInput(ns("dtFrom"),"Desde", value = "2012-02-29", format = "dd/mm/yy", startview = "year")
         ,dateInput(ns("dtTo"),NULL, value = "2012-02-29", format = "dd/mm/yy", startview = "year")
         ,hr()
         ,selectInput(ns("cboScope"), label="Scope", selected=2,choices=c("Intraday"=1,"Day"=2,"Week"=3,"Month"=4))

         ,selectInput(ns("cboModels"), label="Modelo", choices=NULL, selected=NULL)
         ,hr()
         ,bsButton(ns("btnSave"), label = "Guardar", style="success", size="large")
    )
    
    panelMain = tagList(#box( width=NULL, solidHeader = T,status = "primary"
       menuTab(id=ns("tabs"), names=c("Largo", "Intermedio", "Corto"), values=c(1,2,3), selected=2)
       ,fluidRow(boxPlus(id=ns("boxHeader")
                        ,title=textOutput(ns("lblHeader"))
                        , closable = FALSE
                        ,status = "primary"
                        ,solidHeader = TRUE
                        ,collapsible = TRUE
                        ,enable_label = TRUE
                        ,width = 12
                        
                        ,plotlyOutput(ns("plot"), width="98%",height="500px")   
       ))
       ,fluidRow( column(width=6, DT::dataTableOutput(ns("tblData")))
                  ,column(width=3, DT::dataTableOutput(ns("tblDataUp")))
                  ,column(width=3, DT::dataTableOutput(ns("tblDataDown")))
       )

                             # tabsetPanel(id=ns("tabs"), type="pills"
                             #               ,tabPanel("Largo", value = "4",
                             #                         column(12, id=ns("pnlLong")
                             #                         # ,fluidRow(plotlyOutput(ns("plotLong"), width="100%",height="500px"))
                             #                         ,fluidRow(DT::dataTableOutput(ns("tblLong")))
                             #                         )
                             #                )
                             #               ,tabPanel("Intermedio", value="2"
                             #                         ,column(12, id=ns("pnlMedium")
                             #                         # ,fluidRow(plotlyOutput(ns("plotMedium"), width="100%",height="500px"))
                             #                         ,fluidRow(DT::dataTableOutput(ns("tblMedium")))
                             #                         )
                             #               )
                             #               ,tabPanel("Corto", value="1"
                             #                         ,column(12, id=ns("pnlShort")
                             #                         # ,fluidRow(plotlyOutput(ns("plotShort"), width="100%",height="500px"))
                             #                         ,fluidRow(DT::dataTableOutput(ns("tblShort")))
                             #                         )
                             #              )
                             #   )
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

#     panelTool = box(width=NULL
#                     , title = p("Toolbox",actionButton( ns("SBLClose"), "",icon = icon("remove"), class = "btn-xs"))
#     )
# #    panelLeft = getPanelLeft(id)
# 
#     #source("ui/partials/panelRight.R")
    panelRight = tagList(
      wellPanel(h3("Plot sources")
                ,selectInput(ns("cboPlot1"), label = "Primary",   choices = plotItems, selected = 1)
                ,selectInput(ns("cboPlot2"), label = "Secondary", choices = plotItems, selected = 2)
                ,selectInput(ns("cboPlot3"), label = "Terciary",  choices = plotItems, selected = 0)
               )
      ,wellPanel(h3("Plot types")
                ,selectInput(ns("cboType1"), label = "Primary",   choices = plotTypes, selected = 1)
                ,selectInput(ns("cboType2"), label = "Secondary", choices = plotTypes, selected = 2)
                ,selectInput(ns("cboType3"), label = "Terciary",  choices = plotTypes, selected = 0)
      )
      
      # ,radioButtons(ns("rdoPlot"), label="Graph",selected = PLOT_LINEAR
      #                               , choices = list( "Linear"  = PLOT_LINEAR
      #                                                 ,"Log"     = PLOT_LOG
      #                                                 ,"Candles" = PLOT_CANDLE)
      #       ))
      #       ,wellPanel(checkboxGroupInput(ns("chkIndicators"), label = NULL)
      #                  ,checkboxInput(ns("chkShowInd"),   label=LBL.SHOW_IND,    value = TRUE)
      #                  ,wellPanel(radioButtons(ns("rdoProcess"), label="Mode",selected = MODE_AUTOMATIC
      #                                          ,choices = list( "Automatic" = MODE_AUTOMATIC
      #                                                           ,"Inquiry"   = MODE_INQUIRY
      #                                                           ,"Manual"    = MODE_MANUAL)))
      # 
      
    )
#     
#     tagList(fluidRow( #hidden(column(id=ns("pnlLeft"),  panelLeft,  width=2))
#                             column(id=ns("pnlMain"),  panelMain,  width=12)
#                      ,hidden(column(id=ns("pnlRight"), panelRight, width=2))
#                       
#     ))
#
    makePage(id, left=panelLeft, main=panelMain, right=panelRight)
}