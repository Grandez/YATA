modMainInput <- function(id) {
    # Create a namespace function using the provided id
    ns <- NS(id)
    
    tagList(fluidRow( column(10, box(width=NULL, plotlyOutput("plotMain")))
                     ,column(2
                       , box(width=NULL, title = "Position", solidHeader = T, status = "primary", includeHTML("htm/posicion.html"))
                       , box( width=NULL, title = "Summary", solidHeader = T, status = "primary", includeHTML("htm/resumen.html"))
                     ))
            ,fluidRow( column(1, bsButton("btnSimulate", style="success", label = "Simulate" ))
                      ,column(1, bsButton("btnStop",     style="danger",  label = "Stop"     ))
                      ,column(1, bsButton("btnNext",     style="warning", label = "Next"     ))
                      ,column(1, bsButton("btnOper",     style="info",    label = "Operar"   ))
                      ,column(1, bsButton("btnSave",     style="dark",    label = "Save"     ))
            )
            ,fluidRow(column(5, box(width=NULL, title = "Tickers", solidHeader = T, status = "primary", collapsible = T,
                                    DT::dataTableOutput("tblBodyData")))
                     ,column(3, box(width=NULL, title = "Position", solidHeader = T, status = "primary", collapsible = T,
                                    DT::dataTableOutput("tblBodyPos")))
                     ,column(4, box(width=NULL, title = "Trading", solidHeader = T, status = "primary", collapsible = T,
                                    DT::dataTableOutput("tblBodyTrade")))
                     
             )
            
    #    ,checkboxInput(ns("heading"), "Has heading"),
    #    selectInput(ns("quote"), "Quote", c(
    #        "None" = "",
    #        "Double quote" = "\"",
    #        "Single quote" = "'"
    #    ))
    )
}