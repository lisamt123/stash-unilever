/*
Created By:Rajesh, Aswin(Cognizant)
Date-26/02/2015
Description:used for IMP central team to create company card
*/

public class IPM_CompanyCard {

    public IPM_CompanyCard(ApexPages.StandardController controller) {

    }


public IPM_Company_Card__c IPMCompanyCard{get;set;}
public list<mdm_Geography__c>mdmGeo{get;set;}
public list<selectoption> lstRegion{get;set;}
public list<selectoption> lstUnileverCluster{get;set;}
public list<selectoption> lstCountryCluster{get;set;}
public list<selectoption> lstISOCountryDependencyName {get;set;}

public string SelectedRegion{get;set;}
public list<string> SelectedUnileverCluster{get;set;}
public string SelectedCountryCluster{get;set;}
public list<string> SelectedISOCountryDependencyName{get;set;}
public boolean isRegionshow{get;set;}
public boolean isUnileverClusterShow{get;set;}
public boolean isCountryClusterShow{get;set;}
public boolean isISOCountryDependencyNameShow{get;set;}
public string GeoScope{get;set;}
public string OneUnileverCluster{get;set;}
public Boolean isLocal{get;set;}
public Boolean isRegional{get;set;}
public Boolean isGlobal{get;set;}
public string CCRecordType{get;set;}
public id GlobalRid{get;set;}
public id RegionalRid{get;set;}
public id LocalRid{get;set;}
public boolean isMCO{get;set;}
public string CCid{get;set;}
//Constructor
public IPM_CompanyCard (){
    GlobalRid=null;
    RegionalRid=null;
    LocalRid=null;
    isLocal=false;
    isRegional=false;
    isGlobal=false;
    isMCO=false;
    SelectedRegion='';
    GeoScope='';
    CCRecordType='';
    OneUnileverCluster='';
    isRegionshow=false;
    isUnileverClusterShow=false;
    isCountryClusterShow=false;
    isISOCountryDependencyNameShow=false;
    IPMCompanyCard=new IPM_Company_Card__c ();
    CCid= ApexPages.currentPage().getParameters().get('id');
    if(CCid!=null){
    IPMCompanyCard=[select name,IPM_TxtGeographical_Scope__c,RecordTypeId,IPM_Market_Cluster__c,IPM_MCO__c from IPM_Company_Card__c  where id=: CCid];
        //SelectedISOCountryDependencyName=IPMCompanyCard.IPM_TxtGeographical_Scope__c;
        list<RecordType>RType=[Select ID, Name From RecordType Where sObjectType = 'IPM_Company_Card__c' and id=:IPMCompanyCard.RecordTypeId];
        LocalRid=IPMCompanyCard.RecordTypeId;  
        OneUnileverCluster=IPMCompanyCard.IPM_Market_Cluster__c;
        SelectedCountryCluster=IPMCompanyCard.IPM_MCO__c ;
    }
    mdmGeo=new list<mdm_Geography__c>();
    SelectedISOCountryDependencyName=new list<string>();
    set<string>getRegioncode=new set<string>();
    list<mdm_Geography__c>geolist=[Select Region__c from mdm_Geography__c];
    
    for(mdm_Geography__c getregion:geolist){
        getRegioncode.add(getregion.Region__c);
    }
    SelectedUnileverCluster=new list<string> ();
    //mdmGeo=[select Region_Code__c,Region__c from mdm_Geography__c where Region__c IN:getRegioncode];
    lstRegion=new   list<selectoption>();
    lstRegion.add(new selectoption('','Select Region'));
    
    for(string georeg:getRegioncode){
        lstRegion.add(new selectoption(georeg,georeg));
    } 
    
    lstUnileverCluster = new list<selectoption>();
    lstUnileverCluster.add(new selectoption('','Select Unilever Cluster'));
    lstCountryCluster= new list<selectoption>();
    lstCountryCluster.add(new selectoption('','Select Country Cluster'));
    lstISOCountryDependencyName = new list<selectoption>();
    lstISOCountryDependencyName.add(new selectoption('','Select ISO Country Dependency Name')); 
    //onRegionSelection();
    
    list<RecordType>RType=[Select ID, Name From RecordType Where sObjectType = 'IPM_Company_Card__c'];
    for(RecordType rt:RType){
        if(rt.Name=='Global Company Card'){
             GlobalRid=rt.id;
        }
        if(rt.Name=='Regional Company Card'){
            RegionalRid=rt.id;
        }
       if(rt.Name=='Local Company Card'){
           LocalRid=rt.id;
       }
  }
    
}


public String onRegionSelection() {
    
    list<mdm_Geography__c>geolist=[Select id,Unilever_Cluster__c,Unilever_Cluster_Code__c from mdm_Geography__c];
    lstUnileverCluster = new list<selectoption>();
    set<string>getUnileverCluster=new set<string>();
    
    for(mdm_Geography__c getCluster:geolist){
        getUnileverCluster.add(getCluster.Unilever_Cluster__c);
    }
   system.debug('CCRecordType...'+CCRecordType);
    if(CCRecordType=='Local'){
    lstUnileverCluster.add(new selectoption('','Select Unilever Cluster'));
    }
    for(string getClusterString:getUnileverCluster){
        lstUnileverCluster.add(new selectoption(getClusterString,getClusterString));
    }
    
    return null;
}

public String onUnileverClusterSelection() {
    
    list<mdm_Geography__c>geolist=[Select id,ISO_Country_Dependency_Code__c,ISO_Country_Dependency_Name__c,Country_Cluster__c,Country_Cluster_Code__c from mdm_Geography__c where Unilever_Cluster__c=:OneUnileverCluster];
    lstCountryCluster= new list<selectoption>();
    set<string>getCountryCluster=new set<string>();
    
    for(mdm_Geography__c getCluster:geolist){
        getCountryCluster.add(getCluster.Country_Cluster__c);
    }
    
    lstCountryCluster.add(new selectoption('','Select Country Cluster'));
    for(string getCountryClusterString:getCountryCluster){

        lstCountryCluster.add(new selectoption(getCountryClusterString,getCountryClusterString));
    }
    isCountryClusterShow=true;
    isISOCountryDependencyNameShow=true;
    return null;
}

public String onCountryClusterSelection() {
    
    list<mdm_Geography__c>geolist=[Select id,ISO_Country_Dependency_Code__c,ISO_Country_Dependency_Name__c from mdm_Geography__c where Country_Cluster__c=:SelectedCountryCluster];
    lstISOCountryDependencyName = new list<selectoption>();
    set<string>getISOCountryDependencyName=new set<string>();
    
    for(mdm_Geography__c getISOCountryDepName:geolist){
        getISOCountryDependencyName.add(getISOCountryDepName.ISO_Country_Dependency_Name__c );
    }
    
   // lstISOCountryDependencyName.add(new selectoption('','Select ISO Country Dependency Name'));
    for(string getISOCountryDependencyNameString:getISOCountryDependencyName){

        lstISOCountryDependencyName.add(new selectoption(getISOCountryDependencyNameString,getISOCountryDependencyNameString));
    }
    isISOCountryDependencyNameShow=true;
    isMco=true;
    return null;
}
public void showDropdown() {
      if(CCRecordType=='Global') {
        GeoScope='Global';
        isRegionshow=false;
        isUnileverClusterShow=false;
        isCountryClusterShow=false;
        isISOCountryDependencyNameShow=false; 
        isRegional=false;
        isLocal=false;
        isMCO=false;
          
      }else if(CCRecordType=='Regional'){
          GeoScope='';
          isRegional=true;
          isLocal=false;
          isISOCountryDependencyNameShow=false; 
          isMCO=false;
          onRegionSelection();
      }else{
          GeoScope='';
          isLocal=true;
          isRegional=false;
          onRegionSelection();
          isMCO=true;
      }
    }

public PageReference SaveCC(){
if(CCRecordType=='Global') {
        GeoScope='Global';
        IPMCompanyCard.IPM_TxtGeographical_Scope__c=GeoScope;
        IPMCompanyCard.RecordTypeId =GlobalRid;
          
      }else if(CCRecordType=='Regional'){
          string UClusterName='';
        for(string Ucluster:SelectedUnileverCluster){
            UClusterName=UClusterName + Ucluster + ';';
        }
        IPMCompanyCard.IPM_TxtGeographical_Scope__c=UClusterName;
        IPMCompanyCard.RecordTypeId =RegionalRid;
      }else{
          string UCountryName='';
          for(string countryname:SelectedISOCountryDependencyName){
          UCountryName=UCountryName+countryname+';';
          }
        IPMCompanyCard.IPM_TxtGeographical_Scope__c=UCountryName;
        IPMCompanyCard.RecordTypeId =LocalRid;  
        IPMCompanyCard.IPM_Market_Cluster__c=OneUnileverCluster;
        IPMCompanyCard.IPM_MCO__c=SelectedCountryCluster;
      }
try{
if(CCid!=null){
IPMCompanyCard.id=CCid;
update IPMCompanyCard;
}else{
insert IPMCompanyCard;
}
PageReference pg=new PageReference('/'+IPMCompanyCard.id);
system.debug('size of cluster.....'+IPMCompanyCard);
return pg;
}catch(exception e){
return null;
}




}

}