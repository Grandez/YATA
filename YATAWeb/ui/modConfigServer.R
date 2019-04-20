
modConfig <- function(input, output, session, parent) {
    ns <- session$ns    

    vars <- reactiveValues( loaded = F
           # Tabla de tickers, se inicializa para que exista en init 
           ,tickers = NULL   # TBLTickers$new("Tickers") # Tabla de tickers
           ,changed = FALSE
           ,parms = NULL
           ,thres = NULL
           ,clicks = 0
           ,dateChanged = FALSE # Evita el bucle ajustando fechas
    )

    ###################################################################################################
    ### PRIVATE CODE
    ###################################################################################################

    loader         <- function() {
        lista = list.dirs(path = "www/themes", full.names = FALSE, recursive = FALSE)
        updateSelectInput(session, "theme", choices=lista)
        vars$loaded = TRUE
    }    
    
    if (!vars$loaded) loader()
    
    ########################################################################################
    ### OBSERVERS 
    ########################################################################################
    
    observeEvent(input$theme, {
        # output$cssTheme <- renderUI({ tags$head(tags$link(rel = "stylesheet", type = "text/css",
        #                         href = paste0(input$theme, "/bootstap.min.css")))
        # })
    })
    
    # Lo devuelve cada vez que entra aqui
    return(reactive({vars$changed}))
}


