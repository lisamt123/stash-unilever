public without sharing class PQN_GlobalSUReport{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
      public List<PQN_chart> xChartdata{get;set;}
    
    
    public PQN_GlobalSUReport(){
    
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
         xChartdata = new List<PQN_chart>();
         
          //for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c category from PQN_Pallet_Quality_Non_Conformance__c where Product_Category__c!='' group By Product_Category__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc])
          for(AggregateResult xD:[select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' group By Cluster__c  order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc ])
        {
            
            xChartdata.add(new PQN_chart(String.valueOf(xD.get('Cluster__c')),integer.valueof(xD.get('expr0'))));
            //

        }
         
         Map<String,Integer> mapOfCluster = new Map<String,Integer>();
             Map<String,Integer> mapOfClusterPreYear = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnth = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthdc = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthIE = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthtot = new Map<String,Integer>();
             Map<String,Integer> mapOfClusterprevyrtot = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercryeartot = new Map<String,Integer>();
             Map<String,Decimal> mapOftarget = new Map<String,Decimal>();
             
             String prevCluster = '';
             Integer ClusterSum;
             
             List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' group By Cluster__c ,Reporting_DC__c]);
      
      
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Cluster__c')) == prevCluster){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Reporting_DC__c')),False));
            }
            else if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Reporting_DC__c')),False));
            } 
           prevCluster = string.valueOf(ar.get('Cluster__c'));
           
        }                
      
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Cluster__c ,Reporting_DC__c]);
      
        List<PQN_Pallet_Quality_Non_Conformance__c > listtar=new List<PQN_Pallet_Quality_Non_Conformance__c >([select id,Target_Reduction__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c where Cluster__c !='' AND Target_Reduction__c!=null AND Year__c=:string.valueof(system.Today().year())]);
        
         for(PQN_Pallet_Quality_Non_Conformance__c lt: listtar){
            mapOftarget.put(lt.Cluster__c,lt.Target_Reduction__c);
            
           } 
           system.debug('mot-->>'+mapOftarget);
           
        prevCluster = '';
        ClusterSum = 0;
      
        for(AggregateResult ar:ListAGG){
            
          if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
              ClusterSum = 0;
            } 
                                  
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfCluster.put(string.valueOf(ar.get('Cluster__c')), ClusterSum);
          
            mapOfCluster.put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
          
            prevCluster = string.valueOf(ar.get('Cluster__c'));
            
        }
                
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
    
              if (xA.ReportingDC  != '') {
                xA.cuYeardata = mapOfCluster.get(xA.ReportingDC );
                if(mapOftarget.get(xA.Cluster)!=null){
                 xA.cuYeartarper = mapOftarget.get(xA.Cluster);
                 }else{xA.cuYeartarper=0;}
              if (mapOfCluster.get(xA.ReportingDC ) != Null){
                temp = Double.valueOf((mapOfCluster.get(xA.ReportingDC )*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
            else {
                xA.cuYeardata = mapOfCluster.get(xA.Cluster);
                 if(mapOftarget.get(xA.Cluster)!=null){
                   xA.cuYeartarper = mapOftarget.get(xA.Cluster);
                   }else{xA.cuYeartarper=0;}
                 if (mapOfCluster.get(xA.Cluster) != Null){
                temp = Double.valueOf((mapOfCluster.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c  != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Cluster__c ,Reporting_DC__c]);
        
        prevCluster = '';
        ClusterSum = 0;
              
        mapOfClusterPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
               
                ClusterSum = 0;
            }   
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfClusterPreYear.put(string.valueOf(ar.get('Cluster__c')), ClusterSum);
                       
            mapOfClusterPreYear.put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
           
            prevCluster = string.valueOf(ar.get('Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.ReportingDC  != '') {
                xA.preYeardata = mapOfClusterPreYear.get(xA.ReportingDC );
                if (mapOfClusterPreYear.get(xA.ReportingDC ) != Null){
                    temp = Double.valueOf((mapOfClusterPreYear.get(xA.ReportingDC )*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else {
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c ,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c  != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Cluster__c ,Reporting_DC__c]);
        
        prevCluster = '';
        ClusterSum = 0;
      
        mapOfClustercrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
         if (string.valueOf(ar.get('Cluster__c'))!=prevCluster ){
               
                ClusterSum = 0;
            }   
                        
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfClustercrmnth .put(string.valueOf(ar.get('Cluster__c')), ClusterSum);
           
            mapOfClustercrmnth .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.ReportingDC  != '') {
                xA.cumnthdata = mapOfClustercrmnth .get(xA.ReportingDC );
                if (mapOfClustercrmnth .get(xA.ReportingDC ) != Null){
                    temp = Double.valueOf((mapOfClustercrmnth .get(xA.ReportingDC )*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; }
            }
            else {
                xA.cumnthdata = mapOfClustercrmnth .get(xA.Cluster);
                if (mapOfClustercrmnth .get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfClustercrmnth.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Trend Calculation ************************/
         
         for(PQN_Global_SUWrap xA: xSUWRAPLIST){
         
            if(xA.cuYeartarper ==0){
              if(xA.cuYearPercent!=0 && xA.preYearPercent !=0){
                xA.Trendper=((xA.cuYearPercent-xA.preYearPercent)*100/xA.preYearPercent).setscale(2);
                }
                 else{xA.Trendper=0;}
              }
            else{
              if(xA.cuYearPercent!=0 && xA.cuYeartarper !=0){
                xA.Trendper=((xA.cuYearPercent-xA.cuYeartarper )*100/xA.cuYeartarper).setscale(2) ;}
                 else{xA.Trendper=0;}
              }
        }
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Cluster{get;set;}
        public string ReportingDC {get;set;}
        public Integer preYeardata {get;set;}
        public Decimal preYearPercent {get;set;}
        public Decimal cuYeartarper {get;set;}
        public Integer cuYeardata {get;set;}
        public Double cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public Double cumnthPercent {get;set;}
        public Double Trendper{get;set;}
        
        
        
        public PQN_Global_SUWrap(String Cluster, String ReportingDC , Boolean child){
            this.Cluster= Cluster;
            this.ReportingDC = ReportingDC ;
            this.child= child;
           
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