/**********************************************************************
 Name:  isll_UtilityTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test class for isll_Utility
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      08/08/2013      INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class isll_UtilityTest {

    static testMethod void moderatorSetIdsTest() {

    	PermissionSet permSet = [select id from PermissionSet where name = : isll_Utility.ModeratorPermissionSetName];

    	if(null == permSet){
    		permSet = new PermissionSet();
			permSet.name = isll_Utility.ModeratorPermissionSetName;
			insert permSet;
		}


    	List<PermissionSetAssignment> memberList = new List<PermissionSetAssignment>(); 
	   	List<User> users = new List<User>();
	    for(integer i = 0; i < 5; i++){
	    	User aUser = new User();
	    	aUser.Username= 'name.name@company.com'+i;
			aUser.Email = 'name.name@company.com';
			aUser.Lastname = 'name'+i;
			aUser.Firstname = 'name'+i;
			aUser.Alias = 'name'+i;
			aUser.CommunityNickname = 'name'+i;
			aUser.ProfileId = Userinfo.getProfileId();
			aUser.TimeZoneSidKey = 'GMT';
			aUser.LocaleSidKey = 'en_US';
			aUser.EmailEncodingKey = 'ISO-8859-1';
			aUser.LanguageLocaleKey = 'en_US';
			aUser.UserPermissionsMobileUser = false;
	    	users.add(aUser);
	    }
	    insert users;

	    for(User aUser : users){
	    	memberList.add(new PermissionSetAssignment (AssigneeID = aUser.id , PermissionSetId = permSet.id));
	    }
	    insert memberList;

       	system.assert(isll_Utility.moderatorSetIds.size() >= 5);
       	isll_Utility.isCurrentUserModerator();

    }

    static testMethod void adminSetIdsTest() {

    	PermissionSet permSet = [select id from PermissionSet where name = : isll_Utility.AdminPermissionSetName];

    	if(null == permSet){
    		permSet = new PermissionSet();
			permSet.name = isll_Utility.AdminPermissionSetName;
			insert permSet;
		}


    	List<PermissionSetAssignment> memberList = new List<PermissionSetAssignment>(); 
	   	List<User> users = new List<User>();
	    for(integer i = 0; i < 5; i++){
	    	User aUser = new User();
	    	aUser.Username= 'name.name@company.com'+i;
			aUser.Email = 'name.name@company.com';
			aUser.Lastname = 'name'+i;
			aUser.Firstname = 'name'+i;
			aUser.Alias = 'name'+i;
			aUser.CommunityNickname = 'name'+i;
			aUser.ProfileId = Userinfo.getProfileId();
			aUser.TimeZoneSidKey = 'GMT';
			aUser.LocaleSidKey = 'en_US';
			aUser.EmailEncodingKey = 'ISO-8859-1';
			aUser.LanguageLocaleKey = 'en_US';
			aUser.UserPermissionsMobileUser = false;
	    	users.add(aUser);
	    }
	    insert users;

	    for(User aUser : users){
	    	memberList.add(new PermissionSetAssignment (AssigneeID = aUser.id , PermissionSetId = permSet.id));
	    }
	    insert memberList;

       	system.assert(isll_Utility.adminSetIds.size() >= 5);
       	isll_Utility.isCurrentUserAdmin();

    }


}