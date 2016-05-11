/**********************************************************************
Name: CPA_Req_Deli_and_Key_Contacts_util_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Name      01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class CPA_Req_Deli_and_Key_Contacts_util_Test {
    
    /*******************************************************************
    Purpose: This method is used to cover custom settings status methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static  void CPA_StatusMsgCustomSetting(){
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        
    } 
    /*******************************************************************
    Purpose: This method is used to cover CPA_Req_Deli_Util_Test utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_Req_Deli_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
		
        CPA_Trigger_Pattern__c Req_Deli_TriggerPattern = CPA_Test_Req_Deli_and_Key_Contacts_util.createTest_Req_DeliTriggerPattern();
        insert Req_Deli_TriggerPattern;
        CPA_Trigger_Pattern__c key_cont_TriggerPattern = CPA_Test_Req_Deli_and_Key_Contacts_util.createTest_Key_ContactsTriggerPattern();
        insert key_cont_TriggerPattern;
        CPA_Trigger_Pattern__c Resource_TriggerPattern = CPA_Test_Req_Deli_and_Key_Contacts_util.createTest_ResourceTriggerPattern();
        insert Resource_TriggerPattern;
        
       Test.startTest();        
            CPA_PWORF__c objPworf13 = CPA_testPWORFClass_util.createTest_other_PWORF();
        	insert objPworf13;
			
			CPA_Requirements_and_Deliverables__c req_deli = CPA_testPWORFClass_util.createRequirementsDeliverables(objPworf13);
			insert req_deli;
        	
			CPA_Key_Contacts__c key_contact = CPA_testPWORFClass_util.CreateKeyContacts(objPworf13);
			insert key_contact;
        	
        	CPA_Resource_Requirement__c resource = CPA_Test_Req_Deli_and_Key_Contacts_util.createTest_Resource(objPworf13);
			insert resource;
        
        	req_deli.name = 'test123';
        	update req_deli;
        	key_contact.name = 'test123';
        	update key_contact;
        	resource.per_Budget_Expenses_of_Resource_Cost__c = 2;
        	update resource;
        	delete key_contact;
        	delete req_deli;
        	delete resource;
       Test.stopTest();      
        system.assert(objPworf13.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED);
    }
	/*******************************************************************
    Purpose: This method is used to cover CPA_UserDefineAttribute_Util
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_UDA_Test(){ 
        CPA_StatusMsgCustomSetting();
		
        CPA_Trigger_Pattern__c UDA_TriggerPattern = CPA_Test_Req_Deli_and_Key_Contacts_util.createTest_UDATriggerPattern();
        insert UDA_TriggerPattern;
        
       Test.startTest();        
            CPA_PWORF__c objPworf13 = CPA_testPWORFClass_util.createTest_other_PWORF();
        	insert objPworf13;
			CPA_project_work_order__c objPWO = CPA_testContractClass.createotherPWO(objPworf13);
            insert objPWO;
			CPA_User_Defined_Attribute__c uda1 = CPA_Test_Req_Deli_and_Key_Contacts_util.createTest_UDA(objPWO);
			insert uda1;
      
        	uda1.txt_Value__c = 'test123';
        	update uda1;
        CPA_project_work_order__c objPWOList = [Select Id,pkl_Status__c from CPA_project_work_order__c where id= :objPWO.id];
       Test.stopTest();        
        system.assert(objPWOList.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED);
    }
}