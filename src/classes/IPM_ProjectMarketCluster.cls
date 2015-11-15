/* Type Name: ipmProjectMarketCluster 
Author: 
Created Date:
Reason: 
Change History:
Author: 
Modified Date: 15-10-2014  */
global with sharing class IPM_ProjectMarketCluster {
    
  /*  public List<IPM_Project_Rollout__c> projectRollOut{get;set;}

    @RemoteAction
    global static List<String> getcluster(String rolloutname, String clusterRegion,String clusterCountry,Id projectId,String projectName) {
        System.debug(rolloutname);
        System.debug(projectName);
        System.debug(clusterRegion);
        System.debug(clusterCountry);
        
        String[] splitallvalues=rolloutname.split(',');
List<String> lstRegion;
List<String> lstCountry;
Map<String, List<String>> mapclusterRegion=new Map<String, List<String>>();
Map<String, List<String>> mapRegionCountry=new Map<String, List<String>>();
for(Integer i=0;i<splitallvalues.size();i++){
  if(splitallvalues[i].contains('Cluster')){
   lstRegion=new List<String>();
   
   for(integer j=i+1;j<splitallvalues.size();j++){
    if(splitallvalues[j].contains('Region')){
    lstRegion.add(splitallvalues[j].subString(6,splitallvalues[j].length()));
        lstCountry=new List<String>();
        for(integer k=j+1;k<splitallvalues.size();k++){
            if(splitallvalues[k].contains('Country')){
            lstCountry.add(splitallvalues[k].subString(7,splitallvalues[k].length()));
            }else{
              k=splitallvalues.size();
            }
        }
        if(lstCountry.size()>0){
            mapRegionCountry.put(splitallvalues[j].subString(6,splitallvalues[j].length()),lstCountry);}
    }else{
        if(splitallvalues[j].contains('Cluster')){
            j=splitallvalues.size();
        }
    }
    }
    if(lstRegion.size()>0){
        mapclusterRegion.put(splitallvalues[i].subString(7,splitallvalues[i].length()),lstRegion);}
  }
}
System.debug(mapclusterRegion);
System.debug(mapRegionCountry);

List<IPM_Project_Rollout__c> lstipmProjectRollout=new List<IPM_Project_Rollout__c>();
for(String str:mapclusterRegion.keySet()){
IPM_Project_Rollout__c rollout=new IPM_Project_Rollout__c();
if(str == 'Africa' || str =='Europe' || str=='South Asia' || str=='SEAA' || str=='Latin America' || str=='NAMET & RUB' || str == 'North America' || str == 'North Asia'){
    if(str == 'Africa'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'AFR';
    }else if(str == 'North Asia'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'NAS';
    }else if(str == 'Europe'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'EU';
    }else if(str == 'Latin America'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'LA';
    }else if(str == 'South Asia'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'SAS';
    }else if(str == 'SEAA'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'SEAA';
    }else if(str == 'NAMET & RUB'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'N&R';
    }else if(str == 'North America'){
    rollout.IPM_Rollout_Project__c =projectName+'_'+'NA';
    }
}else{
rollout.IPM_Rollout_Project__c =projectName+'_'+str.substring(0,2);
}
rollout.IPM_Project__c=projectId;
rollout.Market_Cluster__c=str;
rollout.Type__c='Regional';
rollout.RecordTypeId='012L00000000aKn';
lstipmProjectRollout.add(rollout);
}

if(lstipmProjectRollout.size()>0){
    //insert lstipmProjectRollout;
    try {
        upsert lstipmProjectRollout IPM_Rollout_Project__c;  
        System.debug(lstipmProjectRollout);
    } catch (DmlException e) {
        System.debug(e.getMessage());
    }
}
List<String> lstCountryCode=new List<String>();
List<IPM_Country__c> lstipmcountry=new List<IPM_Country__c>();
for(IPM_Project_Rollout__c roll:lstipmProjectRollout){
    for(String strRegion:mapclusterRegion.get(roll.Market_Cluster__c)){
     for(String strCountry:mapRegionCountry.get(strRegion)){
         String[] strCountrySplit=strCountry.split('@');
         IPM_Country__c country=new IPM_Country__c();
         country.IPM_Market_Cluster__c=roll.Market_Cluster__c;
         country.IPM_Country_Name__c=strCountrySplit[0];
         country.IPM_CountryCode__c=strCountrySplit[1];
         country.IPM_Region_MCO__c=strRegion;
         country.IPM_Project_Rollout__c=roll.Id;
         country.Project_country__c=projectName+'_'+strCountrySplit[0];
         country.IPM_Project__c=projectId; 
         lstipmcountry.add(country);
         lstCountryCode.add(strCountrySplit[1]);
     }
    }
}
if(lstipmcountry.size()>0){
    //upsert lstipmcountry IPM_Country_Name__c;
    upsert lstipmcountry Project_country__c;
}
          pagereference pg=new pagereference('/apex/ipmProjectRollout?id='+projectId);
          pg.setredirect(true);
               //return pg;
       // return new PageReference('/apex/ipmProjectRollout?id='+projectId);
       return lstCountryCode;
    }
    
    //Initializing Variables
  
    public IPM_Project__c project {get; set;}
    public String projectId{get;set;}
    public Boolean isImage{get; set;}
    public Boolean isDescVisible{get; set;}
    public String projectType;
    public string rolloutName {get; set;}
    public string clusterRegion {get; set;}
    public string clusterCountry {get; set;}
    public boolean generateRolloutPlans {get;set;}
    
    public IPM_ProjectMarketCluster(){
      Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        projectId=ApexPages.currentPage().getParameters().get('Id');
        projectType=ApexPages.currentPage().getParameters().get('isProject');
        isDescVisible=false;
        if(projectType=='true')
            isDescVisible=true;
        if(projectId!=null)
        project=[Select Id,IPM_Project_Name__c,IPM_Project_Description__c,IPM_Category_Text__c,IPM_Brand__c,IPM_Project_Logo__c,IPM_Brand_Positioning__c,IPM_Category__r.Name,IPM_Target_Launch_Date__c from IPM_Project__c where Id=:projectId];
        if(project.IPM_Project_Logo__c !=null)
            isImage=true;
            
         projectRollOut = [SELECT IPM_Rollout_Project__c, Market_Cluster__c, IPM_Status__c, Name, Target_Launch_Year__c, Target_Launch_Month__c,
                                IPM_Regional_PL__c, Finance_Member__c, (SELECT IPM_Country_Name__c,IPM_CountryCode__c  FROM IPM_Countries__r)
                            FROM IPM_Project_Rollout__c WHERE IPM_Project__c = :projectId
                            ORDER BY IPM_Status__c ASC];
        List<IPM_Project__c> lstcoreParameters=[SELECT IPMCompany__c,IPMPlatform__c,IPMProject_Span__c,IPMProject_Type__c,IPMRegion__c,IPM_IsCompleted__c FROM IPM_Project__c WHERE IPM_IsCompleted__c = true and id =: projectId];
        if(lstcoreParameters.IsEmpty()){
            generateRolloutPlans =false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'<a href="https://unilever--cogstagin.cs8.my.salesforce.com/apex/ipmproject?id='+projectId+'">'+Label.IPM_backto_intermediate+'</a>'));
        }else{
            System.debug('Else Block');
            generateRolloutPlans=true;
        }
    }
    
    public void save() {
        
        update projectRollOut;
    }
    
     public PageReference BackToProjectIntermediate(){
               pagereference pg=new pagereference('/apex/ipmProject?id='+projectId);
               return pg;
     }*/

}