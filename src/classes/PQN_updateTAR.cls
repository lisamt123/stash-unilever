public class PQN_updateTAR{
 
 public static void update_TAR(List<PQN_Targets__c>  listtar){
   set<string> setregion=new set<string>();
   set<string> setyear=new set<string>();
   set<string> setGeo=new set<string>();
   Map<String, id> mapTAR= new Map<String, id>();
   for(PQN_Targets__c tar: listtar){
         setyear.add(tar.Year__c);
         //setGeo.add(tar.Geography__c);
         setregion.add(tar.Region__c);
        // system.debug('bbb'+tar.Geography__c);
         mapTAR.put(tar.Year__c+tar.Region__c,tar.id);
         system.debug('maptarr'+mapTAR);
    }
     
     
     List<PQN_Pallet_Quality_Non_Conformance__c> listpqn=new List<PQN_Pallet_Quality_Non_Conformance__c>();
     List<PQN_Pallet_Quality_Non_Conformance__c> listpqn1=new List<PQN_Pallet_Quality_Non_Conformance__c>();
         listpqn=[select id,Date_Pallet_Received__c,Year__c,Month__c,Reporting_DC__c,Region__c,DC_Country__c,Targets__c from PQN_Pallet_Quality_Non_Conformance__c where
         Year__c in:setyear and Region__c in: setregion and Targets__c=null limit 50000];
     //listpqn[0].DC_Volumes__c= mapDC.get(listpqn[0].Reporting_DC__c); 
     if(!listpqn.isEmpty()){
     for(PQN_Pallet_Quality_Non_Conformance__c pqn: listpqn){
         if(mapTAR.containskey(pqn.Year__c+pqn.Region__c)){
         system.debug('aaa'+pqn.Year__c+pqn.Region__c);
             pqn.Targets__c= mapTAR.get(pqn.Year__c+pqn.Region__c);
             listpqn1.add(pqn);
         }
         update listpqn1;
     }
     }
     
     }
     }