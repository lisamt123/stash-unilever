public class PBS_CourseStatsInDetailReport_CC {
    public List<PBS_Profile__c> userNames;
    public String selectedValue{get;set;}

     public List<SelectOption> getUserNames(){
      List<SelectOption> namesList = new List<SelectOption>();
      userNames = [SELECT id,User__r.Name from PBS_Profile__c ORDER BY User__r.Name];
      for(PBS_Profile__c plist : userNames){
      namesList.add(new SelectOption(plist.User__r.Name,plist.User__r.Name));
      }
       return namesList;    
    }
    
     public Pagereference gnertCrseStusInDtlRprt(){
        Pagereference pageref;
         ID reportid =  ApexPages.currentPage().getParameters().get('id') ;
         pageref = new Pagereference('/'+reportid+'?pv0='+selectedValue);
        return pageref;
    }
}