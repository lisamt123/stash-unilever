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
    for (Integer i = 0; i < Trigger.new.size(); i++)
    {
     try
     {
        if( Trigger.isInsert || Trigger.IsUpdate)
        {
          for (VPM_PurchasingRequests__c purc :trigger.new)  
          {
               // if(purc.VPM_Rework__c=='Yes')
               if(purc.VPM_IsLock__c)
                {
                Approval.unlock(trigger.new,false);
                }
          }
        }
     }catch(Exception e)
     {
         Trigger.new[i].addError(e.getMessage());
     }
    }
}