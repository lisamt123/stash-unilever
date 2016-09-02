@isTest
Public Class FS_Monthly_Planning_Russia_CX_Test
{

public static testMethod void FS_CreateContact_CC_TestMethod()
{
String profile='System Administrator';
        String permissionset='FS_Sales_Rep';         
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
        
        
        System.runAs(SalesRepUserMgr)
        {
        Event varEvent=new Event();
        varEvent.ActivityDate=Date.newInstance(2016,09,20);
        varEvent.OwnerId=SalesRepUser.id;
        varEvent.EndDateTime=DateTime.newInstance(2016,09,23,0,0,0);
         varEvent.StartDateTime=DateTime.newInstance(2016,09,23,0,0,0);
        insert varEvent;
        
     FS_Monthly_Planning_Russia_CX varMonthlyPlanningRussia=new FS_Monthly_Planning_Russia_CX();
     varMonthlyPlanningRussia.dateName=Date.newInstance(2016,09,22);
        varMonthlyPlanningRussia.refreshPage();
        varMonthlyPlanningRussia.getlistMonthlyPlanner();
        List<Event> listEventquery=[select id,OwnerID from Event ];
        
         System.debug('SalesRepUserMgr'+SalesRepUserMgr.id);
         System.debug('SalesRepUser'+SalesRepUser.id);
         System.debug('listEventquery'+listEventquery);
       // System.debug('listRussiaUsers'+varMonthlyPlanningRussia.listRussiaUsers);
        // System.debug('listEvents'+varMonthlyPlanningRussia.listEvents);
        }
       
}


}