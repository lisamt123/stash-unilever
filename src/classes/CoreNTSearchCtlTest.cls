/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CoreNTSearchCtlTest {


    static testMethod void testMethodForSearchingProjectComponenets() {
        
        Test.startTest();
        	
        	List<String> searchObjs = new List<String>();
        	searchObjs.add('Project');
        	searchObjs.add('Summary Task');
        	searchObjs.add('Task');
        	searchObjs.add('Milestone');
        	
            CORE_NT_Project__c ntProjectObj = new CORE_NT_Project__c();
            ntProjectObj.Name = 'Network Tracking';
            insert ntProjectObj;
            
            CORE_NT_Summary_Task__c milestoneObj = new CORE_NT_Summary_Task__c();
            milestoneObj.Name = 'Network Tracking Summary Task';
            milestoneObj.Project__c = ntProjectObj.Id;
            insert milestoneObj;
            
            CORE_NT_Task__c taskObj = new CORE_NT_Task__c();
            taskObj.Name = 'Network Tracking Task';
            taskObj.ProjectId__c = ntProjectObj.Id;
            //taskObj.Project_Milestone__c = milestoneObj.Id;
            insert taskObj;
            
            CORE_NT_Task__c taskObj1 = new CORE_NT_Task__c();
            taskObj1.Name = 'Network Tracking Task';
            taskObj1.ProjectId__c = ntProjectObj.Id;
            //taskObj.Project_Milestone__c = milestoneObj.Id;
            taskObj1.Milestone__c = true;
            insert taskObj1;
            
            CoreNTSearchCtl CoreNTSearchCtlObj = new CoreNTSearchCtl();
            Id [] fixedSearchResults= new Id[]{ntProjectObj.Id};
            Test.setFixedSearchResults(fixedSearchResults);
            CoreNTSearchCtlObj.searchInput = 'net';
            CoreNTSearchCtlObj.getItems();
            Id [] fixedSearchResults2= new Id[]{taskObj.Id};
            Test.setFixedSearchResults(fixedSearchResults2);
            CoreNTSearchCtlObj.searchInput = 'net';
            CoreNTSearchCtlObj.getItems();
            Id [] fixedSearchResults3= new Id[]{taskObj1.Id};
            Test.setFixedSearchResults(fixedSearchResults3);
            
            CoreNTSearchCtlObj.searchInput = 'net';
            CoreNTSearchCtlObj.getItems();
            CoreNTSearchCtlObj.searchAction();
            CoreNTSearchCtlObj.searchInput = 'abc';
            CoreNTSearchCtlObj.searchAction();
            CoreNTSearchCtlObj.searchInput = 'a';
            CoreNTSearchCtlObj.searchAction(); 
            CoreNTSearchCtlObj.searchInput = 'net';
            CoreNTSearchCtlObj.searchObjects = searchObjs;
            CoreNTSearchCtlObj.searchAction(); 
        
        Test.stopTest();
        
    }
}