# files.trading = list.files("ui/partials/modAnalysis", pattern="*UI.R$", full.names=TRUE)
# sapply(files.trading,source)

# Al ffinal siempre es la misma pagina
modSimmInput <- function(id) {
    ns = NS(id)
    useShinyjs()
    tgts = FTARGET$new()

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


         ,hr()
         ,bsButton(ns("btnSave"), label = "Guardar", style="success", size="large")
    )
    
    panelMain = tagList(
      #fluidRow(
#        fluidRow( class="YATAInline", width="100%"
               # ,column(width=7,
                      # menuTab(id=ns("tabs"), names=c("Largo", "Intermedio", "Corto"), values=c(1,2,4), selected=2)
       # ))
 #     )
       fluidRow(boxPlus(id=ns("boxHeader")
                        ,title=textOutput(ns("lblHeader"))
                        , closable = FALSE
                        ,status = "primary"
                        ,solidHeader = TRUE
                        ,collapsible = TRUE
                        ,enable_label = TRUE
                        ,width = 12
                        
#                        ,plotlyOutput(ns("plot"), height="500px", inline=TRUE)
                ,hidden(plotlyOutput(ns("plot1"), width="100%", height="auto", inline=T))
                ,hidden(plotlyOutput(ns("plot2"), width="100%", height="auto", inline=T))
                ,hidden(plotlyOutput(ns("plot3"), width="100%", height="auto", inline=T))
                ,hidden(plotlyOutput(ns("plot4"), width="100%", height="auto", inline=T))
                        ,fluidRow(
                          selectInput(ns("cboModel"), label=NULL, choices=NULL, selected=NULL)
                          ,bsButton(ns("btnModel"), label = "Modelo", style="success", size="large")
                          
                          ,sliderInput(ns("sldRange"), label = NULL, min = 0, 
                                              max = 100, value = c(40, 60))
                                  ,bsButton(ns("btnOpenDlg"), label = "Indicador", style="success", size="large")
                        )
       ))
       ,fluidRow( column(width=6, DT::dataTableOutput(ns("tblSimm")))
                 # ,column(width=3, DT::dataTableOutput(ns("tblDataUp")))
                 # ,column(width=3, DT::dataTableOutput(ns("tblDataDown")))
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
      boxPlus(id=ns("boxPlots")
              ,title="Plot"
              ,closable = FALSE
              ,status = "primary"
              ,solidHeader = TRUE
              ,collapsible = TRUE
              ,enable_label = TRUE
              ,width = 6
              ,wellPanel(h3("Plot sources")
                        ,selectInput(ns("cboPlot1"), label = "Primary",   choices = tgts$getCombo(), selected = 2)
                        ,selectInput(ns("cboPlot2"), label = "Secondary", choices = tgts$getCombo(), selected = 0)
                        ,selectInput(ns("cboPlot3"), label = "Terciary",  choices = tgts$getCombo(), selected = 0)
                        ,selectInput(ns("cboPlot4"), label = "Terciary",  choices = tgts$getCombo(), selected = 0)
              )
              ,wellPanel(h3("Plot types")
                         ,selectInput(ns("cboType1"), label = "Primary",   choices = PLOT$getCombo(), selected = 3)
                         ,selectInput(ns("cboType2"), label = "Secondary", choices = PLOT$getCombo(), selected = 4)
                         ,selectInput(ns("cboType3"), label = "Terciary",  choices = PLOT$getCombo(), selected = 0)
                         ,selectInput(ns("cboType4"), label = "Terciary",  choices = PLOT$getCombo(), selected = 0)
              )
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
    panelModal = fluidRow(column(width=3)
            ,column(width=6, boxPlus(id=ns("boxDlg")
                ,title="Cosa modal"
                ,closable = TRUE
                ,status = "primary"
                ,solidHeader = TRUE
                ,collapsible = FALSE
                ,enable_label = TRUE
                ,width = 12
                ,fluidRow( column(width=1), column(width=2, h3("Group"))
                          ,column(width=6, selectInput(ns("cboIndGroups"), label = NULL,      choices = NULL))
                )
                ,fluidRow( column(width=1), column(width=2, h3("Indicator"))
                          ,column(width=6,selectInput(ns("cboIndNames"),  label = NULL,  choices = NULL))
                )
                ,hidden(div(id=ns("dlgIndBody")
                    ,fluidRow(column(width=1), column(width=6, h3(textOutput(ns("indTitle")))))
                    ,fluidRow(column(width=1), column(width=8, uiOutput(ns("indDoc")))
                              )
                    ,fluidRow(column(width=1), column(width=2, h3("Nombre"))
                                             , column(width=6, textInput(ns("lblIndName"), label=NULL)))
                    
                    ,hidden(fluidRow(id=ns("row0"), column(width=1), column(width=2, h3("Apply To"))
                                                  , column(width=6, selectInput(ns("cboTarget"), label = NULL
                                                                  , choices = c("")))))
                    ,hidden(fluidRow(id=ns("row1"), column(width=1), column(width=2, h3(textOutput(ns("lblParm1"))))
                                                  , column(width=6, numericInput(ns("parm1"), label = NULL, value=0))))
                    ,hidden(fluidRow(id=ns("row2"), column(width=1), column(width=2, h3(textOutput(ns("lblParm2"))))
                                                  , column(width=6, numericInput(ns("parm2"), label = NULL, value=0))))
                    ,hidden(fluidRow(id=ns("row3"), column(width=1), column(width=2, h3(textOutput(ns("lblParm3"))))
                                                  , column(width=6, numericInput(ns("parm3"), label = NULL, value=0))))
                    ,hidden(fluidRow(id=ns("row4"), column(width=1), column(width=2, h3(textOutput(ns("lblParm4"))))
                                                  , column(width=6, numericInput(ns("parm4"), label = NULL, value=0))))
                    ,hidden(fluidRow(id=ns("row5"), column(width=1), column(width=2, h3(textOutput(ns("lblParm5"))))
                                                  , column(width=6, numericInput(ns("parm5"), label = NULL, value=0))))
                    ,hidden(fluidRow(id=ns("row6"), column(width=1), column(width=2, h3(textOutput(ns("lblParm6"))))
                                                  , column(width=6, numericInput(ns("parm6"), label = NULL, value=0))))
                ))
                ,fluidRow( column(width=4)
                          ,column(width=6, bsButton(ns("btnAddDlg"),     "Add",    icon = icon("check"), style = "success")
                                         , bsButton(ns("btnCloseDlg"), "Cancel", icon = icon("remove"), style = "danger"))
                )
            ))
    )        
    
    # dataModal <- function(failed = FALSE) {
    #   modalDialog(
    #     textInput("dataset", "Choose data set",
    #               placeholder = 'Try "mtcars" or "abc"'
    #     ),
    #     span('(Try the name of a valid data object like "mtcars", ',
    #          'then a name of a non-existent object like "abc")'),
    #     if (failed)
    #       div(tags$b("Invalid name of data object", style = "color: red;")),
    #     
    #     footer = tagList(
    #       modalButton("Cancel"),
    #       actionButton("ok", "OK")
    #     )
    #   )
    # }
    
    makePage(id, left=panelLeft, main=panelMain, right=panelRight, modal=panelModal)
}