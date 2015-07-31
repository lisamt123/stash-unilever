/*************************************************************************************
Name : BET_BETService

Purpose : Service for BET

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  30-07-2015  Initial
*************************************************************************************/

public with sharing class BET_BETService {
    
    /************************************************************
        Purpose: Return data for given BET (BET_BETWrapper)
        Parameters: -
        Returns: 
        Throws: -
    *************************************************************/
    public static BET_BETWrapper GetBet(Id betd){
        system.debug('Entring BET_BETService.GetBet with param @betd:'+betd);
        BET_BETWrapper betWrapper = new BET_BETWrapper();
        if(betd == null){
            return betWrapper;
        }
        
        List<uw_BET__c> betLst = [Select Id,Name,Status__c,First_release_date__c,Final_release_date__c,Is_Archived__c,OwnerID FROM uw_BET__c WHERE Id =: betd];
        
        if(!betLst.isEmpty()){
            uw_BET__c tmpBet = betLst.get(0);
            betWrapper.BetId = tmpBet.id;
            betWrapper.BetName = tmpBet.Name;
            betWrapper.Status = tmpBet.Status__c;
            betWrapper.FirstReleaseDate = tmpBet.First_release_date__c;
            //it's temporary implemnetation need to be change in next sprint
            betWrapper.FirstReleaseDueDate = tmpBet.First_release_date__c != null ? tmpBet.First_release_date__c.addYears(1) : null;
            betWrapper.FinalReleaseDate = tmpBet.Final_release_date__c;
            //it's temporary implemnetation need to be change in next sprint
            betWrapper.FinalReleaseDueDate = tmpBet.Final_release_date__c != null ? tmpBet.Final_release_date__c.addYears(1) : null;
            betWrapper.isArchived = tmpBet.Is_Archived__c;
            betWrapper.BetOwner = tmpBet.OwnerId;

        }
        
        system.debug('Exiting BET_BETService.GetBet returned folowing BET_BETWrapper: '+ betWrapper);
        
        return betWrapper;
    }

}