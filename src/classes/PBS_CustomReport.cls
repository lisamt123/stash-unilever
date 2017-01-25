public class PBS_CustomReport {
    public  Map<String,Map<String,PBS_Profile__c>> reportDataMap {get;set;}
    public  Map<String,Map<String, PBS_Training_Track_Level_Item__c>> reportTrackDataMap {get;set;}
    public  Map<String,PBS_Training_Plan_Assignment__c> tpAssignmentMap {get;set;}
    public  Map<String, PBS_Training_Track_Level_Item__c>  ttlavelitemMap {get;set;}
    public  Map<String, PBS_Training_Track_Level_Item__c>  ttlavelitemMap2 {get;set;}
    public PBS_CustomReport(){
        reportDataMap = new Map<String,Map<String,PBS_Profile__c>>();
        tpAssignmentMap = new Map<String,PBS_Training_Plan_Assignment__c>();
        ttlavelitemMap = new Map<String,PBS_Training_Track_Level_Item__c>();
        ttlavelitemMap2 = new Map<String,PBS_Training_Track_Level_Item__c>();
        getTrainingPlanAssignment();        
    }
    
    private void getTrainingPlanAssignment(){
        Map<String,PBS_Profile__c> profileMap = new Map<String,PBS_Profile__c>();
        
        for(PBS_Training_Plan_Assignment__c tpa : [Select Id,name, CreatedDate, Completed_On__c,Duration__c,Expected_Completion_Date__c,Status__c,Thirty_Days_Completed__c,Training_Plan__c,User__c From PBS_Training_Plan_Assignment__c]){
            tpAssignmentMap.put(tpa.Training_Plan__c, tpa);
        }      
        
        for(PBS_Profile__c p : [Select Id,name,Category__c,Geography__c,user_role__r.Name,Work_Level__c,User__c,User__r.Manager.Name,User__r.Country From PBS_Profile__c]){
            profileMap.put(p.User__c, p);
        }
        
        for(PBS_Training_Track_Level_Item__c ttl : [SELECT name, Training_Track_Level__r.Training_Track__r.name, Training_Track_Level__r.Training_Track__r.CreatedDate, Training_Plan__c FROM PBS_Training_Track_Level_Item__c]){
            ttlavelitemMap.put(ttl.Training_Plan__c, ttl);
        }
        
        Map<String,PBS_Profile__c> profile = new Map<String,PBS_Profile__c>();
        PBS_Training_Track_Level_Item__c ttlival2 = new PBS_Training_Track_Level_Item__c(); 
        
        for(PBS_Training_Plan_Assignment__c tpaVal : tpAssignmentMap.values()){
            for(PBS_Profile__c profileVal : profileMap.values()){
               //if 2nd map does not have that key
               if(profileMap.keyset().contains(tpaVal.User__c)){
                    profile.put(profileVal.User__c,profileVal);
                    reportDataMap.put(tpaVal.Training_Plan__c,profile);
               }else{
                    profile.put(tpaVal.User__c,profileVal);
                    reportDataMap.put(tpaVal.Training_Plan__c,profile);                   
               }
            }
            
            for(PBS_Training_Track_Level_Item__c ttliVal : ttlavelitemMap.values()){
               //if 2nd map does not have that key
               if(ttlavelitemMap.keyset().contains(tpaVal.Training_Plan__c)){
                    ttlavelitemMap2.put(tpaVal.Training_Plan__c, ttliVal);
               }else{
                    ttlavelitemMap2.put(tpaVal.Training_Plan__c, ttlival2);                   
               }
            }
            
        }        
        system.debug('reportdata map---->'+reportDataMap);
    }    
}