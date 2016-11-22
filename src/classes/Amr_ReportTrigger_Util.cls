/********************************************************************
 Name:  Amr_ReportTrigger_Util()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Generate data required for Tracker Master Production                               
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE               DETAIL                 Description
1.0 -   Mahesh Sankapal             05/04/2016          Initial Development  
***********************************************************************/
public with sharing class Amr_ReportTrigger_Util {

    public static void amr_report_trigger_method(List<Amr_Job_Details__c > newAmr_Job_Details, List<Amr_Job_Details__c > oldAmr_Job_Details){
          Map<String,Map<String,Integer>> mapCategoryCluster = new Map<String,Map<String,Integer>>();
          Map<String,Map<String,Integer>> totalCategoryMap = new Map<String,Map<String,Integer>>();
   
          //GOOD IN TIME REPORT BD
          //Map<String,Map<String,Integer>> categoryStageInvolvedMap = new Map<String,Map<String,Integer>>();
          Map<String,Map<String,Integer>> categoryStageOneToTwoMap = new Map<String,Map<String,Integer>>();
          Map<String,Map<String,Integer>> categoryAllStage = new Map<String,Map<String,Integer>>();
          
          //GOOD IN TIME REPORT BB
         // Map<String,Map<String,Integer>> categoryStageInvolvedMapBB = new Map<String,Map<String,Integer>>();
          Map<String,Map<String,Integer>> categoryStageOneToTwoMapBB = new Map<String,Map<String,Integer>>();
          Map<String,Map<String,Integer>> categoryAllStageBB = new Map<String,Map<String,Integer>>();
          
          integer yearValue = 0;
          for(Amr_Job_Details__c jobObj:newAmr_Job_Details){
              yearValue = jobObj.CreatedDate.year();
              break;
          }
          
          List<Amr_Job_Details__c> jobDetailList = [select Stage_of_Production_Activity__c,Budget_Responsibility__c,ProductCategory__r.name,
                                   id,Project_Leader_Cluster__c,Function_You_Are_Part__c,CreatedDate from Amr_Job_Details__c limit 50000];
            
          Amr_ReportHelper helperClass = new Amr_ReportHelper();
            
          mapCategoryCluster = helperClass.mapCategoryClusterData(jobDetailList,yearValue); 
          totalCategoryMap = helperClass.totalCategoryMapData(jobDetailList,yearValue);
                    
          //GOOD IN TIME REPORT BD
          String BudgetResponBD = 'BD';
          
          //categoryStageInvolvedMap = helperClass.categoryStageInvolvedMapData(jobDetailList,yearValue,BudgetResponBD);     
          categoryStageOneToTwoMap = helperClass.categoryStageOneToTwoMapData(jobDetailList,yearValue,BudgetResponBD);
          
         
          categoryAllStage = helperClass.categoryAllStageData(jobDetailList,yearValue,BudgetResponBD);
            
          //GOOD IN TIME REPORT BB
          String BudgetResponBB = 'BB';
         // categoryStageInvolvedMapBB = helperClass.categoryStageInvolvedMapData(jobDetailList,yearValue,BudgetResponBB);
          categoryStageOneToTwoMapBB = helperClass.categoryStageOneToTwoMapData(jobDetailList,yearValue,BudgetResponBB); 
          categoryAllStageBB =  helperClass.categoryAllStageData(jobDetailList,yearValue,BudgetResponBB);
          
           
          List<Amr_Summary_Plan__c> planList = [select id,Year__c,ProductCategory__c,ProductCategory__r.name,Actual_BD__c,Actual_BB__c from Amr_Summary_Plan__c limit 50000];
          
          List<Amr_Summary_Plan__c> planListNew = new List<Amr_Summary_Plan__c>();
          planListNew = helperClass.updatePlanList(planList,totalCategoryMap,yearValue);
          planListNew  = helperClass.totalBDAndBB(planListNew);
          
         // upsert planListNew;
          
          //Update plan for Good In Time BD
          List<Amr_Summary_Plan__c> planNew = new List<Amr_Summary_Plan__c>();
         
          planNew = helperClass.updatePlanListGoodInTime(planList,categoryStageOneToTwoMap,categoryAllStage,yearValue);
          upsert planNew;
          
          //Update plan for Good In Time BB
          List<Amr_Summary_Plan__c> planNewBB = new List<Amr_Summary_Plan__c>();
          
          planNewBB = helperClass.updatePlanListGoodInTimeBB(planList,categoryStageOneToTwoMapBB,categoryAllStageBB,yearValue);
          upsert planNewBB;
          
          
          List<Amr_Summary_Plan__c> planTotalBBAndBD = new List<Amr_Summary_Plan__c>();
          planTotalBBAndBD = helperClass.updatePlanListTotalBDAndBB(planListNew,categoryStageOneToTwoMap,categoryStageOneToTwoMap);
          upsert planTotalBBAndBD;
          
          //for cluster
          List<Amr_Summary_Plan__c> planCategoryCluster = new List<Amr_Summary_Plan__c>(); 
          planCategoryCluster = helperClass.updatePlanCluster(planList,mapCategoryCluster,yearValue);
          upsert planCategoryCluster;
    }
}