TBLAccounts = R6::R6Class("TBLAccounts", inherit=YATATable,
     public = list(
         # Column names
          ID_CLEARING  = "ID_CLEARING"
         ,ID_CURRENCY  = "CURRENCY"
         ,NAME         = "NAME"
         ,BALANCE      = "BALANCE"
         ,CC           = "CC"
         ,initialize = function() {
             self$name="Accounts";
             self$table = "ACCOUNTS";
             super$refresh()
             tctc = TBLCurrencies$new()
             tmp = tctc$df[, c(tctc$SYMBOL, tctc$NAME)]
             self$dfa = merge(self$dfa, tmp, by.x = self$ID_CURRENCY, by.y = tctc$SYMBOL)
             self$df = self$dfa

         }
         ,getCombo = function(clearing) {
             if (!is.null(clearing) && nchar(clearing) > 0) {
                 df = self$df %>% filter(ID_CLEARING == clearing)
                 setNames(df[, self$ID_CURRENCY], self$df[,self$NAME])
             }
        }
     )
     ,private = list (
     )
)
