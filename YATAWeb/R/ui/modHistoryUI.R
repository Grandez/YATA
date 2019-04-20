modHistoryInput <- function(id) {
    # Create a namespace function using the provided id
    ns <- NS(id)
    
    tagList(fluidRow( h2("Historia"))
            ,fluidRow( column(10, box(width=NULL, DT::dataTableOutput("tblHistory"))))
            ,bsButton("btnSummSave", label = "Save", style="success")
            
    )
}