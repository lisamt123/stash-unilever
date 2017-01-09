/***************************************************************
    Name: UL_PromotionUtility
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    A class to implement Promotion related functionalities.
    ======================================================
    History
    -------
    VERSION     AUTHOR        DATE           DETAIL                 Description
    1.0         Ketan Mehta   16/11/2016     INITIAL DEV            Pramotion push and release functionality implemented.
    ***************************************************************/
   public with sharing class UL_PromotionUtility{
    
    private static Boolean hasParentPromotionTactic = UL_Utility.BOOLEAN_FALSE;    
    
    /*******************************************************************
    Purpose: Method to clone promotion and associate with the provided account list  
    Version 1.0
    Parameters: Promotion Id, List of Account Ids 
    Returns: Boolean
    Throws : N/A 
    ********************************************************************/
    public static List<ACCL__promotion__c> clonePromotion(Id promotionId, List<Id> accountIds, Boolean isTacticClone, 
                                                               Boolean isFundClone, Map<String,object> promotionFieldOverride, Map<String,object> tacticFieldOverride, 
                                                               Map<String,object> fundFieldOverride){
        
        //Non-Static Variables
        List<ACCL__promotion__c> insertPromotionList = new List<ACCL__promotion__c>{};
        //if deriving object id undefined, do not take any action 
        if(accountIds == null ||  accountIds.isEmpty()){
          return insertPromotionList;
        }
        
        //If fund clone is required, tactic clone has to be performed due to Tactic and Fund relationship
        if(isFundClone){
           isTacticClone = true;
        }
              
        SavePoint transactionSavePoint = null;                          
        try{
       
          UL_PromotionCloneWrapper promotionCloneWrapper = UL_PromotionUtility.getClonedPromotion(promotionId, accountIds, isTacticClone, 
                                                           isFundClone, promotionFieldOverride, tacticFieldOverride, fundFieldOverride);
          
          if(PromotionCloneWrapper != null) {         
           List<UL_PromotionCloneWrapper> promotionWrapperList = promotionCloneWrapper.inlineCloneWrapperList;
           
           if(promotionWrapperList != null && (!promotionWrapperList.isEmpty())){
                
               for(UL_PromotionCloneWrapper promotionWrapper: promotionWrapperList){
                    promotionWrapper.inlinePromotion.ACCL__Active__c=true;
                    insertPromotionList.add(promotionWrapper.inlinePromotion);
                }
                   
                transactionSavePoint = Database.setSavePoint(); 
                
                //Insert Promotion list   
                insert insertPromotionList;  
                
                Map<Id,Id> oldNewTacticMap = new Map<Id,Id>();
                if(isTacticClone && hasParentPromotionTactic){
                    Integer promotionCounter=0; 
                    List<ACCL__Tactic__c> insertTacticList = new List<ACCL__Tactic__c>();
                    for(ACCL__promotion__c insertedPromotion : insertPromotionList){
                      for(Id tacticId: promotionWrapperList.get(promotionCounter).inlineTacticMap.keySet()){
                         
                         ACCL__Tactic__c clonedTatic = (ACCL__Tactic__c)promotionWrapperList.get(promotionCounter).inlineTacticMap.get(tacticId);
                         clonedTatic.ACCL__Promotion__c = insertedPromotion.id;
                         
                         //Insert tactic 
                         insert clonedTatic;
                         oldNewTacticMap.put(tacticId, clonedTatic.id);
                      }
                      promotionCounter++;
                    }
                 
                  //Create TacticFund entries
                  if(isFundClone && PromotionCloneWrapper.inlineTacticFundMap != null){
                      Map<Id,ACCL__Tactic_Fund__c> tacticFundMap = PromotionCloneWrapper.inlineTacticFundMap;
                      for(Id tacticId: tacticFundMap.keySet()){
                         tacticFundMap.get(tacticId).ACCL__Tactic__c = oldNewTacticMap.get(tacticId);
                      }
                      insert tacticFundMap.values();
                  }
               }   
            }
          }
        }catch(Exception ex){
           Database.rollback(transactionSavePoint);
           UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
     return insertPromotionList;
  }
  
  /*******************************************************************
    Purpose: Method to release pushed promotion from the associated account  
    Version 1.0
    Parameters: Promotion Id 
    Returns: Boolean
    Throws : N/A 
  ********************************************************************/
  public static Boolean release(Id promotionId){
     Boolean isReleased = UL_Utility.BOOLEAN_FALSE;
     List<ACCL__promotion__c> releasePromotionList = new List<ACCL__promotion__c>();
     try{
         for(ACCL__promotion__c releasePromotion: [SELECT UL_Parent_Locker_Promotion__c FROM ACCL__promotion__c 
                                                        WHERE UL_Parent_Locker_Promotion__c=:promotionId 
                                                        Limit:(LIMITS.getLimitQueryRows() - LIMITS.getQueryRows())]){
            releasePromotion.UL_Parent_Locker_Promotion__c = UL_Utility.NULL_ID;
            releasePromotionList.add(releasePromotion);
         }
         
         if(!releasePromotionList.isEmpty()){
           update releasePromotionList;
         }
         
         isReleased = UL_Utility.BOOLEAN_TRUE;
     }catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
     }
     return isReleased; 
  }
  
  /*******************************************************************
    Purpose: Update promotion product(s) to support security model 
    Version 1.0
    Parameters: Promotion Id, List of product Id 
    Returns: List of UL_PromotionCloneWrapper object
    Throws : N/A 
  ********************************************************************/
  //@future
  public static void updatePromotionProduct(Id promotionId, Set<Id> productIdSet){
      if(promotionId == UL_Utility.NULL_ID){
          return;
      }
      
      //Reset parameter to avoid any exception
      if(productIdSet == null){
          productIdSet = new Set<Id>();
      }    
      
      //Get promotion product(s) if already stored
      Set<Id> storedPromotionProduct = new Set<Id>();
      Map<Id, Id> productCategory = new Map<Id, Id>();
      
      try{
          for(UL_PromotionCategory__c PromotionCategory : [SELECT id, Heroku_Product_Id__c FROM UL_PromotionCategory__c 
                                                           WHERE Promotion__c =: promotionId LIMIT:(LIMITS.getLimitQueryRows() - LIMITS.getQueryRows())]){
              storedPromotionProduct.add(PromotionCategory.Heroku_Product_Id__c); 
              productCategory.put(PromotionCategory.Heroku_Product_Id__c, PromotionCategory.Id);          
          }
          
          //In case promotion has stored product category, remove unused and add new one  
          Set<Id> insertProductSet = new Set<Id>();
          if(!storedPromotionProduct.isEmpty()){
              Set<Id> totlaPromotionProduct = new Set<Id>();
              totlaPromotionProduct.addAll(storedPromotionProduct);
              totlaPromotionProduct.addAll(productIdSet);
              
              
              //Segregate newly added and non-required stored products 
              Set<Id> removeProductSet = new Set<Id>();
              for(Id productId : totlaPromotionProduct){
                 if(productIdSet.contains(productId) && storedPromotionProduct.contains(productId)){ 
                     continue;
                 }
                 else if(productIdSet.contains(productId) && (!storedPromotionProduct.contains(productId))){
                     insertProductSet.add(productId);
                 }
                 else{ 
                     removeProductSet.add(productId);
                 }
              }
                  
              //Remove PromotionCategory added earlier and now not part of promotion 
              if(!removeProductSet.isEmpty()){
                  List<UL_PromotionCategory__c> removeProductList = new  List<UL_PromotionCategory__c>();
                  for(Id storedProductId : removeProductSet){
                      UL_PromotionCategory__c removeProductCategory = new UL_PromotionCategory__c();
                      removeProductCategory.id = productCategory.get(storedProductId);
                      removeProductList.add(removeProductCategory);
                  }
                  
                  Database.delete(removeProductList, false);
              }
          }else {
              //Adding fresh products
              insertProductSet.addAll(productIdSet);
          }
          
          //Insert new products to ProductCategory.
          if(!insertProductSet.isEmpty()){
              List<UL_PromotionCategory__c> insertProductCategoryList = new List<UL_PromotionCategory__c>();
              //Create ProductCategory list to add new products
              for(ACCL__Product__c product : [SELECT id, ACCL__Criterion_2_Product__c FROM ACCL__Product__c WHERE 
                                                   id in:insertProductSet LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
                  if(product.ACCL__Criterion_2_Product__c != UL_Utility.NULL_ID){ 
                      UL_PromotionCategory__c insertProductCategory = new UL_PromotionCategory__c();
                      insertProductCategory.Heroku_Product_Id__c = product.id;
                      insertProductCategory.Product__c = product.ACCL__Criterion_2_Product__c;
                      insertProductCategory.Promotion__c = promotionId;
                      insertProductCategoryList.add(insertProductCategory);
                  }
              } 
              
              Database.insert(insertProductCategoryList);
          }
      }catch(Exception ex){
          UL_Utility.logError(ex, UserInfo.getUserId());
      }
  }
  
  /*******************************************************************
    Purpose: Internal method to clone promotion and related tactics
    Version 1.0
    Parameters: Promotion Id, List of Account Ids 
    Returns: List of UL_PromotionCloneWrapper object
    Throws : N/A 
  ********************************************************************/
  private static UL_PromotionCloneWrapper getClonedPromotion(Id promotionId, List<Id> accountIds, Boolean isTacticClone, Boolean isFundClone, 
                                                             Map<String,object> promotionFieldOverride, Map<String,object> tacticFieldOverride, 
                                                             Map<String,object> fundFieldOverride){
      UL_PromotionCloneWrapper promotionCloneWrapper = null;
      List<UL_PromotionCloneWrapper> clonePromotionList = null;
      
      //if promotion id is null, do not take any action
      if(promotionId != UL_Utility.NULL_ID){
          //A list of fields for promotion 
          List<String> fieldList = new List<String>{};
                    
          //Prepare promotion query
           Schema.SObjectType objectType = promotionId.getSObjectType();
           fieldList.addAll(objectType.getDescribe().fields.getMap().keySet());
           
           String promotionQuery = 'SELECT ' + String.join(fieldList, UL_Utility.FIELD_SPLITTER);
           promotionQuery += ' FROM ' + 
                             objectType.getDescribe().getName() + 
                             ' WHERE ID = \'' + promotionId + '\'';
          
          //Prepare tactic query
          fieldList.clear();
          objectType = ACCL__Tactic__c.getSObjectType();
          fieldList.addAll(objectType.getDescribe().fields.getMap().keySet());
          String tacticQuery = 'SELECT ' + String.join(fieldList, UL_Utility.FIELD_SPLITTER);
                tacticQuery += ' FROM ' + objectType.getDescribe().getName() + ' WHERE ACCL__Promotion__c = \'' + promotionId + '\'';
          
          
          clonePromotionList = new List<UL_PromotionCloneWrapper>();
       
          //Get promotion object
          sObject parentSObject = Database.query(promotionQuery);
       
          //Get tactic objects
          List<sObject> childSObject = Database.query(tacticQuery);
       
         //Clone promotion(s) and tactic(s) with count of account(s)               
         hasParentPromotionTactic = (childSObject != null && (!childSObject.isEmpty()))?  UL_Utility.BOOLEAN_TRUE : UL_Utility.BOOLEAN_FALSE;
         sObject inlineClonedPromotion = UL_Utility.NULL_OBJECT;
         Map<Id, SObject> inlineClonedTacticMap = null; 
         Set<Id> inlineFundSet = new Set<Id>();
         for(Id accountId:accountIds){
            //Clone Promotion
            inlineClonedPromotion = parentSObject.clone(UL_Utility.BOOLEAN_FALSE,UL_Utility.BOOLEAN_TRUE);
            
            //Override promotion fields if provided
            if(promotionFieldOverride != null && (!promotionFieldOverride.isEmpty())){
                for(String key: promotionFieldOverride.keySet()){
                    inlineClonedPromotion.put(key, promotionFieldOverride.get(key)); 
                }
            }
            
            //Clone Tactics
            if(isTacticClone && hasParentPromotionTactic){
              inlineClonedTacticMap = new Map<Id, SObject>();
              for(SObject tacticSObject: childSObject){
                  
                  //Override tactic fields if provided
                  if(tacticFieldOverride != null && (!tacticFieldOverride.isEmpty())){
                    for(String key: tacticFieldOverride.keySet()){
                        tacticSObject.put(key, tacticFieldOverride.get(key)); 
                    }
                  } 
              
                  inlineClonedTacticMap.put(tacticSObject.id, tacticSObject.clone(UL_Utility.BOOLEAN_FALSE,UL_Utility.BOOLEAN_TRUE));
                  inlineFundSet.add(tacticSObject.id);
              }
            }
          
          clonePromotionList.add(new UL_PromotionCloneWrapper(inlineClonedPromotion,inlineClonedTacticMap, accountId, promotionId));
        } 
        
        //Clone tactic-fund records
        Map<Id, ACCL__Tactic_Fund__c> inlineClonedTacticFundMap = null;
        if(isFundClone && (!inlineFundSet.isEmpty())){
          inlineClonedTacticFundMap = new Map<Id, ACCL__Tactic_Fund__c>(); 
          objectType = ACCL__Tactic_Fund__c.getSObjectType(); 
          fieldList.clear(); 
          fieldList.addAll(objectType.getDescribe().fields.getMap().keySet());
          String tacticFundQuery = 'SELECT ' + String.join(fieldList, UL_Utility.FIELD_SPLITTER);
                 tacticFundQuery+= ' FROM ' + objectType.getDescribe().getName() + ' WHERE ACCL__Tactic__c IN:inlineFundSet';
                 
                 
          List<ACCL__Tactic_Fund__c> tacticFundSObjectList = Database.query(tacticFundQuery);
          
          for(ACCL__Tactic_Fund__c tacticFundSObject: tacticFundSObjectList){
          //Override fund fields if provided
              if(fundFieldOverride != null && (!fundFieldOverride.isEmpty())){
                  for(String key: fundFieldOverride.keySet()){
                      tacticFundSObject.put(key, fundFieldOverride.get(key)); 
                  }
              }
              
              inlineClonedTacticFundMap.put(tacticFundSObject.ACCL__Tactic__c, tacticFundSObject.clone(UL_Utility.BOOLEAN_FALSE,UL_Utility.BOOLEAN_TRUE));
          }
        }
        
        promotionCloneWrapper = new UL_PromotionCloneWrapper(clonePromotionList,inlineClonedTacticFundMap);
      }
      
      return promotionCloneWrapper; 
  }
  
  /***************************************************************
    Name: UL_PromotionCloneWrapper
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    Wrapper class to communicate complex result between methods.
    ======================================================
    History
    -------
    VERSION     AUTHOR        DATE           DETAIL                 Description
    1.0         Ketan Mehta   16/11/2016     INITIAL DEV            Class added with a parameterised constuctor.
    ***************************************************************/
  private with sharing class UL_PromotionCloneWrapper{
     private ACCL__promotion__c inlinePromotion = null;
     private Map<Id,SObject> inlineTacticMap = null; 
     private Map<Id,ACCL__Tactic_Fund__c> inlineTacticFundMap = null;
     private List<UL_PromotionCloneWrapper> inlineCloneWrapperList = null;
     
     /*******************************************************************
     Purpose: Parameterized constructor to build wrapper object
     Version 1.0
     Parameters: SObject Promotion, SObject list tactic, Account Id, Promotion Id 
     Returns: N/A
     Throws : N/A 
     ********************************************************************/
     public UL_PromotionCloneWrapper(SObject promotion, Map<Id,SObject> tacticMap, Id accountId, Id parentPromotionId){
       this.inlinePromotion = (ACCL__promotion__c)promotion;
       if(accountId.getSObjectType() == Account.sObjectType){
           this.inlinePromotion.ACCL__Anchor_Account__c = accountId; //Set Account id
       }else{
               this.inlinePromotion.ACCL__Anchor_Account_Set__c = accountId; //set CustomerSet id
       }
       this.inlinePromotion.UL_Parent_Locker_Promotion__c = parentPromotionId;
       this.inlineTacticMap = tacticMap;
     } 
     
     /*******************************************************************
     Purpose: Parameterized constructor to build wrapper object
     Version 1.0
     Parameters: promotionCloneWrapper list, Promotion, Tacticfund Map 
     Returns: N/A
     Throws : N/A 
     ********************************************************************/
     public UL_PromotionCloneWrapper(List<UL_PromotionCloneWrapper> promotionCloneWrapper, Map<Id, ACCL__Tactic_Fund__c> tacticFundMap){
         this.inlineCloneWrapperList = promotionCloneWrapper;
         this.inlineTacticFundMap = tacticFundMap;
     }
  }
}