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
        List<Map<String, Object> > herokuProducts = new List<Map<String, Object>>();
        String result = UL_Utility.STRING_NULL;
        Map<string,set<string>> prodIdTacticSet;
        Set<String> tacticSet;
        Set<Id> productIdSet; 
        try{
            /*Remove namespace from the custom fields.*/ 
            //content=content.replace('ACCL__UL_','UL_');
            
            content=content.replace('ACCL__UL_Brand__c','UL_Brand__c');
            content=content.replace('ACCL__UL_Cannibalisation_Override__c','UL_Cannibalisation_Override__c');  
            content=content.replace('ACCL__UL_Category__c','UL_Category__c');      
            content=content.replace('ACCL__UL_Account__c','UL_Account__c');
            content=content.replace('ACCL__Account__c','Account__c')  ;  
            content=content.replace('ACCL__UL_Current_Status__c','UL_Current_Status__c');    
            content=content.replace('ACCL__UL_Delivery_Profile__c','UL_Delivery_Profile__c');   
            content=content.replace('ACCL__UL_Feature__c','UL_Feature__c');    
            content=content.replace('ACCL__UL_Free_Text__c','UL_Free_Text__c');
            content=content.replace('ACCL__UL_Front_Margin__c','UL_Front_Margin__c');
            content=content.replace('ACCL__UL_IIBB_Tax__c','UL_IIBB_Tax__c');
            content=content.replace('ACCL__UL_Lift__c','UL_Lift__c');
            content=content.replace('ACCL__UL_Mechanic__c','UL_Mechanic__c');
            content=content.replace('ACCL__UL_Next_Status__c','UL_Next_Status__c');
            content=content.replace('ACCL__UL_Post_Dip_End_Date__c','UL_Post_Dip_End_Date__c');
            content=content.replace('ACCL__UL_Pre_Evaluation_Comment__c','UL_Pre_Evaluation_Comment__c');
            content=content.replace('ACCL__UL_Primary_Objective__c','UL_Primary_Objective__c');
            content=content.replace('ACCL__UL_Promotion_Name__c','UL_Promotion_Name__c');
            content=content.replace('ACCL__UL_Promotion_Type__c','UL_Promotion_Type__c');
            content=content.replace('ACCL__UL_Sales_Organization__c','UL_Sales_Organization__c');
            content=content.replace('ACCL__UL_Secondary_Objective__c','UL_Secondary_Objective__c');
            content=content.replace('ACCL__UL_Sharing_Type_Form__c','UL_Sharing_Type_Form__c');
            content=content.replace('ACCL__UL_Sharing_Type_Txt__c','UL_Sharing_Type_Txt__c');
            content=content.replace('ACCL__UL_Sub_Mechanic__c','UL_Sub_Mechanic__c');
            content=content.replace('ACCL__UL_Volume_Type__c','UL_Volume_Type__c');
            content=content.replace('ACCL__UL_Cannibalisation_Rate__c','UL_Cannibalisation_Rate__c');
            content=content.replace('ACCL__UL_ThresholdViolated__c','UL_ThresholdViolated__c');
            content = content.replace('ACCL__UL_Threshold_Window_Result__c','UL_Threshold_Window_Result__c');
            content = content.replace('ACCL__UL_Threshold_Result__c','UL_Threshold_Result__c');
            
            Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
            string contentTarget = (string) tacticDeserializedMap.get(UtilityEnum.target.Name());
        
            if(contentTarget!=null && contentTarget==UtilityEnum.Salesforce.Name()){
            
             //Update Workflow Threshold on every save to see latest Threshold values --Chandrababu
              UL_ThresholdEngine.getThresholdKPI(txId,id.valueof(objectId),UtilityEnum.save.Name());
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
                         }
                       }
                       prodIdTacticSet.put((string)prods.get(UtilityEnum.productid.Name()),tacticSet);
                   }
                   
                   //Insert record to Promotion Category
                   if(!productIdSet.isEmpty()){
                       UL_PromotionUtility.updatePromotionProduct(objectId, productIdSet);
                   }
               }
            
               //Validate Products at Tactics level and vaidate Tactics Overlap
               UL_TacticUtility.validateTacticsProducts(txId,content,prodIdTacticSet);
              
               content = populateCannibalisationRate(content);
             
               result = ACCL.PromotionRemoteActionExtension.writeBOPromotion(txId,objectId,content);
           }
           else{
              result = null;
           }
       }catch(Exception ex){
	     throw ex;
          UL_Utility.logError(ex, UserInfo.getUserId());
       }
      
      return result; 
    }

    /*******************************************************************
    Purpose: Apply filters on Promotion SmartUI.  
    Version 1.0
    Parameters: Transaction Id, Promotion Content 
    Returns: List of FilterItem Object
    Throws : N/A 
    ********************************************************************/     
    @RemoteAction
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
    }
    
    /*******************************************************************
    Purpose: Invokes Promotion workflow  
    Version 1.0
    Parameters: Transaction Id, Promotion Id, Status Mode 
    Returns: String
    Throws : N/A 
    ********************************************************************/     
    @RemoteAction
    global static String invokeWfBOPromotion(String txId, String objectId, String Mode) {
        
        String result = 'test';
        
        try{
            Id promoId = Id.valueOf(objectId);
            String thresholdResult = UL_Utility.EMPTY_STRING;
            Boolean THViolate;
            Id apprFuncRet = UL_Utility.NULL_ID;
            List<ACCL__Promotion__c> promoLst = new List<ACCL__Promotion__c>() ;
            List<Id> approverIdsLst = new List<Id>() ;
                    
            promoLst = [SELECT Id, Name, CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c, UL_Finance_Check_Approvers__c,UL_Manager_Check_Approvers__c,ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c, ACCL__Active__c  FROM ACCL__Promotion__c WHERE Id =: promoId] ;
            approverIdsLst.add(promoLst[0].createdbyid) ;
            
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.toUpperCase())){
                if(!THViolate){
                UL_PromotionWorkflowService.submitForApproval(promoId,promoLst,promoLst[0].createdby.UL_Finance_Manager__c) ;
                    do{ 
                        apprFuncRet = UL_PromotionWorkflowService.approveWorkflow(promoId,promoLst,null) ;
                        promoLst = [SELECT Id, Name,CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c,  ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c  FROM ACCL__Promotion__c WHERE Id =: promoId] ;        
                    } while(apprFuncRet != null && !THViolate && promoLst[0].UL_Current_Status__c != UL_Utility.STATUS_APPROVED);
                }
            }
           
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_APPROVE)){           
                apprFuncRet = UL_PromotionWorkflowService.approveWorkflow(promoId,promoLst,promoLst[0].UL_Current_Status__c) ; 
            }
            
            if(Mode.equalsIgnoreCase(UL_Utility.STATUS_REJECT.toUpperCase())){
                UL_PromotionWorkflowService.rejectWorkflow(promoId,promoLst );
            }       
        }catch(Exception ex){
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
    @RemoteAction
    global static List<EARUI> getEARightsBOPromotion(String txId, String objectId){
       
        List<EARUI> earBOPromotion = new List<EARUI>();
        try{
            Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
            Id promoId = (Id)unTypedMap.get(UtilityEnum.Id.Name()); 
            String objectName =  String.valueOf(((Id)promoId).getSObjectType());
            List<ACCL__Promotion__c> PromoList = new List<ACCL__Promotion__c>();
            promoList = [SELECT Id, Name, UL_Current_Status__c,UL_Parent_Push_Id__c, ACCL__Sales_Org__c,UL_EnableChild__c FROM ACCL__Promotion__c WHERE Id =:promoId];
            String status = promoList[0].UL_Current_Status__c;
            objectName = objectName.replace(UL_Utility.MANAGEDPACKAGE_NAMESPACE, UL_Utility.EMPTY_STRING);
            objectName = objectName.replace(CUSTOM_OBJECT_POSTFIX,UL_Utility.EMPTY_STRING);
            UL_SmartUIEditability__c settings = UL_SmartUIEditability__c.getValues(objectName+UL_Utility.UNDERSCORE+status);
            
            if((settings != null) &&((promoList[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.AR01.Name()) ||(promoList[0].ACCL__Sales_Org__c == UL_Utility.SalesOrg.CL01.Name()) ||(promoList[0].ACCL__Sales_Org__c ==UL_Utility.SalesOrg.CL03.Name()))){
                Schema.FieldSet fldSet = Schema.SObjectType.ACCL__Promotion__c.fieldSets.getMap().get(settings.UL_Fieldset_Name__c);
                for(Schema.FieldSetMember fld: fldSet.getFields()){ 
                   
                    //Ketan - added the following condition since 'Promotion Name' must always be readonly even Promotion is not in approval process.
                    if(fld.getFieldPath().equalsIgnorecase(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Slogan__c.getName())){
                         continue;
                    }
                    EARUI promoObject = new EARUI();
                    promoObject.Name = fld.getFieldPath();
                    promoObject.Type = UtilityEnum.Attribute.Name();
                    promoObject.editable = false;  
                    earBOPromotion.add(promoObject);
                }
            }
            
            
            if(promoList[0].UL_EnableChild__c == true){
                Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACCL__Promotion__c.fields.getMap();
                for(String s : fldObjMap.keySet())
                {
                    if(fldObjMap.get(s).getDescribe().isUpdateable()){
                        EARUI promoObject = new EARUI();
                        promoObject.Name = fldObjMap.get(s).getDescribe().getName();
                        promoObject.Type = UtilityEnum.Attribute.Name();
                        promoObject.editable = true;  
                        earBOPromotion.add(promoObject);
                    }
                        
                }
            }
            else
                if(promoList[0].UL_Parent_Push_Id__c !=UL_Utility.NULL_ID){
                    Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACCL__Promotion__c.fields.getMap();
                    for(String s : fldObjMap.keySet())
                    {
                        if(fldObjMap.get(s).getDescribe().isUpdateable()){
                            EARUI promoObject = new EARUI();
                            promoObject.Name = fldObjMap.get(s).getDescribe().getName();
                            promoObject.Type = UtilityEnum.Attribute.Name();
                            promoObject.editable = false;  
                            earBOPromotion.add(promoObject);
                        }
                    }
                }
            
                //Ketan - added the following code since 'Promotion Name' should always be readonly even Promotion is not in approval process.
                EARUI promoObject = new EARUI();
                promoObject.Name = Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Slogan__c.getName();
                promoObject.Type = UtilityEnum.Attribute.Name();
                promoObject.editable = false;  
                earBOPromotion.add(promoObject);
                
           }catch(Exception ex){
               UL_Utility.logError(ex, UserInfo.getUserId());
           } 
            
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
            Id tacticId = (Id)unTypedMap.get(UtilityEnum.parentId.Name()); 
            List<ACCL__tactic__c> taclst = new List<ACCL__tactic__c>();
            promo=[Select Id,UL_EnableChild__c,UL_Parent_Push_Id__c from ACCL__Promotion__c where ID =:tacticId LIMIT 1];
            taclst = [Select Id from ACCL__tactic__c where ACCL__Promotion__c =:tacticId LIMIT 1];
            if(taclst.size() > 0){
                tacticId = taclst[0].Id;
                String objectName =  String.valueOf(((Id)tacticId).getSObjectType());
                List<ACCL__Tactic__c> tacticList = new List<ACCL__Tactic__c>();
                tacticList = [SELECT Id, Name, ACCL__Promotion__r.UL_Current_Status__c FROM ACCL__Tactic__c WHERE Id =:tacticId];
                String status = tacticList[0].ACCL__Promotion__r.UL_Current_Status__c;
                objectName = objectName.replace(UL_Utility.MANAGEDPACKAGE_NAMESPACE, UL_Utility.EMPTY_STRING);
                objectName = objectName.replace(CUSTOM_OBJECT_POSTFIX,UL_Utility.EMPTY_STRING);
                UL_SmartUIEditability__c settings = UL_SmartUIEditability__c.getValues(objectName+UL_Utility.UNDERSCORE+status);
                    if(settings != null){
                        Schema.FieldSet fldSet = Schema.SObjectType.ACCL__Tactic__c.fieldSets.getMap().get(settings.UL_Fieldset_Name__c);
                        for(Schema.FieldSetMember fld: fldSet.getFields()){ 
                            
                            EARUI tacticObject = new EARUI();
                            tacticObject.Name = fld.getFieldPath();
                            tacticObject.Type = UtilityEnum.Attribute.Name();
                            tacticObject.editable = false;  
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
    global static String invokePromotionThresholdCheckBOPromotion(String txId, String objectId, String Mode){
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
    public static String populateCannibalisationRate(String content){
        try{
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
            if(!productIdList.isEmpty()){
                Map<Id, ACCL__Product__c> productMap = new Map<Id, ACCL__Product__c>([SELECT Id, ACCL__Product_Level__c, ACCL__Criterion_2_Product__c, ACCL__Criterion_2_Product__r.Name, ACCL__Criterion_1_Product__r.Name, ACCL__Criterion_3_Product__r.Name FROM ACCL__Product__c WHERE Id IN:productIdList]);
                
                if(!productMap.isEmpty()){
                    Set<Id> marketLevelIds = new Set<Id>();
                    Set<String> brandLevelSet = new Set<String>();
                    Set<String> categorytLevelSet = new Set<String>();
                    String marketId;
                    String customerId = (String)boPromotion.get('UL_Account__c');
                    String feature = (String)boPromotion.get('UL_Feature__c');
                    String tempMarketId;
                    String tempCustomerId;
                    String tempFeature;
                    Decimal cannibalisationRate;
                    boolean foundCannRate = false;
                    Id childProductId;
                    String market;
                    for(ACCL__Product__c product : productMap.values()){
                        if(product.ACCL__Criterion_2_Product__c != null){
                            marketLevelIds.add(product.ACCL__Criterion_2_Product__c);
                            brandLevelSet.add(product.ACCL__Criterion_3_Product__c);
                            categorytLevelSet.add(product.ACCL__Criterion_1_Product__c);
                            marketId = String.valueOf(product.ACCL__Criterion_2_Product__c);
                            childProductId = product.Id;
                        }
                    }
                    
                    //populating Market Field
                    if(marketLevelIds.size()==1){
                        market = productMap.get(childProductId).ACCL__Criterion_2_Product__r.Name;
                    }
                    else if(marketLevelIds.size()>1){
                        market = System.Label.UL_Multiple_Markets;
                    }
                    else{
                        market = System.Label.None;
                    }

                    //populating Category Field
                    if(categorytLevelSet.size()==1){
                        market = productMap.get(childProductId).ACCL__Criterion_1_Product__r.Name;
                    }
                    else if(marketLevelIds.size()>1){
                        market = System.Label.UL_Multiple_Categories;
                    }
                    else{
                        market = System.Label.None;
                    }

                    //populating Brand Field
                    if(brandLevelSet.size()==1){
                        market = productMap.get(childProductId).ACCL__Criterion_3_Product__r.Name;
                    }
                    else if(marketLevelIds.size()>1){
                        market = System.Label.UL_Multiple_Brands;
                    }
                    else{
                        market = System.Label.None;
                    }

                    boPromotion.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Market__c.getName(), market);
                    
                    String fromStringDate = (String)(UL_Utility.EMPTY_STRING+boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_From__c.getName()));
                    String thruStringDate = (String)(UL_Utility.EMPTY_STRING+boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_Thru__c.getName()));
                    Datetime fromDate = fromStringDate.contains(UL_Utility.HYPHEN) ? null : Datetime.newInstance((Long)boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_From__c.getName()));
                    Date instoreDateFrom = fromStringDate.contains(UL_Utility.HYPHEN) ? Date.valueOf(fromStringDate) : Date.newInstance(fromDate.year(), fromDate.month(), fromDate.day());
                    Datetime thruDate = thruStringDate.contains(UL_Utility.HYPHEN) ? null : Datetime.newInstance((Long)boPromotion.get(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_Thru__c.getName()));
                    Date instoreDateThru = thruStringDate.contains(UL_Utility.HYPHEN) ? Date.valueOf(thruStringDate) : Date.newInstance(thruDate.year(), thruDate.month(), thruDate.day());
                    
                    Map<String, UL_Cannibalisation_Rate__c> cannibRateMap = new Map<String, UL_Cannibalisation_Rate__c>();
                    for(UL_Cannibalisation_Rate__c cannibRate : [SELECT Id, UL_Valid_From__c, UL_Valid_Thru__c, UL_Customer__c, UL_Product__c, UL_Feature__c, UL_Cannibalisation_Rate__c FROM UL_Cannibalisation_Rate__c WHERE UL_Valid_From__c <= :instoreDateFrom AND UL_Valid_Thru__c >= :instoreDateFrom ]){
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
                            tempFeature = null;
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
                        tempFeature = null;
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
                        tempFeature = null;
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
                        tempFeature = null;
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
        String promoSlogan= String.valueOf(boPromotion.get('Slogan_Language_1__c'));
        
        if(boPromotion.get('ACCL__Anchor_Account__c') !=null)
            parentAccountId=String.valueOf(boPromotion.get('ACCL__Anchor_Account__c'));
        else
            parentAccountId=String.valueOf(boPromotion.get('ACCL__Anchor_Account_set__c'));
        system.debug('ACCL__parentAccountId '+parentAccountId);
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
            
       allchildAccount=[SELECT id,Name,UL_Customer_Unique__c FROM Account WHERE id IN:childAccountMap.keyset()];    
         system.debug('allchildAccount '+allchildAccount);   
        }
        //if the customer is an customer set get the child list from ACSFUL001__Account_Set_Account__c 
        else{     
         custHierarchy=  [SELECT id,ACCL__Account__c FROM ACCL__Account_Set_Account__c WHERE ACCL__Account_Set__c=:parentAccountId];
          for (ACCL__Account_Set_Account__c a : custHierarchy)
            {
                childAccountMap.put(a.ACCL__Account__c, a.ACCL__Account__c);
            }
            
        allchildAccount=[SELECT id,Name,UL_Customer_Unique__c FROM Account WHERE id IN:childAccountMap.keyset()];    
    
        
        
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
                List< ACCL__Tactic_Fund__c> listFund =tactFundsMap.get('tactFund.ACCL__Tactic__c');
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
           system.debug('clonepromo '+clonepromo);
            clonepromo.UL_Parent_Push_Id__c=promotocopy.id;
                if(promoCustomerType=='CustomerSet')
                    clonepromo.ACCL__Anchor_Account_Set__c=null;
                
                clonepromo.ACCL__Anchor_Account__c=allPromoAccList[0].Child_Account__c;
              clonepromo.UL_EnableChild__c=false;
               // promoListToinsert.add(clonepromo);
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
                
            }}
       // }
        List<ACCL__Tactic__c> tactToInsertlist = new List<ACCL__Tactic__c> (tactToInsert.keySet());
           if(!tactToInsertlist.isEmpty()){
            insert tactToInsertlist;
           
           if(!tactFundsListToInsert.isEmpty()){
           for(ACCL__Tactic__c t : tactToInsertlist){
               List<ACCL__Tactic_Fund__c> tactFuntocopy = new List<ACCL__Tactic_Fund__c>();
               if(tactFundsMap.containsKey(tactToInsert.get(t))){
               tactFuntocopy=tactFundsMap.get(tactToInsert.get(t));
               for(ACCL__Tactic_Fund__c tf : tactFuntocopy){
                   ACCL__Tactic_Fund__c tfclone = tf.clone();
                   tfclone.ACCL__Tactic__c=t.id;
                   tactFundsListToInsert.add(tfclone);
               }
               }
               
           }
           }
           }
           if(!tactFundsListToInsert.isEmpty()){ 
             insert tactFundsListToInsert;
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
        
        return child;
        
    }
    
    @RemoteAction 
    global static void cleanUpPushBOPromotion(String txId,String promoContent){
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format        
        
        //delete all the last pushed promotions (should delete the tactics and funds too)
         delete [select id FROM ACCL__Promotion__c WHERE UL_Parent_Push_Id__c=: String.valueOf(boPromotion.get('Id'))];
        List<Promotion_Acc_Rel__c> allthePromoAccList= getPromotionAccRel(promoContent); 
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
            cha.TxStatus__c='TxCompleted';
        }
        update allPromoAcc;
        
    }  
    //This function is updating the enableChild field to get all the fields editable when the user click on enable child button
    @RemoteAction 
    global static void UpdateEnablePushBOPromotion(String txId,String promoParams){
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoParams);//deserializing the JSON from UI        
         Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format        
       
        List<Promotion_Acc_Rel__c> allPromoAccList=new List<Promotion_Acc_Rel__c>();
        allPromoAccList= getPromotionAccRel(promoParams);
        try{
            Integer i=0;
            Boolean allIsCompleted=true;
            While(i<allPromoAccList.size() && allIsCompleted==true){
                if(allPromoAccList[i].TxStatus__c != 'TxCompleted')
                    allIsCompleted=false;
            }
            if(allIsCompleted==false){
                Throw new UL_customException('One of the Promotion Acc Rel Status is not completed');
            }
            List <ACCL__Promotion__c> childPromotions = new List <ACCL__Promotion__c>();
            ACCL__Promotion__c promo = new ACCL__Promotion__c();
            childPromotions=[SELECT id,UL_Parent_Push_Id__c,UL_EnableChild__c FROM ACCL__Promotion__c 
                             where UL_Parent_Push_Id__c=: String.valueOf(boPromotion.get('Id'))];
            for(ACCL__Promotion__c p : childPromotions){
                p.UL_EnableChild__c=true;
            }
            update childPromotions;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            
        }
    }
}