
# Clase base de los ficheros
YATADB <- R6Class("YATADB",
   public = list(
      name       = "Database"
     ,active     = NULL
     ,getDefault = function()     { self$getTable(self$active) }
     ,getTable   = function(name) { pos = which(private$.tableNames == name)[1]
                                    if (is.na(pos)) return(NA)
                                    private$.tables[[pos]]
                                  }
     ,getTables = function() { private$.tableNames }
     ,addTables = function(tables) {
         for (t in tables) {
             if (is.na(self$getTable(t$name))) {
                private$.tableNames = c(private$.tableNames, t$name)
                private$.tables     = c(private$.tables,     t)
                self$active = t$name
             }
         }
         invisible(self)
     }
     ,print      = function()     { cat(self$name, "\n") }
     ,initialize = function(name) { self$name = name     }
   )
  ,private = list(.tableNames = c(), .tables = c() )

)

