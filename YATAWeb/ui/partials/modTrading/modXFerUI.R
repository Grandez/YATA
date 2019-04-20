modXFerInput <- function(id) {
  ns = NS(id)
  useShinyjs()
  
  table = {tags$table(class = "box-table",
        tags$tr(tags$td("Origen", class="tblLabel"),
                tags$td(class="tblRow", colspan="6",
                        selectInput(ns("cboFrom"), label=NULL, choices=c("Cash"="Cash"))
                )
        )
        ,tags$tr(tags$td("Destino", class="tblLabel"),
                 tags$td(class="tblRow", colspan="6",
                         selectInput(ns("cboTo"), label=NULL, choices=c("Cash"="Cash"))
                 )
        )
        ,tags$tr(tags$td("Moneda", class="tblLabel")
                 ,tags$td(class="tblRow", colspan="6",
                          selectInput(ns("cboXferCurrencies"), label=NULL, choices=c("No curencies"="None"))
                 )
        )
        ,tags$tr( tags$td("Saldo", class="tblLabel")
                  ,tags$td(class="tblRow",colspan="6",verbatimTextOutput(ns("lblXferSaldo")))
        )
        
        ,tags$tr( tags$td("Amount", class="tblLabel")
                  ,tags$td(class="tblRow",colspan="6",numericInput(ns("txtAmount"), label = NULL, value = 0))
        )
        ,tags$tr( tags$td("Fee", class="tblLabel")
                  ,tags$td(class="tblRow",colspan="6",numericInput(ns("txtXferFee"), label = NULL, value = 0))
        )
        ,tags$tr(tags$td("Total", class="tblLabel")
                 ,tags$td(class="tblRow",colspan="6",numericInput(ns("txtXferFee"), label = NULL, value = 0))
        )
        ,tags$tr( tags$td()
                  ,tags$td("Amount", class="tblLabel")
                  ,tags$td(class="tblRow",verbatimTextOutput(ns("lblXferAmount")))
                  ,tags$td("Efectivo", class="tblLabel")
                  ,tags$td(class="tblRow",verbatimTextOutput(ns("lblXferEfectivo")))
                  ,tags$td("Fee", class="tblLabel")
                  ,tags$td(class="tblRow",verbatimTextOutput(ns("lblXferFee")))
        )
        ,tags$tr( tags$td()
                  ,tags$td( colspan="6", bsButton(ns("btnOK"), "Transfer", icon = icon("check"), style = "success")
                                       , bsButton(ns("btnXCancel"), "Cancel", icon = icon("remove"), style = "danger")
                  )
        )
        ,tags$tr( tags$td()
                  ,tags$td( colspan="6", htmlOutput(ns("lblStatus")))
        )
  )                     
  }
  tagList(fluidRow(column(width=4)
                   ,column(width=6, table)))
}  
