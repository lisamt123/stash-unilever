/**********************************************************************
Name: CPA_MandatoryFieldsUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This controller is used to over rid the new CR button, open the custom page and show only relevant 
Record types.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR         DATE            DETAIL Description
1.0         Dinesh Girase  04/03/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_MandatoryFieldsUtil{

    public static Map<String,String> RequiredFieldMap {get; set;}
    
    /*******************************************************************
    Purpose: This method is used to validate mandatory fields for given object
    Parameters: custSettingName, recordInStringForm
    Returns: Map<String,String>
    Throws [Exceptions]: 
    ********************************************************************/
    public static Map<String,String> validateMandatoryFields(String custSettingName, String recordInStringForm){
        RequiredFieldMap = new Map<String,String>();
        //String strObject = String.valueOf(recordInStringForm);
        String strObject = recordInStringForm;
        Map<String, String> dataMap = new Map<String,String>();
        //Get map from string form record, this will be used for dependent fields
        dataMap = getRecordData(strObject);
        System.debug('dataMap @@@@ ' + dataMap);
        System.debug('strObject@@@@ ' + strObject);
        CPA_LOIMandatoryMessages__c custsetLOI = null;
        //Creat map for other objects here
        List<CPA_LOIMandatoryMessages__c> mandatoryFields = null;
        if(custSettingName != null && strObject != null){
            //if(custSettingName == 'CPA_LOIMandatoryMessages__c'){
            //Get list of all mandatory fields from respective custom settings
            if(custSettingName.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.LOICUSTOMSETTING)){ 
                mandatoryFields = CPA_LOIMandatoryMessages__c.getall().values();//get from custom settings
            }
            //Iterate the list of mandatory fields
            for(Integer i = 0; i < mandatoryFields.size(); i++){
                boolean found = false;
                String fieldName = mandatoryFields[i].txt_FieldAPIName__c;
                System.debug('fieldName @@@@ ' + fieldName);
                //If field name from custom setting is not there in string form of record
                //means this field is empty. If any field is there in Select query and if its value is empty,
                //Salesforce doesnt return that field in query result.
                if(!strObject.contains(fieldName)){
                    //If dependent field is not null, then get name of its parent field. Also get value of
                    //dependent field
                    //RequiredFieldMap.put(mandatoryFields[i].txt_FieldLabel__c, mandatoryFields[i].txt_Message__c);
                    if(mandatoryFields[i].txt_DependentField__c != null && mandatoryFields[i].txt_ValueToCheck__c != null){
                        String dependentField = mandatoryFields[i].txt_DependentField__c;//mpkl_Phases_covered_by_WAR__c
                        String dependentFieldValue = mandatoryFields[i].txt_ValueToCheck__c;
                        System.debug('dependentField @@@@ - ' + dependentField + ' , dependentFieldValue - ' + dependentFieldValue);
                        //this dataMap is loaded with key-value pair from the query result. this is to get dependent fields
                        //parent fields data.
                        if(dataMap.get(dependentField.trim()) != null){
                            System.debug('dataMap.get(fieldName)@@@@ ' + dataMap.get(dependentField.trim()));//Plan
                            //if(dataMap.get(dependentField.trim()).equalsIgnoreCase(dependentFieldValue)){
                            if(dataMap.get(dependentField.trim()).equalsIgnoreCase(dependentFieldValue)){
                                RequiredFieldMap.put(mandatoryFields[i].txt_FieldLabel__c, mandatoryFields[i].txt_Message__c);
                            }
                        }
                    } else if(mandatoryFields[i].txt_DependentField__c == null){
                        RequiredFieldMap.put(mandatoryFields[i].txt_FieldLabel__c, mandatoryFields[i].txt_Message__c);
                        System.debug('Inside outer else@@@@ ' + RequiredFieldMap);
                    }
                    //for boolean fields, Salesforce keep the field name in the query output, but it is by default set to false 
                } else if(dataMap.get(fieldName.trim()).equalsIgnoreCase('false')){
                    System.debug('dataMap.get(fieldName) else @@@@ ' + dataMap.get(fieldName.trim()));
                    RequiredFieldMap.put(mandatoryFields[i].txt_FieldLabel__c, mandatoryFields[i].txt_Message__c);
                    System.debug('Inside last else@@@@ ' + RequiredFieldMap);
                }
            }
        }
        //System.debug('RequiredFieldMap@@@@ ' + RequiredFieldMap);
        return RequiredFieldMap;
    }
    
    /*******************************************************************
    Purpose: This method creates Map out of query output.
    Parameters: strToSplit
    Returns: Map<String,String>
    Throws [Exceptions]: 
    ********************************************************************/
    public static Map<String, String> getRecordData(String strToSplit){
        //String strToSplit='CPA_ClassNames__c:{LastModifiedDate=2016-03-03 13:15:10, IsDeleted=false, CreatedById=00518000000ptYQAAY, CreatedDate=2016-03-03 13:15:10, Id=a8T1800000003PTEAY, LastModifiedById=00518000000ptYQAAY, SetupOwnerId=00D180000008e54EAA, ClassNames__c=CPA_LOI_InformationController, Name=LOI, SystemModstamp=2016-03-03 13:15:10}';
        integer stInd = strToSplit.indexOf('{');
        integer endInd = strToSplit.indexOf('}');
        Map<String, String> dataMap = new Map<String, String>();
        if(stInd >=0 && endInd > 0){
            String trimedString = strToSplit.substring(stInd+1,endInd);
            if(trimedString != null){
                List<String> strSplit = trimedString.split(',');
                if(strSplit != null && strSplit.size() > 0){
                    System.debug('strSplit@@@@@@ ###### ' + strSplit);
                    List<String> datasplit = new List<String>();
                    for( Integer i = 0; i < strSplit.size(); i++ ){
                        datasplit = strSplit[i].split('=');
                        if(datasplit[0] != null && datasplit[1] != null){
                            dataMap.put(datasplit[0].trim(), datasplit[1].trim());
                        }
                    }
                    return dataMap;
                }
            }
        }
        return dataMap;
    }
}