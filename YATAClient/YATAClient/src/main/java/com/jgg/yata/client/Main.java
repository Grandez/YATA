package com.jgg.yata.client;

import com.jgg.yata.client.timers.*;

public class Main {
	
	final static int ACTION_TICKER = 1;
	final static int ACTION_MARKET = 2;  // datos de las ultimas 24 horas
	
	static int interval  = 5;  // Intervalo en segundos/minutos
	static int action    = ACTION_MARKET;
	static Providers provider  = Providers.BITTREX;
	
	public static void main(String[] args) {
		parseParms(args);
        Main client = new Main();
        switch (action) {
           case ACTION_TICKER: client.tickers(); break;
           case ACTION_MARKET: client.markets(); break;
        }
	}
	
	private void tickers() {
		TimerTicker market = new TimerTicker(interval, provider);
		market.start();		
	}
	
	private void markets() {
		TimerMarket ticks = new TimerMarket(interval, provider);
		ticks.start();				
	}
    private static void parseParms(String[] args) {
    	int st = 0;
    	for (int idx = 1; idx < args.length; idx++) {
    		char c = args[idx].charAt(0);
    		if ( c == '-' || c == '/') {
    			if (st != 0) {
    				System.err.println("Invalid arguments: " + args[idx]);
    				System.exit(1);
    			}
    			switch (args[idx].charAt(1)) {
    			   case 'i': case 'I':  st = 1; break;
    			   case 'a': case 'A':  st = 2; break;
    			   case 'p': case 'P':  st = 3; break;
    			   case 'h': case 'H':  st = 9; break;
    			}
    		}
    		else {
    			switch (st) {    			 
    			    case 1: interval = Integer.parseInt(args[idx]); break;
    			    case 2: action   = Integer.parseInt(args[idx]); break;
    			    case 3: provider = Providers.get(args[idx]);    break;
    			    case 9: showHelp(args);
    			    default:  System.err.println("Invalid arguments: " + args[idx]);
    				          System.exit(1);
    			}
    			st = 0;
    		}
    	}
    }
    
    private static void showHelp(String[] args) {
    	System.out.println("Utilidad para recoger datos");
    	System.out.println("Opciones:");
    	System.out.println("\t-i valor  - Intervalo en segundos");
    	System.out.println("\t-a accion - Accion a realizar");
    	System.out.println("\t\t1 - Tickers");
    	System.out.println("\t-p fuente - Proveedor de los datos");
    	System.out.println("\t\t1 - Poloniex");    	
    	System.exit(0);
    }


}
