global class MyPromotionRemoteActionExtension {

     global MyPromotionRemoteActionExtension(ApexPages.StandardController ctr) {
    }
       
 
     @RemoteAction
     global static String writeBOPromotion(String txId, String objectId, String content) {
        
        List<Map<String, Object> > herokuProducts = new List<Map<String, Object> >();
        Map<string,set<string>> prodIdTacticSet;
        Set<String> tacticSet;
        
        /*
        Remove namespace from the custom fields.       
        */ 
        
        content=content.replace('ACSFUL001__UL_Brand__c','UL_Brand__c');
        content=content.replace('ACSFUL001__UL_Cannibalisation_Override__c','UL_Cannibalisation_Override__c');  
        content=content.replace('ACSFUL001__UL_Category__c','UL_Category__c');      
        content=content.replace('ACSFUL001__UL_Account__c','UL_Account__c');
        content=content.replace('ACSFUL001__Account__c','Account__c')  ;  
        content=content.replace('ACSFUL001__UL_Current_Status__c','UL_Current_Status__c');    
        content=content.replace('ACSFUL001__UL_Delivery_Profile__c','UL_Delivery_Profile__c');   
        content=content.replace('ACSFUL001__UL_Feature__c','UL_Feature__c');    
        content=content.replace('ACSFUL001__UL_Free_Text__c','UL_Free_Text__c');
        content=content.replace('ACSFUL001__UL_Front_Margin__c','UL_Front_Margin__c');
        content=content.replace('ACSFUL001__UL_IIBB_Tax__c','UL_IIBB_Tax__c');
        content=content.replace('ACSFUL001__UL_Lift__c','UL_Lift__c');
        content=content.replace('ACSFUL001__UL_Mechanic__c','UL_Mechanic__c');
        content=content.replace('ACSFUL001__UL_Next_Status__c','UL_Next_Status__c');
        content=content.replace('ACSFUL001__UL_Post_Dip_End_Date__c','UL_Post_Dip_End_Date__c');
        content=content.replace('ACSFUL001__UL_Pre_Evaluation_Comment__c','UL_Pre_Evaluation_Comment__c');
        content=content.replace('ACSFUL001__UL_Primary_Objective__c','UL_Primary_Objective__c');
        content=content.replace('ACSFUL001__UL_Promotion_Name__c','UL_Promotion_Name__c');
        content=content.replace('ACSFUL001__UL_Promotion_Type__c','UL_Promotion_Type__c');
        content=content.replace('ACSFUL001__UL_Sales_Organization__c','UL_Sales_Organization__c');
        content=content.replace('ACSFUL001__UL_Secondary_Objective__c','UL_Secondary_Objective__c');
        content=content.replace('ACSFUL001__UL_Sharing_Type_Form__c','UL_Sharing_Type_Form__c');
        content=content.replace('ACSFUL001__UL_Sharing_Type_Txt__c','UL_Sharing_Type_Txt__c');
        content=content.replace('ACSFUL001__UL_Sub_Mechanic__c','UL_Sub_Mechanic__c');
        content=content.replace('ACSFUL001__UL_Volume_Type__c','UL_Volume_Type__c');
        content=content.replace('ACSFUL001__UL_Cannibalisation_Rate__c','UL_Cannibalisation_Rate__c');
        content=content.replace('ACSFUL001__UL_ThresholdViolated__c','UL_ThresholdViolated__c');
        content = content.replace('ACSFUL001__UL_Threshold_Window_Result__c','UL_Threshold_Window_Result__c');
        content = content.replace('ACSFUL001__UL_Threshold_Result__c','UL_Threshold_Result__c');
        
        Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
        
        string contentTarget = (string) tacticDeserializedMap.get('target');
        
        if(contentTarget!=null && contentTarget=='Salesforce'){
          system.debug('content--'+content);
           //To get products(including Manual products from Heroku -- Chandrababu
           herokuProducts = UL_TacticUtility.readLOExtProduct(txId,content);
            system.debug('prods size-'+herokuProducts.size());
           
           if(herokuProducts.size()>0){
               prodIdTacticSet = new Map<string,set<string>>();
               for(Map<String,Object> prods : herokuProducts){
                   System.debug('>>>>ProdId' + (string)prods.get('productid'));
                   list<UL_TacticUtility.TacticWrapper> tacwrap = (list<UL_TacticUtility.TacticWrapper>)prods.get('Tactics');
                   tacticSet = new Set<String>();
                   for(UL_TacticUtility.TacticWrapper eachTactic : tacwrap){
                       system.debug('Each Tactic-'+eachTactic);
                     if(eachTactic.Included == 'MATCH' ||eachTactic.Included == 'INCLUDED' || eachTactic.Included == 'true'){
                         tacticSet.add((string)eachTactic.tacticId);
                     }
                   }
                   prodIdTacticSet.put((string)prods.get('productid'),tacticSet);
               }
           }
        
          //Do not remove following code - Ketan
          //AAAAAKetanTestClass.readLOExtChartValues(txId,content);
          //AAAAAKetanTestClass.readLOCalPromotions(txId,content);

          //Validate Products at Tactics level and vaidate Tactics Overlap
          UL_TacticUtility.validateTacticsProducts(txId,content,prodIdTacticSet);
          
          content = populateCannibalisationRate(content);
          System.debug('Content :::'+content);
             UL_ThresholdEngine.getThresholdKPI(txId,id.valueof(objectId),'save');
          if(UL_ThresholdEngine.thresholdcheck!=null && UL_ThresholdEngine.thresholdcheck.size()>0){
            Map<String, Object> contentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
            Map<String, Object> Promotionobj = (Map<String, Object>) contentDeserializedMap.get('BOPromotion');
            Promotionobj.put('UL_Threshold_Window_Result__c', JSON.serialize(UL_ThresholdEngine.thresholdcheck));
            Promotionobj.put('UL_Threshold_Result__c', JSON.serialize(UL_ThresholdEngine.thresholdcheck).subString(0,255));
            content = JSON.serialize(contentDeserializedMap);
          
          }
            
          return ACSFUL001.PromotionRemoteActionExtension.writeBOPromotion(txId,objectId,content);
      }
      else{
          return null;
      }
    }
    
    @RemoteAction
    global static List<ACSFUL001.PromotionRemoteActionExtension.FilterItem> readLOExtPrdFilters(String txId, String objectContent) {
        system.debug('>>>>>>>>>>>>>>>>>>readLOExtPrdFilters called');
        List<ACSFUL001.PromotionRemoteActionExtension.FilterItem> result = new List<ACSFUL001.PromotionRemoteActionExtension.FilterItem>();
        List<ACSFUL001.PromotionRemoteActionExtension.FilterItem> allfilters = ACSFUL001.PromotionRemoteActionExtension.readLOExtPrdFilters(txId, objectContent);
    
        for (ACSFUL001.PromotionRemoteActionExtension.FilterItem filter:allfilters){
            if (!filter.filterId.equals( 'acsful001__category__c'))
                result.add(filter);
        }
        
        return result;


    }
    
    
    @RemoteAction
    global static String invokeWfBOPromotion(String txId, String objectId, String Mode) {
        // do whatever
        system.debug('test----'+objectId);
        system.debug('test----'+Mode);
        system.debug('txid----'+txid);
        String thresholdResult = '';
        //UL_Debugger.printDebug('test----'+objectId + Mode);
        String result = 'test';
        Id promoId = Id.valueOf(objectId) ;
        thresholdResult = UL_ThresholdEngine.getThresholdKPI(txId,promoId,Mode);
        system.debug('promoid----'+promoId );
        Id apprFuncRet = null ;
        List<ACSFUL001__Promotion__c> promoLst = new List<ACSFUL001__Promotion__c>() ;
                
        promoLst = [SELECT Id, Name, UL_ThresholdViolated__c FROM ACSFUL001__Promotion__c WHERE Id =: promoId] ;
        Boolean THViolate = promoLst[0].UL_ThresholdViolated__c ;
        
        
        //if(Mode.equalsIgnoreCase('KickOff')){
        if(Mode.equalsIgnoreCase('SUBMIT')){
         if(thresholdResult!='submitted' && thresholdResult!='approved'){
            UL_PromotionWorkflowService.submitForApproval(promoId ) ;
            }
        }
        
        if(Mode.equalsIgnoreCase('Approve')){  
                 
            if(!THViolate){
                UL_PromotionWorkflowService.submitForApproval(promoId) ;
            }
            if(thresholdResult!='approved'){
            do{ 
                apprFuncRet = UL_PromotionWorkflowService.approveWorkflow(promoId,null) ; 
            } while(apprFuncRet != null && !THViolate); 
            }
        }
        
        if(Mode.equalsIgnoreCase('REJECT')){
            UL_PromotionWorkflowService.rejectWorkflow(promoId ) ;
        }       
        
        return result;
    }
    
    
    global class EARUI{
        public String Name;
        public String Type;
        public boolean Editable;
        public boolean Visible;
    }
    @RemoteAction
    global static List<EARUI> getEARightsBOPromotion(String txId, String objectId){
       
        List<EARUI> earBOPromotion = new List<EARUI>();
        
        Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
        Id promoId = (Id)unTypedMap.get('Id'); 
        String objectName =  String.valueOf(((Id)promoId).getSObjectType());
        List<ACSFUL001__Promotion__c> PromoList = new List<ACSFUL001__Promotion__c>();
        promoList = [SELECT Id, Name, UL_Current_Status__c,UL_Parent_Push_Id__c, ACSFUL001__Sales_Org__c,UL_EnableChild__c FROM ACSFUL001__Promotion__c WHERE Id =:promoId];
        String status = promoList[0].UL_Current_Status__c;
        objectName = objectName.replace(UL_Utility.MANAGEDPACKAGE_NAMESPACE, '');
        objectName = objectName.replace('__c','');
        UL_SmartUIEditability__c settings = UL_SmartUIEditability__c.getValues(objectName+'_'+status);
        
        if((settings != null) &&((promoList[0].ACSFUL001__Sales_Org__c == 'AR01') ||(promoList[0].ACSFUL001__Sales_Org__c == 'CL01') ||(promoList[0].ACSFUL001__Sales_Org__c =='CL03') ) ){
            Schema.FieldSet fldSet = Schema.SObjectType.ACSFUL001__Promotion__c.fieldSets.getMap().get(settings.UL_Fieldset_Name__c);
            for(Schema.FieldSetMember fld: fldSet.getFields()){ 
               
                //Ketan - added the following condition since 'Promotion Name' must always be readonly even Promotion is not in approval process.
                if(fld.getFieldPath().equalsIgnorecase('ACSFUL001__Slogan__c')){
                     continue;
                }
                EARUI promoObject = new EARUI();
                promoObject.Name = fld.getFieldPath();
                promoObject.Type = 'Attribute';
                promoObject.editable = false;  
                earBOPromotion.add(promoObject);
            }
        }
        
        
        if(promoList[0].UL_EnableChild__c == true){
            system.debug('UL_EnableChild__c IS TRUE');
            Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACSFUL001__Promotion__c.fields.getMap();
            for(String s : fldObjMap.keySet())
            {
                if(fldObjMap.get(s).getDescribe().isUpdateable()){
                EARUI promoObject = new EARUI();
                promoObject.Name = s;
                promoObject.Type = 'Attribute';
                promoObject.editable = true;  
                earBOPromotion.add(promoObject);
                    
                }
                    
            }
        }
        else
            if(promoList[0].UL_Parent_Push_Id__c !=null){
                            system.debug('UL_EnableChild__c IS TRUE');
            Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.ACSFUL001__Promotion__c.fields.getMap();
            for(String s : fldObjMap.keySet())
            {
                if(fldObjMap.get(s).getDescribe().isUpdateable()){
                EARUI promoObject = new EARUI();
                promoObject.Name = s;
                promoObject.Type = 'Attribute';
                promoObject.editable = false;  
                earBOPromotion.add(promoObject);
                    
                }
                    
            }
                
                
            }
        
        //Ketan - added the following code since 'Promotion Name' should always be readonly even Promotion is not in approval process.
            EARUI promoObject = new EARUI();
            promoObject.Name = 'ACSFUL001__Slogan__c';
            promoObject.Type = 'Attribute';
            promoObject.editable = false;  
            earBOPromotion.add(promoObject);
        system.debug('earBOPromotion'+earBOPromotion) ; 
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
         system.debug(earBOPromotion);
        
        return earBOPromotion; 
    }  */
     @RemoteAction
    global static List<EARUI> getEARightsLOTactic(String txId, String objectId){
       
        
        List<EARUI> earBOTactic = new List<EARUI>();
        Map<String, Object> unTypedMap = (Map<String, Object>)JSON.deserializeUntyped(objectId);
        Id tacticId = (Id)unTypedMap.get('parentId'); 
        List<ACSFUL001__tactic__c> taclst = new List<ACSFUL001__tactic__c>();
        taclst = [Select Id from ACSFUL001__tactic__c where ACSFUL001__Promotion__c =:tacticId LIMIT 1];
        if(taclst.size() > 0){
            tacticId = taclst[0].Id;
            String objectName =  String.valueOf(((Id)tacticId).getSObjectType());
            List<ACSFUL001__Tactic__c> tacticList = new List<ACSFUL001__Tactic__c>();
            tacticList = [SELECT Id, Name, ACSFUL001__Promotion__r.UL_Current_Status__c FROM ACSFUL001__Tactic__c WHERE Id =:tacticId];
            String status = tacticList[0].ACSFUL001__Promotion__r.UL_Current_Status__c;
            objectName = objectName.replace(UL_Utility.MANAGEDPACKAGE_NAMESPACE, '');
            objectName = objectName.replace('__c','');
            UL_SmartUIEditability__c settings = UL_SmartUIEditability__c.getValues(objectName+'_'+status);
                if(settings != null){
                    Schema.FieldSet fldSet = Schema.SObjectType.ACSFUL001__Tactic__c.fieldSets.getMap().get(settings.UL_Fieldset_Name__c);
                    for(Schema.FieldSetMember fld: fldSet.getFields()){ 
                        
                        EARUI tacticObject = new EARUI();
                        tacticObject.Name = fld.getFieldPath();
                        tacticObject.Type = 'Attribute';
                        tacticObject.editable = false;  
                        earBOTactic.add(tacticObject);
                    }
                } 
            }
            
            
            return earBOTactic;         
     }
    
 
    @RemoteAction
    global static Map<Id , Set<ChildAccounts>> readLOCustomerHierarchy (String txtID ,String objectContent) {
        
        ACSFUL001__Promotion__c promo = new ACSFUL001__Promotion__c();//should store the promotion from JSON
        String parentAccountId = ''; //should take it from JSON
        List<ACSFUL001__Account_Trade_Org_Hierarchy__c> orgHierarchy= new List<ACSFUL001__Account_Trade_Org_Hierarchy__c>();
        List<ACSFUL001__Account_Set_Account__c> custHierarchy= new List<ACSFUL001__Account_Set_Account__c>();
        Map<Id , Set<ChildAccounts>>  result = new Map<Id , Set<ChildAccounts>> ();
        Map<Id,Id> childAccountMap = new Map<Id,Id>();
        List<Promotion_Acc_Rel__c> includedAccounts = new List<Promotion_Acc_Rel__c>();
        Map<id, Id> includedAccountMap = new Map<id, Id>();
        List<Account> allchildAccount = new List<Account>();
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(objectContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format
        String promoID= String.valueOf(boPromotion.get('Id'));
        
        if(boPromotion.get('Anchor_Account__c') !=null)
            parentAccountId=String.valueOf(boPromotion.get('Anchor_Account__c'));
        else
            parentAccountId=String.valueOf(boPromotion.get('Anchor_Account_set__c'));
        system.debug('parentAccountId '+parentAccountId);
        DescribeSObjectResult describeResultp = ACSFUL001__Promotion__c.getSObjectType().getDescribe();
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
        includedAccounts = [SELECT id, Child_Account__c FROM Promotion_Acc_Rel__c WHERE Parent_Promotion__c =: promo.id AND Parent_Account__c =: parentAccountId];
        system.debug('includedAccounts '+includedAccounts);
        
        for (Promotion_Acc_Rel__c p : includedAccounts)
        {
            includedAccountMap.put(p.Child_Account__c, p.Child_Account__c);
        }
         system.debug('includedAccountMap '+includedAccountMap);
        //checking the type of customer to get the childs
        //if the customer is an account get the child list from ACSFUL001__Account_Trade_Org_Hierarchy__c object
        if(promo.ACSFUL001__Anchor_Account__c !=null){
            
            orgHierarchy = [SELECT id,ACSFUL001__Child_Account__c,ACSFUL001__Parent_Account__c
                            FROM ACSFUL001__Account_Trade_Org_Hierarchy__c
                            WHERE ACSFUL001__Parent_Account__c=:parentAccountId  AND
                            ACSFUL001__Valid_From__c >=: promo.ACSFUL001__Date_From__c  AND
                            ACSFUL001__Valid_Thru__c <=: promo.ACSFUL001__Date_Thru__c];
            
            for (ACSFUL001__Account_Trade_Org_Hierarchy__c a : orgHierarchy)
            {
                childAccountMap.put(a.ACSFUL001__Child_Account__c, a.ACSFUL001__Child_Account__c);
            }
            
       allchildAccount=[SELECT id,Name FROM Account WHERE id IN:childAccountMap.keyset()];    
         system.debug('allchildAccount '+allchildAccount);   
        }
        //if the customer is an customer set get the child list from ACSFUL001__Account_Set_Account__c 
        else{     
         custHierarchy=  [SELECT id,ACSFUL001__Account__c FROM ACSFUL001__Account_Set_Account__c WHERE ACSFUL001__Account_Set__c=:parentAccountId];
          for (ACSFUL001__Account_Set_Account__c a : custHierarchy)
            {
                childAccountMap.put(a.ACSFUL001__Account__c, a.ACSFUL001__Account__c);
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
           

            }
            else{
                child.Included = false;
                child.Name = a.Name;
                child.CustomerID = parentAccountId;
                child.PushedPromoID = promo.id;
  
            }
                 childSet.add(child);
                 result.put(a.id, childSet);
        }

        return result;
    }
    
    @RemoteAction
    //This function get the call from UI and call the push or enableChild functionality
    global static void InvokePushPromotion(String txtId,String mode,String promoContent ){
        if(mode=='Push')
            CreatePushPromotions(promoContent);
        
        else if(mode=='EnableChild')
            UpdateEnableChildPromoFlag(promoContent);//should send as parameter the id from promocontent
    }  
    
    //This function creates new child promotions(with tactics and funds) after the click on push button
    global static void CreatePushPromotions(String promoContent){
        
        // should include the child account list from UI with included and excluded
        List<ChildAccounts> childAccountList = new List<ChildAccounts>(); 
        ChildAccounts child = new ChildAccounts();
        child.Included=true;
        child.CustomerID='0015800000Yx5j5';
        childAccountList.add(child);
        
        
        ACSFUL001__Promotion__c promotocopy = New ACSFUL001__Promotion__c();//parent promotion
        List<ACSFUL001__Promotion__c> promoListToinsert = New List<ACSFUL001__Promotion__c>();//child promotions to insert
        List <Promotion_Acc_Rel__c> allthePromoAccList = New List <Promotion_Acc_Rel__c>();//List of all the promotion_Acc existing
        Map <id,Promotion_Acc_Rel__c> allthePromoAccMap = New Map <id,Promotion_Acc_Rel__c> ();//Map<childAccountId,promotion_Acc>
        List<Promotion_Acc_Rel__c> promoAccrelToDelete = New List<Promotion_Acc_Rel__c>();//promotion_Acc of the child account that changed to exluded in the last save and refresh
        List<id> promoAccrelToAddChildId =New List<id>();//List of child account Id that we need to create promotion_Acc for
        List<Promotion_Acc_Rel__c> promoAccrelToAdd = New List<Promotion_Acc_Rel__c>();//List of new promotion_Acc to insert
        List<ACSFUL001__Tactic__c> tactToInsert = new List<ACSFUL001__Tactic__c>();//List of new Tactics that should be insert with the new child promotions
        List<ACSFUL001__Tactic__c> tactToCopy = new List<ACSFUL001__Tactic__c>();//List of the parent promotion tactics that we need to copy
       List< ACSFUL001__Tactic_Fund__c> tactFundsToCopy = new List< ACSFUL001__Tactic_Fund__c>(); //List of new Tactics Funds that should be insert with the new tactics
        List< ACSFUL001__Tactic_Fund__c> tactFundsToInsert = new List< ACSFUL001__Tactic_Fund__c>();//List of the parent promotion tactics funds that we need to copy
        List <id> tactToSelectList = new List <id>();     
        String promoCustomerType = '';
        
        
        Map<String, Object> promoContentDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(promoContent);//deserializing the JSON from UI        
        Map<String, Object> boPromotion = (Map<String, Object>) promoContentDeserializedMap.get('BOPromotion');//Get the promotion in Map format
        List<Object> boPromotionTacticts = (List<Object>) boPromotion.get('LOTactic');
        String promoID= String.valueOf(boPromotion.get('Id'));

        DescribeSObjectResult describeResultp = ACSFUL001__Promotion__c.getSObjectType().getDescribe();
        
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

        /*promotocopy=[SELECT id,ACSFUL001__Anchor_Account_Set__c,ACSFUL001__Anchor_Account__c FROM ACSFUL001__Promotion__c 
                     WHERE id=: promoID];*/
        
        For(Object o : boPromotionTacticts){
            Map<String, Object> tactic = (Map<String, Object>) o;
            tactToSelectList.add(String.valueOf(tactic.get('Id')));
        }  
        
        DescribeSObjectResult describeResult = ACSFUL001__Tactic__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet());
        
        String query =
            ' SELECT ' +
            String.join( fieldNames, ',' ) +
            ' FROM ' +
            describeResult.getName() +
            ' WHERE ' +
            ' id IN:tactToSelectList ';

        tactToCopy = Database.query( query ); 
        
        
        
      //  tactToCopy=[SELECT id,ACSFUL001__Promotion__c FROM ACSFUL001__Tactic__c WHERE id IN:tactToSelectList];
        
        
        //check the customer type in promotion
        if(promotocopy.ACSFUL001__Anchor_Account__c!=null){
            promoCustomerType='Account';
        }
        else {
            promoCustomerType='CustomerSet';
        }
        //query the existing Promotion_Acc_Rel__c depended of the customer type
        if(promoCustomerType=='Account'){
        allthePromoAccList=[Select id,Child_Account__c FROM Promotion_Acc_Rel__c
                            WHERE Parent_Account__c=:promotocopy.ACSFUL001__Anchor_Account__c and Parent_Promotion__c=:promotocopy.id];

        }else{
            allthePromoAccList=[Select id,Child_Account__c FROM Promotion_Acc_Rel__c
                            WHERE Parent_Account__c=:promotocopy.ACSFUL001__Anchor_Account_Set__c and Parent_Promotion__c=:promotocopy.id];
        }
        //allthePromoAccList to map
            for(Promotion_Acc_Rel__c par :allthePromoAccList){
            allthePromoAccMap.put(par.Child_Account__c,par);
        }
        
        //delete all the last pushed promotions (should delete the tactics and funds too)
        delete [select id FROM ACSFUL001__Promotion__c WHERE UL_Parent_Push_Id__c=: promotocopy.id];  
        
        
        //Loop on childAccountList(FROM UI) clone promotion if the child account is included and add the promotion_acc to delete list if it's exluded
        for(ChildAccounts cha: childAccountList){
           ACSFUL001__Promotion__c clonepromo = promotocopy.clone();
            clonepromo.UL_Parent_Push_Id__c=promotocopy.id;
            if(cha.Included==true){
                if(promoCustomerType=='CustomerSet')
                    clonepromo.ACSFUL001__Anchor_Account_Set__c =null;
                
                clonepromo.ACSFUL001__Anchor_Account__c=cha.CustomerID;
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
        for(ACSFUL001__Promotion__c p : promoListToinsert){
            for(ACSFUL001__Tactic__c t :tactToCopy){
                ACSFUL001__Tactic__c newt = t.clone();
                newT.ACSFUL001__Promotion__c= p.id;
                tactToInsert.add(newt);
                
            }
        }
        insert tactToInsert;
        
        
        
        //Loop to create the new Promotion_Acc_Rel__c for the child account that have been included in the last save
        for(id i:promoAccrelToAddChildId){
            Promotion_Acc_Rel__c par = new Promotion_Acc_Rel__c();
            par.Child_Account__c=i;
            par.Parent_Promotion__c=promotocopy.id;
            if(promoCustomerType=='CustomerSet')
                par.Parent_Account__c= promotocopy.ACSFUL001__Anchor_Account_Set__c;
            else
                par.Parent_Account__c= promotocopy.ACSFUL001__Anchor_Account__c;
            promoAccrelToAdd.add(par);
        }
        insert promoAccrelToAdd;
        
        
    }
    
    //This function is updating the enableChild field to get all the fields editable when the user click on enable child button
    global static void UpdateEnableChildPromoFlag(String objectId){
        List <ACSFUL001__Promotion__c> childPromotions = new List <ACSFUL001__Promotion__c>();
        ACSFUL001__Promotion__c promo = new ACSFUL001__Promotion__c();
        promo =[select id FROM ACSFUL001__Promotion__c WHERE id=: objectId LIMIT 1];//should be taken from JSON objectId
        childPromotions=[SELECT id,UL_Parent_Push_Id__c,UL_EnableChild__c FROM ACSFUL001__Promotion__c 
                         where UL_Parent_Push_Id__c=: promo.ID];
        for(ACSFUL001__Promotion__c p : childPromotions){
            p.UL_EnableChild__c=true;
        }
      update childPromotions;
    }
    
    
    /***************************
    *This Method is used to populate Cannibalisation Rate on Promotion
    ***************************/
    public static String populateCannibalisationRate(String content){
        Map<String, Object> tacticDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
        List<String> productIdList = new List<String>();
        Map<String, Object> boPromotion = (Map<String, Object>) tacticDeserializedMap.get('BOPromotion');
        List<Object> loTactic = (List<Object>) boPromotion.get('LOTactic');
        for(Object tacticObj : loTactic){
            Map<String, Object> productFilter= (Map<String, Object>)((Map<String, Object>)tacticObj).get('productfilter');
            List<Object> manualProducts = new List<Object>();
            if(productFilter.get('manualproducts')!=null){
                manualProducts = (List<Object>) productFilter.get('manualproducts');
            }
            System.debug('manualProducts:::'+manualProducts);
            for(Object productObj : manualProducts){
                productIdList.add((String)((Map<String, Object>)productObj).get('productid'));
            }
        }
        System.debug('productIdList:::'+productIdList);
        if(!productIdList.isEmpty()){
            Map<Id, ACSFUL001__Product__c> productMap = new Map<Id, ACSFUL001__Product__c>([SELECT Id, ACSFUL001__Product_Level__c, ACSFUL001__Criterion_2_Product__c, ACSFUL001__Criterion_2_Product__r.Name FROM ACSFUL001__Product__c WHERE Id IN:productIdList]);
            
            if(!productMap.isEmpty()){
                Set<Id> marketLevelIds = new Set<Id>();
                String marketId;
                String customerId = (String)boPromotion.get('ACSFUL001__Anchor_Account__c');
                String feature = (String)boPromotion.get('UL_Feature__c');
                String tempMarketId;
                String tempCustomerId;
                String tempFeature;
                Decimal cannibalisationRate;
                boolean foundCannRate = false;
                Id childProductId;
                String market;
                for(ACSFUL001__Product__c product : productMap.values()){
                    if(product.ACSFUL001__Criterion_2_Product__c != null){
                        marketLevelIds.add(product.ACSFUL001__Criterion_2_Product__c);
                        marketId = String.valueOf(product.ACSFUL001__Criterion_2_Product__c);
                        childProductId = product.Id;
                    }
                }
                
                //populating Market Field
                if(marketLevelIds.size()==1){
                    market = productMap.get(childProductId).ACSFUL001__Criterion_2_Product__r.Name;
                }
                else if(marketLevelIds.size()>1){
                    market = System.Label.UL_Multiple_Markets;
                }
                else{
                    market = System.Label.None;
                }
                boPromotion.put('UL_Market__c', market);
                
                String fromStringDate = (String)(''+boPromotion.get('ACSFUL001__Placement_Date_From__c'));
                String thruStringDate = (String)(''+boPromotion.get('ACSFUL001__Placement_Date_Thru__c'));
                Datetime fromDate = fromStringDate.contains('-') ? null : Datetime.newInstance((Long)boPromotion.get('ACSFUL001__Placement_Date_From__c'));
                Date instoreDateFrom = fromStringDate.contains('-') ? Date.valueOf(fromStringDate) : Date.newInstance(fromDate.year(), fromDate.month(), fromDate.day());
                Datetime thruDate = thruStringDate.contains('-') ? null : Datetime.newInstance((Long)boPromotion.get('ACSFUL001__Placement_Date_Thru__c'));
                Date instoreDateThru = thruStringDate.contains('-') ? Date.valueOf(thruStringDate) : Date.newInstance(thruDate.year(), thruDate.month(), thruDate.day());
                
                List<UL_Cannibalisation_Rate__c> cannibRateList = [SELECT Id, UL_Valid_From__c, UL_Valid_Thru__c, UL_Customer__c, UL_Product__c, UL_Feature__c, UL_Cannibalisation_Rate__c FROM UL_Cannibalisation_Rate__c WHERE UL_Valid_From__c <= :instoreDateFrom AND UL_Valid_Thru__c >= :instoreDateThru];
                Map<String, UL_Cannibalisation_Rate__c> cannibRateMap = new Map<String, UL_Cannibalisation_Rate__c>();
                for(UL_Cannibalisation_Rate__c cannibRate : cannibRateList){
                    String key = String.valueOf(cannibRate.UL_Customer__c) + String.valueOf(cannibRate.UL_Product__c) + cannibRate.UL_Feature__c;
                    cannibRateMap.put(key, cannibRate);
                }
                for(String K : cannibRateMap.keySet()){
                    System.debug('K:::'+K);
                    System.debug('Value:::'+cannibRateMap.get(K));
                }
                
                tempCustomerId = customerId;
                tempMarketId = marketId;
                tempFeature = feature;
                //Single Market
                if(marketLevelIds.size()==1){
                    
                    //For Customer/Market/Fearure combination
                    String key = tempCustomerId + tempMarketId + tempFeature;
                    if(cannibRateMap.containsKey(key)){
                        cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                        boPromotion.put('UL_Cannibalisation_Rate__c', cannibalisationRate);
                        foundCannRate = true;
                    }
                    if(!foundCannRate){
                        //For Customer/Market/NULL Fearure combination
                        tempFeature = null;
                        key = tempCustomerId + tempMarketId + tempFeature;
                        if(cannibRateMap.containsKey(key)){
                            cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                            boPromotion.put('UL_Cannibalisation_Rate__c', cannibalisationRate);
                            foundCannRate = true;
                        }
                    }
                }
                //Multiple Markets
                if(!foundCannRate){
                    //For Customer/Null Market/Fearure combination
                    tempFeature = feature;
                    tempMarketId = null;
                    String key = tempCustomerId + tempMarketId + tempFeature;
                    if(cannibRateMap.containsKey(key)){
                        cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                        boPromotion.put('UL_Cannibalisation_Rate__c', cannibalisationRate);
                        foundCannRate = true;
                    }
                }
                if(!foundCannRate){
                    //For Customer/Null Market/ NULL Fearure combination
                    tempFeature = null;
                    tempMarketId = null;
                    String key = tempCustomerId + tempMarketId + tempFeature;
                    if(cannibRateMap.containsKey(key)){
                        cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                        boPromotion.put('UL_Cannibalisation_Rate__c', cannibalisationRate);
                        foundCannRate = true;
                    }
                }
                if(!foundCannRate){
                    //For NULL Customer/Null Market/ NULL Fearure combination
                    tempFeature = null;
                    tempMarketId = null;
                    tempCustomerId = null;
                    String key = tempCustomerId + tempMarketId + tempFeature;
                    if(cannibRateMap.containsKey(key)){
                        cannibalisationRate = cannibRateMap.get(key).UL_Cannibalisation_Rate__c;
                        boPromotion.put('UL_Cannibalisation_Rate__c', cannibalisationRate);
                        foundCannRate = true;
                    }
                }
                System.debug('cannibalisationRate:::'+cannibalisationRate);
            }
        }
        content = JSON.serialize(tacticDeserializedMap);
        return content;
    }
    
    
}