public class DMS_CountActiveStore {
    private Set<Id> sellerUserIds = new Set<Id>();      
    private Map<String,Map<String,Set<id>>> numberStoresSeller = new Map<String,Map<String,Set<id>>>();
    private Map<Id,Id> sellerUserContact = new MAP<Id,Id>();
    
    public Map<String,Map<String,Set<id>>> countStores(Set<Id> sellerContactIds){
        
        
        for(User userId : [SELECT ID,ContactId FROM User WHERE ContactId =: sellerContactIds]){        
            sellerUserIds.add(userId.Id);
            sellerUserContact.put(userId.Id,userId.ContactId);
        }
        System.debug('valores da query user aqui!! filtro:  ' + sellerContactIds+ '  sellerUserId:  '+ sellerUserIds + '   sellerUserContact:  ' +sellerUserContact);
        for(AccountTeamMember aTeam : [SELECT id,UserId,AccountId,Account.SalesChannel__c FROM AccountTeamMember WHERE UserId =:sellerUserIds AND AccountId != null AND Account.StoreStatus__c = 'APROV']){
            Set<id> aTeamIds;
            Map<String,Set<id>> channelAteamIdsMap;
            if(numberStoresSeller.containsKey(sellerUserContact.get(aTeam.UserId))){
                if(numberStoresSeller.get(sellerUserContact.get(aTeam.UserId)).containsKey(aTeam.Account.SalesChannel__c)){
                    numberStoresSeller.get(sellerUserContact.get(aTeam.UserId)).get(aTeam.Account.SalesChannel__c).add(aTeam.Id);
                }else{
                    aTeamIds = new Set<id>();           
                    ateamIds.add(aTeam.id);
                    
                    numberStoresSeller.get(sellerUserContact.get(aTeam.UserId)).put(aTeam.Account.SalesChannel__c,ateamIds);          
                }
            }else{
                aTeamIds = new Set<id>();
                channelAteamIdsMap = new  Map<String,Set<id>>();
                ateamIds.add(aTeam.id);
                channelAteamIdsMap.put(aTeam.Account.SalesChannel__c,ateamIds);
                numberStoresSeller.put(sellerUserContact.get(aTeam.UserId),channelAteamIdsMap);
            }
        }
        return numberStoresSeller;
    }        
}