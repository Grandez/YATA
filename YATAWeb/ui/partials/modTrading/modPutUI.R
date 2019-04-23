modPutInput <- function(id) {
  ns = NS(id)
  useShinyjs()
  
  tableOper = {tags$table(class = "box-table",
                      tags$tr(tags$td("Camara", class="tblLabel"),
                              tags$td(class="tblRow", colspan="6",
                                      selectInput(ns("cboCamera"), label=NULL, choices=c(""))
                              )
                      )
                      ,tags$tr(tags$td("Base", class="tblLabel"),
                               tags$td(class="tblRow", colspan="6",
                                       selectInput(ns("cboBase"), label=NULL, choices=c(""))
                               )
                      )
                      ,tags$tr(tags$td("Moneda", class="tblLabel")
                               ,tags$td(class="tblRow", colspan="6",
                                        selectInput(ns("cboCTC"), label=NULL, choices=c("No curencies"="None"))
                               )
                      )
                      ,tags$tr( tags$td("Amount", class="tblLabel")
                                ,tags$td(class="tblRow",colspan="6",numericInput(ns("impAmount"), label = NULL, value = 0))
                      )
                      
                      ,tags$tr( tags$td("Proposal", class="tblLabel")
                                ,tags$td(class="tblRow",colspan="6",numericInput(ns("impProposal"), label = NULL, value = 0))
                      )
                      ,tags$tr( tags$td("Limit", class="tblLabel")
                                ,tags$td(class="tblRow",colspan="6",numericInput(ns("impLimit"), label = NULL, value = 0))
                      )
                      ,tags$tr( tags$td("Stop", class="tblLabel")
                                ,tags$td(class="tblRow",colspan="6",numericInput(ns("impStop"), label = NULL, value = 0))
                      )
                      
                      ,tags$tr( tags$td()
                                ,tags$td( colspan="6", bsButton(ns("btnOK"), "Put Order", icon = icon("check"), style = "success")
                                          , bsButton(ns("btnXCancel"), "Cancel", icon = icon("remove"), style = "danger")
                                )
                      )
                      ,tags$tr( tags$td()
                                ,tags$td( colspan="6", htmlOutput(ns("lblStatus")))
                      )
  )                     
  }

  tableFun = { tags$table(class = "boxTable"
                           ,tags$tr( tags$td("Motivo", class="tblLabel")
                                     ,tags$td(class="tblRow", colspan="6",verbatimTextOutput("value"))
                           )
                           #     ,tags$tr( tags$td("Exchange Fee"), tags$td(textOutput(ns("lblFeeExch")))                        )
                           #     ,tags$tr( tags$td("Block Fee"),    tags$td(textOutput(ns("lblBlockExch")))                      )
                           #     ,tags$tr( tags$td("Effective"),    tags$td(textOutput(ns("lblCTCAmount")))                      )
                           #     ,tags$tr( tags$td("Total"),        tags$td(textOutput(ns("lblTotal")))                          )
                           #     ,tags$tr( tags$td("Comment"),      tags$td(textAreaInput(ns("txtCommentTotal"), label=NULL, rows=5)))
                           #     ,tags$tr( tags$td(bsButton(ns("btnOK"), "Make", icon = icon("check"), style = "primary"))
                           #              ,tags$td(bsButton(ns("btnCancel"), "Cancel", icon = icon("check"), style = "danger"))
                           #             )
                           # )
  )
  }
  
  fluidRow( column(width=2)
           ,column(width=4, h3("Operativo"),  tableOper)
           ,column(width=4, h3("Functional"), tableFun)
           )
}