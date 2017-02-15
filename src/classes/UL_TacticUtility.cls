/***************************************************************
Name: UL_TacticUtility
Copyright © 2016 Salesforce
======================================================
Purpose:
Validate Tactics overlap with existing tactics in the same promotion and same tactics template and validate products mandatory at each tactics level
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Chandrababu Naidu    21/11/2016        INITIAL DEV     Validate Tactics overlap and products in Sprint-3.
*****************************************************************/
public with sharing class UL_TacticUtility {
    private static final String PROMOTION_LOGIC_PATH = '/ACSF/Promotion/';
    public static final String ENDPOINT_GET_TACTIC_PRODUCTS = 'GetTacticProducts';
    private static final String NAMED_CREDENTIAL_ACSF_SERVICE = 'ACSF_Service_Url';
    private static ACCL__Sales_Organization__c defaultSalesOrganization;
    private static String namespace = UL_Utility.MANAGEDPACKAGE_NAMESPACE;
    enum StatusCode {STATUS_ZERO,STATUS_ONE,STATUS_TWO,STATUS_THREE,STATUS_FOUR,STATUS_FIVE,STATUS_SIX,STATUS_SEVEN,STATUS_EIGHT,STATUS_NINE,STATUS_TEN}
    private static Map<Id, ACCL__Sales_Organization__c> salesOrganizationById = new Map<Id, ACCL__Sales_Organization__c>();
    private static Map<String, ACCL__Sales_Organization__c> salesOrganizationByName = new Map<String, ACCL__Sales_Organization__c>();
    /*******************************************************************
Purpose: Generic enum to provide values  
Version 1.0
Parameters: N/A
Returns: N/A
Throws : N/A 
********************************************************************/    
    private enum UtilityEnum{
        Salesforce,
            save,
            BOPromotion,
            fail,
            Tactics,
            MATCH,
            INCLUDED,
            productid,
            Attribute,
            parentId,
            UIElement,
            Push,
            EnableChild,
            Account,
            CustomerSet,
            Result,
            manualproducts,
            productfilter,
            target,
            Id,
            LOTactic,
            PP_BTN_MANAGE_PRODS
            }   
    /*******************************************************************
    Purpose: Validate Tactics overlap and products
    Version: 1.0
    Parameters: Transaction id and BOPromotion Content from controller-MyPromotionRemoteActionExtension
    Returns: Void
    Throws N/A
    ********************************************************************/
    public static void validateTacticsProducts(string txid,string promContent, Map<string,set<string>> prodIdTacticSet){
        set<String> newTacticprodIdSet;
        Map<string,set<string>> prodIdExistTacticSet;
        boolean productsMandate = false;
        boolean productsEnable = false;
        boolean TacticsOverlap = false;
        list<ACCL__Tactic__c> existTactics = new list<ACCL__Tactic__c>();
        List<ACCL__Tactic__c> LOTactics=new  List<ACCL__Tactic__c>();
        Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promContent);
        Map<String, Set<String>> newTacticProdMap = new Map<String, Set<String>>();
        Map<String, Object> boPromotion = (Map<String, Object>) tacticDeserializedMap.get('BOPromotion');
        string contentTarget = (string) tacticDeserializedMap.get('target');
        List<Object> LOTacticList=(List<Object>)boPromotion.get('LOTactic');
        Set<String> newprodIdSet = new Set<String>();
        if(boPromotion.containsKey('LOTactic')){
            Set<String> setfields = new Set<String>();
            setfields.add('ACCL__Promotion__c');
            setfields.add('ACCL__Date_From__c');
            setfields.add('ACCL__Date_Thru__c');
            setfields.add('ACCL__Tactic_Template__c');
            setfields.add('ACCL__Filter_Criteria__c');  
            setfields.add('ACCL__Slogan__c');
            setfields.add('Id');
            for(Object tacticobj : LOTacticList){
                
                Map<String, Object> loTactic = (Map<String, Object>)tacticobj;
                Set<String> listOfKeys = loTactic.keySet();
                
                Integer status= Integer.valueOf( loTactic.get('__ObjectStatus'));
                List<String> lstOfFields = new List<String>(listOfKeys);
                //6 or 2 for new or duplicate tactic, 5 for Tactic Edit
                if(status==StatusCode.STATUS_SIX.ordinal() || status==StatusCode.STATUS_TWO.ordinal() || status==StatusCode.STATUS_FIVE.ordinal()){
                   
                    ACCL__Tactic__c ltactic = new ACCL__Tactic__c();
                    
                    ltactic=(ACCL__Tactic__c)checkFieldTypeAndParsetheJson(txId,setfields,loTactic,'ACCL__Tactic__c');
                    LOTactics.add(ltactic);
                }
              /*  else
                {
                    ACCL__Tactic__c existtactic = new ACCL__Tactic__c();
                    existtactic=(ACCL__Tactic__c)checkFieldTypeAndParsetheJson(txId,setfields,loTactic,'ACCL__Tactic__c');
                    if(existtactic!=null){
                        existTactics.add(existtactic);
                    }
                } */
            }
        }
        //Add products for new tactics
        if(!LOTactics.isEmpty()){
            if(prodIdTacticSet!=null && prodIdTacticSet.keyset().size()>0){
            newTacticprodIdSet = new set<String>();
            prodIdExistTacticSet = new Map<String,set<String>>();
            for(String prodId : prodIdTacticSet.keyset()){
             if(prodIdTacticSet.get(prodid).contains(LOTactics[0].id)){
             newTacticprodIdSet.add(prodid);
             //prodIdExistTacticSet.put(prodId , prodIdTacticSet.get(prodid) );
             }
            }
            
            }
            else {
            //Validation if there are no products present in new\existing tactics
                 productsMandate=true;
            }
            
            }
            //Validation if there are no products on new tactics
            if(newTacticprodIdSet!=null && newTacticprodIdSet.isempty()){
              productsMandate=true;
            }
            
            if(!LOTactics.isEmpty()){
            
            list<ACCL__Tactic_Template__c> tacticTemp = [select UL_TacticOverlap__c,UL_Product_Mandate__c from ACCL__Tactic_Template__c where id=:LOTactics[0].ACCL__Tactic_Template__c limit 1];
            TacticsOverlap =tacticTemp[0].UL_TacticOverlap__c;
            productsEnable = tacticTemp[0].UL_Product_Mandate__c;
            existTactics = [select id,ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Tactic_Template__c,ACCL__Promotion__r.name,ACCL__Tactic_Template__r.name from ACCL__Tactic__c where ACCL__Tactic_Template__c=:LOTactics[0].ACCL__Tactic_Template__c and id!=:LOTactics[0].id and ACCL__Promotion__c in (select Promotion__c from UL_PromotionCategory__c where Heroku_Product_Id__c in:newTacticprodIdSet)];
                 }
        
        if(productsMandate && productsEnable){
            throw new CustomException(label.UL_ProductsMandatory);  
        }
        
        if(LOTactics!=null && LOTactics.size()>0 && existTactics!=null && existTactics.size()>0){
               
                for(ACCL__Tactic__c newTactic : LOTactics){
                    //Check Tactics for overlapping on the same Promotion and same tactics template
                    
                    for(ACCL__Tactic__c checkExist : existTactics){
                        
                        if((TacticsOverlap && checkExist.ACCL__Tactic_Template__c==newTactic.ACCL__Tactic_Template__c && newTactic.ACCL__Date_From__c >= checkExist.ACCL__Date_From__c && newTactic.ACCL__Date_From__c <= checkExist.ACCL__Date_Thru__c) || (TacticsOverlap && checkExist.ACCL__Tactic_Template__c==newTactic.ACCL__Tactic_Template__c && newTactic.ACCL__Date_Thru__c >= checkExist.ACCL__Date_From__c && newTactic.ACCL__Date_Thru__c <= checkExist.ACCL__Date_Thru__c)){
                            //Verify new\edit\duplicate Tactic product id contains in the existing tactics.
                          /*  for(String newProdIds : newTacticprodIdSet){
                                if(prodIdTacticSet.containskey(newProdIds) && prodIdTacticSet.get(newProdIds).contains(checkExist.id)){
                                  throw new CustomException(label.UL_TacticsOverlap);  
                                }
                            } */ 
                           throw new CustomException(checkExist.ACCL__Promotion__r.name+UL_Utility.hyphen+checkExist.ACCL__Tactic_Template__r.name+UL_Utility.hyphen+label.UL_TacticsOverlap);  
                        }
                    }
                }
            
        }
        
    }
    /** checkFieldTypeAndParsetheJson method filter the  Json Data on field type from the UI and parse it back to SObject
    *  @name   :  checkFieldTypeAndParsetheJson
    *  @param  :  txId         GUI id for each transcation we do from UI
    *  @param  :  setfields    set of fields for a Object which is updateble
    *  @param  :  boPromotion  Map<String, Object> contains the Key as API name of field and value as value
    *  @param  :  sObjectType  object Type Like Promotion__c
    *  @return :  SObject       SObject whichc can be Type Cast to Custom/Standard object
    *  @throws :
    *  @author  : g.prajapat@accenture.com
    */
    static SObject checkFieldTypeAndParsetheJson(String txId,Set<String> setfields,Map<String, Object> boPromotion,String sObjectType)
    {
        //LoggerUtility.log('checkFieldTypeAndParsetheJson is called! Transcation Id:'+txId,sObjectType);
        SObjectType objectType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, Schema.SObjectField> sObjectFieldApiNameMap = objectType.getDescribe().fields.getMap();
        SObject sObjValue = Schema.getGlobalDescribe().get(sObjectType).newSObject() ;
        if(boPromotion!=null){
            for(String key:setfields){
                
                if(key !=null && setfields.size()>0){
                    if(boPromotion.containsKey(key))
                    {
                        
                        if(boPromotion.get(key)!=null){
                            
                            String fieldType = sObjectFieldApiNameMap.get(key).getDescribe().getType().name().ToLowerCase();
                            if(fieldType == 'date'){
                                if(boPromotion.get(key)==''){
                                    throw new CustomException('Please fill date field '+key);
                                }
                                else
                                    sObjValue.put(key,objToDate(boPromotion.get(key)));
                                
                            }
                            else if(fieldType == 'reference'){
                                sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'currency' || fieldType == 'decimal' || fieldType == 'integer'){
                                sObjValue.put(key,Integer.valueOf(boPromotion.get(key)));
                            }
                            
                            else if(fieldType == 'double' ||fieldType == 'percent')
                            {
                                
                                sObjValue.put(key,double.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'boolean'){
                                sObjValue.put(key,Boolean.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'lookup'){
                                sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                            }
                            else if(fieldType == 'formula'){
                                sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                            }
                            else {
                                String tmp=(String)boPromotion.get(key);
                                if(tmp.trim()=='')
                                {
                                    throw new CustomException('Please fill the Empty Field '+key);
                                }
                                else
                                {
                                    sObjValue.put(key,String.valueOf(boPromotion.get(key)));
                                }
                            }
                        }
                    }
                    else{
                        
                        //throw new CustomException('field is not in the list:' + key);
                    }
                }
            }
        }
        return  sObjValue;
    }
    /***************************************************************
    Name: customException
    Copyright © 2016 Salesforce
    ======================================================
    Purpose:
    Exception sub class
    ======================================================
    History
    -------
    VERSION     AUTHOR             DATE              DETAIL            Description
    1.0         Chandrababu Naidu    21/11/2016        INITIAL DEV     Exception sub class in Sprint-3.
    *****************************************************************/  
    public class customException extends Exception{
        
    }
    /*******************************************************************
    Purpose: Validate date and return date
    Version: 1.0
    Parameters: getting date object
    Returns: date
    Throws N/A
    ********************************************************************/
    public static Date objToDate(Object o) {
        if (o == null) return null;
        if (o instanceof Date) return (Date)o;
        if (o instanceof Long) {
            Long i = (Long)o;
            DateTime dt = DateTime.newInstance(i);
            return dt.Date();
        }
        if (o instanceof Integer) {
            Integer i = (Integer)o;
            DateTime dt = DateTime.newInstance(i);
            return dt.Date();
        }
        if (o instanceof String) {
            String s = (String)o;
            String[] strDate = s.split('-');
            Integer myIntDate = integer.valueOf(strDate[2]);
            Integer myIntMonth = integer.valueOf(strDate[1]);
            Integer myIntYear = integer.valueOf(strDate[0]);
            Date datevalue = Date.newInstance(myIntYear, myIntMonth, myIntDate);
            return datevalue;
        }
        return Date.newInstance(1700, 1, 1);
    }
        public class TacticWrapper {
        public TacticWrapper(){
        }
        public TacticWrapper(Id Id, Boolean included) {
              this.Id = Id;
              //this.Included = 'MATCH';
              this.Included = included == null ? 'MATCH' : included == true ? 'INCLUDED' : 'EXCLUDED';
              this.tacticId=Id;
        
              this.relationship = this.included;
          }
        public Id Id{get;set;}
        public String Included{get;set;}
        public Id tacticId{get;set;}
        public String relationship{get;set;}
        }
        class ProductResolution {
          Id promotionid;
          List<Id> productlookups;
          List<Id> tacticlookups;
          List<Relation> relations;
          Hierarchy hierarchy;
            }
            class Relation {
            List<String> dimensions;
            List<List<Integer> > mapping;
            }
            class Hierarchy {
            String name;
            List<String> lookups;
            List<Integer> mapping;
            }
            /** readLOExtProducts method reads Ext product
     *  @name   :  readLOExtProducts
     *  @param  :  PromotionId  PromotionId
     *  @return :  String
     *  @throws :
     *  @author :  sumit.chaturvedi@accenture.com
     */
    public static list<Map<String,Object>> readLOExtProduct(String txId,  String promotionContent) {
  
  Long start = Datetime.now().getTime();
  List<Id> productGroupLookups= new List<Id>();
  List<Integer> hierarchyMapping = new List<Integer>();
  system.debug('@@@promotionContent'+promotionContent);
  List<Map<String, Object> > result = new List<Map<String, Object> >();  // untyped since filter attribute are dynamic
  String prdResolution = getResponseBodyForPromotion(txId, ENDPOINT_GET_TACTIC_PRODUCTS, promotionContent);
  system.debug('prdResolution'+prdResolution);
  ProductResolution resolution = (ProductResolution)JSON.deserializeStrict(prdResolution, ProductResolution.class);
  system.debug('@@@@@resolution'+resolution);
  List<Id> tacticLookups = resolution.tacticlookups;
  List<Id> productLookups = resolution.productlookups;

  Map<Id, Integer> productMapping = new Map<Id, Integer>();
  for (Integer i = 0; i < productLookups.size(); i++) {
      productMapping.put(productLookups[i], i);
  }
  if(resolution.hierarchy !=null){
      productGroupLookups = resolution.hierarchy.lookups;
      Hierarchy hierarchy = resolution.hierarchy;
      hierarchyMapping = hierarchy.mapping;
  }
  // Tactic => Product => manual flag
  Map<Id, Map<Id,Boolean> > manualProducts = getManualProducts(txId, promotionContent);

  // prd id => all tactic ids promotion the product
  Map<Id, Set<Id> > tacticProducts  = new Map<Id, Set<Id> >();
  for (Id productId : productLookups) {
      tacticProducts.put(productId, new Set<Id>{});
  }
  
  // tactic product mapping
  for(Relation relation: resolution.relations)
  {
      if (relation.dimensions.size() == 2)
      {
    String firstDimension = relation.dimensions[0];
    String secondDimension = relation.dimensions[1];
    if (firstDimension == 'Tactic' && secondDimension == 'Product' || firstDimension == 'Product' && secondDimension == 'Tactic')
    {
        Integer tacticPos, productPos;
        if (firstDimension == 'Tactic')
        {
      tacticPos = 0;
      productPos = 1;
        }
        else
        {
      tacticPos = 1;
      productPos = 0;
        }
        for (List<Integer> pair : relation.mapping)
        {
      Id tacticId = tacticLookups[pair[tacticPos]];
      Id productId = productLookups[pair[productPos]];
      tacticProducts.get(productId).add(tacticId);
        }
    }
      }
  }
 
   system.debug('prod lookups-'+productLookups+'prod group lookups'+productGroupLookups);
  // product attributes
  List<Schema.FieldSetMember> filterAttributes = SObjectType.ACCL__Product__c.FieldSets.ACCL__TacticFilterCriteria.getFields();
  String tacticQuery = String.format(
      //  'SELECT Id, Short_Description__c, Description_1__c, Product_Level__c, {0} From Product__c Where (Id in :productLookups or Id in :productGroupLookups)',
      'SELECT Id, ACCL__Short_Description__c, ACCL__Description_1__c, ACCL__Product_Level__c,ACCL__Container_Size_Unit__c,ACCL__Category__c,ACCL__Container_Size__c,ACCL__Container_Type__c,ACCL__Criterion_3_Product_Code__c,ACCL__Criterion_3_Product_Description__c,Name,ACCL__Pack_Size__c,ACCL__Pack_Size_Unit__c,ACCL__Product_Form__c From ACCL__Product__c Where (Id in :productLookups or Id in :productGroupLookups)',
      new List<String>{getFieldNames(filterAttributes)}) ;

  system.debug('#######'+tacticQuery);
  system.debug('#######product Lookups'+productLookups);

  system.debug('#######Product Group Lookups'+productGroupLookups);
  List<ACCL__Product__c> products = Database.query(tacticQuery);

  system.debug('######'+products.size()+', products'+products);

  Map<Id, String> productGroupDescriptions = new Map<Id, String>();
  for (ACCL__Product__c product : products)
  {
      String productLevel = product.ACCL__Product_Level__c;
      if (productLevel <> 'Product')
      {
    productGroupDescriptions.put(product.id, product.ACCL__Description_1__c);
      }
  }


  for (ACCL__Product__c product : products)
  {
      String productLevel = product.ACCL__Product_Level__c;
     
     if (productLevel == 'Product')
      {
    Id productId = product.Id;
    Integer productIndex = productMapping.get(productId);
    Integer productGroupIndex = hierarchyMapping[productIndex];    
    id productGroupId = productGroupLookups[productGroupIndex];
    String productGroupDescription = productGroupDescriptions.get(productGroupId);
    if (productGroupDescription == null) productGroupDescription = 'Others';
    Set<Id> tactics = tacticProducts.get(productId);
     Map<String, Object> externalProduct = createExternalProduct(product, tactics, filterAttributes, productGroupId, productGroupDescription, manualProducts);
    result.add(externalProduct);
      }
     
  }
  
  return result;
    }
    public static String getResponseBodyForPromotion(String txId, String endpointName, String promotionContent){
    String requestBody = JSON.serialize(createWSRequestBody(txId, promotionContent)); 
    return invokeWS(txId, PROMOTION_LOGIC_PATH + endpointName, requestBody);
  }
  private static WSRequestBody createWSRequestBody(String txId, String promotionContent) {
        System.debug(promotionContent);
        Map<String, Object> promotionMap = (Map<String,Object>)JSON.deserializeUntyped(promotionContent);
        Map<String, Object> boPromotion = (Map<String, Object>)promotionMap.get('BOPromotion');
        Id promotionId = Id.valueOf((String)boPromotion.get('Id'));
        Id promotionTemplateId = Id.valueOf((String)boPromotion.get('ACCL__Promotion_Template__c'));
        List<ACCL__Promotion_Template__c> promotionTemplates = [Select Id, ACCL__Consider_Listing__c, ACCL__KPI_Set__c From ACCL__Promotion_Template__c Where Id = :promotionTemplateId Limit 1];
        ACCL__Promotion_Template__c promotionTemplate;
        if (promotionTemplates.size() == 0) {
            // todo
            promotionTemplate = new ACCL__Promotion_Template__c(ACCL__Consider_Listing__c=true, ACCL__KPI_Set__c=promotionTemplateId);
        } else {
            promotionTemplate = promotionTemplates[0];
        }
        Date commitDate = objToDate(boPromotion.get('ACCL__Commit_Date__c'));
        Date dateFrom = objToDate(boPromotion.get('ACCL__Date_From__c'));
        Date dateThru = objToDate(boPromotion.get('ACCL__Date_Thru__c'));
        Datetime lastModified = Datetime.now();
        Boolean active = Boolean.valueOf(boPromotion.get('ACCL__Active__c'));
        String phase = (String)boPromotion.get('ACCL__Phase__c');
        Id anchorAccountId;
        if((String)boPromotion.get('ACCL__Anchor_Account__c')!=null){
        //system.debug('account--'+(String)boPromotion.get('ACCL__Anchor_Account__c'));
        anchorAccountId = Id.valueOf((String)boPromotion.get('ACCL__Anchor_Account__c'));
        }
        String salesOrgName = (String)boPromotion.get('ACCL__Sales_Org__c');
        Object manualCalculationInput = JSON.deserializeUntyped((string)boPromotion.get('ACCL__Manual_Calculation_Input__c'));
        System.debug(manualCalculationInput);
        ACCL__Sales_Organization__c salesOrg = getSalesOrganizationByName(salesOrgName);
        
        WSRequestBody request = new WSRequestBody(promotionId, anchorAccountId, promotionTemplate.ACCL__KPI_Set__c, dateFrom, dateThru, commitDate, lastModified, active, phase, salesOrgName, manualCalculationInput,
                                                  Integer.valueOf(salesOrg.ACCL__First_Day_Of_Week__c),Integer.valueOf( salesOrg.ACCL__First_Week_Of_Year__c) , salesOrg.ACCL__Promotion_Aggregation_Level__c, promotionTemplate.ACCL__Consider_Listing__c,
                                                  getPromotionVariables(txId, promotionContent));
        
        List<Object> tactics = (List<Object>)boPromotion.get('LOTactic');
        for (Object tactic: tactics) {
            Map<String, Object> tacticMap = (Map<String, Object>)tactic;
            Boolean included = (Boolean)tacticMap.get('ACCL__Included__c');
            if (included) {
                String tacticId = (String)tacticMap.get('Id'); // really string!?
                Date tacticDateFrom = objToDate(tacticMap.get('ACCL__Date_From__c'));
                Date tacticDateThru = objToDate(tacticMap.get('ACCL__Date_Thru__c'));
                Object tacticFilterCriteria = getProductFilter(tacticMap); 
                WSRequestBodyTactic reqTactic = new WSRequestBodyTactic(tacticId, tacticDateFrom, tacticDateThru, tacticFilterCriteria);             
                request.tactics.add(reqTactic);
            }
        }
        system.debug(request);
        return request;        
    }
    public static Map<String, Map<String, Map<String, Object>>> getPromotionVariables(String txId, String promotionContent) { 
        Map<String, Object> promotionMap = (Map<String,Object>)JSON.deserializeUntyped(promotionContent);
        return getPromotionVariables(txId, promotionMap);
    }
    private static Map<String, Object> createVariableMap(Map<String, Object> obj, List<Schema.FieldSetMember> fields) {
        Map<String, Object> result = new Map<string, Object>();        
        for(Schema.FieldSetMember field : fields){
            String fullName = field.getFieldPath();
            Object value = getValue(obj, fullName);
            String name = simplifyFieldName(fullName);
            result.put(name, value);
        }
        return result;
    }
    private static Object getValue(Map<String, Object> Obj, String path) {
        If (path.contains('.')) {
            // todo: not easy to support
            return null;
        } else {
            return obj.get(path);
        }
    }
     
     public static Map<String, Map<String, Map<String, Object> > > getPromotionVariables(String txId,  Map<String, Object> promotion) {    
        List<Schema.FieldSetMember> promotionFields = SObjectType.ACCL__Promotion__c.FieldSets.ACCL__Calculation_Variables.getFields();      
        Map<String, Object> boPromotion = (Map<String, Object>)promotion.get('BOPromotion');
        Id promotionId = Id.valueOf((String)boPromotion.get('Id'));
        Map<String, Object> promotionMap = createVariableMap(boPromotion, promotionFields);
        Map<String, Map<String, Object> > promotionsMap = new Map<String, Map<String, Object> >();
        promotionsMap.put(promotionId, promotionMap);

        Map<String, Map<String, Object> > tacticsMap = new Map<String, Map<String, Object> >();
        List<Schema.FieldSetMember> tacticFields = SObjectType.ACCL__Tactic__c.FieldSets.ACCL__Calculation_Variables.getFields();
        List<Object> tactics = (List<Object>)boPromotion.get('LOTactic');
        for (Object tct: tactics) {
            Map<String, Object> tactic = (Map<String, Object>)tct;
            String tacticId = (String)tactic.get('Id');
            Map<String, Object> tacticMap = createVariableMap(tactic, tacticFields);
            tacticsMap.put(tacticId, tacticMap);
        }
    Map<String, Map<String, Map<String, Object> > > result = new Map<String, Map<String, Map<String, Object> > >();
        result.put('tactics', tacticsMap);
        result.put('promotions', promotionsMap);
        return result;        
    }

      private static Object getProductFilter(Map<String, Object> tacticMap) {
        Object filterCriteria = tacticMap.get('productfilter');
        System.debug('Value of productfilter: ' + filterCriteria);
        if (filterCriteria instanceof Map<String, Object>) return filterCriteria;
        if (filterCriteria instanceof String) return JSON.deserialize((String)filterCriteria, TacticProductFilterWrapper.class);
        return new TacticProductFilterWrapper();
    }
  
    public static String invokeWS(String txId, String endpointName, String body ) {
        Http httpProtocol = new Http(); 
        HttpRequest request = new HttpRequest(); 
        request.setEndpoint('callout:' + NAMED_CREDENTIAL_ACSF_SERVICE + endpointName);
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('txId', txid);
        request.setCompressed(true);
        request.setBody(body);
        Integer jwtValidPeriod= Integer.valueOf(getSystemSetting(Constants.SYSTEM_SETTING_JWT_EXPIRATION_TIME, txId, Constants.DEFAULT_JWT_EXPIRATION_TIME));
        request = JWT.addJwtTokenToHttpHeader(request,endpointName, jwtValidPeriod  );  
        System.debug('request body '+request.getBody());
        System.debug('request headers params ' + request.getHeader('Authorization'));
        System.debug('request url '+request.getEndpoint()+endpointName);
    HttpResponse response = httpProtocol.send(request);

        String result = response.getBody();
        System.debug(result);

        if(response.getStatusCode() != 200) {
            throw new CustomException(response.getStatus());
        }

        return result;        
    }
    
     public static String getSystemSetting(String settingName, String txId, Object defaultValue) {
        ACCL__System_Setting__c setting = ACCL__System_Setting__c.getInstance(settingName);
        if (setting == null) {
          //LoggerUtility.log(Label.ACCL.SYSTEM_SETTING_MISSING+settingName, txId );
          if( defaultValue == null) {
            return null;
          }
          return  String.valueOf(defaultValue);
        }
        return setting.ACCL__Value__c; 
    }
  public static WSRequestBody createWSRequestBody(String txId, Id promotionId) {
      return createWSRequestBody(txId, promotionId, null);
    }
  static Map<Id, Map<Id,Boolean> > getManualProducts(String txId, String promotionContent)
    {
  Map<Id, Map<Id,Boolean> > result = new Map<Id, Map<Id,Boolean> >();
  Map<String, Object> promotionMap = (Map<String, Object>)JSON.deserializeUntyped(promotionContent);
  Map<String, Object> boPromotion = (Map<String, Object>) promotionMap.get('BOPromotion');

  List<Object> tactics = (List<Object>)boPromotion.get('LOTactic');
  for (Object oTactic : tactics)
  {
      Map<String, Object> tactic = (Map<String, Object>)oTactic;
      Id tacticId = Id.valueOf((Id)tactic.get('Id'));
      Map<String, Object> filterCriteria = (Map<String, Object>)tactic.get('productfilter');
      Map<Id, Boolean> manualProductMap = new Map<Id, Boolean>();
      if (filterCriteria <> null) {
    List<Object> manualProducts = (List<Object>)filterCriteria.get('manualproducts');
    //if (false) {
    if (manualProducts!=null)
    {
        for (Object oManualProduct : manualProducts)
        {
      Map<String, Object> manualProduct = (Map<String, Object>)oManualProduct;
      Id productId = Id.valueOf((String)manualProduct.get('productid'));
      Boolean included = (Boolean)manualProduct.get('included');
      manualProductMap.put(productId, included);
        }
    }
      }
      result.put(tacticId, manualProductMap);
  }
  return result;
    }
    private static String getFieldNames(List<Schema.FieldSetMember> fields) {
  String result = '';
  String separator = '';
  for (Schema.FieldSetMember field: fields) {
      result += separator + field.getFieldPath();
      separator = ',';
  }
  return result;
    }
    static Map<String, Object>  createExternalProduct(ACCL__Product__c product, Set<Id> tacticIds, List<Schema.FieldSetMember> filterAttributes,
                  Id productGroupId, String productGroupDescription, Map<Id, Map<Id,Boolean> > manualProducts) {
                Map<String, Object> result = new Map<String, Object>();
                result.put('Container_Size',product.ACCL__Container_Size__c);
                result.put('Container_Size_Unit',product.ACCL__Container_Size_Unit__c);
                result.put('Container_Type',product.ACCL__Container_Type__c);
                result.put('Criterion_3_Product_Code',product.ACCL__Criterion_3_Product_Code__c);
                result.put('Criterion_3_Product_Description',product.ACCL__Criterion_3_Product_Description__c);
            result.put('Name',product.Name);
            result.put('Pack_Size',product.ACCL__Pack_Size__c);
                result.put('Pack_Size_Unit',product.ACCL__Pack_Size_Unit__c);
                result.put('Category', product.ACCL__Category__c);
                result.put('productid', product.Id);
            result.put('Product_Form',product.ACCL__Product_Form__c);
                result.put('Id', product.Id);
                result.put('description', product.ACCL__Description_1__c);
                result.put('Short_Description', product.ACCL__Short_Description__c);
                result.put('Description_1', product.ACCL__Description_1__c);
                result.put('ProductGroupId', productGroupId);
                result.put('ProductGroupDescription', productGroupDescription);
                List<TacticWrapper> tactics = new List<TacticWrapper>();
                for (Id tacticId : tacticIds) {
                    tactics.add(new TacticWrapper (tacticId, manualProducts.get(tacticId).get(product.Id)));
                }
                result.put('Tactics', tactics);
                return result;
                  }
            public class WSRequestBody {
        WSRequestBody(Id promotionid, Id accountId, Id kpisetid, Date dataFrom, Date dateThru, Date commitDate, Datetime lastModified, Boolean active, String phase, String salesOrg, Object manualCalculationInput,
                  Integer firstDayOfWeek, Integer firstWeekOfYear, String productGroupLevel, Boolean considerListing, Object variables) {
                      this.promotionid = promotionid;
                      this.accountid = accountId;
                      this.kpisetid = kpisetid;
                      this.datefrom = dataFrom;
                      this.datethru = dateThru;
                      this.commitdate = commitDate;
                      this.lastmodified = lastModified;
                      this.active = active;
                      this.phase = phase;
                      if(salesOrg == null) {
                          salesOrg = '';
                      }
                      this.manualcalculationinput = manualCalculationInput;
                      this.salesorg = salesOrg;
                      this.firstdayofweek = firstDayOfWeek;
                      this.firstweekofyear = firstWeekOfYear;
                      this.productgrouplevel = productGroupLevel;
                      this.considerlisting = considerListing;
                      this.tactics = new List<WSRequestBodyTactic>();
                      this.variables = variables;
                       }
                    Id promotionid;
                    Id accountid;
                    id kpisetid;
                    Date datefrom;
                    Date datethru;
                    Date commitdate;
                    Datetime lastmodified;
                    Boolean active;
                    String phase;
                    String salesorg;
                    Object manualcalculationinput;
                    Integer firstdayofweek;
                    Integer firstweekofyear;
                    String productgrouplevel;
                    Boolean considerlisting;
                    List<WSRequestBodyTactic> tactics;  
                    Object variables;      
                }
                 public class WSRequestBodyTactic {
        WSRequestBodyTactic(Id id, Date datefrom, Date datethru, Object productfilter) {
            this.tacticid = id;
            this.datefrom = dateFrom;
            this.datethru = dateThru;
            this.productfilter = productFilter;
        }
        Id tacticid;
        Date datefrom;
        Date datethru;
        Object productfilter;
    }
    public static WSRequestBody createWSRequestBody(String txId, Id promotionId, Id tacticId) {
        List<ACCL__Promotion__c> promotions = [Select Id, ACCL__Commit_Date__c, ACCL__Date_From__c, ACCL__Date_Thru__c, ACCL__Anchor_Account__c, LastModifiedDate, ACCL__Active__c, ACCL__Phase__c, ACCL__Sales_Org__c, ACCL__Manual_Calculation_Input__c,
                                         ACCL__Promotion_Template__r.ACCL__Consider_Listing__c , ACCL__Promotion_Template__r.ACCL__KPI_Set__c 
                                         From ACCL__Promotion__c Where Id = :promotionId Limit 1]; 
        if (promotions.size() == 0) {
            return null;    
        }
         ACCL__Promotion__c promotion = promotions[0];
        ACCL__Sales_Organization__c salesOrg = getSalesOrganizationByName(promotion.ACCL__Sales_Org__c);
        Id kpiSetId = promotion.ACCL__Promotion_Template__r.ACCL__KPI_Set__c;
        Map<String, Map<Id, Map<String, Object > > > variables = getPromotionVariables(txId, promotionId);
        WSRequestBody request = new WSRequestBody(promotion.Id, promotion.ACCL__Anchor_Account__c, KPISetId, promotion.ACCL__Date_From__c, promotion.ACCL__Date_Thru__c, promotion.ACCL__Commit_Date__c,
                                                  promotion.LastModifiedDate, promotion.ACCL__Active__c, promotion.ACCL__Phase__c, promotion.ACCL__Sales_Org__c, JSON.deserializeUntyped(promotion.ACCL__Manual_Calculation_Input__c),
                                                  Integer.valueOf(salesOrg.ACCL__First_Day_Of_Week__c), Integer.valueOf(salesOrg.ACCL__First_Week_Of_Year__c), salesOrg.ACCL__Promotion_Aggregation_Level__c,
                                                  promotion.ACCL__Promotion_Template__r.ACCL__Consider_Listing__c,
                                                  variables);

        String tacticQuery = 'Select Id, Date_From__c, Date_Thru__c, Filter_Criteria__c '+
            'From Tactic__c '+
            'Where Tactic__c.Included__c = true and Tactic__c.Promotion__c = :promotionId';
        if (tacticId != null) {
            tacticQuery += ' and Id = :tacticId';
        }

        List<ACCL__Tactic__c> tactics = Database.query(tacticQuery);

        for (ACCL__Tactic__c tactic: tactics) {
            TacticProductFilterWrapper filterCriteria;
            if (tactic.ACCL__Filter_Criteria__c == null) {
                filterCriteria = new TacticProductFilterWrapper();
            } else {
                filterCriteria = (TacticProductFilterWrapper)JSON.deserialize(tactic.ACCL__Filter_Criteria__c, TacticProductFilterWrapper.class);
            }   
            WSRequestBodyTactic reqTactic = new WSRequestBodyTactic(tactic.Id, tactic.ACCL__Date_From__c, tactic.ACCL__Date_Thru__c, filterCriteria);             
            request.tactics.add(reqTactic);
        } 
        system.debug(request);
        return request;
    }
     public static Map<String, Map<Id, Map<String, Object>>> getPromotionVariables(String txId, Id promotionId) {    
        List<Schema.FieldSetMember> promotionFields = SObjectType.ACCL__Promotion__c.FieldSets.ACCL__Calculation_Variables.getFields();
        String prmQuery = String.format(
            'SELECT {0} From Promotion__c Where Id = :promotionId Limit 1', 
            new List<String>{getFieldNames(promotionFields)});
        /* since the dynamic part is only the field list generated from a field set, soql injection is not possible */
        List<ACCL__Promotion__c> promotions = Database.query(prmQuery);
        ACCL__Promotion__c promotion = promotions[0];
        Map<String, Object> promotionMap = createVariableMap(promotion, promotionFields);
        Map<Id, Map<String, Object> > promotionsMap = new Map<Id, Map<String, Object> >();
        promotionsMap.put(promotionId, promotionMap);
        
        List<Schema.FieldSetMember> tacticFields = SObjectType.ACCL__Tactic__c.FieldSets.ACCL__Calculation_Variables.getFields();
        String tacticQuery = String.format(
            'SELECT {0} From Tactic__c Where Tactic__c.Included__c = true and Tactic__c.Promotion__c = :promotionId',
            new List<String>{getFieldNames(tacticFields)}) ;
        /* since the dynamic part is only the field list generated from a field set, soql injection is not possible */
        List<ACCL__Tactic__c> tactics = Database.query(tacticQuery);
        Map<Id, Map<String, Object> > tacticsMap = new Map<Id, Map<String, Object> >();
        for (ACCL__Tactic__c tactic : tactics) {
            Id tacticId = tactic.Id;
            Map<String, Object> tacticMap = createVariableMap(tactic, tacticFields);
            tacticsMap.put(tacticId, tacticMap);
        }
        Map<String, Map<Id, Map<String, Object> > > result = new Map<String, Map<Id, Map<String, Object> > >();
        result.put('tactics', tacticsMap);
        result.put('promotions', promotionsMap);
        return result;        
    }    
    /* craetes a map(String -> Object) of set of fields and an sObject
     * @param sObj sObject with the values and sub sObject
     * @param fields list of FieldSetMembers that defines which fields are copied to the map
     */
    private static Map<String, Object> createVariableMap(sObject sObj, List<Schema.FieldSetMember> fields) {
        Map<String, Object> result = new Map<string, Object>();        
        for(Schema.FieldSetMember field : fields){
            String fullName = field.getFieldPath();
            Object value = getValue(sObj, fullName);
            String name = simplifyFieldName(fullName);
            result.put(name, value);
        }
        return result;
    }
    /* creates an attribute name 
     * @param name name of the SFDC attribute
     * 1) if the name is apath, only the last par is considered
     * 2) remove the ACSF namespace
     * 3) remove __c at the end
     * 4) remove underlines and convert to lower case
  ********************/
    private static String simplifyFieldName(String name) {
        Integer lastIndex = name.lastIndexOf('.');
        if (lastIndex >= 0) name = name.substring(lastIndex+1);
        if (name.startsWith(Constants.NAMESPACEPREFIX)) name = name.substring(Constants.NAMESPACEPREFIX.length());
        if (name.endsWith('__c')) name = name.substring(0, name.length() - 3);
        return name.remove('_').toLowerCase();        
    }
     /* gets a value of an sObject (similar to sObject.get), but works with a sub sobjects, too
     * @param sObj sObject with the values and sub sObject
     * @param path path to the field, e.g. "Tactic_Template__r.Tactic_Type__c"
     */
    private static Object getValue(sObject sObj, String path) {
        If (path.contains('.')) {
            List<String> headAndTail = path.split('\\.', 2);
            String sObjectName = headAndTail[0];
            String tail = headAndTail[1];
            sObject child = (sObject)sObj.getSObject(sObjectName);
            return getValue(child, tail);
        } else {
            return sObj.get(path);
        }
    }
    public with sharing class TacticProductFilterWrapper {
    public Map<String, List<String>> criteria  { get; set; }
    public List<ManualProductWrapper> manualproducts  { get; set; }

    /**  **/
    public TacticProductFilterWrapper(){}

    /**  **/
    public TacticProductFilterWrapper(Map<String, List<String>> criteria,List<ManualProductWrapper> manualproducts){
      this.criteria = criteria;
      this.manualproducts = manualproducts;
    }
  }
   public with sharing class ManualProductWrapper {
    public Id productid { get; set; }
    public Boolean included { get; set; }

    /**  **/
    public ManualProductWrapper(Id productid, Boolean included) {
      this.productid = productid;
      this.included = included;
    }
  }
    public static ACCL__Sales_Organization__c getSalesOrganizationByName(String salesOrganizationName) {
        ACCL__Sales_Organization__c result;
        
        if(salesOrganizationName == null) {
            result = getDefaultSalesOrganization();
            
        } else {
            if(!salesOrganizationByName.containsKey(salesOrganizationName)) {
                getRecordByName(salesOrganizationName);
            }
            
            result = salesOrganizationByName.get(salesOrganizationName);
        }
        
        return result;
    }  
    private static void checkOlsAndFls() {
        String objectToCheck = ACCL__Sales_Organization__c.SObjectType.getDescribe().getName();
        List<String> fieldsToCheck = new List<String> {'Id', 'Name', namespace + 'First_Day_Of_Week__c', namespace + 'First_Week_Of_Year__c', namespace + 'Promotion_Aggregation_Level__c', namespace + 'Global_Sales_Org__c'};
        checkObjectIsAccessibleOrThrowError(objectToCheck);
        checkFLSPermissionOrThrowError(objectToCheck, fieldsToCheck, Constants.FLS_VIEW);
    }
    
    /**
     *  method for check field creation permission
     *
     *  @author                     adam.bobor@accenture.com
     *  @param sObjectAPIName       api name of the sOBject 
     *  @param fieldAPINameList     field names for which the accessibility should be checked
     *  @param operation            create, update, view 
     */
    public static void checkFLSPermissionOrThrowError(String sObjectAPIName, List<String> fieldAPINameList, String operation)
    {
        String returnMessage;
        
        returnMessage = '';
        
            SObjectType objectType = Schema.getGlobalDescribe().get(sObjectAPIName);
            Map<String, Schema.SObjectField> sObjectFieldApiNameMap = objectType.getDescribe().fields.getMap();
            
            if(operation != NULL)
            {
                for(String tempString : fieldAPINameList)
                {
                    if(sObjectFieldApiNameMap.containsKey(tempString))
                    {
                        if(operation.equalsIgnoreCase('view'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isAccessible())
                            {

                                returnMessage += Label.ACCL.ERROR_MISSING_VIEW_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD + '. On Object: '+ sObjectAPIName+', ';
                                System.debug('not accessible' + returnMessage);
                            }
                        }
                        else if(operation.equalsIgnoreCase('create'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isCreateable())
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_CREATE_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD + '. On Object: '+ sObjectAPIName+  ', ';
                            }
                        }
                        else if(operation.equalsIgnoreCase('update'))
                        {// isCalculated means that the field is a Formula so it cannot be editable, these fields will be omitted!
                            // Type of field is checked also, if it is an Id than it is editable by default so it's also omitted!
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isUpdateable() && !sObjectFieldApiNameMap.get(tempString).getDescribe().isCalculated() && sObjectFieldApiNameMap.get(tempString).getDescribe().getType() != Schema.DisplayType.ID && sObjectFieldApiNameMap.get(tempString).getDescribe().isPermissionable() )
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_EDIT_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD + '. On Object: '+ sObjectAPIName+  ', ';
                            }
                        }
                        else 
                        {
                            returnMessage = Label.ACCL.ERROR_INVALID_OPERATION;
                            
                        }
                    }
                    else
                    {
                        returnMessage += Label.ACCL.ERROR_INVALID_FIELD + ': ' + tempString + '. On Object: '+ sObjectAPIName+', ';
                    }
                }
            } else {
                returnMessage = Label.ACCL.ERROR_INVALID_OPERATION + '. On Object: '+ sObjectAPIName+  ', ';
            }
            
            if(String.isNotBlank(returnMessage))
            {   
                System.debug(LoggingLevel.ERROR, 'ret MEss:'+ returnMessage);
                returnMessage = returnMessage.removeEnd(', ');
                System.debug(LoggingLevel.ERROR, returnMessage);
                throw new CustomException(returnMessage);
            }
            
    }
    
    /**
     *  method to check object access permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @throw SecurityUtilObjectException
     */
    public static void checkObjectIsAccessibleOrThrowError(String sObjectAPIName)
    {
             if(! Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isAccessible()){
                throw new CustomException( Label.ACCL.ERROR_MISSING_VIEW_PERMISSION + ' ' + sObjectAPIName);
             }
    
    }
    
    private static void cacheSalesOrganizationRecord(ACCL__Sales_Organization__c salesOrganizationRecord) {
        salesOrganizationById.put(salesOrganizationRecord.Id, salesOrganizationRecord);
        salesOrganizationByName.put(salesOrganizationRecord.Name, salesOrganizationRecord);
        
        if(salesOrganizationRecord.ACCL__Global_Sales_Org__c) {
            defaultSalesOrganization = salesOrganizationRecord;
        }
    } 
    private static void getRecordByName(String salesOrganizationName) {
        checkOlsAndFls();
        
        ACCL__Sales_Organization__c salesOrganizationRecord = [SELECT Id, Name, ACCL__Global_Sales_Org__c, ACCL__First_Day_Of_Week__c, ACCL__First_Week_Of_Year__c, ACCL__Promotion_Aggregation_Level__c FROM ACCL__Sales_Organization__c WHERE Name =:salesOrganizationName Limit 1];
        
        cacheSalesOrganizationRecord(salesOrganizationRecord);
    } 
    public static ACCL__Sales_Organization__c getDefaultSalesOrganization() {
        if(defaultSalesOrganization == null) {
            getDefaultRecord();
        }
        
        return defaultSalesOrganization;
    }
     private static void getDefaultRecord() {
        checkOlsAndFls();
        
        ACCL__Sales_Organization__c salesOrganizationRecord = [SELECT Id, Name, ACCL__Global_Sales_Org__c, ACCL__First_Day_Of_Week__c, ACCL__First_Week_Of_Year__c, ACCL__Promotion_Aggregation_Level__c FROM ACCL__Sales_Organization__c WHERE ACCL__Global_Sales_Org__c = true Limit 1];
        
        cacheSalesOrganizationRecord(salesOrganizationRecord);
    }
     /*******************************************************************
    Purpose: Validate dummy products per each Tactic
    Version: 1.0
    Parameters: Transaction id and BOPromotion Content from controller-MyPromotionRemoteActionExtension
    Returns: Void
    Throws N/A
    ********************************************************************/
    public static void validateDummyProdsonTactics(string txid,string Content){
     boolean containsDummyProd = false;
     boolean isTacticOffinvoice = false;
     final string offinvoice = 'OffInvoice';
     final string materialType = 'ZFIN';
     Map<id,ACCL__Tactic__c> tacticMap = new Map<id,ACCL__Tactic__c>();
     Map<id,ACCL__Product__c> productMap = new Map<id,ACCL__Product__c>();
     Map<string,string> tacticidProdId = new Map<string,string>();
      List<Map<String, Object> > herokuProducts = new List<Map<String, Object>>();
      Map<String, Set<String>> tacticidProdSet = new Map<String, Set<String>>();
     Map<id,id> prodIdTacticID = new Map<id,id>(); 
       Set<String> tacticSet;
        Set<Id> productIdSet;
        Map<string,set<string>> prodIdTacticSet;
 
 //To get products(including Manual products from Heroku -- Chandrababu
                herokuProducts = UL_TacticUtility.readLOExtProduct(txId,content);
                
                if(herokuProducts.size()>0){
                    productIdSet = new Set<Id>(); 
                    prodIdTacticSet = new Map<string,set<string>>();
                    
                    for(Map<String,Object> prods : herokuProducts){
                        productIdSet.add((Id)prods.get(UtilityEnum.productid.Name()));
                        list<UL_TacticUtility.TacticWrapper> tacwrap = (list<UL_TacticUtility.TacticWrapper>)prods.get(UtilityEnum.Tactics.Name());
                        tacticSet = new Set<String>();
                        for(UL_TacticUtility.TacticWrapper eachTactic : tacwrap){
                            if(UtilityEnum.MATCH.Name().equalsIgnoreCase(eachTactic.Included)  || UtilityEnum.INCLUDED.Name().equalsIgnoreCase(eachTactic.Included) || eachTactic.Included == String.valueOf(UL_Utility.BOOLEAN_TRUE).toLowerCase()){
                                tacticSet.add((string)eachTactic.tacticId);
                                tacticidProdId.put((string)eachTactic.tacticId,(string)prods.get(UtilityEnum.productid.Name()));
                            }
                        }
                        prodIdTacticSet.put((string)prods.get(UtilityEnum.productid.Name()),tacticSet);
                        
                    }
                    }
                       if(prodIdTacticSet!=null){
                                          for(String prod : prodIdTacticSet.keySet()){
                                                         for(String tac : prodIdTacticSet.get(prod))
                                                         {
                                                                    if(!tacticidProdSet.containskey(tac))
                                                                    {
                                                                          tacticidProdSet.put(tac, new Set<String>());
                                                                     }
                                                                   tacticidProdSet.get(tac).add(prod);
                                                            }
                                                         }
                                                         }

                   if(prodIdTacticSet!=null && prodIdTacticSet.keyset().size()>0){ 
                    for(ACCL__Tactic__c tacticObj : [select id,ACCL__Payment_Method__c,ACCL__Tactic_Template__r.UL_Validate_Dummy_Products__c from ACCL__Tactic__c where id in:tacticidProdSet.keyset()]){
                     tacticMap.put(tacticObj.id,tacticObj);
                     
                    }
                    for(ACCL__Product__c prodObj : [select id,UL_Material_Type__c from ACCL__Product__c where id in: prodIdTacticSet.keyset()]){
                      productMap.put(prodObj.id,prodObj);
                    }
                    }
                    String materialTypeString = UL_Utility.STRING_NULL;
                    for(String tacticID : tacticidProdSet.keyset()){
                        if(tacticID!=null && tacticMap.get(tacticID).ACCL__Payment_Method__c!=null && tacticMap.get(tacticID).ACCL__Payment_Method__c.containsignorecase(offinvoice) && tacticMap.get(tacticID).ACCL__Tactic_Template__r.UL_Validate_Dummy_Products__c){
                           
                           for(String productId : tacticidProdSet.get(tacticID)){
                             if(materialTypeString==null){
                              materialTypeString = productMap.get(productId).UL_Material_Type__c;
                              }
                              else
                              {
                                materialTypeString += productMap.get(productId).UL_Material_Type__c;
                              }
                           }
                          
                           if(materialTypeString !=null && !materialTypeString.containsIgnorecase(materialType)){
                             throw new CustomException(label.UL_DummyProdonTactic);
                           }
                        }
                        materialTypeString = UL_Utility.STRING_NULL;
                    }
                  
    }
     
     
}