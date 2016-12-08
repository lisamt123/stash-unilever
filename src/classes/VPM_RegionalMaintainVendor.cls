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
public with sharing class VPM_RegionalMaintainVendor {

    /******************************************************************** 
    Created By   : Ajay
    Created Date : 10th Oct 2016
    Last Modify  : 10th Oct 2016
    Description  : Track field updated in Advance form.Update Vendor ECC with Commodity ECC.
    Return Type  : Contructor no return type.
    ********************************************************************/

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
     System.debug('M: ' + M);
    for (String str : M.keyset()) 
    { 
    try 
        { 
            for(VPM_PurchasingRequests__c vendorReq : updatedVendorRequest)
            {
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
                        vendorReq.VPM_fieldUpdated__c = str+',';
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
             inv.VPM_StoreHours__c=inv.VPM_VendorSLA__c;
             
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
          'Operation Cancelled: Please provide a rejection reason!');
      }
    }  
  }
}
}