modPortfolioInput <- function(id) {
    ns <- NS(id)
    useShinyjs()
    panelLeft = column(id = ns("left"), width=2, style="display: none"
                       ,tags$div(id=ns("left-main")
                       ,radioButtons(ns("swSource"),"Source"   , selected = 1, choices = list("Price" = 0, "Volume" = 1))
                       ,radioButtons(ns("swValue"), "Data"     , selected = 1, choices = list("Value" = 0, "Variation" = 1))
                       ,radioButtons(ns("swPlot"),  "Plot type", selected = 1, choices = list("Linear" = 1, "Log" = 2, "Bar" = 3, "Candle" = 4))
                       ,radioButtons(ns("swShow"),  "Show"     , selected = 2, choices = list("Active" = 1, "Portfolio" = 2, "All" = 3))
                       ,radioButtons(ns("swWindow"),"Interval" , selected = 2, 
                                     choices = list("Week" = 1, "fothnight" = 2, "Month" = 3, "Quarter"= 4))
                       ,bsButton(ns("btnConfig"), "Update", icon = icon("check"), style = "primary")
                       )
    )
    panelMain  = column(id = ns("main"),  width=12
                        ,boxPlus(width=12, closable = FALSE,status = "primary",solidHeader = FALSE,collapsible = TRUE
                                 ,menuTab(ns("tabs"), c("General"))
                                 # ,tabsetPanel(id=ns("tabs")
                                 #            ,tabPanel( id=ns("General"), "General"
                                 #                      ,fluidRow(plotlyOutput(ns("plotSessions"), width="100%",height="500px"))
                                 #                      ,fluidRow(column(width=6, DT::dataTableOutput(ns("tblSessions"))))
                                 #             )
                                 # )
                        )
    )
    panelRight = column(id = ns("right"), width=2, style="display: none"
                        , checkboxGroupInput(ns("chkCTC"), "Currencies to plot:")
                        ,fluidRow( column(width=6, bsButton(ns("btnNone"), "Ninguno", icon = icon("trash"), class="btn-block", style = "warning"))
                                  ,column(width=6, bsButton(ns("btnAll"), "Todos", icon = icon("edit"), class="btn-block", style = "success"))
                        )
                        ,fluidRow(column(width=12,bsButton(ns("btnPlot"), "Update", icon = icon("check"), class="btn-block", style = "primary")))
    )
    tagList( fluidRow(panelLeft, panelMain, panelRight))
}    
