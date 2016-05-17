/**
    About
    -----
    Description: Class Utils
    Created for: Unilever Project
    Create date: 09/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Modified by : @AES
    Details
    -------
    This class is  : used as a global class which contains all Global Methods
                         for better maintenance

    Update History
    --------------
*/

public with sharing class Oblix_Utils {

    //private static final String PROJECT_ASSET_NAME = 'Oblix_Project_Assets__c';
    //private static final String DIGITAL = 'digital';
    //private static final String AUDIO_VISUAL = 'Audio_Visual';
    //private static final String EXPERIENTIAL = 'Experiential';
    //private static final String STATIC_IMAGERY = 'Static_Imagery';
    private static Map<String, List<String>> ms_lis_fields_in_fieldset = new  Map<String, List<String>>();
    private static Map<String, Map<String, Schema.SObjectField>> fieldsByObject = new Map<String, Map<String, Schema.SObjectField>>();



    public static Map<String, Oblix_AssetOfferingWrapper.AssetWrapper> map_of_mdm_id_to_asset;
    public static Oblix_AssetOfferingWrapper asset_offering;
    public static Id wrapper_campaign_id;

    //Used to Wrap RecordType By Object
    public static Map<string, ID> MapRecordType(String ObjectName) {

        List<RecordType> lstRecordType = new List<RecordType>();
        lstRecordType = [Select ID, SobjectType, Name, DeveloperName from RecordType where SobjectType = :ObjectName and DeveloperName != 'Admin'];
        Map<String, ID> MapRTCaseToDeveloperName = new Map<String, ID>();
        for (RecordType rec : lstRecordType) {
            MapRTCaseToDeveloperName.put(rec.DeveloperName, rec.ID);
        }

        return MapRTCaseToDeveloperName;
    }
    
    

    /********************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  This function helper retrieves all fields from fieldset 
                    of a given object
    *********************************************************************/
    public static list<string> getAllFieldsInFieldsSet (String obj_api_name, String fieldset_name){
        system.debug('## ms_lis_fields_in_fieldset' + ms_lis_fields_in_fieldset);
        if(null==ms_lis_fields_in_fieldset || (null!=ms_lis_fields_in_fieldset 
                && null==ms_lis_fields_in_fieldset.get(obj_api_name+fieldset_name))){

            List<String> li_fields = new List<String>();
            Schema.SObjectType target_type = Schema.getGlobalDescribe().get(obj_api_name);
            Schema.FieldSet field_set = target_type.getDescribe().fieldSets.getMap().get(fieldset_name);
            
            for(Schema.FieldSetMember field : field_set.getFields()) {
                li_fields.add(field.getFieldPath());
             }
            ms_lis_fields_in_fieldset.put(obj_api_name+fieldset_name,li_fields);
        }
        return ms_lis_fields_in_fieldset.get(obj_api_name+fieldset_name);
    }


    /********************************************************************
    * @author       Execloud ©
    * @date         2016-02-20
    * @description  map of field name and SObjectField for a given SObject       
    *********************************************************************/
    public static Map<String, Schema.SObjectField> fetchAllFieldsForObject(String objectType) { 
        System.debug('MARKER: '+objectType);
        sObject instance = (sObject)((Type.forName(objectType)).newInstance());
        Map<String, Schema.SObjectField> fields = instance.getSObjectType().getDescribe().fields.getMap();
        
        fieldsByObject.put(objectType, fields);
        return fields;
    }
   
    /********************************************************************
    * @author       Execloud ©
    * @date         2016-02-20
    * @description  Function to get object fields by Object name.
                    Looks up the results in cache before fetching them.        
    *********************************************************************/
    public static Map<String, Schema.SObjectField> getFieldsMapByObject(String objectType) {
        String objectTypeUpperCase = objectType.toUpperCase();
    
        if (!fieldsByObject.keySet().contains(objectTypeUpperCase)) {
            return fetchAllFieldsForObject(objectTypeUpperCase);
        }
        
        return fieldsByObject.get(objectTypeUpperCase);
    }
    /********************************************************************
    * @author       Execloud ©
    * @date         2016-02-20
    * @description  Function to get object fields by Object name.
    *********************************************************************/
    public static List<String> getfieldsByObject(String objectType) {
        List<String> lis_fields = new List<String>();
        Map<String, Schema.SObjectField> mapFields = new Map<String, Schema.SObjectField>();

        mapFields = getFieldsMapByObject(objectType);

        for (String fieldName : mapFields.keySet())
                lis_fields.add(fieldName);
        
        
        return lis_fields;
    }
    // Added by AES to get the abreviation for each sub category
    public static map<string, string> getAbreViationByRTBySubCatgForCardAssets() {

        map<string, string> mapAbreviation = new map<string, string>();

        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel+'_'+Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory, 'AV-OF');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel+'_'+Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory, 'AV-OL');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel+'_'+Label.Oblix_Lbl_UIUX_Audio_Subcategory, 'AV-AU');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel+'_'+Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory, 'AV-A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel+'_'+Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory, 'AV-CD');
        
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital+'_'+Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory, 'D-CA');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital+'_'+Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory, 'D-AR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital+'_'+Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory, 'D-AO');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital+'_'+Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory, 'D-DA');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital+'_'+Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory, 'D-S');
        
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential+'_'+Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory, 'E-A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential+'_'+Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory, 'E-O');
        
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Static_Img+'_'+Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory, 'SI-A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Static_Img+'_'+Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory, 'SI-O');
        
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stimulus_Materials+'_'+Label.Oblix_Lbl_UIUX_Stim_require_Subcategory, 'SM-R');
        
        return mapAbreviation;
    }
    // Added by AES to get the abreviation for each sub category
    public static map<string, string> getAbreViationForCardAssets() {

        map<string, string> mapAbreviation = new map<string, string>();

        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory, 'OF');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory, 'OL');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory, 'AU');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory, 'A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory, 'CD');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory, 'CA');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory, 'AR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory, 'AO');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory, 'DA');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory, 'S');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory, 'A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory, 'O');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory, 'A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory, 'O');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory, 'R');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel, 'AV');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital, 'D');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential, 'E');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Static_Img, 'SI');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stimulus_Materials, 'SM');
        
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Activity, 'ACT');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Communication_Idea, 'BCI');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_USLP, 'USLP');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_equity_development, ' BED');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Leadership_Meetings, 'BLM');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Leadership_Workshops, 'BLW');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Technical_Infrastructure, 'BTI');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Key_Presentations, 'BKP');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Status_Reports, 'SR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Global_Status_Meetings, 'GSM');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Regional_Status_Meetings, 'RSM');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Network_Co_ordination_other_agencies, 'NC');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Network_Competitive_Reviews, 'CR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Led_Training, 'BLT');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Book, 'BBK');
        
        return mapAbreviation;
    }
    
    
    //VF09 Non Campaign Items
    public static id CountrryGetId(String country_name) {
        List <MDO_Geography__c> country_to_get_id;
        country_to_get_id = [SELECT id from MDO_Geography__c WHERE name = :country_name AND (geography_type__c = 'Country' OR geography_type__c = 'Country Geography')  limit 1 ];
        // system.debug('===========Cname' + Cname);
        //system.debug('===========temp' + temp);
        if (!country_to_get_id.isEmpty()) 
        { 
            return country_to_get_id[0].id; 
        }
        else{ 
            return null; 
        }
    }

    public static list<selectOption> selectOptionSortByLabel(list<selectOption> selectOptionsToSort) {
        if (selectOptionsToSort == null || selectOptionsToSort.size() <= 1) {
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;

        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for (selectOption SO : selectOptionsToSort) {
            if (SO.getLabel() <= pivotValue.getLabel()) {
                lessSelectOption.add(SO);
            } else if (SO.getLabel() > pivotValue.getLabel()) {
                greaterSelectOption.add(SO);
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>();
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }
    
    public static List<SelectOption> setFirstValue(String value, List<SelectOption> selectedList) {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', value));
        for (SelectOption option : selectedList) {
            options.add(option);
        }
        return options;
    }

    public class CustomException extends Exception {}
    public class MissingCustomSettingException extends Exception {}


    public class AssetDetailWrapper {
        public String assetId;
        public Decimal quantity;
        public String additionalDescription;
        public Date actualDeliveryDate;
        public String assetName;
        public String location;
        public String assetTitle;
        public String projectId; 
        public String optionName;

        public AssetDetailWrapper(Oblix_Project_Assets__c asset) {
            this.assetId = asset.Id;
            this.quantity = asset.Quantity__c;
            this.additionalDescription = asset.Additional_Description__c;
            this.actualDeliveryDate = asset.Actual_Delivery_Date__c;
            this.assetName = asset.Asset_Picklist__c;
            this.location =  asset.Location__c;
            this.assetTitle = asset.Asset_Title__c;
            this.projectId = asset.Agency_Projects__c;
            this.optionName = asset.Option_Name__c;
        }
    }
    
    // Added by AES to get the Asset Name value 
    public static string getAssetName(Oblix_Project_Assets__c asset){
        if(asset.Asset_Picklist__c == null ) asset.Asset_Picklist__c = '';
        if(asset.Asset_Picklist__c == Label.Oblix_lbl_UIUX_Mobile_APP_Conceptualisation){
            asset.Asset_name__c = asset.Quantity__c+'X'+Label.Oblix_lbl_UIUX_Mob_APP_Conceptualisation;
        }else if(asset.Asset_Picklist__c == Label.Oblix_lbl_UIUX_Web_Optimisation_for_Mobile){
            asset.Asset_name__c = asset.Quantity__c+'X'+Label.Oblix_lbl_UIUX_Web_Optimisation_for_Mob;
        }else if(asset.Asset_Picklist__c.contains(Label.Oblix_lbl_UIUX_Interactive_Game_Adapt)){
            asset.Asset_name__c = asset.Quantity__c+'X'+Label.Oblix_lbl_UIUX_Interactive_Game_Adapt;
        }else if(asset.Asset_Picklist__c.contains(Label.Oblix_lbl_UIUX_Digital_Strategy_Adapt)){
            asset.Asset_name__c = asset.Quantity__c+'X'+Label.Oblix_lbl_UIUX_Digital_Strategy_Adapt;
        }else{
            asset.Asset_name__c = asset.Quantity__c+'X'+asset.Asset_Picklist__c;
        }
        return asset.Asset_name__c;
    }

    //Generic Function to exit swop and go to salesforce homepage
    public static Pagereference exitSwop(){
        Pagereference exitSwopHome = new Pagereference('/');
        return exitSwopHome.setRedirect(true);
    }

    public static Pagereference goToReportsHome(){
        Pagereference goToReportsHome = new Pagereference('/00O/o');
        return goToReportsHome.setRedirect(true);
    }



    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-02
    * @description  new implementation for retreiving record type ids
    ********************************************************************************/
    
    // get the recordTypeId based on the passed in DeveloperName and objecttype check if the map is already populated first
    private static Map<String, Map<String, RecordType>> recordTypesMap = null;
    public static RecordType getRecordType(String rtDeveloperName, String sObjType){
        if(recordTypesMap == null){
            recordTypesMap = new Map<String, Map<String, RecordType>>();
            // S.M 20160210 to avoid sonar issue, need to have a limit on the SOQL setting to 1000 to make future proof
            List<RecordType> listRecTypes = [select Id, SObjectType, DeveloperName, Name from RecordType LIMIT 1000];
            for(RecordType rt : listRecTypes){
                Map<String, RecordType> sObjectRecTypesMap = recordTypesMap.get(rt.sObjectType);
                if(sObjectRecTypesMap == null){
                    sObjectRecTypesMap = new Map<String, RecordType>();
                    recordTypesMap.put(rt.sObjectType, sObjectRecTypesMap);
                }
                sObjectRecTypesMap.put(rt.DeveloperName, rt);
            }
        }
        Map<String, RecordType> sObjectMap = recordTypesMap.get(sObjType);

        RecordType retVal = null;
        if(sObjectMap != null){
            retVal = sObjectMap.get(rtDeveloperName);
        }
        System.debug('------ ' + retVal);
        return retVal;
    }

    public static Id getRecordTypeId(String rtDeveloperName, String sObjType){

        RecordType rt = getRecordType(rtDeveloperName, sObjType);

        return rt == null ? null : rt.Id;

    }

    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-04-27
    * @description  new implementation for retreiving locale format date
    ********************************************************************************/

    public static String toLocaleDate(Datetime originalDate){
        String localeDate ='';
        localeDate = date.valueof(originalDate).format();
        return localeDate;
    }

    public static String toLocaleDate(Date originalDate){
        String localeDate ='';
        localeDate = originalDate.format();
        return localeDate;
    }

    /********************************************************************************
    *                                                                               *
    *                                  CUSTOM SETTINGS                              *
    *                                                                               *
    ********************************************************************************/

    /********************************************************************
    * @author       Execloud ©
    * @date         2016-02-18
    * @description  Retrieve all the custom settings value for Oblix_Settings__c
    *********************************************************************/
    public static Map<String,Oblix_Settings__c> oblix_settings{
        get{            
                if(NULL == oblix_settings){          
                    oblix_settings = new Map<String,Oblix_Settings__c>();
                    oblix_settings = Oblix_Settings__c.getAll();
                    System.debug(LoggingLevel.INFO, '@@ Oblix_Settings__c Custom Settings '+ oblix_settings);                                                
                }                   
            return oblix_settings;
        }
        set;       
    }

    // build a map of custom setting description and custom setting - used for mapping picklist values with value__c in the CS
    public static Map<String,Oblix_Settings__c> map_string_settings{
        get{
            if(NULL == map_string_settings){
                if (NULL == oblix_settings || (NULL != oblix_settings && oblix_settings.isEmpty())){
                    throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for oblix_settings');
                    return null;
                }
                map_string_settings = new Map<String,Oblix_Settings__c>();
                for (Oblix_Settings__c oblix_setting: oblix_settings.values()){
                    map_string_settings.put(oblix_setting.Label__c, oblix_setting);
                }
            }

        return map_string_settings;
        }
    }

    public static Decimal getOblixSettingValue(String label_value){
        Decimal d_result_value = 0;
        
        if (!map_string_settings.containsKey(label_value) || 
            (map_string_settings.containsKey(label_value) && NULL == map_string_settings.get(label_value))){
            
            throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for description: ' + label_value);
            return null;
        }


        d_result_value = Decimal.valueOf(map_string_settings.get(label_value).value__c);
        system.debug('## getting setting value: ' + label_value + ' value is: ' + d_result_value);
        return d_result_value;
    }

    public static String getOblixSettingLabel(String setting_name){
        
        if (!oblix_settings.containsKey(setting_name) || 
            (oblix_settings.containsKey(setting_name) && NULL == oblix_settings.get(setting_name))){
            
            throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for setting_name: ' + setting_name);
            return null;
        }
        return oblix_settings.get(setting_name).Label__c;
    }


    public static String getOblixSettingValueByName(String setting_name){
        
        if (!oblix_settings.containsKey(setting_name) || 
            (oblix_settings.containsKey(setting_name) && NULL == oblix_settings.get(setting_name))){
            
            throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for setting_name: ' + setting_name);
            return null;
        }
        return oblix_settings.get(setting_name).Value__c;
    }


    public static String getOblixSettingAttribute1ByValue(String label_value){
        
        if (!map_string_settings.containsKey(label_value) || 
            (map_string_settings.containsKey(label_value) && NULL == map_string_settings.get(label_value))){
            
            throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for description: ' + label_value);
            return null;
        }


        return map_string_settings.get(label_value).Attribute_1__c;
    }


    public static List<Oblix_Settings__c> getOblixSettingsListNameStartsWith(String setting_name_prefix){
        
        List<Oblix_Settings__c> matchingValues = new List<Oblix_Settings__c>();
        for (String settingName : oblix_settings.keySet()) {
            if (settingName.startsWith(setting_name_prefix)) {
                matchingValues.add(oblix_settings.get(settingName));
            }
        }
        if (matchingValues.size() == 0) {
            throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for setting_name_prefix: ' + setting_name_prefix);
            return null;
        }
        return matchingValues;
    }


    public static Map<String, Oblix_Settings__c> getOblixSettingsMapNameStartsWith(String setting_name_prefix){
        
        Map<String, Oblix_Settings__c> matchingValues = new Map<String, Oblix_Settings__c>();
        for (String settingName : oblix_settings.keySet()) {
            if (settingName.startsWith(setting_name_prefix)) {
                matchingValues.put(settingName, oblix_settings.get(settingName));
            }
        }
        if (matchingValues.keySet().size() == 0) {
            throw new MissingCustomSettingException('NO_CUSTOM_SETTING_SPECIFIED for setting_name_prefix: ' + setting_name_prefix);
            return null;
        }
        return matchingValues;
    }

    /********************************************************************************
    *                                                                               *
    *                                  CONSTANTS                                    *
    *                                                                               *
    ********************************************************************************/
    public static final String FY_PREFIX = 'FY';
    public static final String FY_SEPARATOR = '__';

    public static final String CAMPAIGN_STAGES_ALL = 'Briefing;Strategy & Planning;Creative Ideation;Creative Execution;Production';

    public static final String APPROVAL_PROCESS_NAME = 'Oblix_SOW_Approval_Process_v8';

    public static final String TOTAL_PROJECT_SCORE_CFY_FILED = 'Total_Project_Score__c';
    public static final String TOTAL_PROJECT_SCORE_PFY_FILED = 'Total_Project_Score_PFY__c';
    public static final String SOW_STATUS_APPROVED_BY_AGENCY = 'Approved';
    public static final String SOW_STATUS_AWAITING_UNILEVER_APPROVAL = 'Awaiting Unilever Approval';
    public static final String SOW_STATUS_AWAITING_AGENCY_APPROVAL = 'Awaiting Agency Approval';
    public static final String SOW_STATUS_AWAITING_AGENCY_APPROVAL_TBC = 'Pending Agency Approval';
    public static final String SOW_STATUS_REJECTED_BY_UNILEVER = 'Returned by Approver';
    public static final String SOW_STATUS_REJECTED_BY_AGENCY = 'Returned by Agency';
    public static final String SOW_STATUS_DRAFT_WITH_UNILEVER = 'Draft - with Unilever';
    public static final String SOW_STATUS_OPEN_FOR_UPDATES = 'Open for Updates';
    public static final String SOW_STATUS_FINALISED = 'Finalised';
    public static final String SOW_STATUS_CAMPAIGN_SYNC_REQUIRED = 'Campaign Sync Required';

    public static final String CAMPAIGN_STATUS_CANCELLED = 'Cancelled';
    public static final String SWOP_REPORT_FOLDER = 'SWOP Reporting';
    public static final String SWOP_DASHBOARD_REPORT_SPEND_SHARE = 'Spend_by_Investment_Priority';
    public static final String SWOP_DASHBOARD_REPORT_SPEND_FEE = 'Spend_by_Investment_Priority_Fee';
    public static final String SWOP_DASHBOARD_REPORT_NON_CAMPAIGN_FEES_CFY = 'Non_campaign_fees';
    public static final String SWOP_DASHBOARD_REPORT_CAMPAIGNS_PER_BOX = 'Box_Slavko';
    public static final String SWOP_DASHBOARD_REPORT_ASSET_MIX_PER_CATEGORY = 'Asset_mix_per_Category';

    // campaign business value picklist values
    public static final String TOTAL_TURNOVER_LT_100= 'Total turnover <€100m';
    public static final String TOTAL_TURNOVER_100_200= 'Total turnover €100-€200m';
    public static final String TOTAL_TURNOVER_200_300= 'Total turnover €200-€300m';
    public static final String TOTAL_TURNOVER_300_400= 'Total turnover €300-€400m';
    public static final String TOTAL_TURNOVER_GT_400= 'Total turnover >€400m';

    public static final String INCREMENTAL_TURNOVER_LT_10= 'Incremental turnover <10M';
    public static final String INCREMENTAL_TURNOVER_10_20= 'Incremental turnover 10M - 20M';
    public static final String INCREMENTAL_TURNOVER_20_30= 'Incremental turnover 20M - 30M';
    public static final String INCREMENTAL_TURNOVER_30_40= 'Incremental turnover 30M - 40M';
    public static final String INCREMENTAL_TURNOVER_GT_40= 'Incremental turnover >40M';

    public static final Integer MAX_SOWS_PER_CONTEXT = 1000;
    public static final Integer MAX_CAMPAIGNS_PER_CONTEXT = 200;
    public static final Integer MAX_NON_CAMPAIGNS_PER_CONTEXT = 500;
    public static final Integer MAX_ASSETS_PER_CONTEXT = 200;
    public static final Integer MAX_ATTACHMENTS_PER_CONTEXT = 10;

    public static final String JOB_PROCESS_SET_STATUS = 'Set Job Status';
    public static final String JOB_PROCESS_CLONE_SOW = 'Clone SOW';
    public static final String JOB_PROCESS_CLONE_CAMPAIGN = 'Clone Campaigns';
    public static final String JOB_PROCESS_CLONE_NON_CAMPAIGN = 'Clone Non Campaigns';
    public static final String JOB_PROCESS_CLONE_ATTACHMENTS = 'Clone Attachments';
    public static final String JOB_PROCESS_CLONE_ASSETS = 'Clone Assets';
    public static final String JOB_PROCESS_SYNC_ASSETS = 'Sync Assets';
    public static final String JOB_PROCESS_CLONE_ATTACHMENT_FLAG = 'Set Clone Attachment Flag';
    public static final String JOB_PROCESS_SET_PROCESSING_FLAG = 'Set sync job flag';
    public static final String JOB_PROCESS_RECALCULATE_FEES_PFY = 'Recalculate PFY fees using CFY calculator';

    //public static final String JOB_PROCESS_SYNC_SOW = 'Sync SOW';
    public static final String JOB_PROCESS_SYNC_ADJUST_CAMPAIGN = 'Sync Adjust Campaigns';
        

    public static final String JOB_STATUS_SYNC_REQUIRED = 'Sync Required';
    public static final String JOB_STATUS_SYNC_REQUESTED = 'Sync Requested';
    public static final String JOB_STATUS_SYNC_IN_PROGRESS = 'Sync In Progress';
    public static final String JOB_STATUS_SYNC_COMPLETED = 'Sync Completed';
    public static final String JOB_PROCESS_CAMPAIGN_SET_STATUS = 'Set Job Status';

    public static final String JOB_STATUS_CLONE_REQUESTED = 'Clone Requested';
    public static final String JOB_STATUS_CLONE_COMPLETED = 'Clone Completed';
    public static final String JOB_STATUS_CLONE_IN_PROGRESS = 'Clone In Progress';

    // type of process
    public static final String PROCESS_TYPE_INITIAL_APPROVAL = 'initial approval';
    public static final String PROCESS_TYPE_ROLLOVER = 'rollover process';
    

    // name suffix 
    public static final String NAME_SUFFIX_APPROVED = 'Approved';
    public static final String NAME_SUFFIX_LIVE = 'Live';
    public static final String NAME_SUFFIX_BFW = 'B/Fwd';
    public static final String NAME_SUFFIX_FINALISED = 'Finalised';

    /*------------------------------RECORD TYPE DEVELOPER NAMES---------------------------------*/
    public static final String RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME = getRecordType('Activity', 'Marketing_Basics__c').DeveloperName;
    public static final String RT_NON_CAMPAIGN_RESOURCE_DEV_NAME = getRecordType('Resource', 'Marketing_Basics__c').DeveloperName;


    /*------------------------------RECORD TYPE IDs---------------------------------*/
    public static final Id RT_SOW_PARENT = getRecordTypeId('ParentSowMarketing', 'Marketing_SOW__c');
    public static final Id RT_USER_PERMISSION_UNILEVER_USER = getRecordTypeId('Oblix_Unilever_User', 'Oblix_User_Permission__c');
    public static final Id RT_USER_PERMISSION_AGENCY_USER = getRecordTypeId('Oblix_Agency_User', 'Oblix_User_Permission__c');
    public static final Id RT_NON_CAMPAIGN_ACTIVITY_ID = getRecordTypeId(RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, 'Marketing_Basics__c');
    public static final Id RT_NON_CAMPAIGN_RESOURCE_ID = getRecordTypeId(RT_NON_CAMPAIGN_RESOURCE_DEV_NAME, 'Marketing_Basics__c');
    public static final Id RT_CALCULATOR_ROLE_RATE_ID = getRecordTypeId('Role_Rate', 'Oblix_Calculator__c');
    
    




    /*------------------------------LEVELS OF ACCESS---------------------------------*/
    public static final String USER_PERMISSION_APPROVER = 'Approver';
    public static final String USER_PERMISSION_READ_ONLY = 'Read Only';
    public static final String USER_PERMISSION_ACCESS_EDIT = 'Access & Edit';
    public static final String USER_PERMISSION_SUPERUSER = 'Superuser';

    /*------------------------------PERMISSION SET NAMES-----------------------------*/
    public static final String PERMISSIONSETNAME_UL1 = 'Oblix_SWOP_UL_1_V1';
    public static final String PERMISSIONSETNAME_UL2 = 'Oblix_SWOP_UL_2_V1';
    public static final String PERMISSIONSETNAME_UL3 = 'Oblix_SWOP_UL3_4_V1';
    public static final String PERMISSIONSETNAME_SUPERUSER = 'Oblix_SWOP_Super_User_V1';

    /*------------------------------CUSTOM LABELS------------------------------------*/
    public static final String OTHER_ASSET_LABEL = 'Other';

}