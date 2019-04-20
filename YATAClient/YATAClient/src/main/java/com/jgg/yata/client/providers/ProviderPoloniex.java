package com.jgg.yata.client.providers;

import java.util.*;
import java.util.Map.Entry;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.jgg.endpoint.http.HTTPSClient;
import com.jgg.yata.client.pojos.*;

public class ProviderPoloniex implements Provider {

	//private final String WSSBase  = "wss://api2.poloniex.com";
	private final String HTTPBase = "https://poloniex.com/public";
	private final String TICKERS  = "command=returnTicker";

	@Override
	public Map<String, Ticker> getTickers() throws Exception {
		HTTPSClient client = new HTTPSClient();
		String resp = client.getHttps(HTTPBase, TICKERS);
		return (mountTickers(resp));
	}
	public Map<String, Market> getMarkets() throws Exception {
		HTTPSClient client = new HTTPSClient();
		String resp = client.getHttps(HTTPBase, TICKERS);
		return (mountMarkets(resp));
	}

	/**
	 * La lista de pares es:
	 *     USDT-Moneda si cotiza
	 *     BTC-Moneda  si no cotiza
	 * @param resp
	 */
	private Map<String, Ticker> mountTickers(String resp) {
		List<CTCPair> lst = getPairList(resp);
		Map<String, Ticker> m = getTickers(lst, "USDT");
		Ticker t = m.get("BTC");
		return (addTickers(lst, m, "BTC", t.getLast()));		
	}
	private Map<String, Market> mountMarkets(String resp) {
		return null;		
	}
	
	private List<CTCPair> getPairList(String resp) {
		List<CTCPair> lst = new ArrayList<CTCPair>();
        Gson gson = new Gson();
        JsonParser parser = new JsonParser();
        JsonObject obj = parser.parse(resp).getAsJsonObject();
        Iterator<Entry<String, JsonElement>> it = obj.entrySet().iterator();
        while (it.hasNext()) {
        	Entry<String, JsonElement> el = it.next();
        	CTCPair m = new CTCPair();
        	String toks[] = el.getKey().split("_");
        	m.setFrom(toks[0]);
        	m.setTo(toks[1]);
        	Ticker t = gson.fromJson(el.getValue(), Ticker.class);
        	t.setSymbol(m.getTo());
        	m.setTicker(t);
        	lst.add(m);
        }
        return lst;
	}
	
	private Map<String, Ticker> getTickers(List<CTCPair> lst, String base) {
	    Map<String, Ticker> map = new HashMap<String, Ticker>();
        for (CTCPair c : lst) {
        	if (c.getFrom().compareTo(base) == 0) map.put(c.getTo(), c.getTicker());
        }
        return map;
	}

	private Map<String, Ticker> addTickers(List<CTCPair> lst, Map<String, Ticker> m, String base, float price) {
        for (CTCPair c : lst) {
        	if (c.getFrom().compareTo(base) == 0) {
        		if (!m.containsKey(c.getTo()) ) {
        			c.getTicker().convertToUSDT(price);
        			m.put(c.getTo(), c.getTicker());
        		}
        	}
        }
        return m;
	}
	
}
