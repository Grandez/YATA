modCurrencyUI <- function(id) {
    ns <- NS(id)
    useShinyjs()
    # panelLeft = column(id = ns("left"), width=2, style="display: none"
    #                    ,radioButtons(ns("swSource"),"Source"   , selected = 1, choices = list("Price" = 0, "Volume" = 1))
    #                    ,bsButton(ns("btnConfig"), "Moneda", icon = icon("check"), style = "primary")
    # )
    
    plotType  = list("Linear" = PLOT_LINE, "Log" = PLOT_LOG, "Candlestick" = PLOT_CANDLE, "Bar"=PLOT_BAR)
    plotData  = list("Price" = 1, "Volume" = 2, "Choice 3" = 3) 
    panelMain = boxPlus(width=NULL, closable = F, collapsible = TRUE
                    ,title = textOutput(ns("txtMainPlot"))
                    ,status = "info"
                    ,solidHeader = FALSE
                    # ,enable_dropdown = TRUE
                    # ,dropdown_icon = "wrench"
                    # ,dropdown_menu = dropdownItemList(
                    #     wellPanel("Primary",
                    #         selectInput(ns("cbo11"), label = NULL, choices = plotData, selected = 1)
                    #        ,selectInput(ns("cbo12"), label = NULL, choices = plotType, selected = PLOT_LINE)
                    #     )
                    #     ,wellPanel("Secondary",
                    #                selectInput(ns("cbo21"), label = NULL, choices = plotData, selected = 2)
                    #               ,selectInput(ns("cbo22"), label = NULL, choices = plotType, selected = PLOT_BAR)
                    #     )
                    #     ,bsButton(ns("btnPlots"), style="success", label = "Update")
                    # )
            ,fluidRow(plotlyOutput(ns("plotCTC"), width="100%",height="500px"))   
            ,fluidRow( column(width=6, DT::dataTableOutput(ns("tblCTC")))
                      ,column(width=6, fluidRow( DT::dataTableOutput(ns("tblPos"))
                                                ,DT::dataTableOutput(ns("tblFlow"))
                                       )
                      )
            )
    )
    tagList( fluidRow(panelMain))
}