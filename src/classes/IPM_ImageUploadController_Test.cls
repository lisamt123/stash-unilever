/**
* IPM_ImageUploadController_Test : This Test class for IPM_ImageUploadController apex class
* @author 
*
*/

@isTest
private class IPM_ImageUploadController_Test
{    
     private static IPM_Bosscard__c bossCard;
     private static IPM_Project__c project;
     private static User plUser = new User();
     private static User readUser = new User();
     private static IPM_ImageUploadController imgCtrl; 
     private static final String PLATFORM_USER = 'PLATFORM_USER';
    
    /*************************************************
     * @Description: Test data initilaization
     * ***********************************************/
    @testSetup static void initializeData(){
        //Insert User as project leader with permission set
        plUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        
        List<User>userList=[SELECT lastName FROM user WHERE id=:plUser.id LIMIT 1];
        System.AssertEquals(userList[0].lastName, plUser.lastName,'user lastName is mismatch :'+userList[0].lastName);//positive test
         
        //run as project leader
        system.runAs(plUser){
            //Insert Bosscard
            bossCard = IPM_TestFactory_Helper.createIPMBosscard(FALSE);
            bossCard.IPM_BosscardName__c='Test bossCard';
            bossCard.IPM_Bosscard_Status__c=IPM_ConstantUtils.STATUS_IN_PROGRESS;
            insert bossCard;
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:bossCard.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS, 'Bosscard status is mismatch :'+bossList[0].IPM_Bosscard_Status__c); //Positive test
            
            
            //Insert Project
            project= IPM_TestFactory_Helper.createIPMProject(FALSE); 
            project.IPM_Project_Name__c='Test bossCard';
            project.IPM_Bosscard__c=bossCard.Id;
            project.IPM_Project_Leader__c=plUser.id;
            insert project;
            List<IPM_Project__c>projList=[SELECT IPM_Bosscard__c FROM IPM_Project__c WHERE id=:project.id LIMIT 1];
            System.AssertEquals(projList[0].IPM_Bosscard__c,bossCard.Id, 'Bosscard id is mismatch :'+projList[0].IPM_Bosscard__c); //Positive test

        }
            
    }
    
    
    /*************************************************
     * @Description: Test invoke imageUpload for project
     * ***********************************************/
    static testMethod void testImageUploadProject(){ 
        
        plUser=[SELECT lastName FROM user WHERE lastName=:PLATFORM_USER LIMIT 1];
        System.AssertEquals(plUser.lastName, PLATFORM_USER,'user lastName is not a Platform User:'+plUser.lastName);//positive test
        test.startTest();
        system.runAs(plUser)
        {  
           
            bossCard = [SELECT Id FROM IPM_Bosscard__c LIMIT 1];
            project = [SELECT Id FROM IPM_Project__c WHERE IPM_Bosscard__c=:bossCard.id  LIMIT 1];
            
             //upload project logo
            PageReference pg = Page.IPM_ImageUpload;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, project.id);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_IMGUPLOAD_ISPROJECT, IPM_ConstantUtils.IPM_IMGUPLOAD_TRUE);
            
            imgCtrl=new IPM_ImageUploadController();
            imgCtrl.document.name='Image.jpg'; 
            
            imgCtrl.document.body=Blob.valueof('test');
            imgCtrl.project=IPM_ConstantUtils.IPM_IMGUPLOAD_TRUE;
            imgCtrl.projectId=project.id;
            imgCtrl.isValid=true;
            imgCtrl.upload();
            List<IPM_Project__c>projList=[SELECT IPM_Project_Logo_Id__c FROM IPM_Project__c WHERE id=:project.id LIMIT 1];
            System.AssertEquals(projList[0].IPM_Project_Logo_Id__c,imgCtrl.projects.IPM_Project_Logo_Id__c, 'Project logo insertion fails'+projList[0].IPM_Project_Logo_Id__c); //Positive test
            
            //upload invalid image        
            imgCtrl.document.name='InvalidImage';
            imgCtrl.isValid=true;
            imgCtrl.upload();
            List<IPM_Project__c>projLists=[SELECT IPM_Project_Logo_Id__c FROM IPM_Project__c WHERE id=:project.id LIMIT 1];
            System.AssertEquals(projLists[0].IPM_Project_Logo_Id__c,projList[0].IPM_Project_Logo_Id__c, 'Project logo insertion fails'+projLists[0].IPM_Project_Logo_Id__c); //Negative test
            
        } 
        test.stopTest();  
        
    }
    /*************************************************
     * @Description: Test invoke imageUpload for bosscard
     * ***********************************************/
    static testMethod void testImageUploadBosscard(){ 
        
        plUser=[SELECT lastName FROM user WHERE lastName=:PLATFORM_USER LIMIT 1];
        System.AssertEquals(plUser.lastName, PLATFORM_USER,'user lastName is not a Platform User:'+plUser.lastName);//positive test
        
        readUser= IPM_TestFactory_Helper.createUser(false);
        insert readUser;
        List<User>userLists=[SELECT lastName FROM user WHERE id=:readUser.id LIMIT 1];
        System.AssertEquals(userLists[0].lastName, readUser.lastName,'user lastName is mismatch :'+userLists[0].lastName);//positive test
        
        test.startTest();
        system.runAs(plUser)
        {  
            bossCard = [SELECT Id FROM IPM_Bosscard__c LIMIT 1];
            project = [SELECT Id FROM IPM_Project__c WHERE IPM_Bosscard__c=:bossCard.id  LIMIT 1];
            PageReference pg = Page.IPM_ImageUpload;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, project.id);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_IMGUPLOAD_ISPROJECT, IPM_ConstantUtils.IPM_IMGUPLOAD_TRUE);
            
            imgCtrl=new IPM_ImageUploadController();
            imgCtrl.document.name='Images.jpg'; 
            
            imgCtrl.document.body=Blob.valueof('testing');
            imgCtrl.project='false';
            imgCtrl.projectId=bossCard.id;
            imgCtrl.isValid=true;
            imgCtrl.upload();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Logo_Id__c FROM IPM_Bosscard__c WHERE id=:imgCtrl.projectId LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Bosscard_Logo_Id__c,imgCtrl.bosscard.IPM_Bosscard_Logo_Id__c, 'bosscard logo insertion fails'+bossList[0].IPM_Bosscard_Logo_Id__c); //Positive test
            
            
        } 
        //no access current user but trying to update
        system.runAs(readUser)
        {  
            PageReference pg = Page.IPM_ImageUpload;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, project.id);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_IMGUPLOAD_ISPROJECT, IPM_ConstantUtils.IPM_IMGUPLOAD_TRUE);
            
            imgCtrl=new IPM_ImageUploadController();
            
            imgCtrl.document.name='ProImages.jpg'; 
            
            imgCtrl.document.body=Blob.valueof('Invalid testing');
            imgCtrl.project='false';
            imgCtrl.projectId=bossCard.id;
            imgCtrl.upload();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Logo_Id__c FROM IPM_Bosscard__c WHERE id=:bossCard.id LIMIT 1];
            System.AssertEquals(bossList.isEmpty(),true, 'no access to current user'); //Negative test
            
            
        } 
        test.stopTest();  
        
    }
    
}