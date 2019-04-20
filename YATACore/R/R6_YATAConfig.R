YATAConfig <- R6Class("YATAConfig",
      public = list(
           symbol   = NULL
          ,currency = "EUR"
          ,initial  = 0.0
          ,from     = NULL
          ,to       = NULL
          ,dec      = 2
          ,delay    = 0   # retraso en decimas de segundo para dibujar
          ,mode     = MODE_AUTOMATIC           # Modo de simulacion
          ,summFileName = NULL
          ,summFileData=NULL
      )
)
