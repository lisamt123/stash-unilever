/*****************************************************************************************************************************
   @Author :Nandini KV
   @name : IPM_UploadBusinessCase_Test
   @CreateDate : 02/06/2015
   @Description : This is a test class for IPM_UploadBusinessCase Page, 
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/

@isTest
private class IPM_UploadBusinessCase_Test {
    private static User u1 = new User();
    private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    private static final String EMPTY_LIST = 'list empty';
/**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : testIPM_UploadBusinessCase
    *  @param : none
    *  @return : none
    *************************************************************************/  
    static testMethod void testIPM_UploadBusinessCase(){
         test.startTest(); 
        //Global     
            
            u1 = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            system.runAs(u1){
                projectList = IPM_TestFactory_Helper.insertIPMProjectList();
                system.assertEquals(projectList.isEmpty() , false, EMPTY_LIST);  
                IPM_UploadBusinessCase att1 = new IPM_UploadBusinessCase();
                att1.objAttachment = new attachment();
                Test.setCurrentPageReference(new PageReference('Page.myPage')); 
                System.currentPageReference().getParameters().put('parentId', projectList[0].id);
                Blob b = Blob.valueof('This is the file content to be attached.');
                att1.filebody = b;
                att1.filename = 'Att1';
                att1.saveBusinessCase();
                List<Attachment>attList=[SELECT ParentId FROM Attachment WHERE ParentId=:projectList[0].id LIMIT 1];
                system.assertEquals(attList.size(),1,'attachment got created');         
                          
                
                IPM_UploadBusinessCase att = new IPM_UploadBusinessCase();
                att.filebody = b;
                Test.setCurrentPageReference(new PageReference('Page.myPage')); 
                System.currentPageReference().getParameters().put('parentId', projectList[1].id);
                att.saveBusinessCase();
                List<Attachment>attsList=[SELECT ParentId FROM Attachment WHERE ParentId=:projectList[1].id LIMIT 1];
                system.assertEquals(attsList.size(),0,'attachment is not created');         
                 
            }
        test.stoptest();
        
    }
    
}