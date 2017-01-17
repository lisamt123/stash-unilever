global with sharing class MyMetaDataRemoteActionExtension {

    private static String className = String.valueOf(MyMetaDataRemoteActionExtension.class);
    global MyMetaDataRemoteActionExtension(ApexPages.StandardController ctr) { } //empty controller

    @RemoteAction
    global static String getLoggingConfig () {
        List<item> l = new List<item>();
        item i = new item('info', 'MyTestStream', 'raw');
        l.add(i);
        String str = JSON.serialize(l);
        system.debug('getLoggingConfig.result: '+str);
        return str;
    }

    @RemoteAction
    global  static BoMetaData getMetaLOSFMetaData(String txId, String businessObject, String sfObject, boolean isExternal) {
        return getMetaData(txId, businessObject, sfObject, isExternal);
    }

    /** This method return the object metadata to the Smart UI
     *  @param txId  GUI id for each transcation done from Smart UI
     *  @param businessObject BusinessObject name
     *  @param sfObject Name of the object on Salesforce
     *  @param isExternal True if the object is not on Salesforce or have additional parameters not in salesforce
     *  @return BoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData getMetaData(String txId, String businessObject, String sfObject, boolean isExternal){
        BoMetaData result = new BoMetaData() ;
        try {
/*            
            if (!isExternal) { // check if the object is external or SF object
                
                List<Field> resList = new List<Field>();
                SObjectType objType = Schema.getGlobalDescribe().get(sfObject); 
                Map<String,Schema.SObjectField> fieldsMap = objType.getDescribe().fields.getMap(); 
                
                for (Schema.SObjectField ft : fieldsMap.values()) {
                    Schema.DescribeFieldResult fd = ft.getDescribe();
                    Field f = new Field(fd.getName(), fd.getLabel(), fd.getPicklistValues(), fd.getType().name(), ! fd.isNillable());
                    resList.add(f);
                }
                result.fields = resList;
            } else {
                // if external object check wich external object is and call the specific method 
                
                if (businessObject == 'LOExtPrdFilters') {
                    result = LOExtPrdFilters();
                } else if (businessObject ==' LOFund') {
                    result = LOFund();
                } else if (businessObject == 'LOExtChartValues') {
                    result = LOExtChartValues();
                } else if (businessObject == 'LOExtProduct'){
                    result = LOExtProduct();
                } else if (businessObject == 'LOExtHoverContent'){
                    result = LOExtHoverContent();
                } else if (businessObject == 'LOCalPromotions'){
                    result = LOCalPromotions();
                } else if (businessObject == 'LOCalendarView'){
                    result = LOCalendarView();
                } else if (businessObject == 'LOExtFiscalYear'){
                    result = LOExtFiscalYear();
                }        
            }  
*/
                if (sfObject!=null) {
                    Schema.SObjectType objType = Schema.getGlobalDescribe().get(sfObject);
                    result = MyMetaDataRemoteActionExtension.getMetaDataObject(txId, businessObject, objType, isExternal);
                } else {
                    result = MyMetaDataRemoteActionExtension.getMetaDataObject(txId, businessObject, null, isExternal);
                }                       
        } finally {
        }
        system.debug('getMetaDataResult: '+result);
        return result;
    }

   /** Class returned by getMetaDataList with the metadata of the objects requested    */
    global class BoMetaDataOutput {
        global String businessObject;
        global String sfObject;
        global BoMetaData fields;
    }

   /** Class passed as input parameter with JSON format to getMetaDataList with the objects requested    */
    global class BoMetaDataInput {
        String businessObject;
        String sfObject;
        boolean isExternal;
    }

     /** This method return the object metadata to the Smart UI
     *  @param txId  GUI id for each transaction done from Smart UI
     *  @param inputDataJSON List of BoMetaDataInput
     *  @return List<BoMetaDataOutput> Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static List<BoMetaDataOutput> getMetaDataList(String txId, String inputDataJSON) {

        System.debug('MyMetaDataRemoteActionExtension.getMetaDataList: Start time: ' + System.now());
        System.debug('MyMetaDataRemoteActionExtension.getMetaDataList: Begin txId: ' + txId + ', inputData: ' + inputDataJSON);
        List<BoMetaDataInput> inputDataList = (List<BoMetaDataInput>) JSON.deserialize(inputDataJSON, List<BoMetaDataInput>.class);      
        List<BoMetaDataOutput> resultList = new List<BoMetaDataOutput>();

        Map<String, Schema.SObjectType> objType = Schema.getGlobalDescribe(); // get SObjectType of the SF Object   
            
        for (BoMetaDataInput inputData : inputDataList) {

            BoMetaDataOutput result  = new BoMetaDataOutput();
            result.businessObject = inputData.businessObject;
            result.sfObject = inputData.sfObject;

            if (inputData.sfObject!=null) {
                result.fields = MyMetaDataRemoteActionExtension.getMetaDataObject(txId, inputData.businessObject, objType.get(inputData.sfObject), inputData.isExternal);
            } else {
                result.fields = MyMetaDataRemoteActionExtension.getMetaDataObject(txId, inputData.businessObject, null, inputData.isExternal);
            }
            resultList.add(result);
        }
        
        return resultList;
    }

    private static BoMetaData getMetaDataObject(String txId, String businessObject, Schema.SObjectType objType, boolean isExternal) {
        System.debug('MyMetaDataRemoteActionExtension.getMetaDataObject: Begin txId: ' + txId + ', businessObject: ' + businessObject + ', objType: ' + objType + ', isExternal: ' + isExternal);
        //Datetime d = system.now();
        BoMetaData result = new BoMetaData();

        if (isExternal == false) { // check if the object is external or SF object
            result.fields = getMetaDataObjectFields(objType);
        }
        // if external object check wich external object is and call the specific method
        else if (businessObject == 'LOExtPrdFilters') {
            result = LOExtPrdFilters();
        } else if (businessObject == 'LOFund') {
            result = LOFund();
        } else if (businessObject == 'LOExtChartValues') {
            result = LOExtChartValues();
        } else if (businessObject == 'LOExtProduct') {
            result = LOExtProduct();
        } else if (businessObject == 'LOExtHoverContent') {
            result = LOExtHoverContent();
        } else if (businessObject == 'LOCalPromotions') {
            result = LOCalPromotions();
        } else if (businessObject == 'LOCalendarView') {
            result = LOCalendarView();
        } else if (businessObject == 'LOExtFiscalYear') {
            result = LOExtFiscalYear();
        } else if (businessObject == 'LOExtPromotionAttachment') {
            result = LOExtPromotionAttachment();
        }else if(businessObject == 'LOExtTacticTiers'){
            result = LOExtTacticTiers();
        }else if(businessObject == 'LOExtChildAccounts'){
            result =LOExtChildAccounts();
        }
        return result;
    }

    private static List<Field> getMetaDataObjectFields(Schema.SObjectType objType) {
        System.debug('MyMetaDataRemoteActionExtension.getMetaDataObjectFields: Begin objType: ' + objType );

        List<Field> resList = new List<Field> ();
        if (objType != null) {
            Schema.DescribeSObjectResult describe = objType.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = describe.fields.getMap(); //Get all the SF Object into map
            for (Schema.SObjectField ft : fieldsMap.values()) { //Run on every object
                Schema.DescribeFieldResult fd = ft.getDescribe(); // get entire description of the object
                Field f = new Field();
                f.name = fd.getName(); // (String)m.get('name'); //Get name of field
                f.label = fd.getLabel(); //(String)m.get('label'); // get Label of field
                f.type = (String) fd.getType().name(); //(String)m.get('type'); // get type of field
                f.picklistValues = fd.getPicklistValues(); // m.get('picklistValues'); // get picklistValues of field
                f.mandatory = !fd.isNillable();
                resList.add(f); //Add the field required to resultList

            }
        }
        return resList;
    }
    
                     /** This method return the object metadata to the Smart UI for the businessObject LOExTacticTier
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtTacticTiers() {
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('tacticId', 'tacticId', s, 'string'));
        fieldList.add(new Field('JSONTier', 'JSONTier', s, 'string'));
        result.fields = fieldList;
        system.debug('LOExtTacticTiers'+result);
        return result;
    }
    
            /** This method return the object metadata to the Smart UI for the businessObject LOExtChildAccounts
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtChildAccounts() {
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('PromotionID', 'PromotionID', s, 'string'));
        fieldList.add(new Field('Included', 'Included', s, 'boolean'));
        fieldList.add(new Field('ChildAccountID', 'ChildAccountID', s, 'string'));
        fieldList.add(new Field('ChildAccountName', 'ChildAccountName', s, 'string'));
        fieldList.add(new Field('PushedPromoID', 'PushedPromoID', s, 'string'));
        fieldList.add(new Field('PushedPromoSFID', 'PushedPromoSFID', s, 'string'));
        fieldList.add(new Field('CustomerUnique', 'CustomerUnique', s, 'string'));
        fieldList.add(new Field('PromotionSlogan', 'PromotionSlogan', s, 'string'));
        result.fields = fieldList;
        system.debug('LOExtChildAccounts'+result);

        
        
        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOExtPrdFilters
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtPrdFilters() {
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('filterId', 'filterId', s, 'string'));
        fieldList.add(new Field('filterLabel', 'filterLabel', s, 'string'));
        fieldList.add(new Field('filterValueId', 'filterValueId', s, 'string'));
        fieldList.add(new Field('filterValueLabel', 'filterValueLabel', s, 'string'));
        result.fields = fieldList;

        String st = JSON.serialize(result);
        return result;

    }

     /** This method return the object metadata to the Smart UI for the businessObject LOFund
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOFund() {
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('Id', 'Id', s, 'id'));
        fieldList.add(new Field('Name', 'Name', s, 'String'));
        fieldList.add(new Field('Amount__c', 'Amount__c', s, 'double'));
        fieldList.add(new Field('Anchor_Customer__c', 'Anchor_Customer__c', s, 'reference'));
        fieldList.add(new Field('Description__c', 'Description__c', s, 'textarea'));
        fieldList.add(new Field('Fund_Template_Description__c', 'Fund_Template_Description__c', s, 'textarea'));
        fieldList.add(new Field('Tactics', 'Tactics', s, 'List'));
        result.fields = fieldList;
        return result;
    }


     /** This method return the object metadata to the Smart UI for the businessObject LOExtChartValues
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtChartValues() {
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('kpiId', 'kpiId', s, 'String'));
        fieldList.add(new Field('value', 'value', s, 'double'));
        result.fields = fieldList;

        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOExtHoverContent
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtHoverContent() {
        DateTime d = system.now();
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('promotionID', 'promotionID', s, 'id'));
        fieldList.add(new Field('content', 'content', s, 'textarea'));
        result.fields = fieldList;
        system.debug('LOExtHoverContent: ' + (system.now().getTime() - d.getTime()));
        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOCalPromotions
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOCalPromotions() {
        DateTime d = system.now();
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('Slogan', 'Slogan', s, 'string'));
        fieldList.add(new Field('Promotions', 'Promotions', s, 'list'));
        fieldList.add(new Field('Promotion_Template', 'Promotion_Template', s, 'reference'));
        fieldList.add(new Field('Account_Name', 'Account_Name', s, 'string'));
        fieldList.add(new Field('Account_Id', 'Account_Id', s, 'reference'));
        fieldList.add(new Field('Commit_Color', 'Commit_Color', s, 'string'));
        result.fields = fieldList;
        system.debug('LOCalPromotions: ' + (system.now().getTime() - d.getTime()));
        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOCalendarView
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOCalendarView() {
        DateTime d = system.now();
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('Id', 'Id', s, 'id'));
        fieldList.add(new Field('Name', 'Name', s, 'string'));
        fieldList.add(new Field('Descritpion', 'Descritpion', s, 'string'));
        fieldList.add(new Field('IsDefault', 'IsDefault', s, 'boolean'));
        fieldList.add(new Field('FilterCriteria', 'FilterCriteria', s, 'textarea'));
        result.fields = fieldList;
        system.debug('LOCalendarView: ' + (system.now().getTime() - d.getTime()));
        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOExtFiscalYear
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtFiscalYear() {
        DateTime d = system.now();
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('Id', 'Id', s, 'id'));
        fieldList.add(new Field('Date_From', 'Date_From', s, 'date'));
        fieldList.add(new Field('Date_Thru', 'Date_Thru', s, 'date'));
        fieldList.add(new Field('Periods', 'Periods', s, 'list'));
        result.fields = fieldList;
        system.debug('LOExtFiscalYear: ' + (system.now().getTime() - d.getTime()));
        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOExtProduct
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtProduct() {
        DateTime d = system.now();
        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();
        fieldList.add(new Field('Category', 'Category', s, 'string'));
        fieldList.add(new Field('Container_Size_Unit', 'Container_Size_Unit', s, 'picklist'));
        fieldList.add(new Field('Container_Size', 'Container_Size', s, 'double'));
        fieldList.add(new Field('Container_Type', 'Container_Type', s, 'picklist'));
        fieldList.add(new Field('Criterion_3_Product_Code', 'Criterion_3_Product_Code', s, 'formula'));
        fieldList.add(new Field('Criterion_3_Product_Description', 'Criterion_3_Product_Description', s, 'formula'));
        fieldList.add(new Field('Description_1', 'Description_1', s, 'formula'));
        fieldList.add(new Field('Id', 'Id', s, 'id'));
        fieldList.add(new Field('Name', 'Name', s, 'String'));
        fieldList.add(new Field('Pack_Size_Unit', 'Pack_Size_Unit', s, 'picklist'));
        fieldList.add(new Field('Pack_Size', 'Pack_Size', s, 'double'));
        fieldList.add(new Field('Short_Description', 'Short_Description', s, 'formula'));
        fieldList.add(new Field('ProductGroupId', 'ProductGroupId', s, 'String'));
        fieldList.add(new Field('ProductGroupDescription', 'ProductGroupDescription', s, 'textarea'));
        fieldList.add(new Field('Tactics', 'Tactics', s, 'List'));
        result.fields = fieldList;
        //String st = JSON.serialize(result);
        system.debug('LOExtProduct: ' + (system.now().getTime() - d.getTime()));
        return result;
    }

     /** This method return the object metadata to the Smart UI for the businessObject LOExtPromotionAttachment
     *  @returnBoMetaData Internal class with the fields of the businessobject required
     */
    @RemoteAction
    global static BoMetaData LOExtPromotionAttachment() {
        DateTime d = system.now();

        List<Field> fieldList = New List<Field> ();
        List<object> s = new List<object> ();
        BoMetaData result = new BoMetaData();

        fieldList.addAll(getMetaDataObjectFields(Promotion_Attachment__c.sObjectType));
        fieldList.add(new Field('previewUrl', 'previewUrl', s, 'URL'));
        fieldList.add(new Field('attachmentUrl', 'attachmentUrl', s, 'URL'));

        result.fields = fieldList;
        //String st = JSON.serialize(result);
        system.debug('LOExtPromotionAttachment: ' + (system.now().getTime() - d.getTime()));
        return result;
    }

   /** Class that contains the list of field of an object    */
   global class BoMetaData {
        global List<Field> fields { global get; private set; }
        
        global BoMetaData() {
            fields = new List<Field>();
        }
    }

    /** Class that contains the properties of a field of an object    */
    global class Field {
        global String name { global get; private set; }
        global String label { global get; private set; }
        global Object picklistValues { global get; private set; }
        global String type { global get; private set; }
        global Boolean mandatory { global get; private set; }
        
        global Field(String name, String label, List<object> picklistValues, String fieldType, Boolean mandatory) {
            this.name = name;
            this.label = label;
            this.picklistValues = picklistValues;
            this.type = fieldType;
            this.mandatory = mandatory;
        } 
        
        global Field(String name, String label, List<object> picklistValues, String fieldType) {
            this(name, label, picklistValues, fieldType, false);
        } 

        //empty constructor
        global Field(){   
        } 

    }
        
    global class item {
        global String level { global get; private set; }
        global String stream { global get; private set; }
        global String type { global get; private set; }
        
        global item(String level, String stream, String itemType) {
            this.level = level;
            this.stream = stream;
            this.type = itemType;
        }
    }

    @RemoteAction
    global static String getACSFNamespace(String txId) {
        
        String result = '';
        try {
            if (className.contains('.')) {
                result = className.split('\\.') [0];
            }
        } finally {
            
        }
        return result;
    }

    global class UserSettings {
        public String LocaleSidKey { get; private set; }
        public String LanguageLocaleKey { get; private set; }

        Public UserSettings()
        {
            this.LocaleSidKey = UserInfo.getLocale();
            this.LanguageLocaleKey = UserInfo.getLanguage();
        }

        public override String toString()
        {
            return String.format('[{0}.UserSettings: LocaleSidKey={1}, LanguageLocaleKey={2}]', new String[] { className, LocaleSidKey, LanguageLocaleKey });
        }
    }

    @RemoteAction
    global static UserSettings getUserSettings(String txId)
    {
        
        UserSettings result = null;
        try {
            result = new UserSettings();
        }
        finally {
            
        }
        return result;
    }
    
    /**
    * Method replicated from MyMetaDataRemoteActionExtension class
    * New parameter 'useCache' is added
    *
    */
    @RemoteAction
    public static List<BoMetaDataOutputCache> getMetaDataListCache(String txId, String inputDataJSON, Boolean useCache) {

        //clearOrgCache();
        
        System.debug('getMetaDataList: Start time: ' + System.now());
        System.debug('getMetaDataList: Begin txId: ' + txId + ', inputData: ' + inputDataJSON);

        List<BoMetaDataInput> inputDataList = 
            (List<BoMetaDataInput>) JSON.deserialize(inputDataJSON, List<BoMetaDataInput>.class);
        
        List<BoMetaDataOutputCache> resultList = new List<BoMetaDataOutputCache>();

        Map<String, Schema.SObjectType> objType = Schema.getGlobalDescribe(); // get SObjectType of the SF Object   
            
        for (BoMetaDataInput inputData : inputDataList) {

            BoMetaDataOutputCache result  = new BoMetaDataOutputCache();
            result.businessObject = inputData.businessObject;
            result.sfObject = inputData.sfObject;

            boolean found = false;
            if (!useCache || !found) {
                
                // Get the data!
                BoMetaDataCache boMetaData = getMetaDataObjectCache(
                        txId, 
                        inputData.businessObject, 
                        inputData.isExternal==false ? objType.get(inputData.sfObject) : null,
                        inputData.isExternal
                );
                
                if(useCache) {
                     // todo: Add to cache!
                     // Cache.Org.put(key, boMetaData);
                }          
                result.fields = bometadata;
            }
            resultList.add(result);
        } 
        return resultList;
    }
    
    @RemoteAction
    public static String clearOrgCache() {
        
        Set<String> keySet = Cache.Org.getKeys();
        for(String s : keySet) {
            Cache.Org.remove(s);
        }

        return 'Capacity: ' + Cache.Org.getCapacity();
    }
    
    public class BoMetaDataOutputCache {
        String businessObject;
        String sfObject;
        BoMetaDataCache fields;
    }
    
    public class BoMetaDataCache {
        List<FieldCache> fields = new List<FieldCache> ();
    }

    public class FieldCache {
        String name;
        String label;
        List<Schema.PicklistEntry> picklistValues;
        String type;

        //constructor
        public FieldCache(String n, String l, List<Schema.PicklistEntry> pl, String t) {
            this.name = n;
            this.label = l;
            this.picklistValues = pl;
            this.type = t;

        }

        //empty constructor
        public FieldCache() {
        }

    }
    
    public static BoMetaDataCache getMetaDataObjectCache(String txId, String businessObject, Schema.SObjectType objType, boolean isExternal) {
        System.debug('MyMetaDataRemoteActionExtension.getMetaDataObjectCache: Begin txId: ' + txId + ', businessObject: ' + businessObject + ', objType: ' + objType + ', isExternal: ' + isExternal);
        //Datetime d = system.now();
        BoMetaDataCache result = new BoMetaDataCache ();

        if (isExternal == false) { // check if the object is external or SF object

            List<FieldCache> resList = new List<FieldCache> ();
            Map<String, Schema.SObjectField> fieldsMap = objType.getDescribe().fields.getMap(); //Get all the SF Object into map
            for (Schema.SObjectField ft : fieldsMap.values()) { //Run on every object
                Schema.DescribeFieldResult fd = ft.getDescribe(); // get entire description of the object 
                FieldCache f = new FieldCache();
                f.name = fd.getName(); // (String)m.get('name'); //Get name of field
                f.label = fd.getLabel(); //(String)m.get('label'); // get Label of field
                f.type = (String) fd.getType().name(); //(String)m.get('type'); // get type of field
                if(fd.getType()==Schema.DisplayType.picklist) {
                    f.picklistValues = fd.getPicklistValues();
                }
                resList.add(f); //Add the field required to resultList

            }
            result.fields = resList;
        }
        // if external object check wich external object is and call the specific method 
        else {
            if (businessObject == 'LOExtPrdFilters') {
                result = LOExtPrdFiltersCache();
            }
            else if (businessObject == 'LOFund') {
                result = LOFundCache();
            }
            else if (businessObject == 'LOExtChartValues') {
                result = LOExtChartValuesCache();
            }
            else if (businessObject == 'LOExtProduct') {
                result = LOExtProductCache();
            }
            else if (businessObject == 'LOExtHoverContent') {
                result = LOExtHoverContentCache();
            }
            else if (businessObject == 'LOCalPromotions') {
                result = LOCalPromotionsCache();
            }
            else if (businessObject == 'LOCalendarView') {
                result = LOCalendarViewCache();
            }
            else if (businessObject == 'LOExtFiscalYear') {
                result = LOExtFiscalYearCache();
            }
        }
        return result;
    }
    
    @RemoteAction
    public static BoMetaDataCache LOExtPrdFiltersCache() {
        BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
       
        bomd.fields.add(new FieldCache('filterId', 'filterId', s, 'string'));
        bomd.fields.add(new FieldCache('filterLabel', 'filterLabel', s, 'string'));
        bomd.fields.add(new FieldCache('filterValueId', 'filterValueId', s, 'string'));
        bomd.fields.add(new FieldCache('filterValueLabel', 'filterValueLabel', s, 'string'));

        //String st = JSON.serialize(result);
        return bomd ;
    }
    
    @RemoteAction
    public static BoMetaDataCache LOFundCache() {
        BoMetaDataCache bomd = new BoMetaDataCache ();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
        
        bomd.fields.add(new FieldCache('Id', 'Id', s, 'id'));
        bomd.fields.add(new FieldCache('Name', 'Name', s, 'String'));
        bomd.fields.add(new FieldCache('Amount__c', 'Amount__c', s, 'double'));
        bomd.fields.add(new FieldCache('Anchor_Customer__c', 'Anchor_Customer__c', s, 'reference'));
        bomd.fields.add(new FieldCache('Description__c', 'Description__c', s, 'textarea'));
        bomd.fields.add(new FieldCache('Fund_Template_Description__c', 'Fund_Template_Description__c', s, 'textarea'));
        bomd.fields.add(new FieldCache('Tactics', 'Tactics', s, 'List'));

        //String st = JSON.serialize(result);
        return bomd;
    }
    
    @RemoteAction
    public static BoMetaDataCache LOExtChartValuesCache() {
        BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry>();
        
        bomd.fields.add(new FieldCache('kpiId', 'kpiId', s, 'String'));
        bomd.fields.add(new FieldCache('value', 'value', s, 'double'));

        //String st = JSON.serialize(result);
        return bomd;
    }
    
    @RemoteAction
    public static BoMetaDataCache LOExtHoverContentCache() {
        BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
        DateTime d = system.now();
        
        bomd.fields.add(new FieldCache('promotionID', 'promotionID', s, 'id'));
        bomd.fields.add(new FieldCache('content', 'content', s, 'textarea'));

        system.debug('LOExtHoverContent: ' + (system.now().getTime() - d.getTime()));
        return bomd;
    }
    
    @RemoteAction
    public static BoMetaDataCache LOCalPromotionsCache() {
                BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
        DateTime d = system.now();
        
        bomd.fields.add(new FieldCache('Slogan', 'Slogan', s, 'string'));
        bomd.fields.add(new FieldCache('Promotions', 'Promotions', s, 'list'));
        bomd.fields.add(new FieldCache('Promotion_Template', 'Promotion_Template', s, 'reference'));
        bomd.fields.add(new FieldCache('Account_Name', 'Account_Name', s, 'string'));
        bomd.fields.add(new FieldCache('Account_Id', 'Account_Id', s, 'reference'));
        bomd.fields.add(new FieldCache('Commit_Color', 'Commit_Color', s, 'string'));

        system.debug('LOCalPromotions: ' + (system.now().getTime() - d.getTime()));
        return bomd;
    }

    @RemoteAction
    public static BoMetaDataCache LOCalendarViewCache() {
                BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
        DateTime d = system.now();
        
        bomd.fields.add(new FieldCache('Id', 'Id', s, 'id'));
        bomd.fields.add(new FieldCache('Name', 'Name', s, 'string'));
        bomd.fields.add(new FieldCache('Descritpion', 'Descritpion', s, 'string'));
        bomd.fields.add(new FieldCache('IsDefault', 'IsDefault', s, 'boolean'));
        bomd.fields.add(new FieldCache('FilterCriteria', 'FilterCriteria', s, 'textarea'));

        system.debug('LOCalendarView: ' + (system.now().getTime() - d.getTime()));
        return bomd;
    }

    @RemoteAction
    public static BoMetaDataCache LOExtFiscalYearCache() {
                BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
        DateTime d = system.now();
        
        bomd.fields.add(new FieldCache('Id', 'Id', s, 'id'));
        bomd.fields.add(new FieldCache('Date_From', 'Date_From', s, 'date'));
        bomd.fields.add(new FieldCache('Date_Thru', 'Date_Thru', s, 'date'));
        bomd.fields.add(new FieldCache('Periods', 'Periods', s, 'list'));

        system.debug('LOExtFiscalYear: ' + (system.now().getTime() - d.getTime()));
        return bomd;
    }


    @RemoteAction
    public static BoMetaDataCache LOExtProductCache() {
                BoMetaDataCache bomd = new BoMetaDataCache();
        List<Schema.PicklistEntry> s = new List<Schema.PicklistEntry> ();
        DateTime d = system.now();
        
        bomd.fields.add(new FieldCache('Category', 'Category', s, 'string'));
        bomd.fields.add(new FieldCache('Container_Size_Unit', 'Container_Size_Unit', s, 'picklist'));
        bomd.fields.add(new FieldCache('Container_Size', 'Container_Size', s, 'double'));
        bomd.fields.add(new FieldCache('Container_Type', 'Container_Type', s, 'picklist'));
        bomd.fields.add(new FieldCache('Criterion_3_Product_Code', 'Criterion_3_Product_Code', s, 'formula'));
        bomd.fields.add(new FieldCache('Criterion_3_Product_Description', 'Criterion_3_Product_Description', s, 'formula'));
        bomd.fields.add(new FieldCache('Description_1', 'Description_1', s, 'formula'));
        bomd.fields.add(new FieldCache('Id', 'Id', s, 'id'));
        bomd.fields.add(new FieldCache('Name', 'Name', s, 'String'));
        bomd.fields.add(new FieldCache('Pack_Size_Unit', 'Pack_Size_Unit', s, 'picklist'));
        bomd.fields.add(new FieldCache('Pack_Size', 'Pack_Size', s, 'double'));
        bomd.fields.add(new FieldCache('Short_Description', 'Short_Description', s, 'formula'));
        bomd.fields.add(new FieldCache('ProductGroupId', 'ProductGroupId', s, 'String'));
        bomd.fields.add(new FieldCache('ProductGroupDescription', 'ProductGroupDescription', s, 'textarea'));
        bomd.fields.add(new FieldCache('Tactics', 'Tactics', s, 'List'));

        //String st = JSON.serialize(result);
        system.debug('LOExtProduct: ' + (system.now().getTime() - d.getTime()));
        return bomd;
    }
    

    @RemoteAction
    public static void setObjectCachedMetaData(String txId, String businessObject, String sfObject, boolean isExternal) {
        BoMetaData result = getMetaData(txId, businessObject, sfObject, isExternal);
        Object resultStr = (object)result;
        //String resultStr2 = (string)resultStr;
        String resultStr3 = JSON.serialize(resultStr);
        Cache.Org.put(businessObject.remove('_'), resultStr3);
    }   

    @RemoteAction
    public static string getObjectCachedMetaData(String businessObject){
        return (string)Cache.Org.get(businessObject.remove('_'));
    }

    @RemoteAction
    public static string getObjectCachedMetaDataList(String jsonObjectList){
        string allCachedObjectMetadata = '';
        List<BoMetaDataInputCache> businessObjectList = (List<BoMetaDataInputCache>) JSON.deserialize(jsonObjectList, List<BoMetaDataInputCache>.class);
        for(BoMetaDataInputCache obj : businessObjectList)
        {
            allCachedObjectMetadata += getObjectCachedMetadata(obj.businessObject);
            system.debug('loop: ' +obj.businessObject+ ' / ' +allCachedObjectMetadata);
        }
        return allCachedObjectMetadata;
    }

    public class BoMetaDataInputCache {
        String businessObject;
    }
}