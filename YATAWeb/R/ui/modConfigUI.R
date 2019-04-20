modConfigInput <- function(id) {
    # Create a namespace function using the provided id
    ns <- NS(id)
    
    tagList(
         fluidRow(box(width=12, plotlyOutput("plotConfig")))
        ,fluidRow(
             box(width=3, title = "Investor", solidHeader = T, status = "primary", collapsible = T
                ,textInput("txtPrfName", label = "Nombre", value = "Javier")
                ,selectInput("rdoPrfProfile", label = "Perfil"
                       ,choices = c("Arriesgado" = 1,"Audaz"=2,"Moderado"=3,"Conservador"=4,"Ahorrador"=5)
                       ,selected = 3)
                ,selectInput("rdoPrfScope", label = "Scope"
                             ,choices = c("Intraday" = 1,"Short"=2,"Medium"=3,"Long"=4)
                             ,selected = 2)
                
                ,numericInput("txtPrfImpInitial", label = "Cash", value=10000, min=1000, step=500)
             )                         
            ,box(width=3, title = "Currency", solidHeader = T, status = "primary", collapsible = T
                 ,selectInput("moneda", label = "Moneda", choices = NULL)            
                 ,dateInput("dtFrom", "Desde:", value = "2012-02-29", format = "dd/mm/yy", startview = "year")
                 ,dateInput("dtTo",   "Hasta:", value = "2012-02-29", format = "dd/mm/yy", startview = "year")
                 ,verbatimTextOutput("brush")
            )            
           ,box(width=6, title = "Simulation", solidHeader = T, status = "primary", collapsible = T
                ,fluidRow(column(6,selectInput("modelos", label = "Modelo", choice=NULL)
                                  ,numericInput("processDelay", label = "Delay", value=2,min=0,max=30,step=1)
                                )
                         ,column(6, radioButtons("rdoProcess", label = "Mode"
                                                 ,choices = list( "Automatic" = MODE_AUTOMATIC
                                                                 ,"Inquiry"   = MODE_INQUIRY
                                                                 ,"Manual"    = MODE_MANUAL)
                                                 ,selected = MODE_AUTOMATIC)
                               ) 
                ) 
               
           )           
         )
        ,fluidRow(bsButton("btnLoad", label = "Cargar datos", style="success", size="large"))
        ,fluidRow(
            box(width=12, title = "Modelo", solidHeader = T, status = "primary", collapsible = T
                ,fluidRow(
                     box(width=4, title = "Indicadores", solidHeader = T, status = "primary", collapsible = T
                         ,h3("No hay indicadores", id="modIndicators")
                     )         
                    ,box(width=4, title = "Triggers", solidHeader = T, status = "primary", collapsible = T
                         ,h3("No hay triggers", id="modTriggers")
                    )
                 )           
            )           
         )
        ,fluidRow(
            box(width=12, title = "Documentacion", solidHeader = T, status = "primary", collapsible = T, uiOutput("modelDoc"))
        )    
        
    )

}