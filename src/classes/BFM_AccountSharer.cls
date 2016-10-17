/*
 * BFM_AccountSharer
 * Helper class for creating Apex sharing on Account records 
 * Creation Date: 2016/07/27
 * Author: Zanquini, Vinicius
 * 
 **/
public without sharing class BFM_AccountSharer {
    
    /*
     * Shares the Account records on the AccountsIds list with the user in the userId parameter for read-only acces.
     * @param userId Id of the User the records will be shared with
     * @param accountsIDs ids of the Accounts being shared
     * @return 
     **/ 
    public void shareAccountsReadOnly(Id userId, Set<Id> accountsIds){
        List<AccountShare> accShares = new List<AccountShare>();
        for(Id accountId: accountsIds){
            AccountShare accShare = new AccountShare();
            accShare.AccountAccessLevel = 'Read';
            accShare.OpportunityAccessLevel = 'None';
            accShare.CaseAccessLevel = 'None';
            accShare.AccountId = accountId;
            accShare.UserOrGroupId = userId;
            accShares.add(accShare);
        }
        insert accShares;
    }
}