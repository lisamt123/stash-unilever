/** 
    S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    Replaced by Oblix_ProjectHandlerLogic as part of code refactoring


    About
    -----
    Description: Class Oblix_TR05SOWSplitProjectAvoid
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a fired class from Trigger "" to avoid having more than 100% on split
                        
            Functionnalities : 
                    
    Update History
    --------------    
*/ 
public with sharing class Oblix_TR05SOWSplitProjectAvoid {
    //public static  set<Id> setProjectIds = new set<Id>();
    //public static   List<Oblix_SOW_Projects__c> lstProjects = new List<Oblix_SOW_Projects__c>();
    //public static   Map<Id, Decimal> MapProjectToPercentage = new Map<Id, Decimal>();
    //public static   set<Id> setProjectIdsComment = new set<Id>();
    
    
    ///********************************* Start INSERT /Delete ****************************
    ///*
    //* @Description : Method used to prepare data for project : count percentage and avoid insert split when it exceeds 100%
    //* @param : lstSplitProject from Trigger
    //* @return : void
    //*/  
    //private static  void prepareProjectSplitData(Oblix_Marketing_SOW_Project_Splits__c splitRec, List<Oblix_SOW_Projects__c> lstProject){
    //    /*for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplitProject){
    //        if(split.Id == splitRec.Id){
    //            setProjectIds.add(split.Project_Splits__c);
    //        }
    //    }
    //    System.Debug('###setProjectIds : '+setProjectIds);
    //     lstProjects = [Select Id, Name, (Select Id, Name, Project_Splits__c, Percentage__c from Marketing_SOW_Project_Splits__r) from Oblix_SOW_Projects__c where id = : splitRec.Project_Splits__c];
    //     lstProject = lstProjects ;
    //     */ 
        
    //    if(!lstProject.isEmpty()){
    //        for(Oblix_SOW_Projects__c project : lstProject){
    //                System.debug('###project.Marketing_SOW_Project_Splits__r.size() : '+project.Marketing_SOW_Project_Splits__r.size());
    //                if(splitRec.Project_Splits__c == project.Id && project.Marketing_SOW_Project_Splits__r.size()>0){
    //                    Decimal tmp_percentageSplit = 0;
    //                    for(Oblix_Marketing_SOW_Project_Splits__c split : project.Marketing_SOW_Project_Splits__r){
    //                            if(split.Percentage__c == null) { split.Percentage__c = 0;}
    //                            tmp_percentageSplit += split.Percentage__c;
                           
    //                    }
    //                    //tmp_percentageSplit += splitRec.Percentage__c;
    //                    if(!MapProjectToPercentage.containsKey(project.Id)){
    //                        MapProjectToPercentage.put(project.Id, tmp_percentageSplit);
    //                    }
                    
    //            }
                
                
    //        }
    //    }
    //}
    ///*
    //* @Description : Method used to update project Comment, and Agency scale according to te nmber of records
    //* @return : void
    //*/  
    //private static void UpdateProjectSplitComment(Oblix_Marketing_SOW_Project_Splits__c splitRec, List<Oblix_SOW_Projects__c> lstProject){
        
    //    for(Oblix_SOW_Projects__c proj : lstProject){
    //        if(splitRec.Project_Splits__c == proj.Id){
    //            System.Debug('###proj.Marketing_SOW_Project_Splits__r.size() : '+proj.Marketing_SOW_Project_Splits__r.size());
    //            if(proj.Marketing_SOW_Project_Splits__r.size() == 1){
    //                proj.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners1;
    //            }else if(proj.Marketing_SOW_Project_Splits__r.size() == 2){
    //                proj.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners2;
    //            }else if(proj.Marketing_SOW_Project_Splits__r.size() == 3){
    //                proj.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners3;
    //            }else if(proj.Marketing_SOW_Project_Splits__r.size() == 4){
    //                proj.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners4;
    //            }else if(proj.Marketing_SOW_Project_Splits__r.size() == 5 || proj.Marketing_SOW_Project_Splits__r.size()>= 5){
    //                proj.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners5;
    //            }else{
    //                proj.Project_Scale_2__c = '';
    //            }
                
    //            proj.OblixProjectSplitPercentage_Comment__c = '';
    //            for(Id idProj : setProjectIdsComment){
    //                if(proj.Id == idProj){
    //                    proj.OblixProjectSplitPercentage_Comment__c = 'Total Percentage for that project is below 100%, please raise it';
    //                }
    //            }
    //        }
            
    //    }
    //    //if(!lstProjects.isEmpty()) update lstProjects;
    //}
    ///*
    //* @Description : Method used to avoid insert of split by percentage
    //* @param : lstSplitProject from Trigger
    //* @return : void
    //*/  
    //public static void SOWSplitProjectAvoid(Oblix_Marketing_SOW_Project_Splits__c splitRec, List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitProject
    //    , List<Oblix_SOW_Projects__c> lstProject){
    //   system.Debug('###splitRec : '+splitRec);
    //   system.Debug('###lstProject: '+lstProject);
    //    //Prepare MapProject To split : for each project its own percentage
    //    prepareProjectSplitData(splitRec, lstProject);
    //    //Loop Over the Splits and Avoid Insert or Update if the Percentage is Above > 100%
    //    for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplitProject){
    //        if(split.Id == splitRec.Id){
    //            system.Debug('###MapProjectToPercentage.get(split.Project_Splits__c): '+MapProjectToPercentage.get(split.Project_Splits__c));
    //            if(MapProjectToPercentage.get(split.Project_Splits__c) != null){
    //                if(MapProjectToPercentage.get(split.Project_Splits__c) > 100){
    //                    split.AddError('Total Percentage for that project exceeded 100%, please lower it');
    //                }else if(MapProjectToPercentage.get(split.Project_Splits__c) < 100){
    //                    setProjectIdsComment.add(split.Project_Splits__c);
    //                }
    //            }
    //        }
    //    }
    //    //Call Method to Update project Comment for Split
    //    UpdateProjectSplitComment(splitRec, lstProject);
    //}
    ///****************************** END Insert /Delete *********************************/
    //public static void UpdateProjectWhenisChanged(Oblix_Marketing_SOW_Project_Splits__c splitRec, List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitProjectNew, List<Oblix_SOW_Projects__c> lstProjectNew, List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitProjectOld, List<Oblix_SOW_Projects__c> lstProjectOld){
    //    //SOWSplitProjectAvoid(splitRec,lstSplitProjectOld,lstProjectOld);
    //    SOWSplitProjectAvoid(splitRec,lstSplitProjectNew,lstProjectNew);
        
    //}
    
    ///*******************************************************************
    //    Purpose: get the list of parent Oblix_SOW_Projects__c records and all the related children records
    //    Parameters: List<Oblix_Marketing_SOW_Project_Splits__c> - related children records
    //    Returns: List of Oblix_SOW_Projects__c parents + related Oblix_Marketing_SOW_Project_Splits__c records
    //    Throws [Exceptions]: none
    //********************************************************************/
    //public static List<Oblix_SOW_Projects__c> retrieveProjects(List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitTrig){
    //    set<Id> setProjectsIds = new set<ID>();
    //    for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplitTrig){
    //        setProjectsIds.add(split.Project_Splits__c);
    //    }
    //    return [Select Id, Name, OblixProjectSplitPercentage_Comment__c, Project_Scale_2__c, (Select Id, Name, Project_Splits__c, Percentage__c, OblixCountry__r.Name from Marketing_SOW_Project_Splits__r) from Oblix_SOW_Projects__c  where id in :setProjectsIds];
    //}
    
}