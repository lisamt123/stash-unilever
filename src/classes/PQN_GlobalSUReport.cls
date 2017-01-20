public without sharing class PQN_GlobalSUReport{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
     public Integer cuYear{get;set;}
    public Integer preYear{get;set;}
    public String cuMonth{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
    
    
    public PQN_GlobalSUReport(){
    
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
        xChartdata = new List<PQN_chart>();

/*        for(AggregateResult xD:[select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= '' and Supplier_Cluster__c!= null group By Supplier_Cluster__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc ])
        {
            if(integer.valueof(xD.get('expr0'))!=null){
                xChartdata.add(new PQN_chart(String.valueOf(xD.get('Supplier_Cluster__c')),integer.valueof(xD.get('expr0'))));
            }

        }*/
             List<PQN_Supplier__c> listsup=new List<PQN_Supplier__c>();
             Map<String,String> mapofsup= new Map<String,String>();
             Map<String,Integer> mapOfCluster = new Map<String,Integer>();
             Map<String,Integer> mapOfClusterPreYear = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnth = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthdc = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthIE = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercrmnthtot = new Map<String,Integer>();
             Map<String,Integer> mapOfClusterprevyrtot = new Map<String,Integer>();
             Map<String,Integer> mapOfClustercryeartot = new Map<String,Integer>();
             Map<String,Decimal> mapOftarget = new Map<String,Decimal>();
             cuYear = integer.valueof(system.Today().year());
             preYear = integer.valueof(system.Today().year()) - 1;
             DateTime d = datetime.now();
             cuMonth = d.format('MMMMM');
             
             String prevCluster = '';
             Integer ClusterSum;
             
             List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= ''  group By Supplier_Cluster__c,Supplier__c]);
      
      
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier__c')),False));
            }
            else if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevCluster ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Cluster__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier__c')),False));
            } 
           prevCluster = string.valueOf(ar.get('Supplier_Cluster__c'));
           
        }  
                       
        listsup=[select Supplier_Region__c,Supplier_Cluster__c from PQN_Supplier__c where Supplier_Type__c='SU'];
          for(PQN_Supplier__c sup : listsup){
            mapofsup.put(sup.Supplier_Cluster__c,sup.Supplier_Region__c);
            }
        
        List<AggregateResult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Supplier_Cluster__c,Supplier__c]);
      
        List<PQN_Targets__c> listtar=new List<PQN_Targets__c>([select id,Target_Reduction__c,Region__c from PQN_Targets__c where Region__c!='' AND Year__c=:string.valueof(system.Today().year())]);
         
         
         for(PQN_Targets__c lt: listtar){
            mapOftarget.put(lt.Region__c,lt.Target_Reduction__c);
           } 
           system.debug('mot-->>'+mapOftarget);
           
        prevCluster = '';
        ClusterSum = 0;
      
        for(AggregateResult ar:ListAGG){
            
          if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevCluster ){
              ClusterSum = 0;
            } 
                                  
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfCluster.put(string.valueOf(ar.get('Supplier_Cluster__c')), ClusterSum);
          
            mapOfCluster.put(string.valueOf(ar.get('Supplier_Cluster__c'))+string.valueOf(ar.get('Supplier__c')), integer.valueof(ar.get('expr0')));
          
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c'));
            
        }
                
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if(mapOftarget.get(mapofsup.get(xA.Cluster))!=null){
                 xA.cuYeartarper = string.valueof(mapOftarget.get(mapofsup.get(xA.Cluster)));
                 }else{xA.cuYeartarper='n.a';}
    
              if (xA.Cluster+xA.Supplier != '') {
               if (mapOfCluster.get(xA.Cluster+xA.Supplier) != Null){
                xA.cuYeardata = mapOfCluster.get(xA.Cluster+xA.Supplier);
                 temp = Double.valueOf((mapOfCluster.get(xA.Cluster+xA.Supplier)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            else {
               if (mapOfCluster.get(xA.Cluster) != Null){
                  xA.cuYeardata = mapOfCluster.get(xA.Cluster);
                  temp = Double.valueOf((mapOfCluster.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Supplier_Cluster__c,Supplier__c]);
        
        prevCluster = '';
        ClusterSum = 0;
              
        mapOfClusterPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevCluster ){
               
                ClusterSum = 0;
            }   
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfClusterPreYear.put(string.valueOf(ar.get('Supplier_Cluster__c')), ClusterSum);
                       
            mapOfClusterPreYear.put(string.valueOf(ar.get('Supplier_Cluster__c'))+string.valueOf(ar.get('Supplier__c')), integer.valueof(ar.get('expr0')));
           
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.Cluster+xA.Supplier != '') {
             if (mapOfClusterPreYear.get(xA.Cluster+xA.Supplier) != Null){
                 xA.preYeardata = mapOfClusterPreYear.get(xA.Cluster+xA.Supplier);
                   temp = Double.valueOf((mapOfClusterPreYear.get(xA.Cluster+xA.Supplier)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0; }
            }
            else {
                xA.preYeardata = mapOfClusterPreYear.get(xA.Cluster);
                if (mapOfClusterPreYear.get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfClusterPreYear.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; xA.preYeardata =0;}
            }
            
          
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Supplier_Cluster__c,Supplier__c]);
        
        prevCluster = '';
        ClusterSum = 0;
      
        mapOfClustercrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
         if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevCluster ){
               
                ClusterSum = 0;
            }   
                        
            ClusterSum = ClusterSum + integer.valueof(ar.get('expr0'));
            mapOfClustercrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), ClusterSum);
           
            mapOfClustercrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c'))+string.valueOf(ar.get('Supplier__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.Cluster+xA.Supplier != '') {
              if (mapOfClustercrmnth .get(xA.Cluster+xA.Supplier) != Null){
                xA.cumnthdata = mapOfClustercrmnth .get(xA.Cluster+xA.Supplier);
                 temp = Double.valueOf((mapOfClustercrmnth .get(xA.Cluster+xA.Supplier)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata =0; }
            }
            else {
                xA.cumnthdata = mapOfClustercrmnth .get(xA.Cluster);
                if (mapOfClustercrmnth .get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfClustercrmnth.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;  xA.cumnthdata =0;}
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Trend Calculation ************************/
         
         for(PQN_Global_SUWrap xA: xSUWRAPLIST){
           decimal temp=0;
            if(xA.cuYeartarper =='n.a'){
              if(xA.cuYearPercent!=0 && xA.preYearPercent !=0){
                xA.Trendper=((xA.cuYearPercent-xA.preYearPercent)*100/xA.preYearPercent).setscale(2);
                }
                 else{xA.Trendper=0;}
              }
            else{
              if(xA.cuYearPercent!=0 && xA.cuYeartarper !='0'){
                temp=(xA.cuYearPercent-decimal.valueof(xA.cuYeartarper))*100/decimal.valueof(xA.cuYeartarper) ;
                xA.Trendper=temp.setscale(2);}
                 else{xA.Trendper=0;}
              }
        }
        /**************** For Trend Calculation *****************/
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
             if(xA.child)
             xChartdata.add(new PQN_chart(xA.Cluster,xA.cuYeardata ,xA.Trendper));

         }        
        
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Cluster{get;set;}
        public string Supplier{get;set;}
        public Integer preYeardata {get;set;}
        public Decimal preYearPercent {get;set;}
        public string cuYeartarper {get;set;}
        public Integer cuYeardata {get;set;}
        public Decimal cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public Decimal cumnthPercent {get;set;}
        public Decimal Trendper{get;set;}
        
        
        
        public PQN_Global_SUWrap(String Cluster, String Supplier, Boolean child){
            
            this.Cluster= Cluster;
            this.Supplier= Supplier;
            this.child= child;
           
        }
        
    }
    
    public class PQN_chart{
        
        public String chartXAxis{get;set;}
        public Integer chartdata {get;set;}
        public Decimal linedata {get;set;}
                
        public PQN_chart( String chartXAxis,integer chartdata, Decimal linedata){
            this.chartXAxis= chartXAxis;
            this.chartdata= chartdata;
            this.linedata= linedata;
            
                     
        }
        
    }
    
}