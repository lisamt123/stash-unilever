/*
This Helper class is used to get picklist value from schema as well as from 
custom setting. This return options according to ECC depedent and default values
as from SAP we get only starting codes and not the completed value.
To make the picklsit value user friendly and to map SAP values to field level values.


*/
public with sharing class VPM_PicklistHelper {
    
    public static final string PURCHASING_ORG = 'Purchasing Organisation';
    public static final string CASH_MGMT = 'Cash mgmnt group';
    public static final string LANGUAGE = 'Language';
    public static final string ACCOUNT_STAT = 'Account Statement';
    public static final string PAYMEMT_BLOCK = 'Payment Block';
    public static final string GROUPING_KEY = 'Grouping Key';
    public static final string SCHEMA_GRP = 'Schema Group Vendor';
    public static final string INCOTERMS_1= 'Incoterms 1';    
    public static final string PAYMENT_TERMS = 'Payment Terms';
    public static final string STANDARD_NUMBER='StandardNumber';
    public static final string INT_VERSION='InternationalVersion'; 
    public static final string TRADE_PARTNER_TYPE='TradePartnerType';
    public static final string SSI_Status ='SSI Status';    
    public static final string SOCIAL_IN_CODE_SOC ='Social Insurance Code - [Soc. Ins. Code]';
    public static final string ORDER_OPTIM_REST ='Order Optim Rest';
    public static final string INTER_CALC_INDI ='Interest Calculation Indicator';
    public static final string SHIPPING_CONDITION ='Shipping Conditions';
    public static final string TAX_JURIDICATION_CODE = 'Tax Jurisdiction Code';
    public static final string REG_ST_GRP = 'Reg. St. Grp';
    public static final string RECIPENT_TYPE = 'Type of Recipient';
    //public static final string STAND_COMM = 'Standard Communication';
    public static final string INDUSTRY = 'Industry';
    public static final string IND_WITHHOLD_TAX = 'Indicator WithHolding Tax';
    public static final string INS_KEYDATA_EXCHANGE = 'Instruction Data Exchange';
    public static final string CONF_CONTROL = 'Confirmation Control';
    public static final string MODE_OF_TRANSPORT = 'Mode Of Transport';
    
        
    /********************************************************************  
    Created By   : Piyush Mathur
    Created Date : 05th June 2016
    Last Modify  : 06th June 2016
    Description  : This method assing picklist values from custom setting.
    Return Type  : List of Options
    ********************************************************************/
    
    public static List<SelectOption> getRegionSpecificCustomSettingvalues(string ecc, string pickListName, string defaultValue){
            Map<String, VPM_RegionSpecificFields__c> settingMap = new Map<String, VPM_RegionSpecificFields__c>();
            Map<String, VPM_RegionSpecificFields__c> VPM_RegionSpecificMap = VPM_RegionSpecificFields__c.getAll();
            List<String> settingList = new List<String>();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            if(string.isNotBlank(defaultValue)) {
                options.add(new SelectOption(defaultValue,defaultValue));
            }
            for(VPM_RegionSpecificFields__c region : VPM_RegionSpecificMap.values()) {
                if(region.Region__c == ecc && region.Picklist_Name__c == pickListName && region.Picklist_Values__c !=defaultValue){
                    
                    settingMap.put(region.Picklist_Values__c,region);
                }
            }
            if(settingMap <> null && settingMap.size() > 0) {
                // sorting based on values 
                settingList.addAll(settingMap.keySet());
                settingList.sort();
                system.debug('@@ settingList' + settingList);
                if(settingList <> null && settingList.size() > 0) {         
                    for (String stateName : settingList) {
                        VPM_RegionSpecificFields__c state = settingMap.get(stateName);                        
                        options.add(new SelectOption(state.Picklist_Values__c, state.Picklist_Values__c));
                    }
                    system.debug('@@ Options' + options);
                }
            }
            return options;
        }
        
          public static List<SelectOption> getWithHoldingTaxType(string CountryCode,string defaultValue){
             Map<String, VPM_WithholdingTaxType__c> settingMap = new Map<String, VPM_WithholdingTaxType__c>();
              Map<String, VPM_WithholdingTaxType__c> VPM_WithHoldingTaxTypeMap = VPM_WithholdingTaxType__c.getAll();
               List<String> settingList = new List<String>();
               
                 List<SelectOption> options = new List<SelectOption>();
                  options.add(new SelectOption('','--None--'));
            if(string.isNotBlank(defaultValue)) {
                options.add(new SelectOption(defaultValue,defaultValue));
            }
            for(VPM_WithholdingTaxType__c TaxType : VPM_WithHoldingTaxTypeMap.values()) {
                //if(region.Region__c == ecc && region.Picklist_Name__c == pickListName && region.Picklist_Values__c !=defaultValue){
                    if(TaxType.VPM_Country__c == CountryCode)
                    settingMap.put(TaxType.VPM_WithholdingTaxType__c,TaxType);
                //}
            }
            if(settingMap <> null && settingMap.size() > 0) {
                // sorting based on values 
                settingList.addAll(settingMap.keySet());
                settingList.sort();
                system.debug('@@ settingList' + settingList);
                if(settingList <> null && settingList.size() > 0) {         
                    for (String stateName : settingList) {
                        VPM_WithholdingTaxType__c TaxType = settingMap.get(stateName);                        
                        options.add(new SelectOption(TaxType.VPM_WithholdingTaxType__c, TaxType.VPM_WithholdingTaxType__c));
                    }
                    system.debug('@@ Options' + options);
                }
            }
            return options;
            

        }

        public static List<SelectOption> VPM_WithholdingTaxCode(string CountryCode, string TaxType, string defaultValue){
             Map<String, VPM_WithholdingTaxCode__c> settingMap = new Map<String, VPM_WithholdingTaxCode__c>();
              Map<String, VPM_WithholdingTaxCode__c> VPM_WithHoldingTaxCodeMap = VPM_WithholdingTaxCode__c.getAll();
               List<String> settingList = new List<String>();
               
                 List<SelectOption> options = new List<SelectOption>();
                  options.add(new SelectOption('','--None--'));
            if(string.isNotBlank(defaultValue)) {
                options.add(new SelectOption(defaultValue,defaultValue));
            }
            for(VPM_WithholdingTaxCode__c TaxCode : VPM_WithHoldingTaxCodeMap.values()) {
                //if(region.Region__c == ecc && region.Picklist_Name__c == pickListName && region.Picklist_Values__c !=defaultValue){
                    if(TaxCode.VPM_Country__c == CountryCode && TaxCode.VPM_TaxType__c == TaxType)
                    settingMap.put(TaxCode.VPM_PickListValue__c,TaxCode);
                //}
            }
            if(settingMap <> null && settingMap.size() > 0) {
                // sorting based on values 
                settingList.addAll(settingMap.keySet());
                settingList.sort();
                system.debug('@@ settingList' + settingList);
                if(settingList <> null && settingList.size() > 0) {         
                    for (String stateName : settingList) {
                        VPM_WithholdingTaxCode__c TaxCode = settingMap.get(stateName);                        
                        options.add(new SelectOption(TaxCode.VPM_PickListValue__c, TaxCode.VPM_PickListValue__c));
                    }
                    system.debug('@@ Options' + options);
                }
            }
            return options;
            

        }
}