public class BFM_SefazCheck_Utility_CC{
  //  @Future(callout=true)
    public static void sefazcheck(id objectId,string fileUrl,string objectName,string sessionid){
   // id objectId =so[0].id;string fileUrl='ferdvv'; string objectName='CCE';
        String jsonBodyResponse = BFM_GeneralServiceCalls.requestsefazCheck(objectId, fileUrl, objectName,sessionid);
        jsonBodyResponse = jsonBodyResponse.replace('\\','');
        jsonBodyResponse = jsonBodyResponse.replace('"{','{');
        jsonBodyResponse = jsonBodyResponse.replace('}"','}');
        system.debug('oooooooooooo'+jsonBodyResponse);
        sefazRequest sr = (sefazRequest)JSON.deserializeStrict(jsonBodyResponse, sefazRequest.class);
        sefazCheck rec = sr.sefazCheck;
        system.debug('rrrrrrrrrrrrrr'+rec.objectId);
       // BFM_Sefazresponse response = BFM_Sefazresponse.parse(jsonBodyResponse);
       // BFM_Sefazresponse.SefazCheck rec = response.SefazCheck;
        if(rec.objectName == 'MDFE'){
            BFM_MDF_e__c bfmObject = new BFM_MDF_e__c();
            bfmObject.id= id.valueof(rec.objectId);  
            bfmObject.MDF_e_Sefaz_Status__c= rec.sefazstatus;
            bfmObject.MDF_e_Status__c= rec.sefazstatus;
            upsert bfmObject;         
        }
        /*
        if(rec.objectName == 'CCE'){
            CC_e__c bfmObject = new CC_e__c();
            bfmObject.id= id.valueof(rec.objectId);  
            bfmObject.CC_e_Sefaz_Check_Status__c= rec.sefazstatus;
            upsert bfmObject;         
        }*/
        if(rec.objectName == 'CTE'){
            BFM_CT_e__c bfmObject = new BFM_CT_e__c();
            bfmObject.id= id.valueof(rec.objectId);  
            bfmObject.CT_e_Sefaz_Check_Status__c= rec.sefazstatus;
            upsert bfmObject;         
        }
    }
    
    public class sefazRequest{
        public sefazCheck sefazCheck;
    }
    public class sefazCheck{
        public string objectId;
        public string objectName;
        public string sefazstatus; 
    }
    
   /* public class BFM_Sefazresponse {

    
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, BFM_Sefazresponse.class);
    }
    }*/
}