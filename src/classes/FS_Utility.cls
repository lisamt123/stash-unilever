/**********************************************************************
Purpose: Utility class for Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    11/May/2016     Utility class of NAFS project
                     10/June/2016    Updated to add test user creation method  
***********************************************************************/

public Class FS_Utility{
    //Purpose: Used in Opportunity trigger to avoid recursion.Class NAFS_OpportunityHelper, update Opp with Opp Line Item Value
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    //Purpose: To create and return a test user as per the Profile and Permission provided in test class
    public static user CreateTestUser(String Profilename,String PermissionsetName) 
    {
            Profile p = [SELECT Id FROM Profile WHERE Name=:Profilename];
            Userrole role=[SELECT Id FROM UserRole WHERE Name = 'NAFS 54100 Sales Rep'];
            User testuser = new User(Alias = 'newUser', Email='newuser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
            TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
            insert testuser;
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:PermissionsetName];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = testuser.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        return testuser;
    }
}