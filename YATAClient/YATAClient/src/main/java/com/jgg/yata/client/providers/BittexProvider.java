package com.jgg.yata.client.providers;

import java.sql.Timestamp;
import java.util.*;

import com.google.gson.*;
import com.jgg.endpoint.http.HTTPSClient;
import com.jgg.yata.client.pojos.Market;
import com.jgg.yata.client.pojos.Ticker;

public class BittexProvider implements Provider {

	//private final String WSSBase  = "wss://api2.poloniex.com";
	private final String HTTPBase = "https://bittrex.com/api/v1.1/public/";
	private final String TICKERS  = "command=returnTicker";
	private final String MARKETS  = "getmarketsummaries";

	public Map<String, Ticker> getTickers() throws Exception {
		HTTPSClient client = new HTTPSClient();
		String resp = client.getHttps(HTTPBase, MARKETS);
		return null;
		//return (mountMarkets(resp));
	}

	public Map<String, Market> getMarkets() throws Exception {
		HTTPSClient client = new HTTPSClient();
		String resp = client.getRest(HTTPBase, MARKETS);
		return (mountMarkets(resp));
	}
	
	private Map<String, Market> mountMarkets(String resp) {
		Map<String, Market> map = new HashMap<String, Market>();
        Gson gson = new Gson();
        JsonParser parser = new JsonParser();
        JsonObject obj = parser.parse(resp).getAsJsonObject();
        JsonArray  arr = obj.get("result").getAsJsonArray();
        for(int i = 0; i <  arr.size(); i++) {
        	BittrexMarket bMkt = gson.fromJson(arr.get(i), BittrexMarket.class);
        	Market mkt = mountMarket(bMkt);
        	map.put(mkt.getKey(),mkt);
        }
       return map;
	}

	private Market mountMarket(BittrexMarket bMkt) {
		Market mkt = new Market();
		
		String names[] = bMkt.getMarketName().split("-");
		
		mkt.setFrom(names[0]);
		mkt.setTo(names[1]);
		
		mkt.setOpen (1 / bMkt.getPrevDay());
		mkt.setHigh (1 / bMkt.getHigh());
		mkt.setLow  (1 / bMkt.getLow());
		mkt.setClose(1 / bMkt.getLast());
		mkt.setBid  (1 / bMkt.getBid());
		mkt.setAsk  (1 / bMkt.getAsk());
		
		mkt.setVolume(bMkt.getBaseVolume());
		mkt.setBidOrders(bMkt.getOpenBuyOrders());
		mkt.setAskOrders(bMkt.getOpenSellOrders());

		
		mkt.setDt(Timestamp.valueOf(bMkt.getTimeStamp().replace('T',  ' ')).getTime());
		return (mkt);
	}
}
