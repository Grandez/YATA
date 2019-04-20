package com.jgg.yata.client;

public enum Providers {
      POLONIEX
     ,COINBASE
     ,BITTREX
     ;
	
     public static Providers get(int code) {
         switch (code) {
            case 1: return Providers.POLONIEX;
            case 3: return Providers.BITTREX;
         }
         return Providers.POLONIEX;
     }
     public static Providers get(String code) {
    	 return get(Integer.parseInt(code));
     }

}
