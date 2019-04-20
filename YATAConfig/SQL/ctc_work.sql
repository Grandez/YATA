USE CTC;

DROP TABLE  IF EXISTS OPERATIONS;
CREATE TABLE OPERATIONS  (
    ID_OPER      BIGINT    NOT NULL
   ,TYPE         TINYINT    NOT NULL     
   ,CLEARING     VARCHAR(8) NOT NULL -- Clearing House
   ,BASE         VARCHAR(8) NOT NULL -- From currency
   ,COUNTER      VARCHAR(8) NOT NULL -- To currency
   ,AMOUNT       DOUBLE     NOT NULL
   ,IN_PROPOSAL  DOUBLE     NOT NULL -- Stop price
   ,IN_EXECUTED  DOUBLE              -- Real price
   ,IN_REASON    INTEGER             -- Si cero o negativo, esta en tabla, si no es un codigo
   ,OUT_PROPOSAL DOUBLE    
   ,OUT_EXECUTED DOUBLE              -- Real price
   ,OUT_REASON   INTEGER             -- Si cero o negativo, esta en tabla, si no es un codigo
   ,OPLIMIT      DOUBLE              -- Limit
   ,OPSTOP       DOUBLE              -- Limit
   ,PRICE        TINYINT            -- Considerar para la toma de precios medios
   ,TMS_IN       TIMESTAMP
   ,TMS_OUT      TIMESTAMP
   ,TMS_LAST     TIMESTAMP
   ,PRIMARY KEY ( ID_OPER )
   ,UNIQUE KEY (CLEARING, BASE, COUNTER, TMS_IN)
);
COMMIT;    
