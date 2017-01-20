public without sharing class PQN_Global_Overview_Geography{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
    public Integer cuYear{get;set;}
    public Integer preYear{get;set;}
    public String cuMonth{get;set;}
    
    public Map<String,Integer> xMap{get;set;}
    public Set<String> xAxisName{get;set;}
    public Set<String> yAxisName{get;set;}
    public Set<String> yMapKeySet{get;set;}
    
    public string dosingKey{get;set;}
    public string dosingLabel{get;set;}
    public List<String> listLabelFields {get;set;}
    public Map<String,String> chartLabelmap{get;set;}
    public Map<String,List<String>> chartresult{get;set;}
    
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
    private void callStackChart(){
    
            List<AggregateResult> listAgg =new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c label, Supplier_Cluster__c key from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!='' AND Supplier_Cluster__c !='' AND Year__c=:string.valueof(system.Today().year()) group By Loss_Level_2__c, Supplier_Cluster__c  Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc limit 50000]);
            xMap = new Map<String,Integer>();
            xAxisName = new Set<String>();
            yAxisName = new Set<String>();
            yMapKeySet = new Set<String>();
            for( AggregateResult xA : listAgg ){
                xMap.put((String) xA.get('key')+''+(String) xA.get('label'),Integer.valueOf((Decimal) xA.get('cnt')));
                xAxisName.add((String) xA.get('label'));
                yAxisName.add((String) xA.get('key'));
            }
            yMapKeySet = xMap.keySet();
            listLabelFields = getFieldsLabel();
            dosingKey= listLabelFields[0];
            dosingLabel= listLabelFields[1];
            //chartresult = generateStackData(dosingLabel);
    }
    
    private List<String> getFieldsLabel(){
        chartLabelmap = new Map<String,String>();
        String query ='';
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c), Loss_Level_2__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Year__c=\''+string.valueof(system.Today().year())+'\' group By Loss_Level_2__c Order by Loss_Level_2__c';
        List<String> fields =new List<String>();
        String Key='';
        String label='';
        Integer i=0;
        system.debug(query);
        list<AggregateResult> result = Database.query(query);
        system.debug('result--------->>>>'+result);
        for(AggregateResult xP : result){
                        
            Key += ','+i;
            if((String) xP.get('label')==null || (String) xP.get('label')==''){
                label+= ',Other';
            }else{
                label+= ','+ (String) xP.get('label');
            }
            
            i++;
            
        }
        system.debug('Key%%---'+Key);
        system.debug('Label%%--'+Label);
        if(key.length()>0){
            Key = key.subString(1,key.length());
        }
        if(label.length()>0){
            label= label.subString(1,label.length());
        }

        fields.add(Key);
        fields.add(Label);
        
        
        return fields;
    
    }
    @RemoteAction
    public static Map<String,List<String>> generateStackData(String mapStr){
        system.debug(mapStr);
        Map<String,List<String>> resultsMap = new Map<String,List<String>>();        
        Map<String,Decimal> resultsMapTemp = new Map<String,Decimal>();
        Set<String> setDiag = new Set<String>();
        List<String> keyString = mapStr.split(',');
        String query ='';
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c key, Supplier_Cluster__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Supplier_Cluster__c !=\'\' AND Year__c=\''+string.valueof(system.Today().year())+'\' group By Loss_Level_2__c, Supplier_Cluster__c Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc limit 50000';
        Decimal totalcount = 0;
        list<AggregateResult> result = Database.query(query);
        
        for(AggregateResult xP : result){
               String gVallabel=(String) xP.get('label');
               if(gVallabel=='' || gVallabel==null){
                   gVallabel='Other';
               }
             
             setDiag.add(gVallabel);
             String s='';
             if((String) xP.get('key')=='' || (String) xP.get('key')==null){
                s='Other';
             }else{
                s=(String) xP.get('key');
             }
            resultsMapTemp.put(gVallabel+'_'+s, (Decimal) xP.get('cnt'));
             
         }
        system.debug('&&&&%%%%%'+resultsMapTemp);
        for(String sX : setDiag){
            List<String> strList = new List<String>();
            Decimal i =0;
            for(String xC: keyString){
                   
                Decimal data =0;
                data=resultsMapTemp.get(sX+'_'+xC);
                if(data==null){
                 data=0;
                }
                totalcount+=data;                
                String keyVal ='MD_'+i+'MD_:'+data;
                strList.add(keyVal);   
               
                i++;
           } 
           
           resultsMap.put(sX,strList);
        }
        
        List<String> strList2 = new List<String>();
        String total =String.valueOf(totalcount);
        strList2.add(total);
        resultsMap.put('TOTAL_MD_RESULT',strList2); 
        system.debug('---->>'+resultsMap);       
        return resultsMap;
      
    }
   
    
    public PQN_Global_Overview_Geography(ApexPages.StandardController acon){
    
        callStackChart();
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
            cuYear = integer.valueof(system.Today().year());
            preYear = integer.valueof(system.Today().year()) - 1;
            DateTime d = datetime.now();
            cuMonth = d.format('MMMMM');             
              String prevRegion = '';
              Integer regionSum;
            /*for(AggregateResult xD:[select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= '' group By Supplier_Cluster__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc ])
            {
                if(integer.valueof(xD.get('expr0'))!=null){
                    xChartdata.add(new PQN_chart(String.valueOf(xD.get('Supplier_Cluster__c')),integer.valueof(xD.get('expr0'))));
                }
    
            }*/
             
              List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != ''  group By Supplier_Region__c,Supplier_Cluster__c]);
               xSUWRAPLIST.add(new PQN_Global_SUWrap('Global','','',True,True));
        
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap('Global',string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),False,False));
            }
            else if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               xSUWRAPLIST.add(new PQN_Global_SUWrap('Global',string.valueOf(ar.get('Supplier_Region__c')),'',False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap('Global',string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),False,False));
               
            }
             prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        } 
      
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Supplier_Region__c,Supplier_Cluster__c]);
       
        List<PQN_Targets__c> listtar=new List<PQN_Targets__c>([select id,Target_Reduction__c,Region__c from PQN_Targets__c where Region__c!='' AND Year__c=:string.valueof(system.Today().year())]);
        
         for(PQN_Targets__c lt: listtar){
            mapOftarget.put(lt.Region__c,lt.Target_Reduction__c);
           } 
     
        prevRegion = '';
        regionSum = 0;
        integer total=0;
      
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
              regionSum = 0;
            } 
                                  
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegion.put('',total);
          
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
                
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if(mapOftarget.get(xA.Region)!=null){
                 xA.cuYeartarper = mapOftarget.get(xA.Region);
                }else{xA.cuYeartarper =0;} 
                
             if(xA.Region== '' && xA.Cluster == ''){
               xA.cuYeardata =mapOfRegion.get('');
               xA.cuYearPercent=(mapOfRegion.get('')*100)/integer.valueOf(xPSU[0].get('totalshipped'));
               xA.cuYeartarper =0;
              }
            else if (xA.Cluster != '') {
            if (mapOfRegion.get(xA.Cluster) != Null){
                 xA.cuYeardata = mapOfRegion.get(xA.Cluster);
                 temp = Double.valueOf((mapOfRegion.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            else if(xA.Region!= ''){
              if (mapOfRegion.get(xA.Region) != Null){
                xA.cuYeardata = mapOfRegion.get(xA.Region);
                temp = Double.valueOf((mapOfRegion.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
         total=0;
              
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
                       
            mapOfRegionPreYear.put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put('', total);
           
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
              if(xA.Region== '' && xA.Cluster == ''){
               xA.preYeardata =mapOfRegionPreYear.get('');
               xA.preYearPercent =(mapOfRegionPreYear.get('')*100)/integer.valueOf(xPSU[0].get('totalshipped'));
              }
          
            else if (xA.Cluster != '') {
              if (mapOfRegionPreYear.get(xA.Cluster) != Null){
                xA.preYeardata = mapOfRegionPreYear.get(xA.Cluster);
                  temp = Double.valueOf((mapOfRegionPreYear.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; xA.preYeardata =0;}
            }
            else if(xA.Region!= ''){
              if (mapOfRegionPreYear.get(xA.Region) != Null){
                 xA.preYeardata = mapOfRegionPreYear.get(xA.Region);
                   temp = Double.valueOf((mapOfRegionPreYear.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0; }
            }
            
          
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
        total=0;
      
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
         if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
           
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put('', total);
            
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if(xA.Region== '' && xA.Cluster == ''){
               xA.cumnthdata=mapOfRegioncrmnth.get('');
               xA.cumnthPercent =(mapOfRegioncrmnth.get('')*100)/integer.valueOf(xPSU[0].get('totalshipped'));
              }
          
             else if (xA.Cluster != '') {
               if (mapOfRegioncrmnth .get(xA.Cluster) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Cluster);
                   temp = Double.valueOf((mapOfRegioncrmnth .get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; xA.cumnthdata = 0;}
            }
            else if(xA.Region!= ''){
              if (mapOfRegioncrmnth .get(xA.Region) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Region);
                  temp = Double.valueOf((mapOfRegioncrmnth.get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; xA.cumnthdata = 0;}
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
          
       xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
        total=0;
      
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
          if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
        
            mapOfRegioncrmnthdc.put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc.put('', total);
            
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
             if(xA.Region== '' && xA.Cluster == ''){
               xA.cumnthdcdata=mapOfRegioncrmnthdc.get('');
             }
         
            else if (xA.Cluster != '') {
              if(mapOfRegioncrmnthdc .get(xA.Cluster)!=null){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Cluster);
                }else{xA.cumnthdcdata =0;}
             }
            
            else if(xA.Region!= ''){
                if(mapOfRegioncrmnthdc .get(xA.Region)!=null){
                xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Region);
                }else{xA.cumnthdcdata =0;}
             }
           
        }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
        total=0;
       
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
           if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put('', total);
          
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
             if(xA.Region== '' && xA.Cluster == ''){
               xA.cumnthIEdata =mapOfRegioncrmnthIE .get('');
             }
             else if (xA.Cluster != '') {
               if(mapOfRegioncrmnthIE .get(xA.Cluster)!=null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Cluster);
                }else{xA.cumnthIEdata = 0;}
              }
            
            else if(xA.Region!= ''){
                 if(mapOfRegioncrmnthIE .get(xA.Region)!=null){
                xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Region);
                }else{xA.cumnthIEdata = 0;}
             }
         
        }
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
        total=0;
       
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put('', total);
        
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
             if(xA.Region== '' && xA.Cluster == ''){
               xA.cumnthtotdata =mapOfRegioncrmnthtot .get('');
             }
         
            else if (xA.Cluster != '') {
              if(mapOfRegioncrmnthtot .get(xA.Cluster)!=null){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Cluster);
                }else{xA.cumnthtotdata = 0;}
             }
            
            else if(xA.Region!= ''){
                if(mapOfRegioncrmnthtot .get(xA.Region)!=null){
                xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Region);
                }else{xA.cumnthtotdata = 0;}
             }
           
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
        total=0;
             
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
       if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }       
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
          
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put('', total);
            
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
         if(xA.Region== '' && xA.Cluster == ''){
               xA.preYeardatatot =mapOfRegionprevyrtot .get('');
             }
         
            else if (xA.Cluster != '') {
              if(mapOfRegionprevyrtot .get(xA.Cluster)!=null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Cluster);
                }else{xA.preYeardatatot =0;}
             }
            
            else if(xA.Region!= ''){
                if(mapOfRegionprevyrtot .get(xA.Region)!=null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Region);
                }else{xA.preYeardatatot =0;}
             }
            
          
        }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c != '' AND Year__c=: string.valueof(((system.Today().year())))  group By Supplier_Region__c,Supplier_Cluster__c]);
        
        prevRegion = '';
        regionSum = 0;
        total=0;
        mapOfRegioncryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
           if (string.valueOf(ar.get('Supplier_Region__c'))!=prevRegion ){
               
                regionSum = 0;
            }   
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
         
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Cluster__c')), integer.valueof(ar.get('expr0')));
            total=total+integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put('', total);
          
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
             if(xA.Region== '' && xA.Cluster == ''){
               xA.cuYeardatatot =mapOfRegioncryeartot .get('');
             }
        
            else if (xA.Cluster != '') {
              if( mapOfRegioncryeartot .get(xA.Cluster)!=null){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Cluster);
                }else{xA.cuYeardatatot =0;}
             }
            
            else if(xA.Region!= ''){
                if( mapOfRegioncryeartot .get(xA.Region)!=null){
                xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Region);
                }else{xA.cuYeardatatot =0;}
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
        public Boolean child1{get;set;}
        public string Glo{get;set;}
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
        
        public PQN_Global_SUWrap(string Glo,String Region, String Cluster, Boolean child,Boolean child1){
            this.Region= Region;
            this.Cluster= Cluster;
            this.child= child;
            this.Glo=Glo;
            this.child1= child1;
           
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