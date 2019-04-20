modDlgVerifyUI <- function(id) {
    tagList(
        modalDialog(title="Verify operation"
                    ,fluidRow(box(width=12, title="Operacion", status = "primary"
                                  ,fluidRow(column(6,textInput(ns("dlgOperFecha"), "Fecha",     value=oper$operDate)
                                                   ,textInput(ns("dlgOperOper"),  "Operacion", value=txt)
                                  )
                                  ,column(6,textInput(ns("dlgOperVol"),  "Cantidad", value=abs(oper$units))
                                          ,textInput(ns("dlgOperValue"),"Precio",   value=abs(oper$price))
                                          ,textInput(ns("dlgOperTotal"),"Total",    value=abs(oper$amount))
                                  )
                                  )))
                    ,fluidRow(column(6, box(width=NULL, title="Antes",   status = "primary", wellPanel(includeHTML("htm/dlgBefore.html"))))
                              ,column(6, box(width=NULL, title="Despues", status = "primary", wellPanel(includeHTML("htm/dlgAfter.html"))))
                    )
                    ,footer = tagList(
                        bsButton(ns("btnOperOK"),       label = "Realizar", style="primary")
                        ,bsButton(ns("btnOperESC"),      label = "Anular",   style="secondary")
                    )
        )
        
    )
}
