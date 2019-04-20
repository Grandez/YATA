TBLFlow = R6::R6Class("TBLFlow", inherit=YATATable,
     public = list(
         # Column names
          ID_OPER        =  "ID_OPER"
         ,ID_FLOW        =  "ID_FLOW"
         ,TYPE           =  "TYPE"
         ,CLEARING       =  "CLEARING"
         ,BASE           =  "BASE"
         ,CURRENCY       =  "CURRENCY"
         ,PROPOSAL       =  "PROPOSAL"
         ,EXECUTED       =  "EXECUTED"
         ,MAXLIMIT       =  "MAXLIMIT"
         ,FEE_BLOCK      =  "FEE_BLOCK"
         ,FEE_EXCH       =  "FEE_EXCH"
         ,TMS_PROPOSAL   =  "TMS_PROPOSAL"
         ,TMS_EXECUTED   =  "TMS_EXECUTED"
         ,TMS_LIMIT      =  "TMS_LIMIT"
         ,TMS_CANCEL     =  "TMS_CANCEL"
         ,REFERENCE      =  "REFERENCE"
         ,initialize = function() {
             self$name="Flows";
             self$table = "FLOWS";
         }
     )
     ,private = list (
     )
)
