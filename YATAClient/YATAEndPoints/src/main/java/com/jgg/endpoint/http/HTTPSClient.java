package com.jgg.endpoint.http;

import java.io.*;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;


public class HTTPSClient {
	public String getHttps(String uri, String parms)  throws Exception {
	  if (parms != null) uri = uri + "?" + parms;
      URL url = new URL(uri);
      HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
      return (getContent(con));
   }
	public String getRest(String uri, String parms)  throws Exception {
		  if (parms != null) uri = uri + parms;
	      URL url = new URL(uri);
	      HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
	      return (getContent(con));
	   }
				
   private String getContent(HttpsURLConnection con) throws IOException {
	  if (con == null) return null;
	  StringBuilder sb = new StringBuilder();
				
      BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
      String input;
	  while ((input = br.readLine()) != null) sb.append(input);
	  br.close();
	  return sb.toString();		
   }
}
