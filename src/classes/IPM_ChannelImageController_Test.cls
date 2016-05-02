/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class to test IPM_ChannelImageController class functionalities
**/
@isTest
public class IPM_ChannelImageController_Test{
    private static User stdUserForChannelImage;
    private static Attachment atth;    
    private static IPM_Project_Document_Section_Content__c sectionContent;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();   
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project_Document_Section__c> sectionList = new List<IPM_Project_Document_Section__c>();
   
	private static Set<String> projectNameSet = new Set<String>{'TestComments1'};
    
    private static string EXCEPTION_OCCURED = 'Exception occured while saving document.';
    private static string RECORD_NOT_SAVED = 'Record not saved successfully.';
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : initializeData
    * @param : void
    * @return :void
    */
    @testSetup public static void initializeData()
    {
    	System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
    	{
    	    // user has to be created as system admin 
         	stdUserForChannelImage = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
       
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        IPM_TestFactory_Helper.getProjectMasterData();
         
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForChannelImage);
         
        System.runAs(stdUserForChannelImage)
        {
           insert projectList;
        }  
    }
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : testDataSetup
    * @param : void
    * @return :void
    */
    static testMethod void testDataSetup(){   	

		User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
		System.runAs(globalUser)
		{ 
			projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r)
            				  from IPM_Project__c 
            				  where Name in:projectNameSet];
            				  
			for(IPM_Project__c projectObj : projectListObj)
            {
                projDocList = projectObj.Project_Documents__r;                
                system.assertEquals(projDocList[0].IPM_GateDocuments__c,'Charter','Project Document created'); 

            }
            
            sectionList = [Select Id,IPM_Section_Name__c,IPM_Selected_Channel_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
			sectionList[0].IPM_Selected_Channel_Name__c ='Club';
			sectionList[0].IPM_Customer_Channel_Info__c ='ABC';
			update sectionList;			
			
			list<IPM_Project_Document_Section__c> checkSectionList=[Select Id,IPM_Section_Name__c,IPM_Selected_Channel_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where ID=:sectionList[0].Id];
           
            system.assertEquals(checkSectionList[0].IPM_Selected_Channel_Name__c, 'Club', RECORD_NOT_SAVED); 
            
	        
	        sectionContent = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
			sectionContent.IPM_Project_Document_Section__c = sectionList[0].Id;
			sectionContent.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
			sectionContent.IPM_Customer_Channels__c = 'Hypermarket';
			sectionContent.IPM_Customer_Channel_Priority__c = 1; 
			insert sectionContent;
	        
	        list<IPM_Project_Document_Section_Content__c> checkSectionContentList=[Select Id,IPM_Customer_Channel_Priority__c from IPM_Project_Document_Section_Content__c 
            where ID=:sectionContent.Id];
            
            system.assertEquals(checkSectionContentList[0].IPM_Customer_Channel_Priority__c, 1, RECORD_NOT_SAVED); 
	        atth=new Attachment();
	        Blob blbVal = Blob.valueof('abcd');
	        atth.name='abc.yuv';
	        atth.ParentId=sectionContent.Id;
	        atth.Body=blbVal;
	        insert atth;
	        Attachment attchObj=[select name from Attachment where id=:atth.Id];
	        system.assertEquals(attchObj.name,'abc.yuv',RECORD_NOT_SAVED);	        
	       
		}	
   
   }
    
    /*******************************************************************************************************
    * @description  Test Method to upload Attachment
    * @name : saveDocTest
    * @param : void
    * @return :void
    */
    public static testMethod void saveDocTest(){
    	User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
		System.runAs(globalUser){
			
            Test.startTest();
            testDataSetup();
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id', projectListObj[0].Id);
            pRef.getParameters().put('projDocSecId', sectionList[0].Id);            
            Test.setCurrentPage(pRef);
            IPM_ChannelImageController ipm_channelImageController=new IPM_ChannelImageController();
            pRef=ipm_channelImageController.Savedoc();
            System.assertEquals(ipm_channelImageController.myfile,Null,System.Label.IPM_CATCH_BLOCK_CALLED);
            
            ipm_channelImageController.myfile=atth;
            ipm_channelImageController.parentId=sectionContent.Id;
            ipm_channelImageController.channelType='nothing';
            pRef=ipm_channelImageController.Savedoc();
           
            ipm_channelImageController.parentId=sectionContent.Id;
            ipm_channelImageController.channelType=IPM_ConstantUtils.PREPOSITION_FIRST_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PREPOSITION_SECOND_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PROMOTION_FIRST_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PROMOTION_SECOND_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PRODUCT_FIRST_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PRODUCT_SECOND_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PACK_FIRST_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PACK_SECOND_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PRICE_FIRST_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PRICE_SECOND_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PLACE_FIRST_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            ipm_channelImageController.channelType=IPM_ConstantUtils.PLACE_SECOND_IMAGE;
            pRef=ipm_channelImageController.Savedoc();
            system.assert(ipm_channelImageController.isImageLoaded,EXCEPTION_OCCURED);
            
            atth=ipm_channelImageController.getmyFile();
            system.assertNotEquals(ipm_channelImageController.myfile, null,EXCEPTION_OCCURED);
            Test.stopTest();
        }
    }
    
    /*******************************************************************************************************
    * @description  Test Method totest negative Scenario
    * @name : negativeSaveDocTest
    * @param : void
    * @return :void
    */
     public static testMethod void negativeSaveDocTest(){
     	User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
		System.runAs(globalUser){
			
            Test.startTest();
            testDataSetup();
            PageReference pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id', projectListObj[0].Id);
            pRef.getParameters().put('projDocSecId', sectionList[0].Id);           
            Test.setCurrentPage(pRef);
            IPM_ChannelImageController ipm_channelImageController=new IPM_ChannelImageController();
            ipm_channelImageController.myfile=atth;
            ipm_channelImageController.channelType='nothing';
            pRef=ipm_channelImageController.Savedoc();
            system.assertNotEquals(ipm_channelImageController.isImageLoaded,true, EXCEPTION_OCCURED);
            Test.stopTest();
        }
     }
}