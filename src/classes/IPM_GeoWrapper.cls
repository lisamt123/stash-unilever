/**
    @Description: An intermediate wrapper class to convert the linear form of Geography data into 3 tier structure.
    @Author: Cognizant Technology
    @Date: Feb 2015
**/
public with sharing class IPM_GeoWrapper {
    
    private Map<String, Set<String>> clusterMCOMap; //internally used map to store mcos cluster wise
    //private Map<String, MDO_Geography__c[]> mcoCountryMap;//internally used map to store countries mco wise
    private list<clusterMCO> clusterMCOWrapperList;//final returning variable to the external classes from a method
    
    //constructor
    public IPM_GeoWrapper() {
        
        //initialise them!
        clusterMCOMap = new Map<String, Set<String>>();
        //mcoCountryMap = new Map<String, MDO_Geography__c[]>();
    }
    
    /*******************************************************************************************************
    * @description: the getter of the clusterMCOwrapper 
    * @returns : wrapped list of clusterMCOs
    */
    public list<clusterMCO> getclusterMCOWrapper() {
      list<mco> mcoList;
      list<MDO_Geography__c> goegraphiesMCO = [SELECT  Name, parent_L2__r.Name
                                               FROM MDO_Geography__c where geography_type__c = 'Country Group' and Status__c = 'Active' and parent_L2__c <> ''
                                               LIMIT 500];//extract the data from the master-data object MDO_Geography__c
                                               
        for(MDO_Geography__c eachCountry : goegraphiesMCO) { //Add Clusters
            if(!clusterMCOMap.containsKey(eachCountry.parent_L2__r.Name)) {
                Set<String> tmpLst = new Set<String>();
                tmpLst.add(eachCountry.Name);
                clusterMCOMap.put(eachCountry.parent_L2__r.Name, tmpLst);
            } else {
                clusterMCOMap.get(eachCountry.parent_L2__r.Name).add(eachCountry.Name);
            }
        }
        
        list<MDO_Geography__c> goegraphiesCountry = [SELECT  Name, parent_L2__r.Name
                                               FROM MDO_Geography__c where geography_type__c = 'Country' and Status__c = 'Active' and parent_L2__c <> ''
                                               LIMIT 500];//extract the data from the master-data object MDO_Geography__c
                                               
        clusterMCOWrapperList = new list<clusterMCO>();//this is clustermcowrapper list used internally
        String[] sortedCluster = new list<String>();//sorted Clusters which would help us in definning them on the page.
        sortedCluster.addAll(clusterMCOMap.keySet());
        sortedCluster.sort();//sort them
        
        // Now that we have all information in various variables, now lets try to club 'em together to make a 3-tier Cluster-->MCO-->Country wrapper
        for(String eachCluster : sortedCluster) {
            mcoList = new list<mco>();
            for(String eachMCO : IPM_Utils.convertSetToSortedList(clusterMCOMap.get(eachCluster))) {
                MDO_Geography__c[] countryList = new list<MDO_Geography__c>();
                for(MDO_Geography__c eachCountry : goegraphiesCountry) {
                    if(eachMCO == eachCountry.parent_L2__r.Name) {
                        countryList.add(eachCountry);
                    }
                }
                mcoList.add(new mco(eachMCO, countryList));
            }
            clusterMCOWrapperList.add(new clusterMCO(eachCluster, mcoList));
        }
        mcoList = new list<mco>();
        clusterMCOWrapperList.add(new clusterMCO('Unassigned', mcoList));
        return clusterMCOWrapperList;
    }
    
    /***************************************************************
    * @description: wrapper class which will contain cluster-MCOs
    */
    public class clusterMCO{
        
        public String clusterName {get; set;}//name of the cluster
        public list<mco> mcos {get; set;}//mco list associated to a cluster
 
        public clusterMCO(String c, list<mco> mS) {
            clusterName = c;
            mcos = mS;
        }
    }
    
    /***************************************************************
    * @description: wrapper class which will contain mco-countries
    */
    public class mco {
        
        public String mcoName {get; set;}//mco Name
        public list<MDO_Geography__c> countries {get; set;}//countries associated to that mco
 
        public mco(String m, list<MDO_Geography__c> cS) {
            mcoName = m;
            countries = cS;
        }
    }
}