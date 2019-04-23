USE CTC;

-- Tabla de Proveedores
DROP TABLE  IF EXISTS PROVIDERS CASCADE;
CREATE TABLE PROVIDERS  (
    SYMBOL       VARCHAR    (8)  NOT NULL -- To Currency 
   ,NAME         VARCHAR    (32) NOT NULL -- From currency
   ,ACTIVE       TINYINT    DEFAULT 1
   ,PRIMARY KEY ( SYMBOL )
);

COMMIT;    
