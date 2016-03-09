trigger Amr_Report on Amr_Job_Details__c (after insert, after update) {
	
	Map<String,Map<String,Integer>> mapCategoryCluster = new Map<String,Map<String,Integer>>();
	Map<String,Map<String,Integer>> totalCategoryMap = new Map<String,Map<String,Integer>>();
	
	integer yearValue;
	
	//For csv upload keep year vise data in different sheets 
	
	for(Amr_Job_Details__c jobObj:Trigger.new){
	    system.debug('=========>'+jobObj.CreatedDate);
	    yearValue = jobObj.CreatedDate.year();
	    break;
	}
	
   List<Amr_Job_Details__c> jobDetailList = [select ProductCategory__r.name,id,Project_Location_Cluster__c,Function_You_Are_Part__c,CreatedDate from Amr_Job_Details__c limit 50000];
	
	if(jobDetailList.size()>0){
		
		for(Amr_Job_Details__c jobObj:jobDetailList){
			    system.debug(yearValue+'==========yearComapre=====>'+jobObj.CreatedDate.year());
				
				if(jobObj.CreatedDate.year() == yearValue){
					
					String clusterCategory = jobObj.Project_Location_Cluster__c+','+jobObj.ProductCategory__r.name;
					//system.debug('category+cluster========>'+clusterCategory);
					
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
					
					String Category = jobObj.ProductCategory__r.name;
					//Only category vise map generator
					if(!totalCategoryMap.containsKey(Category) ){				
						//system.debug('inside category Filter=======>');
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

	//system.debug('MAP created=========>'+mapCategoryCluster);
	//system.debug('MAP created=========>Category'+totalCategoryMap);
	
    List<Amr_Summary_Plan__c> planList = [select id,Year__c,Small_C__c,Actual_BD__c,Actual_BB__c from Amr_Summary_Plan__c];
    List<Amr_Summary_Plan__c> newPlansList = new List<Amr_Summary_Plan__c>();
    boolean flag = false;
    for(String categoryKey:totalCategoryMap.keySet()){
    	
        system.debug('All BD values=======>'+totalCategoryMap.get(categoryKey).get('BD'));
        system.debug('All BB values=======>'+totalCategoryMap.get(categoryKey).get('BB'));
        system.debug('All key =======>'+categoryKey);
        
        
        for(Amr_Summary_Plan__c planObj : planList){
        	
        	system.debug(planObj.Small_C__c+'===>category==>'+categoryKey);
        	
        	if(planObj.Small_C__c == categoryKey && planObj.Year__c == string.valueOf(yearValue)){
        		
        		planObj.Actual_BD__c = totalCategoryMap.get(categoryKey).get('BD');
        		planObj.Actual_BB__c = totalCategoryMap.get(categoryKey).get('BB');
        		system.debug('inside if part of object creation ===>'+planObj.id);
        		flag = true;
        		break;
        	}
        	
        }
        
        if(flag == false){
        	  system.debug('inside else part of object creation ===>');
        	  Amr_Summary_Plan__c planObjNew = new Amr_Summary_Plan__c();
        	  planObjNew.Small_C__c = categoryKey;
        	  planObjNew.Year__c = string.valueOf(yearValue);
        	  planObjNew.Actual_BD__c = totalCategoryMap.get(categoryKey).get('BD');
        	  planObjNew.Actual_BB__c = totalCategoryMap.get(categoryKey).get('BB');
        	  newPlansList.add(planObjNew);
        }
        
        flag = false;    
        
    }
    system.debug('new Plan list===>'+newPlansList);
    upsert newPlansList;
    upsert planList;
    
	
}