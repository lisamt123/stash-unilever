public with sharing class PQN_Country_Report{

  public Map<String,Integer> mapofcountry{get;set;}

public PQN_Country_Report(){
 
  mapofcountry=new Map<String,Integer>();
  List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),DC_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where DC_Country__c!= ''  group By DC_Country__c]);
   
  for( AggregateResult ar: ListAGG){

        mapofcountry.put(string.valueof(ar.get('DC_Country__c')),integer.valueof(ar.get('expr0')));
 
      }
   }
 
 }