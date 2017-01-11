public class PQN_updateDCV{
 
 public static void update_DCV(List<PQN_DC_Volumes__c>  listdcv){
   
   set<string> setmonth=new set<string>();
   set<string> setyear=new set<string>();
   set<string> setRepDC=new set<string>();
   Map<String, id> mapDC= new Map<String, id>();
   for(PQN_DC_Volumes__c dcv: listdcv){
         setmonth.add(dcv.Month__c);
         setyear.add(dcv.Year__c);
         setRepDC.add(dcv.Reporting_DC__c);
         system.debug('bbb'+dcv.Reporting_DC__c);
         mapDC.put(dcv.Month__c+dcv.Year__c+dcv.Reporting_DC__c,dcv.id);
         system.debug('mapdcccccccc'+mapDC);
    }
     
     
     List<PQN_Pallet_Quality_Non_Conformance__c> listpqn=new List<PQN_Pallet_Quality_Non_Conformance__c>();
     List<PQN_Pallet_Quality_Non_Conformance__c> listpqn1=new List<PQN_Pallet_Quality_Non_Conformance__c>();
         listpqn=[select id,Date_Pallet_Received__c,Year__c,Month__c,Reporting_DC__c,DC_Volumes__c from PQN_Pallet_Quality_Non_Conformance__c where
         Month__c in:setmonth and Year__c in:setyear and Reporting_DC__c in: setRepDC and DC_Volumes__c=null ];
     //listpqn[0].DC_Volumes__c= mapDC.get(listpqn[0].Reporting_DC__c); 
     if(!listpqn.isEmpty()){
     for(PQN_Pallet_Quality_Non_Conformance__c pqn: listpqn){
         if(mapDC.containskey(pqn.Month__c+pqn.Year__c+pqn.Reporting_DC__c)){
         system.debug('aaa'+pqn.Month__c+pqn.Year__c+pqn.Reporting_DC__c);
             pqn.DC_Volumes__c = mapDC.get(pqn.Month__c+pqn.Year__c+pqn.Reporting_DC__c);
             listpqn1.add(pqn);
         }
         update listpqn1;
     }
     }
     
     }
     }