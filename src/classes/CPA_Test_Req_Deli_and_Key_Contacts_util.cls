/**********************************************************************
Name: CPA_Test_Req_Deli_and_Key_Contacts_util()
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
1.0      Pooja Kanani   01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_Test_Req_Deli_and_Key_Contacts_util {
	/*******************************************************************
    Purpose: This method is used to set the after Key_Contact trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_Key_ContactsTriggerPattern(){

        CPA_Trigger_Pattern__c Key_ContactsTriggerPattern = new CPA_Trigger_Pattern__c();
        Key_ContactsTriggerPattern.Name ='CPA_Key_Contact_Trigger';
        Key_ContactsTriggerPattern.chk_Check_Run__c = true;
        return Key_ContactsTriggerPattern;
        
    }
	/*******************************************************************
    Purpose: This method is used to set the after Requirements_and_Deliverables trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_Req_DeliTriggerPattern(){

        CPA_Trigger_Pattern__c Req_DeliTriggerPattern = new CPA_Trigger_Pattern__c();
        Req_DeliTriggerPattern.Name ='CPA_Requirements_and_Deliverables';
        Req_DeliTriggerPattern.chk_Check_Run__c = true;
        return Req_DeliTriggerPattern;
        
    }	
    /*******************************************************************
    Purpose: This method is used to set the after Resource summary trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_ResourceTriggerPattern(){

        CPA_Trigger_Pattern__c ResourceTriggerPattern = new CPA_Trigger_Pattern__c();
        ResourceTriggerPattern.Name ='Resource_Requirement';
        ResourceTriggerPattern.chk_Check_Run__c = true;
        return ResourceTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the after UDA trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_UDATriggerPattern(){

        CPA_Trigger_Pattern__c UDATriggerPattern = new CPA_Trigger_Pattern__c();
        UDATriggerPattern.Name ='CPA_User_Defined_Attribute';
        UDATriggerPattern.chk_Check_Run__c = true;
        return UDATriggerPattern;
        
    }	
    /*******************************************************************
    Purpose: This method is used to set Resource summary record
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Resource_Requirement__c createTest_Resource(CPA_PWORF__c objPWORF){

        CPA_Resource_Requirement__c Resource = new CPA_Resource_Requirement__c();
        
        Resource.per_Budget_Expenses_of_Resource_Cost__c = 1;
        Resource.dat_Indicative_timeline_End_date__c = system.today()  ;
        Resource.dat_Indicative_timeline_Start_date__c = system.today()  ;
        Resource.PWORF__c  = objPWORF.id;
        Resource.Man_Days__c = 1;
        Resource.txt_Resource_Location__c = CPA_ConstantsForContractingAppClasses.TEST;
        Resource.txt_Role_Level_1_13__c = '1';
        return Resource;
        
    }
    /*******************************************************************
    Purpose: This method is used to set UDA record
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   public static CPA_User_Defined_Attribute__c createTest_UDA(CPA_project_work_order__c objPWO){

        CPA_User_Defined_Attribute__c uda = new CPA_User_Defined_Attribute__c();
        
        uda.pkl_Attribute_Type__c = 'Cost';
        uda.txt_Value__c = 'test'  ;
        uda.lkp_PWO__c = objPWO.id  ;
		uda.chk_isDocusignedRecord__c =true;       
        return uda;
        
    }			
}