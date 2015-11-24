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

    //FabricConditioner begin
    private static Boolean fbEnabled = BET_FabricCoditioners__c.getOrgDefaults().Enabled__c;
    //FabricConditioner end

    /************************************************************
        Purpose: Controller class for BET_newBet.page
        Parameters: Standard Controller
        Returns: -
        Throws: -
    *************************************************************/
    public BET_NewBetController(ApexPages.StandardController stdController){
        System.debug('Entering BET_NewBetController constructor : ' + stdController);
        Id currentId = System.currentPageReference().getParameters().get('Id');   
        Boolean categoryMigrated = null;
        Boolean categoryNotMigrated = null;
        Boolean fabricConditionerCategory = null;
        
        if(currentId == null){
            bet = new uw_BET__c();
            bet.ownerId = UserInfo.getUserId();
        } else {
            bet = [ SELECT  Id, Name, Inoplan_Project__c,Launch_Date__c,
                            Description__c, OwnerId,Inherit_Branding__c,Category_Group__c,
                            IPM_Project__c,IPM_Project__r.name,Brand_Position__c,
                            Product_Category__c,Product_Brand__c,Is_Fabric_Conditioners__c 
                    FROM uw_BET__c WHERE Id = :currentId ];

            categoryMigrated = IPM_BETUpdateService.CategoryCheck(bet.Product_Category__c);
            categoryNotMigrated = !categoryMigrated;
            //FabricConditioner begin
            fabricConditionerCategory = fbEnabled ? BET_MasterDataService.isFabricConditionersCategory(bet.Product_Category__c) : false;
            //FabricConditioner end
        }
        componentData = new BET_CategoryComponentData(bet);
        componentData.categoryMigrated = categoryMigrated;
        componentData.categoryNotMigrated = categoryNotMigrated;
        //FabricConditioner begin
        componentData.fabricConditionerCategory = fabricConditionerCategory;
        //FabricConditioner end
    }

}