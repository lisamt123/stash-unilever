/* Created By : Ajay Rawat
 * Use        : Update company code ECC when new company code is added to vendor request
 *              Update fieldType Picklist with global or Regional filed update
*/

trigger VPM_SetGlobalOrRegionalFieldUpdate on VPM_PurchasingRequests__c (before update) {

   if(trigger.isUpdate && VPM_CheckRecursive.runOnce())
   {
  
   //trigger.New[0].VPM_StoreText__c = String.ValueOf(trigger.New[0].VPM_NoOfDays__c);
       VPM_RegionalMaintainVendor.updateAndCheckFieldUpdate(trigger.New , trigger.OldMap);
       // Use for calling maintain service after vendor code updated from Mulesoft Cache
       VPM_RegionalMaintainVendor.InsertVendor(trigger.New , trigger.OldMap);
       //user for reports and to make comments as mandatory 
       VPM_RegionalMaintainVendor.requireRejectionComment(trigger.New , trigger.OldMap);
       //used to show updated fields in chatter 
       VPM_RegionalMaintainVendor.updateChatterFeed(trigger.New , trigger.OldMap);
       

    }


}