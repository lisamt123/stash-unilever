/*************************************************************************************
Name : BET_BETWrapper

Purpose : Class containing all BET information required  by IPM. It will be used in all communication with 

external systems when a  notification of a change to BET data is needed.

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  20-07-2015  Initial
*************************************************************************************/

public with sharing class BET_BETWrapper {
    
    //Id of Bet
    public Id BetId{get;set;}
    //Name of Bet
    public String BetName{get;set;}
    //Bet Status
    public String Status{get;set;}
    //Date of First release
    public Date FirstReleaseDate{get;set;}
    //Due date of first release
    public Date FirstReleaseDueDate{get;set;}
    //Date of final release
    public Date FinalReleaseDate{get;set;}
    //Due date of final release
    public Date FinalReleaseDueDate{get;set;}
    //Value indicating if BET is archived
    public Boolean isArchived{get;set;}
    //Id of BET owner user
    public Id BetOwner{get;set;}
    
    
    /************************************************************
        Purpose: Class containing all information about user and access level for creation of member request.
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public class MemberRequest{
        
        //Id of User
        public Id UserId{get;set;}
        public String AccessLevel{get;set;}
    }
    
    /************************************************************
        Purpose: BET_BETWrapper constructor
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public BET_BETWrapper(Id betId){
        system.debug('Entring BET_BETWrapper constructor with param @betd:'+betId);
        
        List<uw_BET__c> betLst = [Select Id,Name,Status__c,First_release_date__c,Final_release_date__c,Is_Archived__c,OwnerID FROM uw_BET__c WHERE Id =: betId];
        
        if(!betLst.isEmpty()){
            uw_BET__c tmpBet = betLst.get(0);
            this.BetId = tmpBet.id;
            this.BetName = tmpBet.Name;
            this.Status = tmpBet.Status__c;
            this.FirstReleaseDate = tmpBet.First_release_date__c;
            //it's temporary implemnetation need to be change in next sprint
            this.FirstReleaseDueDate = tmpBet.First_release_date__c;
            this.FinalReleaseDate = tmpBet.Final_release_date__c;
            //it's temporary implemnetation need to be change in next sprint
            this.FinalReleaseDueDate = tmpBet.Final_release_date__c;
            this.isArchived = tmpBet.Is_Archived__c;
            this.BetOwner = tmpBet.OwnerId;

        }
        system.debug('Exiting BET_BETWrapper constructor');
    }
    
    /************************************************************
        Purpose: BET_BETWrapper constructor
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public BET_BETWrapper(){}


}