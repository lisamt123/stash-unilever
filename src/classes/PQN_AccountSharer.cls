/*

 * Helper class for creating Apex sharing on Account records 

 * 
 **/
public with sharing class PQN_AccountSharer {
    
    /*
     * Shares the Account records on the AccountsIds list with the user in the userId parameter for readwrite acces.
     * @param userId Id of the User the records will be shared with
     * @param accountsIDs ids of the Accounts being shared
     * @return 
     **/ 
    public void shareAccountsReadOnly(Id userId, Set<Id> accountsIds){
        List<AccountShare> accShares = new List<AccountShare>();
        //List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
        for(Id accountId: accountsIds){
         /*   AccountTeamMember atm = new AccountTeamMember();
            atm.accountId = accountId;
            atm.UserId = userId;
            atm.accountAccessLevel = 'Read';
            atm.OpportunityAccessLevel = 'None';
            atm.CaseAccessLevel = 'None';
            accountTeamMembers.add(atm);
                */
            AccountShare accShare = new AccountShare();
            accShare.AccountAccessLevel = 'Edit';
            accShare.OpportunityAccessLevel = 'None';
            accShare.CaseAccessLevel = 'None';
            accShare.AccountId = accountId;
            accShare.UserOrGroupId = userId;

            accShares.add(accShare);
            
        }
        insert accShares;
    }
}