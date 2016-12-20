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
     system.debug('jSONRequestBody-->'+jSONRequestBody);  
     
     //Deserializes the input JSON string into an RFID object  
      String resp;
      system.debug('resp'+resp);
      String getOp= request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
      system.debug('GetOp->'+getOp);
      if(getOp.equalsIgnoreCase('AssignRFID'))
      {
       resp = insertRFID(jSONRequestBody);
       system.debug('RFID ->'+resp);
      } 
      if(getOp.equalsIgnoreCase('UpdateWeight'))
      {
       resp = updateWeight(jSONRequestBody);
       system.debug('update weight ->'+resp);
      } 
      if(getOp.equalsIgnoreCase('insertRFID'))
      {
       resp = insertRFID(jSONRequestBody);
       system.debug('move to bay ->'+resp);
      } 
      if(getOp.equalsIgnoreCase('UnloadArea'))
      {
       resp = UnloadArea(jSONRequestBody);
       system.debug('Unload Area ->'+resp);
      }
   return resp;
   }

      public static String updateWeight(String jSONRequestBody)
      {
           TMS_RFID__c rfObj = new TMS_RFID__c ();
           String tStatus= 'Doc Validated';
           String tStatus2= 'Unload/Load Done';
          
           String tAction= 'Int weight';
           String tAction2= 'Fin Weight';
         
           JSONParser parser = JSON.createParser(jSONRequestBody);
           String transId;
           String locId;
           String rfidNumber;
           String siteCode;
           Integer cWeight;
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
                system.debug(' RFID is'+fieldName );
                  rfidNumber= parser.getText();
                  system.debug(' RFID is'+rfidNumber);
                }
                else if (fieldName == 'Site_Code__c') {
                  siteCode= parser.getText();
                }
                else if (fieldName == 'Weight__c') {
                    system.debug('Item weight is >>>  '+ parser.getText());
                  cWeight= Integer.valueOf(parser.getText());
                }
              }
            }
         String reResponse;
         if(cWeight > 10)
         {
             
         try{ 

          TMS_Truck_Entry_Checklist__c tObj = [select id,Status__c,Relay_Item_Id__c,RFID__C,Initial_Wt__c,TMS_ItemWeight__c ,TMS_Current_Weight__c,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where (Status__c=:tStatus OR Status__C =: tStatus2) and (Action__c=:tAction OR Action__c =: tAction2) and RFID__c=:rfidNumber Limit 1];

             
                 TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tObj.id);
                 te.TMS_Current_Weight__c = cWeight;
                 
             if(tObj.Initial_Wt__c == null )
                 {
                     te.Initial_Wt__c = cWeight;
                     te.Action__c = 'Allocate Bay';
                     te.Status__c = 'Initial Wt.done';
                     te.Time_At_Weigh_Bridge__c = system.now();
                     update te;
                     reResponse = constructResponse(transId,locId,'True' );
                  
                 }else
                 {
                     if(tObj.Action__c.equalsIgnoreCase('Fin Weight'))
                     {
                        te.TMS_ItemWeight__c = tObj.TMS_Current_Weight__c-cWeight; 
                        te.Final_Wt__c = cWeight;
                        te.Action__c = 'Qnty Val';
                        te.Status__c = 'Final Wt.done';
                             
                     }
                     else{
                       te.TMS_ItemWeight__c = tObj.TMS_Current_Weight__c-cWeight;
                       te.Action__c = 'Allocate Bay';
                       te.Status__c = 'Item Weight';
                     }
                     
                     update te;
                     
                     TMS_PO_items__c tpo = new TMS_PO_items__c(id=tObj.Relay_Item_Id__c);
                     tpo.Time_At_Weigh_Bridge__c = system.now();
                     tpo.Initial__c = tObj.TMS_Current_Weight__c-cWeight;
                     update tpo;
                     
                     reResponse = constructResponse(transId,locId,'True' );
                 }
        
         }
         catch(Exception ex)
         {
             reResponse = constructResponse(transId,locId,'False') ;
         }
       
      } 
          return reResponse ; 
}  
public static String insertRFID(String jSONRequestBody)
      {
         TMS_RFID__c rfObj = new TMS_RFID__c ();
         
         string tStatus='Arrived';
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
         
    if(locId.contains('DAP_RFID_POWDER_PLANT_LOADING'))
    {
       String tprevaction = 'Move To Bay';
       String tprevstatus = 'Bay Allocated';
        String tprevstatus2 = 'Item Weight';
        
       TMS_Truck_Entry_Checklist__c tpObj = [select id,Status__c,Relay_Item_Id__c,RFID__C,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where (Status__c=:tprevstatus OR Status__C =: tprevstatus2)and Action__c =:tprevaction and RFID__c=:rfidNumber Limit 1];

             String reResponse;
                 TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tpObj.id);
                     te.Action__c = 'Unload/Load Done';
                     te.Status__c = 'Moved To Bay';
                     update te;
                     reResponse = constructResponse(transId,locId,'True' );
         
     }
     else if(locId.contains('RFID_SECURITY'))
     {
         Integer rfIDC = [Select Count() from TMS_RFID__c where RFID_plant_code__c='DAPADA'];  
         
         if(rfIDC > 0)
         {
             TMS_RFID__c rfID = [Select RFID_Card_Number__c,RFID_plant_code__c from TMS_RFID__c where RFID_plant_code__c='DAPADA' Limit 100];  
         delete rfID;
         
         }    
             
             
         
         TMS_RFID__c tE = new TMS_RFID__c();
         te.RFID_Card_Number__c = rfidNumber;
         te.RFID_plant_code__c = siteCode;
         insert te;
         }
         String reResponse = constructResponse(transId,locId,'True' );
         return reResponse ;  
         }
         catch(Exception ex)
         {
             return constructResponse(transId,locId,'False') ;
         }
}  
public static String UnloadArea(String jSONRequestBody)
      {
           TMS_RFID__c rfObj = new TMS_RFID__c ();
         
           string tStatus='Moved To Bay';
           string tAction='Unload/Load Done';
         
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
         
    if(locId.contains('POWDER_PLANT_LOADING'))
    {
        List<TMS_PO_items__c> poItem;
        List<TMS_Shipment_Items__c> shipItem;
        String Loadid;
        ApexPages.StandardController controller;
        TMS_Popup_unloadLoadDone_CC tmspopup = new TMS_Popup_unloadLoadDone_CC(controller);
        Loadid = tmspopup.tmsloadid;
        System.debug('loadid->'+Loadid);
        poItem = [select TMS_PO__r.id,TMS_PO__r.name,TMS_PO__r.PO_Number__c,TMS_PO__r.Invoice_No__c,id,name,Material_Description__c,Quantity_Rcvd__c,choosePO__c,Invoice_Qty__c,UOM__c,Po_Item__c from TMS_PO_items__c  where TMS_PO__r.Truck_Entry_Checklist__c=:Loadid AND choosePO__c = false];
        shipItem = [select TMS_Shipment__r.id,TMS_Shipment__r.name,Item_No__c,id,Name,Quantity_Rcvd__c,UOM__c,Choose_ShipItem__c,Material_Description__c from TMS_Shipment_Items__c where TMS_Shipment__r.Truck_Entry_Checklist__c=:Loadid AND Choose_ShipItem__c = false];
     if(poItem.size()==1 || shipItem.size()==1)
     {
       String tprevaction = 'Moved To Bay';
       String tprevstatus = 'Unload/Load Done';       
        
       TMS_Truck_Entry_Checklist__c tpObj = [select id,Status__c,Relay_Item_Id__c,RFID__C,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where Status__c=:tprevstatus and Action__c =:tprevaction and RFID__c=:rfidNumber Limit 1];
             String reResponse;
             TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tpObj.id);
             te.Exit_time__c = system.now(); 
             te.Action__c = 'Fin weight';
             te.Status__c = 'Unload/Load Done';            
             update te;
             reResponse = constructResponse(transId,locId,'True' );  
       }       
     }
     
         String reResponse = constructResponse(transId,locId,'True' );
         return reResponse ;  
         }
         catch(Exception ex)
         {
             return constructResponse(transId,locId,'False') ;
         }
}
public static String TruckExit(String jSONRequestBody)
      {
           TMS_RFID__c rfObj = new TMS_RFID__c ();
         
           string tStatus='Arrived';
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
         
    if(locId.contains('RFID_SECURITY'))
    {
       String tprevaction = 'Exit';
       String tprevstatus = 'Qty validated';       
        
       TMS_Truck_Entry_Checklist__c tpObj = [select id,Status__c,Relay_Item_Id__c,RFID__C,truck_Action__c,Action__c from TMS_Truck_Entry_Checklist__c where Status__c=:tprevstatus and Action__c =:tprevaction and RFID__c=:rfidNumber Limit 1];
             String reResponse;
             TMS_Truck_Entry_Checklist__c tE = new TMS_Truck_Entry_Checklist__c (id=tpObj.id);
             te.Exit_time__c = system.now(); 
             te.Action__c = 'Exit';
             te.Status__c = 'Exit';            
             update te;
             reResponse = constructResponse(transId,locId,'True' );         
     }
     
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