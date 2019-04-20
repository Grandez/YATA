                                 
modIndicatorsInput <- function(id) {
    ns <- NS(id)
    useShinyjs()
    
    panelTool = box(width=NULL
                    , title = p("Toolbox",actionButton( ns("SBLClose"), "",icon = icon("remove"), class = "btn-xs"))
    )
    panelLeft = box( width=NULL
        , title = p("Config",actionButton( ns("SBLClose"), "",icon = icon("remove"), class = "btn-xs"))
        ,solidHeader = T, status = "primary"
        ,textInput(ns("txtPrfName"), label = "Nombre", value = "Javier")
        ,selectInput(ns("rdoPrfProfile"), label=NULL, selected = PRF_MODERATE
                     , choices=makeList(
                         c(PRF_SAVER,PRF_CONSERVATIVE,PRF_MODERATE,PRF_BOLD,PRF_DARED)
                         ,c(LBL.SAVER,LBL.CONSERVATIVE,LBL.MODERATE,LBL.BOLD,LBL.DARED)))
        ,numericInput(ns("txtPrfImpInitial"), label = "Capital", value=10000, min=1000, step=500)
        ,hr()
        ,selectInput(ns("cboMonedas"), label = "Moneda", choices = NULL, selected=NULL)
        ,dateInput(ns("dtFrom"),"Desde", value = "2012-02-29", format = "dd/mm/yy", startview = "year")
        ,dateInput(ns("dtTo"),NULL, value = "2012-02-29", format = "dd/mm/yy", startview = "year")
        ,hr()
        ,selectInput(ns("rdoPrfScope"), label=NULL, selected=3
                                    ,choices = c("Intraday" = 1,"Short"=2,"Medium"=3,"Long"=4))
                       
        ,selectInput(ns("cboModels"), label="Modelo", choices=NULL, selected=NULL)
        ,hr()
        ,disabled(bsButton(ns("btnSave"), label = "Guardar", style="success", size="large"))
    )
    
    panelRight = box( width=NULL
                       ,title = p("Config",actionButton( ns("SBRClose"), "",icon = icon("remove"), class = "btn-xs"))
                       ,solidHeader = T
                       ,status = "primary"
                       ,wellPanel(radioButtons(ns("rdoPlot"), label="Graph",selected = PLOT_LINEAR
                                                        , choices = list( "Linear"  = PLOT_LINEAR
                                                                          ,"Log"     = PLOT_LOG
                                                                          ,"Candles" = PLOT_CANDLE)
                                ))
                      ,wellPanel(checkboxGroupInput(ns("chkIndicators"), label = NULL)
                      ,checkboxInput(ns("chkShowInd"),   label=LBL.SHOW_IND,    value = TRUE)                                 
                      ,wellPanel(radioButtons(ns("rdoProcess"), label="Mode",selected = MODE_AUTOMATIC
                                              ,choices = list( "Automatic" = MODE_AUTOMATIC
                                                               ,"Inquiry"   = MODE_INQUIRY
                                                               ,"Manual"    = MODE_MANUAL)))
                                              
                      )
    )
    panelMain = box( width=NULL
                      ,title = p("Config",actionButton( ns("SBLOpen"), "",icon = icon("angle-left"), class = "btn-xs")
                                         ,actionButton( ns("SBROpen"), "",icon = icon("angle-right"), class = "btn-sm"))
                      ,solidHeader = T
                      ,status = "primary"
                     ,fluidRow(plotlyOutput(ns("plotLong"), width="100%",height="500px"))
                     ,fluidRow( box(width=2,id="box0",title="caja 0", status="primary",checkboxGroupInput(ns("chkInds0"), label = NULL))
                               ,box(width=2,id="box1",title="caja 1", status="primary",checkboxGroupInput(ns("chkInds1"), label = NULL))
                               ,box(width=2,id="box2",title="caja 2", status="primary",checkboxGroupInput(ns("chkInds2"), label = NULL))
                               ,box(width=2,id="box3",title="caja 3", status="primary",checkboxGroupInput(ns("chkInds3"), label = NULL))
                               ,box(width=2,id="box4",title="caja 4", status="primary",checkboxGroupInput(ns("chkInds4"), label = NULL))
                               ,box(width=2,id="box5",title="caja 5", status="primary",checkboxGroupInput(ns("chkInds5"), label = NULL))
                               )
        )
    
    tagList(fluidRow( hidden(column(id=ns("pnlLeft"),  panelLeft,  width=2))
                            ,column(id=ns("pnlMain"),  panelMain,  width=12)
                     ,hidden(column(id=ns("pnlRight"), panelRight, width=2))
                      
    ))
    
}