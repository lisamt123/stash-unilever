public with sharing class Themes {
    
   @AuraEnabled
    public static List<All_Themes__c> getThemes(){
        
        List<All_Themes__c> themeName=[Select 	Name from All_Themes__c LIMIT 6];
        
        return themeName;
        
    }
}