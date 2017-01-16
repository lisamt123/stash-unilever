public without sharing class PQN_Global_DCReport{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public List<PQN_chart> xChartdata{get;set;}
    public String empty{get;set;}
    public String empt{get;set;}
     public Integer cuYear{get;set;}
    public Integer preYear{get;set;}
    public String cuMonth{get;set;}
      
    public PQN_Global_DCReport(){
       
        
        empty = 'n.a';
        empt='';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
        xChartdata = new List<PQN_chart>();
        String prevClus = '';
        for( AggregateResult xD: [select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Reporting_DC__c ReportingDC from PQN_Pallet_Quality_Non_Conformance__c where Reporting_DC__c!='' group By Reporting_DC__c order by SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c) desc]){
            
            xChartdata.add(new PQN_chart(String.valueOf(xD.get('ReportingDC')),integer.valueof(xD.get('expr0'))));
            //

        }
        system.debug('--->>>>>'+xChartdata);
        List<AggregateResult> ListAGG1=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c != '' AND Supplier_type__c='DC' group By Supplier_Cluster__c,Reporting_DC__c]);
        Map<String,String> mapOfRegions = new Map<String,String>();
        for (AggregateResult ar : ListAGG1){
            if (string.valueOf(ar.get('Supplier_Cluster__c')) == prevClus ){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Reporting_DC__c')),False));
            }
            else if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevClus ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Cluster__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Supplier_Cluster__c')),string.valueOf(ar.get('Reporting_DC__c')),False));
            } 
                
            mapOfRegions.put(string.valueOf(ar.get('Supplier_Cluster__c'))+string.valueOf(ar.get('Reporting_DC__c')),'1');
            prevClus = string.valueOf(ar.get('Supplier_Cluster__c'));
        }
             
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='DC' group By Supplier_Cluster__c,Reporting_DC__c Order By Supplier_Cluster__c]);
      
        List<PQN_Pallet_Quality_Non_Conformance__c > listtar=new List<PQN_Pallet_Quality_Non_Conformance__c >([select Target_Reduction__c,Supplier_Cluster__c from PQN_Pallet_Quality_Non_Conformance__c where Supplier_Cluster__c!='' AND Year__c=:string.valueof(system.Today().year())]);
        
        Map<String,Integer> mapOfRegioncryear = new Map<String,Integer>();
        Map<String,Integer> mapOfRegionPreYear = new Map<String,Integer>();
        Map<String,Integer> mapOfRegioncrmnth = new Map<String,Integer>();
        cuYear = integer.valueof(system.Today().year());
        preYear = integer.valueof(system.Today().year()) - 1;
        DateTime d = datetime.now();
        cuMonth = d.format('MMMMM');
     //   Map<String,Decimal> mapOftarget = new Map<String,Decimal>();
        
        system.debug('listtar-->>'+listtar);
        
    /*    for(PQN_Pallet_Quality_Non_Conformance__c lt: listtar){
            mapOftarget.put(lt.Supplier_Cluster__c,lt.Target_Reduction__c);
          }
          
          system.debug('mapOftarget-->>'+mapOftarget);*/
         
        prevClus = '';
        Integer clusSum = 0;
       
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevClus ){
                clusSum = 0;
            } 
                
            clusSum = clusSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryear .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusSum );
            mapOfRegioncryear .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
            prevClus = string.valueOf(ar.get('Supplier_Cluster__c'));
            
        }
       
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.ReportingDC != '') {
             if( mapOfRegioncryear .get(xA.ReportingDC )!=null){
                xA.cuYeardata = mapOfRegioncryear.get(xA.ReportingDC );
               // xA.cuYeartargetper=mapOftarget.get(xA.Cluster);
               }else{xA.cuYeardata = 0;}
            }
            else {
             if( mapOfRegioncryear .get(xA.Cluster )!=null){
                xA.cuYeardata =  mapOfRegioncryear.get(xA.Cluster);
               // xA.cuYeartargetper=mapOftarget.get(xA.Cluster);
               }else{xA.cuYeardata = 0;}
            } 
         }   
        
        /***For previous year***/  
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()-1) AND Supplier_type__c='DC' group By Supplier_Cluster__c,Reporting_DC__c Order By Supplier_Cluster__c]);    
        prevClus = '';
        clusSum = 0;
       
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevClus ){
                clusSum = 0;
            } 
           
            clusSum = clusSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Supplier_Cluster__c')), clusSum );
           
            mapOfRegionPreYear .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
            
            prevClus = string.valueOf(ar.get('Supplier_Cluster__c'));
            
        }
        system.debug('mapOfRegion--->>'+mapOfRegioncryear );
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.ReportingDC != '') {
             if( mapOfRegionPreYear.get(xA.ReportingDC )!=null){
                xA.preYeardata = mapOfRegionPreYear .get(xA.ReportingDC);
             }else{xA.preYeardata=0;}
           }
            else {
            if( mapOfRegionPreYear.get(xA.Cluster )!=null){
                xA.preYeardata =mapOfRegionPreYear .get(xA.Cluster);
             }else{xA.preYeardata=0;}
           }
       }    
        
        /***For Current month***/  
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Supplier_Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Supplier_Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()) AND MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By Supplier_Cluster__c,Reporting_DC__c Order By Supplier_Cluster__c]);    
        prevClus = '';
        clusSum = 0;
       
       mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Supplier_Cluster__c'))!=prevClus ){
                clusSum = 0;
            } 
            
            clusSum = clusSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Supplier_Cluster__c')), clusSum );
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
          
            prevClus = string.valueOf(ar.get('Supplier_Cluster__c'));
            
        }
        system.debug('mapOfRegion--->>'+mapOfRegioncrmnth );
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.ReportingDC != '') {
             if( mapOfRegioncrmnth .get(xA.ReportingDC )!=null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.ReportingDC );
              }else{xA.cumnthdata =0;}
            }
            else {
             if( mapOfRegioncrmnth .get(xA.Cluster)!=null){
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Cluster);
              }else{xA.cumnthdata =0;}
            }
         }    
       
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string ReportingDC {get;set;}
        public string Cluster{get;set;}
        public integer preYeardata {get;set;}
       // public Decimal cuYeartargetper{get;set;}
        public integer cuYeardata {get;set;}
        public integer cumnthdata {get;set;}
                
        public PQN_Global_SUWrap(String Cluster, String ReportingDC , Boolean child){
            this.ReportingDC = ReportingDC ;
            this.Cluster= Cluster;
            this.child= child;
                     
        }
        
    }
    
    public class PQN_chart{
        
        public String chartXAxis{get;set;}
        public Integer chartdata {get;set;}
                
        public PQN_chart( String chartXAxis,integer chartdata){
            this.chartXAxis= chartXAxis;
            this.chartdata= chartdata;
                     
        }
        
    }
    
}