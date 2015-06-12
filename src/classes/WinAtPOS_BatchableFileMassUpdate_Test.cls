/**********************************************************************
Name: WinAtPOS_BatchableFileMassUpdate_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WinAtPOS_BatchableFileMassUpdate 
and WinAtPOS_BatchFileFeedUrlUpdate
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          01/12/2014      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class WinAtPOS_BatchableFileMassUpdate_Test {
    
    /*******************************************************************
    Purpose: Helper class to create test data
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public class TestingHelper{
        public TestingHelper(){}
        
        /*******************************************************************
        Purpose: Method resposible building an string from Set<ID> for where clause 
        used for reports porpouse
        Parameters: [Set<ID> ids]
        Returns: []
        Throws [Exceptions]: [optional] 
        ********************************************************************/
        public String buildWhereClauseForSetOfIds(Set<ID> ids){
            System.Debug('*** WINatPOS buildWhereClauseForSetOfIds input parameter: ' + ids);
            String output='';
            Boolean isFirst=true;
            for(Id recordId:ids){
                if(isFirst){
                    output +='\''+recordId+'\'';
                    isFirst=false;
                }else{
                    output +=',\''+recordId+'\'';
                }
                
            }
            System.Debug('*** WINatPOS buildWhereClauseForSetOfIds returned: ' + output);
            return output;
            
        }
    }
    
    
    
    /*******************************************************************
    Purpose: Method testing batch for fileSize update
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=false)
    static  void testbatch1(){
        Set<ID> filesIds=new Set<ID>();
        Map<Id,File__c> mapOfFeedIdForFile=null;
        List<File__c> filesToInsert=new List<File__c>();
        List<FeedItem> feedItemsLst=new List<FeedItem>();
        String fileName= 'testWinAtPOSBatnewchableFileMassUpdateFile';
        String fileContent='/9j/4QAYRXhpZgAASUkqAAg';
        //creating files
        for(Integer i=0;i<20;i++){
            File__c f = new File__c();
            f.Name = 'testWinAtPOSBatchableFileMassUpdateFile'+i;
            f.Type__c = 'Image';
            f.Is_Primary_Image__c=true;
            filesToInsert.add(f);
        }
        insert filesToInsert;
        mapOfFeedIdForFile=new Map<Id,File__c>(filesToInsert);
        Integer i=0;
        //creating feedItem for files
        for(File__c f : filesToInsert){
            i++;
            FeedItem fItem = new FeedItem();
            if(i == 18){
                //particual feedItem will throw exception in batch class
                fItem.Type='TextPost';
                fItem.parentId = f.Id;
                fItem.Title = 'DovetestWinAtPOSBatchableFileMassUpdateFile'+i;
                fItem.Body = 'Promo is the UK';
            }else{
                fItem.Type = 'ContentPost';
                fItem.parentId = f.Id;
                fItem.Title = 'DovetestWinAtPOSBatchableFileMassUpdateFile'+i;
                fItem.ContentFileName = 'DovetestWinAtPOSBatchableFileMassUpdateFile'+i+'.jpeg';
                fItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
                fItem.Body = 'Promo is the UK';
            }
            
            
            feedItemsLst.add(fItem);
            filesIds.add(f.id);
            
        }
        insert feedItemsLst;
        //updating populating feed_ID for files
        for(FeedItem fItem: feedItemsLst){
            File__c f=mapOfFeedIdForFile.get(fItem.parentId);
            f.Feed_ID__c=fItem.id;
            f.Feed_URL__c=null;
            f.Feed_Thumbnail_URL__c=null;
            f.File_Size_Bytes__c=null;
        }
        update filesToInsert;
        Test.startTest();
        TestingHelper tsHelper=new TestingHelper();
        String query='select id,Feed_ID__c, Feed_Thumbnail_URL__c, Feed_URL__c,File_Size_Bytes__c from File__c where Feed_ID__c != null and Id in ('+tsHelper.buildWhereClauseForSetOfIds(filesIds)+')';
        WinAtPOS_BatchableFileMassUpdate fileSizeUpdateBatch= new WinAtPOS_BatchableFileMassUpdate();
        ID batchprocessid = Database.executeBatch(fileSizeUpdateBatch);
        
        Test.stopTest();
        //batch finished processing check if fields were populated
        List<File__c> updatedFiles= (List<File__c>)Database.query(query);
        system.assertEquals(true, updatedFiles.get(0).File_Size_Bytes__c>0, 'file size should be calculated');
        
    }
}