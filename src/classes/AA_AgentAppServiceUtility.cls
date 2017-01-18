public  with sharing class AA_AgentAppServiceUtility {
    
   public static String getClusterIsNull(aa_Agent_App_User_Preference__c UserPref,String countryQueryParam){
        String soqlquery = '';
        aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
        if(UserPref.Country__c != null && UserPref.Cluster__c == null )
        {
            soqlquery +=' AND ( Country__c = '+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;   
            // get cluster id for this country
            aa_Country__c countyclustidlst=[Select  Cluster_Id__c from  aa_Country__c where Id=:UserPref.Country__c];
            soqlquery+= ' OR (ClusterId__c='+AA_Constants.Escapechar+countyclustidlst.Cluster_Id__c+AA_Constants.Escapechar;
            soqlquery+= countryQueryParam;
            soqlquery+=' OR  ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+ ' )';
            
        } 
        return soqlquery;
    }
    
    public static String getClusterAndCountryIsNotNull(aa_Agent_App_User_Preference__c UserPref,String countryQueryParam){
        String soqlquery = '';
        
        aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
         if(UserPref.Cluster__c  != null &&  UserPref.Country__c !=null){
            soqlquery+=' AND (country__c= '+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;
            soqlquery+=' OR (ClusterId__c = '+AA_Constants.Escapechar+UserPref.Cluster__c +AA_Constants.Escapechar;
            soqlquery+= countryQueryParam;
            soqlquery+=' OR ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
        }
        return soqlquery;
    }
    
    public static String getClusterIsNotNull(aa_Agent_App_User_Preference__c UserPref,String countryQueryParam){
        String soqlquery = '';
        aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
         if(UserPref.Cluster__c  != null && UserPref.Country__c == null ){
            //if global only selected
            if(UserPref.Cluster__c == globalclustId.id)
            {
                soqlquery+=' AND ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar;
            }else{
                soqlquery+=' AND (ClusterId__c = '+AA_Constants.Escapechar+UserPref.Cluster__c +AA_Constants.Escapechar;
                soqlquery +=' OR (Country__r.Cluster_Id__c ='+AA_Constants.Escapechar+UserPref.Cluster__c+AA_Constants.Escapechar;
                soqlquery+= countryQueryParam;
                soqlquery+=' OR ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
            }                                                                       
        }
        return soqlquery;
    }
    
    public static String getPrepareSqlWithUserPref(aa_Agent_App_User_Preference__c UserPref){
        String soqlquery='';
        String countryQueryParam=' AND country__c=null)';
        //aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
        //if country only selected
        
        soqlquery += getClusterIsNull(UserPref, countryQueryParam);
        
        soqlquery += getClusterAndCountryIsNotNull(UserPref, countryQueryParam);
        
        soqlquery += getClusterIsNotNull(UserPref, countryQueryParam);
       
        
                
        if(UserPref.Agent_App_Unilever_Brand__c!=null)
        {
          soqlquery +=' AND Agent_App_Unilever_Brand__c ='+AA_Constants.Escapechar+UserPref.Agent_App_Unilever_Brand__c+AA_Constants.Escapechar;
        }                
        if(UserPref.Competitor_Name__c !=null)
        {
          soqlquery +=' AND Competitor_Name__c='+AA_Constants.Escapechar+UserPref.Competitor_Name__c+AA_Constants.Escapechar;
        }                
        if(UserPref.Competitor_Brand__c !=null)
        {
           soqlquery +=' AND Competitor_Brand__c ='+AA_Constants.Escapechar+UserPref.Competitor_Brand__c+AA_Constants.Escapechar;
        }                
        if(UserPref.Retailer__c !=null)
        {
           soqlquery +=' AND Retailer__c ='+AA_Constants.Escapechar+UserPref.Retailer__c+AA_Constants.Escapechar;
        }                
        if(UserPref.Category__c !=null)
        {
           soqlquery +=' AND Category__c ='+AA_Constants.Escapechar+UserPref.Category__c+AA_Constants.Escapechar;
        }  
 
        if(UserPref.RecordTypeId__c!=null)
        {
            soqlquery +=' AND RecordTypeId  = '+AA_Constants.Escapechar+UserPref.RecordTypeId__c+AA_Constants.Escapechar;    
        }       
        if(UserPref.Topic__c!=null)
        {
            soqlquery +=' AND Topic__c ='+AA_Constants.Escapechar+UserPref.Topic__c+AA_Constants.Escapechar;
        }
        if(UserPref.ReportingOn__c!=null)
        {
            soqlquery +=' AND Reporting_on__c = '+AA_Constants.Escapechar+UserPref.ReportingOn__c+AA_Constants.Escapechar;
        }
        
        return soqlquery;
    }
}