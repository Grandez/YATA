#modHistory <- function(input, output, session, action) {
#row.names(data) = data[,1]
#datatable(data[,-1])

saveSession <- function(input, output, session) { saveSessionSummary(vars$sessions) }

observeEvent(input$btnSummSave, { saveSession(input, output, session) })

histDataTable <- function(data) {
    sketch = htmltools::withTags(table(
        class = 'display',
        thead(
            tr(
                th(rowspan = 3, 'Session')
                ,th(colspan = 6, 'Case')
                ,th(colspan = 2, 'Model')
                ,th(colspan = 3, 'Operations')
                ,th(colspan = 2, 'Result')
            ),
            tr(
                lapply(colnames(vars$sessions), th)
            )
        )
    ))
    datatable(data, container=sketch,rownames=F)
    
}
    output$tblHistory  = DT::renderDataTable({vars$sessions })

    
#}

#}    
    
