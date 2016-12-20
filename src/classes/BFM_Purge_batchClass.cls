global class BFM_Purge_batchClass implements Database.batchable<SObject>{ 
   
   global Iterable<Sobject> start(Database.batchableContext info){ 
       //Iterable<SObject> myIter = (Iterable<SObject>) new BFM_Purge_CustomIterable();
       return new BFM_PurgeIterable(); 
   }     
   
   global void execute(Database.batchableContext info, List<SObject> scope){ 
       system.debug('ssssssssssssss'+scope.size());
       if(!scope.isEmpty()){
       delete scope;   
       }
   }     
   global void finish(Database.batchableContext info){     
   } 
}