/**********************************************************************
Purpose: Trigger class for the OpportunityProduct.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     07/July/2016     Created
***********************************************************************/

/** Trigger for Opportunity Product (OpportunityLineItem):
*  @name OpportunityProductTrigger
*  @param before insert, before update
*  @return N/A
*  @throws N/A
*/
trigger OpportunityProductTrigger on OpportunityLineItem (before insert, before update) {

    FS_OpportunityProductHandler handler = new FS_OpportunityProductHandler();
    
    if(Trigger.isInsert && Trigger.isBefore) {
        handler.calculateTPR(Trigger.new);
    } //else if(Trigger.isUpdate && Trigger.isBefore) {
    else if(Trigger.isUpdate && Trigger.isBefore) {
        //same with TRUE condition for now
        handler.calculateTPR(Trigger.newMap, Trigger.oldMap);
    } else {
    	//Do Nothing (Reserved)        
    }
}