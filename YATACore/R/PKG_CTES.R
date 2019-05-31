
# Execution mode
MODE_AUTOMATIC = 0
MODE_INQUIRY   = 1
MODE_MANUAL    = 2

# Plot type
PLOT_NONE   =  0
PLOT_LINE   =  1
PLOT_LOG    =  2
PLOT_CANDLE =  4
PLOT_BAR    =  8
PLOT_LINEAR = 10
PLOT_DATA   = 11

# Status of operation
OP_PENDING  = 0
OP_EXECUTED = 1
OP_PROPOSED = 2

OP_BUY  =  1
OP_SELL = -1
OP_NONE =  0

# Risk profiles
PRF_DARED        = 5    # Ignora todo
PRF_BOLD         = 4    # Considera thresholds y alguna cosa
PRF_MODERATE     = 3    # Considera todo
PRF_CONSERVATIVE = 2
PRF_SAVER        = 1

# Tipos de indicadores
IND_POINT       =  1
IND_LINE        =  2
IND_LINE_MULT   =  3
IND_OVERLAY     = 11
IND_OSCILLATOR  = 12
IND_aCCUMULATOR = 13
IND_PATTERN     = 14
IND_MACHINE     = 15
IND_BLACKBOX    = 16

PLOT_FUNC = vector()
PLOT_FUNC[IND_POINT]     = "plotPoint"
PLOT_FUNC[IND_LINE]      = "plotLine"
PLOT_FUNC[IND_LINE_MULT] = "plotLines"
PLOT_FUNC[IND_OVERLAY]   = "plotLine"

# Fuentes de datos
SRC_XLS="XLS"
SRC_DB="MySQL"

# Modes for I/O
IO_XLS="XLS"
IO_CSV="CSV"
IO_SQL="SQL"

# Default FIAT currency
CURRENCY = "EUR"


# Common names for columns

DF_PRICE = "Price"
DF_DATE  = "Date"
DF_ORDER = "Order"
DF_TOTAL = "Total"
DF_TYPE  = "Type"
# Messages

MSG_METHOD_READ_ONLY = function(txt) {cat(sprintf("%s is read only", txt))}
MSG_BAD_CLASS        = function(txt) {cat(sprintf("Object is not a %s", txt))}
MSG_NO_NAME          = function(txt) {cat(sprintf("%s must have a name", txt))}
MSG_MISSING          = function(txt) {cat(sprint("%s must be specified\n", txt))}
MSG_NO_MODELS        = function()    {cat("There is not active models")}
MSG_NO_ACTIVES       = function()    {cat("No hay activos en la cartera\n")}
MSG_BAD_ARGS         = function()    {cat("Argumentos del metodo erroneos")}
MSG_NO_CASE          = function()    {cat("No se puede ejectuar la simulacion sin un caso")}
MSG_NO_PROVIDER      = function(txt) {cat(sprint("There is not information about provider %s\n", txt))}
