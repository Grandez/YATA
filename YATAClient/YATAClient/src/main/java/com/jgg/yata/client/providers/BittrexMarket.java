package com.jgg.yata.client.providers;

public class BittrexMarket {
	private String MarketName;
	private float High;
	private float Low;
	private float Volume;
	private float Last;
	private float BaseVolume;
	private float Bid;
	private float Ask;
	private long  OpenBuyOrders;
	private long  OpenSellOrders;
	private float PrevDay;
	private String  TimeStamp;
	private String  Created;
	public String getMarketName() {
		return MarketName;
	}
	public void setMarketName(String marketName) {
		MarketName = marketName;
	}
	public float getHigh() {
		return High;
	}
	public void setHigh(float high) {
		High = high;
	}
	public float getLow() {
		return Low;
	}
	public void setLow(float low) {
		Low = low;
	}
	public float getVolume() {
		return Volume;
	}
	public void setVolume(float volume) {
		Volume = volume;
	}
	public float getLast() {
		return Last;
	}
	public void setLast(float last) {
		Last = last;
	}
	public float getBaseVolume() {
		return BaseVolume;
	}
	public void setBaseVolume(float baseVolume) {
		BaseVolume = baseVolume;
	}
	public float getBid() {
		return Bid;
	}
	public void setBid(float bid) {
		Bid = bid;
	}
	public float getAsk() {
		return Ask;
	}
	public void setAsk(float ask) {
		Ask = ask;
	}
	public long getOpenBuyOrders() {
		return OpenBuyOrders;
	}
	public void setOpenBuyOrders(long openBuyOrders) {
		OpenBuyOrders = openBuyOrders;
	}
	public long getOpenSellOrders() {
		return OpenSellOrders;
	}
	public void setOpenSellOrders(long openSellOrders) {
		OpenSellOrders = openSellOrders;
	}
	public float getPrevDay() {
		return PrevDay;
	}
	public void setPrevDay(float prevDay) {
		PrevDay = prevDay;
	}
	public String getTimeStamp() {
		return TimeStamp;
	}
	public void setTimeStamp(String timeStamp) {
		TimeStamp = timeStamp;
	}
	public String getCreated() {
		return Created;
	}
	public void setCreated(String created) {
		Created = created;
	}

	
}
