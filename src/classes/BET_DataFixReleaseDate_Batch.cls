/*************************************************************************************
Name : BET_DataFixReleaseDate

Purpose : Class responsible for update first/final due dates and set chatter file id of asset related file 
History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  20-08-2015  Initial
*************************************************************************************/
global class BET_DataFixReleaseDate_Batch implements Database.Batchable<sObject> {
    
    String query = 'Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c, (select URL_of_Asset__c, File_id__c,Related_Feed_Item__c from Assets__r where File_Id__c = null) from uw_BET__c';
    String unitTestQuery = 'Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c, (select URL_of_Asset__c, File_id__c,Related_Feed_Item__c from Assets__r where File_Id__c = null) from uw_BET__c';
    String assetQuery = 'select URL_of_Asset__c, File_id__c,Related_Feed_Item__c from uw_Asset__c where File_Id__c = null';
    
    private Boolean assetVersion = false;

    global BET_DataFixReleaseDate_Batch() {}
    
    global BET_DataFixReleaseDate_Batch(Boolean isAssetVersion) {
        assetVersion = isAssetVersion;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Entering start');
        if(assetVersion){
            return Database.getQueryLocator(assetQuery);
        } else {
            return Test.isRunningTest() ? Database.getQueryLocator(unitTestQuery) : Database.getQueryLocator(query);
        }
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('Entering execute : ' + scope);
        List<uw_BET__c> bets = new List<uw_BET__c>();
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        if(assetVersion){
            for(sObject obj : scope){
                uw_Asset__c asset = (uw_Asset__c)obj;
                assets.add(asset);
            }
            try{
                update BET_AssetService.updateFileId(assets);
                if(assets.get(0).File_Id__c == null){
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_DataFixReleaseDate_Batch','execute',
                    'File id not set : ' + assets.get(0), new BET_CustomBETException('File id not set : ' + assets.get(0)),'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
                }
            }catch(ConnectApi.ConnectApiException e){

                logException('Resource not found : execute ' + assets.get(0) + ' ' + e.getStackTraceString(),e);
            }catch(Exception e){
                logException('execute ' + assets.get(0) + ' ' + e.getStackTraceString(),e);
            }
        } else {
            for(sObject obj : scope){
                uw_BET__c bet = (uw_BET__c)obj;
                if(Test.isRunningTest() || (bet.Launch_Date__c != null && (bet.First_Release_Due_Date__c == null || bet.Final_Release_Due_Date__c == null))) {
                    bets.add(updateDates(bet));
                }
            }

            update bets;
        }
        System.debug('Exit execute : ' + bets);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Finish batch process');
    }

    global uw_BET__c updateDates(uw_BET__c bet){
        bet.Final_Release_Due_Date__c = BET_BETService.getFinalReleaseDueDate(bet.Launch_Date__c);
        bet.First_Release_Due_Date__c = BET_BETService.getFirstReleaseDueDate(bet.Launch_Date__c);
        return bet;
    }

    global void logException(String msg,Exception e){
        ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'BET_DataFixReleaseDate_Batch','execute',
        msg, e,'ERROR',null,null,(Integer)DateTime.now().getTime(),'BET');
    }
    
}