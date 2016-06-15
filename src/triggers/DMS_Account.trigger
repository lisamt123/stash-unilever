trigger DMS_Account on Account (after insert,after update) 
{
    
    List<Id> listId;
    
    if(trigger.isUpdate && Trigger.isAfter) 
    {	listId = new List<Id>();
        for(Account acc : Trigger.New) 
        {
            listId.add(acc.Id);
        }
        DMS_AccountUserRole.createPartner(listId);
    }
    
  
        Set<id> contactIds = new Set<id>();
        listId = new List<Id>();
        
        
        DMS_CountActiveStore countAcStore = new DMS_CountActiveStore();
        
        for(Account acc : Trigger.New){
             listId.add(acc.Id);
        }
        
        for(AccountTeamMember atm : [SELECT id,User.ContactId,AccountId From AccountTeamMember Where AccountId =: listId AND UserId !=null AND User.ContactId !=null]){            
            contactIds.add(atm.User.ContactId);
        }        
        countAcStore.countStores(contactIds);  
}