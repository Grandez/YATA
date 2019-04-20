USE CTC;
DELETE FROM MESSAGES;

INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "OK.XFER"               ,"XX", "XX"     , "Trasnferencia realizada"                             );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "OK.OPER"               ,"XX", "XX"     , "Operacion Realizada: %s"                             );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "SAME.CLEARING"         ,"XX", "XX"     , "Origen y destino no pueden ser iguales"          );
INSERT INTO MESSAGES  (CODE, LANG, REGION, MSG) VALUES ( "INVALID.AMOUNT"        ,"XX", "XX"     , "El importe es erroneo"                           );

COMMIT;
