/**
 * Mock class for simulation of the Mulesoft interface. It exposes its methods as REST webservices and they should be
 * called with HttpRequests calls from Salesforce.
 * */

@RestResource(urlMapping='/MulesoftMock/v2/*')
global class BFM_MulesoftMock_Sefaz {
    
    
    public class sefazRequest{
        public sefazCheck sefazCheck;
    }
    public class sefazCheck{
        public string objectId;
        public string fileUrl;
        public string objectName; 
    }
    
    @HttpPost
    global static string sefazchecking(){
        HttpRequest req = new HttpRequest();
        RestRequest restReq= RestContext.request;
        system.debug('wwwwwwwww'+restReq.requestBody.toString());
        sefazRequest sr = (sefazRequest)JSON.deserializeStrict(restReq.requestBody.toString(), sefazRequest.class);
        
       // id objid;
      //  objid= sr.sefazCheck.objectid;
        system.debug('iiiiiiiiiii'+sr);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('sefazCheck');
        gen.writeStartObject();
        gen.writeStringField('objectId', string.valueof(sr.sefazCheck.objectid));
        gen.writeStringField('objectName', sr.sefazCheck.objectName);
        gen.writeStringField('sefazstatus', 'Sefaz Ok');
        gen.writeEndObject();
        system.debug('iiiiiiiiiii'+gen.getAsString());
        string s = gen.getAsString().replace('\n','');
        s=s.replace('\\','');
        system.debug('ddddddddddddddd'+s);
        return s;
       
    
    }
}