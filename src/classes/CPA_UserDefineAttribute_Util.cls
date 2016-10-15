/**********************************************************************
Name: CPA_UserDefineAttribute_Util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of User Define Attribute
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       21/04/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_UserDefineAttribute_Util{
	Public static string uniquePWOrecord = null;
    /*******************************************************************
    Purpose: This method is used to get the unique set of ID and attribute type
    Parameters:  newUDAist
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public static void duplicateAttribute(List<CPA_User_Defined_Attribute__c > newUDAist)    
    { 
		Map<ID,List<CPA_User_Defined_Attribute__c>> PWO_UDA_Map = new Map<ID,List<CPA_User_Defined_Attribute__c>>();
        Set<ID>SetPWOid = new Set<ID>();
		boolean errormsg = false;

        for(CPA_User_Defined_Attribute__c uda :newUDAist){ 
			SetPWOid.add(uda.lkp_PWO__c);
			if(uda.pkl_Attribute_Type__c != null){
				uda.Unique_value__c = uda.pkl_Attribute_Type__c + uda.txt_Other_Attribute_type__c + uda.lkp_CR__c + uda.lkp_HLE_Request__c + uda.lkp_LOI__c + uda.lkp_PWO__c + uda.lkp_PWORF__c;
			}
			//if(uda.chk_isDocusignedRecord__c) {uniquePWOrecord = uda.Type_of_COntract__c + uda.id;}
        }
		//system.debug('uniquePWOrecord>>'+uniquePWOrecord);
		for (CPA_project_work_order__c pwo : [Select id, (Select id,chk_isDocusignedRecord__c, Type_of_COntract__c from User_Defined_Attributes__r where chk_isDocusignedRecord__c = true) from CPA_project_work_order__c where id IN:SetPWOid]){
            if(pwo.User_Defined_Attributes__r != NULL && pwo.User_Defined_Attributes__r.size()>0){ 
                PWO_UDA_Map.put(pwo.ID,pwo.User_Defined_Attributes__r);  
            }
        }
        for(CPA_User_Defined_Attribute__c uda :newUDAist){
            List<CPA_User_Defined_Attribute__c>relatedAllUDA = new List<CPA_User_Defined_Attribute__c>();
            relatedAllUDA = PWO_UDA_Map.get(uda.lkp_PWO__c);
            if(relatedAllUDA !=null && relatedAllUDA.size()>0){
               errormsg = SearchForMatch(relatedAllUDA,uda.Type_of_COntract__c,uda.id);
            }
			if(errormsg){
				uda.addError('User define Docusign for this Contract is already created, So please update the same.');
			}
        }
        
    }
	/*******************************************************************
    Purpose: This method is used to get the unique set of Contract and ID
    Parameters:  newUDAist
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
	Public static boolean  SearchForMatch (List<CPA_User_Defined_Attribute__c> UDAList,String typeOFContract,ID newudaID){
        for(CPA_User_Defined_Attribute__c udaold :UDAList){
			String oldpWOString = udaold.Type_of_COntract__c;
			String pWOString = typeOFContract;
			system.debug('oldpWOString>>'+oldpWOString);
			system.debug('pWOString>>'+pWOString);
            if(pWOString != null && oldpWOString !=null && newudaID!=udaold.id && oldpWOString.equalsIgnoreCase(pWOString)){
                return true;
            }                           
        }
        return false;
    }
}