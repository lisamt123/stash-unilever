/**********************************************************************
Purpose: Handler class for Opportunity Product for the Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    7/Jul/2016     Draft                     
***********************************************************************/

/** Handler Class for Opportunity Product (OpportunityLineItem):
*  @name FS_OpportunityProductHandler
*  @param N/A
*  @return N/A
*  @throws N/A
*/
public with sharing class FS_OpportunityProductHandler {
    
    /** Handler method for TPR Calculation during update of Opportunity Product:
    *  @name calculateTPR
    *  @param Map<Id, OpportunityLineItem> newOppProdMap, Map<Id, OpportunityLineItem> oldOppProdMap
    *  @return N/A
    *  @throws N/A
    */
    public void calculateTPR(Map<Id, OpportunityLineItem> newOppProdMap, Map<Id, OpportunityLineItem> oldOppProdMap) {
        List<OpportunityLineItem> newOppProdList = new  List<OpportunityLineItem>();
        
        if(isFoodSolutionActivity(newOppProdMap.values())) {
            
            for(OpportunityLineItem oli : newOppProdMap.values()) {
                if(oli.FS_TPRCalculationFlag__c != oldOppProdMap.get(oli.Id).FS_TPRCalculationFlag__c ||
                    oli.Quantity != oldOppProdMap.get(oli.Id).Quantity ||
                    oli.FS_tprPercent__c != oldOppProdMap.get(oli.Id).FS_tprPercent__c ||
                    oli.FS_valueNecessaryWithVAT__c != oldOppProdMap.get(oli.Id).FS_valueNecessaryWithVAT__c ||
                    oli.FS_DistributorMarkup__c != oldOppProdMap.get(oli.Id).FS_DistributorMarkup__c) {
                    newOppProdList.add(oli);
                }
        	}        
        
        FS_TPRCalculationHelper.calculateTPR(newOppProdList, true);
        }
                
    }
    
    /** Handler method for TPR Calculation during insert of Opportunity Product:
    *  @name calculateTPR
    *  @param List<OpportunityLineItem> newOppProdList
    *  @return N/A
    *  @throws N/A
    */
    public void calculateTPR(List<OpportunityLineItem> newOppProdList) {
        if(isFoodSolutionActivity(newOppProdList)) {
        	FS_TPRCalculationHelper.calculateTPR(newOppProdList, false);
        }        
    }
    
    /** Trigger check to see if the trigger is run by a Food Solution RecordType:
    *  @name calculateTPR
    *  @param List<OpportunityLineItem> newOppProdList
    *  @return N/A
    *  @throws N/A
    */
    public boolean isFoodSolutionActivity(List<OpportunityLineItem> oppProdList) {
        boolean isFoodSolutionActivity = false;
        
        Map<String, List<Opportunity>> oppRecordTypeMap = new Map<String, List<Opportunity>>();
        
        //Query Opportunity Entries
        Set<Id> opportunityIdList = new Set<Id>();
        for(OpportunityLineItem oli : oppProdList) {
            opportunityIdList.add(oli.OpportunityId);
        }        
        
        list<Opportunity> tempList = new list<Opportunity>();
        for(Opportunity opp:[SELECT id, 
                             		name, 
                             		RecordType.DeveloperName 
                            	FROM Opportunity 
                             	WHERE Id IN : opportunityIdList]){
                                    
            tempList = new list<Opportunity>();
            if(oppRecordTypeMap.containskey(opp.RecordType.DeveloperName))
            {
                tempList   = oppRecordTypeMap.get(opp.RecordType.DeveloperName);
            }
            tempList.add(opp);
            oppRecordTypeMap.put(opp.RecordType.DeveloperName,tempList);
            
        }  
        
        if(oppRecordTypeMap.containsKey('FS_OpportunityTPR')) {
            isFoodSolutionActivity = true;
        } else {
            isFoodSolutionActivity = false;
        }       
        
        return isFoodSolutionActivity;
    }
    
}