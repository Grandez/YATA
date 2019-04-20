YATAOperation <- R6Class("YATAOperation",
     public = list(
          initialize = function() {
             private$flows = TBLFlow$new()
             private$portfolio = TBLPortfolio$new()
             private$opers     = TBLOperation$new()
          }
         ,transfer = function(from, to, currency, amount) {
             idOper = getYATAID()
             beginTrx(TRUE)
             private$makeTransfer(idOper, from, to, currency, amount)
             if (from != "Cash")
                 private$portfolio$updatePosition(idOper, from, currency, amount * -1, Sys.time(), TRUE)
             if (to   != "Cash")
                 private$portfolio$updatePosition(idOper, to,   currency, amount     , Sys.time(), TRUE)
             commitTrx(TRUE)
         }
         ,add = function(type, clearing, base, counter, amount, proposal, limit, stop) {
             idOper = getYATAID()
             beginTrx(TRUE)
             private$opers$add(idOper, type, clearing, base, counter, amount, proposal, stop, limit)
             commitTrx(TRUE)
             idOper
         }

     )
     ,private = list(flows = NULL, portfolio = NULL, opers = NULL
         ,makeTransfer = function(idOper, from, to, currency, amount) {
             idFlow1 = getYATAID()
             idFlow2 = getYATAID()
             ref = as.numeric(Sys.time())
             tms = Sys.time()
             parms = NULL
             f = private$flows
             fields = c( f$ID_OPER,  f$ID_FLOW,  f$TYPE,     f$CLEARING,     f$BASE
                        ,f$CURRENCY, f$PROPOSAL, f$EXECUTED, f$TMS_PROPOSAL, f$TMS_EXECUTED, f$REFERENCE)

             if (from != "Cash") {
                 val = amount * -1
                 ref = 0
                 if (to != "Cash") ref = idFlow2
                 values = list(idOper, idFlow1, 90, from, currency, currency, val, val, tms, tms, idFlow2)
                 names(values) = fields
                 f$insert(values)
             }
             if (to != "Cash") {
                 ref = 0
                 if (from != "Cash") ref = idFlow1
                 values = list(idOper, idFlow2, 91, from, currency, currency, amount, amount, tms, tms, idFlow1)
                 names(values) = fields
                 f$insert(values)
             }
         }
     )
)

