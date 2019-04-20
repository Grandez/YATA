USE CTC;
DELETE FROM FIAT;

INSERT INTO CURRENCIES (ID, NAME, SYMBOL, DECIMALS, ACTIVE) VALUES (   1, "Euro"                              ,"EUR"        , 2, 1);
INSERT INTO CURRENCIES (ID, NAME, SYMBOL, DECIMALS, ACTIVE) VALUES (   2, "US Dollar"                         ,"USD"        , 2, 1);
INSERT INTO CURRENCIES (ID, NAME, SYMBOL, DECIMALS, ACTIVE) VALUES (   3, "USD T"                             ,"USDT"       , 2, 1);
INSERT INTO CURRENCIES (ID, NAME, SYMBOL, DECIMALS, ACTIVE) VALUES (   4, "USD C"                             ,"USDC"       , 2, 1);

INSERT INTO CURRENCIES (ID, NAME, SYMBOL, DECIMALS, ACTIVE) VALUES (  10, "Bitcoin"                           ,"BTC"        , 6, 1);
INSERT INTO CURRENCIES (ID, NAME, SYMBOL, DECIMALS, ACTIVE) VALUES (  11, "Ethereum"                          ,"ETH"        , 6, 1);

COMMIT;