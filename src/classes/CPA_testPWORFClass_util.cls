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
public with sharing class CPA_testPWORFClass_util {
    
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
    Purpose: This method is used to create test data for PWORF
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_PWORF__c createTest_other_PWORF(){

        //Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();
        RecordType rt =[select id,Name from RecordType where sObjectType='CPA_PWORF__c' AND Name='Other' limit 1] ;
       // CPA_PWORF_Record_type__c PWORFAllrecordtType = CPA_testCustomSettingClass_util.createTest_PWORF_All_recordtType(rt.id);
        //insert(PWORFAllrecordtType);
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
       // Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();
       RecordType rt =[select id,Name from RecordType where sObjectType='CPA_PWORF__c' AND Name='Resource Augmentation' limit 1] ;
       // CPA_PWORF_Record_type__c PWORFRArecordtType = CPA_testCustomSettingClass_util.createTest_PWORF_RA_recordtType(rt.id);
       // insert(PWORFRArecordtType);
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
    Purpose: This method is used to create Query test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/    
    public static CPA_Queries__c createTest_query(CPA_PWORF__c pworf){
    	CPA_Queries__c queryRec = new CPA_Queries__c();
        queryRec.Name = CPA_ConstantsForContractingAppClasses.TEST;
        queryRec.RTXTQuery_Description__c = CPA_ConstantsForContractingAppClasses.TEST;
        queryRec.Type_Of_Query__c = 'Query';
        queryRec.LookupPWORF_Name__c =pworf.id ;
    	return queryRec;
    }
     /*******************************************************************
    Purpose: This method is used to create Query comment test data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/    
    public static CPA_Query_comment__c createTest_queryComment(CPA_Queries__c query){
    	CPA_Query_comment__c queryComentRec = new CPA_Query_comment__c();
        queryComentRec.LookupCPA_Queries__c =query.id ;
    	return queryComentRec; 
    } 
}