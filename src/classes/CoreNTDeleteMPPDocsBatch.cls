global class CoreNTDeleteMPPDocsBatch implements Database.Batchable<sObject>{
//global string query ;

//global CoreNTDeleteMPPDocsBatch(){
//Query = 'SELECT LatestPublishedVersionId,OwnerId,ParentId,PublishStatus,Title FROM ContentDocument where ParentId = ' + '\''+Label.Core_NT_Network_Library_Id +'\'';
 
//}

global database.querylocator start(Database.BatchableContext BC){
    
    return Database.getQueryLocator([SELECT LatestPublishedVersionId,OwnerId,ParentId,PublishStatus,Title FROM ContentDocument where ParentId =:Label.Core_NT_Network_Library_Id]);    
}
   
global void execute(Database.BatchableContext BC, List<sObject> scope){

    if(scope.size() > 0)
        delete scope;
    // For executing Batch
    /*
    DeleteContent b = new DeleteContent();
    database.executebatch(b);
    
    */
 
    }
  global void finish(Database.BatchableContext BC){}  

}