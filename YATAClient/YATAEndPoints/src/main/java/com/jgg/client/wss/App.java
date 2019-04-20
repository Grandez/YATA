package com.jgg.client.wss;

import java.net.URI;
import java.net.URISyntaxException;

/**
 * Hello world!
 *
 */
public class App {
	
	wssclient wss = null;
	
	private final String BASE = "wss://api2.poloniex.com";
	
    public static void main( String[] args )     {
        App app = new App();
        app.start();
    }
    
    void start() {
    	Runtime.getRuntime().addShutdownHook(new Thread() {
    	    public void run() {
    	         if (wss != null) wss.close();
    	    }
    	});        
    	System.out.println( "Hello World!" );
    	
    	try {
			wss = new wssclient(new URI(BASE));
			wss.connect();
			suscripcion s = suscripcion.TICKER;
			wss.send(s.toString());
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    }
    
    void end() {
    	
    }
}
