public with sharing class PQN_GlobalSUReport{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
    
    
    public PQN_GlobalSUReport(){
    
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
         Map<String,Integer> mapOfCluster = new Map<String,Integer>();
             Map<String,Integer> mapOfClusterPreYear = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnth = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthdc = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthIE = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthtot = new Map<String,Integer>();
             Map<String,Integer> mapOfClusterprevyrtot = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercryeartot = new Map<String,Integer>();
             
             String prevCluster = '';
             Integer ClusterSum;
             
             List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' group By Cluster__c ,Sub_Cluster__c]);
      
      
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Cluster__c')) == prevCluster){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False));
            }
            else if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False));
            } 
           prevCluster = string.valueOf(ar.get('Cluster__c'));
           
        }                
      
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Cluster__c ,Sub_Cluster__c]);
      
        prevCluster = '';
        ClusterSum = 0;
      
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Cluster__c')) == prevCluster){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False));
            }
            else if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False));
                ClusterSum = 0;
            } 
                                  
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfCluster.put(string.valueOf(ar.get('Cluster__c')), ClusterSum);
          
            mapOfCluster.put(string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevCluster = string.valueOf(ar.get('Cluster__c'));
            
        }
                
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
    
              if (xA.SubCluster  != '') {
                xA.cuYeardata = mapOfCluster.get(xA.SubCluster );
              if (mapOfCluster.get(xA.SubCluster ) != Null){
                temp = Double.valueOf((mapOfCluster.get(xA.SubCluster )*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
            else if(xA.Cluster!= ''){
                xA.cuYeardata = mapOfCluster.get(xA.Cluster);
                 if (mapOfCluster.get(xA.Cluster) != Null){
                temp = Double.valueOf((mapOfCluster.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c  != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Cluster__c ,Sub_Cluster__c]);
        
        prevCluster = '';
        ClusterSum = 0;
              
        mapOfClusterPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
               
                ClusterSum = 0;
            }   
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfClusterPreYear.put(string.valueOf(ar.get('Cluster__c')), ClusterSum);
                       
            mapOfClusterPreYear.put(string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
           
            prevCluster = string.valueOf(ar.get('Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.SubCluster  != '') {
                xA.preYeardata = mapOfClusterPreYear.get(xA.SubCluster );
                if (mapOfClusterPreYear.get(xA.SubCluster ) != Null){
                    temp = Double.valueOf((mapOfClusterPreYear.get(xA.SubCluster )*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else if(xA.Cluster!= ''){
                xA.preYeardata = mapOfClusterPreYear.get(xA.Cluster);
                if (mapOfClusterPreYear.get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfClusterPreYear.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            
          
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c  != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Cluster__c ,Sub_Cluster__c]);
        
        prevCluster = '';
        ClusterSum = 0;
      
        mapOfClustercrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
         if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
               
                ClusterSum = 0;
            }   
                        
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfClustercrmnth .put(string.valueOf(ar.get('Cluster__c')), ClusterSum);
           
            mapOfClustercrmnth .put(string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.SubCluster  != '') {
                xA.cumnthdata = mapOfClustercrmnth .get(xA.SubCluster );
                if (mapOfClustercrmnth .get(xA.SubCluster ) != Null){
                    temp = Double.valueOf((mapOfClustercrmnth .get(xA.SubCluster )*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else if(xA.Cluster!= ''){
                xA.cumnthdata = mapOfClustercrmnth .get(xA.Cluster);
                if (mapOfClustercrmnth .get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfClustercrmnth.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Cluster{get;set;}
        public string SubCluster {get;set;}
        public Integer preYeardata {get;set;}
        public Double preYearPercent {get;set;}
        public Integer cuYeardata {get;set;}
        public Double cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public Double cumnthPercent {get;set;}
        
        
        public PQN_Global_SUWrap(String Cluster, String SubCluster , Boolean child){
            this.Cluster= Cluster;
            this.SubCluster = SubCluster ;
            this.child= child;
           
        }
        
    }
    
}