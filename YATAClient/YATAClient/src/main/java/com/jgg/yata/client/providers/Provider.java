package com.jgg.yata.client.providers;

import java.util.Map;

import com.jgg.yata.client.pojos.Market;
import com.jgg.yata.client.pojos.Ticker;

public interface Provider {

	Map<String, Ticker> getTickers() throws Exception;
	Map<String, Market> getMarkets() throws Exception;
}
