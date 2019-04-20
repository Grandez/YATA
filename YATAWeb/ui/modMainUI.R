modMainInput <- function(id) {
    ns <- NS(id)
    useShinyjs()
    tagList(
        useShinyjs()
        ,box(
            fluidRow( column(10 
                             # ,box(width=NULL, plotlyOutput(ns("plotMain")))
                             ,tabBox(
                                 # title = "First tabBox",
                                 # The id lets us use input$tabset1 on the server to find the current tab
                                 id = "tabset1", width = NULL,
                                 tabPanel("Largo", plotlyOutput(ns("plotMain"))),
                                 tabPanel("Intermedio", "Tab content 2"),
                                 tabPanel("Corto", "Tab content 2")
                             )
                             )
                 ,column(2, box( width=NULL, title = "Position", solidHeader = T, status = "primary" 
                         ,withTags({ table(class = "boxTable",
                                           tr(td("Euro"),   td(colspan="2", class="lblData", textOutput(ns("lblPosFiat"))))
                                          ,tr(td(textOutput(ns("lblMoneda"))), td(colspan="2", class="lblData", textOutput(ns("lblPosMoneda"))))
                                          ,tr(td("Total"),  td(colspan="2", class="lblData", textOutput(ns("lblPosTotal"))))
                                          ,tr(td("Estado"), td( img(id=ns("resDown"), icon("triangle-bottom", class = "rojo", lib="glyphicon"))
                                                               ,img(id=ns("resUp"),   icon("triangle-top",   class = "verde", lib="glyphicon")))
                                                           ,td(             class="lblData", textOutput(ns("lblEstado"))))
                                          ,tr(td("Tickers"),td(colspan="2", class="lblData", textOutput(ns("lblResMov"))))
                                          ,tr(td("Opers"),  td(             class="lblData", textOutput(ns("lblResC")))
                                                           ,td(             class="lblData", textOutput(ns("lblResV"))))
                                          ,tr(td("Date"),   td(colspan="2", class="lblData", textOutput(ns("lblPosDate"))))
                                          ,tr(td("Trend"),   td(colspan="2", class="lblData", textOutput(ns("lblTrend"))))

                                     )                  
                             
                                   }))
                   , box( width=NULL, title = "Indicators", solidHeader = T, status = "primary" 
                         ,checkboxGroupInput(ns("chkPlots1"), label = NULL)
                         ,checkboxGroupInput(ns("chkPlots2"), label = NULL)
                         ,checkboxGroupInput(ns("chkPlots3"), label = NULL)
                        )                   
             ))
            ,width=NULL, collapsible = T, title = "Plot", solidHeader = T, status="primary")
        ,fluidRow( id="rowButtons"
                  ,column(1, bsButton(ns("btnSimulate"), style="success", label = "Simulate" ))
                  ,column(1, bsButton(ns("btnStop"),     style="danger",  label = "Stop"     ))
                  ,column(1, bsButton(ns("btnNext"),     style="warning", label = "Next"     ))
                  ,column(1, bsButton(ns("btnOper"),     style="info",    label = "Operar"   ))
                  ,column(1, bsButton(ns("btnExport"),   style="dark",    label = "Excel"    ))
            )
            ,fluidRow(column(5, box(width=NULL, title = "Tickers", solidHeader = T, status = "primary", collapsible = T,
                                    DT::dataTableOutput(ns("tblBodyData"))))
                     ,column(3, box(width=NULL, title = "Position", solidHeader = T, status = "primary", collapsible = T,
                                    DT::dataTableOutput(ns("tblBodyPos"))))
                     ,column(4, box(width=NULL, title = "Trading", solidHeader = T, status = "primary", collapsible = T,
                                    DT::dataTableOutput(ns("tblBodyTrade"))))
                     
             )
            
    #    ,checkboxInput(ns("heading"), "Has heading"),
    #    selectInput(ns("quote"), "Quote", c(
    #        "None" = "",
    #        "Double quote" = "\"",
    #        "Single quote" = "'"
    #    ))
    )
}