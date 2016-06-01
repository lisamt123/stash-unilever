trigger DMS_Account on Account (after update) 
{

    List<Id> listId = new List<Id>();
    
    if(trigger.isUpdate) 
    {
        if(Trigger.isAfter) 
        {
            for(Account acc : Trigger.New) 
            {
                 listId.add(acc.Id);
            }
			DMS_AccountUserRole_CC.createPartner(listId);
        }
    }
    
}