package com.jgg.client.wss;

import com.google.gson.Gson;

public class suscripcion {

	    public final static transient suscripcion TICKER = new suscripcion("1002");
	    public final static transient suscripcion HEARTBEAT = new suscripcion("1010");
	    public final static transient suscripcion BASE_COIN_DAILY_VOLUME_STATS = new suscripcion("1003");
	    public final static transient suscripcion USDT_BTC = new suscripcion("121");
	    public final static transient suscripcion USDT_ETH = new suscripcion("149");

	    public final String command;
	    public final String channel;

	    public suscripcion(String channel) {
	        this.command = "subscribe";
	        this.channel = channel;
	    }

	    @Override
	    public String toString() {
	        return new Gson().toJson(this);
	    }
}
