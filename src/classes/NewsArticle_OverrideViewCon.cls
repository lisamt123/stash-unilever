public with sharing class NewsArticle_OverrideViewCon{
    
    public News_Article__c article { get; set; }
    public String strRedirectURL {get;set;}
    public string Email {get;set;}  
    public boolean bolmessage {get;set;}
    public string IsComment{get; set;}
    public string Comment{get; set;}
    public string CurrentUrl{get; set;}
    public NewsArticle_OverrideViewCon(ApexPages.StandardController con){
         Email='0';
         CurrentUrl=URL.getSalesforceBaseUrl().toExternalForm();
        if(!Test.isRunningTest())
        con.addFields(new List<String>{'CreatedDate', 'Title__c', 'Sub_Title__c', 'Summary__c', 'Like_Count_RSF__c', 'Comment_Count__c',
                                        'Image_URL__c', 'Sharepoint_URL__c'});
        article = (News_Article__c) con.getRecord();
        
        strRedirectURL = article.Sharepoint_URL__c;     
        Email=ApexPages.currentPage().getParameters().get('fromEmail');
        if(Email=='1') {
         bolmessage=true; }
        else
         Email='0';
     
         }
    
    public PageReference routeOnLoad(){
     
       System.debug('**** article.Sharepoint_URL__c ' + article.Sharepoint_URL__c + '   ' + ApexPages.currentPage().getParameters().get('retURL') + '   ' + Userinfo.getuserID());
        //String strRedirectURL = article.Sharepoint_URL__c;
        strRedirectURL = article.Sharepoint_URL__c;
        
        //PageReference pageref=new PageReference ('/_ui/core/chatter/ui/ChatterPage?nooverride=1');
       // pageref.setRedirect(true); 
        PageReference result=null;
        
        PermissionSetAssignment[] perm;
        
        try{
            Id permSetId = Id.valueOf(uw_Custom_Setting__c.getInstance('NEWS_CENTRE_PERM_SET').Text_Value__c);
            perm = [Select Id from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId()
                                         AND PermissionSetId = :permSetId ];
        }catch(Exception ex){
            System.debug(LoggingLevel.ERROR, 'Exception querying User Permission Set ' + ex.getMessage());
        }
        
           
        if(perm != null && !perm.isEmpty())
            result = new PageReference('/' + article.Id + '?nooverride=1');
        
         return result;
       //return pageref;

    
    }

}