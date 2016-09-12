/***************************************************************
Name:  CEC_IRIProductLocatorController
Copyright@: 2016  Unilever
=================================================================
=================================================================
Purpose: This is controller class for CEC_IRIProductLocator page                                                                                                   

=================================================================
=================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE             DETAIL               
1.0        Nagesh           Jan-2016      INITIAL DEVELOPMENT 
1.1        Mahesh           06/21/2016       CSC-4762-Sonar Issue
*******************************************************************/


public with sharing class  CEC_IRIProductLocatorController {

    public String postCode {get;set;}
    public String prodCode {get;set;}
    public transient String errMsg {get;set;}
    public List<CEC_IRIWrapper.STORE> stores {get; set;}
    public String currentRecordId{get; set;}
    public transient List<Case> caseList{get;set;}
    public String IRIClientId{get;set;}
    public String IRIProdFamilyId{get; set;}
    public String pageSize{get;set;}

    
    public List<SelectOption> getpageSizeOptions(){
    
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(CEC_Constants.VALUE_FIVE,CEC_Constants.VALUE_FIVE));
       options.add(new SelectOption(CEC_Constants.VALUE_TEN,CEC_Constants.VALUE_TEN));
       options.add(new SelectOption(CEC_Constants.VALUE_TWENTY,CEC_Constants.VALUE_TWENTY));
       options.add(new SelectOption(CEC_Constants.VALUE_THIRTY,CEC_Constants.VALUE_THIRTY));
       options.add(new SelectOption(CEC_Constants.VALUE_FOURTY,CEC_Constants.VALUE_FOURTY));
       options.add(new SelectOption(CEC_Constants.VALUE_FIFTY,CEC_Constants.VALUE_FIFTY));           
       
       return options;
     }   
   
    /******************************************************************* 
        Purpose: Constructor
        Parameters: None
    ********************************************************************/     
    public CEC_IRIProductLocatorController(){
        
        currentRecordId = ApexPages.CurrentPage().getparameters().get('id');
        caseList = [Select Id,Product_UPC__c, Account.PersonMailingPostalCode from Case where Id =: currentRecordId];
        pageSize = CEC_Constants.VALUE_TEN;
        
        cec_Org_Settings__c cecSetting = cec_Org_Settings__c.getOrgDefaults();
        IRIClientId = cecSetting.IRI_Client_Id__c; 
        IRIProdFamilyId = cecSetting.IRI_Product_Family_Id__c;

        if(caseList.size() > 0){
            postCode = caseList[0].Account.PersonMailingPostalCode;
            prodCode = caseList[0].Product_UPC__c;
        }
        
        IRISearch();
    }
    
    
    
    /******************************************************************* 
        Purpose: Invokes the Product Locator webservice and checks for
                 error message
        Parameters: None
    ********************************************************************/ 
    public void IRISearch(){
        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('http://productlocator.infores.com/productlocator/servlet/ProductLocatorEngine?clientid=10&productfamilyid=UNIL&searchradius=20&producttype=upc&productid=1111126614&zip=07006');
            if(postCode == null)
                postCode = '';
            req.setEndpoint('http://productlocator.infores.com/productlocator/servlet/ProductLocatorEngine?clientid='+ IRIClientId +'&productfamilyid='+ IRIProdFamilyId +'&searchradius=20&producttype=upc&productid='+ prodCode +'&zip=' + postCode.mid(0,5) + '&storesperpage=' + pageSize );
            req.setMethod('GET');
            HttpResponse res = http.send(req);
            errMsg = '';        
            
            //CEC_IRIWrapper cecIRIWrap = new CEC_IRIWrapper();
            Dom.Document docx = new Dom.Document();
            docx.load(res.getBody());
            dom.XmlNode xroot = docx.getrootelement();
            
            stores = new List<CEC_IRIWrapper.STORE>();
    
            if(xroot.getAttributeValue(xroot.getAttributeKeyAt(0), xroot.getAttributeKeyNsAt(0)) == '0'){
                stores = parseStoreInfo(res.getBody());
                if(stores.size()== 0){
                    errMsg = 'No store information is available for this product';
                }
            }
            else if(xroot.getAttributeValue(xroot.getAttributeKeyAt(0), xroot.getAttributeKeyNsAt(0)) == '1'){
                errMsg = parseErrorMsg(res.getBody());
            }
            else{
                errMsg = 'Unable to fetch product details due to technical issue. Please contact sys admin';
            }
            if(errMsg != ''){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrMsg));
               errMsg = '';
            }
        }
        catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to fetch product details due to technical issue. Please contact sys admin'));
        }

  }
 
  /******************************************************************* 
        Purpose: 
            To Parse the error message and returns the error message
        Parameters: 
            XMLErrorResp: Error xml response
 ********************************************************************/
 public string parseErrorMsg(String XMLErrorResp){
      
      String ErrMsg = '';
      XmlStreamReader reader = new XmlStreamReader(XMLErrorResp);
      Boolean isNextElement = TRUE;
      
      while(isNextElement){
      
          if(reader.getLocalName()=='ERROR'){
              reader.next();
              ErrMsg += reader.getText();
          }
          if(reader.hasNext())
              reader.Next();
          else
              isNextElement = False;
      }
      return ErrMsg;
  }
  
   
   /******************************************************************* 
        Purpose: 
            To add the selected product locator to the case
        Parameters: 
            None
  ********************************************************************/
  
  public void addToCase(){
      
      List<CEC_Product_Locator__c> storeList = new List<CEC_Product_Locator__c>();
      CEC_Product_Locator__c prodLoc;
      
      for(CEC_IRIWrapper.STORE storeRec : stores){
      
          if(storeRec.ISSELECTED){
          
              prodLoc = new CEC_Product_Locator__c();
              prodLoc.Address__c = storeRec.ADDRESS;
              prodLoc.CaseStoreId__c = currentRecordId +'_'+storeRec.STORE_ID;
              prodLoc.Case__c = currentRecordId;
              prodLoc.City__c = storeRec.CITY;
              prodLoc.Distance__c = storeRec.DISTANCE;
              prodLoc.Latitude__c = storeRec.LATITUDE;
              prodLoc.Longitude__c = storeRec.LONGITUDE;
              prodLoc.Name__c = storeRec.NAME;
              prodLoc.Phone__c = storeRec.PHONE;
              prodLoc.State__c = storeRec.STATE;
              prodLoc.Store_Id__c = storeRec.STORE_ID;
              prodLoc.Store_Number__c = storeRec.STORE_NUMBER;
              prodLoc.UPC_Code__c = storeRec.UPC_CODE;
              prodLoc.Zip_Code__c = storeRec.ZIP;
              storeList.add(prodLoc);
          }
      
      }
            
      if(storeList.size()>0){
          upsert storeList CaseStoreId__c;
      }
  
  }
  
  
   /******************************************************************* 
        Purpose: 
            To Parse the store information
        Parameters: 
            XMLResp: xml response
  ********************************************************************/
  
    public List<CEC_IRIWrapper.STORE> parseStoreInfo(String XMLResp){
        // to read xml stream
        XmlStreamReader reader = new XmlStreamReader(XMLResp);
        // control variable
        Boolean isNextElement = TRUE;
        List<CEC_IRIWrapper.STORE> stores = new List<CEC_IRIWrapper.STORE>();
      
        CEC_IRIWrapper.STORE store;
 		String storeJson,localName; 
        
         while(isNextElement){
            // fetch xml tag <store> where its start element
            if(reader.getLocalName() == 'STORE' && reader.getEventType() == xmlTag.START_ELEMENT){
				
                	store = new CEC_IRIWrapper.STORE();  
                    storeJson = JSON.serialize(store);
					Map<String,Object> objStoreMap = (Map<String,Object>)JSON.deserializeUnTyped(storeJson);
                	System.debug('***objStoreMap***'+objStoreMap);
                // parse till the end tag
                while(reader.hasNext()){
                    // extraxt store
					
					localName = reader.getLocalName();
                    if(reader.getEventType() == xmlTag.START_ELEMENT && objStoreMap.containsKey(localName)){
                        reader.Next();
						objStoreMap.put(localName,reader.getText());

                        System.debug('***objStoreMapAfter***'+objStoreMap);
                    }
                    else if(reader.getEventType() == XmlTag.END_ELEMENT && reader.getLocalName() == 'STORE'){
                        objStoreMap.put('ISSELECTED', False);
                        System.debug('*****objStoreMap final****'+ objStoreMap);
						storeJson = JSON.serialize(objStoreMap);
                        System.debug('*****storeJson****'+ storeJson);
                        stores.add((CEC_IRIWrapper.STORE)JSON.deSerialize(storeJson,CEC_IRIWrapper.STORE.class));
                        
                    }
                    reader.Next();
                }
            }
            if(reader.hasNext())
                reader.Next();
            else
                isNextElement = False;
        }
        //return store list
        return stores;
    }
    
   
}