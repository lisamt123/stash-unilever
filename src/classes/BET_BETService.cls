/*************************************************************************************
Name : BET_BETService

Purpose : Service for BET

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  30-07-2015  Initial
1.1      piotr.czechusmki@gmail.com    04-08-2015  Add search service
1.2      m.bluj@polsource.com          17-08-2015  Add bet update and releaseduedates service
*************************************************************************************/
/* Without sharing due to it is a service class used by external system*/
public without sharing class BET_BETService {
    
    private static final Integer APRIL = 4;
    private static final Integer JUNE = 6;
    private static final Integer JULY = 7;

    private BET_BETService(){}
    
    /************************************************************
        Purpose: Search for BET by provided string
        Parameters: -
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static List<BET_BETWrapper> searchBet(String searchText, Id categoryId, String categoryMDOId){
        system.debug('Entring method SearchBet with param @searchText: '+searchText);
        List<BET_BETWrapper> retVal;
        Id catId = categoryId;
        try{
            if (catId == null && String.isNotBlank(categoryMDOId)){
                catId = getProductCategoryByMDOId(categoryMDOId).id;
            }
            retVal = convertSearchResultsToBETWrapper(
                uw_BETSearchService.search('', catId, searchText, 2000, 1, true,true, 'betName'));
        }
        catch (Exception ex){
            // All exception are cauthed and rethrow as BET_CustomBETException as per design this in only
            // one exception expected from this service method 
            system.debug('Exception catched - ' + ex.getTypeName() + ' :' + ex.getMessage());
            throw new BET_CustomBETException (ex.getMessage() + 'Stack: ' + ex.getStackTraceString(),ex);
        }
        system.debug('Exiting method SearchBet following wrapper will be returned:'+retVal);
        return retVal;
    }
    
     /************************************************************
        Purpose: Update BET with IPM information
        Parameters: -BetId,IPMProject
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static void updateBet(Id BetId,IPM_BETWrapper IPMProject){
        system.debug('Entring method Update with param @BetId: '+BetId+' @IPMProject: '+IPMProject);
        try{
            uw_BET__c relatedBet = [select id,IPM_Project__c,Launch_Date__c,Brand_Position__c,Product_Category__c,Category_Group__c,Final_Release_Due_Date__c,First_Release_Due_Date__c,Inoplan_Project_Keyword_Search__c from uw_Bet__c where id = : BetId];
            if(relatedBet.IPM_Project__c == IPMProject.projectId){
                update updateBetFields(relatedBet,IPMProject);
            }
        }catch(Exception e){
            throw new BET_CustomBETException(e.getMessage() + 'Stack: ' + e.getStackTraceString(),e);
        }
        system.debug('Exit method Update with param @BetId: '+BetId+' @IPMProject: '+IPMProject);
    }

     /************************************************************
        Purpose: Update BET with IPM information
        Parameters: uw_Bet__c relatedBet, IPM_BETWrapper IPMProject
        Returns: uw_Bet__c
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static uw_Bet__c updateBetFields(uw_Bet__c relatedBet, IPM_BETWrapper IPMProject){
        system.debug('Entring method updateBetFields with param @relatedBet: '+relatedBet+' @IPMProject: '+IPMProject);
        try{
            relatedBet.Launch_Date__c = IPMProject.targetLaunchDate;
            relatedBet.Brand_Position__c = IPMProject.brandPosition;
            relatedBet.Product_Category__c = IPMProject.categoryName;
            relatedBet.Category_Group__c = IPMProject.categoryGroupName;
            relatedBet.First_Release_Due_Date__c = getFirstReleaseDueDate(IPMProject.targetLaunchDate);
            relatedBet.Final_Release_Due_Date__c = getFinalReleaseDueDate(IPMProject.targetLaunchDate);
            relatedBet.Inoplan_Project_Keyword_Search__c = IPMProject.projectName;
            system.debug('Exit method updateBetFields with param @relatedBet: '+relatedBet);
            return relatedBet;
        }catch(Exception e){
            throw new BET_CustomBETException(e.getMessage() + 'Stack: ' + e.getStackTraceString(),e);
        }
    }
    
    /************************************************************
        Purpose: Returns first release due date based on provided TLD (Target Launch Date)
        Parameters: Date targetLaunchDate
        Returns: Calculated date
        Throws: -
    *************************************************************/
    public static Date getFirstReleaseDueDate(Date targetLaunchDate){
        system.debug('Entring method GetFirstReleaseDueDate with param @targetLaunchDate: '+targetLaunchDate);
        if(targetLaunchDate == null) {
            return null;
        } else { 
            Integer tldMonth = targetLaunchDate.month();
            Date calculatedDate = null;
            if(tldMonth < JULY){
                calculatedDate = Date.newInstance(targetLaunchDate.year() - 1, APRIL, 15);
            } else {
                calculatedDate = Date.newInstance(targetLaunchDate.year() - 1, JUNE, 30);
            }
            system.debug('Exiting method GetFirstReleaseDueDate following date was returned: ' + calculatedDate);
            return calculatedDate;
        }
    }
    
    
    /************************************************************
        Purpose: Returns final release due date based on provided TLD (Target Launch Date)
        Parameters: Date targetLaunchDate
        Returns: Calculated date
        Throws: -
    *************************************************************/
    public static Date getFinalReleaseDueDate(Date targetLaunchDate){
        system.debug('Entring method GetFinalReleaseDueDate with param @targetLaunchDate: '+targetLaunchDate);
        if(targetLaunchDate == null) {
            return null;
        } else {
            Date calculatedDate = targetLaunchDate.addMonths(-6);
            system.debug('Exiting method GetFinalReleaseDueDate following date was returned: ' + calculatedDate);
            return calculatedDate;
        }
    }
    
    /************************************************************
        Purpose: Return data for given BET (BET_BETWrapper)
        Parameters: -betId
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static BET_BETWrapper getBet(Id betId){
        system.debug('Entring BET_BETService.GetBet with param @betd:'+betId);
        BET_BETWrapper betWrapper;
        
        List<uw_BET__c> betLst = [Select Id,Name,Status__c,FirstReleaseDate__c,FinalReleaseDate__c,Final_Release_Due_Date__c,
                                    First_Release_Due_Date__c,Is_Archived__c,OwnerID,
                                    Category_Group__c, Product_Category__c, Brand_Position__c,Product_Brand__c,Launch_Date__c
                                    FROM uw_BET__c WHERE Id =: betId];
        
        if(betLst.isEmpty()){
            //bet was not found throw an error
            throw new BET_CustomBETException(String.format(Label.BetServiceGetBetError,new List<String>{betId}));
        }else{
            betWrapper = new BET_BETWrapper(betLst.get(0));
        }
        
        system.debug('Exiting BET_BETService.GetBet returned folowing BET_BETWrapper: '+ betWrapper);
        
        return betWrapper;
    }

    /************************************************************
        Purpose: Convert uw_BETWrapper.SearchWrapper to List<BET_BETWrapper>
        Parameters: -
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static List<BET_BETWrapper> convertSearchResultsToBETWrapper(uw_BETWrapper.SearchWrapper searchWrap){
        system.debug('Entring method convertSearchResultsToBETWrapper with param @searchText: '+ searchWrap);
        List<BET_BETWrapper> retVal = new List<BET_BETWrapper>();
        
        if (searchWrap != null && searchWrap.betSearchResult != null){
            for (uw_BETWrapper.BetSearchItem bsi : searchWrap.betSearchResult){
                retVal.add(new BET_BETWrapper(bsi));
            }
        }
        system.debug('Exiting method convertSearchResultsToBETWrapper following wrapper will be returned:'+retVal);
        return retVal;
    }


    /************************************************************
        Purpose: Get product Category based on external id 
        Parameters: mdoId - external id
        Returns: 
        Throws: -[BET_CustomBETException]
    *************************************************************/
    public static MDO_Category__c getProductCategoryByMDOId (String mdoId){
        system.debug('Entring method getProductCategoryByMDOId with param @mdoId: '+ mdoId);
        List<MDO_Category__c> liCategory = [select id, name, mdm_id__c from MDO_Category__c where mdm_id__c = :mdoId ];
        if (liCategory.size() != 1){
            throw new BET_CustomBETException ('Category of provided external id (mdoId=' + mdoId + ') not found');
        }

        system.debug('Exiting method getProductCategoryByMDOId with record: '+ liCategory[0]);
        return liCategory[0];
    }
}