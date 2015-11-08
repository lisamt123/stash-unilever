/** 
    About
    -----
    Description: Class Utils 
    Created for: Unilever Project
    Create date: 09/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a global class which contains all Global Methods
                         for better maintenance 
            
    Update History
    --------------    
*/
public with sharing class Oblix_Utils {
    
    
//Used to Wrap RecordType By Object
    public static Map<string,ID> MapRecordType(String ObjectName){
     
         List<RecordType> lstRecordType = new List<RecordType>();
         
         lstRecordType = [Select ID,SobjectType,Name,DeveloperName from RecordType where SobjectType=:ObjectName and DeveloperName != 'Admin'];
         
         Map<String,ID> MapRTCaseToDeveloperName = new Map<String,ID>();
         
         for(RecordType rec:lstRecordType)
         {
            MapRTCaseToDeveloperName.put(rec.DeveloperName,rec.ID);
         }
         
         return MapRTCaseToDeveloperName;
        
    }
    public static list<string> lstSubCatPerRecT(string recType){

       list<string> lst = new list<string>(); 
           if(recType == 'Audio Visual'){
               lst.add(Oblix_Constants.UIUX_Origination);
               lst.add('Adaptations and Reedits');
               lst.add('Audio');
               lst.add('Cut downs and Tag');
           }
           if(recType == 'Stimulus Materials - Research requirements'){
               lst.add('Stimulus requirements');
           }
           if(recType == 'Static Imagery'){
               lst.add(Oblix_Constants.UIUX_Origination);
               lst.add('Adaptation');
           }
           if(recType == 'Experiential'){
               lst.add(Oblix_Constants.UIUX_Origination);
               lst.add('Adaptation');
           }
           
           if(recType == 'Digital'){
               lst.add('Specialist Digital');
               lst.add('Digital Campaign Assets');
               lst.add('Digital Adaptation');
               lst.add('Data Analytics Reporting Dashboards');
               lst.add('Always on Social');
           }          
             
       return lst;   
    }
    
    public static list<string> getStageList(){
        
        list<string> lstStage = new list<string>();
        Schema.DescribeFieldResult lstProjectStage = Oblix_SOW_Projects__c.Project_Stage__c.getDescribe();
        List<Schema.PicklistEntry> lstStageValues = lstProjectStage.getPicklistValues();
        for (Schema.PicklistEntry a : lstStageValues){ 
             lstStage.add(a.getLabel()); 
         }
          return lstStage;
    }
    
    public static id CloneProject(id idClonedFrom){
    
     Oblix_SOW_Projects__c project = [Select Id,Name, Innovation_Projects__c ,Campaign_Fees_Total__c,Completed_Stage__c,Financial_Year__r.currency__c,Projected_Stage__c,BET_first_release__c,Value_to_be_paid_in_Current_FY__c,Campaign_Status__c,Preview_Date__c,Start_of_TV_production__c,Final_release__c,Live_Date__c,Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c,Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c,Project_Stage__c,Platform__c,CreatedById, Project_Start_Date__c,CreatedDate,OblixRegion__c,Project_Priority__c,Project_Completion_Date__c,Description__c,OblixCountries__c,First_Air_Date__c,Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id=:idClonedFrom];   
    //project old cloned, and assgned to it self for the new clone, Insert the cloned project   
     project = project.clone();
     insert project;
     //get assets of the parent
     List<Oblix_Project_Assets__c> lstAssetFromParent = [Select Target_Delivery_Date__c, Sub_Category__c,
                                                 RecordTypeId, Quantity__c, OblixClonedFromParentAsset__c, Name, 
                                                 Location__c, Id, FULL_Description__c, CreatedDate, Channels__c, 
                                                 Asset_Type__c, Asset_Total_Score__c, Asset_Scoring_Number__c, Asset_Description__c, 
                                                 Agency_Projects__c, Additional_Description__c, Actual_Delivery_Date__c 
                                                 From Oblix_Project_Assets__c where Agency_Projects__c =: idClonedFrom];
     //clone assets, insert them 
     List<Oblix_Project_Assets__c> lstAssetClone = lstAssetFromParent.deepClone();
                if(!lstAssetClone.isEmpty()){
                    for(Oblix_Project_Assets__c assetClone : lstAssetClone){
                        assetClone.Agency_Projects__c = project.Id;
                    }
                    insert lstAssetClone;
                }                        
     //get splits of the parent         
     List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitFromParent = [Select Id, Name, Project_Splits__c, OblixCountry__c, 
                                                    Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c =: idClonedFrom
                                                                ];
     //clone splits, insert them 
     List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitClone = lstSplitFromParent.deepClone();
            if(!lstSplitClone.isEmpty()){
                for(Oblix_Marketing_SOW_Project_Splits__c splitClone : lstSplitClone){
                    splitClone.Project_Splits__c = project.Id;
                }
                insert lstSplitClone;
            }
        return project.id;     
       }
    
}