public with sharing class PQN_Global_Overview_Category_Report{
   
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
   
    public PQN_Global_Overview_Category_Report(){
        
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
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
          
         List<AggregateResult> LAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' group By Product_Group__c,Product_Category__c]);
      
              
        for(AggregateResult ar:LAGG){
            
            if (string.valueOf(ar.get('Product_Group__c')) == prevProduct_Group){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Group__c')),string.valueOf(ar.get('Product_Category__c')),False));
            }
            else if (string.valueOf(ar.get('Product_Group__c'))!=prevProduct_Group ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Group__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Product_Group__c')),string.valueOf(ar.get('Product_Category__c')),False));
            } 
                prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
         }
       
        List<Aggregateresult> xPSU = new List<AggregateResult>([Select SUM(Total_Volume_Of_pallets_Shipped__c) totalshipped,Year__c from PQN_Sourcing_Unit__c where Year__c=:string.valueof(system.Today().year()-1) group by Year__c ]);
        
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Product_Group__c,Product_Category__c from PQN_Pallet_Quality_Non_Conformance__c Where Product_Group__c != '' AND Year__c=:string.valueof(system.Today().year()-1) AND Supplier_type__c='SU' group By Product_Group__c,Product_Category__c]);
      
        
        prevProduct_Group = '';
        Product_GroupSum = 0;
              
        for(AggregateResult ar:ListAGG){
            
           if (string.valueOf(ar.get('Product_Group__c'))!=prevProduct_Group ){
                 Product_GroupSum = 0;
            } 
                                  
            Product_GroupSum = Product_GroupSum + integer.valueof(ar.get('expr0'));
            mapOfProduct_Groupcuryr.put(string.valueOf(ar.get('Product_Group__c')), Product_GroupSum);
            
            mapOfProduct_Groupcuryr.put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
           
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
      
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.Product_Category != '') {
                xA.cuYeardata = mapOfProduct_Groupcuryr.get(xA.Product_Category);
                if (mapOfProduct_Groupcuryr.get(xA.Product_Category) != Null){
                 temp = Double.valueOf((mapOfProduct_Groupcuryr.get(xA.Product_Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
               }else{xA.cuYearPercent=0;}
            }
            else {
                xA.cuYeardata = mapOfProduct_Groupcuryr.get(xA.Product_Group);
                if (mapOfProduct_Groupcuryr.get(xA.Product_Group) != Null){
                 temp = Double.valueOf((mapOfProduct_Groupcuryr.get(xA.Product_Group)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                 xA.cuYearPercent= temp.setscale(2);
               }else{xA.cuYearPercent=0;}
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
          
            mapOfProduct_GroupPreYear.put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
            
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
           
             if (xA.Product_Category != '') {
                xA.preYeardata = mapOfProduct_GroupPreYear.get(xA.Product_Category);
                if (mapOfProduct_GroupPreYear.get(xA.Product_Category) != Null){
                    temp = Double.valueOf((mapOfProduct_GroupPreYear.get(xA.Product_Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else {
                xA.preYeardata = mapOfProduct_GroupPreYear.get(xA.Product_Group);
                if (mapOfProduct_GroupPreYear.get(xA.Product_Group) != Null){
                    temp = Double.valueOf((mapOfProduct_GroupPreYear.get(xA.Product_Group)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.preYearPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
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
          
            mapOfProduct_Groupcrmnth .put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
          
           prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
           
             if (xA.Product_Category != '') {
                xA.cumnthdata = mapOfProduct_Groupcrmnth .get(xA.Product_Category);
                if (mapOfProduct_Groupcrmnth .get(xA.Product_Category) != Null){
                    temp = Double.valueOf((mapOfProduct_Groupcrmnth .get(xA.Product_Category)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
            }
            else {
                xA.cumnthdata = mapOfProduct_Groupcrmnth .get(xA.Product_Group);
                if (mapOfProduct_Groupcrmnth .get(xA.Product_Group) != Null){
                    temp = Double.valueOf((mapOfProduct_Groupcrmnth.get(xA.Product_Group)*100))/integer.valueOf(xPSU[0].get('totalshipped'));
                    xA.cumnthPercent = temp.setscale(2);
                } else { xA.preYearPercent = 0; }
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
       
            mapOfProduct_Groupcrmnth .put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
          
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
       
            if (xA.Product_Category != '') {
                xA.cumnthdcdata = mapOfProduct_Groupcrmnthdc .get(xA.Product_Category);
                }
            
            else {
                xA.cumnthdcdata = mapOfProduct_Groupcrmnthdc .get(xA.Product_Group);
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
                  
            mapOfProduct_GroupcrmnthIE .put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
            
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
        
             if (xA.Product_Category != '') {
                xA.cumnthIEdata = mapOfProduct_GroupcrmnthIE .get(xA.Product_Category);
                }
            
            else {
                xA.cumnthIEdata = mapOfProduct_GroupcrmnthIE .get(xA.Product_Group);
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
         
            mapOfProduct_Groupcrmnthtot .put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
        
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.Product_Category != '') {
                xA.cumnthtotdata = mapOfProduct_Groupcrmnthtot .get(xA.Product_Category);
                }
            
            else {
                xA.cumnthtotdata = mapOfProduct_Groupcrmnthtot .get(xA.Product_Group);
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
        
            mapOfProduct_Groupprevyrtot .put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
        
            if (xA.Product_Category != '') {
                xA.preYeardatatot = mapOfProduct_Groupprevyrtot .get(xA.Product_Category);
                }
            
            else {
                xA.preYeardatatot = mapOfProduct_Groupprevyrtot .get(xA.Product_Group);
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
      
            mapOfProduct_Groupcryeartot .put(string.valueOf(ar.get('Product_Category__c')), integer.valueof(ar.get('expr0')));
       
            prevProduct_Group = string.valueOf(ar.get('Product_Group__c'));
            
        }
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
         
            if (xA.Product_Category != '') {
                xA.cuYeardatatot = mapOfProduct_Groupcryeartot .get(xA.Product_Category);
                }
            
            else {
                xA.cuYeardatatot = mapOfProduct_Groupcryeartot .get(xA.Product_Group);
                }
           
        }
        
        /************************* For Current Month DC Data ****************************/
        
        
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string Product_Group{get;set;}
        public string Product_Category{get;set;}
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
        
        public PQN_Global_SUWrap(String Product_Group, String Product_Category, Boolean child){
            this.Product_Group= Product_Group;
            this.Product_Category= Product_Category;
            this.child= child;
           
        }
        
    }
    
}