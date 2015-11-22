public with sharing class BET_UpdateBETSearchHandler {
    private static Map<Id, String> idProjectToName;
    private static Map<Id, String> idOwnerToName;
    private static Map<Id, String> idBrandToName;
    private static Map<Id, String> idCategoryToName;

    public static void beforeInsert(List<uw_BET__c> newList) {
        prepareData(newList);
        updateSearchField(newList);
    }

    public static void beforeUpdate(List<uw_BET__c> newList, Map<id, uw_BET__c> oldMap) {
        prepareData(newList, oldMap);
        updateSearchField(newList);
    }

    private static void prepareData(List<uw_BET__c> newList) {
        Set<Id> projectIds = new Set<Id>();
        Set<Id> ownersIds = new Set<Id>();
        Set<Id> brandsIds = new Set<Id>();
        Set<Id> categoriesIds = new Set<Id>();

        for (uw_BET__c b : newList) {
            projectIds.add(b.Inoplan_Project__c);
            ownersIds.add(b.OwnerId);
            brandsIds.add(b.uw_Brand__c);
            categoriesIds.add(b.Sub_Category__c);
        }

        prepareDataCommon(projectIds, ownersIds, brandsIds, categoriesIds);
    }

    private static void prepareData(List<uw_BET__c> newList, Map<id, uw_BET__c> oldMap) {
        Set<Id> projectIds = new Set<Id>();
        Set<Id> ownersIds = new Set<Id>();
        Set<Id> brandsIds = new Set<Id>();
        Set<Id> categoriesIds = new Set<Id>();

        for (uw_BET__c b : newList) {
            if (b.Inoplan_Project__c != oldMap.get(b.Id).Inoplan_Project__c) {
                projectIds.add(b.Inoplan_Project__c);
            }
            if (b.OwnerId != oldMap.get(b.Id).OwnerId) {
                ownersIds.add(b.OwnerId);
            }
            if (b.uw_Brand__c != oldMap.get(b.Id).Inoplan_Project__c) {
                brandsIds.add(b.uw_Brand__c);
            }
            if (b.Sub_Category__c != oldMap.get(b.Id).Sub_Category__c) {
                categoriesIds.add(b.Sub_Category__c);
            }
        }

        prepareDataCommon(projectIds, ownersIds, brandsIds, categoriesIds);        
    }

    private static void prepareDataCommon(Set<Id> projectIds, Set<Id> ownersIds, Set<Id> brandsIds, Set<Id> categoriesIds) {
        idProjectToName = new Map<Id, String>();
        idOwnerToName = new Map<Id, String>();
        idBrandToName = new Map<Id, String>();
        idCategoryToName = new Map<Id, String>();

        if (!projectIds.isEmpty()) {
            List<uw_Inoplan_Project__c> infoplanProjects = [SELECT Id, Name FROM uw_Inoplan_Project__c WHERE Id IN :projectIds];
            for(uw_Inoplan_Project__c proj : infoplanProjects){
                idProjectToName.put(proj.Id, proj.Name);
            }
        }        

        if (!ownersIds.isEmpty()) {
            List<User> owners = [SELECT Id, Name FROM User WHERE Id IN :ownersIds];
            for(User usr : owners){
                idOwnerToName.put(usr.Id, usr.Name);
            }
        }

        if (!brandsIds.isEmpty()) {
            List<uw_Brand__c> brands = [SELECT Id, Name FROM uw_Brand__c WHERE Id IN :brandsIds];
            for(uw_Brand__c brand : brands){
                idBrandToName.put(brand.Id, brand.Name);
            }
        }

        if (!categoriesIds.isEmpty()) {
            List<BET_Category__c> categories = [SELECT Id, Name FROM BET_Category__c WHERE Id IN :categoriesIds];
            for(BET_Category__c cat : categories){
                idCategoryToName.put(cat.Id, cat.Name);
            }
        }
    }

    private static void updateSearchField(List<uw_BET__c> newList) {
        for(uw_BET__c b : newList){         
            if(idProjectToName.containsKey(b.Inoplan_Project__c)){
                b.Inoplan_Project_Keyword_Search__c = idProjectToName.get(b.Inoplan_Project__c);
            }
            if(idOwnerToName.containsKey(b.OwnerId)){
                b.Owner_Keyword_Search__c = idOwnerToName.get(b.OwnerId);
            }
            if(idBrandToName.containsKey(b.uw_Brand__c)){
                b.Brand_Keyword_Search__c = idBrandToName.get(b.uw_Brand__c);
            }
            if(idCategoryToName.containsKey(b.Sub_Category__c)){
                b.Category_Keyword_Search__c = idCategoryToName.get(b.Sub_Category__c);
            }
        }        
    }
}