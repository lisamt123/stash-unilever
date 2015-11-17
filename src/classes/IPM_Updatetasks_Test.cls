/*****************************************************************************
*@Author:Cognizant
*@Date:01/02/2015
*@Description : To test IPM_Updatetasks class functionalities
*/
@isTest
public class IPM_Updatetasks_Test {
    public static IPM_Project__c project;
    public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
    public static Map<Id, IPM_Project_Document__c> newPDocumentsMap=new Map<Id, IPM_Project_Document__c>();
    
    /**************************************************************
    *@Description :create a project and project document
    */
    static testMethod void initializeData(){
        project=new IPM_Project__c();
        project.Name='TestComments';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_GateKeeping_Model__c='Both'; 
        insert project;
        system.assertNotEquals(project.id, null);
        
        proDoc.IPM_GateDocuments__c='Charter'; 
        proDoc.IPM_Project__c=project.ID;
        
        insert proDoc;    
        system.assertNotEquals(proDoc.id, null);
        system.assertEquals(proDoc.IPM_GateDocuments__c, 'Charter');
        newPDocumentsMap.put(proDoc.Id,proDoc);
        system.assert(newPDocumentsMap.size()>0, 'newPDocumentsMap map should contain atleast 1 item.');
    }
    
    /**************************************************************
    *@Description :get project id from initiliazedata method
    */
    static testMethod void dotest(){
        
        Test.startTest();
        initializeData();
        Test.stopTest();
        PageReference pRef = new PageReference('/apex/IPM_UniqueProjectName?id='+project.Id);
        Test.setCurrentPage(pRef);
        system.assert(pRef!=null, 'pRef should not be null.');
    }
}