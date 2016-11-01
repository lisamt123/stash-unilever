/* Created By : Ajay Rawat
 * Use        : Update company code ECC when new company code is added to vendor request
 *              Update fieldType Picklist with global or Regional filed update
*/

trigger VPM_setGlobalOrRegionalFieldUpdate on VPM_PurchasingRequests__c (before update) {

   if(trigger.isUpdate)
   {
       VPM_regionalMaintainVendor.updateAndCheckFieldUpdate(trigger.New , trigger.OldMap);
       // Use for calling maintain service after vendor code updated from Mulesoft Cache
       VPM_regionalMaintainVendor.InsertVendor(trigger.New , trigger.OldMap);
    }


}