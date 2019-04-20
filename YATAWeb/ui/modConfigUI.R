modConfigInput <- function(id) {
    # Create a namespace function using the provided id
    ns <- NS(id)
    #$('#data2').addClass('form-control');
    tagList(
        # uiOutput(ns("cssTheme"))
        # ,selectInput(ns("theme"), label = ("Tema"), choices = list("YATA"))
    )
}