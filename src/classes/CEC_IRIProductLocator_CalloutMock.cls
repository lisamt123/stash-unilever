/**********************************************************************
Name:  CEC_IRIProductLocator_CalloutMock()
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class implements the HttpCalloutMock interface for CEC_IRIProductLocatorControllerTest Test Class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sreya           Jan-2016      INITIAL DEVELOPMENT   

***********************************************************************/

@isTest
global class CEC_IRIProductLocator_CalloutMock implements HttpCalloutMock{

global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    string Test_Body = '<?xml version="1.0"?>'+
'<RESULTS SUCCESS_CODE="0">'+
    '<QUERY>'+
        '<USERID><![CDATA[anon]]></USERID>'+
        '<TEMPLATE><![CDATA[]]></TEMPLATE>'+
        '<PRODUCTFAMILYID><![CDATA[UNIL]]></PRODUCTFAMILYID>'+
        '<STORESPERPAGE><![CDATA[10]]></STORESPERPAGE>'+
        '<CLIENTID><![CDATA[10]]></CLIENTID>'+
        '<PRODUCTID><![CDATA[1111126614]]></PRODUCTID>'+
        '<STORESPAGENUM><![CDATA[1]]></STORESPAGENUM>'+
        '<REFERER><![CDATA[No referer used]]></REFERER>'+
        '<SEARCHTYPE><![CDATA[zip]]></SEARCHTYPE>'+
        '<ETAILERSPERPAGE><![CDATA[10]]></ETAILERSPERPAGE>'+
        '<ETAILERS><![CDATA[0]]></ETAILERS>'+
        '<REQUESTURL><![CDATA[http://productlocator.infores.com/productlocator/servlet/ProductLocator]]></REQUESTURL>'+
        '<ETAILERSPAGENUM><![CDATA[1]]></ETAILERSPAGENUM>'+
        '<CITY><![CDATA[]]></CITY>'+
        '<STATE><![CDATA[]]></STATE>'+
        '<OUTPUTTYPE><![CDATA[html]]></OUTPUTTYPE>'+
        '<SEARCHRADIUS><![CDATA[20]]></SEARCHRADIUS>'+
        '<PRODNAME><![CDATA[Dove Men + Care Body & Face Bar Aqua Impact 4 oz 2 Bar]]></PRODNAME>'+
        '<ZIP><![CDATA[07006]]></ZIP>'+
        '<PRODUCTTYPE><![CDATA[upc]]></PRODUCTTYPE>'+
        '<REQUESTIP><![CDATA[96.43.147.8]]></REQUESTIP>'+
        '<STORES><![CDATA[1]]></STORES>'+
    '</QUERY>'+
    '<STORES COUNT="128">'+
        '<STORE>'+
            '<STORE_ID><![CDATA[00291472]]></STORE_ID>'+
            '<PHONE><![CDATA[(973) 227-0319]]></PHONE>'+
            '<ADDRESS><![CDATA[875 BLOOMFIELD AVE]]></ADDRESS>'+
            '<DISTANCE><![CDATA[1.21]]></DISTANCE>'+
            '<LONGITUDE><![CDATA[-74.3008052]]></LONGITUDE>'+
            '<CITY><![CDATA[WEST CALDWELL]]></CITY>'+
            '<NAME><![CDATA[STOP & SHOP]]></NAME>'+
            '<STATE><![CDATA[NJ]]></STATE>'+
 '<PARENT_IDS>'+
            '<PARENT_ID>null</PARENT_ID>'+
'</PARENT_IDS>'+
            '<NUMBER><![CDATA[1]]></NUMBER>'+
            '<ZIP><![CDATA[07006]]></ZIP>'+
            '<UPC_CODE><![CDATA[1111126614]]></UPC_CODE>'+
            '<LATITUDE><![CDATA[40.8523079]]></LATITUDE>'+
        '</STORE>'+
        '<STORE>'+
            '<STORE_ID><![CDATA[00688411]]></STORE_ID>'+
            '<PHONE><![CDATA[(201) 438-1747]]></PHONE>'+
            '<ADDRESS><![CDATA[425 LEWANDOWSKI ST]]></ADDRESS>'+
            '<DISTANCE><![CDATA[9.11]]></DISTANCE>'+
            '<LONGITUDE><![CDATA[-74.1176984]]></LONGITUDE>'+
            '<CITY><![CDATA[LYNDHURST]]></CITY>'+
            '<NAME><![CDATA[STOP & SHOP]]></NAME>'+
            '<STATE><![CDATA[NJ]]></STATE>'+
 '<PARENT_IDS>'+
            '<PARENT_ID>null</PARENT_ID>'+
'</PARENT_IDS>'+
           '<NUMBER><![CDATA[10]]></NUMBER>'+
            '<ZIP><![CDATA[07071]]></ZIP>'+
            '<UPC_CODE><![CDATA[1111126614]]></UPC_CODE>'+
            '<LATITUDE><![CDATA[40.8032833]]></LATITUDE>'+
        '</STORE>'+
   '</STORES>'+
'</RESULTS>'
;
    res.setBody(Test_Body);
   
    return res;
  }
}