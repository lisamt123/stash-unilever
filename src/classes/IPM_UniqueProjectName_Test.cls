@isTest
public class IPM_UniqueProjectName_Test {
	public static IPM_Project__c project;
	public static IPM_Project_Document__c proDoc;//=new IPM_Project_Document__c();
	public static Map<Id, IPM_Project_Document__c> newPDocumentsMap=new Map<Id, IPM_Project_Document__c>();
	
	static testMethod void initializeData(){
		project = IPM_TestFactory_Helper.createIPMProject(false);
        project.IPM_GateKeeping_Model__c='Both'; 
        insert project;

		proDoc = IPM_TestFactory_Helper.createIPMProjectDocument(false);
        proDoc.IPM_Project__c=project.ID;
        //proDoc.IPM_Project_Template__c=projTemp.Id;
        insert proDoc;    
 
		newPDocumentsMap.put(proDoc.Id,proDoc);
		System.assertEquals(1, newPDocumentsMap.size() );
	}

	static testMethod void dotest() {
		initializeData();
        PageReference pRef = new PageReference('/apex/IPM_UniqueProjectName?id='+project.Id);
        Test.setCurrentPage(pRef);
		System.assertEquals(1, newPDocumentsMap.size() );
	}
}