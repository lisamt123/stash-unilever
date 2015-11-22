/**
* IPM_ImageUploadController_Test : This Test class for IPM_ImageUploadController apex class
* @author 
*
*/

@isTest
public class IPM_ImageUploadController_Test
{    
     private static IPM_Bosscard__c boss;
     private static IPM_Project__c proj;
     private static User plUser = new User();
     private static User readUser = new User();
     private static IPM_ImageUploadController imgCtrl; 
     
    
    /*************************************************
     * @Description: Test data initilaization
     * ***********************************************/
    static void initializeData(){
        //Insert User as project leader with permission set
        plUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        
        List<User>userList=[SELECT lastName FROM user WHERE id=:plUser.id LIMIT 1];
    	System.AssertEquals(userList[0].lastName, plUser.lastName,'user lastName is:'+userList[0].lastName);//positive test
    	
    	readUser= IPM_TestFactory_Helper.createUser(false);
        insert readUser;
        List<User>userLists=[SELECT lastName FROM user WHERE id=:readUser.id LIMIT 1];
    	System.AssertEquals(userLists[0].lastName, readUser.lastName,'user lastName is:'+userLists[0].lastName);//positive test
    	
    	 
        //run as project leader
        system.runAs(plUser){
    	 	//Insert Bosscard
            boss = IPM_TestFactory_Helper.createIPMBosscard(FALSE);
            boss.IPM_BosscardName__c='Test Boss';
            boss.IPM_Bosscard_Status__c=IPM_ConstantUtils.STATUS_IN_PROGRESS;
            insert boss;
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
        	System.AssertEquals(bossList[0].IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS, 'Bosscard status is:'+bossList[0].IPM_Bosscard_Status__c); //Positive test
       		
       		
       		//Insert Project
            proj= IPM_TestFactory_Helper.createIPMProject(FALSE); 
            proj.IPM_Project_Name__c='Test Boss';
            proj.IPM_Bosscard__c=boss.Id;
            proj.IPM_Project_Leader__c=plUser.id;
            insert proj;
            List<IPM_Project__c>projList=[SELECT IPM_Bosscard__c FROM IPM_Project__c WHERE id=:proj.id LIMIT 1];
        	System.AssertEquals(projList[0].IPM_Bosscard__c,boss.Id, 'Bosscard id is:'+projList[0].IPM_Bosscard__c); //Positive test
            
            PageReference pg = Page.IPM_ImageUpload;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, proj.id);
            ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.IPM_IMGUPLOAD_ISPROJECT, IPM_ConstantUtils.IPM_IMGUPLOAD_TRUE);
            imgCtrl=new IPM_ImageUploadController();
            
           
	 	}
            
    }
    
    
    /*************************************************
     * @Description: Test invoke imageUpload for project
     * ***********************************************/
    static testMethod void testImageUploadProject(){ 
        
        initializeData();
        test.startTest();
        system.runAs(plUser)
        {  
            //upload project logo
            imgCtrl.document.name='Image.jpg'; 
            imgCtrl.isError = true;
            imgCtrl.document.body=Blob.valueof('test');
            imgCtrl.project=IPM_ConstantUtils.IPM_IMGUPLOAD_TRUE;
            imgCtrl.projectId=proj.id;
            imgCtrl.upload();
            List<IPM_Project__c>projList=[SELECT IPM_Project_Logo_Id__c FROM IPM_Project__c WHERE id=:proj.id LIMIT 1];
        	System.AssertEquals(projList[0].IPM_Project_Logo_Id__c,imgCtrl.imgid, 'Project logo should be inserted'+projList[0].IPM_Project_Logo_Id__c); //Positive test
			
			//upload invalid image        
        	imgCtrl.document.name='InvalidImage';
            imgCtrl.isError = false;
            imgCtrl.upload();
            List<IPM_Project__c>projLists=[SELECT IPM_Project_Logo_Id__c FROM IPM_Project__c WHERE id=:proj.id LIMIT 1];
        	System.AssertEquals(projLists[0].IPM_Project_Logo_Id__c,projList[0].IPM_Project_Logo_Id__c, 'Project logo should be inserted'+projLists[0].IPM_Project_Logo_Id__c); //Negative test
			 
            
            
        } 
        test.stopTest();  
        
    }
    /*************************************************
     * @Description: Test invoke imageUpload for bosscard
     * ***********************************************/
    static testMethod void testImageUploadBosscard(){ 
        
        initializeData();
        test.startTest();
        system.runAs(plUser)
        {  
            imgCtrl.document.name='Images.jpg'; 
            imgCtrl.isError = true;
            imgCtrl.document.body=Blob.valueof('testing');
            imgCtrl.project='false';
            imgCtrl.projectId=boss.id;
            imgCtrl.upload();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Logo_Id__c FROM IPM_Bosscard__c WHERE id=:boss.id LIMIT 1];
        	System.AssertEquals(bossList[0].IPM_Bosscard_Logo_Id__c,imgCtrl.imgid, 'bosscard logo should be inserted'+bossList[0].IPM_Bosscard_Logo_Id__c); //Positive test
        	
        	
        } 
        //no access current user but trying to update
        system.runAs(readUser)
        {  
            imgCtrl.document.name='ProImages.jpg'; 
            imgCtrl.isError = true;
            imgCtrl.document.body=Blob.valueof('Invalid testing');
            imgCtrl.project='false';
            imgCtrl.projectId=boss.id;
            imgCtrl.upload();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Logo_Id__c FROM IPM_Bosscard__c WHERE id=:boss.id LIMIT 1];
        	System.AssertEquals(bossList.isEmpty(),true, 'no access to current user'); //Negative test
        	
        	
        } 
        test.stopTest();  
        
    }
    
}