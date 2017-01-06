public without sharing class PQN_GlobalCategoryReport{
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
    public List<PQN_Pallet_Quality_Non_Conformance__c> PQNList{get;set;}
    
    public PQN_GlobalCategoryReport(){
        // for previous year SU NC group by cluster and subcluster
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
        Map<String,Decimal> mapOftarget = new Map<String,Decimal>();
        
        String prevCate = '';
        String prevRegion = '';
        String prevCluster = '';
        Integer cateSum;
        Integer regionSum;
        Integer clusterSum;
        List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c !='' group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
      
         for(AggregateResult ar:LAGG){
                   
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) == prevCluster){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False,False,False));
            }
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False,False,False));
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),'','',False,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False,False,False));
            }
            else if(string.valueOf(ar.get('Product_Category__c')) != prevCate){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),'','','',True,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),'','',False,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Region__c')),string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Sub_Cluster__c')),False,False,False));
            }
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
         }
        
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c !=''  AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
    
         List<PQN_Targets__c> listtar=new List<PQN_Targets__c>([select id,Target_Reduction__c,Region__c from PQN_Targets__c where Region__c!='' AND Year__c=:string.valueof(system.Today().year())]);
        
         for(PQN_Targets__c lt: listtar){
            mapOftarget.put(lt.Region__c,lt.Target_Reduction__c);
           } 
           
        prevCate = '';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
      
        for(AggregateResult ar:ListAGG){
                   
          if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion){
              
                regionSum = 0;
                clusterSum = 0;
            }
            else if(string.valueOf(ar.get('Product_Category__c')) != prevCate){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
         
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
         
        }
        
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            
            if (xA.subCluster != '') {
                xA.cuYeardata = mapOfRegion.get(xA.Category+'-'+xA.subCluster);
                 if(mapOftarget.get(xA.Region)!=null){
                   xA.cuYeartarper=mapOftarget.get(xA.Region);
                 }else{xA.cuYeartarper =0;}
                if(mapOfRegion.get(xA.Category+'-'+xA.subCluster)!=Null){
                 temp= Double.valueOf((mapOfRegion.get(xA.Category+'-'+xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;}
            }
            else if (xA.Cluster != '') {
                xA.cuYeardata = mapOfRegion.get(xA.Category+'-'+xA.Cluster);
                if(mapOftarget.get(xA.Region)!=null){
                 xA.cuYeartarper=mapOftarget.get(xA.Region);
                }else{xA.cuYeartarper =0;}
                if((mapOfRegion.get(xA.Category+'-'+xA.Cluster))!=Null){
                 temp= Double.valueOf((mapOfRegion.get(xA.Category+'-'+xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;}
            }
            else if(xA.Region != ''){
               xA.cuYeardata = mapOfRegion.get(xA.Category+'-'+xA.Region);
               if(mapOftarget.get(xA.Region)!=null){
                xA.cuYeartarper=mapOftarget.get(xA.Region);
               }else{xA.cuYeartarper =0;}
               if((mapOfRegion.get(xA.Category+'-'+xA.Region))!=Null){
                 temp= Double.valueOf((mapOfRegion.get(xA.Category+'-'+xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;}
            }
           else if(xA.category!=''){
                xA.cuYeardata = mapOfRegion.get(xA.Category);
                if(mapOfRegion.get(xA.Category)!=Null){
                 temp = Double.valueOf((mapOfRegion.get(xA.Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;}
            }
            
           
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year() - 1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c != '' AND Year__c=: string.valueof(((system.Today().year())) - 1) AND Supplier_type__c='SU' group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        prevcate='';
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        cateSum = 0;
        
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
            else if(string.valueOf(ar.get('Product_Category__c')) != prevCate){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
          
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.preYeardata = mapOfRegionPreYear.get(xA.Category+'-'+xA.subCluster);
                if (mapOfRegionPreYear.get(xA.Category+'-'+xA.subCluster) != Null){
                    temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category+'-'+xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else if (xA.Cluster != '') {
                xA.preYeardata = mapOfRegionPreYear.get(xA.Category+'-'+xA.Cluster);
                if (mapOfRegionPreYear.get(xA.Category+'-'+xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category+'-'+xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else if(xA.Region!=''){
                xA.preYeardata = mapOfRegionPreYear.get(xA.Category+'-'+xA.Region);
                if (mapOfRegionPreYear.get(xA.Category+'-'+xA.Region) != Null){
                    temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category+'-'+xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
                }
                
            else if(xA.category!=''){
                xA.preYeardata = mapOfRegionPreYear.get(xA.Category);
                if (mapOfRegionPreYear.get(xA.Category) != Null){
                  temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
          
            
            
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        
        prevcate='';
        prevRegion = '';
        prevCluster = '';
        cateSum =0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion ){
                clusterSum = 0;
                regionSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) != prevCate ){
                cateSum =0;
                regionSum = 0;
                clusterSum = 0;
            }
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category+'-'+xA.subCluster);
                if (mapOfRegioncrmnth .get(xA.Category+'-'+xA.subCluster) != Null){
                    temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Category+'-'+xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; }
            }
            else if (xA.Cluster != '') {
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category+'-'+xA.Cluster);
                if (mapOfRegioncrmnth .get(xA.Category+'-'+xA.Cluster) != Null){
                    temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Category+'-'+xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; }
            }
            else if(xA.Region!=''){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category+'-'+xA.Region);
                if (mapOfRegioncrmnth .get(xA.Category+'-'+xA.Region) != Null){
                    temp = Double.valueOf((mapOfRegioncrmnth.get(xA.Category+'-'+xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; }
            }
             else if(xA.category!=''){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category);
                if (mapOfRegioncrmnth .get(xA.Category) != Null){
                temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
             if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion ){
                clusterSum = 0;
                regionSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) != prevCate ){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
            
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth.put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.subCluster);
                }
            else if (xA.Cluster != '') {
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.Cluster);
                }
            
            else if(xA.Region!='') {
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.Region);
                }
            else if(xA.category!='') {
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.category);
                }
            
           
       }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
             if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion ){
                clusterSum = 0;
                regionSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) != prevCate ){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
           
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                         
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCate= string.valueOf(ar.get('Product_Category__c'));
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.subCluster);
                }
            else if (xA.Cluster != '') {
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.Cluster);
                }
            
            else if(xA.Region!= '') {
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.Region);
                }
             else if(xA.category!= '') {
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.category);
                }
            
            
        }
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        cateSum = 0;
        
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion ){
                clusterSum = 0;
                regionSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) != prevCate ){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
            
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate= string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.subCluster);
                }
            else if (xA.Cluster != '') {
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.Cluster);
                }
            
            else if(xA.Region!= '') {
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.Region);
                }
            else if(xA.category!= '') {
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.category);
                }
            
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion ){
                clusterSum = 0;
                regionSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) != prevCate ){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
            
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c')), cateSum );
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevcate = string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category+'-'+xA.subCluster);
                }
            else if (xA.Cluster != '') {
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category+'-'+xA.Cluster);
                }
            
            else if (xA.Region!= ''){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category+'-'+xA.Region);
                }
            else if (xA.category!= ''){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.category);
                }
           
        }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Region__c,Cluster__c,Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Region__c != '' AND Year__c=: string.valueof(((system.Today().year())))  group By Product_Category__c,Region__c,cluster__c,Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        cateSum = 0;
        
        mapOfRegioncryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) == prevRegion && string.valueOf(ar.get('Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Region__c')) != prevRegion ){
                clusterSum = 0;
                regionSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) != prevCate ){
                cateSum = 0;
                regionSum = 0;
                clusterSum = 0;
            }
            
            cateSum = cateSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c')), cateSum );
               
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Cluster__c')), clusterSum);                
            
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Region__c'));
            prevCate = string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category+'-'+xA.subCluster);
                }
            else if (xA.Cluster != '') {
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category+'-'+xA.Cluster);
                }
            
            else if (xA.Region!= ''){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category+'-'+xA.Region);
                }
            else if (xA.category!= ''){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.category);
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
            else {
              if(xA.cuYearPercent!=0 && xA.cuYeartarper !=0){
               if(xA.cuYeartarper!=null)
                xA.Trendper=((xA.cuYearPercent-xA.cuYeartarper )*100/xA.cuYeartarper).setscale(2) ;}
                 else{xA.Trendper=0;}
              }
              
        }
        /**************** For Trend Calculation *****************/
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public Boolean childCluster{get;set;}
        public Boolean childsubCluster{get;set;}
        public string category{get;set;}
        public string Region{get;set;}
        public string Cluster{get;set;}
        public string subCluster{get;set;}
        public Integer preYeardata {get;set;}
        public decimal preYearPercent {get;set;}
        public decimal cuYeartarper {get;set;}
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
        
        public PQN_Global_SUWrap(String category,String Region, String Cluster, String subCluster, Boolean child, Boolean child1,Boolean child2){
            this.category= category;
            this.Region= Region;
            this.Cluster= Cluster;
            this.subCluster= subCluster;
            this.child= child;
            this.childCluster= child1;
            this.childsubCluster= child2;
            
            
        }
        
    }
    
}