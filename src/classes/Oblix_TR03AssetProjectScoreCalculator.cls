/** 
    S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    Replaced by Oblix_CalculatorLogic as part of code refactoring

    About
    -----
    Description: Class Oblix_TR03AssetProjectScoreCalculator
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a fired class from Trigger  "After insert, update, delete" on SOW Asset object, to calculate the "ProjectTotalAssetScore__c"
                    from the asset record to the project object
                     
            Functionnalities : 
                    
    Update History
    --------------    
*/ 
public with sharing class Oblix_TR03AssetProjectScoreCalculator {
    ///*
    //*    @Description : This method is used to return the list of Project to be updated from the Asset
    //*    @Param : lstAsset
    //*    @return : List<Oblix_SOW_Projects__c>
    //*/
    //public static List<Oblix_SOW_Projects__c> retrieveProjectAgency(List<Oblix_Project_Assets__c> lstAsset){
    //    set<Id> setProjectIds = new set<Id>();
    //    for(Oblix_Project_Assets__c asset : lstAsset){
    //        setProjectIds.add(asset.Agency_Projects__c);
    //    }
    //    return [Select Id, Name, ProjectTotalAssetscore__c, 
    //            (select Id, Name,Asset_Total_Score__c, Asset_Scoring_Number__c from Agency_Project_Assets__r)  
    //            from Oblix_SOW_Projects__c where id in :setProjectIds];
    //}
    // /*
    //*    @Description : This method is used to Calculate total project asset Score
    //*    @Param : Oblix_Project_Assets__c : assetTrig, List<Oblix_Project_Assets__c> : lstAsset, List<Oblix_SOW_Projects__c> : lstProjectAgencies
    //*    @return : List<Oblix_SOW_Projects__c>
    //*/
    //public static List<Oblix_SOW_Projects__c> CalculateProjectScore(Oblix_Project_Assets__c assetTrig, List<Oblix_Project_Assets__c> lstAsset, List<Oblix_SOW_Projects__c> lstProjectAgencies){
        
    //    if(!lstProjectAgencies.isEmpty()){
    //        for(Oblix_SOW_Projects__c project : lstProjectAgencies){
    //            System.debug('###project asset size : '+project.Agency_Project_Assets__r.size());
    //            if(project.Agency_Project_Assets__r.size()>0){
    //                Integer tmp_totalassetScoringNumber = 0;
    //                for(Oblix_Project_Assets__c projectAsset : project.Agency_Project_Assets__r){
    //                    tmp_totalassetScoringNumber += Integer.ValueOf(projectAsset.Asset_Total_Score__c);
    //                }
    //                project.ProjectTotalAssetScore__c = tmp_totalassetScoringNumber;
    //                System.debug('###project.ProjectTotalAssetScore__c : '+project.ProjectTotalAssetScore__c);
    //            }
    //            else
    //            {
    //                // S.M. If the basket is empty, set ProjectTotalAssetScore__c to 0
    //                project.ProjectTotalAssetScore__c = 0;
    //            }
    //        }   
    //    //update lstProjectAgencies;
    //    }
    //    return lstProjectAgencies;
    //}
   
}