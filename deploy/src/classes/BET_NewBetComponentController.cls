/*************************************************************************************
Name : BET_NewBetComponentController

Purpose : Controller for NewBetComponent component

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
public with sharing class BET_NewBetComponentController {

    //FabricConditioner begin
    private static Boolean fbEnabled = BET_FabricCoditioners__c.getOrgDefaults().Enabled__c;
    //FabricConditioner end

    public BET_CategoryComponentData compData {get;set;}
    public Boolean goToMemberSelection {get;set;}
    public String retURL {get;set;}
    public String forwardUrl {get;set;}

    public uw_BET__c bet {
        get{
            return bet;
        }
        set{
            bet = value;
        }
    }

    public BET_NewBetComponentController(){
        goToMemberSelection = false;
    }

    public Boolean ownerOrManager {
        get{
            return BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(bet.id, UserInfo.getUserId());
        }
        set{
            ownerOrManager = value;
        }   
    }

    /************************************************************
        Purpose: Method cancels upsert operation on BET obiect
        Parameters: -
        Returns: Referece to return page
        Throws: -
    *************************************************************/

    public PageReference cancelBET(){     
        System.debug('Entering cancelBET : ' + retUrl);
        PageReference pageRef= retURL == null ? Page.BET : new PageReference(retUrl);
        System.debug('Exit cancelBET : ' + pageRef);
        return pageRef;
    }

    /************************************************************
        Purpose: Method upserts BET object
        Parameters: -
        Returns: Reference to next page
        Throws: -
    *************************************************************/

    public PageReference saveBET(){
        System.debug('Entering saveBET : ' + bet + ', ' + compData);
        PageReference pageRef = null;
        try{
            proceedWithSave(false);
            pageRef = forwardUrl == null ? null : new PageReference(forwardUrl+bet.id);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving BET record'+e));
        }
        System.debug('Exit saveBET : ' + pageRef);
        return pageRef;
    }

    /************************************************************
        Purpose: Method upserts BET object and displays member selection form
        Parameters: -
        Returns: Reference to next page
        Throws: -
    *************************************************************/
    public PageReference saveBETandAddMembers(){
        System.debug('Entering saveBETandAddMembers : ' + bet + ', ' + compData);
        try{
            proceedWithSave(true);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving BET record'+e));
        }
        System.debug('Exit saveBETandAddMembers');
        return null;
    }

    /************************************************************
        Purpose: Method upserts BET object
        Parameters: Boolean indicates if members component shoudl be displayed after upsert operation
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
    private void proceedWithSave(Boolean redirectToMembersComponent){
        System.debug('Entering proceedWithSave : ' + redirectToMembersComponent);
        
        compData.categoryMigrated = compData.category == null ? false : IPM_BETUpdateService.CategoryCheck(compData.category);
        
        //FabricConditioner begin
        try{
            compData.fabricConditionerCategory = fbEnabled ? BET_MasterDataService.isFabricConditionersCategory(compData.category) : false;
        }catch(Exception e){
            compData.fabricConditionerCategory = false;
        }
        //FabricConditioner end
        System.debug(compData);
        bet = moveComponentDataToBET(bet,compData);
        List<String> errorMessages = validateBET(bet);
        Boolean betNameExists = BET_CommonService.checkIfBetExists(bet);
        goToMemberSelection = redirectToMembersComponent;
        if(errorMessages.isEmpty() && !betNameExists){
            if(bet.id == null){
                bet.Sharing__c = 'Private';
            }
            upsert bet;
        } else {
            if(betNameExists) {
                errorMessages.add(Label.BET_NameExists);
            }
            displayErrors(errorMessages);
            goToMemberSelection = false;
        }
        System.debug('Exit proceedWithSave');
    }

    /************************************************************
        Purpose: Method copies BET attributes from DTO to actual BET record
        Parameters: - bet object, dto object
        Returns: - initiated bet object
        Throws: -
    *************************************************************/
    @TestVisible
    private uw_BET__c moveComponentDataToBET(uw_BET__c bet,BET_CategoryComponentData compData){
        System.debug('Entering moveComponentDataToBET : ' + bet + ', ' + compData);
        uw_BET__c modbet =  uw_BETUtil.moveComponentDataToBET(bet,compData);
        System.debug('Exit moveComponentDataToBET : ' + modbet);
        return modbet;
    }

    /************************************************************
        Purpose: Method validates BET record
        Parameters: Related Bet record
        Returns: List of error messages
        Throws: -
    *************************************************************/
    @TestVisible
    private List<String> validateBET(uw_BET__c betObject){
        System.debug('Entering validateBET : ' + betObject);
        List<String> errors = uw_BETUtil.validateBET(betObject,compData);
        System.debug('Exit validateBET : ' + errors);
        return errors;
    }

    /************************************************************
        Purpose: Method displays error messages
        Parameters: List of error messages
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
    private List<ApexPages.Message> displayErrors(List<String> errorsForDisplay){
        System.debug('Entering displayErrors : ' + errorsForDisplay);
        List<ApexPages.Message> displayed = new List<ApexPages.Message>();
        for(String error : errorsForDisplay){
            displayed.add(new ApexPages.Message(ApexPages.Severity.ERROR,error));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
        }
        System.debug('Exit displayErrors : ' + displayed);
        return displayed;
    }
}