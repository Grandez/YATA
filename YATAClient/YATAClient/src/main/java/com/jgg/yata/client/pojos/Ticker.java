package com.jgg.yata.client.pojos;

public class Ticker {
	
	private String symbol;
	private long  dt;
	private float last;
	private float lowestAsk;
	private float highestBid;
	private float percentChange;
	private float baseVolume;
	private float quoteVolume;
	private int   isFrozen;
	private float high24hr;
	private float low24hr;
	
	public Ticker() {
		this.dt = System.currentTimeMillis();
	}
	
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public String getSymbol() {
		return symbol;
	}
	
	public float getLast() {
		return last;
	}
	
	public void convertToUSDT(float btc) {
		last        *= btc;
		lowestAsk   *= btc;
		highestBid  *= btc;
		baseVolume  *= btc;
		quoteVolume *= btc;
		high24hr    *= btc;
		low24hr     *= btc;
	}
	
	public String asString() {
		StringBuilder sb = new StringBuilder(127);
		sb.append(symbol);
		sb.append(";");
		sb.append(dt);
		sb.append(";");		
		sb.append(last);
		sb.append(";");
		sb.append(lowestAsk);
		sb.append(";");
		sb.append(highestBid);
		sb.append(";");
		sb.append(percentChange);
		sb.append(";");
		sb.append(baseVolume);
		sb.append(";");
		sb.append(quoteVolume);
		sb.append(";");
		sb.append(isFrozen);
		sb.append(";");
		sb.append(high24hr);
		sb.append(";");
		sb.append(low24hr);
		return sb.toString();
	}
}
