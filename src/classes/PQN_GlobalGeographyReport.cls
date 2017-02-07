public without sharing class PQN_GlobalGeographyReport{
  
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
    public String empty{get;set;}
    public String cuYear{get;set;}
    public String preYear{get;set;}
    public String cuMonth{get;set;}
    public String selectedcategory{get;set;}
    public String selectedsupplier{get;set;}
    public PQN_Pallet_Quality_Non_Conformance__c pqnObj{get; set;}
       
    public Map<String,Integer> xMap{get;set;}
    public Set<String> xAxisName{get;set;}
    public Set<String> yAxisName{get;set;}
    public Set<String> yMapKeySet{get;set;}    
    public string dosingKey{get;set;}
    public string dosingLabel{get;set;}
    public List<String> listLabelFields {get;set;}
    public Map<String,String> chartLabelmap{get;set;}
    public Map<String,List<String>> chartresult{get;set;}
    public string strChartResult{get;set;}
    
    
    private void callStackChart(){
    
            List<AggregateResult> listAgg =new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c label, Supplier_Cluster__c key from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!='' AND Supplier_Cluster__c !=''  AND Year__c=:string.valueof(system.Today().year()) group By Loss_Level_2__c, Supplier_Cluster__c  Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]);
            xMap = new Map<String,Integer>();
            chartresult = new Map<String,List<String>>();
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
            chartresult = generateStackData(dosingLabel);
            strChartResult = JSON.serialize(chartresult);
            
    }
    
    private List<String> getFieldsLabel(){
        chartLabelmap = new Map<String,String>();
        String query ='';
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c), Loss_Level_2__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Year__c=\''+string.valueof(system.Today().year()) +'\' group By Loss_Level_2__c Order by Loss_Level_2__c';
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

    public Map<String,List<String>> generateStackData(String mapStr){

        Map<String,List<String>> resultsMap = new Map<String,List<String>>();        
        Map<String,Decimal> resultsMapTemp = new Map<String,Decimal>();
        Set<String> setDiag = new Set<String>();
        List<String> keyString = mapStr.split(',');
        String query ='';
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c key, Supplier_Cluster__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Supplier_Cluster__c !=\'\' AND Year__c=\''+string.valueof(system.Today().year()) +'\' group By Loss_Level_2__c, Supplier_Cluster__c Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc';
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
        return resultsMap;
      
    }
    @RemoteAction
   public Static string generateStack(){
        return 'success';
    }
     
  public List<SelectOption> getcategories(){
   
        set<string> setoptions = new set<string>();
        List<SelectOption> options=new List<SelectOption>();
        List<PQN_Pallet_Quality_Non_Conformance__c > queryResult=new List<PQN_Pallet_Quality_Non_Conformance__c >();
        queryResult=[select Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c where Product_Category__c!='' AND Year__c=:cuyear];
          setoptions.add('All');
        for(PQN_Pallet_Quality_Non_Conformance__c obj : queryResult){
           setoptions.add(obj.Product_Category__c);
        }      
        for(string s : setoptions){
           options.add(new SelectOption(s,s));
        }         

        return options;
     }
     public List<SelectOption> getsuppliers(){
   
        set<string> setoptions = new set<string>();
        List<SelectOption> options=new List<SelectOption>();
        List<PQN_Pallet_Quality_Non_Conformance__c > queryResult=new List<PQN_Pallet_Quality_Non_Conformance__c >();
        queryResult=[select Supplier__c from PQN_Pallet_Quality_Non_Conformance__c where Supplier__c!='' AND Year__c=:cuyear];
          setoptions.add('All');
        for(PQN_Pallet_Quality_Non_Conformance__c obj : queryResult){
           setoptions.add(obj.Supplier__c);
        }      
        for(string s : setoptions){
           options.add(new SelectOption(s,s));
        }         

        return options;
     }
     
   public void Searchby(){
    string filtervaluereg='';
    string filtervalueclus='';
    string filtervaluecoun='';
    string filtervaluecate='';
    string filtervaluesup='';
     
        if(pqnObj.Region__c!=null)
          filtervaluereg= pqnObj.Region__c;
        if(pqnObj.Cluster__c!=null)
          filtervalueclus= pqnObj.Cluster__c;
        if(pqnObj.DC_Country__c!=null)
          filtervaluecoun= pqnObj.DC_Country__c;
        if(selectedsupplier!='All')
          filtervaluesup= selectedsupplier;
        if(selectedcategory!='All')
          filtervaluecate= selectedcategory;
                
        report(filtervaluereg,filtervalueclus,filtervaluecoun,filtervaluecate,filtervaluesup,pqnObj.Date_Pallet_Received__c,pqnObj.Current_Month_Freeze_Date__c);  
      }

   
    public PQN_GlobalGeographyReport(){
         callStackChart();
         empty = '';
         pqnObj = new PQN_Pallet_Quality_Non_Conformance__c();
         report('','','','','',null,null);
    }
    public void report(string filtervaluereg, string filtervalueclus,string filtervaluecoun, string filtervaluecate,string filtervaluesup,Date startPallet,Date endPallet){
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
       
        cuYear = String.valueof(system.Today().year());
        preYear = String.valueof(system.Today().year() - 1);
        DateTime d = datetime.now();
        cuMonth = d.format('MMMMM');
        string cumnth=String.valueof(system.Today().month());
        
        String prevRegion='';
        String prevCluster='';
        String filterQuery='';
        Integer regionSum;
        Integer clusterSum;
        
        String LAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c where Supplier_Region__c!=null ';
        if(filtervaluereg!=''){
            filterQuery=filterQuery+' AND Supplier_Region__c=:filtervaluereg ';
        }
        if(filtervalueclus!= ''){
            filterQuery=filterQuery+' AND Supplier_Cluster__c=:filtervalueclus ';
        }
        if(filtervaluecoun!= ''){
            filterQuery=filterQuery+'AND Supplier_Country__c =:filtervaluecoun';
        }
        if(filtervaluecate!= ''){
            filterQuery=filterQuery+' AND Product_Category__c=:filtervaluecate ';
        }
        if(filtervaluesup!= ''){
            filterQuery=filterQuery+' AND Supplier__c=:filtervaluesup ';
        }
        if(startPallet!=null){
            filterQuery=filterQuery+' AND Date_Pallet_Received__c>=:startPallet ';
        }
        if(endPallet !=null){
            filterQuery=filterQuery+' AND Date_Pallet_Received__c<=:endPallet';
        }
        
       
        LAGGQuery = LAGGQuery +filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        system.debug('******'+startPallet+'***********'+endPallet+'*****'+LAGGQuery );
        List<AggregateResult> LAGG = new List<AggregateResult>();
        LAGG = Database.query(LAGGQuery);
       
        for(AggregateResult ar:LAGG){
           if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) == prevCluster){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False));
            }
            else if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'',False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False));
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),'','',True,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),'',False,True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Region__c')),string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Supplier_Country__c')),False,False));
            }
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
         }
         
         /***For Current Year SU***/
      
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        string ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:cuYear AND Supplier_type__c=\'SU\' ';       
        ListAGGQuery =ListAGGQuery + filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        List<AggregateResult> ListAGG=new List<AggregateResult>();
        ListAGG = Database.query(ListAGGQuery);
       
        List<PQN_Targets__c> listtar=new List<PQN_Targets__c>([select id,Target_Reduction__c,Region__c from PQN_Targets__c where Region__c!='' AND Year__c=:string.valueof(system.Today().year())]);
        
         for(PQN_Targets__c lt: listtar){
            mapOftarget.put(lt.Region__c,lt.Target_Reduction__c);
           } 
           
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
               
        for(AggregateResult ar:ListAGG){
            
           if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegion.put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
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
       
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:preYear AND Supplier_type__c=\'SU\' ';       
        ListAGGQuery =ListAGGQuery + filterQuery+' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
      
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
       
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegionPreYear .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            
            if(xA.Country!= '') {
              if (mapOfRegionPreYear .get(xA.Country) != Null){
                xA.preYeardata= mapOfRegionPreYear .get(xA.Country);
                 temp=Double.valueOf((mapOfRegionPreYear .get(xA.Country)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
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
        
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:cuYear AND Supplier_type__c=\'SU\' AND MonthN__c=:cumnth';       
        ListAGGQuery =ListAGGQuery + filterQuery+' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
        
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
       
        mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            
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
            
            else if (xA.Cluster != '') {
             if (mapOfRegioncrmnth .get(xA.Cluster) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Cluster);
                 temp=Double.valueOf((mapOfRegioncrmnth .get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cumnthPercent = temp.setscale(2);
                }else{xA.cumnthPercent =0;xA.cumnthdata =0;}
            }
            else if (xA.Region!= '') {
             if (mapOfRegioncrmnth .get(xA.Region) != Null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Region);
                 temp=Double.valueOf((mapOfRegioncrmnth .get(xA.Region)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                  xA.cumnthPercent = temp.setscale(2);
                }else{xA.cumnthPercent =0;xA.cumnthdata =0;}
            }
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
        
       ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:cuYear AND Supplier_type__c=\'DC\' AND MonthN__c=:cumnth';       
        /*if(filtervaluereg!=''){
            ListAGGQuery =ListAGGQuery +' AND Supplier_Region__c=:filtervaluereg ';
        }
        if(filtervalueclus!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Cluster__c=:filtervalueclus ';
        }
        if(filtervaluecoun!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Country__c =:filtervaluecoun';
        }
        if(filtervaluecate!= ''){
            ListAGGQuery =ListAGGQuery +' AND Product_Category__c=:filtervaluecate';
        }*/
        ListAGGQuery =ListAGGQuery +filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
        system.debug('aaa'+ListAGG );
        
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
       
        mapOfRegioncrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthdc .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
            system.debug('mocdc'+mapOfRegioncrmnthdc );
        }
        system.debug('mocdc'+mapOfRegioncrmnthdc );
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              system.debug('aaa'+xA.Country+mapOfRegioncrmnthdc.get(xA.Country));
               if(mapOfRegioncrmnthdc .get(xA.Country)!=null){
                 system.debug('bbb');
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Country);
                }else{ xA.cumnthdcdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthdc .get(xA.Cluster)!=Null){
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Cluster);
                }else{ xA.cumnthdcdata =0;}
              }
            
            else if (xA.Region!= '') {
                if(mapOfRegioncrmnthdc .get(xA.Region)!=Null){
                  xA.cumnthdcdata = mapOfRegioncrmnthdc .get(xA.Region);
                }else{ xA.cumnthdcdata =0;}
              }
          
        }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:cuYear AND Supplier_type__c=\'Im/Ex\' AND MonthN__c=:cumnth';       
         /*if(filtervaluereg!=''){
            ListAGGQuery =ListAGGQuery +' AND Supplier_Region__c=:filtervaluereg ';
        }
        if(filtervalueclus!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Cluster__c=:filtervalueclus ';
        }
        if(filtervaluecoun!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Country__c =:filtervaluecoun';
        }
        if(filtervaluecate!= ''){
            ListAGGQuery =ListAGGQuery +' AND Product_Category__c=:filtervaluecate';
        }*/
       ListAGGQuery =ListAGGQuery + filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
        
         prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
       
        mapOfRegioncrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
             if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthIE .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
             if (xA.Country!= '') {
               if(mapOfRegioncrmnthIE .get(xA.Country)!=null){
                  xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Country);
                }else{ xA.cumnthIEdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthIE .get(xA.Cluster)!=Null){
                  xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Cluster);
                }else{ xA.cumnthIEdata =0;}
              }
            
            else if (xA.Region!= '') {
                if(mapOfRegioncrmnthIE .get(xA.Region)!=Null){
                  xA.cumnthIEdata = mapOfRegioncrmnthIE .get(xA.Region);
                }else{ xA.cumnthIEdata =0;}
              }
          
        }
        
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
      //  xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
       ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:cuYear  AND MonthN__c=:cumnth';       
        /*if(filtervaluereg!=''){
            ListAGGQuery =ListAGGQuery +' AND Supplier_Region__c=:filtervaluereg ';
        }
        if(filtervalueclus!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Cluster__c=:filtervalueclus ';
        }
        if(filtervaluecoun!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Country__c =:filtervaluecoun';
        }
        if(filtervaluecate!= ''){
            ListAGGQuery =ListAGGQuery +' AND Product_Category__c=:filtervaluecate';
        }*/
        ListAGGQuery =ListAGGQuery +filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
         
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncrmnthtot .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
             if (xA.Country!= '') {
               if(mapOfRegioncrmnthtot .get(xA.Country)!=null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Country);
                }else{ xA.cumnthtotdata =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncrmnthtot .get(xA.Cluster)!=Null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Cluster);
                }else{ xA.cumnthtotdata =0;}
              }
            
            else if (xA.Region!= '') {
                if(mapOfRegioncrmnthtot .get(xA.Region)!=Null){
                  xA.cumnthtotdata = mapOfRegioncrmnthtot .get(xA.Region);
                }else{ xA.cumnthtotdata =0;}
              }
      
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
       
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:preYear ' ;       
        /*if(filtervaluereg!=''){
            ListAGGQuery =ListAGGQuery +' AND Supplier_Region__c=:filtervaluereg ';
        }
        if(filtervalueclus!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Cluster__c=:filtervalueclus ';
        }
        if(filtervaluecoun!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Country__c =:filtervaluecoun';
        }
        if(filtervaluecate!= ''){
            ListAGGQuery =ListAGGQuery +' AND Product_Category__c=:filtervaluecate';
        }*/
       ListAGGQuery =ListAGGQuery + filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
         prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegionprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
             if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegionprevyrtot .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));   
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              if(mapOfRegionprevyrtot .get(xA.Country)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Country);
                }else{xA.preYeardatatot =0;}
              }
            else if (xA.Cluster != '') {
              if(mapOfRegionprevyrtot .get(xA.Cluster)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Cluster);
                }else{xA.preYeardatatot =0;}
               }
            
            else if (xA.Region!= '') {
              if(mapOfRegionprevyrtot .get(xA.Region)!=Null){
                xA.preYeardatatot = mapOfRegionprevyrtot .get(xA.Region);
                }else{xA.preYeardatatot =0;}
              }
            
           }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
         
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Region__c!= \'\'  AND Year__c=:cuYear ';       
        /*if(filtervaluereg!=''){
            ListAGGQuery =ListAGGQuery +' AND Supplier_Region__c=:filtervaluereg ';
        }
        if(filtervalueclus!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Cluster__c=:filtervalueclus ';
        }
        if(filtervaluecoun!= ''){
            ListAGGQuery =ListAGGQuery +'AND Supplier_Country__c =:filtervaluecoun';
        }
        if(filtervaluecate!= ''){
            ListAGGQuery =ListAGGQuery +' AND Product_Category__c=:filtervaluecate';
        }*/
       ListAGGQuery =ListAGGQuery +filterQuery+ ' group By Supplier_Region__c,Supplier_Cluster__c,Supplier_Country__c';
        ListAGG = Database.query(ListAGGQuery);
        prevRegion = '';
        prevCluster = '';
        regionSum = 0;
        clusterSum = 0;
        
        mapOfRegioncryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
             if (string.valueOf(ar.get('Supplier_Region__c')) == prevRegion && string.valueOf(ar.get('Supplier_Cluster__c')) != prevCluster){
                clusterSum = 0;
            } 
            else if (string.valueOf(ar.get('Supplier_Region__c')) != prevRegion){
                regionSum = 0;
                clusterSum = 0;
            }
                        
            regionSum = regionSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Region__c')), regionSum);
            
            clusterSum = clusterSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusterSum);                
            
            mapOfRegioncryeartot .put(string.valueOf(ar.get('Supplier_Country__c')), integer.valueof(ar.get('expr0')));
         
            prevCluster = string.valueOf(ar.get('Supplier_Cluster__c')); 
            prevRegion = string.valueOf(ar.get('Supplier_Region__c'));
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
            if (xA.Country!= '') {
              if(mapOfRegioncryeartot .get(xA.Country)!=Null){
                 xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Country);
                }else{xA.cuYeardatatot =0;}
              }
            else if (xA.Cluster != '') {
                if(mapOfRegioncryeartot .get(xA.Cluster )!=Null){
                 xA.cuYeardatatot = mapOfRegioncryeartot .get(xA.Cluster );
                }else{xA.cuYeardatatot =0;}
              }
            
            else if (xA.Region!= '') {
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
        
        public PQN_Global_SUWrap(String Region, String Cluster,String Country, Boolean child,Boolean child1){
            this.Region= Region;
            this.Cluster= Cluster;
            this.Country= Country;
            this.child= child;
            this.childCluster= child1;
            
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