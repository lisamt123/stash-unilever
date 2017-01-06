public without sharing class PQN_Country_Report{

  public Map<String,Integer> mapofcountry{get;set;}
    
public PQN_Country_Report(){
 
  mapofcountry=new Map<String,Integer>();
    
    /*for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),DC_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where DC_Country__c!= '' group By DC_Country__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]){ 
            
            xChartdata.add(new PQN_chart(String.valueOf(xD.get('DC_Country__c')),integer.valueof(xD.get('expr0'))));
            //

        }*/
     
  List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),DC_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where DC_Country__c!= '' and Year__c=:string.valueof(system.Today().year())  group By DC_Country__c]);
   
  for( AggregateResult ar: ListAGG){

        mapofcountry.put(string.valueof(ar.get('DC_Country__c')),integer.valueof(ar.get('expr0')));
 
      }
   }
 
 
 }