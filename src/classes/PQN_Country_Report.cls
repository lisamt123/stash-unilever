public without sharing class PQN_Country_Report{

  public Map<String,Integer> mapofcountry{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
    
public PQN_Country_Report(){
 
  mapofcountry=new Map<String,Integer>();
    xChartdata = new List<PQN_chart>();
    
    for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Country__c!= '' group By Supplier_Country__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]){ 
            
            xChartdata.add(new PQN_chart(String.valueOf(xD.get('Supplier_Country__c')),integer.valueof(xD.get('expr0'))));
            //

        }
     
  List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Country__c!= '' and Year__c=:string.valueof(system.Today().year())  group By Supplier_Country__c]);
   
  for( AggregateResult ar: ListAGG){

        mapofcountry.put(string.valueof(ar.get('Supplier_Country__c')),integer.valueof(ar.get('expr0')));
 
      }
   }
 public class PQN_chart{
        
        public String chartXAxis{get;set;}
        public Integer chartdata {get;set;}
                
        public PQN_chart( String chartXAxis,integer chartdata){
            this.chartXAxis= chartXAxis;
            this.chartdata= chartdata;
                     
        }
        
    }
 
 }