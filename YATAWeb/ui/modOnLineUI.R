modOnLineInput <- function(id) {
    ns <- NS(id)
    useShinyjs()
    panelLeft = tagList(
                       bsButton(ns("btnCancel"), "Stop subscription", icon = icon("remove"), style = "danger")   
                       ,wellPanel(h3("Plot")
                           ,sliderInput(ns("mins"), "Interval", min=0, max=60, step=5, value=15)
                           ,sliderInput(ns("rows"), "Max. Points", min=0, max=500, step=10, value=0)
                           ,radioGroupButtons(ns("field"), label = "Data",
                                                 choices = list("Last", "Ask", "Bid", "High", "Low", "Volume"), 
                                                 selected = "Last", direction="horizontal", size="xs",
                                                 justified = FALSE, status = "primary",
                                                 checkIcon = list(yes = icon("ok", lib = "glyphicon"))
                           )  
                           ,radioGroupButtons(ns("graph"), label = "Plot type",
                                               choices = list("Value"=1, "Last Change"=2, "Session Change"=3, "Day Change"=4, "Candle"=5), 
                                              selected = 1, direction="horizontal", size="xs",
                                              justified = FALSE, status = "secondary",
                                              checkIcon = list(yes = icon("ok", lib = "glyphicon"))
                           )                           
                       )
                       ,wellPanel(h3("Currencies")
                          ,radioGroupButtons(ns("rdoRange"), label = "Data value",
                                             choices=c("Close", "Session", "Last"="Var"), selected="Close"
                                            ,direction="horizontal", size="sm",justified = FALSE, status = "primary"
                                            ,checkIcon = list(yes = icon("ok", lib = "glyphicon"))
                                  )                           
                           ,sliderInput(ns("sldRows"),  "Max", min=0, max=10, step=1, value=10)
                           ,sliderInput(ns("sldVar"),   "Show Variation", min=0, max=100, step=10, value=5)
                       )
                       ,bsButton(ns("btnConfig"), "Update", icon = icon("check"), style = "success")
                      )
    #panelMain  = column(id = ns("main"),  width=12
    panelMain = tagList(fluidRow(boxPlus(id=ns("boxHeader")
                                ,title=textOutput(ns("lblHeader"))
                                , closable = FALSE
                                ,status = "primary"
                                 ,solidHeader = TRUE
                                 ,collapsible = TRUE
                                 ,enable_label = TRUE
                                 ,width = 12
                                 ,label_text = textOutput(ns("lblMins"), inline=TRUE)
                                 ,menuTab(ns("olMenu"), c(""))
                                 ,fluidRow(plotlyOutput(ns("plot"), width="98%",height="500px"))   
                        ))
                        ,fluidRow( column(width=6, DT::dataTableOutput(ns("tblData")))
                                  ,column(width=3, DT::dataTableOutput(ns("tblDataUp")))
                                  ,column(width=3, DT::dataTableOutput(ns("tblDataDown")))
                        )
                        
                        ) 
    panelRight = tagList( # div(id = ns("right")# , class="shinyjs-hide"
                         switchInput(inputId = ns("swBTC"),label = "Bitcoin", labelWidth = "80px")
                        ,pickerInput(inputId = ns("chkCTC"),label = "Currency"
                                                            ,multiple = TRUE
                                                            ,choices = NULL
                                                            ,options = list( title="Currencies"
                                                                            ,selectedTextFormat = "count"
                                                                            ,`actions-box` = TRUE
                                                                            ,liveSearch  = TRUE)
                                     )
                        ,noUiSliderInput(inputId = ns("sldRngVal"),label = "Value Range"
                                         ,min = 0, max = 10000, step=1000, value=c(10,10000))
                        ,noUiSliderInput(inputId = ns("sldRngPrc"),label = "Value Percentage"
                                         ,min = -100, max = 100, step=10, value=c(-100,100))
                        ,fluidRow(column(width=12,bsButton(ns("btnInfo"), "Update", icon = icon("check"), class="btn-block", style = "primary")))
                 )
#    tagList( fluidRow(panelLeft, panelMain, panelRight))
    makePage(id, left=panelLeft, main=panelMain, right=panelRight)
}    
