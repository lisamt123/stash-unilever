/**********************************************************************
Name: BEN_ApprovalProcess_Helper_test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Approval Process Helper clazz (BEN_ApprovalProcess_Webservice_helper) -------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
V1.0       Mahesh     12/01/2017     INITIAL DEVELOPMENT CSR:
***********************************************************************/

@Istest
public class BEN_ApprovalProcess_Helper_test {

     static User testUser;
    
     static {
       
        ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
        List<User> user = [Select Name, email, username from User where username = 'firstuserdb@test.com'];
        
        if(checkEmpty(user)){
            testUser = new User(username='firstuserdb100@test.com',
                                alias = 'fu',
                                email ='firstuser100@test.com',
                                emailencodingkey = 'UTF-8',
                                lastname = 'fuln',
                                CommunityNickname = 'fucn',
                                languagelocalekey = 'en_US',
                                localesidkey = 'en_US',                                            
                                profileid = adminProfileID,
                                timezonesidkey = 'Europe/Berlin',
                                country = 'India'
                               );
            insert testUser;
        }else
            testUser = user.get(0);
     }
    //test the Approval Process Helper CLazz method.
    static testmethod void testUserIsApprover(){
        
        String result = BEN_AprovalProcess_WebService_helper.userIsApprover(testUser.Id);
        System.assertEquals('false', result);
    }
    
     public static boolean checkEmpty(List<sObject> objs){
        
        if(objs == null){
            return true;
        }else if(objs.size()==0){
            return true;
        }else
            return false;
    }
}