# Mantiene las variables globales de YATACode
# Debe ir en PKG_Main
# YATAVARS <- R6::R6Class("YATAVARS"
#     ,public = list(
#          SQLConn = list()
#         ,lastErr = NULL
#         ,tmpConn = NULL
#         ,addConn = function (SQLConn) {
#             self$SQLConn = c(SQLConn, self$SQLConn)
#         }
#         ,removeConn = function() {
#             tmp = NULL
#             if (length(self$SQLConn) > 0) {
#                 tmp = self$SQLConn[1]
#                 self$SQLConn = self$SQLConn[-1]
#             }
#             tmp
#         }
#     )
#
# )
