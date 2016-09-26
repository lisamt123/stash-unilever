/**********************************************************************  
Name:  Amr_CommonController_CC ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for redirection.                                                        
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  30/03/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/
public with sharing class Amr_CommonController_CC{
    
    public String UserLoginId{get;set;}
    
    public Amr_CommonController_CC(){
    }
    public PageReference EndSession(){
        UserLoginId = userinfo.getuserid();        
        User userObj = [select id,SessionId__c from User where id = :UserLoginId];
        userObj.SessionId__c = null;
        update userObj;
        
        PageReference pageRef1 = new PageReference(Label.Amr_Logout);
        pageRef1.setRedirect(true);
        return pageRef1;
    }
}