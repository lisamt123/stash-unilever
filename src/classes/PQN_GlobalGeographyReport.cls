public without sharing class PQN_GlobalGeographyReport{
  
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
    public String empty{get;set;}
    public Integer cuYear{get;set;}
    public Integer preYear{get;set;}
    public String cuMonth{get;set;}
   
    public PQN_GlobalGeographyReport(){
         empty = '';
           xChartdata = new List<PQN_chart>();
         xSUWRAPLIST = new List<PQN_Global_SUWrap>();
         Map<String,Integer> mapOfRegion = new Map<String,Integer>();
         Map<String,Integer> mapOfRegionPreYear = new Map<String,Integer>();
         Map<String,Integer> mapOfRegioncrmnth = new Map<String,Integer>();
         Map<String,Integer> mapOfRegioncrmnthdc = new Map<String,Integer>();
         Map<String,Integer> mapOfRegioncrmnthIE = new Map<String,Integer>();
         Map<String,Integer> mapOfRegioncrmnthtot = new Map<String,Integer>();
         Map<String,Integer> mapOfRegionprevyrtot = new Map<String,Integer>();
         Map<String,Integer> mapOfRegioncryeartot = new Map<String,Integer>();
         Map<String,Decimal> mapOftarget = new Map<String,Decimal>();
       
        cuYear = integer.valueof(system.Today().year());
        preYear = integer.valueof(system.Today().year()) - 1;
        DateTime d = datetime.now();
        cuMonth = d.format('MMMMM');
        
        String prevRegion='';
        String prevCluster='';
        String prevsbclus='';
        Integer regionSum;
        Integer clusterSum;
        Integer sbclussum;
        
          //for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c category from PQN_Pallet_Quality_Non_Conformance__c where Product_Category__c!='' group By Product_Category__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]){
        /* for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c from PQN_Pallet_Quality_Non_Conformance__c where Supplier_Region__c!=''  group By Supplier_Region__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]){ 
                xChartdata.add(new PQN_chart(String.valueOf(xD.get('Supplier_Region__c')),integer.valueof(xD.get('expr0')),integer.valueof(xD.get('expr0'))));
        }*/
     
        List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c where Supplier_Region__c!=''  group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
        for(AggregateResult ar:LAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) == prevsbclus){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False,False));
            }
            else if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),'',False,False,True));
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False,False));
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'','',False,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False,False));
            }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),'','','',True,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'','',False,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False,False));
                
            }
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
         
         }
         
         /***For Current Year SU***/
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!=''  AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
      
        List<PQN_Targets__c> listtar=new List<PQN_Targets__c>([select id,Target_Reduction__c,Region__c from PQN_Targets__c where Region__c!='' AND Year__c=:string.valueof(system.Today().year())]);
        
         for(PQN_Targets__c lt: listtar){
            mapOftarget.put(lt.Region__c,lt.Target_Reduction__c);
           } 
           
        prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if(mapOftarget.get(xA.Region)!=null){
                 xA.cuYeartarper = mapOftarget.get(xA.Region);
                 }else{xA.cuYeartarper =0;}
            if(xA.Country!= '') {
              if (mapOfRegion.get(xA.Country) != Null){
                xA.cuYeardata = mapOfRegion.get(xA.Country);
                 temp=Double.valueOf((mapOfRegion.get(xA.Country)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            
            else if (xA.subCluster != '') {
             if (mapOfRegion.get(xA.subCluster) != Null){
                xA.cuYeardata = mapOfRegion.get(xA.subCluster);
                 temp=Double.valueOf((mapOfRegion.get(xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            else if (xA.Cluster != '') {
             if (mapOfRegion.get(xA.Cluster) != Null){
                xA.cuYeardata = mapOfRegion.get(xA.Cluster);
                 temp=Double.valueOf((mapOfRegion.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            else if (xA.Region!= '') {
             if (mapOfRegion.get(xA.Region) != Null){
                xA.cuYeardata = mapOfRegion.get(xA.Region);
                 temp=Double.valueOf((mapOfRegion.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
          
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year() - 1) group by Year__c ]);
       
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!='' AND Year__c=:string.valueof(system.Today().year()-1) AND Supplier_type__c='SU' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
      
        prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            
            if(xA.Country!= '') {
              if (mapOfRegionPreYear .get(xA.Country) != Null){
                xA.preYeardata = mapOfRegionPreYear .get(xA.Country);
                 temp=Double.valueOf((mapOfRegionPreYear .get(xA.Country)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.preYearPercent = temp.setscale(2);
                }else{xA.preYearPercent =0;xA.preYeardata =0;}
            }
            
            else if (xA.subCluster != '') {
             if (mapOfRegionPreYear .get(xA.subCluster) != Null){
                xA.preYeardata = mapOfRegionPreYear .get(xA.subCluster);
                 temp=Double.valueOf((mapOfRegionPreYear .get(xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.preYearPercent = temp.setscale(2);
                }else{xA.preYearPercent =0;xA.preYeardata =0;}
            }
            else if (xA.Cluster != '') {
             if (mapOfRegionPreYear .get(xA.Cluster) != Null){
                xA.preYeardata = mapOfRegionPreYear .get(xA.Cluster);
                 temp=Double.valueOf((mapOfRegionPreYear .get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.preYearPercent = temp.setscale(2);
                }else{xA.preYearPercent =0;xA.preYeardata =0;}
            }
            else if (xA.Region!= '') {
             if (mapOfRegionPreYear .get(xA.Region) != Null){
                xA.preYeardata = mapOfRegionPreYear .get(xA.Region);
                 temp=Double.valueOf((mapOfRegionPreYear .get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.preYearPercent = temp.setscale(2);
                }else{xA.preYearPercent =0;xA.preYeardata =0;}
            }
          
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!='' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
        prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if(xA.Country!= '') {
              if (mapOfRegioncrmnth .get(xA.Country) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Country);
                 temp=Double.valueOf((mapOfRegioncrmnth .get(xA.Country)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cumnthPercent = temp.setscale(2);
                }else{xA.cumnthPercent =0;xA.cumnthdata =0;}
            }
            
            else if (xA.subCluster != '') {
             if (mapOfRegioncrmnth .get(xA.subCluster) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.subCluster);
                    temp = Double.valueOf((mapOfRegioncrmnth .get(xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; xA.cumnthdata = 0;}
            }
            else if (xA.Cluster != '') {
            if (mapOfRegioncrmnth .get(xA.Cluster) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Cluster);
                    temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata = 0; }
            }
            else if (xA.Region!= ''){
             if (mapOfRegioncrmnth .get(xA.Region) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Region);
                   temp = Double.valueOf((mapOfRegioncrmnth.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata = 0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
        prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
             if (xA.Country!= '') {
               if(mapOfRegioncrmnthdc .get(xA.Country)!=null){
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Country);
                }else{ xA.cumnthdcdata =0;}
              }
             else if (xA.subCluster != '') {
               if(mapOfRegioncrmnthdc .get(xA.subCluster)!=null){
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.subCluster);
                }else{ xA.cumnthdcdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthdc .get(xA.Cluster)!=Null){
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Cluster);
                }else{ xA.cumnthdcdata =0;}
              }
            
            else {
                if(mapOfRegioncrmnthdc .get(xA.Region)!=Null){
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Region);
                }else{ xA.cumnthdcdata =0;}
              }
          
        }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!=''  AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
         prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              if(mapOfRegioncrmnthIE .get(xA.Country)!=Null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE.get(xA.Country);
                }else{xA.cumnthIEdata =0;}
              }
            else if (xA.subCluster != '') {
              if(mapOfRegioncrmnthIE .get(xA.subCluster)!=Null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.subCluster);
                }else{xA.cumnthIEdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthIE .get(xA.Cluster )!=Null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Cluster );
                }else{xA.cumnthIEdata =0;}
              }
            
            else {
                if(mapOfRegioncrmnthIE .get(xA.Region)!=Null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Region);
                }else{xA.cumnthIEdata =0;}
              }
           
        }
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!=''  AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
         prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              if(mapOfRegioncrmnthtot .get(xA.Country)!=Null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Country);
                }else{xA.cumnthtotdata =0;}
              }
            else if (xA.subCluster != '') {
              if(mapOfRegioncrmnthtot .get(xA.subCluster)!=Null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.subCluster);
                }else{xA.cumnthtotdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthtot .get(xA.Cluster )!=Null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Cluster );
                }else{xA.cumnthtotdata =0;}
             }
            
            else {
                if(mapOfRegioncrmnthtot .get(xA.Region)!=Null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Region);
                }else{xA.cumnthtotdata =0;}
             }
        
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!='' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
         prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              if(mapOfRegionprevyrtot .get(xA.Country)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Country);
                }else{xA.preYeardatatot =0;}
              }
            else if (xA.subCluster != '') {
              if(mapOfRegionprevyrtot .get(xA.subCluster)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.subCluster);
                }else{xA.preYeardatatot =0;}
              }
            else if (xA.Cluster != '') {
              if(mapOfRegionprevyrtot .get(xA.Cluster)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Cluster);
                }else{xA.preYeardatatot =0;}
               }
            
            else {
              if(mapOfRegionprevyrtot .get(xA.Region)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Region);
                }else{xA.preYeardatatot =0;}
              }
            
           }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Supplier_Country__c!='' AND Year__c=: string.valueof(((system.Today().year())))  group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c,Supplier_Country__c]);
        
        prevRegion = '';
        prevCluster = '';
        prevsbclus='';
        regionSum = 0;
        clusterSum = 0;
        sbclussum=0;
        
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if ( string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster && string.valueOf(ar.get('Supplier_Sub_Cluster__c')) != prevsbclus){
               sbclussum=0;
              } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
              
                sbclussum=0;
                clusterSum = 0;
              }
            else if(string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
                sbclussum=0;
                regionSum = 0;
                clusterSum = 0;
              }
         
           
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum); 
              
            sbclussum = sbclussum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Sub_Cluster__c')),sbclussum );              
            
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevsbclus=string.valueOf(ar.get('Supplier_Sub_Cluster__c'));
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              if(mapOfRegioncryeartot .get(xA.Country)!=Null){
                 xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Country);
                }else{xA.cuYeardatatot =0;}
              }
            else if (xA.subCluster != '') {
              if(mapOfRegioncryeartot .get(xA.subCluster)!=Null){
                 xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.subCluster);
                }else{xA.cuYeardatatot =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncryeartot .get(xA.Cluster )!=Null){
                 xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Cluster );
                }else{xA.cuYeardatatot =0;}
              }
            
            else {
               if(mapOfRegioncryeartot .get(xA.Region)!=Null){
                 xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Region);
                }else{xA.cuYeardatatot =0;}
              }
       
        }
        
        /************************* For Current Month DC Data ****************************/
         /************************* For Trend Calculation ************************/
         
         for(PQN_Global_SUWrap xA: xSUWRAPLIST){
          decimal temp=0;
            if(xA.cuYeartarper ==0){
              if(xA.cuYearPercent!=0 && xA.preYearPercent !=0){
                xA.Trendper=((xA.cuYearPercent-xA.preYearPercent)*100/xA.preYearPercent).setscale(2);
                }
                 else{xA.Trendper=0;}
              }
            else{
              if(xA.cuYearPercent!=0 &&  xA.cuYeartarper!=0){
                xA.Trendper=((xA.cuYearPercent-xA.cuYeartarper)*100/xA.cuYeartarper).setscale(2) ;
                  }else{xA.Trendper=0;}
               }
        }
        /**************** For Trend Calculation *****************/
        
         /*for(PQN_Global_SUWrap xA: xSUWRAPLIST){
             if(xA.child)
             xChartdata.add(new PQN_chart(xA.Region,xA.cuYeardata ,xA.Trendper));

         }*/
        
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public Boolean childCluster{get;set;}
         public Boolean childsubCluster{get;set;}
        public string Region{get;set;}
        public string Cluster{get;set;}
        public string subCluster{get;set;}
        public string Country{get;set;}
        public Integer preYeardata {get;set;}
        public decimal preYearPercent {get;set;}
        public decimal cuYeartarper {get;set;}
        public Integer cuYeardata {get;set;}
        public decimal cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public decimal cumnthPercent {get;set;}
        public Integer cumnthdcdata {get;set;}
        public Integer cumnthIEdata {get;set;}
        public Integer cumnthtotdata {get;set;}
        public Integer preYeardatatot {get;set;}
        public Integer cuYeardatatot {get;set;}
        public decimal Trendper{get;set;}
        
        public PQN_Global_SUWrap(String Region, String Cluster, String subCluster,String Country, Boolean child,Boolean child1 ,Boolean child2){
            this.Region= Region;
            this.Cluster= Cluster;
            this.subCluster= subCluster;
            this.Country= Country;
            this.child= child;
            this.childCluster= child1;
            this.childsubCluster= child2;
            
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