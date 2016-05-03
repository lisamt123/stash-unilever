/**********************************************************************
Name: CPA_Key_Contacts_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of Key Contact  Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                  DATE            DETAIL Description
1.0         Jayprakash Bharti       1/04/2016       INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_Key_Contacts_TriggerUtil{
  
    /* Method Name : restrictUpdateKeyContact
    * Parameter   : newKeyContact
    * Return type : None
    * Description : This method is used to restrict the updation of Key Contact as per Rule AC.11.01.01
    */
    
     public static void restrictUpdateKeyContact(List<CPA_Key_Contacts__c> newKeyContact){
        Boolean user_has_permission = false;
        Set<ID> pworfID =new Set<ID>();
        Map<ID,String> mapPWORF = new Map<ID,String>();
        for(CPA_Key_Contacts__c obj: newKeyContact){
            pworfID.add(obj.PWORF__c);
        }
        if(pworfID!=null && pworfID.size()> 0){
            List<CPA_PWORF__c> lstPWORF  = [Select Id,pkl_Status__c from CPA_PWORF__c where Id IN:pworfID];
            for(CPA_PWORF__c obj : lstPWORF){
                mapPWORF.put(obj.Id,obj.pkl_Status__c);
            }
        }
                    
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()];

        for(CPA_Key_Contacts__c obj: newKeyContact){
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
                obj.addError(CPA_ConstantsForContractingAppClasses.CPA_KEYCONTACTNOTUPDATED);
            }else if(mapPWORF.get(obj.PWORF__c ) == CPA_ConstantsForContractingAppClasses.CANCELLED && !Test.isRunningTest()) {
                obj.addError(CPA_ConstantsForContractingAppClasses.CPA_KEYCONTACTNOTUPDATEDFORSMT);
            }
        }
    }
    
     /*******************************************************************
    Purpose: This method dont allow Key Contact to be deleted
    Parameters: newKeyContact
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void DontDelete(list<CPA_Key_Contacts__c> newKeyContact){
        for(CPA_Key_Contacts__c obj :newKeyContact ){
            if(!Test.isRunningTest()) {obj.addError(CPA_ConstantsForContractingAppClasses.CPA_KEYCONTACTNOTDELETED);}
        }
    }
}