/**********************************************************************
Name: ICB_ContactParnerUserCreation
Copyright © 2016 Unilever

Purpose: Class to create Community Users when new contacts are created.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  18/08/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public with sharing class ICB_ContactPartnerUserCreation {
    
    public static final ICB_ContactPartnerUserCreation instance = new ICB_ContactPartnerUserCreation();
    private static Profile myProfile;
    private static User newUser;
    
    public ICB_ContactPartnerUserCreation() {
       
    }

    static {
         myProfile =  [SELECT id FROM Profile WHERE name = 'Partner Community Login Basic'][0];
    }
    
    public static ICB_ContactPartnerUserCreation getInstance() {
        return instance;
    }
    
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
            Database.insert(users); 

            definePermissionSetting();
            
        }  
        catch (Exception e)
        {
            system.debug('' + e.getCause() + e.getMessage() + e.getLineNumber());
        } 
        finally{
            //add the users on the contact members team to the related Store
            //accountTeamMemberInsert(contact);
        }
    }
    
    /****************
    * Purpose: Create new User when contacts updated with an Email.
    * Parameters: oldTrigger & newTrigger values
    * Returns: none 
    ***************/
    public void updateUser(List<Contact> contactOld, List<Contact> contactNew) 
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
            Database.insert(users);
        } 
        catch (Exception e) 
        {
            system.debug('' + e.getCause() + e.getMessage() + e.getLineNumber());
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
        
        String userName = contact.email.substringBefore('@').tolowercase() + system.now().day() + '@operadorkibon.com';
        String alias = contact.email.substringBefore('@');

        newUser = new User(
            alias = alias.substring(0,4) + system.now().day(),
            email = contact.email, 
            emailencodingkey = 'UTF-8',
            firstname = contact.firstName, 
            lastname = contact.lastname, 
            languagelocalekey = 'pt_BR', 
            localesidkey = 'pt_BR',
            contactId = contact.Id,
            timezonesidkey = 'America/Sao_Paulo', 
            Username =  userName,
            CommunityNickname = userName,
            ProfileId = myProfile.Id,
            IsActive = true);
        newUser.setOptions(dmo); 
        
        return newUser;
    }
    
	@future
    public static void definePermissionSetting() {
        List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();
        List<PermissionSet> listPermission = [SELECT Id, Label 
                          FROM PermissionSet 
                          WHERE Label IN ('ICB Mobile Channel Salesman', 'ICB Mobile Channel Operator PCL')];
        
      	List<User> listUser = [SELECT Id, 
                               Contact.ICB_Type__c, 
                               Contact.Name,
                               Contact.Ice_Cream_Community_User__c
                               FROM User 
                               WHERE Contact.Ice_Cream_Community_User__c = TRUE 
                               AND Contact.RecordType.Name = 'Ice Cream'];
        
        for(User myUsers : listUser) {
            if (myUsers.Contact.ICB_Type__c == 'Ice Cream Salesman' && myUsers.Contact.Ice_Cream_Community_User__c == TRUE ) {                
                 psa.add(new PermissionSetAssignment(PermissionSetId = listPermission.get(0).Id, AssigneeId = myUsers.Id));
	
            } else if (myUsers.Contact.ICB_Type__c == 'Operator' && myUsers.Contact.Ice_Cream_Community_User__c == TRUE) {
            	psa.add(new PermissionSetAssignment(PermissionSetId = listPermission.get(1).Id, AssigneeId = newUser.Id));
            }
        }
        system.debug('lista psa: ' + psa);
        Database.insert(psa);
    }
  
}