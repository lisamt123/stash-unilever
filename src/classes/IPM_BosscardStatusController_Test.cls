/**
* IPM_BosscardStatusController_Test : This Test class for IPM_BosscardStatusController apex class
* @author 
*
*/
@isTest
public class IPM_BosscardStatusController_Test
{    
    Static testMethod void bosscardStatus()
    {
        Test.startTest();
        //Insert Bosscard
        IPM_Bosscard__c boss=new IPM_Bosscard__c();
        boss.IPM_BosscardName__c='Test Boss';
        boss.IPM_Bosscard_Status__c='In Progress';
        insert boss;
        System.Assert(boss.Id != null, 'The Bosscard record not inserted');
        
        //Insert Project
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Project_Name__c='Test Boss';
        proj.IPM_Bosscard__c=boss.Id;
        insert proj;
        System.Assert(proj.Id != null, 'The project record not inserted');
        
        PageReference pg = Page.ipmBosscardStatus;
        Test.setCurrentPageReference(pg);
        ApexPages.CurrentPage().getparameters().put('Id', boss.id);
        IPM_BosscardStatusController bossCtrl=new IPM_BosscardStatusController();
        bossCtrl.updateStatus();
        Test.stopTest();
    }
    Static testMethod void bosscardStatus1()
    {
        Test.startTest();
        //Insert Bosscard
        IPM_Bosscard__c boss=new IPM_Bosscard__c();
        boss.IPM_BosscardName__c='Test Boss';
        boss.IPM_Bosscard_Status__c='Not Approved';
        insert boss;
        System.Assert(boss.Id != null, 'The Bosscard record not inserted');
        
        //Insert Project
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Project_Name__c='Test Boss';
        proj.IPM_Bosscard__c=boss.Id;
        insert proj;
        System.Assert(proj.Id != null, 'The project record not inserted');
        
        PageReference pg = Page.ipmBosscardStatus;
        Test.setCurrentPageReference(pg);
        ApexPages.CurrentPage().getparameters().put('Id', boss.id);
        IPM_BosscardStatusController bossCtrl=new IPM_BosscardStatusController();
        bossCtrl.updateStatus();
        Test.stopTest();
    }
    Static void bosscardStatus2()
    {
        Test.startTest();
        Profile p=[Select Id from Profile where Name='System Administrator'];       
        
        //Insert User 
        /*User u= new User(Alias = 'testbs', Email='standarduserbs@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Userps', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testuserbs@test362.com');
        insert u; */ 
        
        User u= new User(Alias = 'testbspecific', Email='standarduserspecific12@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='testbspecific', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testbspecific@testbspecific.com');
        //insert u; 
        
        //Insert User 
       /* User u1= new User(Alias = 'testbs1', Email='standarduserbs1@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Userps1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testuserbs1@test362.com');
        insert u1; */ 
        /* 
         User u1= new User(Alias = 'testbs11', Email='standarduserbs1@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Userps1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testuserbs1@test36211.com');
        //insert u1;
        */
        //Insert Company Card
        IPM_Company_Card__c compCard=new IPM_Company_Card__c();
        compCard.Name='Test Company Card';
        //insert compCard;
        
        //Insert User Profile
        IPM_User_Profile__c up=new IPM_User_Profile__c();
        up.IPM_User__c=u.Id;
        //insert up;
        
        /*
        //Insert User Profile
        IPM_User_Profile__c up1=new IPM_User_Profile__c();
        //up1.IPM_User__c=u1.Id;
        //up1.IPM_Company_Card__c=compCard.Id;
        //insert up1;
        */
        System.runAs(u)
        { 
            //Insert Bosscard
            IPM_Bosscard__c boss=new IPM_Bosscard__c();
            boss.IPM_BosscardName__c='Test Boss';
            boss.IPM_Bosscard_Status__c='Approved';
            insert boss;
            System.Assert(boss.Id != null, 'The Bosscard record not inserted');
            
            //Insert Project
            IPM_Project__c proj=new IPM_Project__c();
            proj.IPM_Project_Name__c='Test Boss';
            proj.IPM_Bosscard__c=boss.Id;
            insert proj;
            System.Assert(proj.Id != null, 'The project record not inserted');
            
            PageReference pg = Page.ipmBosscardStatus;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put('Id', boss.id);
            IPM_BosscardStatusController bossCtrl=new IPM_BosscardStatusController();
            try{
                bossCtrl.updateStatus();
                bossCtrl.checkApproved();
                bossCtrl.setStatus();
            }
            
            catch(Exception e){
            
            }
            
            
        }
        Test.stopTest();
    }
    Static testMethod void bosscardStatus3()
    {
        Test.startTest();
        //Insert Bosscard
        IPM_Bosscard__c boss=new IPM_Bosscard__c();
        boss.IPM_BosscardName__c='Test Boss';
        boss.IPM_Bosscard_Status__c='Discard';
        insert boss;
        System.Assert(boss.Id != null, 'The Bosscard record not inserted');
        
        //Insert Project
        IPM_Project__c proj=new IPM_Project__c();
        proj.IPM_Project_Name__c='Test Boss';
        proj.IPM_Bosscard__c=boss.Id;
        insert proj;
        System.Assert(proj.Id != null, 'The project record not inserted');
        
        PageReference pg = Page.ipmBosscardStatus;
        Test.setCurrentPageReference(pg);
        ApexPages.CurrentPage().getparameters().put('Id', boss.id);
        IPM_BosscardStatusController bossCtrl=new IPM_BosscardStatusController();
        bossCtrl.getStatusValue();
        bossCtrl.updateStatus();
        bossCtrl.checkApproved();
        Test.stopTest();
    }
}