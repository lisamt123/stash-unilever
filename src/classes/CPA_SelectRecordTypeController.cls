public with sharing class CPA_SelectRecordTypeController { 
    
    public List<SelectOption> recordTypelist {get;set;}
    public String recordtypeId {get;set;}
    public String pworfId {get;set;}
    public String flagState{get;set;}
    public String objName {get;set;}
    public List<RecordType> schemeList{get;set;}
    public String titleText {get;set;}
    
    
    public CPA_SelectRecordTypeController() {
    
        pworfId = Apexpages.CurrentPage().getParameters().get('id');
        flagState= Apexpages.CurrentPage().getParameters().get('flag');
        system.debug('pworfId '+pworfId );
        recordTypelist = new List<SelectOption>();
        recordTypelist = getRecordTypeList();
        
        
    }
    
    
    
    public  List<SelectOption> getRecordTypeList() {
    schemeList = new List<RecordType>();
    List<SelectOption> optionsList = new List<SelectOption>();
    try {
    
     
   objName = findObjectNameFromRecordIdPrefix(pworfId );
    system.debug('objName test '+objName );

    if(objName =='CPA_PWORF__c') {
        titleText = 'PWO';
        schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('PWO','Standalone PWO')] ;
    } if(objName =='CPA_project_work_order__c')  {
       titleText = 'CR';
        schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('CR Other','Standalone CR')] ;
    }if(objName =='CPA_PWORF__c' && flagState =='Loi') {
        titleText = 'LOI';
        schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('LOI Other','LOI Submitted')] ;
    }
            if(!schemeList.isEmpty()) {
            //optionsList.add(new SelectOption('None','None'));
            for(RecordType schemeRs:schemeList) {
                optionsList.add(new SelectOption(schemeRs.Id, schemeRs.Name));
            }   
               // optionsList.sort();
                return optionsList;
            }
        
        
        }catch (Exception e){
        
            system.debug('Error on Line no 69'+e.getMessage());
        }
        return new List<SelectOption>();
    }
    
    
    public PageReference redirectToPageNewItem() {  
    String UrlLink ='';
    system.debug('objName '+objName+'Test'+recordtypeId);
    if(objName =='CPA_PWORF__c') {
    
    CPA_PWORF__c Rs= [Select Id,Name From CPA_PWORF__c Where Id=:pworfId];
    
         
    UrlLink = '/'+Label.CPA_ParentId_For_Attachment_trigger+'/e?retURL=a00&RecordType='+recordtypeId+Label.CPA_PWORF_Name_Filed_Id+'='+Rs.Name+Label.CPA_PWORF_Name_Filed_Id+'_lkid='+Rs.Id;
   
   } if(objName =='CPA_PWORF__c' && flagState =='Loi') {
    
    CPA_PWORF__c RsLoi= [Select Id,Name From CPA_PWORF__c Where Id=:pworfId];
    
         
    UrlLink = '/'+Label.CPA_ParentId_For_Attachment_LOI+'/e?retURL=a00&RecordType='+recordtypeId+Label.CPA_PWORF_LOI_Name_Filed_Id+'='+RsLoi.Name+Label.CPA_PWORF_LOI_ID_Filed_Id+'_lkid='+RsLoi.Id;
    
    } if(objName =='CPA_project_work_order__c') {   
    
     CPA_project_work_order__c Rscr= [Select Id,Name From CPA_project_work_order__c Where Id=:pworfId];
      
      UrlLink = '/'+Label.CPA_ParentId_For_Attachment_CR+'/e?retURL=a00&RecordType='+recordtypeId+Label.CPA_PWO_Name_Field_Id+'='+Rscr.Name+Label.CPA_PWO_Name_Field_Id+'_lkid='+Rscr.Id;
    }
    system.debug('Hi'+UrlLink); 
        PageReference massPageUrl = new PageReference(UrlLink);
        massPageUrl.setRedirect(true);
            
       return massPageUrl;
}

  public PageReference cancelRedirect() {  
         
    String UrlLink = '/'+pworfId ;
    system.debug('Hi'+UrlLink); 
        PageReference massPageUrl = new PageReference(UrlLink);
        massPageUrl.setRedirect(true);
            
       return massPageUrl;
}
    
    
    
     public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
    


}