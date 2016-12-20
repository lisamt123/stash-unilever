global class BFM_PurgeIterable implements iterable<sObject>{
   global Iterator<sObject> Iterator(){
      return new BFM_Purge_CustomIterable();
   }
}