/**
    About
    -----
    Description: Trigger SowAssetToProjectCalculator
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a Trigger  "After Update" on SOW Marketing object, to calculate the "ProjectTotalAssetScore__c"
                    from the asset record to the project object
                     
            Functionnalities :    
                    
    Update History
    --------------    
*/
trigger SOWAssetToProjectCalculatorV on Oblix_Project_Assets__c (after insert, after update, after delete, before insert, before update) {
    //Fire the trigger on After insert to calculate Project Score Asset
    TriggerFactory.createHandler(Oblix_Project_Assets__c.sObjectType);
    
}