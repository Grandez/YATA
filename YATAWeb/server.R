
vars <- reactiveValues(lstData = NULL
                       ,fila = 1
                       ,clicks = 0
                       ,numOpers = 0
                       ,buy = 0
                       ,sell = 0
                       ,trading = NULL
                       ,posicion=NULL
                       ,estado=0 # 0 = Inactivo
                       ,mode = 0
                       ,dfd = NULL   # Datos
                       ,dfi = NULL   # Datos con indicadores
                       ,dfc = NULL   # Datos vistos
                       ,dfp = NULL
                       ,dft = NULL
                       ,sessions=NULL
)


server <- function(input, output, session) {
    # No lo captura en el modulo
    # onclick("trad-tradSBOpen", function() {
    #     shinyjs::addCssClass(id="trad-tradMain", "col-sm-10")
    #     shinyjs::removeCssClass(id="trad-tradMain", "col-sm-12")
    #     shinyjs::show(id = "trad-tradSB")
    # }, add=TRUE)
    # 
    # onclick("trad-tradSBClose", function() {
    #     shinyjs::hide(id = "trad-tradSB")
    #     shinyjs::addCssClass(id="trad-tradMain", "col-sm-12")
    #     shinyjs::removeCssClass(id="trad-tradMain", "col-sm-10")
    # }, add=TRUE)
    
    # files.code = list.files("ui", pattern="*Code.R$", full.names=TRUE, ignore.case=F)
    # sapply(files.code,source,local=T)
    
    # files.server = list.files("ui", pattern="*Server.R$", full.names=TRUE, ignore.case=F)
    # sapply(files.server,source,local=T)
 
  observeEvent(input$show, {
    browser()
    showModal(dataModal())
  })
  
    observeEvent(input$mainbar,{

        updateTextInput(session, "nsPreffix", label=NULL, value=input$mainbar); 
        if (input$mainbar == PNL_TST)  callModule(modTest,      PNL_TST)
        if (input$mainbar == PNL_OL)   callModule(modOnLine,    PNL_OL)
        if (input$mainbar == PNL_PRF)  callModule(modPortfolio, PNL_PRF)      
        if (input$mainbar == PNL_TRAD) callModule(modTrading,   PNL_TRAD)
        if (input$mainbar == PNL_ANA)  callModule(modAnalysis,  PNL_ANA)
        if (input$mainbar == PNL_CONF) callModule(modConfig,    PNL_CONF)
        if (input$mainbar == PNL_SIM)  callModule(modSimm,      PNL_SIM)
#        if (input$mainbar == PNL_SIMM) callModule(modMain,       PNL_SIMM, changed)
        if (input$mainbar == PNL_HELP) callModule(modManual,    PNL_HELP)

        if (input$mainbar == PNL_SYS)  callModule(modSystem,     PNL_SYS)
        if (input$mainbar == PNL_IND)  callModule(modIndicators, PNL_IND)        
  })
    observeEvent(input$YATALeftBar, { browser(); shinyjs::hide("leftbar")})
    observeEvent(input$YATARightBar, { browser(); shinyjs::hide("leftbar")})
    
    observeEvent(input$btnjs, { browser(); shinyjs::hide("leftbar")})
    observeEvent(input$btnLeft, { browser(); print("Para")})
    observeEvent(input$btnRight, { browser(); print("Para")})
    #callModule(modOnLine, "online")
    #changed = callModule(modConfig, "config", parent=session)
    #      callModule(modMain,   "main",   parent=session, changed)
          
# observeEvent(changed(),{
#     browser()
#     # Se llama cada vez que se cambian datos en Config
#     # browser()
#     #        msg <- sprintf("Changed es %s", changed())
#     # cat(msg, "\n")
#     callModule(modMain,   "main",   parent=session, changed)
# 
#   })
          
    #source("ui/modMainServer.R")
    
    #output$texto = renderText({ txt() })
    # browser()
    # vars1 = vars
    # vars2 = callModule(modGlobals, "globals")
    # df <- callModule(linkedScatter, "scatters", reactive(mpg),
    #                  left = reactive(c("cty", "hwy")),
    #                  right = reactive(c("drv", "hwy"))
    # )
    
    # observeEvent(input$navbar, { browser() }, ignoreInit = T)
    # 
    # output$plot <- renderPlot({
    #     plot(cars, type=input$plotType)
    # })
    # 
    # output$summary <- renderPrint({
    #     summary(cars)
    # })
    # 
    # output$table <- DT::renderDataTable({
    #     DT::datatable(cars)
    # })
}

