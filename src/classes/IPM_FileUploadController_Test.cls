/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FileUploadController class 
*/
@isTest
public class IPM_FileUploadController_Test
{    
    /*******************************************************************************************************
    * @description	Test Method to IPM_FileUploadController methods
    */
    Static testMethod void testImageUpload()
    {
        
        
       	user loginUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER); 
        
        List<User>userLists=[SELECT lastname FROM user WHERE id=:loginUser.id LIMIT 1];
        System.AssertEquals(userLists[0].lastname, loginUser.lastname,'your user lastname is:'+userLists[0].lastname);//positive test
       
        system.runAs(loginUser){
	        //Insert Bosscard
	        IPM_Bosscard__c boss= IPM_TestFactory_Helper.createIPMBosscard(FALSE);
	        boss.IPM_BosscardName__c='Test Boss';
	        boss.IPM_Bosscard_Status__c='In Progress';
	        insert boss;
	        List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
		    System.AssertEquals(bossList[0].IPM_Bosscard_Status__c,boss.IPM_Bosscard_Status__c, 'Bosscard status is:'+bossList[0].IPM_Bosscard_Status__c); //Positive test
	       
	        
	        //Insert Project
	        //IPM_Project__c proj=new IPM_Project__c(); 
	        IPM_Project__c proj = IPM_TestFactory_Helper.createIPMProject(FALSE);
	        proj.IPM_Project_Name__c='TestProjectName';
	        proj.IPM_Bosscard__c=boss.Id;
	        insert proj;
	        ID projetId=proj.id;
	        List<IPM_Project__c>projectList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE ID=:proj.id LIMIT 1];
		    System.AssertEquals(projectList[0].IPM_Project_Name__c,proj.IPM_Project_Name__c, 'Project name is:'+projectList[0].IPM_Project_Name__c); //Positive test
	    
		    PageReference pg = Page.IPM_FileUpload;
	        Test.setCurrentPageReference(pg);
	        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, proj.id);
	        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID, proj.id);
	        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_SECTION_TYPE, 'test type');
		        
		    IPM_FileUploadController imgCtrl=new IPM_FileUploadController();
        	
        	Test.startTest();
        	
        	imgCtrl.Savedoc(); 
       		List<Attachment>attachmentLists=[SELECT Parentid FROM Attachment WHERE CreatedById =:loginUser.id LIMIT 1];
        	System.AssertEquals(attachmentLists.isEmpty(),true,'attachment name should not be null'); //Negative test
       		
        	imgCtrl.myfiles.Name='image.JPG';
       		imgCtrl.myfiles.body=Blob.valueof('test');
        	imgCtrl.Savedoc();
        	List<Attachment>attachmentList=[SELECT Parentid FROM Attachment WHERE Parentid =:proj.id LIMIT 1];
        	System.AssertEquals(attachmentList[0].Parentid,projetId, 'Parent id is:'+attachmentList[0].Parentid); //Positive test
       		
       		Test.stopTest();
       		 
        }
        
    }
}