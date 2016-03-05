/**********************************************************************
Name: CPA_testClass_util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of test of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Shreyas      01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_testClass_util {
    
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
    Purpose: This method is used to set the status of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_CPA_Status_Msg(){

        CPA_Status_Msg__c saveStatus = new CPA_Status_Msg__c();
        saveStatus.Name ='Saved';
        saveStatus.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return saveStatus;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (auto accepted) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_AutoAcceMsg(){

        CPA_Status_Msg__c AutoAcceMsg = new CPA_Status_Msg__c();
        AutoAcceMsg.Name ='Auto Accepted';
        AutoAcceMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return AutoAcceMsg;
        
    }
    
    /*******************************************************************
    Purpose: This method is used to set the status messages (accepted) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_CPA_Status_Msg1(){

        CPA_Status_Msg__c acceptedStatus = new CPA_Status_Msg__c();
        acceptedStatus.Name ='Accepted';
        acceptedStatus.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return acceptedStatus;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (submitted) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_SubMsg(){

        CPA_Status_Msg__c SubMsg = new CPA_Status_Msg__c();
        SubMsg.Name ='Submitted';
        SubMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return SubMsg;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (Answered) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_AnsweredMsg(){

        CPA_Status_Msg__c AnsweredMsg = new CPA_Status_Msg__c();
        AnsweredMsg.Name ='Answered';
        AnsweredMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return AnsweredMsg;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (Cancel) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_CancelMsg(){

        CPA_Status_Msg__c CancelMsg = new CPA_Status_Msg__c();
        CancelMsg.Name ='Cancelled';
        CancelMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return CancelMsg;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the CR trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_CRTriggerPattern(){

        CPA_Trigger_Pattern__c CRtriggerPattern = new CPA_Trigger_Pattern__c();
        CRtriggerPattern.Name ='CPA_CR_Trigger';
        CRtriggerPattern.chk_Check_Run__c = true;
        return CRtriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the after attachment trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_AfterAttachmentTriggerPattern(){

        CPA_Trigger_Pattern__c AfterAttachmentTriggerPattern = new CPA_Trigger_Pattern__c();
        AfterAttachmentTriggerPattern.Name ='CPA_AfterAttachment';
        AfterAttachmentTriggerPattern.chk_Check_Run__c = true;
        return AfterAttachmentTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the HLE Request trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_HLERequestTriggerPattern(){

        CPA_Trigger_Pattern__c HLERequestTriggerPattern = new CPA_Trigger_Pattern__c();
        HLERequestTriggerPattern.Name ='CPA_HLERequest';
        HLERequestTriggerPattern.chk_Check_Run__c = true;
        return HLERequestTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the LOI trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_LOITriggerPattern(){

        CPA_Trigger_Pattern__c LOITriggerPattern = new CPA_Trigger_Pattern__c();
        LOITriggerPattern.Name ='CPA_LOI_Trigger';
        LOITriggerPattern.chk_Check_Run__c = true;
        return LOITriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWO trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_PWOTriggerPattern(){

        CPA_Trigger_Pattern__c PWOTriggerPattern = new CPA_Trigger_Pattern__c();
        PWOTriggerPattern.Name ='CPA_Project_Work_Order_Trigger';
        PWOTriggerPattern.chk_Check_Run__c = true;
        return PWOTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWORF trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_PWORFTriggerPattern(){

        CPA_Trigger_Pattern__c PWORFTriggerPattern = new CPA_Trigger_Pattern__c();
        PWORFTriggerPattern.Name ='CPA_PWORF_Trigger';
        PWORFTriggerPattern.chk_Check_Run__c = true;
        return PWORFTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the HLE Request SLA details
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_HLE_Request_SLAs__c createTest_HLEReqSLA(){

        CPA_HLE_Request_SLAs__c HLEReqSLA = new CPA_HLE_Request_SLAs__c();
        HLEReqSLA.Name ='SLA';
        HLEReqSLA.HLE_Request_SLA1__c = 5;
        HLEReqSLA.HLE_Request_SLA2__c = 5;
        return HLEReqSLA;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWORF All record types
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_PWORF_Record_type__c createTest_PWORF_All_recordtType(ID allId){

        CPA_PWORF_Record_type__c PWORFAllrecordtType = new CPA_PWORF_Record_type__c();
        PWORFAllrecordtType.Name ='All';
        PWORFAllrecordtType.Record_type_id__c = allId;
        return PWORFAllrecordtType;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWORF RA record type
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_PWORF_Record_type__c createTest_PWORF_RA_recordtType(ID raId){

        CPA_PWORF_Record_type__c PWORFRArecordtType = new CPA_PWORF_Record_type__c();
        PWORFRArecordtType.Name ='RA';
        PWORFRArecordtType.Record_type_id__c = raId;
        return PWORFRArecordtType;
        
    }
    /*******************************************************************
    Purpose: This method is used to create test data for PWORF
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_PWORF__c createTest_other_PWORF(){

        //Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();
        RecordType rt =[select id,Name from RecordType where sObjectType='CPA_PWORF__c' AND Name='Other' limit 1] ;
        CPA_PWORF_Record_type__c PWORFAllrecordtType = createTest_PWORF_All_recordtType(rt.id);
        insert(PWORFAllrecordtType);
        CPA_PWORF__c pworfRec = new CPA_PWORF__c();
        pworfRec.Name = 'Test->' + system.Now()+' 1';
       pworfRec.txt_Clarity_ID__c ='123456' ;
       pworfRec.pkl_Status__c ='Saved' ;
       pworfRec.RecordTypeid = rt.id;
        pworfRec.pkl_Business_Area__c ='Supply Chain' ;        
        pworfRec.pkl_Cost_Centre_Details__c ='ETS IT' ; 
        pworfRec.pkl_Landscape__c  ='Cordillera' ;         
        pworfRec.pkl_Request_Type__c  ='New Project' ;
        pworfRec.pkl_Pricing_Model__c ='T&M' ;                            
        pworfRec.pkl_Region__c  =CPA_ConstantsForContractingAppClasses.EUROPE;           
        
        pworfRec.Is_this_a_new_or_re_worked_Integration_R__c = CPA_ConstantsForContractingAppClasses.YES ;
         pworfRec.pkl_Is_this_Project_Invasive_in_nature__c =CPA_ConstantsForContractingAppClasses.YES ;
        
        pworfRec.txt_Internal_PWO_ID__c = '111111';
        
        pworfRec.dt_Expected_go_live_date__c  =system.today()  ;
        pworfRec.dt_Expected_start_date__c = system.today() ;
       pworfRec.Expected_Start_Date_for_DBTD_PWO__c = system.today() ;
        pworfRec.Expected_Start_Date_for_Plan_and_Analyse__c = system.today() ;
        pworfRec.dat_Indicative_timeline_End_date__c =system.today();
        pworfRec.dat_Indicative_timeline_Start_date__c =system.today();
        pworfRec.Expected_Business_Go_live_date__c =system.today();
      
        pworfRec.txt_SLA1__c = '2';
        pworfRec.txt_SLA2__c = '4';
        
        pworfRec.txt_Cost_Centre__c ='' ;
        pworfRec.txt_ICC_Number__c ='ICC Number' ;
        pworfRec.In_Scope__c='In Scope' ; 
        pworfRec.Out_of_Scope__c ='Out of Scope' ;
        pworfRec.Overall_purpose_or_function_of_the_proje__c='Overall purpose/function of the project' ;      
        pworfRec.Stakeholder_Expectations__c = 'Stakeholder Expectations' ;
        pworfRec.txta_Title__c ='Title' ;
         pworfRec.Business_Case__c = 'Business Case';       
        pworfRec.txta_Acceptance_Criteria__c='Acceptance Criteria'  ;
        pworfRec.Analyse_sessions_expected__c='Analyse sessions expected'  ;
        pworfRec.txta_Application_infrastructure__c ='Application infrastructure'  ;
        pworfRec.txta_Business_critical_milestones__c ='Business critical milestones'  ;       
        pworfRec.Impact_if_expected_business_go_live_date__c = CPA_ConstantsForContractingAppClasses.TEST ;
        pworfRec.Planning_sessions_expected__c ='Planning sessions expected'  ;
        pworfRec.Project_Dependencies__c ='Project Dependencies'  ;
        pworfRec.Summary_of_requirements_and_deliverables__c ='Summary of requirements and deliverables'  ;
        pworfRec.Travel_Arrangements__c ='Travel Arrangements'  ;
        pworfRec.Who_will_support_this_service_once_live__c ='Who will support this service once live?'  ;
        pworfRec.Does_this_project_change_Core_Business_M__c ='Does this project change Core Business M'  ;
        pworfRec.Does_this_Project_involve_Unilever_conf__c ='Does this Project involve Unilever conf'  ; 
        pworfRec.Governance_Risk_and_Compliance__c ='Governance Risk and Compliance'  ;          
        pworfRec.Has_W_R_been_discussed_with_Supplier_Per__c ='Has W@R been discussed with Supplier Per'  ;        
        pworfRec.Interface_to_the_system__c  ='Interface to the system'  ;
        pworfRec.Interface_to_the_system__c  =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.Interface_to_the_system_Detail__c = 'Interface to the system Detail'  ;
        
        pworfRec.pkl_Process_Office_Area_E2E__c ='Other (provide free text to enter)';
        pworfRec.txt_otherProcessOfficeAreaE2E__c ='Other Process Office area E2E'  ;
        pworfRec.mpkl_Project_Phases__c =CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
        pworfRec.txt_OtherProjectPhases__c = 'Other Project Phases'  ;            
        pworfRec.pkl_Process_Office_Area_E2E__c='Process Office Area E2E'  ;
        pworfRec.Is_Project__c  =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.Project_Require_Data_Specific_Testing__c ='Project Require Data Specific Testing'  ;                   
        pworfRec.Is_Project_Require__c  =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.txta_Project_Require_Performance_Testing__c  = 'Project Require Performance Testing'  ;     
        pworfRec.pkl_Project_Scale__c  ='Large Project (>2000 days)';    
        pworfRec.Role_or_System_Authorisation__c  =CPA_ConstantsForContractingAppClasses.YES;
        pworfRec.txta_Role_or_System_Authorisation_detail__c  ='Role or System Authorisation detail'  ; 
       
        pworfRec.txta_Project_Invasive_in_nature__c = 'Why Project Invasive in nature?'  ;
        
        pworfRec.Will_this_project_require_an_LOI_for_Wor__c  = CPA_ConstantsForContractingAppClasses.YES;
        pworfRec.How_many_man_days_do_you_think_you_requi__c  = 'Man Days'  ;
        pworfRec.When_do_you_require_the_Work_at_Risk_to__c  = system.today() ;
        pworfRec.txta_Why_is_Work_at_risk_required__c  =  'Why is Work at risk required?'  ;
        pworfRec.txta_What_specific_roles_do_you_require__c  = 'What specific roles do you require?'  ;
        pworfRec.txta_ITC_Resources_Utilisation__c  = 'ITC Resources Utilisation'  ;
        pworfRec.Which_BP_Innovation_director_has_approve__c  =  'Which BP/Innovation director has approve'  ;
        
        
        pworfRec.txt_Role_Level_1_13__c='Role (Level 1-13)';
        pworfRec.txt_Resource_Location__c ='Resource Location';
        pworfRec.per_Budget_Expenses_of_Resource_Cost__c =1 ;
        pworfRec.txta_Project_Description__c = 'Project Description';
       
        User testUSer = createTestUser();
        pworfRec.lkp_Unilever_budget_approver__c = testUSer.id;
        pworfRec.lkp_Unilever_content_approver__c = testUSer.id;
        pworfRec.lkp_Unilever_Finance_BP_Contact__c = testUSer.id;
        pworfRec.lkp_Unilever_project_manager__c = testUSer.id; 
        
        return pworfRec;
    }

    /*******************************************************************
    Purpose: This method is used to create Requirements and Deliverables test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Requirements_and_Deliverables__c createRequirementsDeliverables (CPA_PWORF__c objPWORF){
        CPA_Requirements_and_Deliverables__c objRandD = new CPA_Requirements_and_Deliverables__c();
        objRandD.Business_Process_Area_del__c= 'Business Process';
        objRandD.High_Level_Description_del__c = 'High Level Description';
        objRandD.New_or_changed_requirement_del__c = 'Changed';
        objRandD.Requirement_Type_del__c = CPA_ConstantsForContractingAppClasses.TEST;
        objRandD.PWORF_Requirement_Deliverables__c = objPWORF.id;
        objRandD.Name = CPA_ConstantsForContractingAppClasses.TEST;
        return objRandD;
    }
    /*******************************************************************
    Purpose: This method is used to create Risk Assessment and Mitigation test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Risk_Assessment_and_Mitigation__c createRiskAssessment (CPA_PWORF__c objPWORF){
        CPA_Risk_Assessment_and_Mitigation__c objRAM = new CPA_Risk_Assessment_and_Mitigation__c();
        objRAM.ltxta_Impact__c = CPA_ConstantsForContractingAppClasses.TEST;
        objRAM.ltxta_Mitigation_Action__c = CPA_ConstantsForContractingAppClasses.TEST;
        objRAM.ltxta_Probability__c = CPA_ConstantsForContractingAppClasses.TEST;
        objRAM.lkp_PWORF__c = objPWORF.Id;
        objRAM.ltxta_Risk_description__c = CPA_ConstantsForContractingAppClasses.TEST;
        objRAM.Name = CPA_ConstantsForContractingAppClasses.TEST;
        return objRAM;
    }
    /*******************************************************************
    Purpose: This method is used to create Key Contacts test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Key_Contacts__c CreateKeyContacts(CPA_PWORF__c objPWORF){
        CPA_Key_Contacts__c objKC = new CPA_Key_Contacts__c();
        objKC.Name = CPA_ConstantsForContractingAppClasses.TEST;
        objKC.E_mail__c = CPA_ConstantsForContractingAppClasses.TEST_EMAIL;
        objKC.Telephone__c = '2371243814';
        objKC.PWORF__c = objPWORF.Id;
        
        return objKC;
    }

    /*******************************************************************
    Purpose: This method is used to create RA PWORF test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/    
    public static CPA_PWORF__c createTest_RA_PWORF(){
      createTest_CPA_Status_Msg();
       // Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();
       RecordType rt =[select id,Name from RecordType where sObjectType='CPA_PWORF__c' AND Name='Resource Augmentation' limit 1] ;
        CPA_PWORF_Record_type__c PWORFRArecordtType = createTest_PWORF_RA_recordtType(rt.id);
        insert(PWORFRArecordtType);
        CPA_PWORF__c pworfRec = new CPA_PWORF__c();
        pworfRec.Name = 'TEST1123445678';
        pworfRec.pkl_Status__c ='Saved' ;
        pworfRec.Business_Case__c = 'Business Case';
        pworfRec.In_Scope__c='In Scope' ; 
        pworfRec.Out_of_Scope__c ='Out of Scope' ;
        pworfRec.Overall_purpose_or_function_of_the_proje__c='Overall purpose/function of the project' ;      
        pworfRec.Stakeholder_Expectations__c = 'Stakeholder Expectations' ;
        pworfRec.txta_Title__c ='Title' ;
        pworfRec.txt_Clarity_ID__c ='123456' ;
        pworfRec.pkl_Business_Area__c ='Business Area' ;        
        pworfRec.pkl_Cost_Centre_Details__c ='Cost Centre Details' ;          
        pworfRec.txt_Cost_Centre__c ='Cost Centre' ;
        pworfRec.txt_ICC_Number__c ='ICC Number' ;
                  
        pworfRec.pkl_Landscape__c  ='Landscape' ;         
        pworfRec.pkl_Request_Type__c  ='Other Request Type' ;
        pworfRec.pkl_Pricing_Model__c ='Pricing Model' ;                            
        pworfRec.pkl_Region__c  =CPA_ConstantsForContractingAppClasses.EUROPE;           
        pworfRec.pkl_Request_Type__c ='Request Type' ;
        pworfRec.RecordTypeid=rt.id;
        pworfRec.txta_Acceptance_Criteria__c='Acceptance Criteria'  ;
        pworfRec.Analyse_sessions_expected__c='Analyse sessions expected'  ;
        pworfRec.txta_Application_infrastructure__c ='Application infrastructure'  ;
        pworfRec.txta_Business_critical_milestones__c ='Business critical milestones'  ;

        pworfRec.dt_Expected_go_live_date__c  =system.today()  ;
        pworfRec.dt_Expected_start_date__c = system.today() ;
        pworfRec.Expected_Start_Date_for_DBTD_PWO__c = system.today() ;
        pworfRec.Expected_Start_Date_for_Plan_and_Analyse__c = system.today() ;
        pworfRec.Impact_if_expected_business_go_live_date__c = CPA_ConstantsForContractingAppClasses.TEST ;
        pworfRec.Planning_sessions_expected__c ='Planning sessions expected'  ;
        pworfRec.Project_Dependencies__c ='Project Dependencies'  ;
        pworfRec.Summary_of_requirements_and_deliverables__c ='Summary of requirements and deliverables'  ;
        pworfRec.Travel_Arrangements__c ='Travel Arrangements'  ;
        pworfRec.Who_will_support_this_service_once_live__c ='Who will support this service once live?'  ;
        pworfRec.Does_this_project_change_Core_Business_M__c ='Does this project change Core Business M'  ;
        pworfRec.Does_this_Project_involve_Unilever_conf__c ='Does this Project involve Unilever conf'  ; 
        pworfRec.Governance_Risk_and_Compliance__c ='Governance Risk and Compliance'  ;          
        pworfRec.Has_W_R_been_discussed_with_Supplier_Per__c ='Has W@R been discussed with Supplier Per'  ;        
        pworfRec.Interface_to_the_system__c  ='Interface to the system'  ;
        pworfRec.Interface_to_the_system__c  =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.Interface_to_the_system_Detail__c = 'Interface to the system Detail'  ;
        pworfRec.Is_Project__c  ='Is Project Require Data Specific Testing'  ;    
        pworfRec.Is_Project_Require__c   ='Is Project Require Performance Testing'  ;  
        pworfRec.Is_this_a_new_or_re_worked_Integration_R__c ='Is this a new or reworked Integration R'  ;
        pworfRec.pkl_Is_this_Project_Invasive_in_nature__c  ='Is this a new or re-worked Integration R'  ;
        pworfRec.txt_Internal_PWO_ID__c = '111111';
        
        pworfRec.pkl_Process_Office_Area_E2E__c ='Other (provide free text to enter)';
        pworfRec.txt_otherProcessOfficeAreaE2E__c ='Other Process Office area E2E'  ;
        pworfRec.mpkl_Project_Phases__c =CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
        pworfRec.txt_OtherProjectPhases__c = 'Other Project Phases'  ;            
        pworfRec.pkl_Process_Office_Area_E2E__c='Process Office Area E2E'  ;
        pworfRec.Is_Project__c  =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.Project_Require_Data_Specific_Testing__c ='Project Require Data Specific Testing'  ;                   
        pworfRec.Is_Project_Require__c  =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.txta_Project_Require_Performance_Testing__c  = 'Project Require Performance Testing'  ;     
        pworfRec.pkl_Project_Scale__c  ='Low Complexity Project (50 - 500 days)';    
        pworfRec.Role_or_System_Authorisation__c  =CPA_ConstantsForContractingAppClasses.YES;
        pworfRec.txta_Role_or_System_Authorisation_detail__c  ='Role or System Authorisation detail'  ; 
        pworfRec.pkl_Is_this_Project_Invasive_in_nature__c =CPA_ConstantsForContractingAppClasses.YES ;
        pworfRec.txta_Project_Invasive_in_nature__c = 'Why Project Invasive in nature?'  ;
        pworfRec.Will_this_project_require_an_LOI_for_Wor__c ='Will this project require an LOI for Wor'  ;

        pworfRec.Will_this_project_require_an_LOI_for_Wor__c  = CPA_ConstantsForContractingAppClasses.YES;
        pworfRec.How_many_man_days_do_you_think_you_requi__c  = 'Man Days'  ;
        pworfRec.When_do_you_require_the_Work_at_Risk_to__c  =  system.today() ;
        pworfRec.txta_Why_is_Work_at_risk_required__c  =  'Why is Work at risk required?'  ;
        pworfRec.txta_What_specific_roles_do_you_require__c  = 'What specific roles do you require?'  ;
        pworfRec.txta_ITC_Resources_Utilisation__c  = 'ITC Resources Utilisation'  ;
        pworfRec.Which_BP_Innovation_director_has_approve__c  =  'Which BP/Innovation director has approve'  ;
         pworfRec.dat_SLA1_Accepted_Date__c = system.today() ;
        User testUSer = createTestUser();
        pworfRec.lkp_Unilever_budget_approver__c = testUSer.id;
        pworfRec.lkp_Unilever_content_approver__c = testUSer.id;
        pworfRec.lkp_Unilever_Finance_BP_Contact__c = testUSer.id;
        pworfRec.lkp_Unilever_project_manager__c = testUSer.id; 
        
        return pworfRec;
    }   
    /*******************************************************************
    Purpose: This method is used to create LOI test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_LOI__c createLOI (CPA_PWORF__c objPWORF){
        createTest_CPA_Status_Msg();
        CPA_LOI__c objLOI = new CPA_LOI__c();  
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CreateKeyContacts(objPWORF);
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
        objLOI.mpkl_Phases_covered_by_WAR__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
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
        createTest_CPA_Status_Msg();
        CPA_project_work_order__c objPwo = new CPA_project_work_order__c();
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CreateKeyContacts(objPWORF);
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
        createTest_CPA_Status_Msg();
        CPA_project_work_order__c objPwo = new CPA_project_work_order__c();
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CreateKeyContacts(objPWORF);
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
        return objPwo;
        
    }
    /*******************************************************************
    Purpose: This method is used to create CR test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_CR__c createCR(CPA_project_work_order__c objPWO){
        createTest_CPA_Status_Msg();
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
        createTest_CPA_Status_Msg();
        CPA_CR__c objCR = new CPA_CR__c();
        objCR.RecordTypeid=label.CPA_Standalone_CR_RecordTypeId;
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
        createTest_CPA_Status_Msg();
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
        createTest_CPA_Status_Msg();
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
    /*******************************************************************
    Purpose: This method is used to create BPE test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_HLE_Request__c CreateBEP(){
        createTest_CPA_Status_Msg();
        CPA_HLE_Request__c objHLEREQ = new CPA_HLE_Request__c();
        //objHLEREQ.recordtypeid = label.CPA_BPE_Recordtype;
        //objHLEREQ.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;  
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