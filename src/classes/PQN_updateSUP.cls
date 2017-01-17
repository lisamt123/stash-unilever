public class PQN_updateSUP{
 
 public static void update_SUP(List<PQN_Pallet_Quality_Non_Conformance__c>  listpqn){
   set<string> setsup=new set<string>();
   
   Map<String,PQN_Supplier__c> mapSUP= new Map<String, PQN_Supplier__c>();
   for(PQN_Pallet_Quality_Non_Conformance__c pqn: listpqn){
         setsup.add(pqn.Supplier__c);
        }
        
     List<PQN_Supplier__c> listsup=new List<PQN_Supplier__c>();
      listsup=[select name,Country__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Region__c,Supplier_Type__c from PQN_Supplier__c where name in:setsup limit 1];
      if( !listsup.isEmpty()){
       for(PQN_Supplier__c sup: listsup){
         mapSUP.put(sup.name,sup);
        } 
       }
   
     List<PQN_Pallet_Quality_Non_Conformance__c> listpqn1=new List<PQN_Pallet_Quality_Non_Conformance__c>();
         
     if(!listpqn.isEmpty()){
     for(PQN_Pallet_Quality_Non_Conformance__c pqn: listpqn){
         if(mapSUP.containskey(pqn.Supplier__c)){
         
             pqn.Supplier_Cluster__c= mapSUP.get(pqn.Supplier__c).Supplier_Cluster__c;
             pqn.Supplier_Region__c= mapSUP.get(pqn.Supplier__c).Supplier_Region__c;
             pqn.Supplier_Sub_Cluster__c= mapSUP.get(pqn.Supplier__c).Supplier_Sub_Cluster__c;
             pqn.Supplier_Country__c= mapSUP.get(pqn.Supplier__c).Country__c;
             
           }
        
       }
     }
   
   }
  }