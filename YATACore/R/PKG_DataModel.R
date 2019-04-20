library("R6")

DB_MODELS     = "Models"
TMOD_GROUPS   = "Groups"
TMOD_MODELS   = "Models"


DB_CURRENCIES = "CTC"
TCTC_INDEX    = "$Index"
TCTC_CURRENCY = "Currency"

TBLPosition = R6::R6Class("TBLPosition", inherit=YATATable,
   public = list(
       ORDER       = DF_ORDER
      ,DATE        = DF_DATE
      ,FIAT        = NULL
      ,CTC         = NULL
      ,BALANCE     = "Balance"
      ,initialize  = function(fiat, ctc) {self$FIAT = fiat; self$CTC  = ctc }
      ,getPosition = function() { self$df[nrow(self$df),]              }
      ,getDecimals = function() { c(self$CTC)                          }
      ,getCoins    = function() { c(self$FIAT, self$CTC, self$BALANCE) }
      ,getDates    = function() { c(self$DATE)                         }
      ,add         = function(date, fiat, ctc, balance) {
          if (is.null(self$df)) {
              self$df = private$makeRecord(date,fiat,ctc,balance)
          }
          else {
              self$df = rbind(self$df, private$makeRecord(date,fiat,ctc,balance, nrow(self$df)))
          }
          invisible(self)
      }
  )
  ,private = list (
      makeRecord = function(date, fiat, ctc, balance, o=0) {
          rec           = as.data.frame(list(o + 1, date, fiat, ctc, balance))
          colnames(rec) = c(self$ORDER, self$DATE, self$FIAT, self$CTC, self$BALANCE)
          rec
     }
  )
)

TBLOperation = R6::R6Class("TBLOperation", inherit=YATATable,
   public = list(
       ORDER    = DF_ORDER
      ,TYPE     = "Type"
      ,DATE     = DF_DATE
      ,UDS      = "Uds"
      ,PRICE    = DF_PRICE
      ,TOTAL    = DF_TOTAL
      ,PMM      = "PMM"
      ,PMA      = "PMA"
      ,POSITION = "Position"
      ,refresh     = function() { } # No data to load
      ,initialize  = function() { super$initialize("Operation") }
      ,getDecimals = function() { c(self$UDS, self$PRICE, self$POSITION)}
      ,getCoins    = function() { c(self$TOTAL, self$PMM)}
      ,getDates    = function() { c(self$DATE)}
      ,getBuy      = function(asc=T) { private$getOpers( 1, asc) }
      ,getSell     = function(asc=T) { private$getOpers(-1, asc) }
      ,getByType   = function(type, asClass=F) {
          if (!asClass) return(self$df[self$df$Type==type,])
          tmp = self$clone()
          tmp$df = tmp$df[Type==type,]
          tmp
      }
      ,getLast     = function(asClass=F) {
          if (!asClass) return(self$df[nrow(self$df),])
          tmp = self$clone()
          tmp$df = tmp$df[nrow(self$df),]
          tmp
      }
      ,add         = function(date, uds, price) {
          if (is.null(self$df)) { # Siempre es una compra
              self$df = private$makeRecord(date, uds, price, price, price)
          }
          else {
              pmm = private$calcPMM(uds, price)
              pma = self$df[nrow(self$df),self$PMA]
              if (uds  > 0) pma = private$calcPMA(uds, price)
              self$df = rbind(self$df, private$makeRecord(date, uds, price, pmm, pma,nrow(self$df)))
          }
          nrow(self$df)
      }
  )
  ,private = list (
     makeRecord = function(date, uds, price, pmm, pma, order=0) {
          type = ifelse(uds > 0, 1 , -1)
          pos = 0
          if (order > 0) pos = sum(self$df[,self$UDS])
          rec           = as.data.frame(list(order + 1, type, date, uds, price, uds * price, pos + uds, pmm, pma))
          colnames(rec) = c(self$ORDER, self$TYPE, self$DATE, self$UDS, self$PRICE, self$TOTAL, self$POSITION, self$PMM, self$PMA)
          rec
      }
    ,calcPMM    = function(uds, price) {
        last = nrow(self$df)
        if (last == 0) return (price)
        den = self$df[last, self$POSITION] + uds
        if (den == 0) return (0)
        return ((self$df[last, self$PMM] + (uds * price)) /  den)
    }
    ,calcPMA    = function(uds, price) {
        last = nrow(self$df)
        return ((self$df[last, self$PMA] + (uds * price)) /  (self$df[last, self$POSITION] + uds))
    }
    ,getOpers   = function(type=1, asc=T) {
        df = self$df[df$Type == type,]
        if (!asc) df = df %>% arrange(desc(eval(self$asVar(self$DATE))))
        df
    }
  )
)


TBLIND = R6::R6Class("TBLIND",
   public = list(
            ORDER  = "Order"
           ,DATE   = "Date"
           ,PRICE  = "Price"
           ,vOLUME = "Volume"
           ,VAR    = "Var"
           ,TREND  = "Trend"
           ,lines  = list()
           ,dfi    = NULL
           ,add    = function(ind, data) {
               if (ind$type == IND_LINE) {
                   self$lines = c(self$lines, enquote(data))
                   names(self$lines) = c(names(self$lines), ind$columns)
               }
               if (ind$type == IND_OVERLAY) {  # Data frame
                   colnames(data) = ind$columns
                   if (is.null(self$dfi)) { self$dfi = data; return (invisible(self)) }
                   self$dfi  = cbind(self$dfi, data)
               }
               invisible(self)
           }
          ,filterByDate = function(from, to) { self$dfi = self$dfi %>% filter(Date >= from, Date <= to)
                                               self$dfi$Order = rep(1:nrow(self$dfi))
                                             }
       )
)

TBLModGroup = R6::R6Class("TBLModGroup", inherit=YATATable,
   public = list(
        ID     = "IdGroup"
       ,ACTIVE = "Active"
       ,NAME   = "Name"
       ,refresh    = function() { super$refresh("loadModelGroups") }
       ,filter     = function(active=T) {
                         if (active) self$df = self$df[self$df$Active==T,]
                         invisible(self)
                     }
 )
)

TBLModMod = R6::R6Class("TBLModMod", inherit=YATATable,
   public = list(
      ID      = "IdModel"
     ,MODEL   = "Model"
     ,GROUP   = "Group"
     ,ACTIVE  = "Active"
     ,SOURCE  = "Source"
     ,CLASS   = "Class"
     ,DESC    = "Description"
     ,refresh = function() { super$refresh("loadModelModels") }
     ,filter  = function(idGroup=NULL, active=T, model=NULL) {
         self$df = self$dfa
         if (!is.null(idGroup)) self$df = self$df %>% filter(Group  == idGroup)
         if (!active)           self$df = self$df %>% filter(Active == T)
         if (!is.null(model))   self$df = self$df %>% filter(Model  == model)
         invisible(self)
    }
  )
)

#
# Tabla de monedas
#

TBLIndex = R6::R6Class("TBLIndex", inherit=YATATable,
   public = list(
        NAME     = "Name"
       ,SYMBOL   = "Symbol"
       ,DECIMAL  = "Decimals"
       ,ACTIVE   = "Active"
       ,refresh  = function() { super$refresh("loadCTCIndex") }
       ,filter   = function(active=T) {
                     if (active) self$df = self$dfa[self$dfa$Active==T,]
                     invisible(self)
       }
       ,select   = function(key) {self$df[self$df$Symbol == key,]}
       ,setRange = function(from = NULL, to = NULL) {
           if (!is.null(from)) self$df = self$df %>% filter(self$df$Symbol >= from)
           if (!is.null(to))   self$df = self$df %>% filter(self$df$Symbol <= to  )
           invisible(self)
       }
       ,initialize  = function(tbName) {
           super$initialize(tbName)
           self$refresh()
           self$filter()
       }
  )
)

########################################################################
### FUNCTIONS
########################################################################


#' @export
createDBModels <- function() {
    # DBModels = YATADB$new(DB_MODELS)
    # tGrp = TBLModGroup$new(TMOD_GROUPS)
    # tMod = TBLModMod$new(TMOD_MODELS)
    # DBModels$addTables(c(tGrp, tMod))
}

#' @export
createDBCurrencies <- function() {
    # DBCurrencies = YATADB$new(DB_CURRENCIES)
    #
    # tIdx = TBLIndex$new(TCTC_INDEX)
    # DBCurrencies$addTables(c(tIdx))
}

