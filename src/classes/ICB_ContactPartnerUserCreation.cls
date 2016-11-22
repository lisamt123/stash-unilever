/**********************************************************************
Name: ICB_ContactParnerUserCreation
Copyright © 2016 Unilever

Purpose: Class to create Community Users when new contacts are created.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE     25/08/2016  INITIAL DEVELOPMENT.
1.1 	ANTONIO RAUL	    27/09/2016  UPDATED CLASS.
***********************************************************************/
public with sharing class ICB_ContactPartnerUserCreation 
{
    private static String profileCommunity;
    private static String UserEmail;

    private static Profile myProfile;
    private static User newUser;
    private static List<String> permissions;
    private static List<String> types;
    private static List<String> recordTypeId;
    private static List<String> recorTypeName;
    private static List<Contact> listContact;
    private static final String CONST_INACTIVE;
   
    //private static List<User> listUser;
    
    public static final ICB_ContactPartnerUserCreation instance = new ICB_ContactPartnerUserCreation();
    
    public ICB_ContactPartnerUserCreation() 
    {
        //ICB_SetupMobileChannel.getInstance().disabledUser(getContacts());
    }
    
    static 
    {
       
       listContact = new List<Contact>();
       CONST_INACTIVE = 'Inactive';
       permissions 			= new List<String> { ICB_ContactTypes__c.getValues('Permission_Salesman').Value__c, ICB_ContactTypes__c.getValues('Permission_Operator').Value__c,ICB_ContactTypes__c.getValues('Permission_Console').Value__c};
       types 				= new List<String> { ICB_ContactTypes__c.getValues('Type_Salesman').Value__c, ICB_ContactTypes__c.getValues('Type_Operator').Value__c,  ICB_ContactTypes__c.getValues('Type_Console').Value__c};
       recordTypeId 		= new List<String> {Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Ice Cream Operator').getRecordTypeId(), Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Ice Cream Salesman').getRecordTypeId()};
       userEmail 			= ICB_ContactTypes__c.getValues('User_Email').Value__c;
       profileCommunity 	= ICB_ContactTypes__c.getValues('Profile_Community').Value__c;
       recorTypeName		= new List<String> { 'Ice Cream Operator', 'Ice Cream Salesman'};
       myProfile 			= [SELECT id FROM Profile WHERE name =: profileCommunity];
     
    }
    
    public static ICB_ContactPartnerUserCreation getInstance() 
    {
        return instance;

    }
    
    /*********************************************************
    * Purpose: Create new User when new contact is created
    * Parameters: oldTrigger & newTrigger values
    * Returns: none 
    *********************************************************/
    public void createNewUser(List<Contact> contact) 
    {
       
        System.debug('Entering <createNewUser>' + contact);
        List<User> users = new List<User>();
        
        try
        {
            for(Contact con : contact) 
            { 
                //create the users
                users.add(create(con));
            } 
            system.debug(users);
            updateContact();
            Database.insert(users,false); 
            definePermissionSetting();
            insertUserGroup();

            
        }  
        catch (Exception e)
        {
            system.debug(Label.ICB_ERROR_MESSAGE +  e.getCause());
        }  
        System.debug('Exiting <createNewUser>');
    }
   
    /***********************************
    * Purpose: Create new User.
    * Parameters: contacts
    * Returns: A created User 
    ************************************/
    private User create(Contact contact) 
    {
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;       
        dmo.EmailHeader.triggerOtherEmail = false;
        dmo.EmailHeader.triggerAutoResponseEmail = false;       
        dmo.optAllOrNone = false;
        
        System.debug('Entering <create>' + contact);
        
        try 
        {  
            Integer value = Integer.valueOf(math.rint(math.random()*1000));
            String userName = contact.email.substringBefore('@').tolowercase() + value + userEmail;
            String alias = contact.email.substringBefore('@');

            newUser = new User(
                alias = alias.substring(0,2) + system.now().day() + system.now().second(),
                email = contact.ICB_Type__c == types.get(0) ? contact.email.substringBefore('@').tolowercase() + '@no-reply.com' : contact.email, 
                emailencodingkey = 'UTF-8',
                firstname = contact.firstName, 
                lastname = contact.lastname, 
                languagelocalekey = 'pt_BR', 
                localesidkey = 'pt_BR',
                contactId = contact.Id,
                timezonesidkey = 'America/Sao_Paulo', 
                Username =  userName,
                //CommunityNickname = contact.email.substringBefore('@').tolowercase(),
                CommunityNickname = contact.email,
                ProfileId = myProfile.Id,
                IsActive = true);
            newUser.setOptions(dmo); 
            
        } 
        catch (Exception e) 
        {
            system.debug(Label.ICB_ERROR_MESSAGE +  e.getMessage());
        } 
        System.debug('Exiting <create>' + newUser);
        return newUser;
    }
    
    /***********************************
    * Purpose: Define the permissionSet used based on the Contact that has been created.
    * It Considered the list of Users by the recordType, type of the User and the value of the community User 
    * Parameters: none
    * Returns: void
    ************************************/
    @future
    private static void definePermissionSetting() 
    {
        System.debug('Entering <definePermissionSetting>');

        Map<Id, String> mapPermission = new Map<Id, String>();
        /*List<PermissionSet> listPermission 	= [SELECT Id, Label 
                                              FROM PermissionSet 
                                              WHERE Label IN: permissions];*/
        Map<String,Id> mapLabelPermission = new Map<String, Id>();
        List<User> 			listUsuarios 	= [SELECT Id, 
                                               Contact.ICB_Type__c, 
                                               Contact.Name,
                                               Contact.ICB_Community_User__c,
                                               CreatedDate
                                               FROM User 
                                               WHERE Contact.RecordType.Name =: recorTypeName
                                               AND Contact.ICB_Community_User__c = true
                                               AND Contact.ICB_Type__c IN: (types)];
        
        try 
        { 
            
            List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();
           
            
            for(PermissionSet psMap : [SELECT Id, Label 
                                       FROM PermissionSet 
                                       WHERE Label IN: permissions]) 
            {
                mapPermission.put(psMap.id, psMap.Label);
                mapLabelPermission.put(psMap.Label, psMap.Id);
            }
                        
            Set<Id> setIdUserPermission = new Set<Id>();
            for(PermissionSetAssignment vPs : [SELECT Id, AssigneeId FROM PermissionSetAssignment 
                                               WHERE AssigneeId IN: listUsuarios 
                                               AND PermissionSetId IN: mapPermission.keySet()]) 
            {
                setIdUserPermission.add(vPs.AssigneeId);                
            }
            for(User myUsers : listUsuarios) 
            {
                if(!setIdUserPermission.contains(myUsers.Id))  {
                    if (myUsers.Contact.ICB_Type__c == types.get(0)) 
                    {                
                        psa.add(new PermissionSetAssignment(PermissionSetId = mapLabelPermission.get(permissions.get(0)), AssigneeId = myUsers.Id));
                        
                    } 
                    else if (myUsers.Contact.ICB_Type__c == types.get(1)) 
                    {
                        psa.add(new PermissionSetAssignment(PermissionSetId = mapLabelPermission.get(permissions.get(1)), AssigneeId = myUsers.Id));
                    }
                    else if(myUsers.Contact.ICB_Type__c == types.get(2))
                    {
                        psa.add(new PermissionSetAssignment(PermissionSetId = mapLabelPermission.get(permissions.get(2)), AssigneeId = myUsers.Id));   
                    }
                }
            }
            //Define the group for the User
            
            Database.upsert(psa);
            
            System.debug('Exiting <definePermissionSetting>' + psa);
        } 
        catch (Exception e) 
        {
            system.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
    }
    
    
    /***********************************
    * Purpose: Insert the User created on the PublicGroup
    * Parameters: none
    * Returns: void
    ************************************/
    @future
    private static void insertUserGroup() 
    {
         System.debug('Entering <insertUserGroup>');
        List<GroupMember> vListGroup = new List<GroupMember>();
        List<User> 		ListUserGroup 	= [SELECT Id, 
                                               Contact.ICB_Type__c, 
                                               Contact.Name,
                                               Contact.ICB_Community_User__c,
                                               CreatedDate
                                               FROM User 
                                               WHERE Contact.RecordType.Name =: recorTypeName
                                               AND Contact.ICB_Community_User__c = true
                                               AND Contact.ICB_Type__c IN: (types)];
      	Group groupId = [SELECT Name, Id FROM Group WHERE NAME =: ICB_ContactTypes__c.getValues('PublicGroup').Value__c];
        for(User vUser : ListUserGroup) {
        	GroupMember vGroupMember = new GroupMember(UserOrGroupId = vUser.Id, GroupId = groupId.Id);
            vListGroup.add(vGroupMember);
        }
	   insert(vListGroup);
        System.debug('Exiting <insertUserGroup>');
    }

    
    public void userCreation() 
    {
        system.debug('Entering <userCreation>');
        try {
            
            List<Contact> vContact = getContacts();
            if (vContact.size() > 0) {
                createNewUser(vContact);
            }
            
        }
        catch(Exception e) 
        {
            system.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
        system.debug('Exiting <userCreation>');
    }
    
    private static List<Contact> getContacts()
    {
       List<Contact> contato = [SELECT Id, FirstName,ICB_Community_User__c,ICB_Fail__c,
                                        ICB_Cause__c, LastName, Email, Name, ICB_Type__c,
                                        ICB_Status__c 
                                 FROM Contact 
                                 WHERE ICB_Type__c =: types 
                                 AND RecordTypeId IN: recordTypeId
                                 AND Email != NULL
                                 AND ICB_Community_User__c = false
                                 AND ICB_Fail__c = false];
        
        return contato;
    }
    
     /*******************************************************************
    Purpose: Update the cause field contact.
    Parameters: List<String>
    Returns: [Void]
    Throws [Exceptions]: [NONE]
	********************************************************************/

    public static void updateContact()
    {
        List<String> statusList = new List<String>{'Active','Fail'};
        listContact.addAll(getContacts());
        System.debug('Entering <updateContact><listContact>: ' + JSON.serializePretty(listContact));
        Map<String, Contact> mapContact = new Map<String,Contact>();
        Set<String> setEmail = new Set<String>();
        for(Contact cont : listContact)
        {
            mapContact.put(cont.Id, cont);
            if(setEmail.contains(cont.Email))
            {
                cont.ICB_Cause__c = Label.ICB_Email_Duplicated;
                cont.ICB_Fail__c = true;
                cont.ICB_Community_User__c = false;
                cont.ICB_Status__c = statusList.get(1);
            }
            else
            {
                cont.ICB_Status__c = statusList.get(0);
                cont.ICB_Community_User__c = true;
            }
            
            setEmail.add(cont.Email);
        }
        System.debug('Valor do setEmail: '+setEmail);
        for(User user : [Select Email,ContactId From User Where Email =: setEmail])
        {
            System.debug('Valor do user: '+user);
            for(String contId : mapContact.keySet())
            {
                System.debug('Valor do contId: '+contId);
                if(mapContact.get(contId).Email == user.Email)
                {
                    mapContact.get(contId).ICB_Cause__c = Label.ICB_Email_Duplicated;   
                    mapContact.get(contId).ICB_Community_User__c = false;
                    mapContact.get(contId).ICB_Fail__c = true;
                    mapContact.get(contId).ICB_Status__c = statusList.get(1);
                }
            }
        }
        System.debug('Valor do contato: '+listContact );
        Database.update(listContact,false);
        System.debug('Exiting <updateContact><listContact>: ' + JSON.serializePretty(listContact));
    }

     /*******************************************************************
    }
    Purpose: Return users for disabled.
    Parameters: [NONE]
    Returns: [Void]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    public void disabledUser()
    {
        List<Id> userIdList = new List<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        List<Contact> contactList = [SELECT Id, Email, ICB_Status__c 
                                    FROM Contact 
                                    WHERE ICB_Type__c =: types
                                    AND ICB_Status__c =: CONST_INACTIVE 
                                    AND RecordTypeId IN: recordTypeId
                                    AND Email != NULL
                                    AND ICB_Community_User__c = true
                                    AND ICB_Fail__c = false];
        
        for(User user : [Select Id,ContactId,IsPortalEnabled,IsActive from User Where ContactId IN: contactList])
        {
            for(Contact contact : contactList)
            {
                if((user.ContactId == contact.Id) && (contact.ICB_Status__c == 'Inactive'))
                {
                    userIdList.add(user.Id);
                    contactIdSet.add(contact.Id);
                }
            }
        }
        updateUser(userIdList);
        updateContactCommunity(contactIdSet);
    }
    /*******************************************************************
    Purpose: Disabled User partner community.
    Parameters: [NONE]
    Returns: [Void]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    @future
    private static void updateUser(List<Id> listIdUser)
    {
        List<User> userList = new List<User>();
        for(User user : [Select Id,IsPortalEnabled,IsActive from User Where Id IN: listIdUser])
        {
            user.IsPortalEnabled = false;
            user.IsActive = false;
            userList.add(user);
        }
        Database.update(userList);
    }
    /*******************************************************************
    Purpose: Disabled User partner community.
    Parameters: [NONE]
    Returns: [Void]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    @future
    private static void updateContactCommunity(Set<Id> listIdContact)
    {
        List<Contact> contactList = new List<Contact>();
        for(Contact con : [Select Id,ICB_Cause__c from Contact Where Id IN: listIdContact])
        {
            con.ICB_Cause__c = Label.ICB_Status_Inactive;
            contactList.add(con);
        }
        Database.update(contactList);
    }

}