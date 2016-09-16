/*********************************************************************************
Name:  VPM_RecallApproval 
Copyright ? 2016  Unilever
==================================================================================
==================================================================================
Purpose:  Trigger to unlock the record when the request is for rework
-------                                                             
===================================================================================
===================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
1.0 -   Samrin Shaikh       11/04/2016       INITIAL DEVELOPMENT     Unlock Record  
2.0     Samrin Shaikh       19/07/2016       IAPR - 482 Point 1      Unlock the record By defaults when it is Approval process  

***********************************************************************************/

trigger VPM_RecallApproval on VPM_PurchasingRequests__c (After insert, After update) 
{

     try
     {
        
          /* if(trigger.isAfter){
           System.debug('Inside Trigger ');
               VPM_PurchaseRequestTriggerHelper purchaseRequestHelper = new VPM_PurchaseRequestTriggerHelper();
              purchaseRequestHelper.unlockPurchaseRequest(trigger.newMap,trigger.oldMap);
          
          } */
          
        for (VPM_PurchasingRequests__c purc1 :trigger.old)  
          {
                  System.debug('purc1  _______'+ purc1 );
          }

          for (VPM_PurchasingRequests__c purc :trigger.new)  
          {
             
                System.debug('Inside Trigger ');
                System.debug('Approval.isLocked(purc.id) @@@@@@'+ Approval.isLocked(purc.id));
                System.debug('purc.VPM_Status__c  @@@@@@'+ purc.VPM_Status__c  );

                // if (Approval.isLocked(purc.id))
                 if(purc.VPM_IsLock__c || purc.VPM_Status__c.Contains('Pending'))
                 {
                     System.debug('inside Block Approval.isLocked(purc.id)  ' + Approval.isLocked(purc.id));
                     //Approval.lock(purc,false);
                   //Boolean result= System.Approval.unlock(purc.id);
                   Boolean result= System.Approval.unlock(purc.id).isSuccess();
                    System.debug('@@@@@@@ result = System.Approval.unlock(purc.id).isSuccess();' +result); 
                 }
          } 
          
 
         
         
         
     }catch(Exception e)
     {
            System.debug('Trigger Error @@@@@@@ ');
     }
    
}