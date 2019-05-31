#' Global Environment data for YATA System
#'
#' @title YATAEnv
#'
#' @docType class
#' @description Class to manage global configuration.
#'              Todos los atributos son publicos y tienen un valor por defecto
#'              Se pueden cambiar de manera global mediante \code{YATAENV$attribute <- ...}
#'
#'
#' @export
YATAEnvironment <- R6Class("YATAEnvironment",
    public = list(
         provider = "POL"    # proveedor de datos
        ,period   = "D1"     # Periodo en uso
        ,currency="USDT"
        ,base = NULL

        ,dirRoot="D:/R/YATA"
        ,dirOut=NULL
        ,dirData=NULL

        ,dataSourceDir=NULL
        ,dataSourceDBName = "currencies"
        ,dataSourceDBType = IO_SQL

        ,modelsDBDir  = NULL
        ,modelsDBName = "Models"
        ,modelsDBType = IO_SQL
        ,modelPrefix  = "IND_"
        ,modelBase    = "YATAModels"
        ,modelsDir    = NULL
        ,modelsMan    = NULL

        ,outputType   = IO_CSV

        ,templateSummaryFile="sprintf('sum_%s_%s',#SYM#, #MODEL#)"
        ,templateSummaryData="sprintf('det_%s_%s',#SYM#, #MODEL#)"
        ,parms    = NULL
        ,profile  = NULL
        ,fiat     = NULL
        ,indGroups = NULL
        ,indNames  = NULL
        ,lastErr  = NULL
        ,initialize = function(root=NULL) {
            if (!is.null(root)) self$dirRoot   = root
            self$dirData         = private$envFilePath(self$dirRoot, "YATAData")
            self$modelsDBDir     = private$envFilePath(self$dirData, "in")
            self$modelsDir       = private$envFilePath(self$dirRoot, "YATAModels/R")
            self$modelsMan       = private$envFilePath(self$dirRoot, "YATAModels/doc")
            self$dataSourceDir   = private$envFilePath(self$dirData, "in")
            self$dirOut          = private$envFilePath(self$dirData, "out")
#            self$parms           = loadParameters()
            self$fiat            = TBLFiat$new()
            self$indGroups     = TBLIndGroups$new()
            self$indNames      = TBLIndNames$new()
        }
        ################################################################################
        ### WRAPPERS FOR PARAMETERS
        ###############################################################################
        ,loadProfile  = function() {
            df = getProfile()
            if (nrow > 0) {
                self$CURRENCY = df[1,"CURRENCY"]
            }
        }
        ,getParameter = function(parm, def=NA) {
            if (is.null(self$parms)) return (def)
            rec = self$parms[self$parms$NAME == parm,]
            if (nrow(rec) == 0) return (def)
            setDataType(rec[1,"TYPE"], rec[1,"VALUE"])
        }
        ,getProvider = function() {
            if (is.null(self$provider)) {
                provider = self$getParameter(PARM_PROVIDER)
                if (is.na(provider)) stop(MSG_NO_PROVIDER(provider))
                self$provider = YATAProvider$new(provider)
            }
            self$provider
        }
        ,getRangeInterval = function() { self$getParameter(PARM_RANGE, 0) }
        # Wrappers
        ,getProviderPrefix = function() {
            provider = self$getProvider()
            provider$prefix
        }
    )

    ,private=list(
       envFilePath = function(..., name=NULL,ext=NULL) {
           txt=""
           if (length(list(...)) > 0) {
               args=as.character(list(...))
               txt=args[1]
               i=1
               while (i < length(args)) {
                   i = i + 1
                   txt = paste(txt,args[i],sep="/")
               }
           }

           if (!is.null(name)) txt=paste(txt,name,sep="/")
           if (!is.null(ext))  txt=paste(txt,ext ,sep=".")
           gsub("\\/", "/",gsub("//", "/",txt))
       }

    )
)
