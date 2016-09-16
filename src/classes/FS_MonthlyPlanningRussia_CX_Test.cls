@isTest

/**********************************************************************
Name: FSMonthlyPlanningRussiaCX_Test
======================================================
======================================================
Purpose: Test class for Monthly Planning Russia controller class
-------
======================================================
======================================================
History
-------
VERSION AUTHOR     DATE        DETAIL Description
1.0     Dinesh 31/08/2016 INITIAL DEVELOPMENT 
***********************************************************************/

Public Class FS_MonthlyPlanningRussia_CX_Test
{
   public static testMethod void FS_MonthlyPlanningRussia_TestMethod()
    {
        String profile='System Administrator';
               
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'FS 59040 Sales Rep'];
        User SalesRepUserMgr = new User(Alias = 'newUser', Email='newuser1@testorg.com',
                                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
                                        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper1@testorg.com');
        insert SalesRepUserMgr;
        User SalesRepUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                     LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,ManagerId = SalesRepUserMgr.Id,
                                     TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        
        
        System.runAs(SalesRepUser)
        {
            Event varEvent=new Event();
            varEvent.ActivityDate=Date.newInstance(2016,09,20);
            varEvent.OwnerId=SalesRepUser.id;
            varEvent.EndDateTime=DateTime.newInstance(2016,09,20,0,0,0);
            varEvent.StartDateTime=DateTime.newInstance(2016,09,10,0,0,0);
            insert varEvent;
            }
            System.runAs(SalesRepUserMgr)
        {
            FS_MonthlyPlanningRussia_CX varMonthlyPlanningRussia=new FS_MonthlyPlanningRussia_CX();
            varMonthlyPlanningRussia.dateName=Date.newInstance(2016,09,22);
            varMonthlyPlanningRussia.refreshPage();
            varMonthlyPlanningRussia.getlistMonthlyPlanner();
           System.assert(varMonthlyPlanningRussia.dateName <> null);
        }
        
    }  
}