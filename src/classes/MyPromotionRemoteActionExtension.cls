/***************************************************************
Name: MyPromotionRemoteActionExtension 
Copyright © 2016 Accenture
======================================================
Purpose:
Utility extention class for Promotion SmartUI
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Badri         16/12/2016     INITIAL DEV            
2.0         Eleonora Dotz 24.01.2017     Add a function "readLOCalPromotions" to get special Event displayed in Trade Calendar   TPM-243 
***************************************************************/
global class MyPromotionRemoteActionExtension {
    
    //Private static declaration
    private static final String CUSTOM_OBJECT_POSTFIX = '__c'; 
    
    /*******************************************************************
Purpose: Default constructor  
Version 1.0
Parameters: Promotion Standard Controller
Returns: N/A
Throws : N/A 
********************************************************************/  
    global MyPromotionRemoteActionExtension(ApexPages.StandardController ctr) {
    }
    
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
Purpose: Handles 'Save & Refresh' and 'Done' button click events on Promotion SmartUI.  
Version 1.0
Parameters: Transaction Id, Promotion Id, Promotion Content 
Returns: JSON Promotion Content
Throws : N/A 
********************************************************************/     
    @RemoteAction
    global static String writeBOPromotion(String txId, String objectId, String content) {
        System.debug('@@@@objectId: ' + objectId + '-' + content);
        List<Map<String, Object> > herokuProducts = new List<Map<String, Object>>();
        String result = UL_Utility.STRING_NULL;
        Map<string,set<string>> prodIdTacticSet = new Map<string,set<string>>();
        Set<String> tacticSet;
         
        try{
            /*Remove namespace from the custom fields.*/ 
            //content=content.replace('ACCL__UL_','UL_');
            system.debug('before content-'+content);
            content = UL_PromotionContentReplace.replaceFieldContent(content);
            system.debug('after content-'+content);
            Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
            string contentTarget = (string) tacticDeserializedMap.get(UtilityEnum.target.Name());
            Map<String, Object> boPromotion = (Map<String, Object>) tacticDeserializedMap.get('BOPromotion');
            List<Object> tacticWithTiersList = (List<Object>) boPromotion.get('LOExtTacticTiers');
             List<Object> LOfund = (List<Object>) boPromotion.get('LOFund'); // add on 23.1 
            if(contentTarget!=null && contentTarget==UtilityEnum.Salesforce.Name()){
                
                //Update Workflow Threshold on every save to see latest Threshold values --Chandrababu
                UL_ThresholdEngine.getThresholdKPI(txId,id.valueof(objectId),UtilityEnum.target.Name());
                if(UL_ThresholdEngine.thresholdcheck!=null && UL_ThresholdEngine.thresholdcheck.size()>0){
                    Map<String, Object> contentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
                    Map<String, Object> Promotionobj = (Map<String, Object>) contentDeserializedMap.get(UtilityEnum.BOPromotion.Name());
                    Promotionobj.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Threshold_Window_Result__c.getName(), JSON.serialize(UL_ThresholdEngine.thresholdcheck));
                    Promotionobj.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Threshold_Result__c.getName(), JSON.serialize(UL_ThresholdEngine.thresholdcheck).subString(0,255));
                    
                    if(JSON.serialize(UL_ThresholdEngine.thresholdcheck).containsIgnoreCase(UtilityEnum.fail.Name())){
                        Promotionobj.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_ThresholdViolated__c.getName(),true);
                    }
                    
                    content = JSON.serialize(contentDeserializedMap);
                    
                }
                //To get products(including Manual products from Heroku -- Chandrababu
                herokuProducts = UL_TacticUtility.readLOExtProduct(txId,content);
                System.debug('@@@herokuProducts: ' + herokuProducts);
                System.Debug ('Ashish Test' + content);
                //herokuProducts = readLOExtProduct(txId,content);
                System.Debug ('Ashish Test Heroku Product' + herokuProducts);
                
                if(herokuProducts.size()>0){
                   
                    prodIdTacticSet = new Map<string,set<string>>();
                    for(Map<String,Object> prods : herokuProducts){
                        list<UL_TacticUtility.TacticWrapper> tacwrap = (list<UL_TacticUtility.TacticWrapper>)prods.get(UtilityEnum.Tactics.Name());
                        tacticSet = new Set<String>();
                        for(UL_TacticUtility.TacticWrapper eachTactic : tacwrap){
                            if(UtilityEnum.MATCH.Name().equalsIgnoreCase(eachTactic.Included)  || UtilityEnum.INCLUDED.Name().equalsIgnoreCase(eachTactic.Included) || eachTactic.Included == String.valueOf(UL_Utility.BOOLEAN_TRUE).toLowerCase()){
                                tacticSet.add((string)eachTactic.tacticId);
                            }
                        }
                        prodIdTacticSet.put((string)prods.get(UtilityEnum.productid.Name()),tacticSet);
                    }
                }
                //Validatation-At least one dummy product per each off-invoice payment method Tactic.
                //UL_TacticUtility.validateDummyProdsonTactics(txId,content);
                
                //Validate Products at Tactics level and vaidate Tactics Overlap
                UL_TacticUtility.validateTacticsProducts(txId,content,prodIdTacticSet);
                
                List<Promotion_Attachment_Link__c> promotionAttachmentLinks = MyPromotionRemoteActionExtension2.initPromotionAttachmentLinks(txId,content);
                if(promotionAttachmentLinks != null && promotionAttachmentLinks.size() > 0){
                    Database.insert(promotionAttachmentLinks);
                } 
                
                content = populateCannibalisationRate(content, prodIdTacticSet.keySet());
                System.debug('@@@@content after populate: ' +content);
                //add new promo_acc_rel__c 
                writePromoAccRel(txId,content);
                result = ACCL.PromotionRemoteActionExtension.writeBOPromotion(txId,objectId,content);
                system.debug('tacticWithTiersList'+tacticWithTiersList);
                system.debug('content'+content);
                Map<String,String> tactIdTiersMap = new Map<String,String>();
         for(Object o:tacticWithTiersList){
             Map<String,Object> tempMap = (Map<String,Object>) o;
             String tactId = String.valueOf(tempMap.get('tacticId'));
             String tiers = JSON.serialize(tempMap.get('JSONTier'));
             SYSTEM.DEBUG('tiers'+tiers);
             tactIdTiersMap.put(tactId,tiers);
         }
         
         List<ACCL__Tactic__c> tacticListToUpdate = [SELECT id,UL_Tier_Definition__c FROM ACCL__Tactic__c WHERE id IN: tactIdTiersMap.keySet()];
         For(ACCL__Tactic__c tact : tacticListToUpdate){
             tact.UL_Tier_Definition__c=tactIdTiersMap.get(tact.id);
         }
                update tacticListToUpdate;
                // add on 23.1 
         system.debug('LOfund '+LOfund);
         if(!LOfund.isEmpty()){
            System.debug('@@@@call to writeLOTacticFund');
            writeLOTacticFund(content);
            System.debug('@@@@Endcall to writeLOTacticFund');
             }
                
                
                
            }
            else{
                 result = ACCL.PromotionRemoteActionExtension.writeBOPromotion(txId,objectId,content);
            }
            
            //Insert record to Promotion Category
            if(!prodIdTacticSet.isEmpty()){
                Set<Id> productIdSet = new Set<Id>(); 
                for(String productId : prodIdTacticSet.keySet()){
                    productIdSet.add(productId);
                }
                UL_PromotionUtility.updatePromotionProduct(objectId, productIdSet);
            }
            
        }catch(Exception ex){
            System.debug('@@@@Exception ex: ' + ex.getMessage());
            throw ex;
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        
        
        system.debug('end');
        return result; 
    }
    
    /*******************************************************************
Purpose: Apply filters on Promotion SmartUI.  
Version 1.0
Parameters: Transaction Id, Promotion Content 
Returns: List of FilterItem Object
Throws : N/A 
********************************************************************/     
   /* @RemoteAction
    global static List<ACCL.PromotionRemoteActionExtension.FilterItem> readLOExtPrdFilters(String txId, String objectContent) {
        List<ACCL.PromotionRemoteActionExtension.FilterItem> result = new List<ACCL.PromotionRemoteActionExtension.FilterItem>();
        try{
            List<ACCL.PromotionRemoteActionExtension.FilterItem> allfilters = ACCL.PromotionRemoteActionExtension.readLOExtPrdFilters(txId, objectContent);
            
            for (ACCL.PromotionRemoteActionExtension.FilterItem filter:allfilters){
                if (!filter.filterId.equals('ACCL__category__c'))
                    result.add(filter);
            }
            
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        return result;
    }*/
        @RemoteAction @ReadOnly
    global static List<ACCL.PromotionRemoteActionExtension.FilterItem> readLOExtPrdFilters(String txId, String objectContent)
    {
   // LoggerUtility.enterMethod(className, 'readLOExtPrdFilters', sWatch, txId, new String[] {objectContent});
    Map<String, Set<ACCL.PromotionRemoteActionExtension.FilterItem>> prdFilters = new Map<String, Set<ACCL.PromotionRemoteActionExtension.FilterItem>>();
    List<ACCL.PromotionRemoteActionExtension.FilterItem> result = new List<ACCL.PromotionRemoteActionExtension.FilterItem>();
    List<ACCL__Product__c> cachedProducts;

    try {

                               List<Schema.FieldSetMember> fields = SObjectType.ACCL__Product__c.FieldSets.ACCL__TacticFilterCriteria.getFields();
                               Map<String, Schema.SObjectField> productFields = Schema.SObjectType.ACCL__Product__c.fields.getMap();

                               for(Schema.FieldSetMember field : fields) {
                                               String fieldPath = field.getFieldPath();
                                               Schema.DescribeFieldResult fieldDescribe = productFields.get(fieldPath).getDescribe();
                                               Schema.DisplayType fieldType = field.getType();
                                               //System.debug(LoggingLevel.ERROR,'AContainsKEy CHECK');
                                               if(!prdFilters.containsKey(fieldPath)) {
                                                               prdFilters.put(fieldPath, new Set<ACCL.PromotionRemoteActionExtension.FilterItem>());
                                               }
                                               Set<ACCL.PromotionRemoteActionExtension.FilterItem> currentSet = prdFilters.get(fieldPath);

                                               if(fieldType == Schema.DisplayType.Picklist) {

                                                               List<Schema.PicklistEntry> picklist = fieldDescribe.getPicklistValues();
                                                               for(Schema.PicklistEntry picklistEntry : picklist) {
                                                                               ACCL.PromotionRemoteActionExtension.FilterItem item = new ACCL.PromotionRemoteActionExtension.FilterItem(fieldPath.toLowerCase(), field.getLabel().capitalize(), picklistEntry.getValue(), picklistEntry.getLabel());
                                                                               //System.debug(LoggingLevel.ERROR,'Adding Item to Set picklist');
                                                                               currentSet.add(item);
                                                                               //result.add(item);
                                                               }
                                               }
                                               else if(fieldType == Schema.DisplayType.REFERENCE) {
                                                               cachedProducts = cachedProducts == null ? getProductsWithFilterFields(fields) : cachedProducts;
                                                               Set<Id> criterionProductIdSet = UL_CollectionsUtil.getSetOfIdsFromListOfSObjects(fieldPath, cachedProducts);
                                                               criterionProductIdSet.remove(null);

                                                               for(ACCL__Product__c product: cachedProducts ) {
                                                                               if(criterionProductIdSet.contains(product.Id)) {
                                                                                              ACCL.PromotionRemoteActionExtension.FilterItem item = new ACCL.PromotionRemoteActionExtension.FilterItem(fieldPath.toLowerCase(), field.getLabel().capitalize(), product.Id, product.ACCL__Description_1__c);
                                                                                              //System.debug(LoggingLevel.ERROR,String.format('Adding Item to Set REFERENCE {0} {1}',new List<String>{fieldPath, product.Id}));
                                                                                              currentSet.add(item);
                                                                                              //result.add(item);
                                                                               }
                                                               }
                                               }

                                               else if(fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.String ) {
                                                               cachedProducts = cachedProducts == null ? getProductsWithFilterFields(fields) : cachedProducts;
                                                               Set<String> fieldValues = new Set<String>();
                                                               for(ACCL__Product__c product : cachedProducts) {
                                                                               Object value = product.get(fieldPath);
                                                                               if( value != null ) {
                                                                                              String stringified = String.valueOf(value);
                                                                                              fieldValues.add(stringified);
                                                                               }
                                                               }

                                                               for(String fieldValue : fieldValues) {
                                                                               ACCL.PromotionRemoteActionExtension.FilterItem item = new ACCL.PromotionRemoteActionExtension.FilterItem(fieldPath.toLowerCase(), field.getLabel().capitalize(), fieldValue, fieldValue );
                                                                               currentSet.add(item);
                                                               }
                                               }              
                               }
                               System.debug('cached after ' + cachedProducts.size());

                               for(String key : prdFilters.keySet()) {
                                               result.addAll(prdFilters.get(key));
                               }
                }
    finally  {
                               //LoggerUtility.leaveMethod(className, 'readLOExtPrdFilters', sWatch, txId, result);
    }
    return result; //new List<FilterItem>(result);
}

    private static List<ACCL__Product__c> getProductsWithFilterFields(List<Schema.FieldSetMember> fields) {
    List<String> fieldPaths = new List<String>();
    for(Schema.FieldSetMember field : fields) {
                               fieldPaths.add(field.getFieldPath());
    }
    string nameSp = 'ACCL__';
    fieldPaths.add(nameSp+'Description_1__c');
    fieldPaths.add(nameSp+'Product_Level__c');
    UL_SecurityUtil.checkObjectIsAccessibleOrThrowError(nameSp+Constants.OBJECT_PRODUCT);
    UL_SecurityUtil.checkFlsPermissionOrThrowError (nameSp+Constants.OBJECT_PRODUCT, fieldPaths, Constants.FLS_VIEW) ;
    String joinedFields = String.join(fieldPaths, ',');
    return (List<ACCL__Product__c>)(Database.query(String.format('SELECT {0} from ACCL__Product__c ', new List<String>{joinedFields})));
    }
    /*******************************************************************
    Purpose: Invokes Promotion workflow  
    Version 1.0
    Parameters: Transaction Id, Promotion Id, Status Mode 
    Returns: String
    Throws : N/A 
    ********************************************************************/     
    @RemoteAction
    global static String invokeWfBOPromotion(String txId, String objectId, String Mode, String Content) {        
        String result = 'test';
        String STATUS_BANDED_PACK = 'Banded Pack Approved';

        try{
            Id promoId = Id.valueOf(objectId);
            system.debug('promoId ::: '+promoId);
            system.debug('Mode ::: '+Mode);
            String thresholdResult = UL_Utility.EMPTY_STRING;
            Boolean THViolate;
            Id apprFuncRet = UL_Utility.NULL_ID;
            List<ACCL__Promotion__c> promoLst = new List<ACCL__Promotion__c>() ;
            List<Id> approverIdsLst = new List<Id>() ;
                    
            promoLst = [SELECT UL_PromotionTemplateType__c, UL_Threshold_Window_Result__c,Id, Name, CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c, UL_Finance_Check_Approvers__c,UL_Manager_Check_Approvers__c,ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c, ACCL__Active__c, ACCL__Promotion_Template__c FROM ACCL__Promotion__c WHERE Id =: promoId] ;
            approverIdsLst.add(promoLst[0].createdbyid) ;
            THViolate = promoLst[0].UL_ThresholdViolated__c ; 
             
             /*****TPM 1599 STARTS*****/
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMITTED_FOR_APPROVAL) || Mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT)){
                
                if(Mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMITTED_FOR_APPROVAL) && promoLst[0].UL_PromotionTemplateType__c.equalsIgnoreCase(UL_Utility.LTA)){
                    AggregateResult attCountAgrResult = [SELECT Count(Id)attCount FROM Promotion_Attachment_Link__c WHERE Promotion__c = :promoId];
                    Integer attCount = Integer.valueOf(attCountAgrResult.get('attCount'));
                    if(attCount == 0){
                        throw new UL_CustomException(Label.Attachment_Count_Error_Message);
                    }                   
                }
                
                Set<String> tacticMandatory = new Set<String>();
                for(ACCL__Tactic__c tctic : [SELECT ACCL__Tactic_Template__c FROM ACCL__Tactic__c WHERE ACCL__Promotion__c = :promoId]){
                        tacticMandatory.add(promoLst[0].ACCL__Promotion_Template__c+UL_Utility.HYPHEN+tctic.ACCL__Tactic_Template__c);
                }

                Boolean tacticMandatoryEmpty = false;
                if(tacticMandatory.isEmpty()){
                    tacticMandatoryEmpty = true;
                }

                String missingTactics = UL_Utility.EMPTY_STRING;
                for(ACCL__Promotion_Template_Tactic_Template__c promTactTempJunc : [SELECT ACCL__Promotion_Template__c, ACCL__Tactic_Template__c, ACCL__Tactic_Template__r.Name FROM ACCL__Promotion_Template_Tactic_Template__c WHERE ACCL__Promotion_Template__c = :promoLst[0].ACCL__Promotion_Template__c AND isMandatory__c = True]){
                    if(!tacticMandatory.contains(promTactTempJunc.ACCL__Promotion_Template__c+UL_Utility.HYPHEN+promTactTempJunc.ACCL__Tactic_Template__c) ||
                        tacticMandatoryEmpty){
                        missingTactics = missingTactics + promTactTempJunc.ACCL__Tactic_Template__r.Name + UL_Utility.FIELD_SPLITTER;
                    }
                }

                if(!string.isBlank(missingTactics)){
                    //Splits the custom label based on character ,
                    List<String> splitMsg = Label.Requires_All_Mandatory_Tactic_for_Promotion.split(UL_Utility.FIELD_SPLITTER);
                    throw new UL_CustomException(splitMsg[0]+UL_Utility.SPACE+UL_Utility.ESCAPE_QUOTE+missingTactics.removeEnd(UL_Utility.FIELD_SPLITTER)+UL_Utility.ESCAPE_QUOTE+UL_Utility.SPACE+splitMsg[1]);
                }                
            }
            /*****TPM 1599 ENDS*****/
            
            
            // for UKSO or Ireland So
            if((promoLst[0].ACCL__Sales_Org__c == UL_Utility.UK_SO) || (promoLst[0].ACCL__Sales_Org__c == UL_Utility.Ireland_SO)){
                
                
                if(Mode == 'Submitted for Approval'){                    
                    promoLst[0].UL_Current_Status__c = 'Finalised';
                }
                else{
                    promoLst[0].UL_Current_Status__c = Mode;
                    
                }
            
            update promoLst;
                
            }
            if ((promoLst[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.AR01.Name()) || (promoLst[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.CL01.Name()) ||
            (promoLst[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.CL03.Name())){
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.toUpperCase())){
                
                //Before submitting promotion for approval, check if each tactic has a fund associated
                if(!hasTacticAssignedFund(promoId)){
                    //throw new UL_CustomException(Label.UL_TACTIC_FUND_ASSOCIATION);
                }
                
                 //Validatation-At least one dummy product per each off-invoice payment method Tactic.
                UL_TacticUtility.validateDummyProdsonTactics(txId,content);
                
                UL_ThresholdEngine.getThresholdKPI(txId,promoId,Mode);
                
                if(!THViolate){
                UL_PromotionWorkflowService.submitForApproval(promoId,promoLst,promoLst[0].createdby.UL_Finance_Manager__c,false) ;
                    if(promoLst[0].UL_Threshold_Window_Result__c != null){
                        do{ 
                            apprFuncRet = UL_PromotionWorkflowService.approveWorkflow(promoId,promoLst,null,false) ;
                            promoLst = [SELECT UL_Threshold_Window_Result__c,Id, Name,CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c,  ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c  FROM ACCL__Promotion__c WHERE Id =: promoId] ;        
                        } while(apprFuncRet != null && !THViolate && promoLst[0].UL_Current_Status__c != UL_Utility.STATUS_APPROVED
                        && promoLst[0].UL_Current_Status__c != STATUS_BANDED_PACK);
                    }
                }
            }
           
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_APPROVE)){           
                apprFuncRet = UL_PromotionWorkflowService.approveWorkflow(promoId,promoLst,promoLst[0].UL_Current_Status__c, false) ; 
            }
            
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_REJECT.toUpperCase())){
                UL_PromotionWorkflowService.rejectWorkflow(promoId,promoLst,false);
            }
            
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_CLOSED.toUpperCase())){
                List<Id> promotionIds = new List<Id>{(Id) objectId};
                return UL_PromotionClosure.closePromotions(promotionIds);
            }
            
            if(Mode.equalsIgnoreCase('EndDate')){           
                //throw new UL_CustomException('end date....');
                try{
                    ACCL__Promotion__c promoObj = new ACCL__Promotion__c() ;
                    List<ProcessInstance> procInstLst = new List<ProcessInstance>() ;
                    
                    promoObj = [SELECT UL_Threshold_Window_Result__c,Id, Name,CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c,  ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c  FROM ACCL__Promotion__c WHERE Id =: promoId] ;        
                    procInstLst = [SELECT Id,TargetObjectId,ProcessDefinition.Name From ProcessInstance Where TargetObjectId =: promoId] ;
                    
                    if(promoObj.UL_Current_Status__c == 'Approved' && promoObj.ACCL__Date_From__c <= system.Today() && promoObj.ACCL__Date_Thru__c >= system.Today()
                        && !procInstLst[0].ProcessDefinition.Name.containsIgnoreCase('parent')){
                        promoObj.UL_Current_Status__c = 'End Date';
                        update promoObj ;
                    }
                    else{
                        throw new UL_CustomException('You can only End Date a non-parent promotion, which is in Approved state and currently running') ;
                    }
                }
                catch(Exception excObj){
                    throw excObj;
                }
            }      
          }
        }
        catch(Exception ex){
            throw ex ;
          UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return result;
    }
    
    /***************************************************************
Name: EARUI
Copyright © 2016 Accenture
======================================================
Purpose:
Wrapper class to send Promotion content to SmartUI
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Badri         16/12/2016     INITIAL DEV            
***************************************************************/
    global class EARUI{
        public String Name;
        public String Type;
        public boolean Editable;
        public boolean Visible;
    }

/*******************************************************************
Purpose:   
Version 1.0
Parameters: Transaction Id, Promotion Id
Returns: List of EARUI custom object
Throws : N/A 
********************************************************************/ 

global static EARUI RightsBOPromotion_SoCo(String txId, String objectId){
        List<EARUI> earBOPromotion = new List<EARUI>();
        
        Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
        Id promoId = (Id)unTypedMap.get(UtilityEnum.Id.Name()); 
        String objectName =  String.valueOf(((Id)promoId).getSObjectType());
        List<ACCL__Promotion__c> PromoList = new List<ACCL__Promotion__c>();
        promoList = [SELECT Id, Name,UL_PromotionTemplateType__c, UL_Current_Status__c,UL_Parent_Push_Id__c, ACCL__Sales_Org__c,UL_EnableChild__c,ACCL__Promotion_Template__c FROM ACCL__Promotion__c WHERE Id =:promoId];
        
        //for hiding lift field from promotion page when Promotion template is LTA
                System.debug('UL_PromotionTemplateType__c '+promoList[0].UL_PromotionTemplateType__c);
                EARUI promoObject = new EARUI();
                promoObject.Name = 'UL_Lift__c';
                promoObject.Type = 'Attribute';
                promoObject.visible = false;
                earBOPromotion.add(promoObject); 
                

            //Added to control the visibility of the Lift% on the Tactic Panel . 
                //Ashish - Added - 18/01/2017
               /* String TacticLift ='TacticLift'; //= 'ACCL__Lift__c' ;
                EARUI DrillDown_Lift_Field = new EARUI();
                DrillDown_Lift_Field.Name = TacticLift;
                DrillDown_Lift_Field.Type = 'Attribute';
                DrillDown_Lift_Field.visible = false;  
                earBOPromotion.add(DrillDown_Lift_Field);
                //Ashish - End- 18/01/2017*/
            
       return promoObject;     
        
}
    
    
    
    /*******************************************************************
Purpose:   
Version 1.0
Parameters: Transaction Id, Promotion Id
Returns: List of EARUI custom object
Throws : N/A 
********************************************************************/    
    @RemoteAction
    global static List<EARUI> getEARightsBOPromotion(String txId, String objectId){
        
        List<EARUI> earBOPromotion = new List<EARUI>();
        //getEARightsBOPromotion_SoCo(txId,objectId);
        //
        try{
            
            Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
            Id promoId = (Id)unTypedMap.get(UtilityEnum.Id.Name()); 
            String objectName =  String.valueOf(((Id)promoId).getSObjectType());
            List<ACCL__Promotion__c> PromoList = new List<ACCL__Promotion__c>();
            promoList = [SELECT Id, Name, UL_Current_Status__c,UL_Parent_Push_Id__c, UL_PromotionTemplateType__c, ACCL__Sales_Org__c,UL_EnableChild__c,ACCL__Promotion_Template__c FROM ACCL__Promotion__c WHERE Id =:promoId];
            //for hiding lift field from promotion page when Promotion template is LTA
            System.debug('promoList[0].UL_PromotionTemplateType__c::::::::::'+promoList[0].UL_PromotionTemplateType__c);
            
            if(promoList[0].UL_PromotionTemplateType__c == 'LTA'){
                //for(List<ACCL__Promotion__c> promList : [SELECT Id, ACCL__Promotion_Template__r.Name FROM ACCL__Promotion__c WHERE ACCL__Promotion_Template__r.Name = 'LTA - Long Term Agreement AR01']){
                    EARUI promoObject = new EARUI();
                    promoObject.Name = 'UL_Lift__c';
                    promoObject.Type = UtilityEnum.Attribute.Name();
                    promoObject.visible = false;
                    earBOPromotion.add(promoObject);
                    
                    EARUI DrillDown_Lift_Field = new EARUI();
                    DrillDown_Lift_Field.Name = 'TacticLift';
                    DrillDown_Lift_Field.Type = 'Attribute';
                    DrillDown_Lift_Field.visible = false;  
                    earBOPromotion.add(DrillDown_Lift_Field);
                    
                //}
                
            }
            String status = promoList[0].UL_Current_Status__c;
            
            
            if(((promoList[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.AR01.Name()) ||(promoList[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.CL01.Name()) ||(promoList[0].ACCL__Sales_Org__c ==UL_Utility.SalesOrg.CL03.Name()))){
                objectName = objectName.replace(UL_Utility.MANAGEDPACKAGE_NAMESPACE, UL_Utility.EMPTY_STRING);
                objectName = objectName.replace(CUSTOM_OBJECT_POSTFIX,UL_Utility.EMPTY_STRING);
                UL_SmartUIEditability__c settings = UL_SmartUIEditability__c.getValues(objectName+UL_Utility.UNDERSCORE+status);    
                if(settings != null){
                    Schema.FieldSet fldSet = Schema.SObjectType.ACCL__Promotion__c.fieldSets.getMap().get(settings.UL_Fieldset_Name__c);
                    for(Schema.FieldSetMember fld: fldSet.getFields()){ 
                        
                        //Ketan - added the following condition since 'Promotion Name' must always be readonly even Promotion is not in approval process.
                        /*if(fld.getFieldPath().equalsIgnorecase(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Slogan__c.getName())){
                            continue;
                        }*/
                        EARUI promoObject = new EARUI();
                        promoObject.Name = fld.getFieldPath();
                        promoObject.Type = UtilityEnum.Attribute.Name();
                        promoObject.editable = false;  
                        earBOPromotion.add(promoObject);
                    }
                }
                
                //-------------Hiding UKI specific fields for SoCo------------------------
                Schema.FieldSet hidhngFields = Schema.SObjectType.ACCL__Promotion__c.fieldSets.getMap().get('UL_SoCo_Hidden_Fields');
                for(Schema.FieldSetMember fld: hidhngFields.getFields()){ 
                    
                    EARUI promoObject = new EARUI();
                    promoObject.Name = fld.getFieldPath();
                    promoObject.Type = UtilityEnum.Attribute.Name();
                    promoObject.Visible = false;  
                    earBOPromotion.add(promoObject);
                }
                
                //Ketan - added the following code since 'Promotion Name' should always be readonly even Promotion is not in approval process.
                /* Making Slogan editable for SoCo
                EARUI promoObject = new EARUI();
                promoObject.Name = Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Slogan__c.getName();
                promoObject.Type = UtilityEnum.Attribute.Name();
                promoObject.editable = false;  
                earBOPromotion.add(promoObject);
                */
                
                
                if(promoList[0].UL_EnableChild__c == true){
                    Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACCL__Promotion__c.fields.getMap();
                    for(String s : fldObjMap.keySet())
                    {
                        if(fldObjMap.get(s).getDescribe().isUpdateable()){
                            EARUI promoField = new EARUI();
                            promoField.Name = fldObjMap.get(s).getDescribe().getName();
                            promoField.Type = UtilityEnum.Attribute.Name();
                            promoField.editable = true;  
                            earBOPromotion.add(promoField);
                        }
                        
                    }
                }
                else if(promoList[0].UL_Parent_Push_Id__c !=UL_Utility.NULL_ID){
                    Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACCL__Promotion__c.fields.getMap();
                    for(String s : fldObjMap.keySet())
                    {
                        if(fldObjMap.get(s).getDescribe().isUpdateable()){
                            EARUI promoField = new EARUI();
                            promoField.Name = fldObjMap.get(s).getDescribe().getName();
                            promoField.Type = UtilityEnum.Attribute.Name();
                            promoField.editable = false;  
                            earBOPromotion.add(promoField);
                        }
                    }
                    List<EARUI> btListBtn = new List<EARUI>();
                     //btListBtn  = UL_ComponentVisibility.hideButtons(promoList[0].ACCL__Sales_Org__c, 'Child Promotions');                     
                     system.debug('vinod hide ---->'+btListBtn);
                     earBOPromotion.addall(btListBtn);
                     System.debug('vinod add buttons---->'+earBOPromotion);
                }
                
            }
            //Added by Abhishek for the visibility control of buttons for UKI
            boolean isChildPromotion = promoList[0].UL_Parent_Push_Id__c!=null ? true : false;
             List<EARUI> btList = new List<EARUI>();
             btList = UL_ComponentVisibility.hideButtons(promoList[0].ACCL__Sales_Org__c, status, isChildPromotion);
             earBOPromotion.addall(btList);
             System.debug('vinod add all buttons---->'+earBOPromotion);
            
            
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        } 
        system.debug('bansitest..'+earBOPromotion);
        return earBOPromotion; 
    }        
    
    /*@RemoteAction
global static List<EARUI> getEARightsLOTactic(String txId, String objectId){

List<EARUI> earBOPromotion = new List<EARUI>();

EARUI promoObject = new EARUI();
promoObject = new EARUI();
promoObject.Name = 'Instore_Date_From__c';
promoObject.Type='Attribute';
promoObject.visible=false;

earBOPromotion.add(promoObject);

return earBOPromotion; 
}  */
    
    
    /*******************************************************************
Purpose:  
Version 1.0
Parameters: Transaction Id, Promotion Id
Returns: List of EARUI custom object
Throws : N/A 
********************************************************************/        
    @RemoteAction
    global static List<EARUI> getEARightsLOTactic(String txId, String objectId){
        List<EARUI> earBOTactic = new List<EARUI>();
        ACCL__Promotion__c promo = new ACCL__Promotion__c();
        
        try{
            Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
            Id tacticParentId = (Id)unTypedMap.get(UtilityEnum.parentId.Name());
            /*if(promo.ACCL__Promotion_Template__r.UL_Promo_Type_ControlView__c == 'LTA'){
                Map<String, Schema.FieldSetMember> fldMap = new Map<String, Schema.FieldSetMember>();
                String fieldSetName = 'UL_UKI_LTA_Rate_Per_Case';
                system.debug('fieldSetName ::: '+fieldSetName);
                for(Schema.FieldSetMember fld : SObjectType.ACCL__Tactic__c.FieldSets.getMap().get(fieldSetName).getFields()){
                    fldMap.put(fld.getFieldPath().toLowerCase(), fld);
                }
                system.debug('fldMap ::: '+fldMap);
                system.debug(':::: '+[Select Id from ACCL__tactic__c where ACCL__Promotion__c =:tacticParentId LIMIT 1]);

                Map<String, Schema.SObjectField> fldObjTacticMap = schema.SObjectType.ACCL__Tactic__c.fields.getMap();
                system.debug('fldObjTacticMap ::: '+fldObjTacticMap);
                for(String fieldPathName : fldObjTacticMap.keySet()){
                    if(fldMap.containsKey(fieldPathName)){
                        EARUI tacticObject = new EARUI();
                        tacticObject.Name = fldObjTacticMap.get(fieldPathName).getDescribe().getName();
                        tacticObject.Type = 'Attribute';
                        tacticObject.visible = True;  
                        earBOTactic.add(tacticObject);
                    } else {
                        EARUI tacticObject = new EARUI();
                        tacticObject.Name = fldObjTacticMap.get(fieldPathName).getDescribe().getName();
                        tacticObject.Type = 'Attribute';
                        tacticObject.visible = False;  
                        earBOTactic.add(tacticObject);
                    }
                }
            }*/

            
            promo=[Select Id,UL_EnableChild__c, UL_Current_Status__c, ACCL__Sales_Org__c, UL_Parent_Push_Id__c, UL_PromotionTemplateType__c from ACCL__Promotion__c where ID =:tacticParentId LIMIT 1];
            List<ACCL__tactic__c> taclst = new List<ACCL__tactic__c>();
            System.debug('promo.UL_PromotionTemplateType__c::::::::::'+promo.UL_PromotionTemplateType__c);
            //for hiding lift field from Tactic page if tactic template is Long Term Agreement
            if(promo.UL_PromotionTemplateType__c == 'LTA'){
                //for(List<ACCL__tactic__c> tactList : [SELECT Id, ACCL__Tactic_Template__r.Name,ACCL__Promotion__c FROM ACCL__tactic__c WHERE ACCL__Tactic_Template__r.Name = 'Long Term Agreement AR']){
                    EARUI tacticObject = new EARUI();
                    tacticObject.Name = 'Lift__c';
                    tacticObject.Type = UtilityEnum.Attribute.Name();
                    tacticObject.visible = false; 
                    System.debug('tacticObject.visible'); 
                    earBOTactic.add(tacticObject);
                    
                //}   
            }
            
            boolean isChildPromotion = promo.UL_Parent_Push_Id__c!=null ? true : false;
            List<EARUI> btList = new List<EARUI>();
            btList = UL_ComponentVisibility.hideButtons(promo.ACCL__Sales_Org__c, promo.UL_Current_Status__c, isChildPromotion);
            earBOTactic.addall(btList);
            
            
            taclst = [Select Id, ACCL__Tactic_Template__r.UL_Redemption_Required__c from ACCL__tactic__c where ACCL__Promotion__c =:tacticParentId LIMIT 1];
            
            System.debug('taclst::::'+taclst);
            if(taclst.size() > 0){
                for(ACCL__tactic__c tactic : taclst){
                    Id tacticId = tactic.Id;
                    String objectName =  String.valueOf(((Id)tacticId).getSObjectType());
                    List<ACCL__Tactic__c> tacticList = new List<ACCL__Tactic__c>();
                    tacticList = [SELECT Id, Name, ACCL__Promotion__r.UL_Current_Status__c FROM ACCL__Tactic__c WHERE Id =:tacticId];
                    String status = tacticList[0].ACCL__Promotion__r.UL_Current_Status__c;
                    objectName = objectName.replace(UL_Utility.MANAGEDPACKAGE_NAMESPACE, UL_Utility.EMPTY_STRING);
                    objectName = objectName.replace(CUSTOM_OBJECT_POSTFIX,UL_Utility.EMPTY_STRING);
                    // UL_SmartUIEditability__c settings = UL_SmartUIEditability__c.getValues(objectName+UL_Utility.UNDERSCORE+status);
                  
                   UL_SmartUIEditability__c settings;
                   //Tactic field visibility when promotion status not in Planning.
                   if(status!=UL_UTILITY.STATUS_PLANNING){
                   settings = new UL_SmartUIEditability__c();
                   settings.UL_Fieldset_Name__c = 'UL_SoCo_NotApproved';
                   }
                          if(settings != null){
                        Schema.FieldSet fldSet = Schema.SObjectType.ACCL__Tactic__c.fieldSets.getMap().get(settings.UL_Fieldset_Name__c);
                        for(Schema.FieldSetMember fld: fldSet.getFields()){ 
                            
                            EARUI tacticObject = new EARUI();
                            tacticObject.Name = fld.getFieldPath();
                            tacticObject.Type = UtilityEnum.Attribute.Name();
                            tacticObject.editable = fld.getRequired();  
                            earBOTactic.add(tacticObject);
                        }
                        
                        //Soumyodeep
                        EARUI buttonOnTactic = new EARUI();
                        buttonOnTactic.Name = UtilityEnum.PP_BTN_MANAGE_PRODS.Name();
                        //buttonOnTactic.Name = 'Manage Products';
                        buttonOnTactic.Type = UtilityEnum.UIElement.Name();
                        buttonOnTactic.editable = false;
                        buttonOnTactic.Visible = false;
                        earBOTactic.add(buttonOnTactic);
                        //Soumyodeep
                    }
                    
                    //-----------Redemption - TPM 1775 - Omkar---------------
                    System.debug('tactic.ACCL__Tactic_Template__r.UL_Redemption_Required__c::::::'+tactic.ACCL__Tactic_Template__r.UL_Redemption_Required__c);
                    if(!tactic.ACCL__Tactic_Template__r.UL_Redemption_Required__c){
                        EARUI tacticObject = new EARUI();
                        tacticObject.Name = 'UL_Redemption__c';
                        tacticObject.Type = UtilityEnum.Attribute.Name();
                        tacticObject.Visible = false;                  
                        earBOTactic.add(tacticObject);
                    }
                }
            } 
            else{
                EARUI tacticObject = new EARUI();
                tacticObject.Name = 'UL_Redemption__c';
                tacticObject.Type = UtilityEnum.Attribute.Name();
                tacticObject.Visible = false;                  
                earBOTactic.add(tacticObject);
            }
            if(promo.UL_EnableChild__c == true){
                system.debug('UL_EnableChild__c IS TRUE');
                Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACCL__Tactic__c.fields.getMap();
                for(String s : fldObjMap.keySet())
                {
                    if(fldObjMap.get(s).getDescribe().isUpdateable()){
                        EARUI tacticObject = new EARUI();
                        tacticObject.Name = fldObjMap.get(s).getDescribe().getName();
                        tacticObject.Type = 'Attribute';
                        tacticObject.editable = true;  
                        earBOTactic.add(tacticObject);
                        
                    }
                    
                }
            }
            else
                if(promo.UL_Parent_Push_Id__c !=null){
                    system.debug('UL_EnableChild__c IS FALSE');
                    Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACCL__Tactic__c.fields.getMap();
                    for(String s : fldObjMap.keySet())
                    {
                        if(fldObjMap.get(s).getDescribe().isUpdateable()){
                            EARUI tacticObject = new EARUI();
                            tacticObject.Name = fldObjMap.get(s).getDescribe().getName();
                            tacticObject.Type = 'Attribute';
                            tacticObject.editable = false;  
                            earBOTactic.add(tacticObject);
                            
                        }
                        
                    }
                    
                }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        return earBOTactic;         
    }
    
    /*******************************************************************
Purpose: Get customer hierarchy  
Version 1.0
Parameters: Transaction Id, Promotion Content String
Returns: Map of Parent and child Customer(s) 
Throws : N/A 
********************************************************************/
    @RemoteAction
    global static Map<Id , Set<ChildAccounts>> readLOCustomerHierarchy (String txtID ,String objectContent) {
        
        Map<Id , Set<ChildAccounts>>  result = new Map<Id , Set<ChildAccounts>> ();
        try{
            ACCL__Promotion__c promo = new ACCL__Promotion__c();//should store the promotion from JSON
            String parentAccountId = UL_Utility.EMPTY_STRING; //should take it from JSON
            Map<Id,Id> childAccountMap = new Map<Id,Id>();
            Map<id, Id> includedAccountMap = new Map<id, Id>();
            List<Account> allchildAccount = new List<Account>();
            Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(objectContent);//deserializing the JSON from UI        
            Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get(UtilityEnum.BOPromotion.Name());//Get the promotion in Map format
            String promoID= String.valueOf(boPromotion.get(UtilityEnum.Id.Name()));
            
            if(boPromotion.get('Anchor_Account__c') !=null){
                parentAccountId=String.valueOf(boPromotion.get('Anchor_Account__c'));
            }
            else{
                parentAccountId=String.valueOf(boPromotion.get('Anchor_Account_set__c'));
            }    
            
            DescribeSObjectResult describeResultp = ACCL__Promotion__c.getSObjectType().getDescribe();
            List<String> fieldNamesp = new List<String>( describeResultp.fields.getMap().keySet());
            String queryp =
                ' SELECT ' +
                String.join( fieldNamesp, UL_Utility.FIELD_SPLITTER) +
                ' FROM ' +
                describeResultp.getName() +
                ' WHERE ' +
                ' id = :promoID ' +
                ' LIMIT 1 ';
            
            promo = Database.query( queryp ); 
            
            //get the included childs account for this specific promotion and parent account (From last push)
            for (Promotion_Acc_Rel__c p : [SELECT id, Child_Account__c FROM Promotion_Acc_Rel__c WHERE Parent_Promotion__c =: promo.id AND Parent_Account__c =: parentAccountId])
            {
                includedAccountMap.put(p.Child_Account__c, p.Child_Account__c);
            }
            
            //checking the type of customer to get the childs
            //if the customer is an account get the child list from ACCL__Account_Trade_Org_Hierarchy__c object
            if(promo.ACCL__Anchor_Account__c !=null){
                for (ACCL__Account_Trade_Org_Hierarchy__c a : [SELECT id,ACCL__Child_Account__c,ACCL__Parent_Account__c
                                                               FROM ACCL__Account_Trade_Org_Hierarchy__c
                                                               WHERE ACCL__Parent_Account__c=:parentAccountId  AND
                                                               ACCL__Valid_From__c >=: promo.ACCL__Date_From__c  AND
                                                               ACCL__Valid_Thru__c <=: promo.ACCL__Date_Thru__c]){
                                                                   childAccountMap.put(a.ACCL__Child_Account__c, a.ACCL__Child_Account__c);
                                                               }
                
                allchildAccount=[SELECT id,Name FROM Account WHERE id IN:childAccountMap.keyset()];    
            }
            //if the customer is an customer set get the child list from ACCL__Account_Set_Account__c 
            else{     
                for (ACCL__Account_Set_Account__c a : [SELECT id,ACCL__Account__c FROM ACCL__Account_Set_Account__c WHERE ACCL__Account_Set__c=:parentAccountId]){
                    childAccountMap.put(a.ACCL__Account__c, a.ACCL__Account__c);
                }
                
                allchildAccount=[SELECT id,Name FROM Account WHERE id IN:childAccountMap.keyset()];    
            }
            
            //Loop to all the child to define included/excluded and fill the return map
            for (Account a : allchildAccount)
            {
                ChildAccounts child = new ChildAccounts();
                Set<ChildAccounts> childSet = new Set<ChildAccounts>();
                if (includedAccountMap.containsKey(a.id))
                {
                    child.Included = true;
                    child.Name = a.Name;
                    child.CustomerID = parentAccountId;
                    child.PushedPromoID = promo.id;
                }else{
                    child.Included = false;
                    child.Name = a.Name;
                    child.CustomerID = parentAccountId;
                    child.PushedPromoID = promo.id;
                }
                
                childSet.add(child);
                result.put(a.id, childSet);
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        return result;
    }
    
    /*******************************************************************
Purpose: Handles 'Push' button event from Promotion SmartUI 
Version 1.0
Parameters: Transaction Id, Mode String ,Promotion Content String
Returns: N/A
Throws : N/A 
********************************************************************/    
    @RemoteAction
    //This function get the call from UI and call the push or enableChild functionality
    global static void InvokePushPromotion(String txtId,String mode,String promoContent ){
        try{
            if(mode==UtilityEnum.Push.Name()){
                CreatePushPromotions(promoContent);
            }
            else {
                if(mode==UtilityEnum.EnableChild.Name())
                    UpdateEnableChildPromoFlag(promoContent);//should send as parameter the id from promocontent
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }  
    
    /*******************************************************************
Purpose: Creates new child promotions(with tactics and funds) after the click on push button 
Version 1.0
Parameters: Promotion Content String
Returns: N/A
Throws : N/A 
********************************************************************/ 
    global static void CreatePushPromotions(String promoContent){
        
        // should include the child account list from UI with included and excluded
        List<ChildAccounts> childAccountList = new List<ChildAccounts>(); 
        ChildAccounts child = new ChildAccounts();
        child.Included=true;
        child.CustomerID='0015800000Yx5j5';
        try{
            childAccountList.add(child);
            
            ACCL__Promotion__c promotocopy = New ACCL__Promotion__c();//parent promotion
            List<ACCL__Promotion__c> promoListToinsert = New List<ACCL__Promotion__c>();//child promotions to insert
            Map <id,Promotion_Acc_Rel__c> allthePromoAccMap = New Map <id,Promotion_Acc_Rel__c> ();//Map<childAccountId,promotion_Acc>
            List<Promotion_Acc_Rel__c> promoAccrelToDelete = New List<Promotion_Acc_Rel__c>();//promotion_Acc of the child account that changed to exluded in the last save and refresh
            List<id> promoAccrelToAddChildId =New List<id>();//List of child account Id that we need to create promotion_Acc for
            List<Promotion_Acc_Rel__c> promoAccrelToAdd = New List<Promotion_Acc_Rel__c>();//List of new promotion_Acc to insert
            List<ACCL__Tactic__c> tactToInsert = new List<ACCL__Tactic__c>();//List of new Tactics that should be insert with the new child promotions
            List<ACCL__Tactic__c> tactToCopy = new List<ACCL__Tactic__c>();//List of the parent promotion tactics that we need to copy
            List< ACCL__Tactic_Fund__c> tactFundsToCopy = new List< ACCL__Tactic_Fund__c>(); //List of new Tactics Funds that should be insert with the new tactics
            List< ACCL__Tactic_Fund__c> tactFundsToInsert = new List< ACCL__Tactic_Fund__c>();//List of the parent promotion tactics funds that we need to copy
            List <id> tactToSelectList = new List <id>();     
            String promoCustomerType = UL_Utility.EMPTY_STRING;
            
            
            Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
            Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get(UtilityEnum.BOPromotion.Name());//Get the promotion in Map format
            List<Object> boPromotionTacticts = (List<Object>) boPromotion.get(UtilityEnum.LOTactic.Name());
            String promoID= String.valueOf(boPromotion.get(UtilityEnum.Id.Name()));
            
            DescribeSObjectResult describeResultp = ACCL__Promotion__c.getSObjectType().getDescribe();
            
            List<String> fieldNamesp = new List<String>( describeResultp.fields.getMap().keySet());
            
            String queryp =
                ' SELECT ' +
                String.join( fieldNamesp, UL_Utility.FIELD_SPLITTER) +
                ' FROM ' +
                describeResultp.getName() +
                ' WHERE ' +
                ' id = :promoID ' +
                ' LIMIT 1 ';
            
            promotocopy = Database.query( queryp ); 
            
            For(Object o : boPromotionTacticts){
                Map<String, Object> tactic = (Map<String, Object>) o;
                tactToSelectList.add(String.valueOf(tactic.get(UtilityEnum.Id.Name())));
            }  
            
            DescribeSObjectResult describeResult = ACCL__Tactic__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet());
            
            String query =
                ' SELECT ' +
                String.join( fieldNames, UL_Utility.FIELD_SPLITTER) +
                ' FROM ' +
                describeResult.getName() +
                ' WHERE ' +
                ' id IN:tactToSelectList ';
            
            tactToCopy = Database.query( query ); 
            
            //check the customer type in promotion
            if(promotocopy.ACCL__Anchor_Account__c!=null){
                promoCustomerType=UtilityEnum.Account.Name();
            }
            else {
                promoCustomerType=UtilityEnum.CustomerSet.Name();
            }
            //query the existing Promotion_Acc_Rel__c depended of the customer type
            if(UtilityEnum.Account.Name().equalsIgnoreCase(promoCustomerType)){
                for(Promotion_Acc_Rel__c par :[Select id,Child_Account__c FROM Promotion_Acc_Rel__c
                                               WHERE Parent_Account__c=:promotocopy.ACCL__Anchor_Account__c and Parent_Promotion__c=:promotocopy.id]){
                                                   allthePromoAccMap.put(par.Child_Account__c,par);
                                               }
                
            }else{
                for(Promotion_Acc_Rel__c par :[Select id,Child_Account__c FROM Promotion_Acc_Rel__c
                                               WHERE Parent_Account__c=:promotocopy.ACCL__Anchor_Account_Set__c and Parent_Promotion__c=:promotocopy.id]){
                                                   allthePromoAccMap.put(par.Child_Account__c,par);
                                               }
            }
            
            
            //delete all the last pushed promotions (should delete the tactics and funds too)
            delete [select id FROM ACCL__Promotion__c WHERE UL_Parent_Push_Id__c=: promotocopy.id];  
            
            //Loop on childAccountList(FROM UI) clone promotion if the child account is included and add the promotion_acc to delete list if it's exluded
            for(ChildAccounts cha: childAccountList){
                ACCL__Promotion__c clonepromo = promotocopy.clone();
                clonepromo.UL_Parent_Push_Id__c=promotocopy.id;
                if(cha.Included==true){
                    if(promoCustomerType==UtilityEnum.CustomerSet.Name())
                        clonepromo.ACCL__Anchor_Account_Set__c =null;
                    
                    clonepromo.ACCL__Anchor_Account__c=cha.CustomerID;
                    promoListToinsert.add(clonepromo);
                    if(!allthePromoAccMap.containsKey(cha.CustomerID))
                        promoAccrelToAddChildId.add(cha.CustomerID);
                }
                else
                    if(allthePromoAccMap.containsKey(cha.CustomerID))
                    promoAccrelToDelete.add(allthePromoAccMap.get(cha.CustomerID));
            }
            insert promoListToinsert;
            
            //Loop on the new promotions List after insert to copy the tactics from parent and relate them to the new promotions
            for(ACCL__Promotion__c p : promoListToinsert){
                for(ACCL__Tactic__c t :tactToCopy){
                    ACCL__Tactic__c newt = t.clone();
                    newT.ACCL__Promotion__c= p.id;
                    tactToInsert.add(newt);
                    
                }
            }
            insert tactToInsert;
            
            //Loop to create the new Promotion_Acc_Rel__c for the child account that have been included in the last save
            for(id i:promoAccrelToAddChildId){
                Promotion_Acc_Rel__c par = (Promotion_Acc_Rel__c)UL_Utility.getNewObject(Schema.SObjectType.Promotion_Acc_Rel__c);
                par.Child_Account__c=i;
                par.Parent_Promotion__c=promotocopy.id;
                
                if(promoCustomerType==UtilityEnum.CustomerSet.Name()){
                    par.Parent_Account__c= promotocopy.ACCL__Anchor_Account_Set__c;
                }
                else{
                    par.Parent_Account__c= promotocopy.ACCL__Anchor_Account__c;
                }
                promoAccrelToAdd.add(par);
            }
            insert promoAccrelToAdd;
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    /*******************************************************************
Purpose: Updates the enableChild field to get all the fields editable when the user click on enable child button 
Version 1.0
Parameters: Promotion Id
Returns: N/A
Throws : N/A 
********************************************************************/    
    global static void UpdateEnableChildPromoFlag(String objectId){
        try{
            List <ACCL__Promotion__c> childPromotions = new List <ACCL__Promotion__c>();
            ACCL__Promotion__c promo = new ACCL__Promotion__c();
            promo =[select id FROM ACCL__Promotion__c WHERE id=: objectId LIMIT 1];//should be taken from JSON objectId
            childPromotions=[SELECT id,UL_Parent_Push_Id__c,UL_EnableChild__c FROM ACCL__Promotion__c 
                             where UL_Parent_Push_Id__c=: promo.ID];
            for(ACCL__Promotion__c p : childPromotions){
                p.UL_EnableChild__c=true;
            }
            update childPromotions;
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    /*******************************************************************
Purpose: Validate Promotion threshold 
Version 1.0
Parameters: Transaction Id, Promotion Id, Status Mode
Returns: N/A
Throws : N/A 
********************************************************************/     
    @RemoteAction
    global static String invokePromotionThresholdCheckBOPromotion(String txId, String objectId){
        String result=UL_Utility.EMPTY_STRING;
        try{
            UL_ThresholdEngine.getThresholdKPI(txId,id.valueof(objectId),UtilityEnum.save.Name());
            if(UL_ThresholdEngine.thresholdcheck!=null && UL_ThresholdEngine.thresholdcheck.size()>0){
                if(JSON.serialize(UL_ThresholdEngine.thresholdcheck).containsIgnoreCase(UtilityEnum.result.Name())){
                    result =  JSON.serialize(UL_ThresholdEngine.thresholdcheck);
                }
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
            throw ex;
        }
        return result;
    }
    
    /*******************************************************************
Purpose: Populates Cannibalisation Rate on Promotion
Version 1.0
Parameters: Promotion Id
Returns: N/A
Throws : N/A 
********************************************************************/    
    public static String populateCannibalisationRate(String content, Set<String> productIdSet){
        try{
            content = UL_PromotionContentReplace.replaceFieldContent(content);
            Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
            List<String> productIdList = new List<String>();
            Map<String, Object> boPromotion = (Map<String, Object>) tacticDeserializedMap.get(UtilityEnum.BOPromotion.Name());
            List<Object> loTactic = (List<Object>) boPromotion.get(UtilityEnum.LOTactic.Name());
            for(Object tacticObj : loTactic){
                Map<String, Object> productFilter= (Map<String, Object>)((Map<String, Object>)tacticObj).get(UtilityEnum.productfilter.Name());
                List<Object> manualProducts = new List<Object>();
                if(productFilter.get(UtilityEnum.manualproducts.Name())!=null){
                    manualProducts = (List<Object>) productFilter.get(UtilityEnum.manualproducts.Name());
                }
                for(Object productObj : manualProducts){
                    productIdList.add((String)((Map<String, Object>)productObj).get(UtilityEnum.productid.Name()));
                }
            }
            System.debug('productIdSet::::::'+productIdSet);
            if(!productIdSet.isEmpty()){
                Map<Id, ACCL__Product__c> productMap = new Map<Id, ACCL__Product__c>([SELECT Id, ACCL__Product_Level__c, ACCL__Criterion_2_Product__c, ACCL__Criterion_2_Product__r.Name, ACCL__Criterion_3_Product__c, ACCL__Criterion_3_Product__r.Name, ACCL__Criterion_4_Product__c, ACCL__Criterion_4_Product__r.Name FROM ACCL__Product__c WHERE Id IN:productIdSet]);
                
                if(!productMap.isEmpty()){
                    Set<Id> marketLevelIds = new Set<Id>();
                    Set<String> brandLevelSet = new Set<String>();
                    Set<String> categorytLevelSet = new Set<String>();
                    String marketId;
                    String customerId = (String)boPromotion.get('UL_Account__c');
                    String feature = (String)boPromotion.get('UL_Feature__c');
                    String salesOrg = (String)boPromotion.get('ACCL__Sales_Org__c');
                    feature = feature==System.Label.UL_Shelf ? feature : System.Label.UL_Off_Shelf;
                    String tempMarketId;
                    String tempCustomerId;
                    String tempFeature;
                    Decimal cannibalisationRate;
                    boolean foundCannRate = false;
                    Id childProductId;
                    String market;
                    String category;
                    String brand;
                    for(ACCL__Product__c product : productMap.values()){
                        System.debug('product.ACCL__Criterion_2_Product__c:::'+product.ACCL__Criterion_2_Product__c);
                        if(product.ACCL__Criterion_3_Product__c != null){
                            marketLevelIds.add(product.ACCL__Criterion_3_Product__c);
                            marketId = String.valueOf(product.ACCL__Criterion_3_Product__c);
                            childProductId = product.Id;
                        }
                        System.debug('Market::::'+product.ACCL__Criterion_3_Product__c);
                        if(product.ACCL__Criterion_4_Product__c!=null){
                            brandLevelSet.add(product.ACCL__Criterion_4_Product__c);
                        }
                        System.debug('Brand::::'+product.ACCL__Criterion_4_Product__c);
                        if(product.ACCL__Criterion_2_Product__c!=null){
                            categorytLevelSet.add(product.ACCL__Criterion_2_Product__c);
                        }
                        System.debug('Category::::'+product.ACCL__Criterion_2_Product__c);
                    }
                    
                    //populating Market Field
                    if(marketLevelIds.size()==1){
                        market = productMap.get(childProductId).ACCL__Criterion_3_Product__r.Name;
                    }
                    else if(marketLevelIds.size()>1){
                        market = System.Label.UL_Multiple_Markets;
                    }
                    else{
                        market = System.Label.None;
                    }
                    
                    //populating Category Field
                    if(categorytLevelSet.size()==1){
                        category = productMap.get(childProductId).ACCL__Criterion_2_Product__r.Name;
                    }
                    else if(categorytLevelSet.size()>1){
                        category = System.Label.UL_Multiple_Categories;
                    }
                    else{
                        category = System.Label.None;
                    }
                    
                    //populating Brand Field
                    if(brandLevelSet.size()==1){
                        brand = productMap.get(childProductId).ACCL__Criterion_4_Product__r.Name;
                    }
                    else if(brandLevelSet.size()>1){
                        brand = System.Label.UL_Multiple_Brands;
                    }
                    else{
                        brand = System.Label.None;
                    }
                    
                    boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Market__c.getName(), market);
                    boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Category__c.getName(), category);
                    boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Brand__c.getName(), brand);
                    
                    if(salesOrg!=null && (salesOrg =='UK SO' || salesOrg == 'Ireland SO')){
                        String fromStringDate = (String)(UL_Utility.EMPTY_STRING+boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_From__c.getName()));
                        String thruStringDate = (String)(UL_Utility.EMPTY_STRING+boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_Thru__c.getName()));
                        Datetime fromDate = fromStringDate.contains(UL_Utility.HYPHEN) ? null : Datetime.newInstance((Long)boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_From__c.getName()));
                        Date instoreDateFrom = fromStringDate.contains(UL_Utility.HYPHEN) ? Date.valueOf(fromStringDate) : Date.newInstance(fromDate.year(), fromDate.month(), fromDate.day());
                        Datetime thruDate = thruStringDate.contains(UL_Utility.HYPHEN) ? null : Datetime.newInstance((Long)boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_Thru__c.getName()));
                        Date instoreDateThru = thruStringDate.contains(UL_Utility.HYPHEN) ? Date.valueOf(thruStringDate) : Date.newInstance(thruDate.year(), thruDate.month(), thruDate.day());
                        
                        Map<String, UL_Cannibalisation_Rate__c> cannibRateMap = new Map<String, UL_Cannibalisation_Rate__c>();
                        for(UL_Cannibalisation_Rate__c cannibRate : [SELECT Id, UL_Valid_From__c, UL_Valid_Thru__c, UL_Customer__c, UL_Product__c, UL_Feature__c, UL_Cannibalisation_Rate__c, UL_IsAllCustomers__c, UL_IsAllProducts__c FROM UL_Cannibalisation_Rate__c WHERE UL_Valid_From__c <= :instoreDateFrom AND UL_Valid_Thru__c >= :instoreDateFrom ]){
                            if(cannibRate.UL_IsAllCustomers__c){
                                cannibRate.UL_Customer__c = null;
                            }
                            if(cannibRate.UL_IsAllProducts__c){
                                cannibRate.UL_Product__c = null;
                            }
                            cannibRateMap.put(String.valueOf(cannibRate.UL_Customer__c) + String.valueOf(cannibRate.UL_Product__c) + cannibRate.UL_Feature__c, cannibRate);
                        }
                        
                        tempCustomerId = customerId;
                        tempMarketId = marketId;
                        tempFeature = feature;
                        //Single Market
                        if(marketLevelIds.size()==1){
                            
                            //#1
                            //For Customer/Market/Fearure combination
                            String key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key)){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                            if(!foundCannRate){
                                //#2
                                //For Customer/Market/NULL Fearure combination
                                tempFeature = System.Label.UL_Off_Shelf;
                                key = tempCustomerId + tempMarketId + tempFeature;
                                if(cannibRateMap.containsKey(key)){
                                    cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                    boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                    foundCannRate = true;
                                }
                            }
                        }
                        //Multiple Markets
                        if(!foundCannRate){
                            //#3
                            //For Customer/Null Market/Fearure combination
                            tempFeature = feature;
                            tempMarketId = null;
                            String key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key)){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                        }
                        if(!foundCannRate){
                            //#4
                            //For Customer/Null Market/ NULL Fearure combination
                            tempFeature = System.Label.UL_Off_Shelf;
                            tempMarketId = null;
                            String key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key)){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                        }
                        
                        //Single Market & Null Customer
                        if(marketLevelIds.size()==1 && !foundCannRate){
                            //#5
                            //Null Customer/Market/Feature
                            tempFeature = feature;
                            tempMarketId = marketId;
                            tempCustomerId = null;
                            String key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key)){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                            
                            //#6
                            //Null Customer/Market/Null Feature
                            tempFeature = System.Label.UL_Off_Shelf;
                            tempMarketId = marketId;
                            tempCustomerId = null;
                            key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key) && !foundCannRate){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                        }
                        
                        //Multiple Market & Null Customer
                        if(!foundCannRate){
                            
                            //#7
                            //Null Customer/Null Market/Feature
                            tempFeature = feature;
                            tempMarketId = null;
                            tempCustomerId = null;
                            String key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key)){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                        }
                        
                        if(!foundCannRate){
                            //#8
                            //For NULL Customer/Null Market/ NULL Fearure combination
                            tempFeature = System.Label.UL_Off_Shelf;
                            tempMarketId = null;
                            tempCustomerId = null;
                            String key = tempCustomerId + tempMarketId + tempFeature;
                            if(cannibRateMap.containsKey(key)){
                                cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                                boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Cannibalisation_Rate__c.getName(), cannibalisationRate);
                                foundCannRate = true;
                            }
                        }
                    }
                    
                }
            }
            content = JSON.serialize(tacticDeserializedMap);
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        return content;
    }
    
    @RemoteAction
    global static void writePromoAccRel(String txtId,String promoContent){
        // should include the child account list from UI with included and excluded
        
        List<ChildAccounts> childAccountList = new List<ChildAccounts>(); 
        List <Promotion_Acc_Rel__c> allPromoAccList = New List <Promotion_Acc_Rel__c>();//List of all the promotion_Acc existing
        Map <id,Promotion_Acc_Rel__c> allthePromoAccMap = New Map <id,Promotion_Acc_Rel__c> ();//Map<childAccountId,promotion_Acc>
        List<Promotion_Acc_Rel__c> promoAccrelToDelete = New List<Promotion_Acc_Rel__c>();//promotion_Acc of the child account that changed to exluded in the last save and refresh
        List<String> promoAccrelToAddChildId =New List<String>();//List of child account Id that we need to create promotion_Acc for
        List<Promotion_Acc_Rel__c> promoAccrelToAdd = New List<Promotion_Acc_Rel__c>();//List of new promotion_Acc to insert
        String promoCustomerType='';
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format
        List<Object> childAccountListFromJson= (List<Object>)boPromotion.get('LOExtChildAccounts');
        SYSTEM.DEBUG('childAccountListFromJson'+childAccountListFromJson);
        //check the customer type in promotion
        if(boPromotion.get('ACCL__Anchor_Account__c')!=null){
            promoCustomerType='Account';
        }
        else {
            promoCustomerType='CustomerSet';
        }
        
        allPromoAccList= getPromotionAccRel(promoContent);
        system.debug('allPromoAccList '+allPromoAccList);
        //allPromoAccList to map
        for(Promotion_Acc_Rel__c par :allPromoAccList){
            allthePromoAccMap.put(par.Child_Account__c,par);
        }
        system.debug('allthePromoAccMap '+allPromoAccList);
        
        //Loop on childAccountList(FROM UI)
        for(Object cha: childAccountListFromJson){
            Map<String,Object> cha1 = (Map<String,Object>)cha;
            if(cha1.get('Included')==true && (!allthePromoAccMap.containsKey(String.valueOf(cha1.get('ChildAccountID'))))){
                promoAccrelToAddChildId.add(String.valueOf(cha1.get('ChildAccountID')));
            }
            else
                if(cha1.get('Included')==FALSE && allthePromoAccMap.containsKey(String.valueOf(cha1.get('ChildAccountID'))))
                promoAccrelToDelete.add(allthePromoAccMap.get(String.valueOf(cha1.get('ChildAccountID'))));
        }
        
        for(id i:promoAccrelToAddChildId){
            Promotion_Acc_Rel__c par = new Promotion_Acc_Rel__c();
            par.Child_Account__c=i;
            par.Parent_Promotion__c= String.valueOf(boPromotion.get('Id'));
            par.TxStatus__c='TxInit';
            if(promoCustomerType=='CustomerSet')
                par.Parent_Account__c= String.valueOf(boPromotion.get('ACCL__Anchor_Account_Set__c'));
            else
                par.Parent_Account__c= String.valueOf(boPromotion.get('ACCL__Anchor_Account__c'));
            promoAccrelToAdd.add(par);
        }
        upsert promoAccrelToAdd;
        delete promoAccrelToDelete;
    } 
    
    
    global static List<Promotion_Acc_Rel__c> getPromotionAccRel(String promoContent){    
        String promoCustomerType='';
        List <Promotion_Acc_Rel__c> allPromoAccList = New List <Promotion_Acc_Rel__c>();//List of all the promotion_Acc existing        
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format        
        List<Object> LOExtChildAccounts = (List<Object>)boPromotion.get('LOExtChildAccounts');
        system.debug('LOExtChildAccounts'+LOExtChildAccounts);
        
        /*for(Object o:LOExtChildAccounts){
Map<String,Object> oMap = (Map<String,Object>)o;
childIdList.add(String.valueOf(oMap.get('ChildAccountID')));

}*/
        if(boPromotion.get('ACCL__Anchor_Account__c')!=null){
            promoCustomerType='Account';
        }
        else {
            promoCustomerType='CustomerSet';
        }
        //query the existing Promotion_Acc_Rel__c depended of the customer type
        if(promoCustomerType=='Account'){
            allPromoAccList=[Select id,Child_Account__c,TxStatus__c,Child_Promotion__c FROM Promotion_Acc_Rel__c
                             WHERE Parent_Account__c=:String.valueOf(boPromotion.get('ACCL__Anchor_Account__c'))  and Parent_Promotion__c=:String.valueOf(boPromotion.get('Id')) ];
            
        }else{
            allPromoAccList=[Select id,Child_Account__c,TxStatus__c,Child_Promotion__c FROM Promotion_Acc_Rel__c
                             WHERE Parent_Account__c=:String.valueOf(boPromotion.get('ACCL__Anchor_Account_Set__c')) and Parent_Promotion__c=:String.valueOf(boPromotion.get('Id'))];
        }
        
        
        system.debug(allPromoAccList);
        return allPromoAccList;
        
    }
    
    
    @RemoteAction
    global static List<ChildAccounts> readLOExtChildAccounts (String txtID ,String objectContent) {
        List<Promotion_Acc_Rel__c> allpromoAccRel = new List<Promotion_Acc_Rel__c>();
        ACCL__Promotion__c promo = new ACCL__Promotion__c();//should store the promotion from JSON
        String parentAccountId = ''; //should take it from JSON
        List<ACCL__Account_Trade_Org_Hierarchy__c> orgHierarchy= new List<ACCL__Account_Trade_Org_Hierarchy__c>();
        List<ACCL__Account_Set_Account__c> custHierarchy= new List<ACCL__Account_Set_Account__c>();
        List<ChildAccounts>  result = new List<ChildAccounts> ();
        Map<Id,Id> childAccountMap = new Map<Id,Id>();
        List<Promotion_Acc_Rel__c> includedAccounts = new List<Promotion_Acc_Rel__c>();
        Map<id, Promotion_Acc_Rel__c> includedAccountMap = new Map<id, Promotion_Acc_Rel__c>();
        List<Account> allchildAccount = new List<Account>();
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(objectContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format
        String promoID= String.valueOf(boPromotion.get('Id'));
        String promoSlogan= String.valueOf(boPromotion.get('ACCL__Slogan_Language_1__c'));
        
        if(boPromotion.get('ACCL__Anchor_Account__c') !=null){
            parentAccountId=String.valueOf(boPromotion.get('ACCL__Anchor_Account__c'));
            }
        else{
           parentAccountId=String.valueOf(boPromotion.get('ACCL__Anchor_Account_Set__c'));
        }
        DescribeSObjectResult describeResultp = ACCL__Promotion__c.getSObjectType().getDescribe();
        List<String> fieldNamesp = new List<String>( describeResultp.fields.getMap().keySet());
        String queryp =
            ' SELECT ' +
            String.join( fieldNamesp, ',' ) +
            ' FROM ' +
            describeResultp.getName() +
            ' WHERE ' +
            ' id = :promoID ' +
            ' LIMIT 1 ';
        
        promo = Database.query( queryp ); 
        system.debug('promo '+promo);
        
        
        //get the included childs account for this specific promotion and parent account (From last push)
        includedAccounts = [SELECT id, Child_Account__c,Child_Promotion__c FROM Promotion_Acc_Rel__c WHERE Parent_Promotion__c =: promoID AND Parent_Account__c =: parentAccountId];
        system.debug('includedAccounts '+includedAccounts);
        if(!includedAccounts.isEmpty()){
            for (Promotion_Acc_Rel__c p : includedAccounts)
            {
                includedAccountMap.put(p.Child_Account__c, p);
            }
        }
        system.debug('includedAccountMap '+includedAccountMap);
        //checking the type of customer to get the childs
        //if the customer is an account get the child list from ACCL__Account_Trade_Org_Hierarchy__c object
        if(promo.ACCL__Anchor_Account__c !=null){
            
            orgHierarchy = [SELECT id,ACCL__Child_Account__c,ACCL__Parent_Account__c
                            FROM ACCL__Account_Trade_Org_Hierarchy__c
                            WHERE ACCL__Parent_Account__c=:parentAccountId  AND
                            ACCL__Valid_From__c <=: promo.ACCL__Date_From__c  AND
                            ACCL__Valid_Thru__c >=: promo.ACCL__Date_Thru__c];
            
            for (ACCL__Account_Trade_Org_Hierarchy__c a : orgHierarchy)
            {
                childAccountMap.put(a.ACCL__Child_Account__c, a.ACCL__Child_Account__c);
            }
            
            allchildAccount=[SELECT id,Name,UL_Customer_Unique__c FROM Account WHERE id IN:childAccountMap.keyset() AND UL_Customer_Hierarchy_Level__c='Level 8'];    
            system.debug('allchildAccount '+allchildAccount);   
        }
        //if the customer is an customer set get the child list from ACSFUL001__Account_Set_Account__c 
        else{     
            custHierarchy=  [SELECT id,ACCL__Account__c FROM ACCL__Account_Set_Account__c WHERE ACCL__Account_Set__c=:parentAccountId];
            for (ACCL__Account_Set_Account__c a : custHierarchy)
            {
                childAccountMap.put(a.ACCL__Account__c, a.ACCL__Account__c);
            }
            
            allchildAccount=[SELECT id,Name,UL_Customer_Unique__c FROM Account WHERE id IN:childAccountMap.keyset() AND UL_Customer_Hierarchy_Level__c='Level 8'];    
            
            
            
        }
        
        /*  allpromoAccRel= getPromotionAccRel(objectContent);
Map<String,Promotion_Acc_Rel__c>allpromoAccRelMap = new Map<String,Promotion_Acc_Rel__c>();
for(Promotion_Acc_Rel__c acc:allpromoAccRel){
allpromoAccRelMap.put(acc.Child_Account__c,acc);
}*/
        
        //Loop to all the child to define included/excluded and fill the return map
        for (Account a : allchildAccount)
        {
            
            ChildAccounts child = new ChildAccounts();
            if (includedAccountMap.containsKey(a.id))
            {
                
                child.Included = true;
                child.ChildAccountID=a.id;
                child.ChildAccountName = a.Name;
                child.CustomerUnique=a.UL_Customer_Unique__c;
                if(includedAccountMap.get(a.id).Child_Promotion__c!=null){
                    child.PushedPromoID = includedAccountMap.get(a.id).Child_Promotion__c;
                    child.PromotionSlogan=promoSlogan;
                }
                
                
            }
            else{
                child.Included = false;
                child.ChildAccountID=a.id;
                child.ChildAccountName = a.Name;
                child.CustomerUnique=a.UL_Customer_Unique__c;
                child.PushedPromoID = null;
                
            }
            result.add(child);
        }
        system.debug('result'+result);
        return result;
    }
    //This function creates new child promotions(with tactics and funds) after the click on push button
    
    @RemoteAction
    global static ChildAccounts CreatePushBOPromotion(String txId,String promoContent){
        system.debug('promoContent'+promoContent);   
        
        List<Promotion_Acc_Rel__c> allPromoAccList= new List<Promotion_Acc_Rel__c>();
        List<Promotion_Acc_Rel__c> allPromoAccListfromUI= new List<Promotion_Acc_Rel__c>();
        ACCL__Promotion__c promotocopy = New ACCL__Promotion__c();//parent promotion
        List<ACCL__Promotion__c> promoListToinsert = New List<ACCL__Promotion__c>();//child promotions to insert
        ChildAccounts child = new ChildAccounts();
        
        Map<ACCL__Tactic__c,String> tactToInsert = new Map<ACCL__Tactic__c,string>();//List of new Tactics that should be insert with the new child promotions
        List<ACCL__Tactic__c> tactToCopy = new List<ACCL__Tactic__c>();//List of the parent promotion tactics that we need to copy
        List< ACCL__Tactic_Fund__c> tactFundsList= new List< ACCL__Tactic_Fund__c>(); //List of new Tactics Funds that should be insert with the new tactics
        List< ACCL__Tactic_Fund__c> tactFundsListToInsert= new List< ACCL__Tactic_Fund__c>(); //List of new Tactics Funds that should be insert with the new tactics
        
        Map<String ,List< ACCL__Tactic_Fund__c> > tactFundsMap = new Map<String ,List< ACCL__Tactic_Fund__c>>();//List of the parent promotion tactics funds that we need to copy
        List <id> tactToSelectList = new List <id>();     
        String promoCustomerType = '';
        
        allPromoAccListfromUI=getPromotionAccRel(promoContent);
        system.debug('allPromoAccList '+allPromoAccList);
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format
        List<Object> boPromotionTacticts = (List<Object>) boPromotion.get('LOTactic');
        String promoID= String.valueOf(boPromotion.get('Id'));
        List<Object> childAccountListFromJson= (List<Object>)boPromotion.get('LOExtChildAccounts');
        system.debug('childAccountListFromJson '+childAccountListFromJson);
        List<ACCL__Promotion_Template_Hierarchy__c> childpromotiontemplate = new List<ACCL__Promotion_Template_Hierarchy__c> ();
        try{
            childpromotiontemplate = [SELECT id, UL_Usage__c,ACCL__Parent_Promotion_Template__c,ACCL__Child_Promotion_Template__c
                                      FROM ACCL__Promotion_Template_Hierarchy__c 
                                      WHERE ACCL__Parent_Promotion_Template__c=: String.valueOf(boPromotion.get('ACCL__Promotion_Template__c')) AND UL_Usage__c='Push' LIMIT 1];
        }  catch(Exception e){}
        system.debug('childpromotiontemplate'+childpromotiontemplate);
        if(!childpromotiontemplate.isEmpty()){
            for(Promotion_Acc_Rel__c acc:allPromoAccListfromUI){
                Map<String, Object> childAcc = (Map<String, Object>) childAccountListFromJson[0];
                if(acc.Child_Account__c == String.valueOf(childAcc.get('ChildAccountID'))){
                    allPromoAccList.add(acc);
                }
            }
            
            
            DescribeSObjectResult describeResultp = ACCL__Promotion__c.getSObjectType().getDescribe();
            
            List<String> fieldNamesp = new List<String>( describeResultp.fields.getMap().keySet());
            
            String queryp =
                ' SELECT ' +
                String.join( fieldNamesp, ',' ) +
                ' FROM ' +
                describeResultp.getName() +
                ' WHERE ' +
                ' id = :promoID ' +
                ' LIMIT 1 ';
            
            promotocopy = Database.query( queryp ); 
            system.debug('promotocopy '+promotocopy);  
            
            For(Object o : boPromotionTacticts){
                Map<String, Object> tactic = (Map<String, Object>) o;
                tactToSelectList.add(String.valueOf(tactic.get('Id')));
            }  
                
            DescribeSObjectResult describeResult = ACCL__Tactic__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet());
            
            String query =
                ' SELECT ' +
                String.join( fieldNames, ',' ) +
                ' FROM ' +
                describeResult.getName() +
                ' WHERE ' +
                ' id IN:tactToSelectList ';
            
            tactToCopy = Database.query( query ); 
            system.debug('tactToCopy '+tactToCopy);
            DescribeSObjectResult describeResultf = ACCL__Tactic_Fund__c.getSObjectType().getDescribe();
            List<String> fieldNamesf = new List<String>( describeResultf.fields.getMap().keySet());
            
            String queryf =
                ' SELECT ' +
                String.join( fieldNamesf, ',' ) +
                ' FROM ' +
                describeResultf.getName() +
                ' WHERE ' +
                ' ACCL__Tactic__c IN:tactToSelectList ';
            
            tactFundsList = Database.query( queryf ); 
            system.debug('tactFundsList '+tactFundsList);
            for(ACCL__Tactic_Fund__c tactFund : tactFundsList){
                
                if(!tactFundsMap.containsKey(tactFund.ACCL__Tactic__c)){
                    List< ACCL__Tactic_Fund__c> listFund = new List< ACCL__Tactic_Fund__c>{tactFund};
                        tactFundsMap.put(tactFund.ACCL__Tactic__c,listFund);
                }
                else{
                    List< ACCL__Tactic_Fund__c> listFund =tactFundsMap.get(tactFund.ACCL__Tactic__c);
                    listFund.add(tactFund);
                    tactFundsMap.put(tactFund.ACCL__Tactic__c,listFund);
                }
                
            }
            
            //check the customer type in promotion
            if(promotocopy.ACCL__Anchor_Account__c!=null){
                promoCustomerType='Account';
            }
            else {
                promoCustomerType='CustomerSet';
            }
            
            
            //Loop on childAccountList(FROM UI) clone promotion if the child account is included and add the promotion_acc to delete list if it's exluded
            try{
                // for(Promotion_Acc_Rel__c cha: allPromoAccList){
                system.debug('allPromoAccList[0]'+allPromoAccList[0].id);
                ACCL__Promotion__c clonepromo = promotocopy.clone();
                if(promotocopy.ACCL__Aggregation_Category__c==null){
                    promotocopy.ACCL__Aggregation_Category__c=promotocopy.id;
                    clonepromo.ACCL__Aggregation_Category__c=promotocopy.id;
                    update promotocopy;
                }
                system.debug('clonepromo '+clonepromo);
                clonepromo.UL_Parent_Push_Id__c=promotocopy.id;
                if(promoCustomerType=='CustomerSet')
                    clonepromo.ACCL__Anchor_Account_Set__c=null;
                
                clonepromo.ACCL__Anchor_Account__c=allPromoAccList[0].Child_Account__c;
                clonepromo.UL_EnableChild__c=false;
                clonepromo.ACCL__Phase__c='Planning';
                clonepromo.ACCL__Promotion_Template__c =childpromotiontemplate[0].ACCL__Child_Promotion_Template__c; 
                allPromoAccList[0].TxStatus__c='TxInProgress';
                system.debug('clonepromo '+clonepromo);
                //}
                insert clonepromo;
                allPromoAccList[0].Child_Promotion__c=clonepromo.id;
                update allPromoAccList[0];
                system.debug('update');
                //Loop on the new promotions List after insert to copy the tactics from parent and relate them to the new promotions
                //  for(ACCL__Promotion__c p : promoListToinsert){
                if(!tactToCopy.isEmpty()){
                    for(ACCL__Tactic__c t :tactToCopy){
                        ACCL__Tactic__c newt = t.clone();
                        newT.ACCL__Promotion__c= clonepromo.id;
                        tactToInsert.put(newt,t.id);
                        system.debug('tactToInsert'+tactToInsert); 
                        insert newT;
                        List<ACCL__Tactic_Fund__c> tactFuntocopy = new List<ACCL__Tactic_Fund__c>();
                          if(tactFundsMap.containsKey(t.id)){
                                tactFuntocopy=tactFundsMap.get(t.id);
                                for(ACCL__Tactic_Fund__c tf : tactFuntocopy){
                                    ACCL__Tactic_Fund__c tfclone = tf.clone();
                                    tfclone.ACCL__Tactic__c=newT.id;
                                    tactFundsListToInsert.add(tfclone);
                                    system.debug('tactFundsListToInsert'+tactFundsListToInsert);   
                                }
                            }
                        
                    }}
                // }
                List<ACCL__Tactic__c> tactToInsertlist = new List<ACCL__Tactic__c> (tactToInsert.keySet());
               /* if(!tactToInsertlist.isEmpty()){
                   // insert tactToInsertlist;
                 system.debug('tactToInsert'+tactToInsert); 
                    system.debug('tactFundsMap'+tactFundsMap);
                    if(!tactToInsertlist.isEmpty()){
                        for(ACCL__Tactic__c t : tactToInsertlist){
                            List<ACCL__Tactic_Fund__c> tactFuntocopy = new List<ACCL__Tactic_Fund__c>();
                            String oldTac = tactToInsert.get(t);
                            system.debug('oldTac'+oldTac);
                            if(tactFundsMap.containsKey(oldTac)){
                                tactFuntocopy=tactFundsMap.get(oldTac);
                                for(ACCL__Tactic_Fund__c tf : tactFuntocopy){
                                    ACCL__Tactic_Fund__c tfclone = tf.clone();
                                    tfclone.ACCL__Tactic__c=t.id;
                                    tactFundsListToInsert.add(tfclone);
                                    system.debug('tactFundsListToInsert'+tactFundsListToInsert);   
                                }
                            }
                        }
                    }
                }*/
                if(!tactFundsListToInsert.isEmpty()){ 
                    insert tactFundsListToInsert;
                    system.debug('tactFundsListInserted------'+JSON.SERIALIZE(tactFundsListToInsert)); 
                }
                
                Map<String,Object> jsonChildMap = (Map<String,Object>)childAccountListFromJson[0];
                child.ChildAccountID=String.valueOf(jsonChildMap.get('ChildAccountID'));
                child.ChildAccountName=String.valueOf(jsonChildMap.get('ChildAccountName'));
                child.Included=Boolean.valueOf(jsonChildMap.get('Included'));
                child.PushedPromoID=clonepromo.id;
                system.debug('child'+child);
            }
            catch(Exception e){
                Map<String,Object> jsonChildMap = (Map<String,Object>)childAccountListFromJson[0];
                child.ChildAccountID=String.valueOf(jsonChildMap.get('ChildAccountID'));
                child.ChildAccountName=String.valueOf(jsonChildMap.get('ChildAccountName'));
                child.Included=Boolean.valueOf(jsonChildMap.get('Included'));
                child.PushedPromoID=null;
                system.debug('e'+e);  
            }
        }
        else{
            Throw new updateException('There is no Child Promotion Templates with Push Usage');
        }
        
        return child;
        
    }
    
    @RemoteAction 
    global static void cleanUpPushBOPromotion(String txId,String promoContent){
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format        
        List<Promotion_Acc_Rel__c> allthePromoAccList= new List<Promotion_Acc_Rel__c>();
        //delete all the last pushed promotions (should delete the tactics and funds too)
        delete [select id FROM ACCL__Promotion__c WHERE UL_Parent_Push_Id__c=: String.valueOf(boPromotion.get('Id'))];
        allthePromoAccList= getPromotionAccRel(promoContent); 
        system.debug('allthePromoAccList'+allthePromoAccList);
        for(Promotion_Acc_Rel__c cha : allthePromoAccList){
            cha.TxStatus__c='TxInit';
            cha.Child_Promotion__c=null;
        }
        update allthePromoAccList;
        
    }
    
    @RemoteAction 
    global static void finalizePushBOPromotion(String txId,String promoContent){
        List<Promotion_Acc_Rel__c> allPromoAcc= new List<Promotion_Acc_Rel__c>();
        allPromoAcc=getPromotionAccRel(promoContent);
        system.debug('allPromoAccList'+allPromoAcc);
        for(Promotion_Acc_Rel__c cha : allPromoAcc){
            if(cha.Child_Promotion__c!=null)
                cha.TxStatus__c='TxCompleted';
        }
        update allPromoAcc;
        
    } 
    //This function is updating the enableChild field to get all the fields editable when the user click on enable child button
    @RemoteAction 
    global static void UpdateEnablePushBOPromotion(String txId,String promoParams){
    try{
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format        
        Long DateFromString =Long.valueOf(String.valueof(boPromotion.get('ACCL__Date_From__c')));
        Long DateThrutring =Long.valueOf(String.valueof(boPromotion.get('ACCL__Date_Thru__c')));
        DateTime DateFrom = DateTime.newInstance(DateFromString);
        DateTime DateThru = DateTime.newInstance(DateThrutring);
        List<Promotion_Acc_Rel__c> allPromoAccList=new List<Promotion_Acc_Rel__c>();
        allPromoAccList= getPromotionAccRel(promoParams);
        ACCL__Promotion_Template__c promotemp = new ACCL__Promotion_Template__c();
        promotemp = [SELECT id,UL_Allow_past_Promotions__c FROM ACCL__Promotion_Template__c WHERE id=: String.valueOf(boPromotion.get('ACCL__Promotion_Template__c')) LIMIT 1];
        
        Integer i=0;
        Boolean allIsCompleted=true;
        While(i<allPromoAccList.size() && allIsCompleted==true){
            if(allPromoAccList[i].TxStatus__c != 'TxCompleted')
                allIsCompleted=false;
            i++;
        }
        if(allIsCompleted==false){
            Throw new updateException('One of the Promotion Acc Rel Status is not completed');
        }
        if(DateThru > system.today() || (DateThru < system.today() && promotemp.UL_Allow_past_Promotions__c== true)){
            List <ACCL__Promotion__c> childPromotions = new List <ACCL__Promotion__c>();
            ACCL__Promotion__c promo = new ACCL__Promotion__c();
            for(ACCL__Promotion__c p : [SELECT id,UL_Parent_Push_Id__c,UL_EnableChild__c FROM ACCL__Promotion__c where UL_Parent_Push_Id__c=: String.valueOf(boPromotion.get('Id'))]){
                p.UL_EnableChild__c=true;
                p.ACCL__Phase__c = UL_Utility.status_approved;
                p.UL_Current_status__c = UL_Utility.status_approved;
                childPromotions.add(p);
            }
            update childPromotions;
        }
        else{
            Throw new updateException('The promotion is passed');
        }
        }
        catch(exception ex){
         throw ex;
        }
        
    }
    @RemoteAction
    global static void validateLOExtTacticTiers(String txId, String promoParams){
        // Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);//deserializing the JSON from UI        
        //   Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format 
        // List<Object> tacticList = (List<Object>) boPromotion.get('LOTactic');//Get the promotion in Map format 
         List<Object> tacticTiersListFromJson = new List<Object>();
        system.debug('promoParams'+promoParams);
        if(promoParams.contains('tier')){
            Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);
            tacticTiersListFromJson=(List<Object>) promoContentDeserializedMap.get('tier');
        }else
            tacticTiersListFromJson = (List<Object>) JSON.deserializeUntyped(promoParams);
        
        List <TacticTier> tacticTiersList = new List <TacticTier>();
        for(Object obj : tacticTiersListFromJson){
            Map<String, Object> tempMap = (Map<String, Object>) obj;
            TacticTier tt = new TacticTier();
            
            tt.fromValue=Decimal.valueOf(String.valueOf(tempMap.get('fromValue'))) ;
            if(tempMap.containsKey('toValue'))
                tt.toValue=Decimal.valueOf(String.valueOf(tempMap.get('toValue'))) ;
            tt.amount=Decimal.valueOf(String.valueOf(tempMap.get('amount'))) ;
            
            tacticTiersList.add(tt);
        }
        Integer j=tacticTiersList.size();
        for(Integer i=0;i<j;i++){
            if(!(tacticTiersList[i].fromValue < tacticTiersList[i].toValue)){
                Throw new updateException(System.Label.VOLUME_MIN_IN+' '+System.Label.LINE+' '+i+' '+System.Label.HIGHER_THAN+' '+System.Label.VOLUME_MAX);
            }
            if(i!=((j-1))){
                if(tacticTiersList[i+1].fromValue-tacticTiersList[i].toValue!= 0)
                    if(tacticTiersList[i+1].fromValue-tacticTiersList[i].toValue<0)
                    Throw new updateException(System.Label.MSG_GAP_TIERS_OVERLAP_LINE+' '+System.Label.LINE+' '+(i+1)+' '+System.Label.AND+' '+System.Label.LINE+' '+(i+2));
                    
                    else
                    Throw new updateException(System.Label.MSG_GAP_TIERS_BETWEEN_LINE+' '+System.Label.LINE+' '+(i+1)+' '+System.Label.AND+' '+System.Label.LINE+' '+(i+2));
            }
        }
        
        
    }
    
    
    @RemoteAction
    global static List<LOExTacticTier> readLOExtTacticTiers(String txId,String readParams){
    
    system.debug('bansi..test'+readParams);
        List<LOExTacticTier> result = new List<LOExTacticTier>();
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(readParams);//deserializing the JSON from UI        
      /*  Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format
        
        if (boPromotion != null) {
            String promoID= String.valueOf(boPromotion.get('Id'));*/
            if (promoContentDeserializedMap != null) {
            String promoID = String.valueOf(promoContentDeserializedMap.get('parentId'));
            
            if (promoID!=null) {
                List <ACCL__Tactic__c> tacticList = new List<ACCL__Tactic__c>();
                tacticList=[SELECT id,UL_Tier_Definition__c FROM ACCL__Tactic__c WHERE ACCL__Promotion__c =: promoID];
                for(ACCL__Tactic__c tact : tacticList){
                    LOExTacticTier temp = new LOExTacticTier();
                    temp.tacticId=tact.id;
                    if (tact.UL_Tier_Definition__c != null) {
                        temp.JSONTier = tact.UL_Tier_Definition__c;
                    } else {
                        temp.JSONTier = '[]';
                    }
                    system.debug(temp);
                    result.add(temp);
                }
            }
        }
        system.debug(result);
        return result;
    }
    
    
    global class LOExTacticTier{
        String tacticId;
        String JSONTier;
    }
    
    
    
    
    global class TacticTier{
        Decimal fromValue;
        Decimal toValue;
        Decimal amount;
    }
    

    

    
    private static Boolean hasTacticAssignedFund(Id promotionId){
        Boolean result = UL_Utility.BOOLEAN_TRUE;
        
        if(promotionId != null){        
            //Get promotion sales org
            List<ACCL__Promotion__c> promotionList = [SELECT ACCL__Sales_Org__c, (SELECT id FROM ACCL__Tactics__r) FROM ACCL__Promotion__c WHERE id=:promotionId AND ACCL__Promotion_Template__r.UL_Is_Tactic_Fund_Required__c = true];
            
            if(!promotionList.isEmpty()){
                ACCL__Promotion__c promotion = promotionList[0];
                
                //Get parent sales org. E.g for AR01, parent sales org is SoCo
                String parentSalesOrg = UL_Utility.getParentSalesOrg(promotion.ACCL__Sales_Org__c);
                
                //Validate only for SoCo org
                if(promotion != null && String.isNotEmpty(promotion.ACCL__Sales_Org__c) && UL_Utility.SalesOrg.SoCo.Name().equalsIgnoreCase(parentSalesOrg)){    
                    Set<id> tacticIdSet = null;
                    if(promotion.ACCL__Tactics__r != null){
                        tacticIdSet = new Set<id>();
                        for(ACCL__Tactic__c tactic: promotion.ACCL__Tactics__r){
                            tacticIdSet.add(tactic.id);
                        }
                    }
                    else{
                        result = UL_Utility.BOOLEAN_FALSE;
                    }
                    
                    if(tacticIdSet != null && tacticIdSet.size() > 0){
                        for(ACCL__Tactic_Fund__c tacticFund : [SELECT ACCL__Tactic__c FROM ACCL__Tactic_Fund__c WHERE ACCL__Tactic__c IN :tacticIdSet]){
                            tacticIdSet.remove(tacticFund.ACCL__Tactic__c);
                        }
                    
                        if(tacticIdSet.size() == 0){
                            result = UL_Utility.BOOLEAN_FALSE;
                        }
                    }
                }
            }
        }
        return result;    
    }
    
   
   @RemoteAction
   global static List<Map<String,Object>> readLOFilteredFunds(String txId, String promotionContent) {
        List<Map<String,Object>> result =  ACCL.PromotionRemoteActionExtension.readLOFilteredFunds('txId',promotionContent);
        
        if(userInfo.getUserName().equalsIgnoreCase('ketan.vinodrai.mehta@accenture.com.actpmdev')){
            system.debug('>>>>>>>>>>inside method');
            //Add addtional fund with Customer at level 1 and product category
            Map<String, Object> promotionMap = (Map<String, Object>) JSON.deserializeUntyped(promotionContent);
            Map<String, Object> boPromotion  = (Map<String, Object>) promotionMap.get('BOPromotion');
            String promotionId = (String)boPromotion.get('Id');
            ACCL__Promotion__c promotion = [SELECT ID, ACCL__Commit_Date__c, ACCL__Anchor_Account__c, ACCL__Sales_Org__c from ACCL__Promotion__c WHERE Id =:promotionId];  //= initPromotion(txId,promotionId);
            
            //Check if the promotion is created for SoCo org
            if(UL_Utility.SalesOrg.SoCo.Name().equalsIgnoreCase(UL_Utility.getParentSalesOrg(promotion.ACCL__Sales_Org__c))){
               Date promotionCommitDate = promotion.ACCL__Commit_Date__c;
               
               List<Object> tacticList = (List<Object>)boPromotion.get('LOTactic');
               if(tacticList.size() > 0 ){
                   for(Object obj : tacticList){
                       Map<String, object> mObj = (Map<String, object>)obj;
                       system.debug('ketan>>>>>>>>>>>>>>' + mObj); 
                   }
               }
               
               Schema.SObjectType objectType = promotion.Id.getSObjectType();
               List<String> fieldList = new List<String>{}; 
               fieldList.addAll(objectType.getDescribe().fields.getMap().keySet());
               String query = 'SELECT ' + String.join(fieldList, UL_Utility.FIELD_SPLITTER) + ',Anchor_Account__r.name,Anchor_Product__r.name FROM ACCL__Fund__c WHERE (Valid_Thru__c >= :promotionCommitDate AND Valid_From__c <= :promotionCommitDate) AND ACC__Anchor_Account__r.UL_Customer_Hierarchy_Level__c  = :UL_Utility.LEVEL1  Order by Description__c ';
               List<ACCL__Fund__c> fundsList = Database.query(query);
               system.debug('>>>>>' + fundsList);
               //#Ketan
               //populateFunds(txId, Database.query(query));
            
            }
        }
        return result;
    }
   
    @RemoteAction
    global static List<Map<String,Object>> readLOFund(String txt,String param){

        List<Map<String,Object>> result =ACCL.PromotionRemoteActionExtension.readLOFund('txId',param);
        Map<String,ACCL__Tactic_Fund__c> tactFundList = readLoTacticFund(param);
        if(!tactFundList.isEmpty()){
        system.debug('tactFundList----'+tactFundList);
        For(Map<String,Object> fu :result){
            String fundId = String.valueof(fu.get('Id'));
            List<Object> tactList =(List<Object>) fu.get('Tactics');
                for(Object o :tactList){
                    Map<String,Object> temp = (Map<String,Object>) o;
                    String tacticId = String.valueOf(temp.get('tacticId'));
                    ACCL__Tactic_Fund__c temptactFunf = tactFundList.get(''+fundId+tacticId);
                    temp.put('UL_Allocation__c',String.valueOf(temptactFunf.UL_Allocation__c)); //String.valueOf(temptactFunf.UL_Allocation__c)
                    temp.put('UL_Amount_Allocated__c',String.valueOf(temptactFunf.UL_Amount_Allocated__c)); //String.valueOf(temptactFunf.UL_Amount_Allocated__c)
                    system.debug(temp);
                }
            
           
                system.debug(fu);
            }
        }
        
        system.debug(JSON.SERIALIZE(result));
        return result;
    }
    
    global static List<ACCL__Tactic_Fund__c> readLoTacticFund(String txId, String promoParams){
        
        List<ACCL__Tactic_Fund__c> result = new List<ACCL__Tactic_Fund__c>();
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format  
        String promoid = String.valueOf(boPromotion.get('Id'));
        result =[SELECT id,ACCL__Fund__c,UL_Allocation__c,UL_Amount_Allocated__c,ACCL__Fund__r.ACCL__Description__c FROM ACCL__Tactic_Fund__c WHERE ACCL__Tactic__r.ACCL__Promotion__c =: promoid ];
        return result;    
    }
    
        private static Map<String,ACCL__Tactic_Fund__c> readLoTacticFund(String promoParams){
        Map<String,ACCL__Tactic_Fund__c> result2= new Map<String,ACCL__Tactic_Fund__c>();
        List<ACCL__Tactic_Fund__c> result = new List<ACCL__Tactic_Fund__c>();
         Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);//deserializing the JSON from UI        
         Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format  
            String promoid = String.valueOf(boPromotion.get('Id'));
            List<Object> tactList = (List<Object>) boPromotion.get('LOTactic');
            List<String> tactlistId = new List<String>();
            if(!tactList.isEmpty()){
            For(Object o:tactList){
                Map<String,Object> temp = (Map<String,Object>)o;
                tactlistId.add(String.valueOf(temp.get('Id')));
            }
            system.debug('tactlistId'+tactlistId);
            result =[SELECT id,ACCL__Fund__c,UL_Allocation__c,UL_Amount_Allocated__c,ACCL__Tactic__c FROM ACCL__Tactic_Fund__c WHERE ACCL__Tactic__c IN:  tactlistId ];
            system.debug('result'+result);
            if(!result.isEmpty()){
            for(ACCL__Tactic_Fund__c acc: result){
                result2.put(''+acc.ACCL__Fund__c+acc.ACCL__Tactic__c,acc);
            }
            }
            }
        return result2;    
    }
    
     @RemoteAction
    global static string validateLOFund(String txId, String tacticFundParams){
        tacticFundParams=UL_PromotionContentReplace.replaceFieldContent(tacticFundParams);
        List<Object> tacticFundList = (List<Object>) JSON.deserializeUntyped(tacticFundParams); //should change when the UI will sent the JSON example
        Double sum=0;
        system.debug(''+tacticFundList);
        if(!tacticFundList.isEmpty()){
        for(Object o:tacticFundList){
            Map<String,Object> temp = (Map<String,Object>)o;
            system.debug('o'+o);
            if(double.valueOf(temp.get('UL_Allocation__c'))!=0.0){
            sum=sum+(double.valueOf(temp.get('UL_Allocation__c')));
            if(sum > 100){
                 Throw new updateException('The allocation % is up then 100');

            }
            else
                if(temp.get('UL_Allocation__c')==0.0)
                Throw new updateException('The fund' + String.valueOf(temp.get('ACCL__Fund__c')) + ' is selected and the allocation is 0%');
            }
        }
           /* if(sum != 100){
                 Throw new updateException('The allocation % is different then 100');

            }*/
        }
        return tacticFundParams;
    }
      
    
        //VERISON OF 23.1
     public static void writeLOTacticFund(String promoParams){
         promoParams=UL_PromotionContentReplace.replaceFieldContent(promoParams);
         Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);//deserializing the JSON from UI        
         Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format 
        List<Object> fundList = (List<Object>) boPromotion.get('LOFund');//Get the Fund in Map format 
        String promoid = String.valueOf(boPromotion.get('Id'));
        List<ACCL__Tactic_Fund__c>tacFundresult =[SELECT id,ACCL__Fund__c,UL_Allocation__c,UL_Amount_Allocated__c,ACCL__Tactic__c FROM ACCL__Tactic_Fund__c WHERE ACCL__Tactic__r.ACCL__Promotion__c =:  promoid ];
        Map<String,Map<String,ACCL__Tactic_Fund__c>> tactFundfromJSON = new Map<String,Map<String,ACCL__Tactic_Fund__c>>();
        Map<String,ACCL__Tactic_Fund__c> tacfunmap = new Map<String,ACCL__Tactic_Fund__c>();
        Map<String,Map<String,ACCL__Tactic_Fund__c>> tacfunmap2 = new Map<String,Map<String,ACCL__Tactic_Fund__c>>();
                List<ACCL__Tactic_Fund__c> tacFundToaddOrUpdate = new List<ACCL__Tactic_Fund__c>();
        
        List<ACCL__Tactic_Fund__c> tacFundTodelete = new List<ACCL__Tactic_Fund__c>();
        For(ACCL__Tactic_Fund__c acc:tacFundresult ){
            Map<String,ACCL__Tactic_Fund__c> temp =New Map<String,ACCL__Tactic_Fund__c>();
            if(tacfunmap2.containsKey(acc.ACCL__Fund__c)){
                temp=tacfunmap2.get(acc.ACCL__Fund__c);
                temp.put(acc.ACCL__Tactic__c,acc);
                }
            else
                temp.put(acc.ACCL__Tactic__c,acc);
            tacfunmap2.put(acc.ACCL__Fund__c,temp);
        }
        
        Map<String,Object> tactfundMap = new Map<String,Object>();
        For(Object o : fundList){
            Map<String, Object> temp = (Map<String, Object>) o;
            String fundId = String.valueOf(temp.get('Id'));
            //Tactics is received like 'tactics'
            //List<Object> taclist= (List<Object>) temp.get('Tactics');
            List<Object> taclist= (List<Object>) temp.get('tactics');
            system.debug('temp tactics '+temp.get('tactics'));
            for(Object tacto:taclist){
                Map<String, Object> temp2 = (Map<String, Object>) tacto;
                String tactId = String.valueOf(temp2.get('tacticId'));                
                if(tacfunmap2.containsKey(fundId)){
                    if(tacfunmap2.get(fundId).containsKey(tactId)){
                        ACCL__Tactic_Fund__c newtac = new ACCL__Tactic_Fund__c();
                        newtac=tacfunmap2.get(fundId).get(tactId);
                        
                        newtac.UL_Allocation__c=Decimal.valueOf(String.valueOf(temp2.get('UL_Allocation__c')));
                        String allocated=String.valueOf(temp2.get('UL_Amount_Allocated__c'));
                        String amountAllocated='';
                        if(allocated.contains(','))
                            amountAllocated=allocated.remove(',');
                        else
                            amountAllocated=allocated;
                        newtac.UL_Amount_Allocated__c=Decimal.valueOf(amountAllocated);
                        //newtac.UL_Amount_Allocated__c=150;
                        //newtac.UL_Allocation__c=40;
                        tacFundToaddOrUpdate.add(newtac);
                        tacfunmap.put(newtac.id,newtac);
                    }
                }
                else{
                    ACCL__Tactic_Fund__c newtac = new ACCL__Tactic_Fund__c();
                    newtac.UL_Allocation__c=Decimal.valueOf(String.valueOf(temp2.get('UL_Allocation__c')));
                        String allocated=String.valueOf(temp2.get('UL_Amount_Allocated__c'));
                        String amountAllocated='';
                        if(allocated.contains(','))
                            amountAllocated=allocated.remove(',');
                        else
                            amountAllocated=allocated;
                        newtac.UL_Amount_Allocated__c=Decimal.valueOf(amountAllocated);
                    //newtac.UL_Amount_Allocated__c=120;
                    //newtac.UL_Allocation__c=80;
                    newtac.ACCL__Tactic__c=tactId;
                    newtac.ACCL__Fund__c=fundId;
                    tacFundToaddOrUpdate.add(newtac);                  
               }
            
            }
            
        }

        
        For(ACCL__Tactic_Fund__c tacfund : tacFundresult){
            if(!tacfunmap.containsKey(tacfund.id)){
                tacFundTodelete.add(tacfund);
            }

        }
        
        system.debug(tacFundToaddOrUpdate);
        upsert tacFundToaddOrUpdate;
        delete tacFundTodelete;
    
}
        

 /***************************************************************    
Name: AuditData
Copyright © 2016 Accenture
======================================================
Purpose:
Wrapper class to send Audit content to SmartUI
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Abhishek      18/01/2017     INITIAL DEV            
***************************************************************/
    global class LOPromotionHistory{
        public String Name;
        public String NewValue;
        public String OldValue;
        public String CreatedDate ;
    }
    
    /*******************************************************************
Purpose:   
Version 1.0
Parameters: Transaction Id, Promotion Id
Returns: List of Audit Data custom object
Throws : N/A 
********************************************************************/
    @RemoteAction
    global static List<LOPromotionHistory> readLOPromotionHistory(String txtID ,String prmId) {
        system.debug('readLOPromotionHistory ::: ');
        List<LOPromotionHistory> auditDataList = new List<LOPromotionHistory>();
        system.debug('txtID ::: '+txtID);
        system.debug('prmId ::: '+prmId);
        String promoId= String.valueOf(prmId);
        
        try{
            for(ACCL__Promotion__History promHis: [SELECT CreatedBy.name,CreatedDate,NewValue,OldValue FROM ACCL__Promotion__History  where parentid = :promoId]){
                if(promHis.NewValue != Null && promHis.OldValue != Null){
                    LOPromotionHistory auditContent = new LOPromotionHistory();
                    auditContent.NewValue = (string)promHis.NewValue;
                    auditContent.OldValue = (string)promHis.OldValue;
                    auditContent.Name= promHis.CreatedBy.name;
                    auditContent.CreatedDate = String.Valueof(promHis.CreatedDate);
                    auditDataList.add(auditContent); 
                }
            }
          system.debug('Test01..bansi'+auditDataList);
        }catch(Exception ex){
            system.debug('Ex ::: '+ex);
        UL_Utility.logError(ex, UserInfo.getUserId());
        }
        system.debug('testt..'+auditDataList);
        // return JSON.serialize(auditDataList);
        return auditDataList;
    }



  /* @RemoteAction
    global static List<AuditData> invokeAuditTrailBOPromotion(String txId, String objectId){
        List<AuditData> auditDataList = new List<AuditData>();
            try{
            
            //Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
            //Id promoId = (Id)unTypedMap.get(UtilityEnum.Id.Name()); 
              Id promoId = objectId;
                system.debug('promoId ::: '+promoId);
                for(ACCL__Promotion__History promHis: [SELECT CreatedBy.name,CreatedDate,NewValue,OldValue FROM ACCL__Promotion__History  where parentid = :promoId]){
                    if(promHis.NewValue != Null && promHis.OldValue != Null){
                        AuditData auditContent = new AuditData();
                        auditContent.newValue = (string)promHis.NewValue;
                        auditContent.oldValue = (string)promHis.OldValue;
                        auditContent.userName = promHis.CreatedBy.name;
                        auditContent.dt = String.Valueof(promHis.CreatedDate);
                        auditDataList.add(auditContent); 
                    }
                }
              
            }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
            }
            system.debug('auditDataList ::: '+auditDataList);
             return  auditDataList;
       } */
    /** readLOExtProducts method reads Ext product
     *  @name   :  readLOExtProducts
     *  @param  :  PromotionId  PromotionId
     *  @return :  String
     *  @throws :
     *  @author :  sumit.chaturvedi@accenture.com
     */
    @RemoteAction
    global static List<Map<String, Object> > readLOExtProduct(String txId,  String promotionContent) {
      promotionContent = UL_PromotionContentReplace.replaceFieldContent(promotionContent);
      return ACCL.PromotionRemoteActionExtension.readLOExtProduct(txId,promotionContent);
    }
     /**Custom readLOFilteredProducts function to read the Filtered Products
     *  @name : readLOFilteredProducts
     *  @param : txId GUI id for each transcation we do from UI
     *  @param : promotionContent    JSON containing the current promotion info
     *  @return : List<String>       List of string
     *  @throws :
     *  @author :sudharsan.shanmugam@accenture.com
     
     *  @author: Ketan Mehta
     *  @desc: Filter products based on level and show only SKU products 
     */
    @RemoteAction
    global static List<ACCL__Product__c> readLOFilteredProducts(String txId,String promotionContent) {
        
        List<ACCL__Product__c> result = null;
        promotionContent = UL_PromotionContentReplace.replaceFieldContent(promotionContent);
        result = ACCL.PromotionRemoteActionExtension.readLOFilteredProducts(txId,promotionContent);                
        
        //Display only least level products.
        if(!result.isEmpty()){
            List<ACCL__Product__c> internalProductList = new List<ACCL__Product__c>();
            for(ACCL__Product__c product : result){
                if(UL_Utility.ProductLevel.Product.name().equalsIgnoreCase(product.ACCL__Product_Level__c)){
                    internalProductList.add(product);
                }
            }
            result.clear();
            result.addAll(internalProductList);            
         }
        
        return result;
    }
    
    
    private class updateException extends Exception{}
    
    /*******************************************************************
    Purpose: Populate fund object field values into a Map structure   
    Version 1.0
    Parameters: Transaction Id, Promotion Id
    Returns: List of Map with field and value
    Throws : N/A 
    ********************************************************************/
    private static List<Map<String, Object>> populateFunds(String txId, List<ACCL__Fund__c> fundsList)
    {
    
        List<Map<String, Object>> result = new List<Map<String, Object>>();
         for (ACCL__Fund__c fund : fundsList)
         {
            Map<String, Object> fundValues = new Map<String, Object>();
            fundValues.put('Id', fund.id);
            fundValues.put('Anchor_Customer__c',fund.ACCL__Anchor_Account__r.name);
            fundValues.put('Anchor_Product__c', fund.ACCL__Anchor_Product__r.name);
            fundValues.put('Name', fund.Name);
            fundValues.put('Description__c', fund.ACCL__Description__c);
            fundValues.put('Fund_Template_Description__c', fund.ACCL__Fund_Template_Description__c);
            fundValues.put('Status__c', fund.ACCL__Status__c);
            fundValues.put('Amount__c', fund.ACCL__Amount__c);
            fundValues.put('Valid_From__c', fund.ACCL__Valid_From__c);
            fundValues.put('Valid_Thru__c', fund.ACCL__Valid_Thru__c);
            result.add(fundValues);
         }
        return result;
    }
    
    /*******************************************************************
    Purpose: Read the Promotions that should be displayed in TradeCalendar and add some 
    SpecialEvents and Event for Trade Calendar 
    Version 1.0
    Parameters: String txId, String uiview in JSON Format
    Returns:  List<ACCL.PromotionRemoteActionExtension.ACCL.PromotionGroup>
    Throws : N/A 
    Author : Eleonora.dotz@accenture.com 
    ********************************************************************/     
  @RemoteAction
    public static List<ACCL.PromotionRemoteActionExtension.PromotionGroup> readLOCalPromotions(String txId, String uiview){
       system.debug(JSON.serialize(uiview));
       ACCL.PromotionRemoteActionExtension.UIViewDefinition incomingParams = ( ACCL.PromotionRemoteActionExtension.UIViewDefinition)JSON.deserialize(uiview, ACCL.PromotionRemoteActionExtension.UIViewDefinition.class);
           
        DateTime dateFromTime =   Ul_Utility.objToDate(incomingParams.date_from);
        Date dateFrom =  dateFromTime.date();
        DateTime dateThruTime =   Ul_Utility.objToDate(incomingParams.date_thru);
        Date dateThru =  dateThruTime.date();
        String currentSalesOrg = Ul_Utility.getSalesOrg(UserInfo.getUserId());

        List<ACCL.PromotionRemoteActionExtension.PromotionGroup> result = ACCL.PromotionRemoteActionExtension.readLOCalPromotions(txId, uiview);
          system.debug('result: ' + result);
      
       //  return PromotionRemoteActionExtensionEdo.readLOCalPromotions(txId, uiview);
          
        String slogan = '';
        Integer countGoups = 0;

        List <ACCL.PromotionRemoteActionExtension.CalendarPromotion> listCalProm = new List<ACCL.PromotionRemoteActionExtension.CalendarPromotion> ();
        ACCL__Promotion__c lastevent ; 
        String lastAddPromGroup = null;

        for (ACCL__Promotion__c event :  [ SELECT Id, Name, ACCL__Active__c, ACCL__Date_From__c, ACCL__Date_Thru__c, 
                                                ACCL__Phase__c, ACCL__Sales_Org__c, ACCL__Promotion_Template__c, 
                                                ACCL__Promotion_Template__r.ACCL__Trade_Calendar_Color__c,
                                                ACCL__Slogan__c, ACCL__Anchor_Account__c, ACCL__Anchor_Account__r.name 
                                            FROM ACCL__Promotion__c
                                            Where
                                                ACCL__Active__c = true
                                                and ACCL__Sales_Org__c = : currentSalesOrg
                                                and ACCL__Promotion_Template__r.ACCL__Anchor_Type__c = :UL_Utility.PROMOTION_TEMPLATE_ANCHOR_TYPE_CUSTOMER 
                                                and ACCL__Promotion_Template__r.UL_Promo_Type_ControlView__c in (:UL_Utility.PROMOTION_TEMPLATE_TYPE_SPECIALHOLIDAY, :UL_Utility.PROMOTION_TEMPLATE_TYPE_MARKETINGEVENT)
                                                and ACCL__Promotion_Template__r.ACCL__Trade_Calendar_Relevant__c= :UL_Utility.PROMOTION_TEMPLATE_TRADE_CALENDAR_RELEVANT_YES 
                                                and ACCL__Promotion_Template__r.ACCL__Promotion_Type__c = :UL_Utility.PROMOTION_TEMPLATE_PROMOTION_TYPE_PROMOTION
                                                and (ACCL__Date_Thru__c >= :dateFrom and ACCL__Date_From__c <= : dateThru)  
                                                order by ACCL__Slogan__c]){

         
            
             System.debug('Event ' + event);
            if (event != null){

                 ACCL.PromotionRemoteActionExtension.CalendarPromotion calProm =  new ACCL.PromotionRemoteActionExtension.CalendarPromotion(event.ACCL__Phase__c, event.Id, event.ACCL__Date_From__c,event.ACCL__Date_Thru__c ); // prepareDataForPromotion (event);
            
                if (!slogan.equals(event.ACCL__Slogan__c)){
                    System.debug (' Slogan is different of previous');
                    if (listCalProm.size()>0 ){
                         ACCL.PromotionRemoteActionExtension.PromotionGroup promGroup = new ACCL.PromotionRemoteActionExtension.PromotionGroup(lastevent.ACCL__Slogan__c, 
                            listCalProm, lastevent.ACCL__Promotion_Template__c, lastevent.ACCL__Anchor_Account__c, null, lastevent.ACCL__Promotion_Template__r.ACCL__Trade_Calendar_Color__c,
                           0, lastevent.ACCL__Anchor_Account__r.name , '' );
                         lastAddPromGroup = promGroup.Slogan;

                         System.debug ('lastAddPromGroup ' + lastAddPromGroup);
                         result.add(countGoups,promGroup);
                         countGoups  = countGoups + 1;

                         System.debug (' new group created');

                    }

                    listCalProm = new List<ACCL.PromotionRemoteActionExtension.CalendarPromotion> ();
                    listCalProm.add (calProm);
                    slogan = event.ACCL__Slogan__c;
                } else {
                    listCalProm.add (calProm);
                }
            
              lastevent = event;
               
            }
           


        }  // for 
         System.debug('countGoups' + countGoups);
         System.debug('result[countGoups-1].Slogan  - ' + result[0].Slogan);

        if (listCalProm.size()>0  && result.size() >0 &&  countGoups >0 && result.size() >= countGoups && lastAddPromGroup !=null && !result[countGoups-1].Slogan.equals(lastAddPromGroup) ){
             ACCL.PromotionRemoteActionExtension.PromotionGroup promGroup = new ACCL.PromotionRemoteActionExtension.PromotionGroup(lastevent.ACCL__Slogan__c, 
                        listCalProm, lastevent.ACCL__Promotion_Template__c, lastevent.ACCL__Anchor_Account__c, null, lastevent.ACCL__Promotion_Template__r.ACCL__Trade_Calendar_Color__c,
                       null, lastevent.ACCL__Anchor_Account__r.name , null );
                     lastAddPromGroup = lastevent.ACCL__Slogan__c;

                     System.debug ('lastAddPromGroup ' + lastAddPromGroup);
                     result.add(countGoups,promGroup);
                     countGoups  = countGoups + 1;

        }


        return result;
    }

 
 
}