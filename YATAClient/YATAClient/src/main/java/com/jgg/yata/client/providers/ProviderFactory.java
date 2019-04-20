package com.jgg.yata.client.providers;

import com.jgg.yata.client.Providers;

public class ProviderFactory {

	public static Provider getProvider(Providers provider) {
		switch (provider) {
		    case POLONIEX: return (Provider) new ProviderPoloniex(); 
		    case BITTREX:  return (Provider) new BittexProvider();
		    default: return null;
		}
	}
}
