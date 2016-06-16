/**********************************************************************
Name: DMS_UserCreation
Copyright © 2016 Salesforce
====================================================== 
======================================================
Purpose: Class to create Users when new contacts are created.
====================================================== 
======================================================
History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  12/06/2016  INITIAL DEVELOPMENT.
2.0		DIMITRI MENEZES	 15/06/2016	 UPDATE METHOD FOR ACCOUNT TEAM MEMBERS.. 
3.0		CARLOS HENRIQUE	 16/06/2016  CLASS NAME CHANGED.
***********************************************************************/
public with sharing class DMS_ContactTriggerHelper 
{
	private static Profile myProfile;
	
    static 
    {
      myProfile =  [SELECT id FROM Profile WHERE name = 'Partner Community User'][0];
    }
    
    public DMS_ContactTriggerHelper() {}
    
    /*********************************************************
    * Purpose: Create new User when new contact is created
    * Parameters: oldTrigger & newTrigger values
    * Returns: none 
    *********************************************************/
    public void createNewUser(List<Contact> contact) 
    {
        
        List<User> users = new List<User>();
        try 
        {
            for(Contact con : [SELECT id, email, firstName, lastname, accountId FROM Contact WHERE Id =: contact]) 
            {
                if(!String.isEmpty(con.Email)) 
                {
                    //create the users
                    users.add(create(con));
                }
            } 
            insert users;
            
            //add the users on the contact members team to the related Store
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
        List<id> distributorsIds = new List<id>();
        List<id> storesIds = new List<id>();
        List<User> usersList = new List<User>();
        List<String> codeRegionList = new List<String>();

        for(User users : [SELECT Id, ContactId,Contact.accountId, Contact.CodRegion__c FROM User WHERE ContactId =: listContact]){
            distributorsIds.add(users.Contact.accountId);
            codeRegionList.add(users.Contact.CodRegion__c);
            usersList.add(users);
            
        }
        
        List<AccountTeamMember> aTeamList = new List<AccountTeamMember>();
        List<Account> accList = [SELECT id FROM Account WHERE ParentId =: distributorsIds AND CodRegion__c =: codeRegionList ];
        
        for(Account acc : [SELECT id,ParentId FROM Account WHERE ParentId =: distributorsIds AND CodRegion__c =:codeRegionList AND RecordTypeId =: DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer')]){
            for(User userTeam : usersList) 
            {
                if(userTeam.Contact.accountId == acc.ParentId){
                    AccountTeamMember aTeam = new AccountTeamMember();
                    aTeam.AccountId = acc.id;
                    aTeam.UserId = userTeam.id;
                    aTeamList.add(aTeam);
                }
            }            
        }
        Database.insert(aTeamList);                
         
    }
    
    
    /*
    * Purpose: Retreive all stores from the distributor with the Region Code.
    * Parameters: Map with Contacts and Ids
    * Returns: none 
    */
    private Map<Id, String> getStores(Map<Contact, Id> mapAccount) 
    {
        
        Map<Id, String> mapAccountCdRegion = new Map<Id, String>();
        List<Account> listAccount = [SELECT Id, CodRegion__c FROM Account WHERE ParentId =: mapAccount.values() And RecordTypeId =: DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer')];
        
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
    
    /***********************************
    * Purpose: Create new User.
    * Parameters: contacts
    * Returns: none 
    ************************************/
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
            ProfileId = myProfile.Id,
            IsActive = true);
        newUser.setOptions(dmo); 
        
        return newUser;
    }
}