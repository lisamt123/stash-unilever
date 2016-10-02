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
public class FS_OpportunityProductHandler {
    
    /** Handler method for TPR Calculation during update of Opportunity Product:
    *  @name calculateTPR
    *  @param Map<Id, OpportunityLineItem> newOppProdMap, Map<Id, OpportunityLineItem> oldOppProdMap
    *  @return N/A
    *  @throws N/A
    */
    public void calculateTPR(Map<Id, OpportunityLineItem> newOppProdMap, Map<Id, OpportunityLineItem> oldOppProdMap) {
        List<OpportunityLineItem> newOppProdList = new  List<OpportunityLineItem>();
        
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
    
    /** Handler method for TPR Calculation during insert of Opportunity Product:
    *  @name calculateTPR
    *  @param List<OpportunityLineItem> newOppProdList
    *  @return N/A
    *  @throws N/A
    */
    public void calculateTPR(List<OpportunityLineItem> newOppProdList) {
        FS_TPRCalculationHelper.calculateTPR(newOppProdList, false);        
    }
    
}