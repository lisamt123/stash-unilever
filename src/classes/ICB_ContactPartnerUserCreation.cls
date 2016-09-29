/**********************************************************************
Name: ICB_ContactParnerUserCreation
Copyright © 2016 Unilever

Purpose: Class to create Community Users when new contacts are created.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  25/08/2016  INITIAL DEVELOPMENT.
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
    
    //private static List<User> listUser;
    
    public static final ICB_ContactPartnerUserCreation instance = new ICB_ContactPartnerUserCreation();
    
    public ICB_ContactPartnerUserCreation() 
    {
        
    }
    
    static 
    {
       permissions 			= new List<String> { ICB_ContactTypes__c.getValues('Permission_Salesman').Value__c, ICB_ContactTypes__c.getValues('Permission_Operator').Value__c};
       types 				= new List<String> { ICB_ContactTypes__c.getValues('Type_Salesman').Value__c, ICB_ContactTypes__c.getValues('Type_Operator').Value__c };
       recordTypeId 		= new List<String> {Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Ice Cream Operator').getRecordTypeId(), Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Ice Cream Salesman').getRecordTypeId()};
       userEmail 			= ICB_ContactTypes__c.getValues('User_Email').Value__c;
       profileCommunity 	= ICB_ContactTypes__c.getValues('Profile_Community').Value__c;
       recorTypeName		= new List<String> { 'Ice Cream Operator', 'Ice Cream Salesman'};
       myProfile 			= [SELECT id FROM Profile WHERE name =: profileCommunity];
      /* listUser 			= [SELECT Id, 
                                   Contact.ICB_Type__c, 
                                   Contact.Name,
                                   Contact.ICB_Community_User__c,
                                   CreatedDate
                                   FROM User 
                                   WHERE Contact.RecordType.Name =: recorTypeName
                                   AND Contact.ICB_Community_User__c = false
                                   AND Contact.ICB_Type__c IN: (types)];*/
        
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
            
            Database.SaveResult[] save =  Database.insert(users,false); 
            
            definePermissionSetting();
        }  
        catch (Exception e)
        {
            system.debug(Label.ICB_ERROR_MESSAGE +  e.getCause());
        }  
        System.debug('Exiting <createNewUser>');
    }
    
    /****************
    * Purpose: Create new User when contacts updated with an Email.
    * Parameters: oldTrigger & newTrigger values
    * Returns: none 
    ***************/
    /*public void updateUser(List<Contact> contactOld, List<Contact> contactNew) 
    {
    System.debug('Entering <updateUser>' + contactOld);
    System.debug('Entering <updateUser>' + contactNew);
    List<User> users = new List<User>();
    try {
    
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
    system.debug(Label.ICB_ERROR_MESSAGE +  e.getMessage());
    } 
    System.debug('Exiting <updateUser>');
    } */
    
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
                CommunityNickname = contact.email.substringBefore('@').tolowercase(),
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
                                               AND Contact.ICB_Community_User__c = false
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
                }
            }
            //Define the group for the User
            insertUserGroup();
            Database.upsert(psa);
            
            updateContact();
            System.debug('Exiting <definePermissionSetting>' + psa);
        } 
        catch (Exception e) 
        {
            system.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
       /*  Datetime tempo = system.now().addHours(1);
              System.schedule('Processa New Contact ' +
                            system.now().format('yyyy.MM.dd.hh.mm.ss.SSS'), tempo.second() +' '+ tempo.minute() +' '+ tempo.hour() +' '+ tempo.day() +' '+ tempo.month() +' ? '+ tempo.year(), new ICB_PartnerUserCreation_BatchSchedule());*/
        
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
                                               AND Contact.ICB_Community_User__c = false
                                               AND Contact.ICB_Type__c IN: (types)];
       // system.debug('VALOR DO GRUPO: ' + ICB_ContactTypes__c.getValues('PublicGroup').Value__c);
    	Group groupId = [SELECT Name, Id FROM Group WHERE NAME =: ICB_ContactTypes__c.getValues('PublicGroup').Value__c];
        for(User vUser : ListUserGroup) {
        	GroupMember vGroupMember = new GroupMember(UserOrGroupId = vUser.Id, GroupId = groupId.Id);
            vListGroup.add(vGroupMember);
        }
	    
        insert(vListGroup);
        System.debug('Exiting <insertUserGroup>');
    }
    
     
    /***********************************
    * Purpose: Insert the User created on the PublicGroup
    * Parameters: none
    * Returns: void
    ************************************/
    @future
    private static void updateContact() 
    {
        List<Contact> updateContact = new List<Contact>();
        
        for(Contact valueNew : getContacts())
        {
            valueNew.ICB_Community_User__c = true;
            updateContact.add(valueNew);
        }
        Database.upsert(updateContact);
    }
    
    public void userCreation() 
    {
        system.debug('Entering <userCreation>');
        try {
            
            List<Contact> vContact = getContacts();
            
            if (vContact.size() > 0) {
                createNewUser(vContact);
            }
            
        } catch(Exception e) 
            
        {
            system.debug(Label.ICB_ERROR_MESSAGE + e.getMessage());
        }
        system.debug('Exiting <userCreation>');
    }
    
    private static List<Contact> getContacts()
    {
        List<Contact> contato = [SELECT Id, FirstName, LastName, Email, Name, ICB_Type__c 
                                 FROM Contact 
                                 WHERE ICB_Type__c =: types 
                                 AND RecordTypeId IN: recordTypeId
                                 AND Email != NULL
                                 AND ICB_Community_User__c = false];
        
        return contato;
    }
    
}