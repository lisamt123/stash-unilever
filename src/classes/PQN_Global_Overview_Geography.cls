public with sharing class PQN_Global_Overview_Geography{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
    
    
    public PQN_Global_Overview_Geography(){
    
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
             Map<String,Integer> mapOfRegion = new Map<String,Integer>();
             Map<String,Integer> mapOfRegionPreYear = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnth = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnthdc = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnthIE = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncrmnthtot = new Map<String,Integer>();
             Map<String,Integer> mapOfRegionprevyrtot = new Map<String,Integer>();
             Map<String,Integer> mapOfRegioncryeartot = new Map<String,Integer>();
             
              String prevRegion = '';
              Integer regionSum;
             
              List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != ''  group By Region__c,cluster__c]);
       
        
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Region__c')) == prevRegion){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),False));
            }
            else if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Region__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),False));
               
            }
             prevRegion = string.valueOf(ar.get('Region__c'));
            
        } 
      
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=:string.valueof(system.Today().year()-1) AND Supplier_type__c='SU' group By Region__c,cluster__c]);
       
     
        prevRegion = '';
        regionSum = 0;
      
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
              regionSum = 0;
            } 
                                  
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Region__c')), regionSum);
          
            mapOfRegion.put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevRegion = string.valueOf(ar.get('Region__c'));
            
        }
                
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
    
              if (xA.Cluster != '') {
                xA.cuYeardata = mapOfRegion.get(xA.Cluster);
              if (mapOfRegion.get(xA.Cluster) != Null){
                temp = Double.valueOf((mapOfRegion.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
            else if(xA.Region!= ''){
                xA.cuYeardata = mapOfRegion.get(xA.Region);
                 if (mapOfRegion.get(xA.Region) != Null){
                temp = Double.valueOf((mapOfRegion.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
              
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Region__c')), regionSum);
                       
            mapOfRegionPreYear.put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
           
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
      
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
         if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Region__c')), regionSum);
           
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
      
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Region__c')), regionSum);
        
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
       
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
           if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Region__c')), regionSum);
          
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
       
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Region__c')), regionSum);
          
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
        
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
             
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
       if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }       
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Region__c')), regionSum);
          
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Region__c,Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year())))  group By Region__c,cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
             
        mapOfRegioncryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Region__c')), regionSum);
         
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Cluster__c')), integer.valueof(ar.get('expr0')));
          
            prevRegion = string.valueOf(ar.get('Region__c'));
            
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
        
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Region{get;set;}
        public string Cluster{get;set;}
        public Integer preYeardata {get;set;}
        public Double preYearPercent {get;set;}
        public Integer cuYeardata {get;set;}
        public Double cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public Double cumnthPercent {get;set;}
        public Integer cumnthdcdata {get;set;}
        public Integer cumnthIEdata {get;set;}
        public Integer cumnthtotdata {get;set;}
        public Integer preYeardatatot {get;set;}
        public Integer cuYeardatatot {get;set;}
        
        public PQN_Global_SUWrap(String Region, String Cluster, Boolean child){
            this.Region= Region;
            this.Cluster= Cluster;
            this.child= child;
           
        }
        
    }
    
}