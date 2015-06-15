@isTest
public class IPM_CommentsListController_Test {
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static FeedItem insertFeed;
    
    static testMethod void initializeData()
    {
               project=new IPM_Project__c();
               project.Name='TestComments';
               
               project.IPM_Phase__c='Ideas';
               insert project;
               projDoc=new IPM_Project_Document__c();
               projDoc.IPM_GateDocuments__c='Charter'; 
               projDoc.IPM_Project__c=project.ID;
               insert projDoc;
               projDocSec=new IPM_Project_Document_Section__c();
               projDocSec.IPM_Project_Document__c=projDoc.ID;
        
               insert projDocSec;
                                                          
               insertFeed=new FeedItem();
               insertFeed.Body='This is comment Test';
               insertFeed.ParentId=''+projDocSec.id; 
             insertFeed.Type='TextPost';
               insert insertFeed;
    }
    static testMethod void testComments()
           {
               //TestData testData= new TestData();
              
               initializeData();
               PageReference pRef = new PageReference('apex/IPMCommentsPage?id='+projDocSec.ID);
               Test.setCurrentPage(pRef);
               IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
              
           }
    
    
  static testMethod void testAddComments()    
    {
              
             initializeData();
            
                               
               PageReference pRef = new PageReference('apex/IPMCommentsPage?id='+projDocSec.ID);
               Test.setCurrentPage(pRef);
               IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
            system.debug('section ID'+projDocSec.id);
             ipmComments.CommentRecord.ParentId=projDocSec.id;
             ipmComments.CommentRecord.Body='Test THis Comment';
             ipmComments.CommentRecord.Type='TextPost';
            // string secID=String.valueOf(projDocSec.id);  
              //system.debug('section ID'+secID);
            
            ipmComments.AddComment();
              
        
    
    }
    
    static testMethod void testDeleteComments()    
    {
              
             initializeData();
            
                               
               PageReference pRef = new PageReference('apex/IPMCommentsPage?id='+projDocSec.ID);
               Test.setCurrentPage(pRef);
               IPM_CommentsListController  ipmComments = new IPM_CommentsListController();
            system.debug('section ID'+projDocSec.id);
             //ipmComments.CommentRecord.ParentId=projDocSec.id;
            ipmComments.ParentID=projDocSec.id;
                       //system.debug('section ID'+secID);
              
            ipmComments.doDelete();
              
        
    
    }
   
}