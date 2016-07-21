@isTest
private class CEC_OCWidgetRedirectControllerTest {
    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
       //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'CEC Global Head'];
        //System.debug('Role' + r.name);
        User u = new User(LastName = 'Testing', 
                             Username = 'cectestuser@test00DE0000000bbLj.org', 
                             Email = 'cectestuser@test00DE0000000bbLj.org', 
                             Alias = 'utest', 
                             TimeZoneSidKey = 'Europe/London', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'UTF-8', 
                             ProfileId = p.Id, 
                             LanguageLocaleKey = 'en_US',
                             UserPermissionsKnowledgeUser = true);  
                             
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            
            psalist.add(psa);
        
        }
        
        insert psalist;
        
        Group GR = [SELECT Id,name FROM Group WHERE Name = 'CEC - Knowledge Manager'];
        GroupMember GM = new GroupMember();
        GM.GroupId = GR.id;
        GM.UserOrGroupId = u.Id;
        insert GM;
        
        return u;
    
    }
    @isTest static void test_method_one() {
    Test.startTest(); 
        User u = insertUser();
        
         System.runAs(u)
         {
        CEC_OCWidgetRedirectController widgetController = new CEC_OCWidgetRedirectController();
        String widgetRedirectURL = widgetController.widgetRedirect().getURL();
        System.assertEquals('/apex/th1__widget_main',widgetRedirectURL);
    
    Test.stopTest();
}
}
}