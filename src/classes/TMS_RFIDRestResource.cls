@RestResource(urlMapping='/TMSRFIDREST/*')
global with sharing class TMS_RFIDRestResource {
    
    @HttpPost  
   global static String doRFIDPost() {  
   
        /*  
       RestContext Class - Allows us to access the RestRequest and RestResponse objects in your Apex REST methods.   
       RestRequest class - Allows us to pass request data into our Apex RESTful Web service method.  
       RestResponse class - Allows us to pass or send back response data from our Apex RESTful web service method  
     */  
     //Returns the RestRequest object for our Apex REST method.  
     RestRequest request = RestContext.request;  
     //Returns the RestResponse for our Apex REST method.  
     RestResponse response = RestContext.response;  
     //Access the request body with input data coming in the JSON format  
     String jSONRequestBody=request.requestBody.toString().trim();  
     //Deserializes the input JSON string into an RFID object  
      String resp;
      String getOp= request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
      if(getOp.equalsIgnoreCase('AssignRFID'))
      {
       resp = insertRFID(jSONRequestBody);
      } 
      if(getOp.equalsIgnoreCase('UpdateWeight'))
      {
       resp = updateWeight(jSONRequestBody);
      } 
      if(getOp.equalsIgnoreCase('UnloadBay'))
      {
       resp = unloadBay(jSONRequestBody);
      } 
      if(getOp.equalsIgnoreCase('TruckExit'))
      {
       resp = exitTruck(jSONRequestBody);
      } 
   return resp;
   }

      public static String updateWeight(String jSONRequestBody)
      {
         TMS_RFID__c rfObj = new TMS_RFID__c ();
         string tStatus='Accept';
         string tAction='Exit';
         
         JSONParser parser = JSON.createParser(jSONRequestBody);
           String transId;
           String locId;
           String rfidNumber;
           String siteCode;
           Integer initWeight;
            while (parser.nextToken() != null) {
              if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'Transaction_ID__c') {
                  transId = parser.getText();
                } else if (fieldName == 'Location_ID__c') {
                  locId = parser.getText();
                }
                else if (fieldName == 'RFID_Card_Number__c') {
                  rfidNumber= parser.getText();
                }
                else if (fieldName == 'Site_Code__c') {
                  siteCode= parser.getText();
                }
                else if (fieldName == 'Weight__c') {
                  initWeight= Integer.valueOf(parser.getText());
                }
              }
            }
         
          TMS_Truck_Entry_Checklist__c tObj = [select id,Status__c,Relay_Item_Id__c,RFID__C,Initial_Wt__c,TMS_ItemWeight__c ,TMS_Current_Weight__c,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where truck_Action__c=:tStatus and Action__c !=:tAction and RFID__c=:rfidNumber Limit 1];

         try{ 
             String reResponse;
                 TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tObj.id);
                   te.TMS_Current_Weight__c = initWeight;
                 if(tObj.Initial_Wt__c == null)
                 {
                     te.Initial_Wt__c = initWeight;
                     te.Action__c = 'Allocate Bay';
                     te.Status__c = 'Initial Wt.done';
                     update te;
                     reResponse = constructResponse(transId,locId,'True' );
                  
                 }else
                 {
                     te.TMS_ItemWeight__c = tObj.TMS_Current_Weight__c-initWeight;
                     te.Action__c = 'Allocate Bay';
                      te.Status__c = 'Initial Wt.done';
                     update te;
                     TMS_PO_items__c tpo = new TMS_PO_items__c(id=tObj.Relay_Item_Id__c);
                     tpo.Initial__c = tObj.TMS_Current_Weight__c-initWeight;
                     update tpo;
                     
                     reResponse = constructResponse(transId,locId,'True' );
                 }
         return reResponse ; 
         }
         catch(Exception ex)
         {
             return constructResponse(transId,locId,'False') ;
         }
      
      
      }
      public static String unloadBay(String jSONRequestBody)
      {
         TMS_RFID__c rfObj = new TMS_RFID__c ();
         string tStatus='Accept';
         string tAction='Doc Val';
         
         TMS_Truck_Entry_Checklist__c tObj = [select id,Status__c,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where truck_Action__c=:tStatus and Action__c =:tAction Limit 1];
         JSONParser parser = JSON.createParser(jSONRequestBody);
           String transId;
           String locId;
           String rfidNumber;
           String siteCode;
            while (parser.nextToken() != null) {
              if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'Transaction_ID__c') {
                  transId = parser.getText();
                } else if (fieldName == 'Location_ID__c') {
                  locId = parser.getText();
                }
                else if (fieldName == 'RFID_Card_Number__c') {
                  rfidNumber= parser.getText();
                }
                else if (fieldName == 'Site_Code__c') {
                  siteCode= parser.getText();
                }
              }
            }
         
         
         try{ 
     
         TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tObj.id);
         te.RFID__c = rfidNumber;
         update te;
         String reResponse = constructResponse(transId,locId,'True' );
         return reResponse ;  
         }
         catch(Exception ex)
         {
             return constructResponse(transId,locId,'False') ;
         }
}  
public static String exitTruck(String jSONRequestBody)
      {
     
     
         TMS_RFID__c rfObj = new TMS_RFID__c ();
         string tStatus='Accept';
         string tAction='Doc Val';
         
         TMS_Truck_Entry_Checklist__c tObj = [select id,Status__c,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where truck_Action__c=:tStatus and Action__c =:tAction Limit 1];
         JSONParser parser = JSON.createParser(jSONRequestBody);
           String transId;
           String locId;
           String rfidNumber;
           String siteCode;
            while (parser.nextToken() != null) {
              if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'Transaction_ID__c') {
                  transId = parser.getText();
                } else if (fieldName == 'Location_ID__c') {
                  locId = parser.getText();
                }
                else if (fieldName == 'RFID_Card_Number__c') {
                  rfidNumber= parser.getText();
                }
                else if (fieldName == 'Site_Code__c') {
                  siteCode= parser.getText();
                }
              }
            }
         
         
         try{ 
     
         TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tObj.id);
         te.RFID__c = rfidNumber;
         update te;
         String reResponse = constructResponse(transId,locId,'True' );
         return reResponse ;  
         }
         catch(Exception ex)
         {
             return constructResponse(transId,locId,'False') ;
         }
}  
public static String insertRFID(String jSONRequestBody)
      {
     
     
         TMS_RFID__c rfObj = new TMS_RFID__c ();
         string tStatus='Accept';
         string tAction='Doc Val';
         
         JSONParser parser = JSON.createParser(jSONRequestBody);
           String transId;
           String locId;
           String rfidNumber;
           String siteCode;
            while (parser.nextToken() != null) {
              if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                if (fieldName == 'Transaction_ID__c') {
                  transId = parser.getText();
                } else if (fieldName == 'Location_ID__c') {
                  locId = parser.getText();
                }
                else if (fieldName == 'RFID_Card_Number__c') {
                  rfidNumber= parser.getText();
                }
                else if (fieldName == 'Site_Code__c') {
                  siteCode= parser.getText();
                }
              }
            }
         
         
         try{ 
     
         TMS_RFID__c tE = new TMS_RFID__c();
         te.RFID_Card_Number__c = rfidNumber;
         te.RFID_plant_code__c = siteCode;
         insert te;
         
         
         String reResponse = constructResponse(transId,locId,'True' );
         return reResponse ;  
         }
         catch(Exception ex)
         {
             return constructResponse(transId,locId,'False') ;
         }
}  

  public static String constructResponse(String transId,String locId,String successMessage)
   {
      
      JSONGenerator gen = JSON.createGenerator(true);
      gen.writeStartObject();
      gen.writeStringField('Transaction ID', transId);
      gen.writeStringField('Location ID', locId);
      gen.writeStringField('Test Result', successMessage);
      gen.writeEndObject();
      String respBody = gen.getAsString();

      return respBody ;
      
   
   } 
}