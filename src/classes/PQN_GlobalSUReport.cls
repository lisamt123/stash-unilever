public without sharing class PQN_GlobalSUReport{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
    public String cuYear{get;set;}
    public String preYear{get;set;}
    public String cuMonth{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
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
            List<AggregateResult> listAgg =new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c label, Supplier_Cluster__c key from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!='' AND Supplier_Cluster__c !='' AND Supplier_type__c='SU' AND Year__c=:string.valueof(system.Today().year())  group By Loss_Level_2__c, Supplier_Cluster__c  Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]);
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
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c), Loss_Level_2__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\'  AND Year__c=\''+string.valueof(system.Today().year()) +'\'  group By Loss_Level_2__c Order by Loss_Level_2__c';
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
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c key, Supplier_Cluster__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Supplier_Cluster__c !=\'\'  AND Supplier_type__c=\'SU\' AND Year__c=\''+string.valueof(system.Today().year()) +'\'   group By Loss_Level_2__c, Supplier_Cluster__c Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc';
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

   
    public PQN_GlobalSUReport(){
         callStackChart();
         empty = '';
         pqnObj = new PQN_Pallet_Quality_Non_Conformance__c();
         report('','','','','',null,null);
    }
    
    public void report(string filtervaluereg, string filtervalueclus,string filtervaluecoun, string filtervaluecate,string filtervaluesup,Date startPallet,Date endPallet){
 
    
            empty = '';
            xSUWRAPLIST = new List<PQN_Global_SUWrap>();
            xChartdata = new List<PQN_chart>();
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
             cuYear = string.valueof(system.Today().year());
             preYear = string.valueof(system.Today().year() - 1);
             DateTime d = datetime.now();
             cuMonth = d.format('MMMMM');
             string cumnth=String.valueof(system.Today().month());
             
             String prevCluster = '';
             Integer ClusterSum;
             String filterQuery='';
             
              String LAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c where Supplier_Cluster__c!=null ';
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
        
       
        LAGGQuery = LAGGQuery +filterQuery+ ' group By Supplier_Cluster__c,Supplier__c';
        system.debug('******'+startPallet+'***********'+endPallet+'*****'+LAGGQuery );
        List<AggregateResult> LAGG = new List<AggregateResult>();
        LAGG = Database.query(LAGGQuery);
                  
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
        
        string ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= \'\'  AND Year__c=:cuYear AND Supplier_type__c=\'SU\' ';       
        ListAGGQuery =ListAGGQuery + filterQuery+ ' group By Supplier_Cluster__c,Supplier__c';
        List<AggregateResult> ListAGG=new List<AggregateResult>();
        ListAGG = Database.query(ListAGGQuery);
      
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
            else if(xA.Cluster!=''){
               if (mapOfCluster.get(xA.Cluster) != Null){
                  xA.cuYeardata = mapOfCluster.get(xA.Cluster);
                  temp = Double.valueOf((mapOfCluster.get(xA.Cluster)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                xA.cuYearPercent= temp.setscale(2);
                }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
         
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= \'\'  AND Year__c=:preYear AND Supplier_type__c=\'SU\' ';       
        ListAGGQuery =ListAGGQuery + filterQuery+' group By Supplier_Cluster__c,Supplier__c';
        ListAGG = Database.query(ListAGGQuery);
        
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
            else if(xA.Cluster!=''){
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
        
        ListAGGQuery = 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Supplier__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c!= \'\'  AND Year__c=:cuYear AND Supplier_type__c=\'SU\' AND MonthN__c=:cumnth';       
        ListAGGQuery =ListAGGQuery + filterQuery+' group By Supplier_Cluster__c,Supplier__c';
        ListAGG = Database.query(ListAGGQuery);
        
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
            else if(xA.Cluster!='') {
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