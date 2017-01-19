public without sharing class PQN_Global_Overview_Category_Report{
   
    public List<PQN_Global_SUWrap> xSUWRAPLISTGC{get;set;}
    public String empty{get;set;}
    public String tarval{get;set;}
    public List<PQN_chart> xChartdata1{get;set;}
    
    public Map<String,Integer> xMapCAT{get;set;}
    public Set<String> xMapCATKey{get;set;}
    public Set<String> xLOSS {get;set;}
    public Set<String> xCAT {get;set;}
    
    
    public string catKey{get;set;}
    public string catLabel{get;set;}
    public List<String> listLabelCatFields {get;set;}
    public Map<String,String> chartCatLabelmap{get;set;}
    public Map<String,List<String>> chartCatresult{get;set;}
    
    
     private void callCatStackChart(){
            List<AggregateResult> listAgg =new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c label, Product_Group__c key from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!='' AND Product_Group__c!='' AND Year__c=:string.valueof(system.Today().year()) group By Loss_Level_2__c, Product_Group__c Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc limit 50000]);
            xMapCAT = new Map<String,Integer>();
            xLOSS = new Set<String>();
            xCAT= new Set<String>();
            xMapCATKey = new Set<String>();
            for( AggregateResult xA : listAgg ){
                xMapCAT.put((String) xA.get('key')+''+(String) xA.get('label'),Integer.valueOf((Decimal) xA.get('cnt')));
                xLOSS.add((String) xA.get('label'));
                xCAT.add((String) xA.get('key'));
            }
            xMapCATKey =xMapCAT.keySet();
            listLabelCatFields = getFieldsLabel2();
            catKey= listLabelCatFields[0];
            catLabel= listLabelCatFields[1];
            //chartresult = generateCatStackData(catLabel);
    }
    
    private List<String> getFieldsLabel2(){
        chartCatLabelmap= new Map<String,String>();
        String query ='';
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c), Loss_Level_2__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Year__c=\''+string.valueof(system.Today().year())+'\' group By Loss_Level_2__c';
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
    public static Map<String,List<String>> generateCatStackData(String mapStr){
        system.debug(mapStr);
        Map<String,List<String>> resultsMap = new Map<String,List<String>>();        
        Map<String,Decimal> resultsMapTemp = new Map<String,Decimal>();
        Set<String> setDiag = new Set<String>();
        List<String> keyString = mapStr.split(',');
        String query ='';
        query += 'select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) cnt, Loss_Level_2__c key, Product_Group__c label from PQN_Pallet_Quality_Non_Conformance__c where Loss_Level_2__c!=\'\' AND Product_Group__c !=\'\' AND Year__c=\''+string.valueof(system.Today().year())+'\' group By Loss_Level_2__c, Product_Group__c Order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc limit 50000';
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
    
    
     public PQN_Global_Overview_Category_Report(ApexPages.StandardController acon){
        callCatStackChart();
        empty = '';
        tarval='n.a';
        xChartdata1 = new List<PQN_chart>();
        xSUWRAPLISTGC = new List<PQN_Global_SUWrap>();
        Map<String,Integer> mapOfProduct_Groupcuryr= new Map<String,Integer>();
        Map<String,Integer> mapOfProduct_GroupPreYear = new Map<String,Integer>();
        Map<String,Integer> mapOfProduct_Groupcrmnth = new Map<String,Integer>();
         Map<String,Integer> mapOfProduct_Groupcrmnthdc = new Map<String,Integer>();
         Map<String,Integer> mapOfProduct_GroupcrmnthIE = new Map<String,Integer>();
         Map<String,Integer> mapOfProduct_Groupcrmnthtot = new Map<String,Integer>();
         Map<String,Integer> mapOfProduct_Groupprevyrtot = new Map<String,Integer>();
         Map<String,Integer> mapOfProduct_Groupcryeartot = new Map<String,Integer>();
        
        
         String prevProduct_Group = '';
         Integer Product_GroupSum;
         
        /*for(AggregateResult xD:[select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Category__c!= '' group By Product_Category__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc ])
        {
            if(integer.valueof(xD.get('expr0'))!=null){
                xChartdata1.add(new PQN_chart(String.valueOf(xD.get('Product_Category__c')),integer.valueof(xD.get('expr0'))));
            }
        
        }*/
          
         List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' group By Product_Group__c,Product_Category__c]);
      
              
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Product_Group__c')) == prevProduct_Group){
                 xSUWRAPLISTGC.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Group__c')),string.valueOf(ar.get('Product_Category__c')),False));
            }
            else if (string.valueOf(ar.get('Product_Group__c'))!=prevProduct_Group ){
                xSUWRAPLISTGC.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Group__c')),'',True));
                xSUWRAPLISTGC.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Group__c')),string.valueOf(ar.get('Product_Category__c')),False));
            } 
                prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
         }
       
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='SU' group By Product_Group__c,Product_Category__c]);
      
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
              
        for(AggregateResult ar:ListAGG){
            
           if (string.valueOf(ar.get('Product_Group__c'))!=prevProduct_Group ){
                 Product_GroupSum = 0;
            } 
                                  
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupcuryr.put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
            
            mapOfProduct_Groupcuryr.put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
           
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
      
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
          
            if (xA.Product_Group+xA.Product_Category != '') {
               if (mapOfProduct_Groupcuryr.get(xA.Product_Group+xA.Product_Category) != Null){
                xA.cuYeardata = mapOfProduct_Groupcuryr.get(xA.Product_Group+xA.Product_Category);
                 temp = Double.valueOf((mapOfProduct_Groupcuryr.get(xA.Product_Group+xA.Product_Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
               }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
            else {
             if (mapOfProduct_Groupcuryr.get(xA.Product_Group) != Null){
               xA.cuYeardata = mapOfProduct_Groupcuryr.get(xA.Product_Group);
                temp = Double.valueOf((mapOfProduct_Groupcuryr.get(xA.Product_Group)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
               }else{xA.cuYearPercent=0;xA.cuYeardata =0;}
            }
          
        }          
        
        
        /************************* For Previous Year Data ****************************/
        
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year()-1))) AND Supplier_type__c='SU' group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
      
        mapOfProduct_GroupPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
           if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
            }
                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_GroupPreYear.put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
          
            mapOfProduct_GroupPreYear.put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
            
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
           
             if (xA.Product_Group+xA.Product_Category != '') {
             if (mapOfProduct_GroupPreYear.get(xA.Product_Group+xA.Product_Category) != Null){
                 xA.preYeardata = mapOfProduct_GroupPreYear.get(xA.Product_Group+xA.Product_Category);
                  temp = Double.valueOf((mapOfProduct_GroupPreYear.get(xA.Product_Group+xA.Product_Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0; }
            }
            else {
                xA.preYeardata = mapOfProduct_GroupPreYear.get(xA.Product_Group);
                if (mapOfProduct_GroupPreYear.get(xA.Product_Group) != Null){
                    temp = Double.valueOf((mapOfProduct_GroupPreYear.get(xA.Product_Group)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.preYeardata =0; }
            }
          
        }
        
        /************************* For Previous Year Data ****************************/
        
        /************************* For Current Month Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year()))) AND Supplier_type__c='SU' and MonthN__c=:string.valueof(system.Today().month()) group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
      
        mapOfProduct_Groupcrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
         
            if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
               }
                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupcrmnth .put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
          
            mapOfProduct_Groupcrmnth .put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
          
           prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
           
             if (xA.Product_Group+xA.Product_Category != '') {
              if (mapOfProduct_Groupcrmnth .get(xA.Product_Group+xA.Product_Category) != Null){
                xA.cumnthdata = mapOfProduct_Groupcrmnth .get(xA.Product_Group+xA.Product_Category);
                 temp = Double.valueOf((mapOfProduct_Groupcrmnth .get(xA.Product_Group+xA.Product_Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.cumnthdata =0; }
            }
            else {
            if (mapOfProduct_Groupcrmnth .get(xA.Product_Group) != Null){
                xA.cumnthdata = mapOfProduct_Groupcrmnth .get(xA.Product_Group);
                  temp = Double.valueOf((mapOfProduct_Groupcrmnth.get(xA.Product_Group)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0;xA.cumnthdata =0; }
            }
            
         }
        
        /************************* For Current Month Data ****************************/
        /************************* For Current Month DC Data ****************************/
          
       xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
       
        mapOfProduct_Groupcrmnthdc = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
       
             if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
              }
                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupcrmnth .put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
       
            mapOfProduct_Groupcrmnth .put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
          
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
       
            if (xA.Product_Group+xA.Product_Category != '') {
              if( mapOfProduct_Groupcrmnthdc .get(xA.Product_Group+xA.Product_Category)!=null){
                 xA.cumnthdcdata = mapOfProduct_Groupcrmnthdc .get(xA.Product_Group+xA.Product_Category);
                }else{xA.cumnthdcdata =0;}
             }
            
            else {
                if( mapOfProduct_Groupcrmnthdc .get(xA.Product_Group)!=null){
                 xA.cumnthdcdata = mapOfProduct_Groupcrmnthdc .get(xA.Product_Group);
                }else{xA.cumnthdcdata =0;}
             }
          
        }
        
        /************************* For Current Month DC Data ****************************/
        /************************* For Current Month Im/Ex Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='Im/Ex' group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
     
        
        mapOfProduct_GroupcrmnthIE = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
         
             if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
               }
                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_GroupcrmnthIE .put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
                  
            mapOfProduct_GroupcrmnthIE .put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
            
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
        
             if (xA.Product_Group+xA.Product_Category != '') {
               if(mapOfProduct_GroupcrmnthIE .get(xA.Product_Group+xA.Product_Category)!=null){
                xA.cumnthIEdata = mapOfProduct_GroupcrmnthIE .get(xA.Product_Group+xA.Product_Category);
                }else{xA.cumnthIEdata = 0;}
             }
            
            else {
                 if(mapOfProduct_GroupcrmnthIE .get(xA.Product_Group)!=null){
                xA.cumnthIEdata = mapOfProduct_GroupcrmnthIE .get(xA.Product_Group);
                }else{xA.cumnthIEdata =0;}
             }
        
        }
        
        /************************* For Current Month Im/Ex Data ****************************/
        /************************* For Current Month Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()) and Month__c=:string.valueof(system.Today().month()) group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year()))) and MonthN__c=:string.valueof(system.Today().month())  group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
     
        mapOfProduct_Groupcrmnthtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
               }
                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupcrmnthtot .put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
         
            mapOfProduct_Groupcrmnthtot .put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
        
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
          
            if (xA.Product_Group+xA.Product_Category != '') {
              if(mapOfProduct_Groupcrmnthtot .get(xA.Product_Group+xA.Product_Category)!=null){
                xA.cumnthtotdata = mapOfProduct_Groupcrmnthtot .get(xA.Product_Group+xA.Product_Category);
                }else{xA.cumnthtotdata =0;}
             }
            
            else {
                 if(mapOfProduct_Groupcrmnthtot .get(xA.Product_Group)!=null){
                xA.cumnthtotdata = mapOfProduct_Groupcrmnthtot .get(xA.Product_Group);
                }else{xA.cumnthtotdata =0;}
             }
           
        }
        
        /************************* For Current Month Total Data ****************************/
         /************************* For prev year Total  Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year())-1))  group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
      
        mapOfProduct_Groupprevyrtot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
        
            if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
             }
                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupprevyrtot .put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
        
            mapOfProduct_Groupprevyrtot .put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
        
            if (xA.Product_Group+xA.Product_Category != '') {
              if(mapOfProduct_Groupprevyrtot .get(xA.Product_Group+xA.Product_Category)!=null){
                xA.preYeardatatot = mapOfProduct_Groupprevyrtot .get(xA.Product_Group+xA.Product_Category);
                }else{xA.preYeardatatot = 0;}
             }
            
            else {
               if(mapOfProduct_Groupprevyrtot .get(xA.Product_Group)!=null){
                xA.preYeardatatot = mapOfProduct_Groupprevyrtot .get(xA.Product_Group);
                }else{xA.preYeardatatot = 0;}
             }
           
        }
        
        /************************* For previous year Total  Data ****************************/
         /************************* For Current year Total Data ****************************/
          
        xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year())  group by Year__c ]);
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=: string.valueof(((system.Today().year())))  group By Product_Group__c,Product_Category__c]);
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
           
        mapOfProduct_Groupcryeartot = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
          if (string.valueOf(ar.get('Product_Group__c')) != prevProduct_Group){
                Product_GroupSum = 0;
            }                        
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupcryeartot .put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
      
            mapOfProduct_Groupcryeartot .put(string.valueOf(ar.get('Product_Group__c'))+string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
       
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
            decimal temp = 0;
         
            if (xA.Product_Group+xA.Product_Category != '') {
              if( mapOfProduct_Groupcryeartot .get(xA.Product_Group+xA.Product_Category)!=null){
                xA.cuYeardatatot = mapOfProduct_Groupcryeartot .get(xA.Product_Group+xA.Product_Category);
                }else{xA.cuYeardatatot=0;}
             }
            
            else {
                if( mapOfProduct_Groupcryeartot .get(xA.Product_Group)!=null){
                xA.cuYeardatatot = mapOfProduct_Groupcryeartot .get(xA.Product_Group);
                }else{xA.cuYeardatatot=0;}
             }
           
        }
        
        /************************* For Current Month DC Data ****************************/
          /************************* For Trend Calculation ************************/
         
         for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
         
            
              if(xA.cuYearPercent!=0 && xA.preYearPercent !=0){
                xA.Trendper=((xA.cuYearPercent-xA.preYearPercent)*100/xA.preYearPercent).setscale(2);
                }
                 else{xA.Trendper=0;}
             
        }
        /**************** For Trend Calculation *****************/
         for(PQN_Global_SUWrap xA: xSUWRAPLISTGC){
             if(xA.child)
             xChartdata1.add(new PQN_chart(xA.Product_Group,xA.cuYeardata ,xA.Trendper));

         }
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Product_Group{get;set;}
        public string Product_Category{get;set;}
        public Integer preYeardata {get;set;}
        public decimal preYearPercent {get;set;}
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
        
        public PQN_Global_SUWrap(String Product_Group, String Product_Category, Boolean child){
            this.Product_Group= Product_Group;
            this.Product_Category= Product_Category;
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