trigger VPM_RecallApproval on VPM_PurchasingRequests__c (After update,before update) 
{
   
          if(Trigger.IsUpdate)
        {
          for (VPM_PurchasingRequests__c purc :trigger.new)  
          {
                  if(purc.VPM_Rework__c=='Yes' || (purc.VPM_Rework__c=='Completed' && purc.VPM_IsLock__c==true))
                {
                System.debug('Alsana Shaikh  1');
                Approval.unlock(trigger.new);
                System.debug('Alsana Shaikh  2');
                }
          
                // else  if (String.isBlank(purc.VPM_Rework__c))
                else if(purc.VPM_Rework__c=='Completed')
                {
System.debug('Alsana Shaikh  3');
                        Approval.lock(trigger.new);
                    System.debug('Alsana Shaikh  4');
                }    
          
        }
     }
        
     
    
}