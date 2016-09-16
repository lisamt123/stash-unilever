/* Created By : Ajay Rawat
 * Use        : Update company code ECC when new company code is added to vendor request
 *              Update fieldType Picklist with global or Regional filed update
*/

trigger VPM_setGlobalOrRegionalFieldUpdate on VPM_PurchasingRequests__c (before update) {

     List<VPM_GlobalFields__c> globalFields = VPM_GlobalFields__c.getall().values();
    list<VPM_PurchasingRequests__c> updatedVendorRequest = trigger.new; 
    list<VPM_PurchasingRequests__c> oldVendorRequest = trigger.old; 
    Map<id,VPM_PurchasingRequests__c> OldVendorRequestValueList =trigger.oldMap;
    list<id> vendorRequestCompanyCode = new list<id>();
    
    try
    {
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
          if(VPM_SearchVendor1.CheckFlag != true && vendorRequest.VPM_checkForFieldUpdate__c == true)
          {
             VPM_PurchasingRequests__c OldVendorRequestValue =OldVendorRequestValueList.get(vendorRequest.id);
            for (VPM_GlobalFields__c fieldList : globalFields)
            {
                 if(vendorRequest.get(fieldList.VPM_apiName__c) != OldVendorRequestValue.get(fieldList.VPM_apiName__c))
                {
                    if(vendorRequest.VPM_Fieldtype__c == null)
                    {
                        vendorRequest.VPM_Fieldtype__c = fieldList.VPM_Fieldtype__c;
                    }
                    else if((vendorRequest.VPM_Fieldtype__c == 'Global' && fieldList.VPM_Fieldtype__c =='Regional')||(vendorRequest.VPM_Fieldtype__c == 'Regional' && fieldList.VPM_Fieldtype__c =='Global'))
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
            //system.debug('%%%'+vendorReq.VPM_checkForFieldUpdate__c );
            if(!(OldVendorRequestValueList.get(vendorReq.id).get('VPM_checkForFieldUpdate__c') ==true))
            system.debug('%%%'+OldVendorRequestValueList.get(vendorReq.id).get('VPM_checkForFieldUpdate__c'));
             //system.debug('%%%'+str);
            //if(vendorReq.VPM_checkForFieldUpdate__c == true && OldVendorRequestValueList.get(vendorReq.id).get('VPM_checkForFieldUpdate__c') == true)
            if(VPM_SearchVendor1.CheckFlag != true && vendorReq.VPM_checkForFieldUpdate__c == true)
            {
            if(vendorReq.get(str) != OldVendorRequestValueList.get(vendorReq.id).get(str))
            { 
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
         catch (Exception e) 
         { 
            System.debug('Error: ' + e); 
         } 
    }
    }
    catch(Exception ex)
    {
        system.debug('Exception from trigger'+ex);
    } 
}