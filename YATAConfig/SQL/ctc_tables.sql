USE CTC;

-- SET FOREIGN_KEY_CHECKS = 0 ;

-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- TABLAS DE CONFIGURACION Y GENERALES
-- PREFIJO: CFG
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Tabla de configuracion de sistema
-- Cuando no hay acceso a la base de datos se corresponde con el
-- fichero de propiedades
-- -------------------------------------------------------------------

-- Tabla de Parametros
DROP TABLE  IF EXISTS PARMS CASCADE;
CREATE TABLE PARMS  (
    NAME     VARCHAR    (32) NOT NULL -- Parametro
   ,TYPE     INTEGER         NOT NULL -- Tipo de parametro
   ,VALUE    VARCHAR    (64) NOT NULL
   ,PRIMARY KEY ( NAME )
);

-- Tabla de Textos
DROP TABLE  IF EXISTS MESSAGES;
CREATE TABLE MESSAGES  (
    CODE     VARCHAR    (64) NOT NULL
   ,LANG     CHAR(2)         NOT NULL
   ,REGION   CHAR(2)         NOT NULL
   ,MSG      VARCHAR(255)
   ,PRIMARY KEY ( CODE )
);

-- Tablas de Codigos

DROP TABLE  IF EXISTS CODE_GROUPS CASCADE;
CREATE TABLE CODE_GROUPS  (
    ID     INTEGER       NOT NULL -- Id del Grupo
   ,NAME   VARCHAR(32)   NOT NULL -- Nombre
   ,DESCR  VARCHAR(255)  
   ,PRIMARY KEY ( ID )
);

DROP TABLE  IF EXISTS CODES CASCADE;
CREATE TABLE CODES  (
    ID_GROUP  INTEGER      NOT NULL -- Id del Grupo
   ,ID        INTEGER      NOT NULL -- Valores del codigo
   ,NAME      VARCHAR(32)  NOT NULL -- Nombre
   ,DESCR     VARCHAR(255)     
   ,PRIMARY KEY ( ID_GROUP, NAME )
);

-- Tabla de Parametros
DROP TABLE  IF EXISTS PROFILES CASCADE;
CREATE TABLE PROFILES  (
    ID       INTEGER         NOT NULL -- Tipo de parametro
   ,NAME     VARCHAR    (32) NOT NULL -- Parametro
   ,ACTIVE   INTEGER         NOT NULL -- Tipo de parametro   
   ,FIAT     VARCHAR(8)
   ,CTC      VARCHAR(8)
   ,MODEL    INTEGER   
   ,PROFILE  INTEGER   
   ,SCOPE    INTEGER      
   ,PRIMARY KEY ( ID )
);

-- Tabla de monedas finales (FIAT)
DROP TABLE  IF EXISTS CURRENCIES_FIAT CASCADE;
CREATE TABLE CURRENCIES_FIAT  (
    SYMBOL   VARCHAR(8)  NOT NULL -- To Currency
   ,NAME     VARCHAR(64) NOT NULL -- From currency
   ,DECIMALS INTEGER     NOT NULL
   ,ACTIVE   TINYINT     NOT NULL
   ,PRIMARY KEY ( SYMBOL )
);

-- Tabla de monedas
DROP TABLE  IF EXISTS CURRENCIES_CTC CASCADE;
CREATE TABLE CURRENCIES_CTC  (
    SYMBOL   VARCHAR(8)  NOT NULL -- To Currency
   ,NAME     VARCHAR(64) NOT NULL -- From currency
   ,DECIMALS INTEGER     NOT NULL
   ,ACTIVE   TINYINT     NOT NULL
   ,FEE      DOUBLE                DEFAULT 0.0
   ,PRIMARY KEY ( SYMBOL )
);

-- Contiene los pares cotizados por clearing
-- Y la ultima fecha de actualizacion
DROP TABLE  IF EXISTS CURRENCIES_CLEARING CASCADE;
CREATE TABLE CURRENCIES_CLEARING  (
    CLEARING    VARCHAR(8) NOT NULL -- Clearing Symbol
   ,BASE        VARCHAR(8) NOT NULL -- From currency
   ,COUNTER     VARCHAR(8) NOT NULL -- To Currency
   ,LAST_UPD    TIMESTAMP    
   ,PRIMARY KEY ( CLEARING, BASE, COUNTER )
);

-- Tabla de Camaras
DROP TABLE  IF EXISTS CLEARINGS CASCADE;
CREATE TABLE CLEARINGS  (
    ID_CLEARING  VARCHAR(08) NOT NULL           -- Clearing Symbol
   ,NAME         VARCHAR(32) NOT NULL           -- Clearing Name
   ,ACTIVE       TINYINT     NOT NULL DEFAULT 1 -- 0 Compra / 1 Venta    
   ,MAKER        TINYINT     NOT NULL DEFAULT 0 -- Fees
   ,TAKER        TINYINT     NOT NULL DEFAULT 0
   ,PRIMARY KEY ( ID_CLEARING )
);

-- Tabla de Proveedores
DROP TABLE  IF EXISTS PROVIDERS CASCADE;
CREATE TABLE PROVIDERS  (
    SYMBOL       VARCHAR    (8)  NOT NULL -- To Currency 
   ,NAME         VARCHAR    (32) NOT NULL -- From currency
   ,ACTIVE       TINYINT    DEFAULT 1
   ,PRIMARY KEY ( SYMBOL )
);


-- Tabla de Cuentas/Camara
DROP TABLE  IF EXISTS ACCOUNTS CASCADE;
CREATE TABLE ACCOUNTS  (
    ID_CLEARING VARCHAR(8) NOT NULL -- To Currency 
   ,CURRENCY    VARCHAR(8) NOT NULL -- From currency
   ,BALANCE     DOUBLE     NOT NULL -- From currency
   ,CC          VARCHAR(512) 
   ,PRIMARY KEY ( ID_CLEARING, CURRENCY )
);

-- Tabla de Portfolio
DROP TABLE  IF EXISTS PORTFOLIO CASCADE;
CREATE TABLE PORTFOLIO  (
    ID_CLEARING VARCHAR(8) NOT NULL -- To Currency 
   ,CURRENCY    VARCHAR(8) NOT NULL -- From currency
   ,ACTIVE      TINYINT     NOT NULL DEFAULT 1 -- 0 Compra / 1 Venta    
   ,POS         DOUBLE     NOT NULL           -- Posicion total
   ,AVAILABLE   DOUBLE     NOT NULL           -- Posicion considerando si esa ejecutado o no
   ,LAST_OP     BIGINT 
   ,LAST_VALUE  DOUBLE  
   ,LAST_TMS   TIMESTAMP          
   ,PRIMARY KEY ( ID_CLEARING, CURRENCY )
);

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

DROP TABLE  IF EXISTS FLOWS CASCADE;
CREATE TABLE FLOWS  (
    ID_OPER    BIGINT    NOT NULL
   ,ID_FLOW    BIGINT    NOT NULL
   ,TYPE       TINYINT    NOT NULL     
   ,CLEARING   VARCHAR(8) NOT NULL -- Clearing House
   ,BASE       VARCHAR(8) NOT NULL -- From currency
   ,CURRENCY   VARCHAR(8) NOT NULL -- From currency
   ,PROPOSAL   DOUBLE     NOT NULL -- Stop price
   ,EXECUTED   DOUBLE              -- Real price
   ,MAXLIMIT   DOUBLE              -- Limit
   ,FEE_BLOCK  DOUBLE     -- FEE blockchain 
   ,FEE_EXCH   DOUBLE     -- FEE Exchange
   ,TMS_PROPOSAL  TIMESTAMP          
   ,TMS_EXECUTED  TIMESTAMP             
   ,TMS_LIMIT     TIMESTAMP 
   ,TMS_CANCEL    TIMESTAMP   
   ,REFERENCE     BIGINT             
   ,PRIMARY KEY ( ID_FLOW )
   ,UNIQUE  KEY ( ID_OPER, ID_FLOW )   
   ,UNIQUE  KEY (CLEARING, BASE, CURRENCY, TMS_PROPOSAL)
);

-- Tabla de Agrupaciones de modelos
DROP TABLE  IF EXISTS IND_GROUPS CASCADE;
CREATE TABLE IND_GROUPS  (
    ID_GROUP  INTEGER        NOT NULL -- Id CTC
   ,NAME      VARCHAR    (32) NOT NULL -- From currency    
   ,ACTIVE    TINYINT        NOT NULL DEFAULT 1
   ,PRIMARY KEY ( ID_GROUP )
);

-- Tabla de Agrupaciones de modelos
DROP TABLE  IF EXISTS IND_INDS CASCADE;
CREATE TABLE IND_INDS  (
    ID_GROUP  INTEGER        NOT NULL -- Id CTC
   ,ID_IND    INTEGER        NOT NULL -- Id CTC 
   ,ID_PARENT INTEGER        NOT NULL -- Id CTC    
   ,ACTIVE    TINYINT        NOT NULL DEFAULT 1 
   ,NAME      VARCHAR (32)   NOT NULL -- From currency    
   ,DESCR     VARCHAR(255)   NOT NULL -- From currency    
   ,PRIMARY KEY ( ID_GROUP, ID_IND )
--   ,FOREIGN KEY ( ID_GROUP ) REFERENCES IND_GROUPS ( ID_GROUP ) ON DELETE CASCADE
);

-- Tabla de Agrupaciones de modelos
DROP TABLE  IF EXISTS IND_PARMS CASCADE;
CREATE TABLE IND_PARMS  (
    ID_IND     INTEGER       NOT NULL -- Id CTC 
   ,FLG_SCOPE  INTEGER       NOT NULL -- Intradia, dia, etc
   ,FLG_TERM   INTEGER       NOT NULL DEFAULT  15 -- Ambito: 1 - Corto, 2 - Medio - 3 - Largo
   ,NAME       VARCHAR (32)  NOT NULL
   ,TYPE       INTEGER       NOT NULL      
   ,VALUE      VARCHAR (64)  NOT NULL
   ,DESCR      VARCHAR(255)   
   ,PRIMARY KEY ( ID_IND, FLG_SCOPE, FLG_TERM, NAME )
--   ,FOREIGN KEY ( ID_GROUP, ID_IND ) REFERENCES IND_INDS ( ID_GROUP, ID_IND ) ON DELETE CASCADE
);

-- Tabla de Agrupaciones de modelos
DROP TABLE  IF EXISTS MODELS CASCADE;
CREATE TABLE MODELS  (
    ID_MODEL   INTEGER        NOT NULL -- Id del Modelo
   ,ID_PARENT  INTEGER        NOT NULL -- Padre del modelo para agraupar
   ,FLG_SCOPE  INTEGER        NOT NULL -- Scope al que aplica el Modelo. 255 = Todos
   ,ACTIVE     TINYINT        NOT NULL DEFAULT 1 
   ,NAME       VARCHAR (32)   NOT NULL -- From currency    
   ,DESCR      VARCHAR(255)   
   ,PRIMARY KEY ( ID_MODEL )
--   ,FOREIGN KEY ( ID_GROUP ) REFERENCES IND_GROUPS ( ID_GROUP ) ON DELETE CASCADE
);

-- Tabla de Agrupaciones de modelos
DROP TABLE  IF EXISTS MODEL_INDICATORS CASCADE;
CREATE TABLE MODEL_INDICATORS  (
    ID_MODEL  INTEGER        NOT NULL -- ID del Modelo
   ,ID_IND    INTEGER        NOT NULL -- Indicador    
   ,FLG_TERM  INTEGER        NOT NULL DEFAULT  15 -- Ambito: 1 - Corto, 2 - Medio - 3 - Largo
   ,FLG_DAT   INTEGER        NOT NULL DEFAULT 255 -- Id del plot (1, 2, 3) Por binario   
   ,PRIMARY KEY ( ID_MODEL, ID_IND, FLG_TERM )
);

COMMIT;