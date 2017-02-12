public class TPM_AccountRemoteActionExtension {

    public TPM_AccountRemoteActionExtension(ApexPages.StandardController controller) {

    }



/*
The following function is only a draft version to be used as a pattern. 
Make sure that it fits to your customization.
*/

@RemoteAction
public static List<Account> readLOAccounts (String txId, String promtionId) {
    List<Account> lAccount = new List<Account>();
    System.debug('Entering "readLOAccount" - ' + txId);
    try {
        if(promtionId != null){
        ACCL__Promotion__c currentPromotion = [select id,name,UL_Account__c,ACCL__Anchor_Account__c from ACCL__Promotion__c where id=:promtionId limit 1];
        set<id> idS = new set<id>();
            if(currentPromotion.UL_Account__c != null){
                 idS.add(currentPromotion.UL_Account__c);
            }
            if(currentPromotion.ACCL__Anchor_Account__c != null){
                 idS.add(currentPromotion.ACCL__Anchor_Account__c);
            }       
            
            for(account fetchAccount:[select id,name from account where id in:idS  LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
                lAccount.add(fetchAccount);
            }
        }
        
    } finally {
        System.debug('Leaving "readLOAccount" - ' + txId);
    }
    
    return lAccount;
} 


}