/**********************************************************************
Name: DMS_RestApiHelper
Copyright © 2016 Salesforce

Purpose: 
Class used as Helper for Wave/Rest Methods

History 

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 07/06/2016		INITIAL DEVELOPMENT
***********************************************************************/
public with sharing virtual class DMS_RestApiHelper {
    
    public class RestClientException extends Exception {}
    
    public Map<String,String> headers;
    public String url;
    public String method;
    public String body;
    public HttpRequest request;
    public HttpResponse response;
    public String responseBody;
    Http h;
    
    public DMS_RestApiHelper() {} //Prevent empty objects.
    
    
    //master constructor with everything required. 
    Public DMS_RestApiHelper(String url, String method, Map<String,String> headers, String body) {
        try {
            this.h = new Http();
            this.request = buildRequest(headers, url, method.toUpperCase(), body);
            this.response = makeRequest(this.h, this.request);
            this.responseBody = handleResponse(this.response);
        } catch (Exception e) {
            if(headers != null) this.headers = headers;
            this.body = body;
            this.url = url;
            this.method = method.toUpperCase();            
        }
    }
    
    public static HttpRequest buildRequest(map<String,String> headers, String url, String method, String body){
        HttpRequest request = new HttpRequest();
        
        if (headers != null) {
            for(String hkey : headers.keySet()){
                request.setHeader(hkey, headers.get(hkey)); 
            }   
        }
        request.setEndpoint(url);
        request.setMethod(method);
        if (body != null && body.length() > 0) {
            request.setBody(body);
        }
        return request;
    }
    
    public static HttpResponse makeRequest(Http h, HttpRequest request){
        HttpResponse response = h.send(request);
        if (response.getStatusCode() > 299) {
            throw new RestClientException('Failed to recieve a success code from remote. Code was: ' + response.getStatusCode() + ' request was ' + request + ' Response Body is: ' + response.getBody());
        }
        return response;    
    }  
    
    public string handleResponse(HttpResponse response){
        return response.getBody();
    }
    
}