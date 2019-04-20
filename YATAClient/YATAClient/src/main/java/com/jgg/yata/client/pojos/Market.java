package com.jgg.yata.client.pojos;

public class Market {

	private String from;
	private String to;
	private float open;
	private float high;
	private float low;
	private float close;
	private float volume;
	private float bid;
	private float ask;
	private long  bidOrders;
	private long  askOrders;
	private long  dt;

	public String getKey() {
		return from + "-" + to;
	}
	public String getFrom() {
		return from;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public float getOpen() {
		return open;
	}
	public void setOpen(float open) {
		this.open = open;
	}
	public float getHigh() {
		return high;
	}
	public void setHigh(float high) {
		this.high = high;
	}
	public float getLow() {
		return low;
	}
	public void setLow(float low) {
		this.low = low;
	}
	public float getClose() {
		return close;
	}
	public void setClose(float close) {
		this.close = close;
	}
	public float getVolume() {
		return volume;
	}
	public void setVolume(float volume) {
		this.volume = volume;
	}
	public float getBid() {
		return bid;
	}
	public void setBid(float bid) {
		this.bid = bid;
	}
	public float getAsk() {
		return ask;
	}
	public void setAsk(float ask) {
		this.ask = ask;
	}
	public long getBidOrders() {
		return bidOrders;
	}
	public void setBidOrders(long bidOrders) {
		this.bidOrders = bidOrders;
	}
	public long getAskOrders() {
		return askOrders;
	}
	public void setAskOrders(long askOrders) {
		this.askOrders = askOrders;
	}
	public long getDt() {
		return dt;
	}
	public void setDt(long dt) {
		this.dt = dt;
	}


	public String toCSV() {
		StringBuilder sb = new StringBuilder();
		sb.append(dt);
		sb.append(";");
		sb.append(from);
		sb.append(";");
		sb.append(to);
		sb.append(";");
		sb.append(open);
		sb.append(";");
		sb.append(high);
		sb.append(";");
		sb.append(low);
		sb.append(";");
		sb.append(close);
		sb.append(";");
		sb.append(volume);
		sb.append(";");
		sb.append(bid);
		sb.append(";");
		sb.append(ask);
		sb.append(";");
		sb.append(bidOrders);
		sb.append(";");
		sb.append(askOrders);		
        return (sb.toString());		
	}
}
