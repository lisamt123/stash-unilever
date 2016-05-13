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
    public static final String EMPTY_LIST = 'list empty';
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
                          
                
                IPM_UploadBusinessCase att = new IPM_UploadBusinessCase();
                att.filebody = b;
                Test.setCurrentPageReference(new PageReference('Page.myPage')); 
                System.currentPageReference().getParameters().put('parentId', projectList[0].id);
                att.saveBusinessCase();
            }
        test.stoptest();
        
    }
    
}