public with sharing class BET_UpdateBETSearchHandler {
    private static Map<Id, String> idIPMProjectToName;
    private static Map<Id, String> idProjectToName;
    private static Map<Id, String> idOwnerToName;
    private static Map<Id, String> idBrandToName;
    private static Map<Id, String> idCategoryToName;
    private static Map<Id, String> idCategoryGroupToName;
    private static Map<Id, String> idBrandPositionToName;

    private BET_UpdateBETSearchHandler(){}

    public static void beforeInsert(List<uw_BET__c> newList) {
        prepareData(newList);
        updateSearchField(newList);
    }

    public static void beforeUpdate(List<uw_BET__c> newList, Map<id, uw_BET__c> oldMap) {
        prepareData(newList, oldMap);
        updateSearchField(newList);
    }

    private static void prepareData(List<uw_BET__c> newList) {
        Set<Id> projectIPMIds = new Set<Id>();
        Set<Id> projectIds = new Set<Id>();
        Set<Id> ownersIds = new Set<Id>();
        Set<Id> brandsIds = new Set<Id>();
        Set<Id> categoriesIds = new Set<Id>();
        Set<Id> categoriesGroupsIds = new Set<Id>();
        Set<Id> brandPositionsIds = new Set<Id>();

        for (uw_BET__c b : newList) {
            projectIPMIds.add(b.IPM_Project__c);
            projectIds.add(b.Inoplan_Project__c);
            ownersIds.add(b.OwnerId);
            brandsIds.add(b.Product_Brand__c);
            categoriesIds.add(b.Product_Category__c);
            categoriesGroupsIds.add(b.Category_Group__c);
            brandPositionsIds.add(b.Brand_Position__c);
        }

        prepareDataCommon(projectIPMIds,projectIds, ownersIds, brandsIds, categoriesIds,categoriesGroupsIds,brandPositionsIds);
    }

    private static void prepareData(List<uw_BET__c> newList, Map<id, uw_BET__c> oldMap) {
        Set<Id> projectIPMIds = new Set<Id>();
        Set<Id> projectIds = new Set<Id>();
        Set<Id> ownersIds = new Set<Id>();
        Set<Id> brandsIds = new Set<Id>();
        Set<Id> categoriesIds = new Set<Id>();
        Set<Id> categoriesGroupsIds = new Set<Id>();
        Set<Id> brandPositionsIds = new Set<Id>();

        for (uw_BET__c b : newList) {
            if (b.IPM_Project__c != oldMap.get(b.Id).IPM_Project__c) {
                projectIPMIds.add(b.IPM_Project__c);
            }
            if (b.Inoplan_Project__c != oldMap.get(b.Id).Inoplan_Project__c) {
                projectIds.add(b.Inoplan_Project__c);
            }
            if (b.OwnerId != oldMap.get(b.Id).OwnerId) {
                ownersIds.add(b.OwnerId);
            }
            if (b.Product_Brand__c != oldMap.get(b.Id).Product_Brand__c) {
                brandsIds.add(b.Product_Brand__c);
            }
            if (b.Product_Category__c != oldMap.get(b.Id).Product_Category__c) {
                categoriesIds.add(b.Product_Category__c);
            }
            if (b.Category_Group__c != oldMap.get(b.Id).Category_Group__c) {
                categoriesGroupsIds.add(b.Category_Group__c);
            }
            if (b.Brand_Position__c != oldMap.get(b.Id).Brand_Position__c) {
                brandPositionsIds.add(b.Brand_Position__c);
            }
        }

        prepareDataCommon(projectIPMIds,projectIds, ownersIds, brandsIds, categoriesIds,categoriesGroupsIds,brandPositionsIds);        
    }

    private static void prepareDataCommon(Set<Id> projectIPMIds, Set<Id> projectIds, Set<Id> ownersIds, Set<Id> brandsIds, Set<Id> categoriesIds,Set<Id> categoriesGroupsIds,Set<Id> brandPositionsIds) {
        idIPMProjectToName = new Map<Id, String>();
        idProjectToName = new Map<Id, String>();
        idOwnerToName = new Map<Id, String>();
        idBrandToName = new Map<Id, String>();
        idCategoryToName = new Map<Id, String>();
        idCategoryGroupToName = new Map<Id, String>();
        idBrandPositionToName = new Map<Id, String>();

        prepareProjectData(projectIPMIds,projectIds);      

        if (!ownersIds.isEmpty()) {
            List<User> owners = [SELECT Id, Name FROM User WHERE Id IN :ownersIds];
            for(User usr : owners){
                idOwnerToName.put(usr.Id, usr.Name);
            }
        }
        
        prepareCategoryBrandData(brandsIds,categoriesIds,categoriesGroupsIds,brandPositionsIds);
    }
    
    private static void prepareProjectData(Set<Id> projectIPMIds, Set<Id> projectIds){
    	if (!projectIPMIds.isEmpty()) {
            List<IPM_Project__c> ipmProjects = [SELECT Id, Name FROM IPM_Project__c WHERE Id IN :projectIPMIds];
            for(IPM_Project__c proj : ipmProjects){
                idIPMProjectToName.put(proj.Id, proj.Name);
            }
        }  

        if (!projectIds.isEmpty()) {
            List<uw_Inoplan_Project__c> infoplanProjects = [SELECT Id, Name FROM uw_Inoplan_Project__c WHERE Id IN :projectIds];
            for(uw_Inoplan_Project__c proj : infoplanProjects){
                idProjectToName.put(proj.Id, proj.Name);
            }
        }
    }
    
    private static void prepareCategoryBrandData(Set<Id> brandsIds, Set<Id> categoriesIds,Set<Id> categoriesGroupsIds,Set<Id> brandPositionsIds){
        if (!brandsIds.isEmpty()) {
            List<MDO_Brand__c> brands = [SELECT Id, Name FROM MDO_Brand__c WHERE Id IN :brandsIds];
            for(MDO_Brand__c brand : brands){
                idBrandToName.put(brand.Id, brand.Name);
            }
        }

        if (!categoriesIds.isEmpty()) {
            List<MDO_Category__c> categories = [SELECT Id, Name FROM MDO_Category__c WHERE Id IN :categoriesIds];
            for(MDO_Category__c cat : categories){
                idCategoryToName.put(cat.Id, cat.Name);
            }
        }

        if (!categoriesGroupsIds.isEmpty()) {
            List<MDO_Category__c> categories = [SELECT Id, Name FROM MDO_Category__c WHERE Id IN :categoriesGroupsIds];
            for(MDO_Category__c cat : categories){
                idCategoryGroupToName.put(cat.Id, cat.Name);
            }
        }

        if(!brandPositionsIds.isEmpty()) {
            List<MDO_BrandPosition__c> brandPositions = [SELECT Id, Name FROM MDO_BrandPosition__c WHERE Id IN :brandPositionsIds];
            for(MDO_BrandPosition__c brandPosition : brandPositions){
                idBrandPositionToName.put(brandPosition.Id, brandPosition.Name);
            }
        }
    }

    private static void updateSearchField(List<uw_BET__c> newList) {
        for(uw_BET__c b : newList){
            if(idProjectToName.containsKey(b.Inoplan_Project__c)){
                b.Inoplan_Project_Keyword_Search__c = idProjectToName.get(b.Inoplan_Project__c);
            }
            if(idIPMProjectToName.containsKey(b.IPM_Project__c)){
                b.Inoplan_Project_Keyword_Search__c = idIPMProjectToName.get(b.IPM_Project__c);
            }
            if(idOwnerToName.containsKey(b.OwnerId)){
                b.Owner_Keyword_Search__c = idOwnerToName.get(b.OwnerId);
            }
            if(idBrandToName.containsKey(b.Product_Brand__c)){
                b.Brand_Keyword_Search__c = idBrandToName.get(b.Product_Brand__c);
            }
            if(idCategoryToName.containsKey(b.Product_Category__c)){
                b.Category_Keyword_Search__c = idCategoryToName.get(b.Product_Category__c);
            }
            if(idCategoryGroupToName.containsKey(b.Category_Group__c)){
                b.Category_Group_Keyword_Search__c = idCategoryGroupToName.get(b.Category_Group__c);
            }
            if(idBrandPositionToName.containsKey(b.Brand_Position__c)){
                b.Brand_Position_Keyword_Search__c = idBrandPositionToName.get(b.Brand_Position__c);
            }
        }        
    }
}