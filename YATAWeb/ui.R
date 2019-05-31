YATAPage("YATA!",id="mainbar", selected=PNL_TST
           ,theme = "yata/yata.css"
           #,theme=shinytheme("slate")
           ,useShinyjs(debug=T)
     #,tabPanel("Test",          value=PNL_TST,      modTestInput(PNL_TST))
     ,tabPanel("On Line",       value=PNL_OL,   modOnLineInput(PNL_OL))
     ,tabPanel("Portfolio",     value=PNL_PRF,  modPortfolioInput(PNL_PRF))
     ,tabPanel("Analysis",      value=PNL_ANA,  modAnalysisInput(PNL_ANA))
     ,tabPanel("Simulation",    value=PNL_SIM,  modSimmInput(PNL_SIM))          
     ,tabPanel("Trading",       value=PNL_TRAD, modTradingInput(PNL_TRAD))
     
     # ,tabPanel("Configuration", value=PNL_CONF,     modConfigInput(PNL_CONF))
     # ,navbarMenu("Ayuda"
     #      ,tabPanel("Manual",   value=PNL_MAN_USR,  modManUserUI(PNL_MAN_USR))
     #      ,tabPanel("Tecnico",  value=PNL_MAN_TECH, modManTechUI(PNL_MAN_TECH))
     # )
)

  