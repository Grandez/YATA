
# Clase base de los ficheros y tablas
# Emula una tabla
YATATable <- R6Class("YATATable",
   public = list(
       name     = "friendlyName"
      ,table    = "tableName"
      ,df       = NULL   # Selected data
      ,dfa      = NULL   # All data
      ,metadata = NULL
      ,initialize  = function(refresh=TRUE, name = NULL, table = NULL)    {
                       if (!is.null(name))  {
                           self$name  = name
                           self$table = name
                       }
                       if (!is.null(table)) self$table = table
                       if (refresh) self$refresh()
                       self$metadata = getMetadata(self$table)
                  }
      ,select   = function(key) { stop("This method is virtual") }
      ,insert   = function(values, isolated=T) {
          sql = paste("INSERT INTO ", self$table, "(")
          sql = paste(sql, toString(names(values)))
          sql = paste(sql, ") VALUES (", toString(rep("?", length(values))), ")")
          executeUpdate(sql, values, isolated=isolated)
      }
      ,update = function(values, keys, isolated=T) {
          sql = paste("UPDATE ", self$table, "SET")
          upd = gsub(",", " = ?,", paste(toString(names(values)), ","))
          upd = substr(upd, 1, nchar(upd) - 1)
          sql = paste(sql, upd, "WHERE")
          key = gsub(",", " = ? AND", paste(toString(names(keys)), ","))
          key = substr(key, 1, nchar(key) - 3)
          sql = paste(sql, key)
          executeUpdate(sql, parms=c(values, keys), isolated=isolated)
      }
      ,refresh  = function(method = NULL, ...) {
                      if (is.null(self$dfa)) { # dfa tiene todo, no tiene sentido refrescarlo
                          ##JGG mirar con substitute
                          #parms = as.list(...)
                          # Cargar por tabla
                          if (is.null(method))  {
                              method = "loadTable"
                              parms = list(self$table)
                          }
                          self$dfa = do.call(method, parms)
                          self$df  = self$dfa
                      }
                      invisible(self)
                  }
      ,setData     = function(df)            { self$dfa = df; self$df=df; invisible(self) }
      ,getRow      = function(row)             {
                        if (is.numeric(row))         return (self$df[row,])
                        if (toupper(row) == "FIRST") return (self$df[1,])
                        if (toupper(row) == "LAST")  return (self$df[nrow(self$df),])
                        stop(MSG_BAD_ARGS())
      }

      ,nrow        = function()                { nrow(self$df)                               }
      ,getColumn   = function(colname)         { self$df[,colname]                           }
      ,getField    = function(row, col)        { row = self$getRow(row); return (row[1,col]) }
      ,getColumns  = function(colnames)        { self$df[,colnames]                          }
      ,fieldIndex  = function(name)            { which(private$fields == name)[1]            }
      ,fieldName   = function(index)           { private$fields[index]                       }
      ,fieldsCount = function()                { length(private$fields)                      }
      ,asExpr      = function(name, df="df")   { parse(text=paste0(df,"$",name))             }

      ,print       = function(...)             { cat(self$name)                              }
   )
)
