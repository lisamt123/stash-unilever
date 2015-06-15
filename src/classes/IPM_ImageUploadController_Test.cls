/**
* IPM_ImageUploadController_Test : This Test class for IPM_ImageUploadController apex class
* @author 
*
*/

@isTest
public class IPM_ImageUploadController_Test
{    
    Static testMethod void imageUpload()
    {
        Test.startTest();
        
        Profile p=[Select Id from Profile where Name='System Administrator'];       
        
        //Insert User 
        User u= new User(Alias = 'uploadi', Email='uploadi@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Useriu', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='uploadi@test362.com');
        //insert u;  
        
        //Insert User 
        User u1= new User(Alias = 'testiu11', Email='standarduseriu1@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Useriu', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',isActive=true, 
        UserName='testuseriu1@test362.com');
        //insert u1;      
        
        //Insert Company Card
        IPM_Company_Card__c compCard=new IPM_Company_Card__c();
        //compCard.Name='Test Company Card';
        //insert compCard;
        
        //Insert User Profile
        IPM_User_Profile__c up=new IPM_User_Profile__c();
        //up.IPM_User__c=u.Id;
        //insert up;
        
        //Insert User Profile
        IPM_User_Profile__c up1=new IPM_User_Profile__c();
        //up1.IPM_User__c=u1.Id;
        //up1.IPM_Company_Card__c=compCard.Id;
        //insert up1;
        
        //System.runAs(u)
        //{ 
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
            
            PageReference pg = Page.IPM_ImageUpload;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put('Id', proj.id);
            ApexPages.CurrentPage().getparameters().put('isProject', 'true');
            IPM_ImageUploadController  imgCtrl=new IPM_ImageUploadController();
            imgCtrl.document.name='.jpg';   
            imgCtrl.upload();
            
            PageReference pg1 = Page.IPM_ImageUpload;
            Test.setCurrentPageReference(pg1);
            ApexPages.CurrentPage().getparameters().put('Id', boss.id);
            ApexPages.CurrentPage().getparameters().put('isProject', 'false');
            IPM_ImageUploadController  imgCtrl1=new IPM_ImageUploadController();
            imgCtrl1.document.name='.jpg';   
            imgCtrl1.upload();
        //}
        Test.stopTest();
    }
}