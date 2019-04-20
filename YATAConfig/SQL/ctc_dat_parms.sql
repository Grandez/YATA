USE CTC;
DELETE FROM PARMS;

INSERT INTO PARMS ( NAME,  TYPE, VALUE ) VALUES ("provider",          1 ,     "POLONIEX"         );
INSERT INTO PARMS ( NAME,  TYPE, VALUE ) VALUES ("range",            11 ,     "30"               );

COMMIT;
