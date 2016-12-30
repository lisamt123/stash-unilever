/**********************************************************************
Name: TEL_CaseTrigger_Test
Copyright © 2016 Unilever
======================================================
Purpose: Class to test the class: TEL_CaseTrigger_Test.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Ronaldo Garcia  	26/12/2016  Class Creation
***********************************************************************/
@isTest
public class TEL_CaseTrigger_Test {
    
    static testMethod void createData() {     
        TEL_Telesales__c cs = new TEL_Telesales__c();
        cs.Name = 'Additional_Days';
        cs.Value__c = '5';
        insert cs;
        
        Case caseObj 			= new Case(TEL_Product__c = 'Test', Status = 'Approved');
        System.Database.insert(caseObj);
        caseObj.RecordTypeId 	= [SELECT Id FROM RecordType WHERE DeveloperName = 'TEL_Sample_Requests' LIMIT 1].Id;
        System.Database.update(caseObj);
        
        Opportunity oppObj 		= new Opportunity();
        oppObj.Name				= Label.TEL_Opportunity_Name;
        oppObj.TEL_Case__c		= caseObj.Id;
        oppObj.Type				= Label.TEL_Sample_Request;
        oppObj.RecordTypeId		= [SELECT Id FROM RecordType WHERE DeveloperName = 'TEL_Telesales' LIMIT 1].Id;
        oppObj.CloseDate		= System.today().addDays(30);
        oppObj.StageName 		= Label.TEL_Opportunity_Status;
        System.Database.insert(oppObj);
        
        // Retrieve the Case and Sample Opportunity created. 
        List<Case> caseList = [SELECT TEL_Product__c FROM Case WHERE TEL_Product__c = 'Test' LIMIT 1];
        List<Opportunity> oppList = [SELECT TEL_Case__c FROM Opportunity WHERE TEL_Case__c =: caseList.get(0).Id LIMIT 1];  
        
        // Validate if the case and opportunity was created correctly. 
        System.assert(!caseList.isEmpty()); 
        System.assert(!oppList.isEmpty());        
    }
    
}