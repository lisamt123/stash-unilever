public with sharing class userFeedbackCTRL {
    @auraEnabled
    public static USER getUserInfo(string userId){
		return [select id, name from user where id = :userId];
    }
    
    @auraEnabled
    public static list<User_Feedback__c> history(string userId){
        
        list<User_Feedback__c> feedback = new List<User_Feedback__c>();
        //try{
            feedback = [select id, name, feedback__c, Status__c, type__c, Age__c, Enterprise_Architect__c,Object_Type__c, Project__c, createddate from User_Feedback__c where createdById = :userId order by createdDate DESC];
        //}catch(exception e){
            //nothing
        //}
        
        return feedback;
    }
    
    
    private static void getProjectDetails(User_Feedback__c uf){
        id recId = (Id)uf.Record_id__c;
        
        Schema.SObjectType sobjectType = recId.getSObjectType();
        
        string obname = sobjectType.getDescribe().getName();
        uf.Object_Type__c = obname;
        
        
    }
    
    private static void getEADetails(User_Feedback__c uf){
        
        //return if there is no associated object
        
        if(uf.Object_Type__c == null || uf.Object_Type__c==''){
            return;
        }
            
        string obname = uf.Object_Type__c;
        
        //strip out custom object identifier
        
        if(obname.contains('__c')){
            obname.replace('__c', '');
        }
        
        //Standard Objects or those without Prefix probably dont have an owner
        //so ignore standard objects?!
        
        if(obname.contains('_')){
            string[] items = obname.split('_');
            //take the prefix
            string prefix = items[0];
            
            //Check there is a mapping to the prefix in custom settings
            Global_Object_Ownership__c prefixVal = Global_Object_Ownership__c.getInstance(prefix);
            
            //Copy the project prefix mapping
            if(prefixVal!=null){
                uf.Project__c = prefixVal.Project__c;
                //Try and Match the EA based on full name - not entirely happy with this join as might be two people with same name in Unilever
                
                try{
                    uf.Enterprise_Architect__c = [select id from user where email = :prefixVal.Enterprise_Architect__c limit 1].id;
                }catch(exception e){
                    
                }
                                
            }
        }
    }
    
    //Void Method because publisher action closes on save
    @auraEnabled
    public static void insertFeedback(User_Feedback__c uf){
        
        
        if(uf.Record_id__c !=null && uf.Record_id__c!=''){
            
           userFeedbackCTRL.getProjectDetails(uf);
           userFeedbackCTRL.getEADetails(uf);
            
            
        }
            
		
        
        insert uf;
        
    }
    
    
}