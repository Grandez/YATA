# Tables

TBL_CURRENCIES = "Currencies"
TBL_DAY        = "TICKERSD1"
TBL_IND_GROUPS = "IND_GROUPS"
TBL_IND        = "IND_INDS"

# Scope of Tickers
SCOPE_NONE   =     0
SCOPE_ALL    = 65535

SCOPE_REAL   =     1
SCOPE_MIN05  =     2
SCOPE_MIN15  =     4
SCOPE_HOUR01 =     8
SCOPE_HOUR02 =    16
SCOPE_HOUR04 =    32
SCOPE_HOUR08 =    64
SCOPE_DAY    =   256
SCOPE_WEEK   =   512
SCOPE_MONTH  =  1024

SCOPES = c(SCOPE_REAL   ,SCOPE_MIN05 , SCOPE_MIN15, SCOPE_HOUR01, SCOPE_HOUR02,
           SCOPE_HOUR04 ,SCOPE_HOUR08, SCOPE_DAY,   SCOPE_WEEK,   SCOPE_MONTH)

TERM_SHORT  =  1
TERM_MEDIUM =  2
TERM_LONG   =  4
TERM_ALL    = 15

# Target for formulas
TGT_OPEN   =  1
TGT_CLOSE  =  2
TGT_LOW    =  4
TGT_HIGH   =  8
TGT_TICKER = 16
TGT_VOLUME = 32


# Data Types
TYPE_STR  =  1
TYPE_DEC  = 10
TYPE_INT  = 11
TYPE_LONG = 12


TARGETS = c("Price", "Volume", "Other")
XAXIS   = c("Date",  "Date",   "Date")

# Parameters

PARM_CURRENCY = "currency"
PARM_MODEL    = "model"
PARM_RANGE    = "range"
PARM_PROVIDER = "provider"
