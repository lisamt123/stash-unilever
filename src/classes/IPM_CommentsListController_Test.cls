/**************************************************************************************************************************
* @Author: Cognizant
* @Created Date:12/03/2015
* @Description :Test Class for Comments List Controller in Gate Document
*/

/*****************************************************************************************
    Please Note: 1)IPM_CommentsListController is used for IPM_CommentsPage to add comment for a project document section 1 at a time. 
                   So bulk test scenarios are not required to test the functionality. 
                 2)Testing with a Non System Admin user, gives an error related to Implementation restriction, hence have tested with Sys Admin only.
                   (This is salesforce known limitation:- While querying feeditem in the test class with non system admin context,
                    'Implementation restriction' error comes for which id should be specified in SOQL filter, which can not be done as it will affect business functionality.)   
******************************************************************************************/
    
    
@isTest
private class IPM_CommentsListController_Test {
    private static IPM_Project__c project;
    private static IPM_Project_Document__c projDoc;
    private static IPM_Project_Document_Section__c projDocSec;
    private static FeedItem insertFeed;
    private static final String PAGE_REFERENCE_STR='apex/IPMCommentsPage?id=';
    private static final String COUNT_COMMENTS='Count of Comments Should be Greater than Zero';
    private static final String TEXT_STR='TextPost';
    private static final String TEST_DATA='This is comment Test';
    private static final String FEEDITEM_INSERTED='FeedItem Inserted';
    private static final String FEEDITEM_DELETED='FeedItem Deleted';
    private static Integer countOfCommnts;
    private static IPM_Project_Document_Section__c projectDocumentSection;
    
    private static final String IDEA_GRAPHIC= 'Idea / Graphic';
    
    /**************************************************************************************************************************
    * @Description: Initializing Test Data
    */
    @testSetup static void initializeData(){
        //Creation test user
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        insert project;
        System.assert(project!=null);

        projDoc=IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        projDoc.IPM_GateDocuments__c=IPM_ConstantUtils.CHARTER_GATE; 
        projDoc.IPM_Project__c=project.ID;
        insert projDoc;
        System.assertEquals(projDoc.IPM_Project__c, project.Id);

        projDocSec=IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        insert projDocSec;
       List<IPM_Project_Document_Section__c>secData=[select Id,IPM_Project_Document__c from IPM_Project_Document_Section__c 
                                                     where Id=:projDocSec.Id Limit 1];
        System.assertEquals(secData[0].IPM_Project_Document__c, projDoc.Id, 'Record Mismatch');
        
        insertFeed=new FeedItem();
        insertFeed.Body=TEST_DATA;
        insertFeed.ParentId=''+projDocSec.id; 
        insertFeed.Type=TEXT_STR;
        insert insertFeed;
        System.assertNotEquals(insertFeed,null,'record properly inserted');
    }
    
    /**************************************************************************************************************************
    * @Description: Running Test Method
    */
    static testMethod void testComments(){
        
        test.startTest(); 
        List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Section_Name__c from IPM_Project_Document_Section__c 
                                                       where IPM_Section_Name__c=:IDEA_GRAPHIC Limit 1]; 
        PageReference pRef = new PageReference(PAGE_REFERENCE_STR+secList[0].ID);
        Test.setCurrentPage(pRef);
        IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
        
        List<FeedItem> testcomments=[SELECT id, body,CreatedBy.name,CreatedDate,ParentId,InsertedById 
                                  FROM FeedItem 
                                  WHERE ParentId =: ipmComments.parentID 
                                  AND type =:IPM_ConstantUtils.COMMENT_TYPE 
                                  LIMIT 5 OFFSET :0];
        system.assertEquals(ipmComments.listComments.size(),testComments.size(),'Records Size not Matching');
        test.stopTest();
    }
    
    /**************************************************************************************************************************
    * @Description: Running Test Method
    */
    static testMethod void testAddComments(){
        
        test.startTest();    
        List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Section_Name__c from IPM_Project_Document_Section__c 
                                                       where IPM_Section_Name__c=:IDEA_GRAPHIC Limit 1]; 
        PageReference pRef = new PageReference(PAGE_REFERENCE_STR+secList[0].ID);
        Test.setCurrentPage(pRef);
        IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
        ipmComments.CommentRecord.ParentId=secList[0].id;
        ipmComments.CommentRecord.Body=IPM_ConstantUtils.TEST_STR;
        ipmComments.CommentRecord.Type=TEXT_STR;
        ipmComments.AddComment();
        
        countOfCommnts = [Select Count() from FeedItem where ParentId =: ipmComments.parentID and type =:IPM_ConstantUtils.COMMENT_TYPE];
        System.assertNotEquals(countOfCommnts,0,COUNT_COMMENTS);
        
        projectDocumentSection=[SELECT Id,IPM_Count_of_Comments__c FROM IPM_Project_Document_Section__c WHERE Id=:ipmComments.parentID];
        system.assertEquals(projectDocumentSection.IPM_Count_of_Comments__c,countOfCommnts, 'Counts Not Matched');
        test.stopTest(); 
    }
    
    /**************************************************************************************************************************
    * @Description: Running Test Method
    */
    static testMethod void testDeleteComments(){
        
        test.startTest();    
        List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Section_Name__c from IPM_Project_Document_Section__c 
                                                       where IPM_Section_Name__c=:IDEA_GRAPHIC Limit 1]; 
        List<FeedItem>feedItemList=[select Id,Type from FeedItem where Type=:TEXT_STR Limit 1];
        PageReference pRef = new PageReference(PAGE_REFERENCE_STR+secList[0].ID);
        Test.setCurrentPage(pRef);
        IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
        ipmComments.ParentID=secList[0].id;
        ipmComments.CommentsID=feedItemList[0].Id;
        countOfCommnts = [Select Count() from FeedItem where ParentId =: ipmComments.parentID and type =:IPM_ConstantUtils.COMMENT_TYPE];
        system.assertEquals(countOfCommnts,1,FEEDITEM_INSERTED);
        
        ipmComments.doDelete();
        countOfCommnts = [Select Count() from FeedItem where ParentId =: ipmComments.parentID and type =:IPM_ConstantUtils.COMMENT_TYPE];
        system.assertEquals(countOfCommnts,0,FEEDITEM_DELETED);
        
        test.stopTest(); 
    }
    
    /**************************************************************************************************************************
    * @Description: test exception handling
    */
    static testMethod void testAddCommentsExceptions(){
        
        test.startTest();    
       List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Section_Name__c from IPM_Project_Document_Section__c 
                                                       where IPM_Section_Name__c=:IDEA_GRAPHIC Limit 1]; 
        PageReference pRef = new PageReference(PAGE_REFERENCE_STR+secList[0].ID);
        Test.setCurrentPage(pRef);
        IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
       String sample = IPM_ConstantUtils.TEST_STR;
 
        String newSample = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
        for (Integer i = 0; i < 6000; i ++) {
                newSample += sample;
        }
        ipmComments.CommentRecord.Body=newSample;
        ipmComments.CommentRecord.Type=IPM_ConstantUtils.TEST_STR;
        ipmComments.AddComment();
        for(ApexPages.Message msg : ApexPages.getMessages()) {
        System.assertEquals(msg.getSummary(), System.Label.IPM_Data_Value_Too_Large,System.Label.IPM_Data_Value_Too_Large);
        }
        test.stopTest();
     
    }
}