package com.jgg.yata.client.timers;

import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import com.jgg.yata.client.Providers;
import com.jgg.yata.client.pojos.Ticker;
import com.jgg.yata.client.providers.Provider;
import com.jgg.yata.client.providers.ProviderFactory;

public class TimerTicker extends TimerTask {

	int seconds = 1;
	Provider prov;
	
	public TimerTicker (int seconds, Providers provider) {
		this.seconds = seconds;
		this.prov = ProviderFactory.getProvider(provider);
	}
	
	public void start() {	
	    Timer timer = new Timer();
	    timer.scheduleAtFixedRate(this, 0, seconds * 1000); 
	}
	
	@Override
    public void run() {
		try {
			Map<String, Ticker> map = prov.getTickers();
			for(Map.Entry<String, Ticker> entry : map.entrySet()) {
			    System.out.println(entry.getValue().asString());
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			System.exit(16);
		}
    }
}
