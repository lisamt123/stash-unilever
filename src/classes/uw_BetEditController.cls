/**********************************************************************
Name: uw_BetEditController 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for editing BETs
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
1.1 -   Nikhil Mishra           17/06/2015      T0- method addded to close the settings page on cancel button click 
**********************************************************************/
public with sharing class uw_BetEditController {
    @TestVisible private Integer throwUTException;
    @TestVisible public class BetException extends Exception {}

    public uw_BET__c bet {get; set;}
    public Document banner {get;set;}
    public Document icon {get;set;}
    public Id currentId{get;set;}
    public Boolean runJsSuccess{get;set;}
    public Boolean moveHome{get; protected set;}

    public String tabInFocus{get;set;}

    private String initialOwnerId {get; set;}
    private uw_BET__Share initialBETShare {get {
        if (initialBETShare == null) {
            List<uw_BET__Share> betShares = [SELECT userOrGroupId FROM uw_BET__Share WHERE parentId=:bet.Id AND RowCause='Owner'];
            if (!uw_HelperMethods.listIsNull(betShares)) {
                initialBETShare = betShares[0];
            }
        }
        return initialBETShare;
    } set;}

    public Boolean showClearBanner{get;set;}
    public Boolean showClearIcon{get;set;}

    public BET_CategoryComponentData compData {get;set;}

    public Boolean currentUserIsOwner {get;set;}

    /*****************************************************************************************
    Purpose: Constructor 
    ******************************************************************************************/  
    public uw_BetEditController(ApexPages.StandardController stdController){
        System.debug(stdController);
        throwUTException = 0;

        runJsSuccess = false;
        moveHome = false;
        currentId = System.currentPageReference().getParameters().get('Id');
        tabInFocus = System.currentPageReference().getParameters().get('activeTab') == null ? 'name1' : (String)System.currentPageReference().getParameters().get('activeTab');
        Boolean categoryMigrated = null;
        Boolean categoryNotMigrated = null;

        banner = new Document(); 
        icon = new Document(); 
        

        bet = [ SELECT Id, Name, Inoplan_Project__c, uw_Brand__c, Category__c, Sub_Category__c, Scope__c, Market_Clusters__c,
                        Launch_Date__c, Sharing__c, Description__c, Banner_1_Location__c, Background_Colour__c, Icon_Location__c, OwnerId,
                        Font_Colour__c, Banner_Colour__c, Component_Colour__c, Is_Archived__c, Studio_Chatter_Group__c,
                        Category_Group__c, IPM_Project__c,IPM_Project__r.name,Brand_Position__c, Product_Category__c,Product_Brand__c,Inherit_Branding__c FROM uw_BET__c WHERE Id = :currentId ];

        initialOwnerId = initialBETShare.UserOrGroupId;

        categoryMigrated = IPM_BETUpdateService.CategoryCheck(bet.Product_Category__c);
        categoryNotMigrated = !categoryMigrated;

        compData = new BET_CategoryComponentData(bet);
        compData.categoryMigrated = categoryMigrated;
        compData.categoryNotMigrated = categoryNotMigrated;

        if(bet.Banner_1_Location__c == null){
            showClearBanner = false;
        }else{
            showClearBanner = true;
        }

        if(bet.Icon_Location__c == null){
            showClearIcon = false;               
        }else{
            showClearIcon = true;               
        }

        currentUserIsOwner = BET_SuggestedMemberService.checkIfUserIsManagerOrOwnerOfBet(bet.id, UserInfo.getUserId());
    } 

    /*****************************************************************************************
    Purpose: Saves documents in db
    Parameters: Document
    Returns: Id
    ******************************************************************************************/  
    public Id saveDocument(Document documentToSave){
        if (documentToSave == null || documentToSave.name == null || documentToSave.body == null){
             return null;
        }else{
            try{
                Database.Saveresult result;
                if (Test.isRunningTest() && throwUTException == 2) {
                    Document documentToSaveTest = null;
                    Database.insert(documentToSaveTest, false);
                }  

                result = Database.insert(documentToSave, false);

                if (result.isSuccess()){
                    return documentToSave.Id;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error attaching image '+result.getErrors()[0].getMessage()));
                    return null;
                }
            
            } catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception attaching image '+e));
                return null;
            }
        }
    }

    private void doClearBanner(){
        if(!showClearBanner){
            if(bet.Banner_1_Location__c != null){
                List<Document> bannerList = [SELECT Id FROM Document WHERE Id =:bet.Banner_1_Location__c];
                if(!bannerList.isEmpty()){
                    delete bannerList[0];
                }
            }
            bet.Banner_1_Location__c = null;
        } 
    }

    private void doSaveBanner(Id userId,Folder currentfolder){
        if(banner != null && banner.body != null){
            banner.folderId = currentfolder.ID;  
            banner.AuthorId = userId;
            Id bannerId = saveDocument(banner);
            bet.Banner_1_Location__c = bannerId;
            showClearBanner = true;
        } 
    }

    private void doClearIcon(){
        if(!showClearIcon){
            if(bet.Icon_Location__c != null){
                List<Document> iconList = [SELECT Id FROM Document WHERE Id =:bet.Icon_Location__c];
                if(!iconList.isEmpty()){
                    delete iconList[0];
                }
            }
            bet.Icon_Location__c = null;
        }
    }

    private void doSaveIcon(Id userId,Folder currentfolder){
        if(icon != null && icon.body != null){
            icon.folderId = currentfolder.ID;  
            icon.AuthorId = userId;
            Id iconId = saveDocument(icon);
            bet.Icon_Location__c = iconId;
            showClearIcon = true;
        }    
    }

    private void initialOwnerMatches(){
        compData.categoryMigrated = IPM_BETUpdateService.CategoryCheck(compData.category);
        bet = moveComponentDataToBET(bet,compData);
        List<String> errorMessages = validateBET(bet);
        if(errorMessages.isEmpty()){
            update bet;   
        } else {
            displayErrors(errorMessages);
        }
    }

    private void initialOwnerDoesNotMatch(){
        update bet;                     
        if (Test.isRunningTest() && throwUTException == 1) {
            throw new BetException('Exception');
        }                                                       
        uw_OwnerUpdate ou = new uw_OwnerUpdate();
        ou.addInitialSharersAsStandard(bet, bet.ownerId, bet.Id);
        ou.updateCollaborationOwner(bet, initialOwnerId, bet.ownerId);            
        banner = new Document();    
        icon = new Document();          
        runJsSuccess = true;
    }

    /*****************************************************************************************
    Purpose: Saves bets and their documents
    Returns: PageReference
    ******************************************************************************************/  
    public PageReference saveBET(){
        runJsSuccess = false;
        moveHome = false;
        try{
            //start transaction
            Id userId = UserInfo.getUserId();
            Folder currentfolder = [select Id,name from Folder where Name = 'BET Branding'];

            if (Test.isRunningTest() && throwUTException == 2) {
                delete bet;
            }  

            doClearBanner();
            doClearIcon();
            doSaveIcon(userId,currentfolder);
            doSaveBanner(userId,currentfolder);

            if (bet.ownerId == initialOwnerId) {
                initialOwnerMatches();
            } else {
                Savepoint sp = Database.setSavepoint();
                try {                   
                    compData.categoryMigrated = IPM_BETUpdateService.CategoryCheck(compData.category);
                    bet = moveComponentDataToBET(bet,compData);
                    List<String> errorMessages = validateBET(bet);
                    if(errorMessages.isEmpty()){
                        initialOwnerDoesNotMatch();
                        return null;
                    } else {
                        displayErrors(errorMessages);
                    }
                }catch (Exception e) {
                    System.Debug('Problem with BET Owner change' + e.getMessage()); 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Problem with BET Owner change' + e.getMessage()));
                    Database.rollback(sp);
                    return null;
                }
            }

            
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving record '+e));
            return null;
        }
      
        banner = new Document();    
        icon = new Document();
        
        runJsSuccess = true;

        return null;
    }

    /************************************************************
        Purpose: Method copies BET attributes from DTO to actual BET record
        Parameters: - bet object, dto object
        Returns: - initiated bet object
        Throws: -
    *************************************************************/
    @TestVisible
    private uw_BET__c moveComponentDataToBET(uw_BET__c bet,BET_CategoryComponentData compData){
        return uw_BETUtil.moveComponentDataToBET(bet,compData);
    }

    /************************************************************
        Purpose: Method validates BET record
        Parameters: Related Bet record
        Returns: List of error messages
        Throws: -
    *************************************************************/
    @TestVisible
    private List<String> validateBET(uw_BET__c betObject){
        return uw_BETUtil.validateBET(betObject,compData.categoryMigrated);
    }

    /************************************************************
        Purpose: Method displays error messages
        Parameters: List of error messages
        Returns: -
        Throws: -
    *************************************************************/
    @TestVisible
    private void displayErrors(List<String> errorsForDisplay){
        for(String error : errorsForDisplay){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
        }
    }

    /*****************************************************************************************
    Purpose: Method for archiving BET
    Returns: PageReference
    ******************************************************************************************/  
    public PageReference archiveBET(){
        runJsSuccess = false;
        moveHome = false;
        try{
            uw_BET__c b = [SELECT Id FROM uw_BET__c WHERE Id =: bet.Id LIMIT 1];
            b.Is_Archived__c = true;            
            update b;            
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving record '+e));
            return null;
        }
      
        banner = new Document();    
        icon = new Document();
        
        runJsSuccess = true;
        moveHome = true;

        return null;
    }
    /*****************************************************************************************
    Purpose: Remove icon image from fronted
    ******************************************************************************************/  
    public void cancelBET(){
        runJsSuccess = true;
    }
    /*****************************************************************************************
    Purpose: Remove icon image from fronted
    ******************************************************************************************/  
    public void clearIcon(){
        showClearIcon = false;
    }
    /*****************************************************************************************
    Purpose: Remove banner image from fronted
    ******************************************************************************************/  
    public void clearBanner(){
        showClearBanner = false;
    }

    public Boolean getHasProjectsToApprove(){
        List<BET_Follow_Request__c> followRequests = [select Project_Name__c,Project_Id__c,Project_Lead__r.name,CreatedDate from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: bet.id and Status__c =: BET_LinkingService.FOLLOW_STATUS_NEW limit 1];
        return !followRequests.isEmpty();
    }
}