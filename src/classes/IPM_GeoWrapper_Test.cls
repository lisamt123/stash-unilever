@isTest
public class IPM_GeoWrapper_Test {
public static IPM_Project__c project;
public static mdm_Geography__c geo=new mdm_Geography__c();

static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;
 
 geo.Name='Name';
 geo.Country_Cluster__c='con';
 insert geo;

}


 
  
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_GeoWrapper?id='+project.Id);
         Test.setCurrentPage(pRef);
         
          // ApexPages.StandardController sc1= new ApexPages.StandardController(proTask1);
         IPM_GeoWrapper ipmGeo=new IPM_GeoWrapper();
         list<mdm_Geography__c> cS=new list<mdm_Geography__c>();
        
         IPM_GeoWrapper.mco m=new IPM_GeoWrapper.mco(geo.Name,cs);
         list<IPM_GeoWrapper.mco> mS=new list<IPM_GeoWrapper.mco>();
         //ms.add(geo.Name);
         IPM_GeoWrapper.clusterMCO cm=new IPM_GeoWrapper.clusterMCO('abc',ms);
         
       list<IPM_GeoWrapper.clusterMCO> LClusMco=new list<IPM_GeoWrapper.clusterMCO>();
       LClusMco=ipmGeo.getclusterMCOWrapper();
         
     
         
     }
}