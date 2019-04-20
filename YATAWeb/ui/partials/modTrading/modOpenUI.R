modOpenInput <- function(id) {
  ns = NS(id)
  useShinyjs()
 
  fluidRow( column(width=6, DT::dataTableOutput(ns("tblOpen")))
  )  
}