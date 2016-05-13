/**********************************************************************
Name: uw_BETSearchService
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a placeholder for all remote actions called from Bet 
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             26/11/2014      INITIAL DEVELOPMENT
1.1 -   Piotr Czechumski        05/08/2015      Add new master data, IPM project and remove archive bets from results

**********************************************************************/
/* Without sharing due to this is a service class*/
public without sharing class uw_BETSearchService {
    public class BetException extends Exception {}

    private static Map<String, String> fieldToLabel = new Map<String, String>{
        'betName'       =>  'Name',
        'betBrandName'  =>  'Product_Brand__r.Name',
        'betRegion'     =>  'Region__c',
        'betProjectName'=>  'Inoplan_Project__r.Name',
        'betStatus'     =>  'Status__c',
        'betLastUpdated'=>  'LastModifiedDate',
        'betOwnerName'  =>  'Owner.Name'
    };


    private uw_BETSearchService(){}

    /*******************************************************************
    Purpose: Method returns list of BET Owned by current logged in user
    or list of BET that current logged in user is member of
    Parameters: [optional]
    Returns: uw_BETWrapper
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static uw_BETWrapper getMyBETs(){
        Id currentUserId = UserInfo.getUserId();

        Set<Id> betsIds = new Set<Id>();
        List<uw_BET_Team_Member__c> betMember = [SELECT BET__c, Pending_Request__c FROM uw_BET_Team_Member__c WHERE Team_Member__c =:currentUserId AND Pending_Request__c != true];
        for(uw_BET_Team_Member__c m : betMember){
            betsIds.add(m.BET__c);
        }
 
        List<uw_BETWrapper.BetSearchItem> betsIamOwnerOf = new List<uw_BETWrapper.BetSearchItem>(); 
        List<uw_BETWrapper.BetSearchItem> betsIamMemberOf = new List<uw_BETWrapper.BetSearchItem>();         

        for(uw_BET__c bet: [SELECT Id, Name, Is_Archived__c, Studio_Chatter_Group__c, FinalReleaseDate__c, Presentation_Id__c, Icon_Location__c, Description__c, Product_Brand__r.Name, Region__c, Inoplan_Project__r.Name,IPM_Project__r.Name, Status__c, LastModifiedDate, Owner.Id, Owner.Name, Category_Group__c, Product_Category__c, Brand_Position__c,Brand_Position__r.name, Product_Brand__c, Inoplan_Project_Keyword_Search__c FROM uw_BET__c WHERE Id IN :betsIds and Is_Deleted__c = false ORDER BY Name]){
            Boolean betActive = ! bet.Is_Archived__c;
            if(currentUserId == bet.Owner.Id){
                betsIamOwnerOf.add(new uw_BETWrapper.BetSearchItem(bet.Id, bet.Name, bet.Studio_Chatter_Group__c, bet.FinalReleaseDate__c, bet.Presentation_Id__c, bet.Icon_Location__c, bet.Description__c, bet.Product_Brand__r.Name,bet.Region__c, bet.Inoplan_Project__r.Name,bet.IPM_Project__r.Name, bet.Status__c, bet.LastModifiedDate, bet.Owner.Name, betActive, true, true, '','','','',''));
            }else{
                betsIamMemberOf.add(new uw_BETWrapper.BetSearchItem(bet.Id, bet.Name, bet.Studio_Chatter_Group__c, bet.FinalReleaseDate__c, bet.Presentation_Id__c, bet.Icon_Location__c, bet.Description__c, bet.Product_Brand__r.Name,bet.Region__c, bet.Inoplan_Project__r.Name,bet.IPM_Project__r.Name, bet.Status__c, bet.LastModifiedDate, bet.Owner.Name, betActive, true, false, '','','','',''));
            }
        }
        
        Map<String, List<uw_BETWrapper.BetSearchItem>> betsMap = new Map<String, List<uw_BETWrapper.BetSearchItem>>();
        betsMap.put('betsIamMemberOf', betsIamMemberOf);
        betsMap.put('betsIamOwnerOf', betsIamOwnerOf);

        return new uw_BETWrapper('BETs Owned by current logged in user or BETS that current logged user is member of','0',betsMap,'');
    }

    /*******************************************************************
    Purpose: Method is helper method to search engine it's build where clauses for main search result.

    Parameters: [String brandId, String categoryName]
    Returns: [String]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    private static String buildWhereClausesForSearch(String brandId, String categoryId, Boolean active){
        //String whereClauseForBet = 'where Is_Archived__c = false AND Id != \'\'';
        String whereClauseForBet = 'where Id != \'\' AND Is_Deleted__c = false ';
        if(active != null && active){
            whereClauseForBet = 'where Id != \'\' AND Is_Deleted__c = false and Is_Archived__c = false ';
        } else if(active !=null && !active){
            whereClauseForBet = 'where Id != \'\' AND Is_Deleted__c = false and Is_Archived__c = true ';
        }

        try{
            if(brandId != null && brandId != '' ){
                Id.valueOf(brandId);             
                whereClauseForBet += ' AND Product_Brand__c = \''+brandId+'\'';
            }
            
            if(categoryId != null  && categoryId != ''){
                Id.valueOf(categoryId);
                whereClauseForBet += ' AND Product_Category__c = \''+categoryId+'\'';
            }          
        }catch(Exception ex){
            throw new BetException('Search method returns no results. Invalid parameters to build query', ex);
        }    
        
        return whereClauseForBet; 
    }

    /*******************************************************************
    Purpose: Method is helper method for search engine. Method gather all bets for search
    which meeting search criteria from bet object.
    Parameterd Description:
    
    Parameters: [String brandId, String categoryId, String keyWord, Boolean lastUpdatedSortAsc, String sortField]
    Returns: [List<uw_BET__c>]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    //private static List<uw_BET__c> gatherResultsForSearch(String brandId, String categoryId, String keyWord, Boolean lastUpdatedSortAsc){
    private static List<uw_BET__c> gatherResultsForSearch(String brandId, String categoryId, String keyWordStr, Boolean sortAsc, String sortFieldStr, Integer pageSize, Integer pageNumber, Boolean active){
        String whereClauseForBet = uw_BETSearchService.buildWhereClausesForSearch(brandId, categoryId, active);
        return buildResultsForSearch(whereClauseForBet,brandId,categoryId,keyWordStr,sortAsc, sortFieldStr, pageSize, pageNumber) ;
    }

    private static List<uw_BET__c> buildResultsForSearch(String whereClauseForBet,String brandId, String categoryId, String keyWordStr, Boolean sortAsc, String sortFieldStr, Integer pageSize, Integer pageNumber){
        Integer startIndex=pageSize*(pageNumber-1);

        String sortField;

        if( sortFieldStr != null && sortFieldStr.trim() != '' && uw_BETSearchService.fieldToLabel.containsKey(sortFieldStr.trim())){
            sortField = uw_BETSearchService.fieldToLabel.get(sortFieldStr.trim());
        }else{
            sortField = 'LastModifiedDate';
        }

        String orderDir = sortAsc ? 'ASC NULLS FIRST' : 'DESC NULLS LAST';

        //Start building final query
        Boolean isSoslQuery = false;
        String finalSoslQuery = '';
        String keyWord;
        String finalSoqlQuery = 'SELECT Id, Name, Studio_Chatter_Group__c, FirstReleaseDate__c, FinalReleaseDate__c,Final_Release_Due_Date__c,First_Release_Due_Date__c, Presentation_Id__c, Icon_Location__c, Description__c, Product_Brand__r.Name, Product_Brand__c, Region__c, Inoplan_Project__r.Name, Status__c, LastModifiedDate, Owner.Id, Owner.Name, Brand_Keyword_Search__c, Category_Keyword_Search__c, Inoplan_Project_Keyword_Search__c, Owner_Keyword_Search__c, Region_Keyword_Search__c, Banner_1_Location__c, Background_Colour__c, Banner_Colour__c, Border_Colour__c, Font_Colour__c, Sharing__c, Launch_Date__c,IPM_Project__c,IPM_Project__r.Name, Category_Group__c, Product_Category__c, Brand_Position__c,Brand_Position__r.name,Is_Archived__c,Category_Group_Keyword_Search__c,Brand_Position_Keyword_Search__c,Total_Actual_Assets__c,Total_Expected_Assets__c FROM uw_BET__c ' + whereClauseForBet + ' ORDER BY '+ sortField + ' ' + orderDir +' LIMIT '+pageSize+' OFFSET '+startIndex ;
        if(keyWordStr != null && keyWordStr !='' && keyWordStr.trim() !=''){    
            keyWord = String.escapeSingleQuotes(keyWordStr);       
            finalSoslQuery += 'FIND \''+keyWord+'*\' ';
            isSoslQuery = true;
        }

        List<uw_BET__c> betSearchList = new List<uw_BET__c>();
        if(isSoslQuery){            
            finalSoslQuery += 'IN ALL FIELDS RETURNING uw_BET__c (Id, Name, Studio_Chatter_Group__c, FirstReleaseDate__c, FinalReleaseDate__c,Final_Release_Due_Date__c,First_Release_Due_Date__c, Presentation_Id__c, Icon_Location__c, Description__c, Product_Brand__r.Name, Product_Brand__c, Region__c, Inoplan_Project__r.Name, Status__c, LastModifiedDate, Owner.Id, Owner.Name, Brand_Keyword_Search__c, Category_Keyword_Search__c, Inoplan_Project_Keyword_Search__c, Owner_Keyword_Search__c, Region_Keyword_Search__c, Banner_1_Location__c, Background_Colour__c, Banner_Colour__c, Border_Colour__c, Font_Colour__c, Sharing__c, Launch_Date__c,IPM_Project__c,IPM_Project__r.name, Category_Group__c, Product_Category__c, Brand_Position__c,Brand_Position__r.name, Is_Archived__c,Category_Group_Keyword_Search__c,Brand_Position_Keyword_Search__c,Total_Actual_Assets__c,Total_Expected_Assets__c ' + whereClauseForBet + ' ORDER BY '+ sortField + ' ' + orderDir +' LIMIT '+pageSize+' OFFSET '+startIndex+ ')';
                       
            List<List<SObject>> searchList = Search.Query(finalSoslQuery);            
            if(!searchList.isEmpty()){
                betSearchList = (List<uw_BET__c>)searchList.get(0);
            }        
        }else{
            betSearchList = Database.query(finalSoqlQuery);
        }
        
        return betSearchList;   
    }

    /*******************************************************************
    Purpose: Method is unified method for searching appropriate active bets in system.
    Parameterd Description:   
    Parameters: [String searchType, String brandId, String categoryId, String keyWord, 
    Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc, String sortField]
    Returns: [Map<String, Object>]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static uw_BETWrapper.SearchWrapper searchActive(String brandId, String categoryId, String keyWord, Integer pageSize, Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){       
        List<uw_BET__c> betsSearchList = gatherResultsForSearch(brandId, categoryId, keyWord, sortAsc, sortField, pageSize, pageNumber,true);
        return buildSearchResult(betsSearchList,brandId, categoryId,keyWord, pageSize, pageNumber, withFilters, sortAsc, sortField);
    }

    /*******************************************************************
    Purpose: Method is unified method for searching appropriate archived bets in system.
    Parameterd Description:   
    Parameters: [String searchType, String brandId, String categoryId, String keyWord, 
    Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc, String sortField]
    Returns: [Map<String, Object>]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static uw_BETWrapper.SearchWrapper searchArchived(String brandId, String categoryId, String keyWord, Integer pageSize, Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){       
        List<uw_BET__c> betsSearchList = gatherResultsForSearch(brandId, categoryId, keyWord, sortAsc, sortField, pageSize, pageNumber,false);
        return buildSearchResult(betsSearchList,brandId, categoryId,keyWord, pageSize, pageNumber, withFilters, sortAsc, sortField);
    }

    /*******************************************************************
    Purpose: Method is unified method for searching appropriate bets in system.
    Parameterd Description:   
    Parameters: [String searchType, String brandId, String categoryId, String keyWord, 
    Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc, String sortField]
    Returns: [Map<String, Object>]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static uw_BETWrapper.SearchWrapper search(String brandId, String categoryId, String keyWord, Integer pageSize, Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){       
        List<uw_BET__c> betsSearchList = gatherResultsForSearch(brandId, categoryId, keyWord, sortAsc, sortField, pageSize, pageNumber,null);
        return buildSearchResult(betsSearchList,brandId, categoryId,keyWord, pageSize, pageNumber, withFilters, sortAsc, sortField);
    }

    private static uw_BETWrapper.SearchWrapper buildSearchResult (List<uw_BET__c> betsSearchList,String brandId, String categoryId, String keyWord, Integer pageSize, Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){

        Id currentUserId = UserInfo.getUserId();

        Set<Id> allBetsIds = new Set<Id>();
        for(uw_BET__c b : betsSearchList){
            allBetsIds.add(b.Id);
        }

        Set<Id> myBetsIds = new Set<Id>();
        Set<Id> myPendingBetsIds = new Set<Id>();
        List<uw_BET_Team_Member__c> betMembers = [SELECT BET__c, Pending_Request__c FROM uw_BET_Team_Member__c WHERE Team_Member__c =:currentUserId AND BET__c IN :allBetsIds];
        for(uw_BET_Team_Member__c m : betMembers){
            if(m.Pending_Request__c){
                myPendingBetsIds.add(m.BET__c);
            }else{
                myBetsIds.add(m.BET__c);
            }
        }

        List<uw_BETWrapper.FilterLineItemWrapper> filterList =new List<uw_BETWrapper.FilterLineItemWrapper>();
        if(withFilters){
            filterList = uw_BETUtil.getFiltersForBet(brandId, categoryId);
        }

        uw_BETWrapper.SearchWrapper searchWrapper;      
        if(betsSearchList.isEmpty()){
            searchWrapper = new uw_BETWrapper.SearchWrapper(filterList,null);
        }else{
            List<uw_BETWrapper.BetSearchItem> betResultWrapper=new List<uw_BETWrapper.BetSearchItem>();
            for(uw_BET__c bet : betsSearchList){
                if(myPendingBetsIds.contains(bet.Id)){
                    betResultWrapper.add(
                        new uw_BETWrapper.BetSearchItem(bet, true, !bet.Is_Archived__c, false, false)
                    );
                } else if(myBetsIds.contains(bet.Id)){
                    betResultWrapper.add(
                        new uw_BETWrapper.BetSearchItem(bet, false, !bet.Is_Archived__c, true, false)
                    );
                }else{
                    betResultWrapper.add(
                        new uw_BETWrapper.BetSearchItem(bet, false, !bet.Is_Archived__c, false, false)
                    );
                }
            }

            //searchWrapper=new uw_BETWrapper.SearchWrapper(filterList,uw_BETUtil.getResultsForPage(betResultWrapper,pageSize,pageNumber));
            searchWrapper=new uw_BETWrapper.SearchWrapper(filterList,betResultWrapper);
        }

        return searchWrapper;
    }
}