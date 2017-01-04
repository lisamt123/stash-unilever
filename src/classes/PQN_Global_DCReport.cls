public with sharing class PQN_Global_DCReport{
    
    public List<PQN_Global_SUWrap> xSUWRAPLIST{get;set;}
    public String empty{get;set;}
      
    public PQN_Global_DCReport(){
       
        empty = '';
        xSUWRAPLIST = new List<PQN_Global_SUWrap>();
        String prevClus = '';
        
        List<AggregateResult> ListAGG1=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' AND Supplier_type__c='DC' group By cluster__c,Reporting_DC__c]);
        Map<String,String> mapOfRegions = new Map<String,String>();
        for (AggregateResult ar : ListAGG1){
            if (string.valueOf(ar.get('Cluster__c')) == prevClus ){
                 xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Reporting_DC__c')),False));
            }
            else if (string.valueOf(ar.get('Cluster__c'))!=prevClus ){
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),'',True));
                xSUWRAPLIST.add(new PQN_Global_SUWrap(string.valueOf(ar.get('Cluster__c')),string.valueOf(ar.get('Reporting_DC__c')),False));
            } 
                
            mapOfRegions.put(string.valueOf(ar.get('Cluster__c'))+string.valueOf(ar.get('Reporting_DC__c')),'1');
            prevClus = string.valueOf(ar.get('Cluster__c'));
        }
             
        List<AggregateResult> ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()) AND Supplier_type__c='DC' group By cluster__c,Reporting_DC__c Order By cluster__c]);
      
        Map<String,Integer> mapOfRegioncryear = new Map<String,Integer>();
        Map<String,Integer> mapOfRegionPreYear = new Map<String,Integer>();
        Map<String,Integer> mapOfRegioncrmnth = new Map<String,Integer>();
         
        prevClus = '';
        Integer clusSum = 0;
       
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Cluster__c'))!=prevClus ){
                clusSum = 0;
            } 
                
            clusSum = clusSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncryear .put(string.valueOf(ar.get('Cluster__c')), clusSum );
            mapOfRegioncryear .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
            prevClus = string.valueOf(ar.get('Cluster__c'));
            
        }
       
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.ReportingDC != '') {
                xA.cuYeardata = mapOfRegioncryear .get(xA.ReportingDC );
               }
            else {
                xA.cuYeardata = mapOfRegioncryear .get(xA.Cluster );
              
               }
        }    
        
        /***For previous year***/  
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()-1) AND Supplier_type__c='DC' group By cluster__c,Reporting_DC__c Order By cluster__c]);    
        prevClus = '';
        clusSum = 0;
       
        mapOfRegionPreYear = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Cluster__c'))!=prevClus ){
                clusSum = 0;
            } 
           
            clusSum = clusSum + integer.valueof(ar.get('expr0'));
            mapOfRegionPreYear.put(string.valueOf(ar.get('Cluster__c')), clusSum );
           
            mapOfRegionPreYear .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
            
            prevClus = string.valueOf(ar.get('Cluster__c'));
            
        }
        system.debug('mapOfRegion--->>'+mapOfRegioncryear );
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.ReportingDC != '') {
                xA.preYeardata = mapOfRegionPreYear .get(xA.ReportingDC );
             }
            else {
                xA.preYeardata = mapOfRegionPreYear .get(xA.Cluster );
             }
        }    
        
        /***For Current month***/  
        
        ListAGG=new List<AggregateResult>([select SUM(Number_of_Pallets_Per_SKU_Non_Compliant__c),Cluster__c,Reporting_DC__c from PQN_Pallet_Quality_Non_Conformance__c Where Cluster__c != '' AND Year__c=:string.valueof(system.Today().year()) AND MonthN__c=:string.valueof(system.Today().month()) AND Supplier_type__c='DC' group By cluster__c,Reporting_DC__c Order By cluster__c]);    
        prevClus = '';
        clusSum = 0;
       
       mapOfRegioncrmnth = new Map<String,Integer>();
        
        for(AggregateResult ar:ListAGG){
            
            if (string.valueOf(ar.get('Cluster__c'))!=prevClus ){
                clusSum = 0;
            } 
            
            clusSum = clusSum + integer.valueof(ar.get('expr0'));
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Cluster__c')), clusSum );
            
            mapOfRegioncrmnth .put(string.valueOf(ar.get('Reporting_DC__c')), integer.valueof(ar.get('expr0')));
          
            prevClus = string.valueOf(ar.get('Cluster__c'));
            
        }
        system.debug('mapOfRegion--->>'+mapOfRegioncrmnth );
        
        for(PQN_Global_SUWrap xA: xSUWRAPLIST){
            decimal temp = 0;
          
            if (xA.ReportingDC != '') {
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.ReportingDC );
              }
            else {
                xA.cumnthdata = mapOfRegioncrmnth .get(xA.Cluster );
               
            }
         
        }    
       
    }
    
    
    public class PQN_Global_SUWrap{
        public Boolean child{get;set;}
        public string ReportingDC {get;set;}
        public string Cluster{get;set;}
        public Integer preYeardata {get;set;}
        public Integer cuYeardata {get;set;}
        public Integer cumnthdata {get;set;}
                
        public PQN_Global_SUWrap(String Cluster, String ReportingDC , Boolean child){
            this.ReportingDC = ReportingDC ;
            this.Cluster= Cluster;
            this.child= child;
                     
        }
        
    }
    
}