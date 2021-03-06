USE CTC;
DELETE FROM CURRENCIES_FIAT;

INSERT INTO CURRENCIES_FIAT (ACTIVE, DECIMALS, SYMBOL, NAME) VALUES ( 1, 0, "EUR"    , "Euro"      );
INSERT INTO CURRENCIES_FIAT (ACTIVE, DECIMALS, SYMBOL, NAME) VALUES ( 1, 0, "USD"    , "US Dollar" );
INSERT INTO CURRENCIES_FIAT (ACTIVE, DECIMALS, SYMBOL, NAME) VALUES ( 1, 0, "USDT"   , "USD T"     );
INSERT INTO CURRENCIES_FIAT (ACTIVE, DECIMALS, SYMBOL, NAME) VALUES ( 1, 0, "USDC"   , "USD C"     );
                                                                  
INSERT INTO CURRENCIES_FIAT (ACTIVE, DECIMALS, SYMBOL, NAME) VALUES ( 1, 6, "BTC"    , "Bitcoin"   );
INSERT INTO CURRENCIES_FIAT (ACTIVE, DECIMALS, SYMBOL, NAME) VALUES ( 1, 6, "ETH"    , "Ethereum"  );

COMMIT;