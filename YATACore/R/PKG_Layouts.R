DB_CURRENCIES = "Currencies"
TBL_INDEX     = "$Index"
TBL_CURRENCY  = "Currency"

IDX_NAME="Name"
IDX_SYMBOL="Symbol"
IDX_DECIMAL="Decimals"
IDX_ACTIVE="Active"
DF_CTC_INDEX=c(IDX_NAME,IDX_SYMBOL,IDX_DECIMAL,IDX_ACTIVE)

CTC_DATE="Date"
CTC_OPEN="Open"
CTC_HIGH="High"
CTC_LOW="Low"
CTC_CLOSE="Close"
CTC_VOLUME="Volume"
CTC_CAP="MarketCap"
DF_CTC_CTC=c(CTC_DATE,CTC_OPEN,CTC_HIGH,CTC_LOW,CTC_CLOSE,CTC_VOLUME,CTC_CAP)


# Dataframe for position
POS_ORDER="orden"
POS_DATE="date"
POS_EUR="EUR"
POS_CURRENCY="Moneda"
POS_BALANCE="Balance"
DF_POSITION=c(POS_ORDER,POS_DATE,POS_EUR,POS_CURRENCY,POS_BALANCE)

# Dataframe de Operacion

OP_ORDER="orden"
OP_DATE="date"
OP_UDS="uds"
OP_PRICE="price"
OP_TOTAL="total"
OP_PMM="pmm"
OP_POS="position"
DF_OPERATION=c(OP_ORDER,OP_DATE,OP_UDS,OP_PRICE,OP_TOTAL,OP_PMM,OP_POS)

# Cases

DB_CASES      = "Cases"
TBL_CASES     = "Cases"

CASE_ID       = "idTest"
CASE_NAME     = "Name"
CASE_SUMMARY  = "Summary"
CASE_DETAIL   = "Detail"
CASE_INFO     = "Info"

CASE_PROFILE  = "Profile"
CASE_SCOPE    = "Scope"
CASE_CAPITAL  = "Capital"
CASE_OTRO     = "Otro"

CASE_FROM     = "From"
CASE_TO       = "To"
CASE_START    = "Start"
CASE_PERIOD   = "Period"
CASE_INTERVAL = "Interval"

CASE_MODEL          = "Model"
CASE_VERSION        = "Version"
CASE_GRP_PARMS      = "Parm"
CASE_GRP_THRESHOLDS = "Thre"

CASE_END      = "End"
CASE_SYM_NAME = "SymName"
CASE_SYM_SYM  = "Symbol"

DF_CASES=c( CASE_ID,CASE_NAME,CASE_SUMMARY,CASE_DETAIL,CASE_INFO
           ,CASE_PROFILE,CASE_SCOPE,CASE_CAPITAL,CASE_OTRO
           ,CASE_FROM,CASE_TO,CASE_START,CASE_PERIOD,CASE_INTERVAL
           ,CASE_MODEL,CASE_VERSION
)

# Dataframe with indicatos
DFI_ORDER  = "orden"
DFI_DATE   = "date"
DFI_PRICE  = "price"
DFI_VOLUME = "volume"


########################################################################
### FUNCTIONS
########################################################################

.generateLayouts <- function() {
    index    = YATATable$new(TBL_INDEX,    DF_CTC_INDEX)
    currency = YATATable$new(TBL_CURRENCY, DF_CTC_CTC)
    DBCurrencies = YATADB$new(DB_CURRENCIES)
    DBCurrencies$addTables(c(index, currency))
}

.generateDBCases <- function() {
    DBCases = YATADB$new(DB_CASES)
    DBCases$addTables(c(YATATable$new(TBL_CASES, DF_CASES
                                               , groups=c(CASE_GRP_PARMS, CASE_GRP_THRESHOLDS)
                                               , numGroups=c(5,5)))
                      )
}
