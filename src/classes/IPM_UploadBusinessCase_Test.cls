/*****************************************************************************************************************************
   @Author :Nandini KV
   @name : IPM_UploadBusinessCase_Test
   @CreateDate : 02/06/2015
   @Description : This is a test class for IPM_UploadBusinessCase Page, 
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/

@isTest
public class IPM_UploadBusinessCase_Test {
    public static User u1 = new User();
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
/**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : testIPM_UploadBusinessCase
    *  @param : none
    *  @return : none
    *************************************************************************/  
    static testMethod void testIPM_UploadBusinessCase(){
         test.startTest(); 
        //Global     
            
            Profile p = [SELECT Id FROM Profile WHERE Name='IPM NG Basic']; 
            u1 = IPM_TestFactory_Helper.createUser(FALSE);
            u1 = new User(Alias = 'fin30', Email='finGrid0@testorg4.com', 
                          EmailEncodingKey='UTF-8', LastName='finGrid0', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='finGrid0@testorg4.com', 
                          IPM_Category__c = 'test4'  , IPM_Brand_Positioning__c= 'test4',IPM_Brand_Name__c ='test1',
                          IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
            insert u1;
             user uname = [select LastName from User where id=:u1.Id];
            
            system.assert(uname.LastName == 'finGrid0', 'User insert failed'); 
            system.runAs(u1){
                projectList = IPM_TestFactory_Helper.insertIPMProjectList();
                IPM_UploadBusinessCase att1 = new IPM_UploadBusinessCase();
                att1.objAttachment = new attachment();
                Test.setCurrentPageReference(new PageReference('Page.myPage')); 
                System.currentPageReference().getParameters().put('parentId', projectList[0].id);
                Blob b = Blob.valueof('This is the file content to be attached.');
                att1.filebody = b;
                att1.filename = 'Att1';
                att1.saveBusinessCase();
                
                IPM_UploadBusinessCase att = new IPM_UploadBusinessCase();
                att.filebody = b;
                Test.setCurrentPageReference(new PageReference('Page.myPage')); 
                System.currentPageReference().getParameters().put('parentId', projectList[0].id);
                att.saveBusinessCase();
            }
        test.stoptest();
        
    }
    
}