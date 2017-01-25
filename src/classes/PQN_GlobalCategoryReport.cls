public without sharing class PQN_GlobalCategoryReport{
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
      public List<PQN_chart> xChartdata{get;set;}
    public String empty{get;set;}
     public Integer cuYear{get;set;}
    public Integer preYear{get;set;}
    public String cuMonth{get;set;}
    public List<PQN_Pallet_Quality_Non_Conformance__c> PQNList{get;set;}
    
    public PQN_GlobalCategoryReport(){
        // for previous year SU NC group by cluster and subcluster
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
        xChartdata= new List<PQN_chart>();
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
        
        String prevCate = '';
        String prevRegion = '';
        String prevCluster = '';
        Integer cateSum;
        Integer regionSum;
        Integer clusterSum;
        //for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Supplier_Region__cfrom PQN_Pallet_Quality_Non_Conformance__c where Supplier_Region__c!=''  group By Supplier_Supplier_Region__corder by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc])
        /*for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c !='' group By Product_Category__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]){ 
            
                xChartdata.add(new PQN_chart(String.valueOf(xD.get('Product_Category__c')),integer.valueOf(xD.get('expr0'))));

        }*/
        List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c !='' AND Supplier_Region__c!='' AND (Year__c=:string.valueOf(cuYear) OR Year__c=:string.valueOf(preYear)) group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
      
         for(AggregateResult ar:LAGG){
                   
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),False,False,False));
            }
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),False,False,False));
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),'','',False,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),False,False,False));
            }
            else if(string.valueOf(ar.get('Product_Category__c')) != prevCate){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),'','','',True,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),'','',False,True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'',False,False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Category__c')),string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Sub_Cluster__c')),False,False,False));
            }
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
         }
        
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c !=''  AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
    
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
                   
          if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
              
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
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegion.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
         
        }
        
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if(mapOftarget.get(xA.Region)!=null){
                   xA.cuYeartarper=mapOftarget.get(xA.Region);
                 }else{xA.cuYeartarper =0;}
                 
            if (xA.subCluster != '') {
            if(mapOfRegion.get(xA.Category+'-'+xA.subCluster)!=Null){
                 xA.cuYeardata = mapOfRegion.get(xA.Category+'-'+xA.subCluster);
                 temp= Double.valueOf((mapOfRegion.get(xA.Category+'-'+xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0; xA.cuYeardata =0;}
            }
            else if (xA.Cluster != '') {
            if((mapOfRegion.get(xA.Category+'-'+xA.Cluster))!=Null){
                xA.cuYeardata = mapOfRegion.get(xA.Category+'-'+xA.Cluster);
                 temp= Double.valueOf((mapOfRegion.get(xA.Category+'-'+xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            else if(xA.Region != ''){
             if((mapOfRegion.get(xA.Category+'-'+xA.Region))!=Null){
                 xA.cuYeardata = mapOfRegion.get(xA.Category+'-'+xA.Region);
                 temp= Double.valueOf((mapOfRegion.get(xA.Category+'-'+xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
           else if(xA.category!=''){
            if(mapOfRegion.get(xA.Category)!=Null){
                xA.cuYeardata = mapOfRegion.get(xA.Category);
                temp = Double.valueOf((mapOfRegion.get(xA.Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{ xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            
           
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year() - 1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c != '' AND Year__c=: string.valueof(((system.Today().year())) - 1) AND Supplier_type__c='SU' group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        prevcate='';
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        cateSum = 0;
        
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
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
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegionPreYear.put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
             if (mapOfRegionPreYear.get(xA.Category+'-'+xA.subCluster) != Null){
               xA.preYeardata = mapOfRegionPreYear.get(xA.Category+'-'+xA.subCluster);
                 temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category+'-'+xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; xA.preYeardata =0; }
            }
            else if (xA.Cluster != '') {
            if (mapOfRegionPreYear.get(xA.Category+'-'+xA.Cluster) != Null){
                xA.preYeardata = mapOfRegionPreYear.get(xA.Category+'-'+xA.Cluster);
                  temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category+'-'+xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0; }
            }
            else if(xA.Region!=''){
            if (mapOfRegionPreYear.get(xA.Category+'-'+xA.Region) != Null){
                 xA.preYeardata = mapOfRegionPreYear.get(xA.Category+'-'+xA.Region);
                   temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category+'-'+xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0;  }
                }
                
            else if(xA.category!=''){
            if (mapOfRegionPreYear.get(xA.Category) != Null){
                xA.preYeardata = mapOfRegionPreYear.get(xA.Category);
                  temp = Double.valueOf((mapOfRegionPreYear.get(xA.Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0;  }
            }
          
            
            
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        
        prevcate='';
        prevRegion = '';
        prevCluster = '';
        cateSum =0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
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
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
             if (mapOfRegioncrmnth .get(xA.Category+'-'+xA.subCluster) != Null){
               xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category+'-'+xA.subCluster);
                 temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Category+'-'+xA.subCluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata =0; }
            }
            else if (xA.Cluster != '') {
             if (mapOfRegioncrmnth .get(xA.Category+'-'+xA.Cluster) != Null){
               xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category+'-'+xA.Cluster);
                temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Category+'-'+xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata =0; }
            }
            else if(xA.Region!=''){
             if (mapOfRegioncrmnth .get(xA.Category+'-'+xA.Region) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category+'-'+xA.Region);
                   temp = Double.valueOf((mapOfRegioncrmnth.get(xA.Category+'-'+xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata =0; }
            }
            else if(xA.category!=''){
              if (mapOfRegioncrmnth .get(xA.Category) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Category);
                temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cumnthPercent = temp.setscale(2);
                } else { xA.cumnthPercent = 0;xA.cumnthdata =0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
             if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
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
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate =string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
              if( mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.subCluster)!=null){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.subCluster);
                }else{xA.cumnthdcdata = 0;}
              }
            else if (xA.Cluster != '') {
              if( mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.Cluster )!=null){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.Cluster );
                }else{xA.cumnthdcdata = 0;}    
              }
            
            else if(xA.Region!='') {
                if( mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.Region)!=null){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category+'-'+xA.Region);
                }else{xA.cumnthdcdata = 0;}
              }
            else if(xA.category!='') {
                if( mapOfRegioncrmnthdc .get(xA.Category)!=null){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Category);
                }else{xA.cumnthdcdata = 0;}
              }
            
           
       }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
             if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
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
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCate= string.valueOf(ar.get('Product_Category__c'));
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
              if(mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.subCluster)!=null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.subCluster);
                }else{ xA.cumnthIEdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.Cluster )!=null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.Cluster );
                }else{ xA.cumnthIEdata =0;}
              }
            
            else if(xA.Region!= '') {
                if(mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.Region)!=null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category+'-'+xA.Region);
                }else{ xA.cumnthIEdata =0;}
              }
             else if(xA.category!= '') {
                if(mapOfRegioncrmnthIE .get(xA.Category)!=null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Category);
                }else{ xA.cumnthIEdata =0;}
              }
            
            
        }
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        cateSum = 0;
        
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
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
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate= string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
              if(mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.subCluster)!=null){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.subCluster);
                }else{xA.cumnthtotdata =0;}
              }
            else if (xA.Cluster != '') {
               if(mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.Cluster )!=null){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.Cluster );
                }else{xA.cumnthtotdata =0;}
              }
            
            else if(xA.Region!= '') {
                if(mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.Region)!=null){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category+'-'+xA.Region);
                }else{xA.cumnthtotdata =0;}
              }
            else if(xA.category!= '') {
                if(mapOfRegioncrmnthtot .get(xA.Category)!=null){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Category);
                }else{xA.cumnthtotdata =0;}
              }
            
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        cateSum = 0;
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
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
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevcate = string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
              if(mapOfRegionprevyrtot .get(xA.Category+'-'+xA.subCluster)!=null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category+'-'+xA.subCluster);
                }else{xA.preYeardatatot =0;}
             }
            else if (xA.Cluster != '') {
                if(mapOfRegionprevyrtot .get(xA.Category+'-'+xA.Cluster )!=null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category+'-'+xA.Cluster );
                }else{xA.preYeardatatot =0;}
             }
            
            else if (xA.Region!= ''){
                if(mapOfRegionprevyrtot .get(xA.Category+'-'+xA.Region)!=null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category+'-'+xA.Region);
                }else{xA.preYeardatatot =0;}
             }
            else if (xA.category!= ''){
                if(mapOfRegionprevyrtot .get(xA.Category)!=null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Category);
                }else{xA.preYeardatatot =0;}
             }
           
        }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= '' AND Year__c=: string.valueof(((system.Today().year())))  group By Product_Category__c,Supplier_Region__c,Supplier_Cluster__c,Supplier_Sub_Cluster__c]);
        
        prevCate='';
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        cateSum = 0;
        
        mapOfRegioncryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Product_Category__c')) == prevCate && string.valueOf(ar.get('Supplier_Region__c')) != prevRegion ){
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
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Product_Category__c'))+'-'+string.valueOf(ar.get('Supplier_Sub_Cluster__c')), integer.valueof(ar.get('expr0')));
            
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            prevCate = string.valueOf(ar.get('Product_Category__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.subCluster != '') {
             if( mapOfRegioncryeartot .get(xA.Category+'-'+xA.subCluster)!=null){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category+'-'+xA.subCluster);
                }else{xA.cuYeardatatot =0;}
             }
            else if (xA.Cluster != '') {
                if( mapOfRegioncryeartot .get(xA.Category+'-'+xA.Cluster )!=null){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category+'-'+xA.subCluster);
                }else{xA.cuYeardatatot =0;}
             }
            
            else if (xA.Region!= ''){
                if( mapOfRegioncryeartot .get(xA.Category+'-'+xA.Region)!=null){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category+'-'+xA.Region);
                }else{xA.cuYeardatatot =0;}
             }
            else if (xA.category!= ''){
               if( mapOfRegioncryeartot .get(xA.Category)!=null){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Category);
                }else{xA.cuYeardatatot =0;}
             }
            
           
       }
        
        /************************* For Current Month DC Data ****************************/
         /************************* For Trend Calculation ************************/
         
         for(PQN_Global_SUWrap xA: xSUWRAPLIST){
         
             if(xA.cuYeartarper ==0 || xA.cuYeartarper ==null){
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
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
             if(xA.child)
             xChartdata.add(new PQN_chart(xA.category,xA.cuYeardata ,xA.Trendper));

         }
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
        public decimal cuYearPercent {get;set;}
        public Integer cumnthdata {get;set;}
        public decimal cumnthPercent {get;set;}
        public Integer cumnthdcdata {get;set;}
        public Integer cumnthIEdata {get;set;}
        public Integer cumnthtotdata {get;set;}
        public Integer preYeardatatot {get;set;}
        public Integer cuYeardatatot {get;set;}
        public decimal Trendper{get;set;}
        
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
    
     public class PQN_chart{
        
        public String chartXAxis{get;set;}
        public Integer chartdata {get;set;}
        public decimal linedata {get;set;}
                
        public PQN_chart( String chartXAxis,integer chartdata, decimal linedata){
            this.chartXAxis= chartXAxis;
            this.chartdata= chartdata;
            this.linedata= linedata;
            
                     
        }
        
    }
}