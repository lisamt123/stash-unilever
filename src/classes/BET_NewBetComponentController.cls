/*************************************************************************************
Name : BET_NewBetComponentController

Purpose : Controller for NewBetComponent component

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
public with sharing class BET_NewBetComponentController {

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

    /************************************************************
        Purpose: Method cancels upsert operation on BET obiect
        Parameters: -
        Returns: Referece to return page
        Throws: -
    *************************************************************/

    public PageReference cancelBET(){     
        System.debug('Entering cancelBET : ' + retUrl);
        PageReference pageRef;
        if(retURL == null){
            pageRef = Page.BET;
        } else {
            pageRef = new PageReference(retUrl);
        }
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
            if(forwardUrl == null){
                pageRef = null;
            } else {
                pageRef = new PageReference(forwardUrl);
            }
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
        bet = moveComponentDataToBET(bet,compData);
        List<String> errorMessages = validateBET(bet);
        if(errorMessages.isEmpty()){
            upsert bet;
            goToMemberSelection = redirectToMembersComponent;
        } else {
            displayErrors(errorMessages);
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
        compData.categoryMigrated = IPM_BETUpdateService.CategoryCheck(bet.Product_Category__c);
        List<String> errors = uw_BETUtil.validateBET(betObject,compData.categoryMigrated);
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
    private void displayErrors(List<String> errorsForDisplay){
        System.debug('Entering displayErrors : ' + errorsForDisplay);
        for(String error : errorsForDisplay){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
        }
        System.debug('Exit displayErrors');
    }
}