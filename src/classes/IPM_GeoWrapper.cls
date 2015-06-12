public with sharing class IPM_GeoWrapper {
    
    private Map<String, Set<String>> clusterMCOMap;
    private Map<String, mdm_Geography__c[]> mcoCountryMap;
    private list<clusterMCO> clusterMCOWrapperList;
    
    public IPM_GeoWrapper() {
        
        clusterMCOMap = new Map<String, Set<String>>();
        mcoCountryMap = new Map<String, mdm_Geography__c[]>();
    }
    
    public list<clusterMCO> getclusterMCOWrapper() {
        
        list<mdm_Geography__c> goegraphies = [SELECT Unilever_Cluster__c, Country_Cluster__c, ISO_Country_Dependency_Name__c
                                               FROM mdm_Geography__c
                                               LIMIT 500];
        
        for(mdm_Geography__c eachCountry : goegraphies) { //Add Clusters
            String key = eachCountry.Unilever_Cluster__c+';'+eachCountry.Country_Cluster__c;
            if(!clusterMCOMap.containsKey(eachCountry.Unilever_Cluster__c)) {
                Set<String> tmpLst = new Set<String>();
                tmpLst.add(eachCountry.Country_Cluster__c);
                clusterMCOMap.put(eachCountry.Unilever_Cluster__c, tmpLst);
            } else {
                clusterMCOMap.get(eachCountry.Unilever_Cluster__c).add(eachCountry.Country_Cluster__c);
            }
        }
        
        for(mdm_Geography__c eachCountry : goegraphies) { //Add MCOs
            String key = eachCountry.Country_Cluster__c;
            if(!mcoCountryMap.containsKey(key)) {
                mdm_Geography__c[] tmpLst = new list<mdm_Geography__c>();
                tmpLst.add(eachCountry);
                mcoCountryMap.put(key, tmpLst);
            } else {
                mcoCountryMap.get(key).add(eachCountry);
            }
        }
        
        clusterMCOWrapperList = new list<clusterMCO>();
        String[] sortedCluster = new list<String>();
        sortedCluster.addAll(clusterMCOMap.keySet());
        sortedCluster.sort();
        
        for(String eachCluster : sortedCluster) {
            list<mco> mcoList = new list<mco>();
            for(String eachMCO : IPM_Utils.convertSetToSortedList(clusterMCOMap.get(eachCluster))) {
                String key = eachCluster+';'+eachMCO;
                mdm_Geography__c[] countryList = new list<mdm_Geography__c>();
                for(mdm_Geography__c eachCountry : goegraphies) {
                    String countryKey = eachCountry.Unilever_Cluster__c + ';' + eachCountry.Country_Cluster__c;
                    if(countryKey == key) {
                        countryList.add(eachCountry);
                    }
                }
                mcoList.add(new mco(eachMCO, countryList));
            }
            clusterMCOWrapperList.add(new clusterMCO(eachCluster, mcoList));
        }
        
        return clusterMCOWrapperList;
    }
    
    public class clusterMCO{
        
        public String clusterName {get; set;}
        public list<mco> mcos {get; set;}
 
        public clusterMCO(String c, list<mco> mS) {
            clusterName = c;
            mcos = mS;
        }
    }
    
    public class mco {
        
        public String mcoName {get; set;}
        public list<mdm_Geography__c> countries {get; set;}
 
        public mco(String m, list<mdm_Geography__c> cS) {
            mcoName = m;
            countries = cS;
        }
    }
}