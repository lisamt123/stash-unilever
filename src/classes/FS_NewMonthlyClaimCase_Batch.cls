/* * NewMonthlyClaimCase_Batch used to create claimed cases each month
*  @name NewMonthlyClaimCase_Batch
*  @param
*  @return 
*  @throws
*/
Global with sharing class FS_NewMonthlyClaimCase_Batch implements database.Batchable<sObject>{
    global String query;
    global Map<Id,FS_Monthly_Claimed_Cases__c> MapClaimCase;
/* * Start method for batch class
*  @name Start
*  @param Database.BatchableContext BC
*  @return 
*  @throws
*/     
    global Database.QueryLocator start(Database.BatchableContext BC){       
       query='Select id,Account__c,Contract_Product__c,FS_Claimed_Cases_Paid__c,FS_First_of_Month__c,FS_Delivery_Start_Date__c,FS_Planned_Quantity__c,product__C from FS_Monthly_Claimed_Cases__c';    
       // where contract_product__c= \'a8y8A0000004EOp\'
       return Database.getQueryLocator(query);
    }
/* * Execute method for batch class
*  @name Execute
*  @param Database.BatchableContext BC,List<sObject> scope
*  @return 
*  @throws
*/ 
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        //List<FS_Monthly_Claimed_Cases__c> ClaimCaseList  =(List<FS_Monthly_Claimed_Cases__c>)scope;        
        List<FS_Monthly_Claimed_Cases__c> claimCaseToInsert  = new List<FS_Monthly_Claimed_Cases__c>();
        List<FS_Monthly_Claimed_Cases__c> relatedClaimCaseList  = new List<FS_Monthly_Claimed_Cases__c>();
        FS_Monthly_Claimed_Cases__c tempClaimCase=new FS_Monthly_Claimed_Cases__c();        
        Integer count;
        Integer totalActual;      
        Map<id,FS_Monthly_Claimed_Cases__c> mapClaimCase=new Map<id,FS_Monthly_Claimed_Cases__c>();
        FS_Monthly_Claimed_Cases__c temp  = new FS_Monthly_Claimed_Cases__c();
        //set<id> tempSet = new set<id>();
        for(FS_Monthly_Claimed_Cases__c claimed_case : (List<FS_Monthly_Claimed_Cases__c>)scope)
        {
            temp  = new FS_Monthly_Claimed_Cases__c();
            if(mapClaimCase.containskey(claimed_case.Contract_Product__c))
            {
                        temp=mapClaimCase.get(claimed_case.Contract_Product__c);
                If(claimed_case.FS_First_of_Month__c!=Null){
                        If(claimed_case.FS_First_of_Month__c>temp.FS_First_of_Month__c){
                        mapClaimCase.KeySet().remove(claimed_case.Contract_Product__c);
                        temp=claimed_case; 
                        MapClaimCase.put(claimed_case.Contract_Product__c,temp);
                        //Break;
                   }
                }
            }
            If(!mapClaimCase.containskey(claimed_case.Contract_Product__c) && claimed_case.FS_First_of_Month__c!=Null){           
            temp=claimed_case;            
            mapClaimCase.put(claimed_case.Contract_Product__c,temp);         
            }                                          
            }                 
            
        tempClaimCase=new FS_Monthly_Claimed_Cases__c();          
        for(Id conProduct : MapClaimCase.KeySet())
         {           
           tempClaimCase  = new FS_Monthly_Claimed_Cases__c();
           //If(MapClaimCase.containsKey(conProduct)){
           tempClaimCase=MapClaimCase.get(conProduct);           
           If(tempClaimCase!=Null){
           claimCaseToInsert.add(New FS_Monthly_Claimed_Cases__c(contract_product__c=tempClaimCase.Contract_Product__c,FS_First_of_Month__c=(tempClaimCase.FS_First_of_Month__c+32).toStartOfMonth(),FS_Planned_Quantity__c=tempClaimCase.FS_Planned_Quantity__c,Product__c=tempClaimCase.Product__c,account__c=tempClaimCase.Account__c));
          }           
        }        
        try{              
              if(!claimCaseToInsert.isEmpty()){
                  Insert claimCaseToInsert;                  
              }              
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'FS_NewClaimedCasesbatch', 'New Claimed Case', e.getMessage(), e, null, null, null, 0,'Food Solution');
          }
        }
/* * Finish method for execute class
*  @name Finish
*  @param Database.BatchableContext BC
*  @return 
*  @throws
*/
    global void finish(Database.BatchableContext BC){        
    }
}