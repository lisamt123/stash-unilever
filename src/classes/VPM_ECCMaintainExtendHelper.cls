public class VPM_ECCMaintainExtendHelper {

    // List of all constant values
    final string STR_CONST_Address = 'Address';
    final string STR_CONST_BankDetails = 'BankDetails';
    final string STR_CONST_boolean = 'Boolean';
    final string STR_CONST_CIN = 'CIN';
    final string STR_CONST_CompanyData = 'CompanyData';
    final string STR_CONST_DateTime = 'DateTime';
    final string STR_CONST_Dunning = 'Dunning';
    final string STR_CONST_InternationalVersions = 'InternationalVersions';
    final string STR_CONST_MainObject = 'MainObject';
    final string STR_CONST_PurchasingData = 'PurchasingData';
    final string STR_CONST_freeText = 'Text';
    final string STR_CONST_valueWithUnderScore = 'valueWithUnderScore';
    final string STR_CONST_VAT = 'VAT';
    final string STR_CONST_WtaxType = 'WtaxType';
    final string STR_CONST_MultiPicklistValueWithUnderScore = 'MultiPicklistValueWithUnderScore';
    final string STR_CONST_COLON = '" : "';

    // All below string Represent JSON string
    Map<string,string> objectInJSON = new Map<string,string>{STR_CONST_Dunning =>'',STR_CONST_InternationalVersions =>'',STR_CONST_WtaxType =>'','Address'=>'', 'BankDetails' => '', 'CIN' =>'', 'CompanyData' => '', 'PurchasingData' =>'','MainObject'=>'','VAT'=>''};
    string valueForQuery='VPM_fieldUpdated__c, VPM_ECC__c,RecordTypeId,VPM_companyCodeMatch__c, VPM_purchasingOrgMatch__c, VPM_VendorCodeLookup__r.mdm_ID__c, VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c,VPM_VendorCodeLookup__r.mdm_vCodeSirius__c,VPM_VendorCodeLookup__r.mdm_vCodeFusion__c,VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c,VPM_AccountGroup__c,VPM_PurchasingOrg__r.Name,VPM_CompanyCode__r.VPM_CompanyCode__c';
    string  apiForCompantData = ',';
    string apiForPurchasingData=',';
    string Dunning=',';
    string valueToMatch ='';
    
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
                if(RegionalandGlobalField.VPM_parentElement__c == 'CompanyData' || RegionalandGlobalField.VPM_parentElement__c == 'WtaxType')
                    apiForCompantData=apiForCompantData+RegionalandGlobalField.VPM_ApiName__c+',';
                if(RegionalandGlobalField.VPM_parentElement__c == 'PurchasingData')
                    apiForPurchasingData=apiForPurchasingData+RegionalandGlobalField.VPM_ApiName__c+',';
                if(RegionalandGlobalField.VPM_parentElement__c == STR_CONST_Dunning)
                    Dunning =Dunning +RegionalandGlobalField.VPM_ApiName__c+',';
        }

     List<VPM_PurchasingRequests__c> vendorReuestList = Database.query('SELECT '+valueForQuery+' FROM VPM_PurchasingRequests__c  WHERE id = :VendorRequestId');
    vendorReuest = vendorReuestList[0];
    if(ECC == 'U2K2')
    vendorReuest.VPM_fieldUpdated__c =  vendorReuest.VPM_fieldUpdated__c+'VPM_ReconciliationAccount__c,VPM_CashManagementGroup__c,';
    recordType rec = [select Name, id from recordType where id=: vendorReuest.RecordTypeId limit 1];
    
    
         valueToMatch =vendorReuest.VPM_fieldUpdated__c;
    //system.debug(vendorReuest);
    if(rec.Name.containsIgnoreCase('Extend'))
    {
         if(!vendorReuest.VPM_companyCodeMatch__c)
            vendorReuest.VPM_fieldUpdated__c = vendorReuest.VPM_fieldUpdated__c +apiForCompantData;
         if(!vendorReuest.VPM_purchasingOrgMatch__c)
            vendorReuest.VPM_fieldUpdated__c = vendorReuest.VPM_fieldUpdated__c +apiForPurchasingData;
    }
    system.debug('vendorReuest.VPM_fieldUpdated__c '+vendorReuest.VPM_fieldUpdated__c);
    createJSONObject(fieldList);
    
    if(ECC == 'U2K2')
      {
      objectInJSON.put('MainObject',objectInJSON.get('MainObject')+'"ECC" :"'+vendorReuest.VPM_ECC__c+'","VendorCode" : "'+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c+'"');
       
      }
   
    else if(ECC == 'Fusion')
    {
         objectInJSON.put('MainObject',objectInJSON.get('MainObject')+'"ECC" :"'+vendorReuest.VPM_ECC__c+'","VendorCode" : "'+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeFusion__c+'","AccountGroup" :"'+vendorReuest.VPM_AccountGroup__c+'"');
    }
    else if(ECC == 'Sirius')
    {
         objectInJSON.put('MainObject',objectInJSON.get('MainObject')+'"ECC" :"'+vendorReuest.VPM_ECC__c+'","VendorCode" : "'+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeSirius__c+'","AccountGroup" :"'+vendorReuest.VPM_AccountGroup__c+'"');
    }
    else if(ECC == 'Cordillera')
    {
         objectInJSON.put('MainObject',objectInJSON.get('MainObject')+'"ECC" :"'+vendorReuest.VPM_ECC__c+'","VendorCode" : "'+vendorReuest.VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c+'","AccountGroup" :"'+vendorReuest.VPM_AccountGroup__c+'"');
    } 
    
   for(string objectName : objectInJSON.keySet())
   {

        if(objectInJSON.get(objectName) !='' && objectName != 'MainObject')
        {
            if(objectName == STR_CONST_PurchasingData)
                objectInJSON.put(STR_CONST_PurchasingData,objectInJSON.get(objectName)+ '"PurchasingOrganisation" : "'+VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_PurchasingOrg__r.Name)+'",');
            else if(objectName == STR_CONST_CompanyData)
                 objectInJSON.put(STR_CONST_CompanyData,objectInJSON.get(objectName)+ '"CompanyCode" : "'+VPM_HttpUtil.valueBeforeUnderscore(vendorReuest.VPM_CompanyCode__r.VPM_CompanyCode__c)+'", "CheckDoubleInvoices" : '+vendorReuest.VPM_CheckDoubleInvoices__c+',');
             if(objectName == STR_CONST_WtaxType)
                objectInJSON.put(STR_CONST_CompanyData,objectInJSON.get(STR_CONST_CompanyData)+ '"WtaxType" : {'+objectInJSON.get(objectName).removeEnd(',')+'},');
           else
            objectInJSON.put('MainObject',objectInJSON.get('MainObject') +',"'+objectName+'" :{ '+objectInJSON.get(objectName).removeEnd(',')+'}');
        }

    }

    system.debug('Print MainObject-----'+ '{'+objectInJSON.get(STR_CONST_WtaxType)+'}');
    
    system.debug('Print MainObject-----'+ '{'+objectInJSON.get('MainObject')+'}');
    

    return '{'+objectInJSON.get('MainObject')+'}';
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
        system.debug('field.VPM_parentElement__c '+vendorReuest.VPM_fieldUpdated__c);
           if(field.VPM_parentElement__c == STR_CONST_MainObject)
            objectInJSON.put('MainObject',objectInJSON.get('MainObject')+formatFieldToJSONProperty(field));
               // rootMaintainVendor = rootMaintainVendor+ formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_Address)
                    objectInJSON.put('Address',objectInJSON.get('Address')+formatFieldToJSONProperty(field));
            
               // Address = Address + formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_VAT)
                objectInJSON.put('VAT',objectInJSON.get('VAT')+formatFieldToJSONProperty(field));
              //  VAT = VAT + formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_BankDetails)
                objectInJSON.put('BankDetails',objectInJSON.get('BankDetails')+formatFieldToJSONProperty(field));
                //BankDetails = BankDetails + formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_CompanyData)
                 {
                 if(!field.VPM_ApiName__c.equalsignorecase('VPM_CheckDoubleInvoices__c'))
                objectInJSON.put('CompanyData',objectInJSON.get('CompanyData')+formatFieldToJSONProperty(field));
                 }
                //CompanyData = CompanyData + formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_PurchasingData)
                objectInJSON.put('PurchasingData',objectInJSON.get('PurchasingData')+formatFieldToJSONProperty(field));
                //PurchasingData = PurchasingData + formatFieldToJSONProperty(field);
            else if(field.VPM_parentElement__c == STR_CONST_CIN)
                objectInJSON.put('CIN',objectInJSON.get('CIN')+formatFieldToJSONProperty(field));
            
            else if(field.VPM_parentElement__c == STR_CONST_WtaxType)
                objectInJSON.put('WtaxType',objectInJSON.get('WtaxType')+formatFieldToJSONProperty(field));

            else if(field.VPM_parentElement__c == STR_CONST_InternationalVersions)
                objectInJSON.put(STR_CONST_InternationalVersions,objectInJSON.get(STR_CONST_InternationalVersions)+formatFieldToJSONProperty(field));
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
            JSONElement = '"'+field.VPM_JSONFieldName__c+'" : '+vendorReuest.get(field.VPM_ApiName__c)+',';
        }
        // Ajya Rawat : Condition to check field type and send free as a free text in JSON string.
        else if(field.VPM_fieldDatatype__c == STR_CONST_freeText)
        {
            if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c))))
            {
            if(field.VPM_ApiName__c == 'VPM_ReconciliationAccount__c')
            {
               Integer diff;
               String reconcilAcc = String.valueOf(vendorReuest.get(field.VPM_ApiName__c));
               if(reconcilAcc.length() < 10)
               {
                  diff = 10 - reconcilAcc.length();
                  for(Integer i=0;i<diff;i++)
                  {
                    reconcilAcc = '0'+reconcilAcc; 
                  }
               }
              JSONElement = '"'+field.VPM_JSONFieldName__c+STR_CONST_COLON+reconcilAcc+'",'; 
            }
            else
            JSONElement = '"'+field.VPM_JSONFieldName__c+STR_CONST_COLON+vendorReuest.get(field.VPM_ApiName__c)+'",'; 
            }
            else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c))
             JSONElement = '"'+field.VPM_JSONFieldName__c+'" : "",';
             else
              JSONElement = '"'+field.VPM_JSONFieldName__c+'" : null,';
        }
        // Ajya Rawat : Condition to check field type and send any underscore Value after formatting it.
        else if(field.VPM_fieldDatatype__c == STR_CONST_valueWithUnderScore)
        {
            if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c)))){
        string finalStringValue =String.valueOf(vendorReuest.get(field.VPM_ApiName__c)) ==null?'':String.valueOf(vendorReuest.get(field.VPM_ApiName__c));
            JSONElement = '"'+field.VPM_JSONFieldName__c+STR_CONST_COLON+VPM_HttpUtil.valueBeforeUnderscore(finalStringValue)+'",';   
            }
             else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c))
                JSONElement = '"'+field.VPM_JSONFieldName__c+'" : "",';
                else
              JSONElement = '"'+field.VPM_JSONFieldName__c+'" : null,';
                
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
             
            JSONElement = '"'+field.VPM_JSONFieldName__c+STR_CONST_COLON+paymentMeth.remove(' ') +'",';    
            }
             else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c))
                JSONElement = '"'+field.VPM_JSONFieldName__c+'" : "",';
                else
              JSONElement = '"'+field.VPM_JSONFieldName__c+'" : null,';
        }
        // Ajya Rawat : Condition to check field type and send any DateTime Value after formatting it.
        else if(field.VPM_fieldDatatype__c == STR_CONST_DateTime)
        {
               if(string.isNotBlank(String.valueOf(vendorReuest.get(field.VPM_ApiName__c))))
            JSONElement = '"'+field.VPM_JSONFieldName__c+STR_CONST_COLON+formatDate(String.valueOf(vendorReuest.get(field.VPM_ApiName__c)))+'",';  
             else if(valueToMatch.containsIgnoreCase(field.VPM_ApiName__c)) 
                     JSONElement = '"'+field.VPM_JSONFieldName__c+'" : "",';
                      else
              JSONElement = '"'+field.VPM_JSONFieldName__c+'" : null,';
        }
        return JSONElement;
    }
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