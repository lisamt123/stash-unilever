/***************************************************************
Name: UL_CreatePromotionController()
Copyright © 2015 Salesforce
======================================================
Purpose:
Controller for UL_DeliveryProfileController apex page.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Vinod Thupakula    05/12/2016        INITIAL DEV       Creation of Delivery Profile for UKI.
*****************************************************************/
public with sharing class UL_DeliveryProfileController{
    
    private final Static String SAVE_NEW = 'saveAndNew';
    
    
    private ApexPages.StandardController ctr;
    private String recId{set;get;}
    
    public boolean disWeeks{set;get;}
    public list<Integer> filedLevels{set;get;} 
    public Integer weekLimit{set;get;}      
    public UL_Delivery_Profile__c releatedRecord{set;get;}
   
    
    private UL_Planning_Level__c allAccounts{set;get;}
    private ACCL__Product__c allProducts{set;get;}
    /*******************************************************************
    Purpose: Default constructor fetch delivery profile
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_DeliveryProfileController(ApexPages.StandardController controller) {
        this.ctr = controller;       
        releatedRecord = new UL_Delivery_Profile__c ();  
        recId = System.currentPagereference().getParameters().get(Schema.SObjectType.UL_Delivery_Profile__c.fields.Id.getName());        
         if(releatedRecord.UL_Valid_From__c == UL_Utility.NULL_DATE && releatedRecord.UL_Valid_Thru__c == UL_Utility.NULL_DATE){
                releatedRecord.UL_Valid_From__c = System.today();
                releatedRecord.UL_Valid_Thru__c =  Date.newInstance(2099, 12, 31);
        }
          try{
             allProducts = UL_Utility.returnGenericProduct();
             allAccounts = UL_Utility.returnGenericCustomer();
            
            this.releatedRecord.UL_Planning_Level__c = allAccounts.Id;
            this.releatedRecord.UL_Product__c = allProducts.Id;
        }
        catch(Exception e){}
        
    }
    /*******************************************************************
    Purpose: This method feth the Instore days value assign to Shipment End Days field. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public void shipmentEndDaysSet(){  
        try{
            releatedRecord.UL_Shipment_End_days__c = releatedRecord.UL_Instore_End_days__c;  
            displayWeeks();
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
          }
          
    }
    
    /*******************************************************************
    Purpose: This method feth the valid from value assign to valid thru field. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public void validThruDateSet(){  
        try{
            releatedRecord.UL_Valid_Thru__c= releatedRecord.UL_Valid_From__c;  
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
          }
          
    }
    /*******************************************************************
    Purpose: This method set the Shipment Start days. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public void shipmentStartDaysSet(){  
        try{    
           if(releatedRecord.UL_Shipment_Start_days__c!= null && releatedRecord.UL_Shipment_Start_days__c>0){
               releatedRecord.UL_Shipment_Start_days__c =  releatedRecord.UL_Shipment_Start_days__c - (2 * releatedRecord.UL_Shipment_Start_days__c);
               ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, System.label.Shipment_Instore_validation);
               ApexPages.addMessage(msg);               
           }
           displayWeeks();
        }
    catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
      }
    }   
    /*******************************************************************
    Purpose: This method save and update current record. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/   
    public PageReference save(){
            PageReference pref = null;
       try{
           
                mappingCustomer();               
                Database.upsert(releatedRecord);
                Boolean saveAndNew = false;                 
                for(String key : Apexpages.currentPage().getParameters().keySet()){                                       
                    if(key.contains(SAVE_NEW)){                     
                        saveAndNew = true;
                        break;
                    }
                }
                if(saveAndNew){                 
                    Apexpages.currentPage().setRedirect(true);
                    pref =  new PageReference(UL_Utility.FORWARD_SLASH + ctr.getRecord().getSObjectType().getDescribe().getKeyPrefix()+ UL_Utility.RECORD_EDIT_PARAM);
                }
                else{
                    pref = new PageReference(UL_Utility.FORWARD_SLASH + releatedRecord.Id);
                    pref.setRedirect(true); 
                }                                   
             }             
         catch(Exception ex){               
               if(!ex.getMessage().contains(Label.UL_Duplicate_Record_Found)){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  UL_UtilityController.errorMessage(ex.getMessage())));
               }               
               UL_Utility.logError(Ex, UserInfo.getUserId());
              
          }
    return pref ;
    } 
    /*******************************************************************
    Purpose: This method redirect for edit page. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/ 
    public void editDeliveryProfile(){
        try{
            if(recId != null){
                releatedRecord = [SELECT Id,OwnerId,Name,RecordTypeId,CreatedDate,CreatedById, 
                                         UL_Week_1_Phasing__c,
                                         UL_Week_2_Phasing__c,UL_Week_3_Phasing__c,UL_Week_4_Phasing__c, 
                                         UL_Week_5_Phasing__c,UL_Week_6_Phasing__c,UL_Week_7_Phasing__c,
                                         UL_Week_8_Phasing__c,UL_Week_9_Phasing__c,UL_Week_10_Phasing__c, 
                                         UL_Week_11_Phasing__c,UL_Week_12_Phasing__c,UL_Week_13_Phasing__c ,
                                         UL_Week_14_Phasing__c ,UL_Week_15_Phasing__c ,
                                         UL_Total_of_Phasing__c,UL_Delivery_Profile_Name__c, UL_Account__c, UL_Sales_Organisation__c, UL_Shipment_Start_days__c, UL_Shipment_End_days__c, UL_Instore_End_days__c, UL_Valid_From__c, UL_Valid_Thru__c, UL_Product__c, UL_Planning_Level__c FROM UL_Delivery_Profile__c where id=:recId limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
                displayWeeks();
            }
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
          }
    }
/*******************************************************************
Purpose: This method map the record field values. 
Version: 1.0
Parameters: N/A
Returns: Page Reference
Throws: N/A
********************************************************************/ 
    private void mappingCustomer(){
        if(releatedRecord.UL_Planning_Level__c == null){
             releatedRecord.UL_Planning_Level__c = allAccounts.Id;             
         }
          if(releatedRecord.UL_Product__c == null ){
             releatedRecord.UL_Product__c = allProducts.Id;
         }
         List<UL_Planning_Level__c> planningRec = [Select id, UL_Customer__c from  UL_Planning_Level__c where id=:releatedRecord.UL_Planning_Level__c limit 1];
             releatedRecord.UL_Account__c= planningRec[0].UL_Customer__c ;
        
    }
    /*******************************************************************
    Purpose: This method displays weeks dynamically 
    Version: 1.0
    Parameters: N/A
    Returns: None
    Throws: N/A
    ********************************************************************/  
    public void displayWeeks(){   
        try{
        filedLevels = new list<Integer>();
        Integer shipStartDate = Integer.valueOf(releatedRecord.UL_Shipment_Start_days__c);
        Integer shipEndDate = Integer.valueOf(releatedRecord.UL_Shipment_End_days__c);              
        if(shipStartDate != null && shipEndDate != null){
            if(shipStartDate < 0){
                shipStartDate  = shipStartDate * -1;
            }
            if(shipStartDate>0 && shipEndDate>0){                  
                Integer daysOfWeek = (shipStartDate + shipEndDate)/7;
                Integer numberOfWeeks = math.mod(shipStartDate + shipEndDate,7);                
                if(numberOfWeeks >0){
                    daysOfWeek = daysOfWeek + 1;
                    
                }
                if(daysOfWeek>15){ daysOfWeek = 15;}
                for(Integer i = 0;i<daysOfWeek ;i++){
                    filedLevels.add(i);
                }
                
                weekLimit = daysOfWeek ;
                disWeeks = true;
                }
           }  
        }
        catch(Exception Ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());            
            }
    }
    
    
}