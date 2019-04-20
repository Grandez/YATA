dataError <- function(failed = FALSE) {
    modalDialog(
        textInput("dataset", "Choose data set",
                  placeholder = 'Try "mtcars" or "abc"'
        ),
        span('(Try the name of a valid data object like "mtcars", ',
             'then a name of a non-existent object like "abc")'),
        if (failed)
            div(tags$b("Invalid name of data object", style = "color: red;")),
        
        footer = tagList(
            #            modalButton("Cancel"),
            actionButton("dlgOK", "OK")
        )
    )
}

dlgOper <- function(input, output, session, oper = NULL) {
    
    if (is.null(oper)) return (NULL);
    txt = ifelse(oper$isBuy(), "Compra", "Venta")

    output$dlgPosFiatB     = renderText({portfolio$saldo()})
    output$dlgPosCurrencyB = renderText({portfolio$getActive()$position})
    output$dlgPosTotalB    = renderText({portfolio$balance()})

    saldo = portfolio$getActive(CURRENCY)$position + oper$amount
    pos   = portfolio$getActive()$position + oper$units
    
    output$dlgPosFiatA     = renderText({saldo})
    output$dlgPosCurrencyA = renderText({pos})
    output$dlgPosTotalA    = renderText({saldo + (pos * oper$price)})
    
    modalDialog(title="Verify operation"
                ,fluidRow(box(width=12, title="Operacion", status = "primary", solidHeader = T
                         ,fluidRow(column(6,textInput("dlgOperFecha", "Fecha",     value=oper$operDate)
                                           ,textInput("dlgOperOper",  "Operacion", value=txt)
                                          )
                                  ,column(6,textInput("dlgOperVol",  "Cantidad", value=abs(oper$units))
                                           ,textInput("dlgOperValue","Precio",   value=abs(oper$price))
                                           ,textInput("dlgOperTotal","Total",    value=abs(oper$amount))
                                         )
                                  )))
                ,fluidRow(column(6, box(width=NULL, title="Antes",   status = "primary", solidHeader = T, wellPanel(includeHTML("htm/dlgBefore.html"))))
                         ,column(6, box(width=NULL, title="Despues", status = "primary", solidHeader = T, wellPanel(includeHTML("htm/dlgAfter.html"))))
                )
                ,footer = tagList(
                     bsButton("btnOperOK",       label = "Realizar", style="primary")
                    ,bsButton("btnOperESC",      label = "Anular",   style="secondary")
                )
    )

    # shinyjs::addClass("lblOperCapital", "form-control")
}
