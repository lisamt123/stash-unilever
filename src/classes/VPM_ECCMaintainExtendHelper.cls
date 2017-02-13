/*********************************************************************************************************
Name:  VPM_ECCMaintainExtendHelper 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  To perform search Vendor from cache, make web service callout,
          show different screen based on buisness user selected on Launch 
         screen, perform validations and save functionality.    
1. VPM_AdvancedForm

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Ajay      --              INITIAL DEVELOPMENT       Create MuleSoft payload for regional maintain.
2.0 -    Deepak    11 Nov 2016     IAVMD-2410                Create MuleSoft payload for regional extend.  
************************************************************************************************************/
public with sharing class VPM_ECCMaintainExtendHelper {

    // List of all constant values
    final static string STR_CONST_Address = 'Address';
    final static string STR_CONST_BankDetails = 'BankDetails';
    final static string STR_CONST_boolean = 'Boolean';
    final static string STR_CONST_CIN = 'CIN';
    final static string STR_CONST_CompanyData = 'CompanyData';
    final static string STR_CONST_DateTime = 'DateTime';
    final static string STR_CONST_Dunning = 'Dunning';
    final static string STR_CONST_InternationalVersions = 'InternationalVersions';
    final static string STR_CONST_MainObject = 'MainObject';
    final static string STR_CONST_PurchasingData = 'PurchasingData';
    final static string STR_CONST_freeText = 'Text';
    final static string STR_CONST_valueWithUnderScore = 'valueWithUnderScore';
    final static string STR_CONST_VAT = 'VAT';
    final static string STR_CONST_WtaxType = 'WtaxType';
    final static string STR_CONST_MultiPicklistValueWithUnderScore = 'MultiPicklistValueWithUnderScore';
    final static string STR_CONST_COLON = '////# : ////#';
    final static string STR_CONST_COLON1 ='////#';
    final static string STR_CONST_COLON2 ='////#,';
    final static string STR_CONST_Create ='Create';

    // All below string Represent JSON string
    Map<string,string> objectInJSON = new Map<string,string>{STR_CONST_Dunning =>'',STR_CONST_InternationalVersions =>'',STR_CONST_WtaxType =>'','Address'=>'', 'BankDetails' => '', STR_CONST_CIN =>'', STR_CONST_CompanyData => '', STR_CONST_PurchasingData =>'',STR_CONST_MainObject=>'','VAT'=>''};
    string valueForQuery='VPM_fieldUpdated__c,VPM_PANNumber__c, VPM_ECC__c,RecordTypeId,VPM_companyCodeMatch__c,VPM_SRVBasedVendorID__c,VPM_GRbasedIV__c,VPM_AutomaticPurchaseOrderGeneration__c,VPM_OrderingEmailAddress__c, VPM_purchasingOrgMatch__c, VPM_VendorCodeLookup__r.mdm_ID__c, VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c,VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,VPM_AccountGroup__c,VPM_PurchasingOrg__r.Name,VPM_CompanyCode__r.VPM_CompanyCode__c';
    string  apiForCompantData = ',';
    string apiForPurchasingData=',';
    string Dunning=',';
    string valueToMatch ='';
    Boolean panNumberCheck = false;
    String recordTypeName='';
    
    VPM_PurchasingRequests__c vendorReuest;


/* Created By : Ajay Rawat
   Created on : 25 Sep 2016
   Description: This method take Vendor request Id and return final JSON string for POST method.
*/
    public string VPM_ConvertMaintainVendorFieldDetailsToJSON(string VendorRequestId)
    {
        // Get all Regional Fields form custom setting
        
        string ECC =[select VPM_ECC__c from VPM_PurchasingRequests__c where id=: VendorRequestId].VPM_ECC__c;
        
        //if(ECC =='U2K2')
        //valueForQuery= valueForQuery +',VPM_ReconciliationAccount__c';
        list<VPM_listOfRegionalandGlobalField__c>  fieldList =Database.query('SELECT VPM_fieldDatatype__c, VPM_JSONFieldName__c,VPM_ApiName__c, VPM_parentElement__c,VPM_ECCRegion__c  FROM VPM_listOfRegionalandGlobalField__c WHERE  VPM_fieldType__c =\'Regional\' AND VPM_ECCRegion__c like \'%'+ECC+'%\'');
        for(VPM_listOfRegionalandGlobalField__c RegionalandGlobalField : fieldList)
        {
            // Logic to get all API name for Vendor Request Query
                if(!valueForQuery.containsIgnoreCase(RegionalandGlobalField.VPM_ApiName__c))
                {
                    valueForQuery = valueForQuery +', '+RegionalandGlobalField.VPM_ApiName__c;
                }
                if(RegionalandGlobalField.VPM_parentElement__c == STR_CONST_CompanyData || RegionalandGlobalField.VPM_parentElement__c == 'WtaxType'){
                    apiForCompantData=apiForCompantData+RegionalandGlobalField.VPM_ApiName__c+',';
                }if(RegionalandGlobalField.VPM_parentElement__c == STR_CONST_PurchasingData){
                    apiForPurchasingData=apiForPurchasingData+RegionalandGlobalField.VPM_ApiName__c+',';
                }if(RegionalandGlobalField.VPM_parentElement__c == STR_CONST_Dunning){
                    Dunning =Dunning +RegionalandGlobalField.VPM_ApiName__c+',';
                }
        }

     List<VPM_PurchasingRequests__c> vendorReuestList = Database.query('SELECT '+valueForQuery+' FROM VPM_PurchasingRequests__c  WHERE id = :VendorRequestId');
    vendorReuest = vendorReuestList[0];
    if(ECC == 'U2K2'){
    vendorReuest.VPM_fieldUpdated__c =  vendorReuest.VPM_fieldUpdated__c+'VPM_ReconciliationAccount__c,VPM_CashManagementGroup__c,';
    }
    recordType rec = [select Name, id from recordType where id=: vendorReuest.RecordTypeId limit 1];
    recordTypeName = rec.Name;
    
         valueToMatch =vendorReuest.VPM_fieldUpdated__c;
         vendorReuest.VPM_fieldUpdated__c =  vendorReuest.VPM_fieldUpdated__c+'VPM_OrderingEmailAddress__c'+'VPM_SRVBasedVendorID__c'+'VPM_GRbasedIV__c'+'VPM_AutomaticPurchaseOrderGeneration__c';
    //system.debug(vendorReuest);
    if(rec.Name.containsIgnoreCase('Extend'))
    {
         if(!vendorReuest.VPM_companyCodeMatch__c){
            vendorReuest.VPM_fieldUpdated__c = vendorReuest.VPM_fieldUpdated__c +apiForCompantData;
         }if(!vendorReuest.VPM_purchasingOrgMatch__c){
            vendorReuest.VPM_fieldUpdated__c = vendorReuest.VPM_fieldUpdated__c +apiForPurchasingData;
         }
    }
    system.debug('vendorReuest.VPM_fieldUpdated__c '+vendorReuest.VPM_fieldUpdated__c);
    createJSONObject(fieldList);
    
    if(ECC == 'U2K2')
      {
      objectInJSON.put(STR_CONST_MainObject,objectInJSON.get(STR_CONST_MainObject)+STR_CONST_COLON1+'ECC'+STR_CONST_COLON+vendorReuest.VPM_ECC__c+'////#,////#VendorCode'+STR_CONST_COLON+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c+STR_CONST_COLON1);
       
      }
   
    else if(ECC == 'Fusion')
    {
         objectInJSON.put(STR_CONST_MainObject,objectInJSON.get(STR_CONST_MainObject)+STR_CONST_COLON1+'ECC'+STR_CONST_COLON+vendorReuest.VPM_ECC__c+'////#,////#VendorCode'+STR_CONST_COLON+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeFusion__c+STR_CONST_COLON2 +STR_CONST_COLON1+'AccountGroup'+STR_CONST_COLON+vendorReuest.VPM_AccountGroup__c+STR_CONST_COLON1);
    }
    else if(ECC == 'Sirius')
    {
         objectInJSON.put(STR_CONST_MainObject,objectInJSON.get(STR_CONST_MainObject)+STR_CONST_COLON1+'ECC'+STR_CONST_COLON+vendorReuest.VPM_ECC__c+STR_CONST_COLON2+STR_CONST_COLON1+'VendorCode'+STR_CONST_COLON+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeSirius__c+STR_CONST_COLON2+STR_CONST_COLON1+'AccountGroup'+STR_CONST_COLON+vendorReuest.VPM_AccountGroup__c+STR_CONST_COLON1);
    }
    else if(ECC == 'Cordillera')
    {
         objectInJSON.put(STR_CONST_MainObject,objectInJSON.get(STR_CONST_MainObject)+STR_CONST_COLON1+'ECC'+STR_CONST_COLON+vendorReuest.VPM_ECC__c+STR_CONST_COLON2+STR_CONST_COLON1+'VendorCode'+STR_CONST_COLON+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c+STR_CONST_COLON2+STR_CONST_COLON1+'AccountGroup'+STR_CONST_COLON+vendorReuest.VPM_AccountGroup__c+STR_CONST_COLON1);
    } 
    
   for(string objectName : objectInJSON.keySet())
   {

        if(objectInJSON.get(objectName) !='' && objectName != STR_CONST_MainObject)
        {
            if(objectName == STR_CONST_PurchasingData)
            {
                objectInJSON.put(STR_CONST_PurchasingData,objectInJSON.get(objectName)+STR_CONST_COLON1+'PurchasingOrganisation'+STR_CONST_COLON+VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingOrg__r.Name)+STR_CONST_COLON2);
            }
            else if(objectName == STR_CONST_CompanyData)
            {
                 objectInJSON.put(STR_CONST_CompanyData,objectInJSON.get(objectName)+STR_CONST_COLON1+'CompanyCode'+STR_CONST_COLON+VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_CompanyCode__r.VPM_CompanyCode__c)+STR_CONST_COLON2+STR_CONST_COLON1+'CheckDoubleInvoices'+STR_CONST_COLON1+' : '+vendorReuest.VPM_CheckDoubleInvoices__c+',');
            }
            else if(objectName == STR_CONST_CIN)
            {    
                if(panNumberCheck)
                {
                objectInJSON.put(STR_CONST_CIN,objectInJSON.get(objectName));
                }
                else
                {
                String PanNumberVal = String.valueOf(vendorReuest.VPM_PANNumber__c) ==null?'':vendorReuest.VPM_PANNumber__c;    
                objectInJSON.put(STR_CONST_CIN,objectInJSON.get(objectName)+ STR_CONST_COLON1+'PANNumber'+STR_CONST_COLON+PanNumberVal+STR_CONST_COLON2);
                }
            }
            if(objectName == STR_CONST_WtaxType)
            {
                objectInJSON.put(STR_CONST_CompanyData,objectInJSON.get(STR_CONST_CompanyData)+ STR_CONST_COLON1+'WtaxType'+STR_CONST_COLON1+' : {'+objectInJSON.get(objectName).removeEnd(',')+'},');
            }
           else
           {
            objectInJSON.put(STR_CONST_MainObject,objectInJSON.get(STR_CONST_MainObject) +','+STR_CONST_COLON1+objectName+STR_CONST_COLON1+' :{ '+objectInJSON.get(objectName).removeEnd(',')+'}');
           }
        }
    }

    system.debug('Print MainObject-----'+ '{'+objectInJSON.get(STR_CONST_WtaxType)+'}');
    
    system.debug('Print MainObject-----'+ '{'+objectInJSON.get(STR_CONST_MainObject)+'}');
    string addEscapeCharacter = objectInJSON.get(STR_CONST_MainObject);
    addEscapeCharacter = addEscapeCharacter.replace('\\','\\\\');
     addEscapeCharacter = addEscapeCharacter.replace('"','\\"');
      addEscapeCharacter = addEscapeCharacter.replace('\r\n','\\r\\n');
     addEscapeCharacter = addEscapeCharacter.replace('////#','"');
    return '{'+addEscapeCharacter+'}';
    }

/* Created By : Ajay Rawat
   Created on : 25 Sep 2016
   Description: This method take list of VPM_listOfRegionalandGlobalField record and format it into complete JSON object.
*/
   public void createJSONObject(list<VPM_listOfRegionalandGlobalField__c> fieldList)
   {
    for(VPM_listOfRegionalandGlobalField__c field : fieldList)
    {
   //system.debug('field.VPM_ApiName__c '+field.VPM_ApiName__c);
        if(vendorReuest.VPM_fieldUpdated__c.containsIgnoreCase(field.VPM_ApiName__c))
        {
        //system.debug('field.VPM_parentElement__c '+vendorReuest.VPM_fieldUpdated__c);
           if(field.VPM_parentElement__c == STR_CONST_MainObject){
            objectInJSON.put(STR_CONST_MainObject,objectInJSON.get(STR_CONST_MainObject)+formatFieldToJSONProperty(field));
               // rootMaintainVendor = rootMaintainVendor+ formatFieldToJSONProperty(field);
            }else if(field.VPM_parentElement__c == STR_CONST_Address){
                    objectInJSON.put('Address',objectInJSON.get('Address')+formatFieldToJSONProperty(field));
            
               // Address = Address + formatFieldToJSONProperty(field);
            }else if(field.VPM_parentElement__c == STR_CONST_VAT){
                objectInJSON.put('VAT',objectInJSON.get('VAT')+formatFieldToJSONProperty(field));
              //  VAT = VAT + formatFieldToJSONProperty(field);
            }else if(field.VPM_parentElement__c == STR_CONST_BankDetails){
                objectInJSON.put('BankDetails',objectInJSON.get('BankDetails')+formatFieldToJSONProperty(field));
                //BankDetails = BankDetails + formatFieldToJSONProperty(field);
            }else if(field.VPM_parentElement__c == STR_CONST_CompanyData)
                 {
                 if(!field.VPM_ApiName__c.equalsignorecase('VPM_CheckDoubleInvoices__c'))
                 {
                    objectInJSON.put(STR_CONST_CompanyData,objectInJSON.get(STR_CONST_CompanyData)+formatFieldToJSONProperty(field));
                 }
                 }
                //CompanyData = CompanyData + formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_PurchasingData){
                objectInJSON.put(STR_CONST_PurchasingData,objectInJSON.get(STR_CONST_PurchasingData)+formatFieldToJSONProperty(field));
                //PurchasingData = PurchasingData + formatFieldToJSONProperty(field);
            }else if(field.VPM_parentElement__c == STR_CONST_CIN){
                if(!field.VPM_ApiName__c.equalsignorecase('VPM_PANNumber__c'))
                {
                objectInJSON.put(STR_CONST_CIN,objectInJSON.get(STR_CONST_CIN)+formatFieldToJSONProperty(field));
                }
                else
                {
                  panNumberCheck=true;
                  objectInJSON.put(STR_CONST_CIN,objectInJSON.get(STR_CONST_CIN)+formatFieldToJSONProperty(field));
                }
            
            }else if(field.VPM_parentElement__c == STR_CONST_WtaxType){
                objectInJSON.put('WtaxType',objectInJSON.get('WtaxType')+formatFieldToJSONProperty(field));

            }else if(field.VPM_parentElement__c == STR_CONST_InternationalVersions){
                objectInJSON.put(STR_CONST_InternationalVersions,objectInJSON.get(STR_CONST_InternationalVersions)+formatFieldToJSONProperty(field));
            }
        }
    }
   }

/* Created By : Ajay Rawat
   Created on : 25 Sep 2016
   Description: This method take VPM_listOfRegionalandGlobalField record as a parameter and convert it into JSON format.
*/
    public string formatFieldToJSONProperty(VPM_listOfRegionalandGlobalField__c field)
    {
        string JSONElement='';
        
        // Ajya Rawat : Condition to check field type and send boolean as a boolean in JSON string.
        if(field.VPM_fieldDatatype__c == STR_CONST_boolean)
        {
            JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON1+': '+vendorReuest.get(field.VPM_ApiName__c)+',';
        }
        // Ajya Rawat : Condition to check field type and send free as a free text in JSON string.
        else if(field.VPM_fieldDatatype__c == STR_CONST_freeText)
        {
            //system.debug('hreee='+vendorReuest.get(field.VPM_ApiName__c));
            if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c))))
            {
            if(field.VPM_ApiName__c == 'VPM_ReconciliationAccount__c')
            {
               
               String reconcilAcc = String.valueOf(vendorReuest.get(field.VPM_ApiName__c));
               
               if(reconcilAcc.length() < 10)
               {
                  Integer diff = 10 - reconcilAcc.length();
                  for(Integer i=0;i<diff;i++)
                  {
                    reconcilAcc = '0'+reconcilAcc; 
                  }
               }
              JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+reconcilAcc+STR_CONST_COLON2; 
            }
            else
            {
            JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+vendorReuest.get(field.VPM_ApiName__c)+STR_CONST_COLON2; 
            }
            }
            else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c)&& !recordTypeName.containsIgnoreCase(STR_CONST_Create))
            {
             JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+STR_CONST_COLON2;
            }
             else if(!recordTypeName.containsIgnoreCase(STR_CONST_Create))
             {
              JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON1+': null,';
              }
        }
        // Ajya Rawat : Condition to check field type and send any underscore Value after formatting it.
        else if(field.VPM_fieldDatatype__c == STR_CONST_valueWithUnderScore)
        {
            if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c)))){
        string finalStringValue =String.valueOf(vendorReuest.get(field.VPM_ApiName__c)) ==null?'':String.valueOf(vendorReuest.get(field.VPM_ApiName__c));
            JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+VPM_HttpUtil.valueBeforeUnderscore(finalStringValue)+STR_CONST_COLON2;   
            }
             else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c) && !recordTypeName.containsIgnoreCase(STR_CONST_Create))
             {
                JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+STR_CONST_COLON2;
             }
              else if(!recordTypeName.containsIgnoreCase(STR_CONST_Create))
              {
              JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON1+': null,';
              }
                
        }
        else if(field.VPM_fieldDatatype__c == STR_CONST_MultiPicklistValueWithUnderScore)
        {
            if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c)))){
            string finalStringValue =String.valueOf(vendorReuest.get(field.VPM_ApiName__c)) ==null?'':String.valueOf(vendorReuest.get(field.VPM_ApiName__c));
           string payMeth = finalStringValue.remove('[');
            string payMeth1 = payMeth.remove(']');
           // string payMeth2 = payMeth1.remove('null').trim();
            // system.debug('kkk='+payMeth2);
             List<string> finalStringValueList = payMeth1.split(',');
             string paymentMeth='';
             for(String str:finalStringValueList)
             {
                 paymentMeth += VPM_HttpUtil.valueBeforeUnderscore(str);
             }
             
            JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+paymentMeth.remove(' ') +STR_CONST_COLON2;    
            }
             else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c)&& !recordTypeName.containsIgnoreCase(STR_CONST_Create))
             {
                JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+STR_CONST_COLON2;
            }
             else if( !recordTypeName.containsIgnoreCase(STR_CONST_Create))
             {
              JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON1+': null,';
              }
        }
        // Ajya Rawat : Condition to check field type and send any DateTime Value after formatting it.
        else if(field.VPM_fieldDatatype__c == STR_CONST_DateTime)
        {
               if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c))))
               {
            JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+formatDate(String.valueOf(vendorReuest.get(field.VPM_ApiName__c)))+STR_CONST_COLON2; 
                }
             else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c)&& !recordTypeName.containsIgnoreCase(STR_CONST_Create))
                {
                     JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON+STR_CONST_COLON2;
                }
                else if(!recordTypeName.containsIgnoreCase(STR_CONST_Create))
                {
                 JSONElement = STR_CONST_COLON1+field.VPM_JSONFieldName__c+STR_CONST_COLON1+': null,';
                }
        }
        return JSONElement;
    }
    
/* Created By : Deepak
   Created on : 25 Sep 2016
   Description: Formt DateTime field into mm-dd-yyyy.
*/
      public string formatDate(string dt)
    {
    List<string> formatedDate = new List<String>();
    try{
    system.debug('Date '+dt);
    formatedDate = dt.split(' ');
        }
        catch(exception ex){
         system.debug('Error has been occured');
        }
        system.debug('formatedDate='+formatedDate);
        return formatedDate[0];
        
    }
}