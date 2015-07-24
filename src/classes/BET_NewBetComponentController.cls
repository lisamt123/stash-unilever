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
        return retURL == null ? Page.BET : new PageReference(retUrl);
    }

    /************************************************************
        Purpose: Method upserts BET object
        Parameters: -
        Returns: Reference to next page
        Throws: -
    *************************************************************/

    public PageReference saveBET(){
        System.debug('Entering saveBET : ' + bet + ', ' + compData);
        try{
            proceedWithSave(false);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving BET record'+e));
        }
        return forwardUrl == null ? null : new PageReference(forwardUrl);
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
        bet = moveComponentDataToBET(bet,compData);
        List<String> errorMessages = validateBET(bet);
        if(errorMessages.isEmpty()){
            upsert bet;
            goToMemberSelection = redirectToMembersComponent;
        } else {
            displayErrors(errorMessages);
        }
    }

    /************************************************************
        Purpose: Method copies BET attributes from DTO to actual BET record
        Parameters: - bet object, dto object
        Returns: - initiated bet object
        Throws: -
    *************************************************************/
    @TestVisible
    private uw_BET__c moveComponentDataToBET(uw_BET__c bet,BET_CategoryComponentData compData){
        return uw_BETUtil.moveComponentDataToBET(bet,compData);
    }

    /************************************************************
        Purpose: Method validates BET record
        Parameters: Related Bet record
        Returns: List of error messages
        Throws: -
    *************************************************************/
    @TestVisible
    private List<String> validateBET(uw_BET__c betObject){
        return uw_BETUtil.validateBET(betObject);
    }

    /************************************************************
        Purpose: Method displays error messages
        Parameters: List of error messages
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
    private void displayErrors(List<String> errorsForDisplay){
        for(String error : errorsForDisplay){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
        }
    }
}