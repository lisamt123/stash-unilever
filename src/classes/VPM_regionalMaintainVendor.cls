public  class VPM_regionalMaintainVendor {

  public static void updateAndCheckFieldUpdate(List<VPM_PurchasingRequests__c> updatedVendorRequest , Map<Id,VPM_PurchasingRequests__c> OldVendorRequestValueList)
  {
    List<VPM_listOfRegionalandGlobalField__c> globalFields = VPM_listOfRegionalandGlobalField__c.getall().values();
    list<id> vendorRequestCompanyCode = new list<id>();
    recordType rec =[select id , Name from recordType where Name like '%Create%' AND sobjectType='VPM_PurchasingRequests__c' LIMIT 1];

    // Loop to get list of all company code id (Bulkify trigger)
        for (VPM_PurchasingRequests__c vendorRequest : updatedVendorRequest)
    {
        vendorRequestCompanyCode.add(vendorRequest.VPM_CompanyCode__c);
    }
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
        //Logic for : Update fieldType Picklist with global or Regional filed update
       
         VPM_PurchasingRequests__c OldVendorRequestValue =OldVendorRequestValueList.get(vendorRequest.id);
          if(VPM_SearchVendor1.CheckFlag != true && vendorRequest.VPM_checkForFieldUpdate__c == true && rec.id != OldVendorRequestValue.recordTypeId)
          {
            
            for (VPM_listOfRegionalandGlobalField__c fieldList : globalFields)
            {
                 if(vendorRequest.get(fieldList.VPM_ApiName__c) != OldVendorRequestValue.get(fieldList.VPM_ApiName__c))
                {
                    
                    if(vendorRequest.VPM_Fieldtype__c == null)
                    {
                        vendorRequest.VPM_Fieldtype__c = fieldList.VPM_fieldType__c;
                    }
                    else if((vendorRequest.VPM_Fieldtype__c == 'Global' && fieldList.VPM_fieldType__c=='Regional')||(vendorRequest.VPM_Fieldtype__c == 'Regional' && fieldList.VPM_fieldType__c=='Global'))
                             vendorRequest.VPM_Fieldtype__c='Both';
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
              if(VPM_SearchVendor1.CheckFlag != true && vendorReq.VPM_checkForFieldUpdate__c == true)
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
         catch (Exception e) { System.debug('Error: ' + e); } 
    }
  }

 public static void InsertVendor(List<VPM_PurchasingRequests__c> venreqList , Map<Id,VPM_PurchasingRequests__c> vendReqOldMap)
    {
    List<VPM_PurchasingRequests__c> venReqLst = new List<VPM_PurchasingRequests__c>();
    List<String> vendorList = new List<String>();
    List<mdm_Vendors__c> venList = new List<mdm_Vendors__c>();
    MAP<String,String> vendorVenReqMap = new MAP<String,String>();
    MAP<String,String> venReqVendorMap = new MAP<String,String>();
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
                for(VPM_PurchasingRequests__c venR : venReqLst)
                {
                    VPM_regionalMaintainVendor.callRegionalService(venR.Id);
                }
            }
                
        }
    
    }

@future(Callout = true)
public static void callRegionalService(string vendorId)
{

             String responseString= vendorId;
            
             responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
             VPM_HttpUtil.sendEmail('ajay.rawat@capgemini.com','Global Create Response from service trigger',responseString); 
             VPM_HttpUtil.sendEmail('deepak.moudekar@capgemini.com','Global Create Response from service trigger',responseString);
             
}

}