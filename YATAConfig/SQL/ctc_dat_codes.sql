USE CTC;

DELETE FROM CODE_GROUPS;
DELETE FROM CODES;

INSERT INTO CODE_GROUPS (          ID, NAME, DESCR) VALUES (    1,         "TERM",   "Short, Medium and Long");
                                                                      
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    1,     1,  "Short"     , "Ambito corto");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    1,     2,  "Medium"    , "Ambito normal");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    1,     4,  "Long"      , "Ambito largo");
                                                                      
INSERT INTO CODE_GROUPS (          ID, NAME, DESCR) VALUES (    2,         "SCOPE"     , "Alcance de los Tickers");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     1,  "Real"      , "Minuto o tiempo real");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     2,  "5 Min."    , "5 Minutos");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     4,  "15 Min."   , "Cuartos");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     8,  "1 Hour"    , "1 Hora");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,    16,  "2 Hours"   , "2 Horas");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,    32,  "4 Hours"   , "Media Jornada");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,    64,  "8 Hour"    , "Jornada Laboral");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,   256,  "Day"       , "Diario" );
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,   512,  "Weekly"    , "Semanal");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,  1024,  "Monthly"   , "Mensual");

INSERT INTO CODE_GROUPS (          ID, NAME, DESCR) VALUES (    5,         "TARGET"    , "Dato operativo del indicator");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    5,     1,  "Open"      , "Open");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     2,  "Close"     , "Close");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     4,  "Low"       , "Low");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,     8,  "High"      , "High");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,    16,  "Ticker"    , "Open/Close - High/Low");
INSERT INTO CODES       (ID_GROUP, ID, NAME, DESCR) VALUES (    2,    32,  "Volume"    , "Volumen");

COMMIT;