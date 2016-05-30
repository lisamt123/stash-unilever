public with sharing class Amr_ReportHelper {
	public Map<String,Map<String,Integer>>  mapCategoryClusterData(List<Amr_Job_Details__c> jobDetailList,integer yearValue){
    Map<String,Map<String,Integer>> mapCategoryCluster = new Map<String,Map<String,Integer>>();
    if(jobDetailList.size()>0){
      
      for(Amr_Job_Details__c jobObj:jobDetailList){
        
        if(jobObj.CreatedDate.year() == yearValue){
          String clusterCategory = jobObj.Project_Leader_Cluster__c+','+jobObj.ProductCategory__r.name;
          //For category and cluster vise map generator
          if(!mapCategoryCluster.containsKey(clusterCategory) ){        
            
            mapCategoryCluster.put(clusterCategory,new Map<String,Integer>());
            mapCategoryCluster.get(clusterCategory).put('BD',0);
            mapCategoryCluster.get(clusterCategory).put('BB',0);
            
            if(jobObj.Function_You_Are_Part__c == 'BD'){
                integer counter = mapCategoryCluster.get(clusterCategory).get('BD');
              mapCategoryCluster.get(clusterCategory).put('BD',counter+1);
            
            }
            
            if(jobObj.Function_You_Are_Part__c == 'BB'){
              integer counter = mapCategoryCluster.get(clusterCategory).get('BB');
              mapCategoryCluster.get(clusterCategory).put('BB',counter+1);
    
            }
            
          }else{
            
            if(jobObj.Function_You_Are_Part__c == 'BD'){
               integer counter = mapCategoryCluster.get(clusterCategory).get('BD');
               mapCategoryCluster.get(clusterCategory).put('BD',counter+1);
  
            }
            
            if(jobObj.Function_You_Are_Part__c == 'BB'){
              integer counter = mapCategoryCluster.get(clusterCategory).get('BB');
              mapCategoryCluster.get(clusterCategory).put('BB',counter+1);
  
            }      
          }
          
          
        }
      }
      
    }
      return mapCategoryCluster;
  }
  
 
  
	public Map<String,Map<String,Integer>>  totalCategoryMapData(List<Amr_Job_Details__c> jobDetailList,integer yearValue){
    	Map<String,Map<String,Integer>> totalCategoryMap = new Map<String,Map<String,Integer>>();
    	if(jobDetailList.size()>0){
      
      		for(Amr_Job_Details__c jobObj:jobDetailList){
        
        	if(jobObj.CreatedDate.year() == yearValue){
         		 String Category = jobObj.ProductCategory__r.name;
            	 //Only category vise map generator
          		if(!totalCategoryMap.containsKey(Category) ){        
            		totalCategoryMap.put(Category,new Map<String,Integer>());
            		totalCategoryMap.get(Category).put('BD',0);
            		totalCategoryMap.get(Category).put('BB',0);
            
        			if(jobObj.Function_You_Are_Part__c == 'BD'){
                		integer counter = totalCategoryMap.get(Category).get('BD');
              			totalCategoryMap.get(Category).put('BD',counter+1);     
            		}
            
            		if(jobObj.Function_You_Are_Part__c == 'BB'){
              			integer counter = totalCategoryMap.get(Category).get('BB');
              			totalCategoryMap.get(Category).put('BB',counter+1);
            		}   
          		}else{
            
            		if(jobObj.Function_You_Are_Part__c == 'BD'){
               			integer counter = totalCategoryMap.get(Category).get('BD');
               			totalCategoryMap.get(Category).put('BD',counter+1);
  
            		}
            
            		if(jobObj.Function_You_Are_Part__c == 'BB'){
              			integer counter = totalCategoryMap.get(Category).get('BB');
              			totalCategoryMap.get(Category).put('BB',counter+1);
  
            		}      
          		}
        	}
      	}
	}
    return totalCategoryMap;
  }
  
  
  public Map<String,Map<String,Integer>>  categoryStageInvolvedMapData(List<Amr_Job_Details__c> jobDetailList,integer yearValue,String BudgetRespon){
     Map<String,Map<String,Integer>> categoryStageInvolvedMap =  new Map<String,Map<String,Integer>>();
    if(jobDetailList.size()>0){
      for(Amr_Job_Details__c jobObj:jobDetailList){
        
        if(jobObj.CreatedDate.year() == yearValue && jobObj.Budget_Responsibility__c == BudgetRespon){
            
            String Category = jobObj.ProductCategory__r.name;
            if(!categoryStageInvolvedMap.containsKey(Category)){
               categoryStageInvolvedMap.put(Category,new Map<String,Integer>());
                 if(!categoryStageInvolvedMap.get(Category).containsKey(jobObj.Stage_of_Production_Activity__c)){
                  categoryStageInvolvedMap.get(Category).put(jobObj.Stage_of_Production_Activity__c,1);
                  
                 }else{
                  integer counter = categoryStageInvolvedMap.get(Category).get(jobObj.Stage_of_Production_Activity__c);
                  categoryStageInvolvedMap.get(Category).put(jobObj.Stage_of_Production_Activity__c,counter +1);
                  
                 }
            }else{
              if(!categoryStageInvolvedMap.get(Category).containsKey(jobObj.Stage_of_Production_Activity__c)){
                  categoryStageInvolvedMap.get(Category).put(jobObj.Stage_of_Production_Activity__c,1);
                  
                }else{
                  integer counter = categoryStageInvolvedMap.get(Category).get(jobObj.Stage_of_Production_Activity__c);
                  categoryStageInvolvedMap.get(Category).put(jobObj.Stage_of_Production_Activity__c,counter +1);
                  
                }

             }  

        }
      }
    }
    return categoryStageInvolvedMap;
  }
  
  
  public Map<String,Map<String,Integer>>  categoryStageOneToTwoMapData(List<Amr_Job_Details__c> jobDetailList,integer yearValue,String BudgetRespon){
    Map<String,Map<String,Integer>> categoryStageOneToTwoMap =  new Map<String,Map<String,Integer>>();
    if(jobDetailList.size()>0){
      for(Amr_Job_Details__c jobObj:jobDetailList){
        if(jobObj.CreatedDate.year() == yearValue && jobObj.Budget_Responsibility__c == BudgetRespon){
          String Category = jobObj.ProductCategory__r.name;
          
          if(!categoryStageOneToTwoMap.containsKey(Category)){
              categoryStageOneToTwoMap.put(Category,new Map<String,Integer>());
            categoryStageOneToTwoMap.get(Category).put(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT,0);
                 
            if(jobObj.Stage_of_Production_Activity__c == 'Before briefing the agency' || jobObj.Stage_of_Production_Activity__c =='Before getting a response to the brief (eg storyboard)'){
              integer counter = categoryStageOneToTwoMap.get(Category).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
                categoryStageOneToTwoMap.get(Category).put(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT,counter+1);
            }
          
          
          }else{
            if(jobObj.Stage_of_Production_Activity__c == 'Before briefing the agency' || jobObj.Stage_of_Production_Activity__c =='Before getting a response to the brief (eg storyboard)'){
                    integer counter = categoryStageOneToTwoMap.get(Category).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
                   categoryStageOneToTwoMap.get(Category).put(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT,counter+1);
            }
          }
        }
      }
      
    }
    return categoryStageOneToTwoMap;
  }
  
  
  public Map<String,Map<String,Integer>>  categoryAllStageData(List<Amr_Job_Details__c> jobDetailList,integer yearValue,String BudgetRespon){
    Map<String,Map<String,Integer>> categoryAllStage =  new Map<String,Map<String,Integer>>();
    if(jobDetailList.size()>0){
      for(Amr_Job_Details__c jobObj:jobDetailList){
        if(jobObj.CreatedDate.year() == yearValue && jobObj.Budget_Responsibility__c == BudgetRespon){
          String Category = jobObj.ProductCategory__r.name;
          
          if(!categoryAllStage.containsKey(Category)){
              categoryAllStage.put(Category,new Map<String,Integer>());
            categoryAllStage.get(Category).put(Amr_ConstantForAdManager.ALL_COUNT,0);
              
            if(jobObj.Stage_of_Production_Activity__c!=null){
                integer counter = categoryAllStage.get(Category).get(Amr_ConstantForAdManager.ALL_COUNT);
                categoryAllStage.get(Category).put(Amr_ConstantForAdManager.ALL_COUNT,counter+1);
            }
          
          }else{
            if(jobObj.Stage_of_Production_Activity__c!=null){
                integer counter = categoryAllStage.get(Category).get(Amr_ConstantForAdManager.ALL_COUNT);
                categoryAllStage.get(Category).put(Amr_ConstantForAdManager.ALL_COUNT,counter+1);
              }
          }
        }
      }
    }
    return categoryAllStage;
  }
  
  public List<Amr_Summary_Plan__c> updatePlanList(List<Amr_Summary_Plan__c> planList,Map<String,Map<String,Integer>> totalCategoryMap,integer yearValue){
    boolean flag = false;
    List<Amr_Summary_Plan__c> newPlansList = new List<Amr_Summary_Plan__c>();
    
    for(String categoryKey:totalCategoryMap.keySet()){

          for(Amr_Summary_Plan__c planObj : planList){
          
           
          
            if(planObj.ProductCategory__r.name == categoryKey && planObj.Year__c == string.valueOf(yearValue)){
            
              planObj.Actual_BD__c = totalCategoryMap.get(categoryKey).get('BD');
              planObj.Actual_BB__c = totalCategoryMap.get(categoryKey).get('BB');
              
              flag = true;
              break;
            } 
          }       
       }
       
       
       planList.addAll(newPlansList);
       
       return planList;
  }
   
   //cluster
  public List<Amr_Summary_Plan__c> updatePlanCluster(List<Amr_Summary_Plan__c> planList,Map<String,Map<String,Integer>> mapCategoryCluster,integer yearValue){
    
    for(String categoryKey:mapCategoryCluster.keySet()){
         for(Amr_Summary_Plan__c planObj : planList){
         
              if(planObj.ProductCategory__r.name == categoryKey.substringAfter(',') && planObj.Year__c == string.valueOf(yearValue)){
                   
                   if(categoryKey.substringBefore(',') == 'Africa'){
                        planObj.AfricaBB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.AfricaBD__c = mapCategoryCluster.get(categoryKey).get('BD');
                      
                        break;
                   }
                   
                    if(categoryKey.substringBefore(',') == 'Europe'){
                        planObj.EuropeBB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.EuropeBD__c = mapCategoryCluster.get(categoryKey).get('BD');
                     
                        break;
                    }
                    
                    if(categoryKey.substringBefore(',') == 'Latin America'){
                        planObj.Latin_AmericaBB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.Latin_AmericaBD__c = mapCategoryCluster.get(categoryKey).get('BD');
                      
                        break;
                    }
                    
                    if(categoryKey.substringBefore(',') == 'NAMET & RUB'){
                        planObj.NAMET_RUB_BB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.NAMET_RUB_BD__c = mapCategoryCluster.get(categoryKey).get('BD');
                      
                        break;
                    }
                    if(categoryKey.substringBefore(',') == 'North America'){
                        planObj.North_America_BB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.North_America_BD__c = mapCategoryCluster.get(categoryKey).get('BD');
                       
                        break;
                    }
                     if(categoryKey.substringBefore(',') == 'North Asia'){
                        planObj.North_Asia_BB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.North_Asia_BD__c = mapCategoryCluster.get(categoryKey).get('BD');
                      
                        break;
                    }
                    if(categoryKey.substringBefore(',') == 'SEAA'){
                        planObj.SEAA_BB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.SEAA_BD__c = mapCategoryCluster.get(categoryKey).get('BD');
                        
                        break;
                    }
                    if(categoryKey.substringBefore(',') == 'South Asia'){
                        planObj.South_Asia_BB__c = mapCategoryCluster.get(categoryKey).get('BB');
                        planObj.South_Asia_BD__c = mapCategoryCluster.get(categoryKey).get('BD');
                     
                        break;
                    }
              }
         }
    }
    return planList;
  } 
  
  public List<Amr_Summary_Plan__c> updatePlanListGoodInTime(List<Amr_Summary_Plan__c> planList,Map<String,Map<String,Integer>> categoryStageOneToTwoMap,Map<String,Map<String,Integer>> categoryAllStage,integer yearValue){
   
     for(String categoryVal:categoryAllStage.keySet()){
      
       for(String categoryValue :categoryStageOneToTwoMap.keySet()){
        
        if(categoryValue == categoryVal){
          integer counter1 = categoryStageOneToTwoMap.get(categoryValue).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
          integer counter2 = categoryAllStage.get(categoryValue).get(Amr_ConstantForAdManager.ALL_COUNT);
        
          integer percentBD = counter1 * 100/counter2;
          
          for(Amr_Summary_Plan__c planObj : planList){     
            if(planObj.ProductCategory__r.name == categoryValue){
               planObj.In_Good_Time_BD__c =  percentBD;
             
               break;
            }
          }
        
        }
      
      }
    
    }
 
  return planList;
  }
  
   public List<Amr_Summary_Plan__c> updatePlanListGoodInTimeBB(List<Amr_Summary_Plan__c> planList,Map<String,Map<String,Integer>> categoryStageOneToTwoMap,Map<String,Map<String,Integer>> categoryAllStage,integer yearValue){
     
     for(String categoryVal:categoryAllStage.keySet()){
      
       for(String categoryValue :categoryStageOneToTwoMap.keySet()){
        
        if(categoryValue == categoryVal){
          integer counter1 = categoryStageOneToTwoMap.get(categoryValue).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
          integer counter2 = categoryAllStage.get(categoryValue).get(Amr_ConstantForAdManager.ALL_COUNT);
        
          integer percentBD = counter1 * 100/counter2;
          
          
          for(Amr_Summary_Plan__c planObj : planList){     
            if(planObj.ProductCategory__r.name == categoryValue){
               planObj.In_Good_Time_BB__c =  percentBD;
             
               break;
            }
          }
          
        }
      
      }
    
    }
  
  return planList;
  }
  
  public List<Amr_Summary_Plan__c> totalBDAndBB(List<Amr_Summary_Plan__c> planList){
      Double total = 0;
      Map<String,Integer> BDBBMap = new Map<String, Integer>();
     
      for(Amr_Summary_Plan__c pList : planList){
          
          if(pList.Actual_BB__c != null && pList.Actual_BD__c != null){
               total = pList.Actual_BB__c + pList.Actual_BD__c;
          }else
          if(pList.Actual_BB__c == null){
              total = pList.Actual_BD__c;
          }else
          if(pList.Actual_BD__c == null){
              total = pList.Actual_BB__c;
          }
         
          pList.Actual_BB_And_BB__c = total;
      
      }    
   return planList;
  }
    public List<Amr_Summary_Plan__c> updatePlanListTotalBDAndBB(List<Amr_Summary_Plan__c> planList,Map<String,Map<String,Integer>> categoryStageOneToTwoMapBD,Map<String,Map<String,Integer>> categoryStageOneToTwoMapBB){
    
    Map<String, Integer> totalCountOfStage = new Map<String, Integer>();
    
    Integer total = 0;
   
    for(Amr_Summary_Plan__c pList : planList){
        total = 0;
        if(pList.ProductCategory__r.name != null ){
           
            if(categoryStageOneToTwoMapBD.containsKey(pList.ProductCategory__r.name ) && categoryStageOneToTwoMapBB.containsKey(pList.ProductCategory__r.name ) ){
                total = categoryStageOneToTwoMapBD.get(pList.ProductCategory__r.name).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT) + categoryStageOneToTwoMapBB.get(pList.ProductCategory__r.name).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
            }else
            if(!categoryStageOneToTwoMapBD.containsKey(pList.ProductCategory__r.name )&& categoryStageOneToTwoMapBB.containsKey(pList.ProductCategory__r.name ) ){
                total = categoryStageOneToTwoMapBB.get(pList.ProductCategory__r.name).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
            }else
            if(!categoryStageOneToTwoMapBB.containsKey(pList.ProductCategory__r.name ) && categoryStageOneToTwoMapBD.containsKey(pList.ProductCategory__r.name ) ){
                total = categoryStageOneToTwoMapBD.get(pList.ProductCategory__r.name).get(Amr_ConstantForAdManager.STAGE_ONEANDTWOCOUNT);
            }
            if(pList.Actual_BB_And_BB__c != 0){
                pList.In_Good_Time_BD_BB__c = (total / pList.Actual_BB_And_BB__c)*100;
            }
        }
    }
    return planList;
    }
  
}