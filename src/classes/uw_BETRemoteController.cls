/**********************************************************************
Name: uw_BETRemoteController
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class is a wrapper which keeps all wrapper classes for all remote actions called from Bet 
application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             26/11/2014      INITIAL DEVELOPMENT
**********************************************************************/

public with sharing class uw_BETRemoteController {
    /**
     * Prefix to uw_BET__c object. It isused to redirect user to create new BET page
     */
    public String betPrefix {get; protected set;}
    /**
     * Boolean flag set based on user profile. If true, user has readonly access to all bets
     */
    public String hasReadAll {get; protected set;}
    /**
     * Boolean flag set based on user profile. If true, user has read/write access to all bets
     */
    public String hasModifyAll {get; protected set;}
    /**
     * If set, application will automaticallu load BET detail page instead of home page
     */
    public String newBetId {get; protected set;}
    /**
     * Link to BET help page
     */
    public String helpLink {get; protected set;}
    /**
     * Link to BET template file
     */
    public String BETTemplateLink {get; protected set;}

    /**
    *Boolean flag indicates if user is bet operation admin
    */
    public String betOperationAdmin {get; protected set;}

    /**
    * Home page ipm integration information
    */
    public String homeInfoText {get; protected set;}

    /**
    *Boolean flag indicates if expected assets are provided
    */
    public String expectedAssetsProvided {get; protected set;} 

    /*******************************************************************
    Purpose: class constructor
    ********************************************************************/
    public uw_BETRemoteController() {
        init();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    }
    /*******************************************************************
    Purpose: class constructor
    ********************************************************************/
    public uw_BETRemoteController(ApexPages.StandardController sc) {
        newBetId = sc.getId();
        init();
    }
    /*******************************************************************
    Purpose: initialize application variables
    ********************************************************************/
    private void init() {
        betPrefix = uw_BET__c.SObjectType.getDescribe().getKeyPrefix();
        hasReadAll = BET_CommonService.hasAccess(true) ? 'true' : 'false';
        hasModifyAll = BET_CommonService.hasAccess(false) ? 'true' : 'false';

        Boolean isHubAdmin = BET_CommonService.isHubAdmin();
        Boolean isBetOwnerOrManager = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(newBetId, UserInfo.getUserId());

        betOperationAdmin = BET_CommonService.isBETOperationAdmin() && !isHubAdmin && !isBetOwnerOrManager ? 'true' : 'false';
        expectedAssetsProvided = BET_AssetService.expectedAssetsSetForBet(newBetId) ? 'true' : 'false';

        if (newBetId == null) {
            newBetId = '';
        }
        BETTemplateLink = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.BET_TEMPALTE_DOWNLOAD_URL, '');
        helpLink = uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.BET_HELP_URL, '');
        String groupId = BET_Settings__c.getOrgDefaults().HelpChatterGroupId__c == null ? '' : (String)BET_Settings__c.getOrgDefaults().HelpChatterGroupId__c;
        homeInfoText = String.format(Label.BET_Home_Page_Info,new List<String>{groupId,Label.BET_Help_Group_Name});

    }
    /*******************************************************************
    Purpose: Method returns list of BET Owned by current logged in user
    or list of BET that current logged in user has access to
    Parameters: [optional]
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getMyBETs(){
        return uw_BETSearchService.getMyBETs();
    }

    /*******************************************************************
    Purpose: Search engine method resposible for returning applicable bets
    Parameters: [String brandId, String categoryId, String keyWord, Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper search(String brandId, String categoryId, String keyWord, Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            uw_BETWrapper.SearchWrapper results = uw_BETSearchService.search(brandId, categoryId, keyWord, pageSize, pageNumber, withFilters, sortAsc, sortField);
            
            resultMap.put('bets', results.betSearchResult);
            resultMap.put('filters', results.searchFilters);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Search engine method resposible for returning applicable bets
    Parameters: [String brandId, String categoryId, String keyWord, Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper searchActiveAndArchived(String brandId, String categoryId, String keyWord, Integer pageSize,Integer pageNumber,Boolean withFilters, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            uw_BETWrapper.SearchWrapper resultsActive = uw_BETSearchService.searchActive(brandId, categoryId, keyWord, pageSize, pageNumber, withFilters, sortAsc, sortField);
            uw_BETWrapper.SearchWrapper resultsArchived = uw_BETSearchService.searchArchived(brandId, categoryId, keyWord, pageSize, pageNumber, withFilters, sortAsc, sortField);
            resultMap.put('betsActive', resultsActive.betSearchResult);
            resultMap.put('betsArchived', resultsArchived.betSearchResult);
            resultMap.put('filters', resultsActive.searchFilters);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Search engine method resposible for request for access to BET
    Parameters: [String betId] 
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper requestBETAccess(String betId){
        Id currentUserId = UserInfo.getUserId();
        String currentUserEmail = UserInfo.getUserEmail();

        try{
            Boolean result = BET_CommonService.requestBETAccess(currentUserId, betId, currentUserEmail);

            if(result){
                return new uw_BETWrapper('Request Access is send', '0', null,''); 
            }else{
                return new uw_BETWrapper('Request Access is already send', '-2', null,''); 
            }
        }catch(Exception ex){
            return new uw_BETWrapper('Request Access is not send ' +ex.getMessage(), '-1', null,'');
        }
    }

    /*******************************************************************
    Purpose: Search engine method resposible for request for access to BET
    Parameters: [String betId] 
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper removeMeFromBET(String betId){
        Id currentUserId = UserInfo.getUserId();
        String currentUserEmail = UserInfo.getUserEmail();

        try{
            BET_CommonService.deleteBetTeamMember(currentUserId, betId);
            return new uw_BETWrapper('Member is deleted', '0', null,''); 
        }catch(Exception ex){
            return new uw_BETWrapper('Member is not deleted:' +ex.getMessage(), '-1', null,'');
        }
    }

    /*******************************************************************
    Purpose: Method resposible for request for detail page for BET
    Parameters: [String betId] 
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getBETDetails(String betId){
        Id currentUserId = UserInfo.getUserId();
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            
            BET_AssetService.forceAssetReordering(betId);

            uw_BETWrapper.DetailWrapper results = uw_BETDetailService.getBETDetails(betId, currentUserId);
            if(results.bet.betIPMProjectId != null) {
                results.bet.currentUserHasAccessToIPM = IPM_BETUpdateService.UserAccess((Id)betId, results.bet.betIPMProjectId,currentUserId);
            }

            results.bet.expectedAssetsProvided = BET_AssetService.expectedAssetsSetForBet(betId);

            Boolean assetPrioritySet = false;
            for(uw_Asset__c asset : [select Order_Of_Display__c from uw_Asset__c where uw_Bet__c =: betId]){
                if(asset.Order_Of_Display__c != null){
                    assetPrioritySet = true;
                } else {
                    assetPrioritySet = false;
                    break;
                }
            } 

            results.bet.assetPrioritySet = assetPrioritySet;

            System.debug('results.bet.expectedAssetsProvided ' + results.bet.expectedAssetsProvided);

            if(results.bet.betIPMProjectId != null && results.bet.betIPMProjectName == null){
                IPM_BETWrapper ipmwrap =  IPM_BETUpdateService.ipm_Wrapper((Id)results.bet.betIPMProjectId);
                results.bet.betIPMProjectName = ipmwrap.projectName;
            }

            resultMap.put('bet', results.bet);
            resultMap.put('members', results.memberSetting);
            return new uw_BETWrapper('Result', '0', resultMap,'');        
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
    }

    /*******************************************************************
    Purpose: Method resposible for returning Brand Development assets for bet
    Parameters: [String betId, String mediaType, String country]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getBETBDAssets(String betId, String mediaType, String countryName, Integer pageSize,Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            uw_BETWrapper.AssetWrapper results = uw_BETDetailService.getBETAssets(betId, mediaType, countryName, 'Brand Development', pageSize, pageNumber, withFilters, sortAsc, sortField);
            
            resultMap.put('assets', results.assetResult);
            resultMap.put('filters', results.searchFilters);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Method resposible for returning draft assets for bet
    Parameters: [String betId, String mediaType, String country]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getBETDraftAssets(String betId, String mediaType, String countryName, Integer pageSize,Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            uw_BETWrapper.AssetWrapper results = uw_BETDetailService.getBETAssets(betId, mediaType, countryName, 'Draft', pageSize, pageNumber, withFilters, sortAsc, sortField);
            
            resultMap.put('assets', results.assetResult);
            resultMap.put('filters', results.searchFilters);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Method resposible for returning Brand Building assets for bet
    Parameters: [String betId, String mediaType, String country]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getBETBBAssets(String betId, String mediaType, String countryName, Integer pageSize,Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            uw_BETWrapper.AssetWrapper results = uw_BETDetailService.getBETAssets(betId, mediaType, countryName, 'Brand Building', pageSize, pageNumber, withFilters, sortAsc, sortField);
            
            resultMap.put('assets', results.assetResult);
            resultMap.put('filters', results.searchFilters);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Method resposible for returning approved assets for bet
    Parameters: [String betId, String mediaType, String country]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getBETAssets(String betId, String mediaType, String countryName, String subFunctionType, Integer pageSize,Integer pageNumber, Boolean withFilters, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            uw_BETWrapper.AssetWrapper results = uw_BETDetailService.getBETAssets(betId, mediaType, countryName, subFunctionType, pageSize, pageNumber, withFilters, sortAsc, sortField);
            
            resultMap.put('assets', results.assetResult);
            resultMap.put('filters', results.searchFilters);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Search engine method resposible for request for access to BET
    Parameters: [String betId] 
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper deleteBETAsset(String betId, String assetId){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            Boolean result = uw_BETDetailService.deleteBETAsset(betId, assetId);
            resultMap.put('refreshPresentation', result);

            return new uw_BETWrapper('Asset deleted', '0', resultMap,'');     
        }catch(Exception ex){
            return new uw_BETWrapper('Asset not deleted ' +ex.getMessage(), '-1', null,'');
        }
    }

    /*******************************************************************
    Purpose: Method responsible for Draft list in BET Details
    Parameters: [String betId]
    Returns: uw_BETWrapper 
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper getBETChatterFiles(String betId, Integer pageSize, Integer pageNumber, Boolean sortAsc, String sortField){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            List<uw_BETWrapper.DraftItem> results = uw_BETDetailService.getBETChatterFiles(betId, pageSize, pageNumber, sortAsc, sortField);
            
            resultMap.put('drafts', results);
        }catch(Exception ex){
            return new uw_BETWrapper(ex.getMessage(), '-1', null,'');
        }
        return new uw_BETWrapper('Results', '0', resultMap,''); 
    }

    /*******************************************************************
    Purpose: Search engine method resposible for request for access to BET
    Parameters: [String betId] 
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper chatterFileToDraftAsset(String betId, String feedId){
        Map<String, Object> resultMap = new Map<String, Object>();
        try{
            Id assetId = uw_BETDetailService.chatterFileToDraftAsset(betId, feedId);
            resultMap.put('draftAssetId', assetId);
            return new uw_BETWrapper('Asset created', '0', resultMap,''); 
        }catch(Exception ex){
            return new uw_BETWrapper('Asset not created ' +ex.getMessage(), '-1', resultMap,'');
        }
    }

    /*******************************************************************
    Purpose: Search engine method resposible for request for access to BET
    Parameters: [String betId] 
    Returns: uw_BETWrapper
    ********************************************************************/
    @RemoteAction
    public static uw_BETWrapper deleteChatterFileDraft(String feedId){
        try{
            uw_BETDetailService.deleteChatterFileDraft(feedId);
            return new uw_BETWrapper('Feed deleted', '0', null,''); 
        }catch(Exception ex){
            return new uw_BETWrapper('Feed not deleted ' +ex.getMessage(), '-1', null,'');
        }
    }
}