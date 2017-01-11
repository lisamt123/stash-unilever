public without sharing class PQN_Global_Overview_Geography{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
     public List<PQN_chart> xChartdata{get;set;}
      
    
    public PQN_Global_Overview_Geography(ApexPages.StandardController acon){
    
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
         xChartdata = new List<PQN_chart>();
             Map<String,Integer> mapOfRegion = new Map<String,Integer>();
             Map<String,Integer> mapOfRegionPreYear = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnth = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnthdc = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnthIE = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnthtot = new Map<String,Integer>();
             Map<String,Integer> mapOfRegionprevyrtot = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncryeartot = new Map<String,Integer>();
             Map<String,Decimal> mapOftarget = new Map<String,Decimal>();
             
              String prevRegion = '';
              Integer regionSum;
            /*for(AggregateResult xD:[select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= '' group By Supplier_Cluster__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc ])
            {
                if(integer.valueof(xD.get('expr0'))!=null){
                    xChartdata.add(new PQN_chart(String.valueOf(xD.get('Supplier_Cluster__c')),integer.valueof(xD.get('expr0'))));
                }
    
            }*/
             
              List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != ''  group By Supplier_Region__c,Supplier_Cluster__c]);
       
        
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),False));
            }
            else if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),False));
               
            }
             prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        } 
      
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=:string.valueof(system.Today().year()-1) AND Supplier_type__c='SU' group By Supplier_Region__c,Supplier_Cluster__c]);
       
        List<PQN_Targets__c> listtar=new List<PQN_Targets__c>([select id,Target_Reduction__c,Region__c from PQN_Targets__c where Region__c!='' AND Year__c=:string.valueof(system.Today().year())]);
        
         for(PQN_Targets__c lt: listtar){
            mapOftarget.put(lt.Region__c,lt.Target_Reduction__c);
           } 
     
        prevRegion = '';
        regionSum = 0;
      
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
              regionSum = 0;
            } 
                                  
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
                
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
    
            if (xA.Cluster != '') {
                xA.cuYeardata = mapOfRegion.get(xA.Cluster);
                if(mapOftarget.get(xA.Region)!=null){
                 xA.cuYeartarper = mapOftarget.get(xA.Region);
                }else{xA.cuYeartarper =0;}
              if (mapOfRegion.get(xA.Cluster) != Null){
                temp = Double.valueOf((mapOfRegion.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
            else if(xA.Region!= ''){
                xA.cuYeardata = mapOfRegion.get(xA.Region);
                if(mapOftarget.get(xA.Region)!=null){
                 xA.cuYeartarper = mapOftarget.get(xA.Region);
                }else{xA.cuYeartarper =0;}
                 if (mapOfRegion.get(xA.Region) != Null){
                temp = Double.valueOf((mapOfRegion.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
              
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
                       
            mapOfRegionPreYear.put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
           
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.Cluster != '') {
                xA.preYeardata = mapOfRegionPreYear.get(xA.Cluster);
                if (mapOfRegionPreYear.get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfRegionPreYear.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else if(xA.Region!= ''){
                xA.preYeardata = mapOfRegionPreYear.get(xA.Region);
                if (mapOfRegionPreYear.get(xA.Region) != Null){
                    temp = Double.valueOf((mapOfRegionPreYear.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            
          
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
      
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
         if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
           
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.Cluster != '') {
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Cluster);
                if (mapOfRegioncrmnth .get(xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else if(xA.Region!= ''){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Region);
                if (mapOfRegioncrmnth .get(xA.Region) != Null){
                    temp = Double.valueOf((mapOfRegioncrmnth.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
          
       xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
      
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
        
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
         
            if (xA.Cluster != '') {
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Cluster);
                }
            
            else if(xA.Region!= ''){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Region);
                }
           
        }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
       
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
           if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if (xA.Cluster != '') {
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Cluster);
                }
            
            else if(xA.Region!= ''){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Region);
                }
         
        }
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
       
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
        
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
         
            if (xA.Cluster != '') {
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Cluster);
                }
            
            else if(xA.Region!= ''){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Region);
                }
           
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
             
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
       if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }       
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
         
            if (xA.Cluster != '') {
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Cluster);
                }
            
            else if(xA.Region!= ''){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Region);
                }
            
          
        }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year())))  group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
             
        mapOfRegioncryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
         
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
        
            if (xA.Cluster != '') {
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Cluster);
                }
            
            else if(xA.Region!= ''){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Region);
                }
           
        }
        
        /************************* For Current Month DC Data ****************************/
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
        /**************** For Trend Calculation *****************/
         for(PQN_Global_SUWrap xA: xSUWRAPLIST){
             if(xA.child)
             xChartdata.add(new PQN_chart(xA.Region,xA.cuYeardata ,xA.Trendper));

         }
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Region{get;set;}
        public string Cluster{get;set;}
        public Integer preYeardata {get;set;}
        public Decimal preYearPercent {get;set;}
        public Decimal cuYeartarper {get;set;}
        public Integer cuYeardata {get;set;}
        public Double cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public Double cumnthPercent {get;set;}
        public Integer cumnthdcdata {get;set;}
        public Integer cumnthIEdata {get;set;}
        public Integer cumnthtotdata {get;set;}
        public Integer preYeardatatot {get;set;}
        public Integer cuYeardatatot {get;set;}
        public Double Trendper{get;set;}
        
        public PQN_Global_SUWrap(String Region, String Cluster, Boolean child){
            this.Region= Region;
            this.Cluster= Cluster;
            this.child= child;
           
        }
        
    }
     public class PQN_chart{
        
        public String chartXAxis{get;set;}
        public Integer chartdata {get;set;}
        public Double linedata {get;set;}
                
        public PQN_chart( String chartXAxis,integer chartdata, Double linedata){
            this.chartXAxis= chartXAxis;
            this.chartdata= chartdata;
            this.linedata= linedata;
            
                     
        }
        
    }
    
}