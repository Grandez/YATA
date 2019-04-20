package com.jgg.yata.client.timers;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import com.jgg.yata.client.Providers;
import com.jgg.yata.client.pojos.Market;
import com.jgg.yata.client.providers.Provider;
import com.jgg.yata.client.providers.ProviderFactory;

public class TimerMarket extends TimerTask {

	int interval = 1;
	Provider prov;
	
	public TimerMarket (int interval, Providers provider) {
		this.interval = interval;
		this.prov = ProviderFactory.getProvider(provider);
	}
	
	public void start() {	
	    Timer timer = new Timer();
	    this.run();
	    if (interval > 0) timer.scheduleAtFixedRate(this, interval, interval * 60000); 
	}
	
	@Override
    public void run() {
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
		System.err.println("Started at " + dateFormat.format(new Date()));
		try {
			Map<String, Market> map = prov.getMarkets();
			for(Map.Entry<String, Market> entry : map.entrySet()) {
			    System.out.println(entry.getValue().toCSV());
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			System.exit(16);
		}
    }
}
