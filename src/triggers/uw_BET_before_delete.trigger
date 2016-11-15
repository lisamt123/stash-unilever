/* This trigger is written ACC-IDC-Srilakshmi for Incident -ULHD00007465430 -Deleting a BET does not delete the corresponding group */
trigger uw_BET_before_delete on uw_BET__c (before delete) 
{
    List<Id> delete_BET_group_Ids = new List<Id>();
    List<CollaborationGroup> delete_BET_chatter_group = new List<CollaborationGroup>();
    List<Id> BET_Ids = new List<Id>();
    List<uw_BET_Team_Member__c> delete_BET_Team_Member = new List<uw_BET_Team_Member__c>();
    
    for(uw_BET__c u:Trigger.old)//for loop for BET related chatter grouo id and BET ids.
    {
            delete_BET_group_Ids.add(u.Studio_Chatter_Group__c);//BET related chatter group
            BET_Ids.add(u.Id);//BET ids
            System.debug('Group Id'+u.CollaborationGroupId__c+'second group id'+u.Studio_Chatter_Group__c);      
    }
    
    /* Below code is added to delete the Chatter groupo associated with the deleted BET */
    try
    {
       List<Database.DeleteResult> result_delete_BET_Group = null;
       result_delete_BET_Group = Database.delete(delete_BET_group_Ids,false);//deleted BET related Chatter group
    }
    catch(System.DmlException e)
    {
        System.debug('Error in deleting the BET Group');
    }

    /* Below code is added to delete the BET Team members associated with the deleted BET */

    try
    {
        delete_BET_Team_Member =[Select u.Id, u.BET__c From uw_BET_Team_Member__c u where u.BET__c in:BET_Ids];//BET team members
    }
    catch(Exception e)
    {
    }    
    try
    {
       List<Database.DeleteResult> result_delete_BET_Member = null;
       result_delete_BET_Member = Database.delete(delete_BET_Team_Member,false);//deleted BET team members
    }
    catch(System.DmlException e)
    {
        System.debug('Error in deleting the BET Member');
    }
}