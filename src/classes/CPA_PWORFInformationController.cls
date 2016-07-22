/**********************************************************************
Name: CPA_PWORFInformationController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
global with sharing class CPA_PWORFInformationController {
 Public id pworfId;
 Public CPA_PWORF__c pworfRec;
 Public CPA_PWORF__c pworfRecord;
 public Map<String,String> objectMap {get; set;}
 public String mandatoryStringFlag {get; set;}   
boolean callFromVF = false;
  
    /*******************************************************************
    Purpose: Below constructor will be call from VF page
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public CPA_PWORFInformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            pworfId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(pworfId,callFromVF);         
        }
    } 
    
    /*******************************************************************
    Purpose: Below constructor will be call from webservice call
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_PWORFInformationController(){}
    
    /*******************************************************************
    Purpose: Below method will check the mandatory fields and flag message accordingly.
    Parameters: id, boolean
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    boolean CPA_Messages(id pworfRecId,boolean callFromVF){
        objectMap = new Map<String,String>();
        Id AllrecordType = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_ALL_RECORDTYPE).getRecordTypeId();
        Id RArecordType = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_RA_RECORDTYPE).getRecordTypeId();
        mandatoryStringFlag = null;
        pworfRec = [select id,pkl_Status__c,Business_Case__c,pkl_Business_Area__c ,In_Scope__c,txta_Acceptance_Criteria__c,Analyse_sessions_expected__c,Will_this_project_require_an_LOI_for_Wor__c,RecordTypeid,RecordType.name,Out_of_Scope__c,Overall_purpose_or_function_of_the_proje__c,Stakeholder_Expectations__c,txta_Title__c,txta_Application_infrastructure__c,txta_Business_critical_milestones__c,Expected_Business_Go_live_date__c,dt_Expected_go_live_date__c,dt_Expected_start_date__c,Expected_Start_Date_for_DBTD_PWO__c,Expected_Start_Date_for_Plan_and_Analyse__c,Impact_if_expected_business_go_live_date__c,Planning_sessions_expected__c,Project_Dependencies__c,Summary_of_requirements_and_deliverables__c,Travel_Arrangements__c,Who_will_support_this_service_once_live__c,pkl_Cost_Centre_Details__c,txt_Cost_Centre__c,txt_ICC_Number__c,pkl_Landscape__c,pkl_Request_Type__c,txta_Other_Request_Type__c,pkl_Pricing_Model__c,pkl_Region__c,dat_Revised_Submission_Date__c,Does_this_project_change_Core_Business_M__c,Does_this_Project_involve_Unilever_conf__c,Governance_Risk_and_Compliance__c,Has_W_R_been_discussed_with_Supplier_Per__c,Interface_to_the_system__c,Interface_to_the_system_Detail__c,Is_Project__c,Is_Project_Require__c,Is_this_a_new_or_re_worked_Integration_R__c,pkl_Is_this_Project_Invasive_in_nature__c,pkl_Process_Office_Area_E2E__c,mpkl_Project_Phases__c,pkl_Project_Scale__c,Role_or_System_Authorisation__c,txta_Project_Invasive_in_nature__c,txta_Role_or_System_Authorisation_detail__c,txta_Project_Require_Performance_Testing__c,Project_Require_Data_Specific_Testing__c,txt_OtherProjectPhases__c,txt_otherProcessOfficeAreaE2E__c,isValidated__c,txt_Role_Level_1_13__c,txt_Resource_Location__c,per_Budget_Expenses_of_Resource_Cost__c,dat_Indicative_timeline_End_date__c,dat_Indicative_timeline_Start_date__c,How_many_man_days_do_you_think_you_requi__c,When_do_you_require_the_Work_at_Risk_to__c,txta_Why_is_Work_at_risk_required__c,txta_What_specific_roles_do_you_require__c,txta_ITC_Resources_Utilisation__c,Which_BP_Innovation_director_has_approve__c ,pkl_Phases_covered_by_the_WAR__c,txta_PWO_linked_to_CR__c, eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c, eml_Unilever_Finance_BP_Contact_Email__c, txt_Unilever_Finance_BP_Contact_Name__c, txt_Unilever_Project_Manager_Name__c, eml_Unilever_Project_Manager_Email__c,txta_Project_Description__c, eml_Project_requestor_Email__c,txt_Project_requestor_Name__c from CPA_PWORF__c where id =:pworfRecId];
        
        if((pworfRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || pworfRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED || pworfRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.WITHHOLD)  || !callFromVF){

            if(pworfRec.Business_Case__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.BUSINESSCASE,CPA_ConstantsForContractingAppClasses.MANDATORY);  
            }               
            if((pworfRec.In_Scope__c ==null)){
                objectMap.put(CPA_ConstantsForContractingAppClasses.INSCOPE,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.Out_of_Scope__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.OUTOFSCOPE,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.Overall_purpose_or_function_of_the_proje__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.OVERALLPURPOSEOFPROJ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.Stakeholder_Expectations__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.STACKHOLDEREXPECTATIONS,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.txta_Title__c == null ){
                objectMap.put(CPA_ConstantsForContractingAppClasses.TITLE,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.eml_Unilever_Content_Approver_Email__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULCAEMAIL,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.txt_Unilever_Content_Approver_Name__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULCANAME,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.eml_Unilever_Budget_Approver_Email__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULBAEMAIL,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.txt_Unilever_Budget_Approver_Name__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULBANAME,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.eml_Unilever_Finance_BP_Contact_Email__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULFMEMAIL,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.txt_Unilever_Finance_BP_Contact_Name__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULFMENAME,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }

            if(pworfRec.txt_Unilever_Project_Manager_Name__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULPMENAME,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.eml_Unilever_Project_Manager_Email__c == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ULPMEMAIL,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if( pworfRec.pkl_Business_Area__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Business_Area__c ==null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.BUSINESSAREA,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }               
            if(pworfRec.txt_Cost_Centre__c != null && (pworfRec.pkl_Cost_Centre_Details__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Cost_Centre_Details__c ==null)){ 
                objectMap.put(CPA_ConstantsForContractingAppClasses.COSTCENTERDETAILS,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }               
            if(pworfRec.txt_Cost_Centre__c ==null && pworfRec.txt_ICC_Number__c ==null){  
                objectMap.put(CPA_ConstantsForContractingAppClasses.COSTCENTER,CPA_ConstantsForContractingAppClasses.MANDATORYIFICCNOISPROVIDED);
                objectMap.put(CPA_ConstantsForContractingAppClasses.ICCNUMBER,CPA_ConstantsForContractingAppClasses.MANDATORYIFCOSTCENTNOTPROVIDED);
            }           
            if(pworfRec.pkl_Landscape__c == CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Landscape__c  ==null ){ 
                objectMap.put(CPA_ConstantsForContractingAppClasses.LANDSCAPE,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }               
            if(pworfRec.pkl_Pricing_Model__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Pricing_Model__c ==null){  
                objectMap.put(CPA_ConstantsForContractingAppClasses.PRICINGMODEL,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }               
            if(pworfRec.pkl_Region__c  ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Region__c  == null){    
                objectMap.put(CPA_ConstantsForContractingAppClasses.REGION,CPA_ConstantsForContractingAppClasses.MANDATORY);           
            }
            if(pworfRec.pkl_Request_Type__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Request_Type__c ==null ){   
                objectMap.put(CPA_ConstantsForContractingAppClasses.REQUESTTYPE,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pworfRec.pkl_Request_Type__c  ==CPA_ConstantsForContractingAppClasses.OTHER && pworfRec.txta_Other_Request_Type__c  == null ){  
                objectMap.put(CPA_ConstantsForContractingAppClasses.OTHERREQUESTTYPE,CPA_ConstantsForContractingAppClasses.MANDATORYIFOTHISSELECTEDINRT); 
            }
            if(pworfRec.pkl_Request_Type__c  != null && pworfRec.pkl_Request_Type__c  != CPA_ConstantsForContractingAppClasses.OTHER && pworfRec.txta_Other_Request_Type__c  != null ){  
                objectMap.put(CPA_ConstantsForContractingAppClasses.OTHERREQUESTTYPE,CPA_ConstantsForContractingAppClasses.NOTREQUIREDWHENREQUESTTYPENOTOTHER); 
            }
            
            if(pworfRec.txta_PWO_linked_to_CR__c== null  &&  pworfRec.pkl_Request_Type__c== CPA_ConstantsForContractingAppClasses.PROJECTSCOPECHANGE){
                objectMap.put(CPA_ConstantsForContractingAppClasses.PWOLINKEDTOCR1 ,CPA_ConstantsForContractingAppClasses.MANDATORYIFRTISPSC);
            }    
            if(pworfRec.txta_Project_Description__c  == null){
                objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTDECRIPTION,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if((pworfRec.txta_Acceptance_Criteria__c==null)){
                objectMap.put(CPA_ConstantsForContractingAppClasses.ACCEPTANCECRITERIA ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if((pworfRec.txt_Project_requestor_Name__c==null)){
                objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTREQUESTORNAME ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if((pworfRec.eml_Project_requestor_Email__c==null)){
                objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTREQUESTOREMAIL ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            
            if(pworfRec.RecordTypeid == AllrecordType){
                if((pworfRec.Analyse_sessions_expected__c==null)){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.ANALYSESESSIONSEXPECTED ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.txta_Application_infrastructure__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.APPINFRASTRUCTURE ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.txta_Business_critical_milestones__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.BUCRITICALMILESTONES ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Expected_Business_Go_live_date__c  == null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.EXPBUGOLIVEDATE ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.dt_Expected_go_live_date__c  == null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.EXPECTEDGOLIVEDATE ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.dt_Expected_start_date__c == null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.EXPECTEDSTDT ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                //Dinesh added below code on 20/03/2016, to fix new UAT issue number 2 (P2)
               if(pworfRec.mpkl_Project_Phases__c != null && (pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.DESIGN) && pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.BUILD) && pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.DEPLOY) && pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.TEST)) && pworfRec.Expected_Start_Date_for_DBTD_PWO__c == null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.EXPSTDTFORDBTDPWO ,'Mandatory, when project phases contains Design,Build,Test,Deploy');
                }
               /* if(pworfRec.mpkl_Project_Phases__c != null && pworfRec.mpkl_Project_Phases__c != 'Design;Build;Test;Deploy' && pworfRec.Expected_Start_Date_for_DBTD_PWO__c != null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.EXPSTDTFORDBTDPWO ,'Mandatory, only when project phases are Design,Build,Test,Deploy');
                }*/
                if(pworfRec.mpkl_Project_Phases__c != null && (pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.PLAN) && pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.ANALYSE)) && pworfRec.Expected_Start_Date_for_Plan_and_Analyse__c == null ){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.EXPECTEDPASTARTDATE ,'Mandatory, when project phases contains Plan and Analyse');
                }
                if(pworfRec.Impact_if_expected_business_go_live_date__c == null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.IMPACTIFGOLIVEDATENOTMET ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Planning_sessions_expected__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PLANNINGSESSIONSEXPECTED ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Project_Dependencies__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTDEPENDENCIES ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Summary_of_requirements_and_deliverables__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.SUMMARYOFREQANDDEL ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Travel_Arrangements__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.TRAVELARRANGEMENTS ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Who_will_support_this_service_once_live__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.POSTGOLIVESUPPORTSERVICE ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if( pworfRec.Does_this_project_change_Core_Business_M__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Does_this_project_change_Core_Business_M__c ==null){   
                    objectMap.put(CPA_ConstantsForContractingAppClasses.COREBUMODELCHANGED ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Does_this_Project_involve_Unilever_conf__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Does_this_Project_involve_Unilever_conf__c ==null){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.THIRDPARTYULCONFDATA ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
                }
                if(pworfRec.Governance_Risk_and_Compliance__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Governance_Risk_and_Compliance__c ==null){  
                    objectMap.put(CPA_ConstantsForContractingAppClasses.GOVRISKANDCOMPLIANCE ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                                                     
                if(pworfRec.Interface_to_the_system__c  ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Interface_to_the_system__c  ==null){    
                    objectMap.put(CPA_ConstantsForContractingAppClasses.INTERFACEINTROCHANGED ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Interface_to_the_system__c  ==CPA_ConstantsForContractingAppClasses.YES && pworfRec.Interface_to_the_system_Detail__c == null ){    
                    objectMap.put(CPA_ConstantsForContractingAppClasses.INTERFACETOSYSDETAIL ,CPA_ConstantsForContractingAppClasses.MANDATORYIFINTERFACE);
                }
                if(pworfRec.Is_Project__c  ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Is_Project__c  ==null){    
                    objectMap.put(CPA_ConstantsForContractingAppClasses.DATASPECIFICTESTINGREQ ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
                }                   
                if(pworfRec.Is_Project_Require__c   ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Is_Project_Require__c   == null ){   
                    objectMap.put(CPA_ConstantsForContractingAppClasses.APPPERTESTINGNEEDED ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                if(pworfRec.Is_this_a_new_or_re_worked_Integration_R__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Is_this_a_new_or_re_worked_Integration_R__c ==null){   
                    objectMap.put(CPA_ConstantsForContractingAppClasses.NEWORREWORKEDINTREQ ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.pkl_Is_this_Project_Invasive_in_nature__c  ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Is_this_Project_Invasive_in_nature__c  ==null){    
                    objectMap.put('Is this ‘Project’ Invasive in nature?' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.pkl_Process_Office_Area_E2E__c ==CPA_ConstantsForContractingAppClasses.OTHER && pworfRec.txt_otherProcessOfficeAreaE2E__c == null ){  
                    objectMap.put(CPA_ConstantsForContractingAppClasses.OTHERPROCESSOFFICEAREAE2E ,CPA_ConstantsForContractingAppClasses.MANDATORYIFOTHISSELECTEDINPO);
                }
                if(pworfRec.pkl_Process_Office_Area_E2E__c !=null && pworfRec.pkl_Process_Office_Area_E2E__c !=CPA_ConstantsForContractingAppClasses.OTHER && pworfRec.txt_otherProcessOfficeAreaE2E__c != null ){  
                    objectMap.put(CPA_ConstantsForContractingAppClasses.OTHERPROCESSOFFICEAREAE2E ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROCESSOFFICEAREAE2EISOTHER);
                }
                if(pworfRec.mpkl_Project_Phases__c !=null && pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pworfRec.txt_OtherProjectPhases__c == null ){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.OTHERPROJECTPHASES ,CPA_ConstantsForContractingAppClasses.MANDATORYIFOTHERISSELECTEDINPP);
                }
                if(pworfRec.txt_OtherProjectPhases__c != null && !pworfRec.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.OTHERPROJECTPHASES ,CPA_ConstantsForContractingAppClasses.NOTREQUIREDWHENPROJECTPHASENOTOTHER);
                }
                if(pworfRec.pkl_Process_Office_Area_E2E__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Process_Office_Area_E2E__c ==null){    
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PROCESSOFFICEAREAE2E ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.mpkl_Project_Phases__c ==null ){  
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTPHASES ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                if(pworfRec.Is_Project__c == CPA_ConstantsForContractingAppClasses.YES && pworfRec.Project_Require_Data_Specific_Testing__c == null ){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTREQDATASPECIFICTESTING ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPRJREQDATASPTESTING);
                }                   
                if(pworfRec.Is_Project_Require__c  ==CPA_ConstantsForContractingAppClasses.YES && pworfRec.txta_Project_Require_Performance_Testing__c  == null ){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTREQPERFORMANCETESTING ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPRJREQPERFTEST);
                }                   
                if(pworfRec.pkl_Project_Scale__c  ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.pkl_Project_Scale__c  ==null){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.PROJECTSCALE ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                if(pworfRec.Role_or_System_Authorisation__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Role_or_System_Authorisation__c ==null ){   
                    objectMap.put(CPA_ConstantsForContractingAppClasses.ROLEAUTHINTRODUCEDCHANGED ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                if(pworfRec.Role_or_System_Authorisation__c  ==CPA_ConstantsForContractingAppClasses.YES&& pworfRec.txta_Role_or_System_Authorisation_detail__c  == null){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.ROLEORSYSAUTHDETAIL ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPRJROLESYSADMIN);
                }                   
                if(pworfRec.pkl_Is_this_Project_Invasive_in_nature__c ==CPA_ConstantsForContractingAppClasses.YES && pworfRec.txta_Project_Invasive_in_nature__c == null){ 
                    objectMap.put(CPA_ConstantsForContractingAppClasses.WhyProjectInvasiveInNature ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPRJISINVASIVEINNATURTE);
                }
                if(pworfRec.Will_this_project_require_an_LOI_for_Wor__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Will_this_project_require_an_LOI_for_Wor__c ==null){
                    objectMap.put(CPA_ConstantsForContractingAppClasses.WORKATRISKREQMANDATORY ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pworfRec.Will_this_project_require_an_LOI_for_Wor__c  == CPA_ConstantsForContractingAppClasses.YES){
                    if(pworfRec.How_many_man_days_do_you_think_you_requi__c  == null){
                        objectMap.put(CPA_ConstantsForContractingAppClasses.MANDAYSREQFORWAR ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.When_do_you_require_the_Work_at_Risk_to__c  == null){ 
                        objectMap.put(CPA_ConstantsForContractingAppClasses.WORKATRISKSTARTDATE ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.txta_Why_is_Work_at_risk_required__c  == null){ 
                        objectMap.put(CPA_ConstantsForContractingAppClasses.WHYISWORKATRISKREQ ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.txta_What_specific_roles_do_you_require__c  == null){ 
                        objectMap.put(CPA_ConstantsForContractingAppClasses.WHATSPECIFICROLES ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.txta_ITC_Resources_Utilisation__c  == null){ 
                        objectMap.put(CPA_ConstantsForContractingAppClasses.ITCRESOURCESUTIL ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.Which_BP_Innovation_director_has_approve__c  == null){ 
                        objectMap.put(CPA_ConstantsForContractingAppClasses.DIRECTORAPPROVEDWAR ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.pkl_Phases_covered_by_the_WAR__c  == null || pworfRec.pkl_Phases_covered_by_the_WAR__c  == 'Select'){ 
                        objectMap.put(CPA_ConstantsForContractingAppClasses.PHASESCOVEREDBYWAR ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                    if(pworfRec.Has_W_R_been_discussed_with_Supplier_Per__c ==CPA_ConstantsForContractingAppClasses.STRSELECT || pworfRec.Has_W_R_been_discussed_with_Supplier_Per__c ==null){    
                        objectMap.put(CPA_ConstantsForContractingAppClasses.HASWARBEENDISCUSSEDWITHSUPPER ,CPA_ConstantsForContractingAppClasses.MANDATORYIFPROJECTREQUIRELOI);
                    }
                }
                if(pworfRec.dt_Expected_go_live_date__c  != null && pworfRec.dt_Expected_go_live_date__c  < pworfRec.dt_Expected_start_date__c ){
                       objectMap.put(CPA_ConstantsForContractingAppClasses.EXPECTEDGOLIVEDATE,CPA_ConstantsForContractingAppClasses.EXPECTEDGOLIVEDATEVALIDATION);
                }
                Boolean user_has_permission = false;                
                List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
                for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                    string permission = psa.PermissionSet.Name;
                    if (permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPASMT)){
                        user_has_permission = true;
                        break;
                    }
                }
                if(!user_has_permission){
                    if(pworfRec.dt_Expected_go_live_date__c  != null && pworfRec.dt_Expected_go_live_date__c  < date.today() ){
                       objectMap.put(CPA_ConstantsForContractingAppClasses.EXPECTEDGOLIVEDATE,CPA_ConstantsForContractingAppClasses.EXPTGOLIVEDATENOTPASTDATE);
                    }                      
                }
            }
                   PWORFrelatedCheck(pworfRecId,pworfRec.RecordTypeid);
        }
        String strMessage = getPWORFStatus(objectMap,pworfRec.pkl_Status__c,callFromVF);
        if(callFromVF){ 
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,strMessage));
        }
        if(!objectMap.isEmpty()){ 
             mandatoryStringFlag = CPA_ConstantsForContractingAppClasses.MANDATORYFIELDSMESSAGE;
            return false;
        }  
        return true; 
    }
    
    /*******************************************************************
    Purpose: This method create message for requirement fields
    Parameters: pworfRecordId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    string getPWORFStatus(Map<String,String> objectMap,String status,boolean vfcall){
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(status); 
        CPA_Status_Msg__c customSettingStatusMsg1 = CPA_Status_Msg__c.getInstance(CPA_ConstantsForContractingAppClasses.READYTOSUBMIT);
        
        if(customSettingStatusMsg1!=null && customSettingStatusMsg1.Status_Message__c != null && vfcall && objectMap.isEmpty() && status == CPA_ConstantsForContractingAppClasses.SAVED ){
          return customSettingStatusMsg1.Status_Message__c;
        }
        else if(customSettingStatusMsg.Status_Message__c != null && vfcall  ){
             return customSettingStatusMsg.Status_Message__c;
        }
        return customSettingStatusMsg.Status_Message__c;
    }
    
    /*******************************************************************
    Purpose: This method flags message for requirement fields
    Parameters: pworfRecordId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    void PWORFrelatedCheck(id pworfRecordId,ID pworfRecordTypeid){ 
        Id RArecordType = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_RA_RECORDTYPE).getRecordTypeId();
        pworfRecord = [SELECT Id,(SELECT PWORF_Requirement_Deliverables__c FROM Requirements_and_Deliverables__r),(select id from PWORF_Key_Contact__r),(Select id from Resource_Requirement__r) FROM CPA_PWORF__c WHERE Id =:pworfRecordId];
        if(pworfRecord.Requirements_and_Deliverables__r.size()==0 ){ 
            objectMap.put(CPA_ConstantsForContractingAppClasses.REQUIREMENTSANDDELIVERABLES ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pworfRecord.PWORF_Key_Contact__r.size()==0){ 
            objectMap.put(CPA_ConstantsForContractingAppClasses.KEYCONTACTS ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pworfRecordTypeid == RArecordType && pworfRecord.Resource_Requirement__r.size()==0){
            objectMap.put(CPA_ConstantsForContractingAppClasses.RESOURCEREQUIREMENT ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }          
    }
   
    /*******************************************************************
    Purpose: This method checks whether all mandatory fields have data
    Parameters: pworfRecordId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;
        CPA_PWORFInformationController obj = new CPA_PWORFInformationController();
        flag = obj.CPA_Messages(objId,false); 
        return flag; 
    }

}