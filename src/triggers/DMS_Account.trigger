trigger DMS_Account on Account (after insert,after update) 
{    
    List<Id> listId;
    Set<id> contactIds = new Set<id>();
    listId = new List<Id>();
    for(Account acc : Trigger.New) 
    {
        listId.add(acc.Id);
    }
    if(trigger.isUpdate && Trigger.isAfter) 
    {
        DMS_AccountUserRole.createPartner(listId);
    }
        
    DMS_ActiveStore countAcStore = new DMS_ActiveStore();
    
    for(AccountTeamMember atm : [SELECT id,User.ContactId From AccountTeamMember Where AccountId =: listId AND UserId !=null AND User.ContactId !=null])
    {            
        contactIds.add(atm.User.ContactId);
    }     
    countAcStore.countStoreUpdateAccount(contactIds);    
}