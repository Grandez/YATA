USE CTC;
DELETE FROM IND_GROUPS;

INSERT INTO IND_GROUPS ( ID_GROUP, NAME, ACTIVE) VALUES ( 0,   "Base"                  ,  0);
INSERT INTO IND_GROUPS ( ID_GROUP, NAME, ACTIVE) VALUES ( 1,   "Overlays"              ,  1);
INSERT INTO IND_GROUPS ( ID_GROUP, NAME, ACTIVE) VALUES ( 2,   "Oscillators"           ,  1);
INSERT INTO IND_GROUPS ( ID_GROUP, NAME, ACTIVE) VALUES ( 3,   "Accumulators"          ,  1);
INSERT INTO IND_GROUPS ( ID_GROUP, NAME, ACTIVE) VALUES ( 4,   "Patterns"              ,  1);
INSERT INTO IND_GROUPS ( ID_GROUP, NAME, ACTIVE) VALUES ( 5,   "Black Boxes"           ,  1);

DELETE FROM IND_INDS;
DELETE FROM IND_PARMS;
DELETE FROM MODELS;
DELETE FROM MODEL_INDICATORS;

-- -----------------------------------------------------------------------------------------
-- Comunes
-- -----------------------------------------------------------------------------------------

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (    0,	   1,	   0, 0,	"BASE"         , "Raiz"                                  );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (    1,    0,    0,     "THRESHOLD"    , 11,  "3");

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (    0,	  11,	   1, 1,	"Trend"        , "Linear regression"                      );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (    0,	  12,	   1, 1,	"Spline"       , "Spline"                                 );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (    0,	  13,	   1, 1,	"MaxMin"       , "Maximos y Minimos"                      );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   13,     0,   0,     "Depth"        , 11,  "3");

-- -----------------------------------------------------------------------------------------
-- Overlays
-- -----------------------------------------------------------------------------------------

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1000,	   0,  0,	 "OVERLAY"      , "Base Overlays"                          );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1000, 65535,    15,      "maType"       ,  1,  "EMA");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1000, 65535,    15,      "WINDOW"       , 11,  "20");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1000,   256,    15,      "WINDOW"       , 11,  "30");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1000,   512,    15,      "WINDOW"       , 11,  "12");

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1001,	1000,  0,	 "SMA"          , "Media movil simple"                     );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1002,	1000,  1,	 "EMA"          , "Exponential moving average"             ); 
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1003,	1000,  1,	 "DEMA"         , "Double-exponential moving average"      );
                                                                                                                 
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,	 1004,	1000,  1,	 "ALMA"         , "Arnaud Legoux moving average"           );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,	 1005,	1000,  1,	 "BBand"        , "Bollinger Bands Normal"                 );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1002, 65535,    15,      "SD"           , 10,  "2.0");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1002, 65535,    15,      "SD1"          , 10,  "1.5");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)   VALUES (   1002, 65535,    15,      "SD2"          , 10,  "2.0");
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,	 1006,	1002,  1,	 "BBandD"       , "Double Bollinger Bands Normal Double"   );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,	 1007,	1002,  1,	 "BBandS"       , "Bollinger Bands Simple"                 );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,	 1008,	1002,  1,	 "BBandSD"      , "Double Bollinger Bands Simple Double"   );
                                                                                                                             



INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1009,	1000,  0,	 "EVWMA"        , "Elastic volume-weighted moving average" );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1010,	1000,  0,	 "HMA"          , "Hull moving average"                    );

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1011,	1000,  0,	 "VWA"          , "Variable-length moving average"         );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1012,	1000,  0,	 "VWAP"         , "Volume-weighed average price"           );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1013,	1000,  0,	 "VWMA"         , "Volume-weighed moving average"          );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1014,	1000,  0,	 "WMA"          , "Weighted moving average"                );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )  VALUES (      1,  1015,	1000,  1,	 "ZLEMA"        , "Zero lag exponential moving average"    );
                                                                                                                      
-- -----------------------------------------------------------------------------------------
-- Oscillators
-- -----------------------------------------------------------------------------------------

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )          VALUES (     2,   2000,	   0,  0,	 "OSCILLATOR"   , "Base Oscillators"                       );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR  )  VALUES (  2000,  65535,    15,      "maType"       ,  1,   "EMA", "Exponential Mobile Average");

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )          VALUES (     2,	 2010,	2000,  0,	 "STOCHASTIC"   , "Base Oscillators"                       );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)           VALUES (  2010,    256,    15,      "KFast"        , 11,  "14");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)           VALUES (  2010,    256,    15,      "DFast"        , 11,   "3");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE)           VALUES (  2010,    256,    15,      "DSlow"        , 11,   "3");

INSERT INTO IND_INDS  ( ID_GROUP, ID_IND, ID_PARENT, ACTIVE, NAME, DESCR )             VALUES (      2,	 2011,	2010,  1,	 "Stoch"        , "Sthochastic Momentum"                   );
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND, ID_PARENT, ACTIVE, NAME, DESCR )             VALUES (      2,	 2012,	2010,  1,	 "SMI"          , "Sthochastic Momentum Index"             );
                                                                                       
INSERT INTO IND_INDS  ( ID_GROUP, ID_IND,    ID_PARENT, ACTIVE, NAME, DESCR )          VALUES (     2,	 2014,	2000,  1,	 "MACD"         , "Convergence-Divergence Average Mobile"  );
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR )   VALUES (  2014,    256,    15,      "nFast"        , 11,  "12", "Media rapida");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR )   VALUES (  2014,    256,    15,      "nSlow"        , 11,  "26", "Media Lenta");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR )   VALUES (  2014,    256,    15,      "nSig"         , 11,   "9", "Compensador");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR )   VALUES (  2014,    512,    15,      "nFast"        , 11,   "4", "Media rapida");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR )   VALUES (  2014,    512,    15,      "nSlow"        , 11,  "12", "Media Lenta");
INSERT INTO IND_PARMS ( ID_IND,   FLG_SCOPE, FLG_TERM,  NAME,   TYPE, VALUE, DESCR )   VALUES (  2014,    512,    15,      "nSig"         , 11,   "8", "Compensador");

-- -----------------------------------------------------------------------------------------
-- Modelos
-- -----------------------------------------------------------------------------------------

INSERT INTO MODELS           (ID_MODEL, ID_PARENT, FLG_SCOPE, ACTIVE,    NAME, DESCR)  VALUES ( 1,     0,  65535,    0,   "BASE"         , "Modelo base");
-- INSERT INTO MODEL_INDICATORS (ID_MODEL, ID_IND,    FLG_TERM, FLG_DAT)                 VALUES ( 1,    11,  15,  255);  -- Tendencia
-- INSERT INTO MODEL_INDICATORS (ID_MODEL, ID_IND,    FLG_TERM, FLG_DAT)                 VALUES ( 1,    12,  15,  255);  -- Spline
-- INSERT INTO MODEL_INDICATORS (ID_MODEL, ID_IND,    FLG_TERM, FLG_DAT)                 VALUES ( 1,    13,  15,  255);  -- Max and Mins 
-- 
INSERT INTO MODELS           (ID_MODEL, ID_PARENT, FLG_SCOPE,  ACTIVE,   NAME,  DESCR) VALUES ( 11,     1,   256,   1,   "ELDER"        , "Modelo base de Elder");
INSERT INTO MODEL_INDICATORS (ID_MODEL, ID_IND,    FLG_TERM,  FLG_DAT)                 VALUES ( 11,  1003,     4,   1);  -- DEMA
INSERT INTO MODEL_INDICATORS (ID_MODEL, ID_IND,    FLG_TERM,  FLG_DAT)                 VALUES ( 11,  1007,     2,   1);  -- Bollinger Band
INSERT INTO MODEL_INDICATORS (ID_MODEL, ID_IND,    FLG_TERM,  FLG_DAT)                 VALUES ( 11,  2014,     6,   4);  -- MACD


COMMIT;    
