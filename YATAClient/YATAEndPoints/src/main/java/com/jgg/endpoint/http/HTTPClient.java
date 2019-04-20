package com.jgg.endpoint.http;

import java.io.IOException;
import java.util.List;
import org.apache.http.*;
import org.apache.http.client.*;
import org.apache.http.client.entity.*;
import org.apache.http.client.methods.*;

import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

/**
 *
 * @author David
 */
public class HTTPClient
{
    public String postHttp(String url, List<NameValuePair> params, List<NameValuePair> headers) throws IOException
    {
        HttpPost post = new HttpPost(url);
        post.setEntity(new UrlEncodedFormEntity(params, Consts.UTF_8));
        post.getEntity().toString();

        if (headers != null)
        {
            for (NameValuePair header : headers)
            {
                post.addHeader(header.getName(), header.getValue());
            }
        }

        HttpClient httpClient = HttpClientBuilder.create().build();
        HttpResponse response = httpClient.execute(post);

        HttpEntity entity = response.getEntity();
        if (entity != null)
        {
            return EntityUtils.toString(entity);

        }
        return null;
    }

    public String getHttp(String url, List<NameValuePair> headers) throws IOException
    {
        HttpRequestBase request = new HttpGet(url);

        if (headers != null)
        {
            for (NameValuePair header : headers)
            {
                request.addHeader(header.getName(), header.getValue());
            }
        }

        HttpClient httpClient = HttpClientBuilder.create().build();
        HttpResponse response = httpClient.execute(request);

        HttpEntity entity = response.getEntity();
        if (entity != null)
        {
            return EntityUtils.toString(entity);

        }
        return null;
    }
}
