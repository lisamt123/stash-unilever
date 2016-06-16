/********************************************************************** 
Name: DMS_Home_CC
Copyright © 2016 Salesforce 
====================================================== 
====================================================== 
Purpose: 
Controller with the logic configurations to the page DMS_CommunityHome
====================================================== 
====================================================== 
History 
------- 
VERSION	 	AUTHOR 		DATE 			DETAIL 					Description
1.0 		Carlos 		01/06/2015 		INITIAL DEVELOPMENT 	CSR: First Version
2.0			CARLOS HENRIQUE 16/06/2016  FIX CLASS.
***********************************************************************/

public with sharing class DMS_Home_CC {
    
    private User currentUser {get;set;}
    
    /******************************************************************* 
    Purpose: Constructor from this class. Responsible for the 
    settlement of the variables of this class.
    Throws [Exceptions]: [optional] 
	********************************************************************/
    public DMS_Home_CC(){
        currentUser = [SELECT name,smallphotourl,fullphotourl, ContactId FROM User where id =:UserInfo.getUserId()];
    }
    
    /******************************************************************* 
    Purpose: Return the current user. 
    Returns: User.
	********************************************************************/
    public User getCurrentUser(){
        return this.currentUser;
    }
    
}