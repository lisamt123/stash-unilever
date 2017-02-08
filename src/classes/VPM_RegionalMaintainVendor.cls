/*********************************************************************************************************
Name:  VPM_RegionalMaintainVendor 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  To perform search Vendor from cache, make web service callout,
          show different screen based on buisness user selected on Launch 
         screen, perform validations and save functionality.    
1. VPM_AdvancedForm

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Deepak       06 Oct 2016      Trigger handler         Use to call maintain service when vendor cached or updated by MuleSoft.
2.0 -    Deepak       06 Oct 2016      Trigger handler         Track field updated in Advance form
3.0 -    Ajay         10 Oct 2016      Trigger handler         Update Vendor ECC with Commodity ECC.
4.0 -    Vaishali     06 Nov 2016      Trigger handler         Set SLA for different queue.
************************************************************************************************************/
public without sharing class VPM_RegionalMaintainVendor {

    /******************************************************************** 
    Created By   : Ajay
    Created Date : 10th Oct 2016
    Last Modify  : 10th Oct 2016
    Description  : Track field updated in Advance form.Update Vendor ECC with Commodity ECC.
    Return Type  : Contructor no return type.
    ********************************************************************/
    final static string STR_CONST_PurchasingOrg = 'Payment Terms and Purchasing Org Details Changed';
    final static string STR_CONST_FinancialDetails = 'Financial Details Section Changed';
    final static string STR_CONST_RegionalSpec = 'Regional Specific Section Changed';
    final static string STR_CONST_BankDetails = 'Bank Details Section Changed';
    final static string STR_CONST_GeneralVendorDetails = 'General Vendor Details Section Changed';
    final static string STR_CONST_PIVendor = 'PI Vendor Section Changed';
    final static string STR_CONST_SAPBPMError = 'MDM Insert/Update Status Message';
    static boolean feedCreated = false;
    Static Map<string,string> FormatedFeed=  new Map<string,string>{STR_CONST_PurchasingOrg =>'',STR_CONST_FinancialDetails =>'',STR_CONST_RegionalSpec =>'',STR_CONST_BankDetails=>'', STR_CONST_GeneralVendorDetails => '',STR_CONST_PIVendor =>'',STR_CONST_SAPBPMError  =>''};
    static Set<Id> oldRegionSet = new Set<Id>();
    //static Set<Id> newRegionSet = new Set<Id>();



  public static void updateAndCheckFieldUpdate(List<VPM_PurchasingRequests__c> updatedVendorRequest , Map<Id,VPM_PurchasingRequests__c> OldVendorRequestValueList)
  {
    List<VPM_ListOfRegionalandGlobalField__c> globalFields = VPM_ListOfRegionalandGlobalField__c.getall().values();
    list<id> vendorRequestCompanyCode = new list<id>();
    //Id devRecordTypeId = Schema.SObjectType.VPM_PurchasingRequests__c.getRecordTypeInfosByName().get('Vendor Request').getRecordTypeId();
   // recordType rec =[select id , Name from recordType where Name like '%Create%' AND sobjectType='VPM_PurchasingRequests__c' LIMIT 1];

    // Loop to get list of all company code id (Bulkify trigger)
   for (VPM_PurchasingRequests__c vendorRequest : updatedVendorRequest)
    {
       //if(vendorRequest.RecordTypeId == devRecordTypeId)
       {
        vendorRequestCompanyCode.add(vendorRequest.VPM_CompanyCode__c);
        if(vendorRequest.VPM_Regions__c != null)  {
              
            oldRegionSet .add(vendorRequest.VPM_Regions__c);
        }
        if(OldVendorRequestValueList.get(vendorRequest.Id).VPM_Regions__c != null)
        {
            oldRegionSet.add(OldVendorRequestValueList.get(vendorRequest.Id).VPM_Regions__c);
        }
        
       }
    }
    if(!vendorRequestCompanyCode.isEmpty())
    {
     Map <id,VPM_CompanyCode__c> companyCodeMap =new Map<ID, VPM_CompanyCode__c>([SELECT ECC__c, id from VPM_CompanyCode__c where id =: vendorRequestCompanyCode]);
     for (VPM_PurchasingRequests__c vendorRequest : updatedVendorRequest)
    {
        // Logic for : Update company code ECC when new company code is added to vendor request
         VPM_CompanyCode__c companyCode =companyCodeMap.get(vendorRequest.VPM_CompanyCode__c);        
         if(Trigger.isUpdate){
            if(companyCode.ECC__c != vendorRequest.VPM_ECC__c && companyCode.ECC__c!=null)
            {
                system.debug('companyCode.ECC__c '+companyCode.ECC__c);
                vendorRequest.VPM_ECC__c = companyCode.ECC__c;
            }
           }
        }
      }
        //Logic for : Update fieldType Picklist with global or Regional filed update
    for (VPM_PurchasingRequests__c vendorRequest : updatedVendorRequest)
    {
         VPM_PurchasingRequests__c OldVendorRequestValue =OldVendorRequestValueList.get(vendorRequest.id);
         if(!VPM_SearchVendor1.CheckFlag)
         {
          if(vendorRequest.VPM_checkForFieldUpdate__c )
          {
            
            for (VPM_ListOfRegionalandGlobalField__c fieldList : globalFields)
            {
                 if(vendorRequest.get(fieldList.VPM_ApiName__c) != OldVendorRequestValue.get(fieldList.VPM_ApiName__c))
                {
                    
                    if(vendorRequest.VPM_Fieldtype__c == null)
                    {
                        vendorRequest.VPM_Fieldtype__c = fieldList.VPM_fieldType__c;
                    }
                    else if((vendorRequest.VPM_Fieldtype__c == 'Global' && fieldList.VPM_fieldType__c=='Regional')||(vendorRequest.VPM_Fieldtype__c == 'Regional' && fieldList.VPM_fieldType__c=='Global'))
                         {
                             vendorRequest.VPM_Fieldtype__c='Both';
                          }
                }
            }
           }
         
      }
         
    }


        // Save updated field
    Map<String, Schema.SObjectField> M = Schema.SObjectType.VPM_PurchasingRequests__c.fields.getMap(); 

    //Schema.SObjectType leadSchema = Schema.getGlobalDescribe().get('VPM_PurchasingRequests__c');
    //Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    //String chatterText='';

    //boolean isChatterUpdateRequired = false;
    //Adding a Text post
    //FeedItem post = new FeedItem();
    
    
    
     System.debug('M: ' + M);
    for (String str : M.keyset()) 
    { 
    try 
        { 
            for(VPM_PurchasingRequests__c vendorReq : updatedVendorRequest)
            {
                //post.ParentId = vendorReq.id; //eg. Opportunity id, custom object id..
           // if(!(OldVendorRequestValueList.get(vendorReq.id).get('VPM_checkForFieldUpdate__c') ==true))
           if(!VPM_SearchVendor1.CheckFlag)
           {
               if(vendorReq.VPM_checkForFieldUpdate__c)
                {
                    if(vendorReq.get(str) != OldVendorRequestValueList.get(vendorReq.id).get(str))
                    { 
                         system.debug(str +' :'+vendorReq.get(str));
                             system.debug(str +' :'+OldVendorRequestValueList.get(vendorReq.id).get(str));
                        if( vendorReq.VPM_fieldUpdated__c != null){
                        if(!vendorReq.VPM_fieldUpdated__c.contains(str))
                        {
                          vendorReq.VPM_fieldUpdated__c =str+','+vendorReq.VPM_fieldUpdated__c ;

                        }
                        
                        }
                        else
                        {
                        vendorReq.VPM_fieldUpdated__c = str+',';
                      }
                      
                    } 
                }
            }
            
            
            }
           
        }
         catch (Exception e) { System.debug('Error: ' + e); } 
    }

  }



    /******************************************************************** 
    Created By   : Deepak
    Created Date : 06th Oct 2016
    Last Modify  : 06th Oct 2016
    Description  :  Use to call maintain service when vendor cached or updated by MuleSoft.
    Return Type  : Contructor no return type.
    ********************************************************************/
 public static void InsertVendor(List<VPM_PurchasingRequests__c> venreqList , Map<Id,VPM_PurchasingRequests__c> vendReqOldMap)
    {
    List<VPM_PurchasingRequests__c> venReqLst = new List<VPM_PurchasingRequests__c>();
    //List<String> vendorList = new List<String>();
   // List<mdm_Vendors__c> venList = new List<mdm_Vendors__c>();
   // MAP<String,String> vendorVenReqMap = new MAP<String,String>();
    //MAP<String,String> venReqVendorMap = new MAP<String,String>();
    String whereCon ='';
        for(VPM_PurchasingRequests__c venR : venreqList)
        {
            if(venR.VPM_MDMInsertUpdateStatus__c != vendReqOldMap.get(venR.Id).VPM_MDMInsertUpdateStatus__c && venR.VPM_MDMInsertUpdateStatus__c == 'MDM Insert/Update Succeeded')
            {
               if(venR.VPM_ECC__c == 'Fusion')
               {
                //vendorVenReqMap.put(venR.VPM_VendorCode__c,venR.Id);
                 whereCon = 'where mdm_vCodeFusion__c = \''+venR.VPM_VendorCode__c+'\' Limit 1';
               }
               else if(venR.VPM_ECC__c == 'U2K2')
               {
                 whereCon = 'where mdm_vCodeU2K2__c = \''+venR.VPM_VendorCode__c+'\' Limit 1';
               }
               else if(venR.VPM_ECC__c == 'Sirius')
               {
                  whereCon = 'where mdm_vCodeSirius__c = \''+venR.VPM_VendorCode__c+'\' Limit 1';
               }
               else if(venR.VPM_ECC__c == 'Cordillera')
               {
                  whereCon = 'where mdm_vCodeCordillera__c = \''+venR.VPM_VendorCode__c+'\' Limit 1';
               }
            }
        }
        
        if(!String.isBlank(whereCon))
        {
                String soql = 'Select Id,mdm_ID__c from mdm_Vendors__c '+whereCon;
                
                for(mdm_Vendors__c vend : Database.query(soql))
                {
                   for(VPM_PurchasingRequests__c venR : venreqList)
                    {
                        venR.VPM_VendorCodeLookup__c = vend.Id;
                        venReqLst.add(venR);
                    }
                
                }
            if(!venReqLst.isEmpty())
            {
               // update venReqLst;
                //for(VPM_PurchasingRequests__c venR : venReqLst)
                {
                    VPM_RegionalMaintainVendor.callRegionalService(venReqLst[0].Id);
                }
                
            }
                
        }
    
    }


 /******************************************************************** 
    Created By   : Deepak
    Created Date : 06th Oct 2016
    Last Modify  : 06th Oct 2016
    Description  :  Use to call maintain service when vendor cached or updated by MuleSoft.
    Return Type  : Contructor no return type.
    ********************************************************************/
@future(Callout = true)
public static void callRegionalService(string vendorId)
{

             String responseString= vendorId;
            
             responseString =responseString + VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
             VPM_HttpUtil.updateRecordType(vendorId); 
            
}

public static void requireRejectionComment(List<VPM_PurchasingRequests__c> updatedVendorRequest , Map<Id,VPM_PurchasingRequests__c> OldVendorRequestValueList)
{ 
      Map<Id, VPM_PurchasingRequests__c> rejectedStatements = new Map<Id, VPM_PurchasingRequests__c>{};

  for(VPM_PurchasingRequests__c inv: updatedVendorRequest)
  {
    
     /* 
      Set the hours spent with each approver group and store it in VPM_StoreHours.
    */
             
            if(!VPM_SearchVendor1.UpdateNoOfHoursFlag)
            {
            inv.VPM_CheckHours__c =true;
            VPM_SearchVendor1.UpdateNoOfHoursFlag =!VPM_SearchVendor1.UpdateNoOfHoursFlag;
            }
             if((inv.VPM_CheckHours__c))
             {
            system.debug('VPM_VendorSLA__c '+inv.VPM_VendorSLA__c);
            if( inv.VPM_VendorSLA__c < = 0)
            {
              inv.VPM_StoreHours__c= 0.01;
            }
            else
            {
             inv.VPM_StoreHours__c= inv.VPM_VendorSLA__c;
            }
             
             }
    
    /* 
      Get the old object record, and check if the approval status 
      field has been updated to rejected. If so, put it in a map 
      so we only have to use 1 SOQL query to do all checks.
    */
    
    VPM_PurchasingRequests__c oldInv = OldVendorRequestValueList.get(inv.Id);

    if (oldInv.VPM_ApprovalStatus__c != 'Rejected' 
     && inv.VPM_ApprovalStatus__c == 'Rejected')
    { 
      rejectedStatements.put(inv.Id, inv);  
    }
  }
   
  if (!rejectedStatements.isEmpty())  
  {
    // UPDATE 2/1/2014: Get the most recent approval process instance for the object.
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    
    for (VPM_PurchasingRequests__c invs : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM VPM_PurchasingRequests__c
                                      WHERE ID IN :rejectedStatements.keySet()])
    {
        processInstanceIds.add(invs.ProcessInstances[0].Id);
    }
      
    // Now that we have the most recent process instances, we can check
    // the most recent process steps for comments.  
    for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                               FROM ProcessInstance
                               WHERE Id IN :processInstanceIds
                               ORDER BY CreatedDate DESC])   
    {                   
      if ((pi.Steps[0].Comments == null || 
           pi.Steps[0].Comments.trim().length() == 0))
      {
        rejectedStatements.get(pi.TargetObjectId).addError(
          'Please provide a rejection reason!');
      }
    }  
  }
}

 /******************************************************************** 
    Created By   : Vaishali
    Created Date : 9th Dec 2016
    Last Modify  : 13th Dec 2016
    Description  : Logic for chatter feed istory
    Return Type  : Contructor no return type.
    ********************************************************************/
public static void updateChatterFeed(List<VPM_PurchasingRequests__c> updatedVendorRequest , Map<Id,VPM_PurchasingRequests__c> OldVendorRequestValueList){
    //FormatedFeed = new Map<string,string>{STR_CONST_PurchasingOrg =>'',STR_CONST_FinancialDetails =>'',STR_CONST_RegionalSpec =>'',STR_CONST_BankDetails=>'', STR_CONST_GeneralVendorDetails => ''};
   

    List<VPM_ListOfRegionalandGlobalField__c> globalFields = VPM_ListOfRegionalandGlobalField__c.getall().values();
     
    Schema.SObjectType leadSchema = Schema.getGlobalDescribe().get('VPM_PurchasingRequests__c');
    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    String chatterText='<ul><li>';
    boolean isChatterUpdateRequired = false;
    //Adding a Text post
    FeedItem post = new FeedItem();
    system.debug('@@@@ VendorReqWithRegion  '+oldRegionSet);
                          
    Map<id,VPM_Region__c> VendorReqWithRegion = new Map<id,VPM_Region__c >([SELECT ID, Name from VPM_Region__c where id in :oldRegionSet]);
    for (VPM_ListOfRegionalandGlobalField__c fieldApi : globalFields) 
    { 
    try 
        { 
          for(VPM_PurchasingRequests__c vendorReq : updatedVendorRequest)
            {
            VPM_PurchasingRequests__c OldVendorRequestValue =OldVendorRequestValueList.get(vendorReq.id);
                post.ParentId = vendorReq.id; //eg. Opportunity id, custom object id..
           
                      // Vaishali Nagar : Logic for chatter feed istory
                       if(!VPM_SearchVendor1.CheckFlag && vendorReq.VPM_checkForFieldUpdate__c)
                          {
               
                           if(vendorReq.get(fieldApi.VPM_ApiName__c) != OldVendorRequestValue.get(fieldApi.VPM_ApiName__c))
                          {
                          
                            String oldValue=String.ValueOf(OldVendorRequestValue.get(fieldApi.VPM_ApiName__c));
                            String newValue=String.ValueOf(vendorReq.get(fieldApi.VPM_ApiName__c));
                             system.debug('@@@@ VendorReqWithRegion  '+VendorReqWithRegion);
                          
                             if(fieldApi.VPM_ApiName__c =='VPM_Regions__c' && !string.isBlank(newValue))
                             {
                             newValue = VendorReqWithRegion.get(newValue).Name;
                             }
                              if(fieldApi.VPM_ApiName__c =='VPM_Regions__c' && !string.isBlank(oldValue))
                             {
                             oldValue= VendorReqWithRegion.get(oldValue).Name;
                             }
                                
                             if(string.isBlank(newValue))
                             {
                                newValue='Blank Value';
                             }
                            
                              if(string.isBlank(oldValue))
                             {
                                oldValue='Blank Value';
                             }
                             
                            chatterText= 'Changed '+fieldMap.get(fieldApi.VPM_ApiName__c).getDescribe().getLabel()+' from '+oldValue+' to '+newValue;
                             if(!string.isBlank(string.ValueOf(fieldApi.VPM_SectionName__c))){
                                 
                                 
                                
                                 createHTMLFormatedFeed(chatterText ,String.ValueOf(fieldApi.VPM_SectionName__c));
                                 isChatterUpdateRequired =true;
                             }
                           
                             
                           }
                           }
                    } 
                } catch (Exception e) { System.debug('Error: ' + e); } 
            }
    if(isChatterUpdateRequired)
    {
      chatterText ='';
      for(string objectName : FormatedFeed.keySet())
      {
      system.debug('chatter Feed 1'+FormatedFeed.get(objectName));
      if( FormatedFeed.get(objectName) != '' && FormatedFeed.get(objectName) !=null)
        chatterText = chatterText + FormatedFeed.get(objectName)+'</ul>';
      }
      system.debug('Chatter Feed '+chatterText  );
      if(!feedCreated)
      {
        post.Body = chatterText;
        post.IsRichText =true;
        
        insert post;
        feedCreated = true;
        
        }
        else
        {
        FeedItem feedItems = [SELECT Id FROM FeedItem WHERE CreatedById = :UserInfo.getUserId() ORDER BY CreatedDate DESC limit 1];
        feedItems.body = chatterText;
         feedItems.IsRichText =true;
         update feedItems;
        
}
        }
    }


 public static void createHTMLFormatedFeed(String feedToformat, String SectionName)
 {
     feedToformat =feedToformat.replace('<','&lt;');
     feedToformat =feedToformat.replace('>','&gt;');
    if(FormatedFeed.get(SectionName) == '')
    {
      FormatedFeed.put(SectionName,'<p><b>'+SectionName+'</b></p><ul><li>'+feedToformat+'</li>');
    }
    else
     FormatedFeed.put(SectionName,FormatedFeed.get(SectionName)+'<li>'+feedToformat+'</li>');
  }
}