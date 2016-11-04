public class UL_FundTransactionHandler{

public static void FundTransfer(list<ACSFUL001__Fund_Transaction__c> ftlist){
   Set<Id> fundIdSet = new Set<Id>();
   Set<Id> templateSet = new Set<Id>();
   
   for(ACSFUL001__Fund_Transaction__c fundTran: ftList){
     fundIdSet.add(fundTran.ACSFUL001__Source_Fund__c);
     fundIdSet.add(fundTran.ACSFUL001__Target_Fund__c);
     templateSet.add(fundTran.ACSFUL001__Transaction_Template__c);
   }
     
   Map<Id,ACSFUL001__Fund__c> fundMap = new Map<Id,ACSFUL001__Fund__c>([SELECT ACSFUL001__Anchor_Product__c FROM ACSFUL001__Fund__c WHERE Id IN:fundIdSet]);
   Set<Id> anchProdSet = new Set<Id>();
   For(ACSFUL001__Fund__c fundObj: fundMap.Values()){
     anchProdSet.add(fundObj.ACSFUL001__Anchor_Product__c);
   }
   
   Map<Id,ACSFUL001__Product__c> prodMap = new Map<Id,ACSFUL001__Product__c>([SELECT ACSFUL001__Product_Level__c FROM ACSFUL001__Product__c WHERE id IN:anchProdSet]);
   Map<Id,String> fundLevelMap = new Map<Id,String>();
   ACSFUL001__Product__c tempProd;
   for(ACSFUL001__Fund__c fundObj: fundMap.values()){
       tempProd =  prodMap.get(fundObj.ACSFUL001__Anchor_Product__c);
       if(tempProd !=null){
        fundLevelMap.put(fundObj.id, tempProd.ACSFUL001__Product_Level__c);
       }
   }
    
    String source, target;
    ACSFUL001__Transaction_Template__c  tranTemplate; 
    Map<id, ACSFUL001__Transaction_Template__c> templateMap = new Map<id, ACSFUL001__Transaction_Template__c>([SELECT Id, ACSFUL001__Transaction_Type__c, UL_Cross_Category_Transfer_Allowed__c FROM ACSFUL001__Transaction_Template__c WHERE Id IN:templateSet]);
    
    for(ACSFUL001__Fund_Transaction__c fundTran: ftList){
      tranTemplate = templateMap.get(fundTran.ACSFUL001__Transaction_Template__c); 
      if(tranTemplate == null){
          continue;
      }
      else if(tranTemplate.ACSFUL001__Transaction_Type__c=='Transfer'){
             if(tranTemplate.UL_Cross_Category_Transfer_Allowed__c==True){
                 source = fundLevelMap.get(fundTran.ACSFUL001__Source_Fund__c);
                 target= fundLevelMap.get(fundTran.ACSFUL001__Target_Fund__c);
                
                 if(target.equalsIgnoreCase(source)){
                     fundTran.adderror('For Cross Category Transfer transaction the product category in funds cannot be same');
                 }
             }
             else if(tranTemplate.UL_Cross_Category_Transfer_Allowed__c==False){
                 source = fundLevelMap.get(fundTran.ACSFUL001__Source_Fund__c);
                 target= fundLevelMap.get(fundTran.ACSFUL001__Target_Fund__c);
                
                 if(!target.equalsIgnoreCase(source)){
                     fundTran.adderror('For Transfer transaction the product category in funds must be same'); 
                 }
            } 
      }
 }
}
}