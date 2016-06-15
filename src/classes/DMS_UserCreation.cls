/**********************************************************************
Name: DMS_UserCreation

Purpose: Class to create Users when new contacts are created.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  12/06/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public class DMS_UserCreation {
    
    public DMS_UserCreation() {}
    
    /*
    * Purpose: Create new User when new contact is created
    * Parameters: oldTrigger & newTrigger values
    * Returns: none 
    */
    public void createNewUser(List<Contact> contact) 
    {
        
        List<User> users = new List<User>();
       try 
        {
            for(Contact con : [SELECT id, email, firstName, lastname, accountId FROM Contact WHERE Id =: contact]) 
            {
                if(!String.isEmpty(con.Email)) {
                    users.add(create(con));
                }
            } 
            insert users;
           
            accountTeamMemberInsert(contact);
        }  
        catch (Exception e)
        {
            system.debug(DMS_GlobalConstants.MSG_EXCEPTION_USERCREATION + e.getCause() + e.getMessage() + e.getLineNumber());
        } 
    }
    
    private void accountTeamMemberInsert(List<Contact> listContact) 
    {

        Map<Id, Map<Id, User>> mapContact = new Map<Id,Map<Id, User>>();
        Map<Id, User> mapValues = new Map<Id, User>();
        List<User> users = [SELECT Id, ContactId FROM User WHERE User.ContactId =: listContact];
        
        //insert contact
        for(User usr : users) {
            mapValues.put(usr.ContactId, usr);
        }
        
        if(mapValues.size() > 0) {
            for(Contact contact : [SELECT Id, CodRegion__c, AccountId FROM Contact WHERE Id =: mapValues.keySet()]) 
            {	
                if(mapContact.containsKey(contact.AccountId)) {
                	mapContact.put(contact.AccountId, mapValues);               
                } 
                
            }
            system.debug('VALOR DOIDO: ' + mapContact);
        }
    }
    
    private Map<Id, String> getStores(Map<Contact, Id> mapAccount) 
    {

        Map<Id, String> mapAccountCdRegion = new Map<Id, String>();
        List<Account> listAccount = [SELECT Id, CodRegion__c FROM Account WHERE ParentId =: mapAccount.values() And RecordTypeId = '01219000000CiAY'];

        for(Account acc : listAccount) 
        {
            if(!String.isEmpty(acc.CodRegion__c)) {
                mapAccountCdRegion.put(acc.Id, acc.CodRegion__c);
            }
        }
        return mapAccountCdRegion;
    }
    
    /*
    * Purpose: Create new User when contacts updated with an Email.
    * Parameters: oldTrigger & newTrigger values
    * Returns: none 
    */
    public void createtUserUpdate(List<Contact> contactOld, List<Contact> contactNew) 
    {
        try {
        	
            List<User> users = new List<User>();
            for(Integer i = 0; i < contactOld.size(); i++) 
            {
                if(contactOld.get(i).email == null && contactNew.get(i).email != null) 
                {
                    users.add(create(contactNew.get(i)));
                }
            }
            insert users;
            
            accountTeamMemberInsert(contactNew);
          } 
       catch (Exception e) 
        {
            system.debug(DMS_GlobalConstants.MSG_EXCEPTION_USERCREATION + e.getCause() + e.getMessage() + e.getLineNumber());
        }  
    }
    
    /*
    * Purpose: Create new User.
    * Parameters: contacts
    * Returns: none 
    */
    private User create(Contact contact) {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;       
        dmo.EmailHeader.triggerOtherEmail = false;
        dmo.EmailHeader.triggerAutoResponseEmail = false;       
        dmo.optAllOrNone = false;
        
        String userName = contact.email.substringBefore('@').tolowercase() + system.now().day() + '@unilever.community.com';
        String alias = contact.email.substringBefore('@') +system.now().day();
        User newUser = new User(
            alias = alias.abbreviate(6),
            email = contact.email, 
            emailencodingkey = 'UTF-8',
            firstname = contact.firstName, 
            lastname = contact.lastname, 
            languagelocalekey = 'es', 
            localesidkey = 'es_ES', 
            contactId = contact.Id,
            timezonesidkey = 'America/New_York', 
            Username = userName,
            CommunityNickname = userName,
            ProfileId = '00eE00000011JZ6',
            IsActive = true);
        newUser.setOptions(dmo); 
        
        return newUser;
    }
}