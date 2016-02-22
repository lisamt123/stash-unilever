public class CPA_testClass_util {
    
    public static User createTestUser (){
        User testUser;
        Profile p = [select id from profile where name='system Administrator'];
        
        testUser = new User(alias = 'u1', email='u1@unilever.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='u1@unilever.com');
        User testUser1 = [Select Id,profileid,isactive from user where profileid  =: p.Id AND isactive = true limit 1];
        return testUser1;
    
    }
    
    public static CPA_PWORF__c createTest_other_PWORF(){

      
        Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();  
        CPA_PWORF__c pworfRec = new CPA_PWORF__c();
        pworfRec.Name = 'Test->' + system.Now()+' 1';
       
       pworfRec.pkl_Status__c ='Saved' ;
       pworfRec.RecordTypeid = customSettingPworfRT.get('All').Record_type_id__c ;
        pworfRec.pkl_Business_Area__c ='Supply Chain' ;        
        pworfRec.pkl_Cost_Centre_Details__c ='ETS IT' ; 
        pworfRec.pkl_Landscape__c  ='Cordillera' ;         
        pworfRec.pkl_Request_Type__c  ='New Project' ;
        pworfRec.pkl_Pricing_Model__c ='T&M' ;                            
        pworfRec.pkl_Region__c  ='Europe' ;           
        
        pworfRec.Is_this_a_new_or_re_worked_Integration_R__c = ConstantsForContractingAppClasses.YES ;
         pworfRec.pkl_Is_this_Project_Invasive_in_nature__c =ConstantsForContractingAppClasses.YES ;
        
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
        pworfRec.Impact_if_expected_business_go_live_date__c = ConstantsForContractingAppClasses.TEST ;
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
        pworfRec.Interface_to_the_system__c  =ConstantsForContractingAppClasses.YES ;
        pworfRec.Interface_to_the_system_Detail__c = 'Interface to the system Detail'  ;
        
        
        
        
        pworfRec.pkl_Process_Office_Area_E2E__c ='Other (provide free text to enter)';
        pworfRec.txt_otherProcessOfficeAreaE2E__c ='Other Process Office area E2E'  ;
        pworfRec.mpkl_Project_Phases__c ='Plan; Analyse';
        pworfRec.txt_OtherProjectPhases__c = 'Other Project Phases'  ;            
        pworfRec.pkl_Process_Office_Area_E2E__c='Process Office Area E2E'  ;
        pworfRec.Is_Project__c  =ConstantsForContractingAppClasses.YES ;
        pworfRec.Project_Require_Data_Specific_Testing__c ='Project Require Data Specific Testing'  ;                   
        pworfRec.Is_Project_Require__c  =ConstantsForContractingAppClasses.YES ;
        pworfRec.txta_Project_Require_Performance_Testing__c  = 'Project Require Performance Testing'  ;     
        pworfRec.pkl_Project_Scale__c  ='Large Project (>2000 days)';    
        pworfRec.Role_or_System_Authorisation__c  =ConstantsForContractingAppClasses.YES;
        pworfRec.txta_Role_or_System_Authorisation_detail__c  ='Role or System Authorisation detail'  ; 
       
        pworfRec.txta_Project_Invasive_in_nature__c = 'Why Project Invasive in nature?'  ;
        

        pworfRec.Will_this_project_require_an_LOI_for_Wor__c  = ConstantsForContractingAppClasses.YES;
        pworfRec.How_many_man_days_do_you_think_you_requi__c  = 'Man Days'  ;
        pworfRec.When_do_you_require_the_Work_at_Risk_to__c  =  'When do you require the Work at Risk to'  ;
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

    public static Requirements_and_Deliverables__c createRequirementsDeliverables (CPA_PWORF__c objPWORF){
        Requirements_and_Deliverables__c objRandD = new Requirements_and_Deliverables__c();
        objRandD.Business_Process_Area_del__c= 'Business Process';
        objRandD.High_Level_Description_del__c = 'High Level Description';
        objRandD.New_or_changed_requirement_del__c = 'Changed';
        objRandD.Requirement_Type_del__c = ConstantsForContractingAppClasses.TEST;
        objRandD.PWORF_Requirement_Deliverables__c = objPWORF.id;
        objRandD.Name = ConstantsForContractingAppClasses.TEST;
        return objRandD;
    }
    
    public static Risk_Assessment_and_Mitigation__c createRiskAssessment (CPA_PWORF__c objPWORF){
        Risk_Assessment_and_Mitigation__c objRAM = new Risk_Assessment_and_Mitigation__c();
        objRAM.ltxta_Impact__c = ConstantsForContractingAppClasses.TEST;
        objRAM.ltxta_Mitigation_Action__c = ConstantsForContractingAppClasses.TEST;
        objRAM.ltxta_Probability__c = ConstantsForContractingAppClasses.TEST;
        objRAM.lkp_PWORF__c = objPWORF.Id;
        objRAM.ltxta_Risk_description__c = ConstantsForContractingAppClasses.TEST;
        objRAM.Name = ConstantsForContractingAppClasses.TEST;
        return objRAM;
    }

    public static PWORFKey_Contacts__c CreateKeyContacts(CPA_PWORF__c objPWORF){
        PWORFKey_Contacts__c objKC = new PWORFKey_Contacts__c();
        objKC.Name = ConstantsForContractingAppClasses.TEST;
        objKC.E_mail__c = ConstantsForContractingAppClasses.TEST_EMAIL;
        objKC.Telephone__c = '2371243814';
        objKC.PWORF__c = objPWORF.Id;
        
        return objKC;
    }

        
    public static CPA_PWORF__c createTest_RA_PWORF(){
      
        Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();  
        CPA_PWORF__c pworfRec = new CPA_PWORF__c();
        pworfRec.Name = 'TEST1123445678';
        pworfRec.pkl_Status__c ='Saved' ;
        pworfRec.Business_Case__c = 'Business Case';
        pworfRec.In_Scope__c='In Scope' ; 
        pworfRec.Out_of_Scope__c ='Out of Scope' ;
        pworfRec.Overall_purpose_or_function_of_the_proje__c='Overall purpose/function of the project' ;      
        pworfRec.Stakeholder_Expectations__c = 'Stakeholder Expectations' ;
        pworfRec.txta_Title__c ='Title' ;
      
        pworfRec.pkl_Business_Area__c ='Business Area' ;        
        pworfRec.pkl_Cost_Centre_Details__c ='Cost Centre Details' ;          
        pworfRec.txt_Cost_Centre__c ='Cost Centre' ;
        pworfRec.txt_ICC_Number__c ='ICC Number' ;
                  
        pworfRec.pkl_Landscape__c  ='Landscape' ;         
        pworfRec.pkl_Request_Type__c  ='Other Request Type' ;
        pworfRec.pkl_Pricing_Model__c ='Pricing Model' ;                            
        pworfRec.pkl_Region__c  ='Europe' ;           
        pworfRec.pkl_Request_Type__c ='Request Type' ;
        pworfRec.RecordTypeid = customSettingPworfRT.get('RA').Record_type_id__c ;
        pworfRec.txta_Acceptance_Criteria__c='Acceptance Criteria'  ;
        pworfRec.Analyse_sessions_expected__c='Analyse sessions expected'  ;
        pworfRec.txta_Application_infrastructure__c ='Application infrastructure'  ;
        pworfRec.txta_Business_critical_milestones__c ='Business critical milestones'  ;

        pworfRec.dt_Expected_go_live_date__c  =system.today()  ;
        pworfRec.dt_Expected_start_date__c = system.today() ;
        pworfRec.Expected_Start_Date_for_DBTD_PWO__c = system.today() ;
        pworfRec.Expected_Start_Date_for_Plan_and_Analyse__c = system.today() ;
        pworfRec.Impact_if_expected_business_go_live_date__c = ConstantsForContractingAppClasses.TEST ;
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
        pworfRec.Interface_to_the_system__c  =ConstantsForContractingAppClasses.YES ;
        pworfRec.Interface_to_the_system_Detail__c = 'Interface to the system Detail'  ;
        pworfRec.Is_Project__c  ='Is Project Require Data Specific Testing'  ;    
        pworfRec.Is_Project_Require__c   ='Is Project Require Performance Testing'  ;  
        pworfRec.Is_this_a_new_or_re_worked_Integration_R__c ='Is this a new or reworked Integration R'  ;
        pworfRec.pkl_Is_this_Project_Invasive_in_nature__c  ='Is this a new or re-worked Integration R'  ;
        pworfRec.txt_Internal_PWO_ID__c = '111111';
        
        pworfRec.pkl_Process_Office_Area_E2E__c ='Other (provide free text to enter)';
        pworfRec.txt_otherProcessOfficeAreaE2E__c ='Other Process Office area E2E'  ;
        pworfRec.mpkl_Project_Phases__c ='Other (provide free text to enter)';
        pworfRec.txt_OtherProjectPhases__c = 'Other Project Phases'  ;            
        pworfRec.pkl_Process_Office_Area_E2E__c='Process Office Area E2E'  ;
        pworfRec.Is_Project__c  =ConstantsForContractingAppClasses.YES ;
        pworfRec.Project_Require_Data_Specific_Testing__c ='Project Require Data Specific Testing'  ;                   
        pworfRec.Is_Project_Require__c  =ConstantsForContractingAppClasses.YES ;
        pworfRec.txta_Project_Require_Performance_Testing__c  = 'Project Require Performance Testing'  ;     
        pworfRec.pkl_Project_Scale__c  ='Project Scale';    
        pworfRec.Role_or_System_Authorisation__c  =ConstantsForContractingAppClasses.YES;
        pworfRec.txta_Role_or_System_Authorisation_detail__c  ='Role or System Authorisation detail'  ; 
        pworfRec.pkl_Is_this_Project_Invasive_in_nature__c =ConstantsForContractingAppClasses.YES ;
        pworfRec.txta_Project_Invasive_in_nature__c = 'Why Project Invasive in nature?'  ;
        pworfRec.Will_this_project_require_an_LOI_for_Wor__c ='Will this project require an LOI for Wor'  ;

        pworfRec.Will_this_project_require_an_LOI_for_Wor__c  = ConstantsForContractingAppClasses.YES;
        pworfRec.How_many_man_days_do_you_think_you_requi__c  = 'Man Days'  ;
        pworfRec.When_do_you_require_the_Work_at_Risk_to__c  =  'When do you require the Work at Risk to'  ;
        pworfRec.txta_Why_is_Work_at_risk_required__c  =  'Why is Work at risk required?'  ;
        pworfRec.txta_What_specific_roles_do_you_require__c  = 'What specific roles do you require?'  ;
        pworfRec.txta_ITC_Resources_Utilisation__c  = 'ITC Resources Utilisation'  ;
        pworfRec.Which_BP_Innovation_director_has_approve__c  =  'Which BP/Innovation director has approve'  ;
        
        User testUSer = createTestUser();
        pworfRec.lkp_Unilever_budget_approver__c = testUSer.id;
        pworfRec.lkp_Unilever_content_approver__c = testUSer.id;
        pworfRec.lkp_Unilever_Finance_BP_Contact__c = testUSer.id;
        pworfRec.lkp_Unilever_project_manager__c = testUSer.id; 
        
        return pworfRec;
    }   
    
    public static CPA_LOI__c createLOI (CPA_PWORF__c objPWORF){
        
        CPA_LOI__c objLOI = new CPA_LOI__c();  
        User testUSer = createTestUser();
        
        Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        PWORFKey_Contacts__c objKCs = CreateKeyContacts(objPWORF);
        insert objKCs;
        objPWORF.pkl_Status__c = 'Submitted';
        update  objPWORF;
        objPWORF.pkl_Status__c = 'Auto Accepted';
        update  objPWORF;
        
        objLOI.txt_Accenture_Project_Manager__c = ConstantsForContractingAppClasses.TEST;
      
        objLOI.pkl_Currency__c = ConstantsForContractingAppClasses.TEST;
        objLOI.num_Expense_charges_of_LOI__c = 2;
        objLOI.num_If_applicable_please_specify_the__c = 4;
        
        objLOI.dt_LOI_End_date__c = system.Today()+10;
        objLOI.dt_LOI_Start_Date__c = system.Today();
        objLOI.mpkl_Phases_covered_by_WAR__c = 'Plan; Analyse';
        objLOI.txt_PWO_number__c = 'PWO00123';
        objLOI.lkp_PWORF__c = objPWORF.Id;
        objLOI.txt_PWO_title__c = ConstantsForContractingAppClasses.TEST;
        objLOI.num_Total_value_in_being_requested_for__c = 1;
        objLOI.txt_Unilever_Clarity_ID__c = '21323';
        
        return objLOI;
        
        
        
    }
    
    public static CPA_project_work_order__c createPWO(CPA_PWORF__c objPWORF){
        CPA_project_work_order__c objPwo = new CPA_project_work_order__c();
        User testUSer = createTestUser();
        
        Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        PWORFKey_Contacts__c objKCs = CreateKeyContacts(objPWORF);
        insert objKCs;
        
        /*objPWORF.pkl_Status__c = 'Submitted';
        update  objPWORF;*/
        objPWORF.pkl_Status__c = 'Auto Accepted';
        update  objPWORF;
        
        
        
        objPwo.txt_Accenture_Project_Manager__c = ConstantsForContractingAppClasses.TEST;
        objPwo.num_Authorisation_charges__c = 100;
        objPwo.num_Authorisation_man_days__c = 100;
        objPwo.pkl_Billing_Details__c = 'Unilever Europe';
        objPwo.Comments__c = ConstantsForContractingAppClasses.TEST;
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
        objPwo.mpkl_Project_Phases__c = 'Plan; Analyse';
        objPwo.txt_PWO_number__c = 'PWO-001';
        objPwo.PWORF_ID__c = objPWORF.Id;
        objPwo.txt_PWO_title__c = 'Titke';
        objPwo.pkl_Region__c = 'Europe';
        objPwo.num_RMS_value__c = 1;
        objPwo.num_Senior_resources_man_days__c=1;
        objPwo.num_Target_Blend_Rate__c = 1;
        objPwo.num_Total_work_order_charge__c =1;
        objPwo.mpkl_Unilever_Innovation_Area__c = 'HR';
        objPwo.txt_Unilever_Project_Name__c = ConstantsForContractingAppClasses.TEST;
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

    public static CPA_CR__c createCR(CPA_project_work_order__c objPWO){
        CPA_CR__c objCR = new CPA_CR__c();
        objCR.txt_Accenture_Project_Manager__c = ConstantsForContractingAppClasses.TEST;
        objCR.num_Authorisation_charges__c = 1;
        objCR.num_Authorisation_man_days__c =1;
        objCR.mpkl_Change_Record_history__c = '2nd Change';
        objCR.txt_Change_Record_number__c = ConstantsForContractingAppClasses.TEST;
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
        objCR.txt_Other_Phase_change_record_raised__c = ConstantsForContractingAppClasses.TEST;
        objCR.txt_Other_Project_Phases__c = 'Plan, Analyse';
        objCR.pkl_Phase_change_record_raised__c = 'Plan';
        objCR.txt_Previous_Status_Value__c = ConstantsForContractingAppClasses.TEST;
        objCR.pkl_Project_Phases__c = 'Plan; Analyse';
      //  objCR.CPA_Project_Work_Order__c = objPWO.Id;
        objCR.PWO_number__c = ConstantsForContractingAppClasses.TEST;
        objCR.Region_impacted__c = 'Europe';
        objCR.num_RMS_value__c =1;
        objCR.num_Senior_resources_man_days__c =1;
        objCR.num_Target_Blend_Rate__c =1;
        objCR.txt_Title_of_change__c =ConstantsForContractingAppClasses.TEST;
        objCR.num_Total_charge_of_CR__c = 1;
        objCR.txta_Unilever_Project_Name__c = ConstantsForContractingAppClasses.TEST;
        objCR.txt_Unilever_Reference__c = ConstantsForContractingAppClasses.TEST;
        objCR.pec_Variance__c=1;
        objCR.num_Varied_Target_Blend_Rate__c =1;
        
        return objCR;
        
    }
    
    
    public static CPA_TNF__c CreateTNF(){
        CPA_PWORF__c objPWORF = createTest_other_PWORF();
        User testUSer = createTestUser();
        insert  objPWORF;
        
        Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        PWORFKey_Contacts__c objKCs = CreateKeyContacts(objPWORF);
        insert objKCs;
        
        
        CPA_project_work_order__c ObjPWO = createPWO(objPWORF);
        ObjPWO.chk_Excel_Attached__c =true;       
        objPWO.chk_PDF_Attached__c = true;
        insert ObjPWO;
        
        
       CPA_TNF__c objTNF = new CPA_TNF__c();
        objTNF.txt_Accenture_Contact__c = ConstantsForContractingAppClasses.TEST;
        objTNF.num_Actual_charges__c =1;
        objTNF.txt_Actual_effort_in_days__c =1;
        objTNF.txt_Approved_by__c = ConstantsForContractingAppClasses.TEST;
        objTNF.txt_Comments__c = ConstantsForContractingAppClasses.TEST;
        objTNF.pkl_Currency__c = 'INR';
        objTNF.dt_TD_Date_Notified__c = system.Today();
        objTNF.dt_TD_Effective_Date__c = system.Today();
        objTNF.txt_TD_Notice_Required__c = ConstantsForContractingAppClasses.TEST;
        objTNF.num_Planned_charges__c =1;
        objTNF.num_Planned_effort_in_days__c=1;
        objTNF.lkp_PWO_ID__c = ObjPWO.Id;
        objTNF.txt_PWO_number__c = '2';
        objTNF.txt_PWO_title__c = 'Title';
        objTNF.txt_Reason_for_termination__c = ConstantsForContractingAppClasses.TEST;
        objTNF.txt_Relocation_of_resources__c = ConstantsForContractingAppClasses.TEST;
        objTNF.pkl_Terminated_by__c = 'Unilever';
        objTNF.txt_TNF_ID__c = '12344';
        objTNF.txt_Unilever_Clarity_ID__c ='122133';
        objTNF.lkp_Unilever_Contact__c =testUSer.Id;
        objTNF.num_Variance_in_charges__c =1;
        objTNF.num_Variance_in_effort__c =1;
        return objTNF;


    }
    
    public static CPA_CNF__c CreateCNF(){
        CPA_PWORF__c objPWORF = createTest_other_PWORF();
        User testUSer = createTestUser();
        insert  objPWORF;
        objPWORF.pkl_Status__c = 'Accepted';
        update objPWORF;
        
        Requirements_and_Deliverables__c objRaD = createRequirementsDeliverables(objPWORF);
        insert objRaD;
        Risk_Assessment_and_Mitigation__c objRAM = createRiskAssessment(objPWORF);
        insert objRAM;
        PWORFKey_Contacts__c objKCs = CreateKeyContacts(objPWORF);
        insert objKCs;
        
        
        CPA_project_work_order__c ObjPWO = createPWO(objPWORF);
        ObjPWO.chk_Excel_Attached__c =true;       
        objPWO.chk_PDF_Attached__c = true;
        insert ObjPWO;
        ObjPWO.pkl_Status__c = 'Delivered';
        update ObjPWO;
        CPA_CNF__c objCNF = new CPA_CNF__c();
        
        objCNF.txt_Accenture_Project_Manager__c=ConstantsForContractingAppClasses.TEST;
        objCNF.num_Actual_Day_rate__c = 1;
        objCNF.num_Actual_expenses__c =1;
        objCNF.num_Actual_fees_inclusive_of_discount__c =1;
        objCNF.num_Actual_Fixed_Price_Contingency__c =1;
        objCNF.num_Actual_man_days__c =1;
        objCNF.num_Actual_PMO_tax__c =1;
        objCNF.dt_Actual_PWO_End_Date__c=system.today();
        objCNF.num_Actual_total_charges__c =1;
        objCNF.Comments__c =ConstantsForContractingAppClasses.TEST;
        objCNF.txt_CR_number__c = ConstantsForContractingAppClasses.TEST;
        objCNF.mpkl_Currency__c = 'EURO';
        objCNF.num_Planned_Day_rate__c =1;
        objCNF.num_Planned_expenses__c =1;
        objCNF.num_Planned_fees_inclusive_of_discount__c =1;
        objCNF.num_Planned_Fixed_Price_Contingency__c=1;
        objCNF.num_Planned_man_days__c=1;
        objCNF.num_Planned_PMO_tax__c=1;
        objCNF.dt_Planned_PWO_End_Date__c= system.today();
        objCNF.num_Planned_total_charges__c =1;
        objCNF.PWO_ID__c = ObjPWO.Id;
        objCNF.txt_PWO_number__c =ConstantsForContractingAppClasses.TEST;
        objCNF.txt_PWO_title__c = ConstantsForContractingAppClasses.TEST;
        objCNF.lkp_Unilever_budget_approver__c = testUSer.Id;
        objCNF.lkp_Unilever_content_approver__c = testUSer.Id;
        objCNF.num_Variance_number_in_man_days__c=1;
        objCNF.txt_Unilever_Clarity_ID__c ='1234';
        
        return objCNF;
        
    }
    
    
    public static CPA_HLE_Request__c CreateHLERequest(){
        CPA_HLE_Request__c objHLEREQ = new CPA_HLE_Request__c();
        objHLEREQ.txt_Background__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.ph_UBPR_Contact_No__c  ='123';
        objHLEREQ.ph_UIOS_Contact_No__c ='123';
        objHLEREQ.ph_AAL_Contact_No__c  ='123';
        objHLEREQ.dt_Date_raised__c  =system.Today();
        objHLEREQ.txt_Dependencies__c  =ConstantsForContractingAppClasses.TEST;
        objHLEREQ.eml_UBPR_Email__c  =ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.eml_UIOS_Email__c  =ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.eml_AAL_Email__c  =ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.txt_UBPR_Name__c = ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.txt_UIOS_Name__c  =ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.txt_AAL_Name__c  =ConstantsForContractingAppClasses.TEST_EMAIL;
        objHLEREQ.dt_Planned_end_date__c  =system.Today();
        objHLEREQ.dt_Planned_start_date__c  =system.Today();
        objHLEREQ.txt_Project_description_specification__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Project_type__c   = ConstantsForContractingAppClasses.TEST;
       // objHLEREQ.txt_Request_ID__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Risks_and_issues__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Software_Licensing_requirements__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Support_impact__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Technologies__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_Title__c  = ConstantsForContractingAppClasses.TEST;
        objHLEREQ.txt_UL_reference__c  = ConstantsForContractingAppClasses.TEST;
        
        return objHLEREQ;
        
        
        
    }
}