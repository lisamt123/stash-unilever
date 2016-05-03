/**********************************************************************
Name: CPA_HLERequInformationController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to check whether user entered data in all mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR             DATE            DETAIL Description
1.0         Dinesh Girasre     12/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
global with sharing class CPA_HLERequInformationController {
    Public id hleReqId;
    Public CPA_HLE_Request__c hleRec;
    Public String mandatoryStringFlag {get; set;}
    Public String estimateFlag;
    public Map<String,String> RequiredFieldMap {get; set;}
    boolean callFromVF = false;
 
    /*******************************************************************
    Purpose: This constructor calls CreateRequiredFieldMessage() methos by providing record id
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_HLERequInformationController (ApexPages.StandardController controller) {
        callFromVF = true;
        //mandatoryString = '';
        if(ApexPages.currentPage().getParameters().get('id') != null) {     
            hleReqId = ApexPages.currentPage().getParameters().get('id');
            CreateRequiredFieldMessage(hleReqId,callFromVF);           
        }
    }
     public CPA_HLERequInformationController (){}
    
    /*******************************************************************
    Purpose: This method is used to check whether all mandatory fields have data
    Parameters: hleRecId, callFromVF
    Returns: blloean
    Throws [Exceptions]: 
    ********************************************************************/
    boolean CreateRequiredFieldMessage(id hleRecId,boolean callFromVF){
        RequiredFieldMap = new Map<String,String>();
        mandatoryStringFlag = null;
        estimateFlag = null;
        hleRec = [SELECT Estimates_Status__c,pkl_Status__c, isValidated__c, dt_Date_raised__c,dt_Planned_end_date__c,dt_Planned_start_date__c,eml_AAL_Email__c,eml_UBPR_Email__c,eml_UIOS_Email__c,Id,mpkl_PFS_If_yes_what_is_the_source__c,Name,OwnerId,PFS_Is_there_approved_funding_for_this__c,ph_AAL_Contact_No__c,ph_UBPR_Contact_No__c,ph_UIOS_Contact_No__c,pkl_Business_area__c,pkl_HLE_type__c,txt_AAL_Name__c,txt_Accenture_skill_types_required__c,txt_Additional_information__c,txt_Assumptions__c,txt_Background__c,txt_Dependencies__c,txt_NA_Notes__c,txt_Project_description_specification__c,txt_Project_type__c,txt_Request_ID__c,txt_Risks_and_issues__c,txt_RQ_Query__c,txt_Software_Licensing_requirements__c,txt_Status__c,txt_Support_impact__c,txt_Technologies__c,txt_Title__c,txt_UBPR_Name__c,txt_UIOS_Name__c,txt_UL_reference__c,Estimate_Type__c,txt_BPE_Accenture_Demand_ID__c ,txt_BPE_Unilever_Demand_ID__c ,txt_BPE_Title__c ,txt_BPE_Accenture_Project_Manager__c,num_BPE_Effort_in_man_days__c,txt_BPE_Key_assumptions__c,txt_HLE_Accenture_estimated_project_char__c,txt_HLE_Accenture_reference__c,txt_HLE_Assumptions_Risks_Qualifying__c,txt_HLE_Commercial_caveats__c,ph_HLE_PB_Contact_No__c,eml_HLE_PB_Email__c,num_HLE_Estimated_man_days__c,txt_HLE_PB_Name__c,dt_HLE_Preparation_date__c,txt_HLE_Project_charging_mechanism__c, HLE_Proposed_high_level_plan_timelines__c,txt_HLE_Scope__c,txt_HLE_Skill_Resources_Blend_rate__c,txt_HLE_Solution_overview_approach__c,recordtypeid,txt_Other_Project_funding_Source__c  FROM CPA_HLE_Request__c where id =:hleRecId];
        Id HLERecordType = Schema.SObjectType.CPA_HLE_Request__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_HLE_Recordtype).getRecordTypeId();
        ID BPERecordType = Schema.SObjectType.CPA_HLE_Request__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_BPE_Recordtype).getRecordTypeId();
        
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(hleRec.pkl_Status__c);
        if(customSettingStatusMsg.HLE_Request_Status_Msg__c != null  && callFromVF){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.HLE_Request_Status_Msg__c));
        }
        if((hleRec.pkl_Status__c == 'Saved'  || !callFromVF)){
            if(hleRec.txt_Assumptions__c  == null) 
                 RequiredFieldMap.put('Assumptions',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.pkl_HLE_type__c  == null) 
                 RequiredFieldMap.put('HLE Type',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_Background__c  == null) 
                 RequiredFieldMap.put('Background',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.ph_UBPR_Contact_No__c  == null) 
                 RequiredFieldMap.put('Contact No','MANDATORY in Unilever business partner/requestor section');
            if(hleRec.ph_UIOS_Contact_No__c  == null) 
                 RequiredFieldMap.put('Contact No ','MANDATORY in Unilever innovation owner/SME section');
            if(hleRec.ph_AAL_Contact_No__c  == null) 
                 RequiredFieldMap.put('Contact No  ','MANDATORY in Accenture Area lead section');

            if(hleRec.pkl_Business_area__c  == null) 
                RequiredFieldMap.put('Business Area',CPA_ConstantsForContractingAppClasses.MANDATORY);
                                      
            if(hleRec.dt_Date_raised__c == null || hleRec.dt_Date_raised__c < system.today()) 
                 RequiredFieldMap.put('Date raised','It is Mandatory and should not be before today date');
            if(hleRec.txt_Dependencies__c  == null) 
                 RequiredFieldMap.put('Dependencies',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.eml_UBPR_Email__c  == null) 
                 RequiredFieldMap.put('Email','MANDATORY in Unilever business partner/requestor section');
            if(hleRec.eml_UIOS_Email__c  == null) 
                 RequiredFieldMap.put('Email ','MANDATORY in Unilever innovation owner/SME section');
            if(hleRec.eml_AAL_Email__c  == null) 
                 RequiredFieldMap.put('Email  ','MANDATORY in Accenture Area lead section');
            if(hleRec.txt_UBPR_Name__c  == null) 
                 RequiredFieldMap.put('Name','MANDATORY in Unilever business partner/requestor section');
            if(hleRec.txt_UIOS_Name__c  == null) 
                 RequiredFieldMap.put('Name ','MANDATORY in Unilever innovation owner/SME section');
            if(hleRec.txt_AAL_Name__c  == null) 
                 RequiredFieldMap.put('Name  ','MANDATORY in Accenture Area lead section');
            if(hleRec.dt_Planned_end_date__c  == null || hleRec.dt_Planned_end_date__c < hleRec.dt_Planned_start_date__c) 
                 RequiredFieldMap.put('Planned End Date','It is Mandatory and should not be before Planned Start Date');
            if(hleRec.dt_Planned_start_date__c  == null || hleRec.dt_Planned_start_date__c < system.today()) 
                 RequiredFieldMap.put('Planned Start Date','It is Mandatory and should not be before today date');
            if(hleRec.txt_Project_description_specification__c  == null) 
                 RequiredFieldMap.put('Project Description/Specification',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_Project_type__c  == null) 
                 RequiredFieldMap.put('Project Type',CPA_ConstantsForContractingAppClasses.MANDATORY);
            /*
            if(hleRec.txt_Request_ID__c  == null) 
                 RequiredFieldMap.put('Request ID',CPA_ConstantsForContractingAppClasses.MANDATORY);
             */
            if(hleRec.txt_Risks_and_issues__c  == null) 
                 RequiredFieldMap.put('Risks And Issues',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_Software_Licensing_requirements__c  == null) 
                 RequiredFieldMap.put('Software/Licensing Requirements',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_Support_impact__c  == null) 
                 RequiredFieldMap.put('Support Impact',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_Technologies__c  == null) 
                 RequiredFieldMap.put('Technologies',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_Title__c  == null) 
                 RequiredFieldMap.put('Title',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_UL_reference__c  == null) 
                 RequiredFieldMap.put('UL Reference',CPA_ConstantsForContractingAppClasses.MANDATORY);
             
            //jp- Adding to check funding 
            if(hleRec.PFS_Is_there_approved_funding_for_this__c  == null) 
                 RequiredFieldMap.put('Funding approved?',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.PFS_Is_there_approved_funding_for_this__c  == 'Yes' && hleRec.mpkl_PFS_If_yes_what_is_the_source__c == null ) 
                 RequiredFieldMap.put('If yes, what is the source?',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.PFS_Is_there_approved_funding_for_this__c  == 'Yes' && hleRec.mpkl_PFS_If_yes_what_is_the_source__c != null && hleRec.mpkl_PFS_If_yes_what_is_the_source__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)  &&  hleRec.txt_Other_Project_funding_Source__c == null) 
                 RequiredFieldMap.put('Other Project funding Source',CPA_ConstantsForContractingAppClasses.MANDATORY);  
            if(hleRec.txt_Other_Project_funding_Source__c != null && !hleRec.mpkl_PFS_If_yes_what_is_the_source__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)) 
                 RequiredFieldMap.put('Other Project funding Source','"Other Project funding Source" should be only entered when "Source" is Others');
             
           
        }if(hleRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED && hleRec.Estimate_Type__c == null && callFromVF){
            estimateFlag = 'Please select Estimate Type, wherther it will be High Level Estimation(HLE)/Ball Park Estimation(BPE) in Estimate Type Section';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, estimateFlag ));
        }else if(hleRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED && hleRec.Estimate_Type__c == 'BPE' && callFromVF){
            estimateFlag = 'Please submit Ball Park Estimation';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, estimateFlag ));
        }else if(hleRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED && hleRec.Estimate_Type__c == 'HLE' && callFromVF){
            estimateFlag = 'Please submit High Level Estimation';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, estimateFlag ));
        }
        if((hleRec.recordtypeid == BPERecordType && hleRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED)){
            if(hleRec.txt_BPE_Accenture_Demand_ID__c   == null)  RequiredFieldMap.put('BPE  Accenture Demand ID',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_BPE_Unilever_Demand_ID__c  == null)  RequiredFieldMap.put('BPE Unilever Demand ID',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_BPE_Title__c   == null)  RequiredFieldMap.put('BPE Title',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_BPE_Accenture_Project_Manager__c   == null)  RequiredFieldMap.put('BPE Accenture project manager',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.num_BPE_Effort_in_man_days__c   == null)  RequiredFieldMap.put('BPE Effort in man-days',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_BPE_Key_assumptions__c   == null)  RequiredFieldMap.put('BPE Key assumptions',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }else if((hleRec.recordtypeid == HLERecordType && hleRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED )){
            if(hleRec.txt_HLE_Accenture_estimated_project_char__c  == null)  RequiredFieldMap.put('HLE Accenture estimated project charge*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Accenture_reference__c  == null)  RequiredFieldMap.put('HLE Accenture reference*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Assumptions_Risks_Qualifying__c  == null)  RequiredFieldMap.put('HLE Assumption/Risks/Qualifying Info*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Commercial_caveats__c  == null)  RequiredFieldMap.put('HLE Commercial caveats*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.ph_HLE_PB_Contact_No__c  == null)  RequiredFieldMap.put('HLE Contact No*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.eml_HLE_PB_Email__c  == null)  RequiredFieldMap.put('HLE Email*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.num_HLE_Estimated_man_days__c  == null)  RequiredFieldMap.put('HLE Estimated man-days*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_PB_Name__c  == null)  RequiredFieldMap.put('HLE Name*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.dt_HLE_Preparation_date__c   == null)  RequiredFieldMap.put('HLE Preparation date*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Project_charging_mechanism__c   == null)  RequiredFieldMap.put('HLE Project charging mechanism*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.HLE_Proposed_high_level_plan_timelines__c  == null)  RequiredFieldMap.put('HLE Proposed high level plan&timelines*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Scope__c  == null)  RequiredFieldMap.put('HLE Scope*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Skill_Resources_Blend_rate__c  == null)  RequiredFieldMap.put('HLE Skill / Resources / Blend rate*',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(hleRec.txt_HLE_Solution_overview_approach__c   == null)  RequiredFieldMap.put('HLE Solution overview/approach*',CPA_ConstantsForContractingAppClasses.MANDATORY);
 
        }           

                      
        if(!RequiredFieldMap.isEmpty()){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Below fields are mandatory to Submit the record'));
            mandatoryStringFlag =  'Below field(s) are mandatory to Submit the record';
            return false;
        }
        return true;
    }
   
    /*******************************************************************
    Purpose: This webservice gets called from page. this is to refresh isValidate variable.
    Parameters: hleRecId, callFromVF
    Returns: blloean
    Throws [Exceptions]: 
    ********************************************************************/
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;
 
        CPA_HLERequInformationController obj = new CPA_HLERequInformationController();
        flag = obj.CreateRequiredFieldMessage(objId,false);
        return flag;
    } 
 
}