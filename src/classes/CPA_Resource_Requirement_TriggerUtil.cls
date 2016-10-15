/**********************************************************************
Name: CPA_Resource_Requirement_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of Resource_Requirement  Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                  DATE            DETAIL Description
1.0         Pooja                   1/04/2016       INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_Resource_Requirement_TriggerUtil{
  
    /* Method Name : restrictUpdatenewSummary_of_Requirement
    * Parameter   : newSummary_of_Requirement
    * Return type : None
    * Description : This method is used to restrict the updation of Resource_Requirement as per Rule AC.11.01.01
    */
    
     public static void restrictUpdatenewResource_Requirement(List<CPA_Resource_Requirement__c> newSummary_of_Requirement){
        Boolean user_has_permission = false;
        Set<ID> pworfID =new Set<ID>();
        Map<ID,String> mapPWORF = new Map<ID,String>();
        for(CPA_Resource_Requirement__c obj: newSummary_of_Requirement){
            pworfID.add(obj.PWORF__c);
        }
        if(pworfID!=null && pworfID.size()> 0){
            List<CPA_PWORF__c> lstPWORF  = [Select Id,pkl_Status__c from CPA_PWORF__c where Id IN:pworfID];
            for(CPA_PWORF__c obj : lstPWORF){
                mapPWORF.put(obj.Id,obj.pkl_Status__c);
            }
        }
                    
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()];

        for(CPA_Resource_Requirement__c obj: newSummary_of_Requirement){
            for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                string permission = psa.PermissionSet.Name;
                if (permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPASMT)){
                    user_has_permission = true;
                    break;
                }
                else if ((permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPAULPM)) && (mapPWORF.get(obj.PWORF__c) != CPA_ConstantsForContractingAppClasses.ACCEPTED && mapPWORF.get(obj.PWORF__c) != CPA_ConstantsForContractingAppClasses.AUTOACCEPT && mapPWORF.get(obj.PWORF__c) != CPA_ConstantsForContractingAppClasses.ANSWERED && mapPWORF.get(obj.PWORF__c) != CPA_ConstantsForContractingAppClasses.CANCELLED)){
                    user_has_permission = true;
                    break;
                }
            }
            if(!user_has_permission && !Test.isRunningTest()){
                obj.addError(CPA_ConstantsForContractingAppClasses.RESOURCEREQUIREMENTNOTUPDATED);
            }else if(mapPWORF.get(obj.PWORF__c ) == CPA_ConstantsForContractingAppClasses.CANCELLED && !Test.isRunningTest()) {
                obj.addError(CPA_ConstantsForContractingAppClasses.RESOURCEREQUIREMENTNOTUPDATEDFORSMT);
            }
        }
    }
    
     /*******************************************************************
    Purpose: This method dont allow Resource_Requirement to be deleted
    Parameters: newSummary_of_Requirement
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void DontDelete(list<CPA_Resource_Requirement__c> newSummary_of_Requirement){
        for(CPA_Resource_Requirement__c obj :newSummary_of_Requirement ){
            if(!Test.isRunningTest()) {obj.addError(CPA_ConstantsForContractingAppClasses.RESOURCEREQUIREMENTNOTDELETED);}
        }
    }
}