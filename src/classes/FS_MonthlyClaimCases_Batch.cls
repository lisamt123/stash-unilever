/* * MonthlyClaimCasesBatch used to calculate forecast amount on monthly claimed cases
*  @name MonthlyClaimCasesBatch
*  @param
*  @return 
*  @throws
*/ 
global with sharing class FS_MonthlyClaimCases_Batch implements database.Batchable<sObject>{
    global String query;
    global Map<Id,List<FS_Monthly_Claimed_Cases__c>> mapClaimCase;
    //global monthlyClaimCasesBatch(){     
    //}
/* * Start method for batch class
*  @name Start
*  @param Database.BatchableContext BC
*  @return 
*  @throws
*/ 
    global Database.QueryLocator start(Database.BatchableContext BC){       
       query='Select id,Account__c,Contract_Product__c,FS_Claimed_Cases_Paid__c,FS_First_of_Month__c,FS_Delivery_Start_Date__c from FS_Monthly_Claimed_Cases__c';
       return Database.getQueryLocator(query);
    }
/* * Execute method for batch class
*  @name Execute
*  @param Database.BatchableContext BC,List<sObject> scope
*  @return 
*  @throws
*/ 
    global void execute(Database.BatchableContext BC,List<sObject> scope){
        //List<FS_Monthly_Claimed_Cases__c> claimCaseList  =(List<FS_Monthly_Claimed_Cases__c>)scope;       
        List<FS_Monthly_Claimed_Cases__c> claimCaseToUpdate  = new List<FS_Monthly_Claimed_Cases__c>();
        List<FS_Monthly_Claimed_Cases__c> relatedClaimCaseList  = new List<FS_Monthly_Claimed_Cases__c>();
        //Set<Id> conProdIdList=new Set<Id>();
        Integer count;
        Integer totalActual;        
        //Map<id,List<FS_Monthly_Claimed_Cases__c>> epdLeadMap=new Map<id,List<FS_Monthly_Claimed_Cases__c>>();
        Map<id,List<FS_Monthly_Claimed_Cases__c>> mapClaimCase=new Map<id,List<FS_Monthly_Claimed_Cases__c>>();
        List<FS_Monthly_Claimed_Cases__c> tempList  = new List<FS_Monthly_Claimed_Cases__c>();
        //set<id> tempSet = new set<id>();
        for(FS_Monthly_Claimed_Cases__c claimed_case : (List<FS_Monthly_Claimed_Cases__c>)scope)
        {
            tempList  = new List<FS_Monthly_Claimed_Cases__c>();
            if(mapClaimCase.containskey(claimed_case.Contract_Product__c))
                    {
                        tempList   = mapClaimCase.get(claimed_case.Contract_Product__c);
                    }
            If(claimed_case.FS_First_of_Month__c!=Null){
            tempList.add(claimed_case);
            }            		
                    MapClaimCase.put(claimed_case.Contract_Product__c,tempList);
            //tempSet.add(claimed_case.Contract_Product__c);
        }         
         List<FS_Monthly_Claimed_Cases__c> relatedClaimCaseListtemp  = new List<FS_Monthly_Claimed_Cases__c>();        
        for(FS_Monthly_Claimed_Cases__c claimed_case : (List<FS_Monthly_Claimed_Cases__c>)scope)
         {           
           relatedClaimCaseListtemp  = new List<FS_Monthly_Claimed_Cases__c>();
           IF(mapClaimCase.containsKey(claimed_case.Contract_Product__c)){
           relatedClaimCaseListtemp=mapClaimCase.get(claimed_case.Contract_Product__c);
           count=0;
           TotalActual=0;          
           for(FS_Monthly_Claimed_Cases__c related_Claimed_Case: relatedClaimCaseListtemp){
                //system.debug(related_Claimed_Case.FS_First_of_Month__c);
                //system.debug(related_Claimed_Case.FS_Delivery_Start_Date__c);
                //null check related_Claimed_Case.FS_Claimed_Cases_Paid__c
                If(related_Claimed_Case.FS_First_of_Month__c< (claimed_case.FS_First_of_Month__c-100) && related_Claimed_Case.FS_First_of_Month__c>(claimed_case.FS_First_of_Month__c-450)){
                    If(related_Claimed_Case.FS_Claimed_Cases_Paid__c!=Null){                    
                    TotalActual=TotalActual+Integer.valueOf(related_Claimed_Case.FS_Claimed_Cases_Paid__c);                    
                }
                    count=count+1;
                }               
            }
            If(count>0){           
            claimed_case.FS_Forecast_Quantity__c=TotalActual/count;
            claimCaseToUpdate.add(claimed_case);
        }
        }        
        }        
        try{              
              if(!ClaimCaseToUpdate.isEmpty()){
                  update ClaimCaseToUpdate;
              }              
          }
          Catch(DmlException e){
              System.debug( 'The following exception has occurred: '+e.getMessage() );
              ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'FS_MonthlyClaimedCasesbatch', 'UpdateOppField', e.getMessage(), e, null, null, null, 0,'Food Solution');
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