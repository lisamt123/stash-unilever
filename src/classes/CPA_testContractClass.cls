/********************************************************************
 Name:  CPA_testContractClass()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Test class to cover record type                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR    DATE              DETAIL                 Description
   1.0   Pooja     09/03/2015        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class CPA_testContractClass {
    /*******************************************************************
    Purpose: This method is used to create Test User
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static User createTestUser (){
        //User testUser; - commented as this variable not used anywhere, just initialized on line number 7, but returning testUser1
        Profile p = [select id from profile where name='system Administrator'];
        
        //testUser = new User(alias = 'u1', email='u1@unilever.com',
        //emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        //localesidkey='en_US', profileid = p.Id, country='United States',
        //timezonesidkey='America/Los_Angeles', username='u1@unilever.com');
        User testUser1 = [Select Id,profileid,isactive from user where profileid  =: p.Id AND isactive = true limit 1];
        return testUser1;
    
    }
        /*******************************************************************
    Purpose: This method is used to create LOI test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_LOI__c createLOI (CPA_PWORF__c objPWORF){
        CPA_LOI__c objLOI = new CPA_LOI__c();  
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = CPA_testPWORFClass_util.createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = CPA_testPWORFClass_util.createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CPA_testPWORFClass_util.CreateKeyContacts(objPWORF);
        insert objKCs;
        objPWORF.pkl_Status__c = 'Submitted';
        update  objPWORF;
        objPWORF.pkl_Status__c = 'Auto Accepted';
        update  objPWORF;
        
        objLOI.txt_Accenture_Project_Manager__c = CPA_ConstantsForContractingAppClasses.TEST;
        objLOI.lkp_PWORF__c=objPWORF.id;
        objLOI.pkl_Currency__c = CPA_ConstantsForContractingAppClasses.TEST;
        objLOI.num_Expense_charges_of_LOI__c = 2;
        objLOI.num_If_applicable_please_specify_the__c = 4;
        
        objLOI.dt_LOI_End_date__c = system.Today()+10;
        objLOI.dt_LOI_Start_Date__c = system.Today();
        objLOI.mpkl_Phases_covered_by_WAR__c = 'Plan';
        objLOI.txt_PWO_number__c = 'PWO00123';
        objLOI.lkp_PWORF__c = objPWORF.Id;
        objLOI.txt_PWO_title__c = CPA_ConstantsForContractingAppClasses.TEST;
        objLOI.num_Total_value_in_being_requested_for__c = 1;
        objLOI.txt_Unilever_Clarity_ID__c = '21323';
        
        return objLOI;

    }
    /*******************************************************************
    Purpose: This method is used to create PWO test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_project_work_order__c createPWO(CPA_PWORF__c objPWORF){
        CPA_project_work_order__c objPwo = new CPA_project_work_order__c();
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = CPA_testPWORFClass_util.createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = CPA_testPWORFClass_util.createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CPA_testPWORFClass_util.CreateKeyContacts(objPWORF);
        insert objKCs;
        
        /*objPWORF.pkl_Status__c = 'Submitted';
        update  objPWORF;*/
        objPWORF.pkl_Status__c = 'Auto Accepted';
        update  objPWORF;
        
        objPwo.txt_Accenture_Project_Manager__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.num_Authorisation_charges__c = 100;
        objPwo.num_Authorisation_man_days__c = 100;
        objPwo.pkl_Billing_Details__c = 'Unilever Europe';
        objPwo.Comments__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.Currency__c = 'EUR';
        objPwo.num_Estimated_Man_days_of_PWO__c = 10;
        objPwo.pec_Estimated_Off_shore__c = 1;
        objPwo.pec_Estimated_On_shore__c=1;
        objPwo.num_Estimated_Value_of_PWO__c =10;
        objPwo.pec_Expense__c =1;
        objPwo.num_Expense_charges_of_work_order__c=10;
        
        objPwo.num_ITC_resources_man_days__c = 10;
        objPwo.num_On_shore_senior_resources_man_days__c  =10;
        objPwo.txt_Previous_Status_Value__c='sdkj';
        objPwo.pkl_Pricing_Model__c = 'Fixed Price';
        objPwo.mpkl_Project_Classification__c = 'Complex';
        objPwo.mpkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
        objPwo.txt_PWO_number__c = 'PWO-001';
        objPwo.PWORF_ID__c = objPWORF.Id;
        objPwo.txt_PWO_title__c = 'Titke';
        objPwo.pkl_Region__c = CPA_ConstantsForContractingAppClasses.EUROPE;
        objPwo.num_RMS_value__c = 1;
        objPwo.num_Senior_resources_man_days__c=1;
        objPwo.num_Target_Blend_Rate__c = 1;
        objPwo.num_Total_work_order_charge__c =1;
        objPwo.mpkl_Unilever_Innovation_Area__c = 'HR';
        objPwo.txt_Unilever_Project_Name__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.txt_Unilever_Reference__c = 'Uni';
        objPwo.pec_Variance__c =1;
        objPwo.num_Varied_Target_Blend_Rate__c = 1;
        objPwo.dt_Date_PWORF_accepted__c = system.Today();
        objPwo.dt_Project_Initiation_Date__c = system.today();
        objPwo.dt_Expected_Start_Date__c = system.today();
        objPwo.dt_Expected_End_date__c = system.today();
        objPWO.lkp_Unilever_budget_approver__c = testUSer.Id;
        objPWO.lkp_Unilever_content_approver__c =testUSer.Id;
        objPWO.lkp_Unilever_Finance_BP_Contact__c = testUSer.Id;
        return objPwo;
        
    }
    /*******************************************************************
    Purpose: This method is used to create Other PWO test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_project_work_order__c createotherPWO(CPA_PWORF__c objPWORF){
        CPA_project_work_order__c objPwo = new CPA_project_work_order__c();
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = CPA_testPWORFClass_util.createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = CPA_testPWORFClass_util.createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CPA_testPWORFClass_util.CreateKeyContacts(objPWORF);
        insert objKCs;
        
        /*objPWORF.pkl_Status__c = 'Submitted';
        update  objPWORF;*/
        objPWORF.pkl_Status__c = 'Auto Accepted';
        update  objPWORF;
        
        objPwo.txt_Accenture_Project_Manager__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.num_Authorisation_charges__c = 100;
        objPwo.num_Authorisation_man_days__c = 100;
        objPwo.pkl_Billing_Details__c = 'Unilever Europe';
        objPwo.Comments__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.Currency__c = 'EUR';
        objPwo.num_Estimated_Man_days_of_PWO__c = 10;
        objPwo.pec_Estimated_Off_shore__c = 1;
        objPwo.pec_Estimated_On_shore__c=1;
        objPwo.num_Estimated_Value_of_PWO__c =10;
        objPwo.pec_Expense__c =1;
        objPwo.num_Expense_charges_of_work_order__c=10;
        
        objPwo.num_ITC_resources_man_days__c = 10;
        objPwo.num_On_shore_senior_resources_man_days__c  =10;
        objPwo.txt_Previous_Status_Value__c='sdkj';
        objPwo.pkl_Pricing_Model__c = 'Fixed Price';
        objPwo.mpkl_Project_Classification__c = null;
        objPwo.mpkl_Project_Phases__c = null;
        objPwo.txt_PWO_number__c = 'PWO-001';
        objPwo.PWORF_ID__c = objPWORF.Id;
        objPwo.txt_PWO_title__c = null;
        objPwo.pkl_Region__c = null;
        objPwo.num_RMS_value__c = 1;
        objPwo.num_Senior_resources_man_days__c=1;
        objPwo.num_Target_Blend_Rate__c = 1;
        objPwo.num_Total_work_order_charge__c =1;
        objPwo.mpkl_Unilever_Innovation_Area__c = null;
        objPwo.txt_Unilever_Project_Name__c = null;
        objPwo.txt_Unilever_Reference__c = null;
        objPwo.pec_Variance__c =1;
        objPwo.num_Varied_Target_Blend_Rate__c = 1;
        objPwo.dt_Date_PWORF_accepted__c = null;
        objPwo.dt_Project_Initiation_Date__c = system.today();
        objPwo.dt_Expected_Start_Date__c = system.today();
        objPwo.dt_Expected_End_date__c = system.today();
        objPWO.lkp_Unilever_budget_approver__c = null;
        objPWO.lkp_Unilever_content_approver__c =null;
        objPWO.lkp_Unilever_Finance_BP_Contact__c = null;
          objPWO.num_Effort_Cost__c=1;
          
        return objPwo;
        
    }
    
    /*******************************************************************
    Purpose: This method is used to create CR test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_CR__c createCR(CPA_project_work_order__c objPWO){
        CPA_CR__c objCR = new CPA_CR__c();
        objCR.txt_Accenture_Project_Manager__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.num_Authorisation_charges__c = 1;
        objCR.num_Authorisation_man_days__c =1;
        objCR.mpkl_Change_Record_history__c = '2nd Change';
        objCR.txt_Change_Record_number__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.ltxta_Comments__c = 'Test C';
        objCR.dt_CR_End_date__c = system.Today()+8;
        objCR.dt_CR_Start_Date__c = system.today();
        objCR.pkl_Currency__c = 'EUR';
        objCR.dt_Date_raised__c = system.today();
        objCR.num_Estimated_Man_days_of_CR__c = 1;
        objCR.pec_Estimated_Off_shore__c =1;
        objCR.pec_Estimated_On_shore__c =1;
        objCR.num_Estimated_Value_of_CR__c =1;
        objCR.pec_Expense__c =1;
        objCR.num_Expense_charges_of_CR__c =1;
        objCR.num_ITC_resources_man_days__c =1;
        objCR.num_On_shore_senior_resources_man_days__c =1;
        objCR.txt_Other_Phase_change_record_raised__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.txt_Other_Project_Phases__c = 'Plan, Analyse';
        objCR.pkl_Phase_change_record_raised__c = 'Plan';
        objCR.txt_Previous_Status_Value__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.pkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
        objCR.CPA_Project_Work_Order__c = objPWO.Id;
        objCR.PWO_number__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.Region_impacted__c = CPA_ConstantsForContractingAppClasses.EUROPE;
        objCR.num_RMS_value__c =1;
        objCR.num_Senior_resources_man_days__c =1;
        objCR.num_Target_Blend_Rate__c =1;
        objCR.txt_Title_of_change__c =CPA_ConstantsForContractingAppClasses.TEST;
        objCR.num_Total_charge_of_CR__c = 1;
        objCR.txta_Unilever_Project_Name__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.txt_Unilever_Reference__c = CPA_ConstantsForContractingAppClasses.TEST;
         objCR.num_Effort_Cost__c=100;
        objCR.num_Total_Resource_Cost_CR__c=1;
        objCR.num_Expense_charges_of_CR__c =1;
       // objCR.pec_Variance__c=1;
        objCR.num_Varied_Target_Blend_Rate__c =1;
        objCR.chk_isStandalone_CR__c = false;        
        return objCR;
        
    }
    /*******************************************************************
    Purpose: This method is used to create Standalone CR test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_CR__c standAloneCR(){
        CPA_CR__c objCR = new CPA_CR__c();
        Id StandaloneCRRecordType = Schema.SObjectType.CPA_CR__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_Standalone_CR_RecordTypeId).getRecordTypeId();
        //objCR.RecordTypeid=label.CPA_Standalone_CR_RecordTypeId;
        objCR.RecordTypeid= StandaloneCRRecordType;
        objCR.txt_Accenture_Project_Manager__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.num_Authorisation_charges__c = 1;
        objCR.num_Authorisation_man_days__c =1;
        objCR.mpkl_Change_Record_history__c = '2nd Change';
        objCR.txt_Change_Record_number__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.ltxta_Comments__c = 'Test C';
        objCR.dt_CR_End_date__c = system.Today()+8;
        objCR.dt_CR_Start_Date__c = system.today();
        objCR.pkl_Currency__c = 'EUR';
        objCR.dt_Date_raised__c = system.today();
        objCR.num_Estimated_Man_days_of_CR__c = 1;
        objCR.pec_Estimated_Off_shore__c =1;
        objCR.pec_Estimated_On_shore__c =1;
        objCR.num_Estimated_Value_of_CR__c =1;
        objCR.pec_Expense__c =1;
        objCR.num_Expense_charges_of_CR__c =1;
        objCR.num_ITC_resources_man_days__c =1;
        objCR.num_On_shore_senior_resources_man_days__c =1;
        objCR.txt_Other_Phase_change_record_raised__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.txt_Other_Project_Phases__c = 'Plan, Analyse';
        objCR.pkl_Phase_change_record_raised__c = 'Plan';
        objCR.txt_Previous_Status_Value__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.pkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
        objCR.PWO_number__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.Region_impacted__c = CPA_ConstantsForContractingAppClasses.EUROPE;
        objCR.num_RMS_value__c =1;
        objCR.num_Senior_resources_man_days__c =1;
        objCR.num_Target_Blend_Rate__c =1;
        objCR.txt_Title_of_change__c =CPA_ConstantsForContractingAppClasses.TEST;
        objCR.num_Total_charge_of_CR__c = 1;
        objCR.txta_Unilever_Project_Name__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.txt_Unilever_Reference__c = CPA_ConstantsForContractingAppClasses.TEST;
        objCR.num_Effort_Cost__c=1;
        objCR.num_Expense_charges_of_CR__c =1;
        //objCR.pec_Variance__c=1;
        objCR.num_Varied_Target_Blend_Rate__c =1;
        
        return objCR;
        
    }
    /*******************************************************************
    Purpose: This method is used to create empty CR test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_CR__c blankCR(CPA_project_work_order__c objPWO){
        CPA_CR__c objCR1 = new CPA_CR__c();
        objCR1.CPA_Project_Work_Order__c = objPWO.Id;       
        return objCR1;
        
    }
    /*******************************************************************
    Purpose: This method is used to create LE request test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_HLE_Request__c CreateHLERequest(){
        CPA_HLE_Request__c objHLEREQ = new CPA_HLE_Request__c();
        objHLEREQ.txt_Background__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.ph_UBPR_Contact_No__c  =CPA_ConstantsForContractingAppClasses.ONETWOTHREE;
        objHLEREQ.ph_UIOS_Contact_No__c =CPA_ConstantsForContractingAppClasses.ONETWOTHREE;
        objHLEREQ.ph_AAL_Contact_No__c  =CPA_ConstantsForContractingAppClasses.ONETWOTHREE;
        objHLEREQ.dt_Date_raised__c  =system.Today();
        objHLEREQ.txt_Dependencies__c  =CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.eml_UBPR_Email__c  =CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.eml_UIOS_Email__c  =CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.eml_AAL_Email__c  =CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.txt_UBPR_Name__c = CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.txt_UIOS_Name__c  =CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.txt_AAL_Name__c  =CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.dt_Planned_end_date__c  =system.Today();
        objHLEREQ.dt_Planned_start_date__c  =system.Today();
        objHLEREQ.txt_Project_description_specification__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Project_type__c   = CPA_ConstantsForContractingAppClasses.TEST;
       // objHLEREQ.txt_Request_ID__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Risks_and_issues__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Software_Licensing_requirements__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Support_impact__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Technologies__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Title__c  = CPA_ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_UL_reference__c  = CPA_ConstantsForContractingAppClasses.TEST;
        
        return objHLEREQ;
    }     
}