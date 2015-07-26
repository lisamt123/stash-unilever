/*************************************************************************************
Name : BET_NewBetController

Purpose : Controller for BET_NewBet page

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/

public with sharing class BET_NewBetController {

    public uw_BET__c bet {get; set;}
    public BET_CategoryComponentData componentData {get;set;}

    /************************************************************
        Purpose: Controller class for BET_newBet.page
        Parameters: Standard Controller
        Returns: -
        Throws: -
    *************************************************************/
    public BET_NewBetController(ApexPages.StandardController stdController){
        Id currentId = System.currentPageReference().getParameters().get('Id');   
        Boolean categoryMigrated = null;
        Boolean categoryNotMigrated = null;
        if(currentId != null){
            bet = [ SELECT  Id, Name, Inoplan_Project__c, uw_Brand__c,Launch_Date__c,
                            Description__c, OwnerId,Inherit_Branding__c,Category_Group__c,
                            IPM_Project__c,IPM_Project__r.name,Brand_Position__c,
                            Product_Category__c,Product_Brand__c 
                    FROM uw_BET__c WHERE Id = :currentId ];

            categoryMigrated = IPM_BETUpdateService.CategoryCheck(bet.Product_Category__c);
            categoryNotMigrated = !categoryMigrated;
        } else {
            bet = new uw_BET__c();
            bet.ownerId = UserInfo.getUserId();
        }

        componentData = new BET_CategoryComponentData(bet);
        componentData.categoryMigrated = categoryMigrated;
        componentData.categoryNotMigrated = categoryNotMigrated;
    }

}