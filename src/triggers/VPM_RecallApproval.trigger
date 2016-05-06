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
                if(purc.VPM_Rework__c=='Yes')
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