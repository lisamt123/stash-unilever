/*************************************************************************************************************
* @author:Cognizant
* @date: 19/01/2016
* @description: The methods in the class updates relative financial records when enver there is updates in Rollouts and Projects TLDs

*/

public with sharing class IPM_SyncFinanceTableTLD {
    private String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
    Map<ID, IPM_Project_Rollout__c> localKeyRollouts;
    Map<ID, IPM_Project_Rollout__c> localNonkeyRollouts;
    Map<ID, IPM_Project_Rollout__c> regionalRolloutsMap;
    Map<ID, IPM_Financial__c> financialsMap;
    Map<ID, IPM_Financial_Year__c> financialsYearMap;  
    Set<String> fYearExternalIds;  
    Set<String> updatedfYearExternalIds;
    List<IPM_Project_Rollout__c> consolidationTLDList;	
    
	public void syncProjectRolloutFinancialTLD( Map<ID,IPM_Project_Rollout__c> updatedRollouts ) {
         
        financialsMap = new Map<ID,IPM_Financial__c>();  
        localKeyRollouts = new Map<ID, IPM_Project_Rollout__c>();
        localNonkeyRollouts = new Map<ID, IPM_Project_Rollout__c>();
		consolidationTLDList = new List<IPM_Project_Rollout__c>();
        
        for(ID rolloutId: updatedRollouts.keySet()) {
            IPM_Project_Rollout__c projectRollout = updatedRollouts.get(rolloutId);
            // Collec only local rollouts. Non-local rollouts will be handled via local rollouts
            if(projectRollout.RecordTypeId==LOCAL_ROLLOUT_RECORDTYPE) {
            	if(projectRollout.KeyMCO__c) {
                	// collect KEY Rollouts
                	localKeyRollouts.put(rolloutId,projectRollout);
                } else {
                	// collect NONKEY tollouts
                	localNonkeyRollouts.put(rolloutId,projectRollout);
                }
				consolidationTLDList.add(projectRollout);
            }

        }
        if(!localNonkeyRollouts.isEmpty()) {
            handleLocalNonkeyRollouts();
        }
        if(!localKeyRollouts.isEmpty()) {
            handleLoalKeyRollouts();
        }
		if(!consolidationTLDList.isEmpty()){
            updateConsolidatedFinTLDs();
        }
        updateFinancialTables();
    }
    /*
    	This method retrieves local and regional financials and financial year records from updated project.
    	Once retrieved the financial's Target Launch Date and financial year's name & external id fields will be updated with project's Target Lanuch Date. 
    	The complexity is due to handling Map/List retrieved from SOQL,	will be handled for NONKEY and CONSOLIDATED financials
    	This is required to minimise the number of SOQLs to avoid Too Many SOQL error.
    	@param  IPM_Project__c, updated projects from the trigger
  		@return  None
    */
    public void syncProjectFinancialTLD( Map<ID,IPM_Project__c> updatedProjects ) {
		financialsMap = new Map<ID,IPM_Financial__c>();
        Map<ID, IPM_Project__c> operationalProjects = new Map<ID,IPM_Project__c>();
    	Map<ID, IPM_Project__c> localProjects = new Map<ID,IPM_Project__c>();
    	Map<ID, IPM_Project__c> projects = new Map<ID, IPM_Project__c>(	
                                                                        [ Select ID, Name, IPM_Project_Type__c, IPMProject_Span__c, IPM_Target_Launch_Dates__c, IPM_Parent_Project__c,IPM_Project_Rollout__c,IPM_Project_Rollout__r.Target_Launch_Date__c,
    																		 ( Select Name, Financial_External_ID__c 
    																		   From IPM_Financials_Consolidated__r where isActive__c=true ),
    																		 ( Select Name, Financial_External_ID__c 
    																		   From IPM_Financials_Regional__r where isActive__c=true ),
    																		 ( Select Name, Financial_External_ID__c 
    																		   From IPM_Financials_Local__r where isActive__c=true) 
    																	  From IPM_Project__c 
    																	  where id in: updatedProjects.keySet()]);
        
        for(IPM_Project__c updatedProject: projects.values() ) {
        	if(updatedProject.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) {
        		// filter operational projects 
				operationalProjects.put(updatedProject.id, updatedProject);
        	} else if(updatedProject.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
        		// filter local projects 
				localProjects.put(updatedProject.id, updatedProject);
        	}
        }

		if(!operationalProjects.isEmpty()) {
    		for(IPM_Project__c operationalProject: operationalProjects.values()){
    			if(operationalProject.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) {
         			// Update Global operational projects's financials with projects' TLD
         			for(IPM_Financial__c ipmFinancial:operationalProject.IPM_Financials_Consolidated__r) {
    					ipmFinancial.Target_Launch_Date__c = operationalProject.IPM_Target_Launch_Dates__c;
    			        financialsMap.put(ipmFinancial.id, ipmFinancial);
        			}
    			} else if(operationalProject.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) {
        			// Update Regional operational projects's financials with projects' TLD
         			for(IPM_Financial__c ipmFinancial:operationalProject.IPM_Financials_Regional__r) {
    					ipmFinancial.Target_Launch_Date__c = operationalProject.IPM_Target_Launch_Dates__c;
    			        financialsMap.put(ipmFinancial.id, ipmFinancial);
        			}
    			} else if(operationalProject.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
        			// Update Local operational projects's financials with projects' TLD
         			for(IPM_Financial__c ipmFinancial:operationalProject.IPM_Financials_Local__r) {
    					ipmFinancial.Target_Launch_Date__c = operationalProject.IPM_Target_Launch_Dates__c;
    			        financialsMap.put(ipmFinancial.id, ipmFinancial);
        			}
    			}
    		}
		}
		
		if(!localProjects.isEmpty()) {
	    	Set<ID> projectIdsContainsFinancials = new Set<ID>();
	    	Set<ID> projectIdsNotContainsFinancials = new Set<ID>();
	    	Set<ID> parentProjectIds = new Set<ID>();
	    	for(IPM_Project__c project: localProjects.values()) {
	    		// collect local financials of local projects
	    		if(!project.IPM_Financials_Local__r.isEmpty()) {
	    			projectIdsContainsFinancials.add(project.id);
	    		} 
	    		// if the local project doesnt have financial, get it from parent project
	    		else if(project.IPM_Parent_Project__c!=null) {
	    			parentProjectIds.add(project.IPM_Parent_Project__c);
	    			projectIdsNotContainsFinancials.add(project.id);
	    		}
	    	}
	    	if(!projectIdsContainsFinancials.isEmpty()) {
	    		for(ID projId: projectIdsContainsFinancials){
	    			IPM_Project__c project = localProjects.get(projId);
	    			// Update Local projects's financials with projects' TLD
         			for(IPM_Financial__c ipmFinancial:project.IPM_Financials_Local__r) {
	    				if(ipmFinancial.Financial_External_ID__c==project.name) {
                            ipmFinancial.Target_Launch_Date__c = project.IPM_Project_Rollout__r.Target_Launch_Date__c;
					        financialsMap.put(ipmFinancial.id, ipmFinancial);
	    				}
	    			}
	    		}
	    	}
	    	if(!parentProjectIds.isEmpty()) {
	    		
	        // filter local projects 
	    		Map<ID, IPM_Project__c> parentProjects = new Map<ID, IPM_Project__c>(	
			    																	[ Select ID, Name,
			    																		( Select Name, IPM_Target_Launch_Dates__c 
			    																		  From IPM_Projects__r ),
			    																		( Select Name, Financial_External_ID__c 
			    																		  From IPM_Financials_Regional__r  where isActive__c=true) 
			    																	  From IPM_Project__c 
			    																	  where id in: parentProjectIds and IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ]);
	    		
	    		for(IPM_Project__c parentProj: parentProjects.values()){
	    			for(IPM_Financial__c ipmFinancial:parentProj.IPM_Financials_Regional__r) {
	    				if( ipmFinancial.Financial_External_ID__c==(parentProj.name+'_NONKEY') ) {
	    					// Update Local projects's NONKEY financials with projects' TLD
	    					for(IPM_Project__c proj:parentProj.IPM_Projects__r) {
	    						if(projectIdsNotContainsFinancials.contains(proj.id)) {
			     					ipmFinancial.Target_Launch_Date__c = proj.IPM_Target_Launch_Dates__c;
							      	financialsMap.put(ipmFinancial.id, ipmFinancial);
	    						}
	    					}
	    				}
	    			}
	    		}
	    	}
		}
    	updateFinancialTables();
    }
    /*
    	This method retrieves local and regional financials and financial year records from updated NONKEY MCO rollouts & regional projects.
    	Once retrieved the financial's Target Launch Date and financial year's name & external id fields will be updated with NONKEY MCO rollouts' Target Lanuch Date. 
    	The complexity is due to 
    		handling Map/List retrieved from SOQL
    		calclulating leatest target launch date on local mco rollouts. if the earliest is not updated target launch date there wont be any update to financial records
    		handling  NONKEY and CONSOLIDATED financials
    	This is required to minimise the number of SOQLs to avoid Too Many SOQL error 
    	@param  IPM_Project__c, updated rollouts from the trigger
  		@return  None
    */
   	private void handleLocalNonkeyRollouts() {
        // Get regional rollout ids from local rollouts. 
        // We need this ids to retrieve sibling local rollouts. 
        // The latest Target_Launch_Date__c of the sibling local rollouts is going to be the TLD  of finalcial and financial year records
        Set<ID> regionalRolloutIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localNonkeyRollouts.values()) {
            if(projRollout.Regional_Rollout__c!=null && projRollout.Regional_Project__c ==null ) {
            	regionalRolloutIDs.add(projRollout.Regional_Rollout__c);
            }
            
        }
        if(!regionalRolloutIDs.isEmpty()) {
	        // Get the local  rollouts of the regional rollouts. The rocords are order by Target_Launch_Date__c, so the first record in the list is latest TLD
	        // Get the non-key and consolidated finalcial records of regionla rollout as well
	        regionalRolloutsMap = new Map<ID, IPM_Project_Rollout__c>(  [ Select name, id, External_Id__c, IPM_Project__r.IPM_Phase__c, 
	                                                                                                        ( Select Target_Launch_Date__c 
	                                                                                                          From Local_Rollouts__r
	                                                                                                          where KeyMCO__c !=true AND  isActive__c=true
	                                                                                                          ORDER BY Target_Launch_Date__c ASC NULLS LAST ), 
	                                                                                                        ( Select Financial_External_ID__c 
	                                                                                                          From IPM_Financials__r 
	                                                                                                          where isActive__c=true AND (Financial_External_ID__c like '%NONKEY') ) 
	                                                                                                     From IPM_Project_Rollout__c  
	                                                                                                     where id in : regionalRolloutIDs AND isActive__c=true]);
	        if(!regionalRolloutsMap.isEmpty()) {
		        for(ID rolloutId: regionalRolloutsMap.keySet()) {
		            
		            IPM_Project_Rollout__c regionalRollout = regionalRolloutsMap.get(rolloutId);
		            if(!regionalRollout.Local_Rollouts__r.isEmpty()) {
		            	IPM_Project_Rollout__c localRollout = regionalRollout.Local_Rollouts__r[0];
			            Date earliestTargetLaunchDate = localRollout.Target_Launch_Date__c;
			            // check to see the updated is earliest
			            if(localNonkeyRollouts.containsKey(localRollout.id) && !regionalRollout.IPM_Financials__r.isEmpty()) {
				                    
				                for(IPM_Financial__c ipmFinancial: regionalRollout.IPM_Financials__r) {
				                    // update financial table's Target_Launch_Date__c
				                    ipmFinancial.Target_Launch_Date__c = earliestTargetLaunchDate;
				                    financialsMap.put(ipmFinancial.id, ipmFinancial);
				                
				                }
			            }
		            }
		        }
	        }
        }
        // In Feasibility phase the financial records are associated with regional PROJECT
        Set<ID> regionalProjectIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localNonkeyRollouts.values()) {
            if(projRollout.Regional_Project__c!=null) {
            	regionalProjectIDs.add(projRollout.Regional_Project__c);
            }
        }
        if(!regionalProjectIDs.isEmpty()) {
	        List<IPM_Project__c> regionalProjList = [ SELECT ID, Name,IPM_Project_Type__c,IPMProject_Span__c,
	        											( Select Name, Target_Launch_Date__c,Local_Project_Target_Launch_Date__c, Local_Project__c 
	        											  From Regional_Project_Rollout__r 
	        											  where KeyMCO__c !=true  AND isActive__c=true 
	        											  ORDER BY Target_Launch_Date__c ASC NULLS LAST ),  
	        											( Select id, Financial_External_ID__c, Target_Launch_Date__c 
	        											  From IPM_Financials_Regional__r  where isActive__c=true)   
	        										  FROM IPM_Project__c 
	        										  WHERE id in : regionalProjectIDs];
	        for(IPM_Project__c regionalProject: regionalProjList) {
	        	if(!regionalProject.Regional_Project_Rollout__r.isEmpty()) {
		            	IPM_Project_Rollout__c earliestlocalRollout = regionalProject.Regional_Project_Rollout__r[0];
			            Date earliestTargetLaunchDate = earliestlocalRollout.Target_Launch_Date__c;
			            // check to see the updated is earliest
	                    if(localNonkeyRollouts.containsKey(earliestlocalRollout.id) && !regionalProject.IPM_Financials_Regional__r.isEmpty()) {
			                for(IPM_Financial__c ipmFinancial: regionalProject.IPM_Financials_Regional__r) {
			                    if(ipmFinancial.Financial_External_ID__c==regionalProject.name+'_NONKEY') {
				                    // update financial table's Target_Launch_Date__c
				                    ipmFinancial.Target_Launch_Date__c = earliestTargetLaunchDate;
				                    financialsMap.put(ipmFinancial.id, ipmFinancial);
			                    }
			                }
			            }
			            // update financial record if local rollout is not yet converted to local project
			            for(IPM_Project_Rollout__c localRollout:regionalProject.Regional_Project_Rollout__r) {
			            	if( localRollout.Local_Project__c==null && localNonkeyRollouts.containsKey(localRollout.id)) {
				                for(IPM_Financial__c ipmFinancial: regionalProject.IPM_Financials_Regional__r) {
				                    if(ipmFinancial.Financial_External_ID__c==localRollout.name) {
					                    // update financial table's Target_Launch_Date__c
					                    ipmFinancial.Target_Launch_Date__c = earliestTargetLaunchDate;
					                    financialsMap.put(ipmFinancial.id, ipmFinancial);
				                    }
				                }
			            	}
			            }
	        	}
	        }	
        }
    }
    /*
    	This method retrieves local and regional financials and financial year records from updated KEY MCO rollouts & regional projects.
    	Once retrieved the financial's Target Launch Date and financial year's name & external id fields will be updated with NONKEY MCO rollouts' Target Lanuch Date. 
    	The complexity is due to 
    		handling Map/List retrieved from SOQL
    		calclulating leatest target launch date on local mco rollouts.
    		handling for KEY and CONSOLIDATED financials
    	This is required to minimise the number of SOQLs to avoid Too Many SOQL error 
    	@param  IPM_Project__c, updated rollouts from the trigger
  		@return None
    */
    
	private void handleLoalKeyRollouts() {
        // Get regional rollout ids from local rollouts. 
        // We need this ids to retrieve sibling key local rollouts. 
        // The Target_Launch_Date__c of the sibling key local rollouts is going to be the TLD of finalcial and financial year records
        Set<ID> regionalRolloutIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localKeyRollouts.values()) {
            if(projRollout.Regional_Rollout__c!=null && projRollout.Regional_Project__c ==null ) {
                regionalRolloutIDs.add(projRollout.Regional_Rollout__c);
            }
        }
        // Get the local rollouts of the regional rollouts. The rocords are order by Target_Launch_Date__c, so the first record in the list is latest TLD
        // Get the key finalcial records of regionla rollout as well
        regionalRolloutsMap = new Map<ID, IPM_Project_Rollout__c>(  [ Select id, External_Id__c, 
                                                                        ( Select Target_Launch_Date__c, Name 
                                                                          From Local_Rollouts__r
                                                                          where KeyMCO__c =true AND isActive__c=true), 
                                                                        ( Select Financial_External_ID__c 
                                                                          From IPM_Financials__r 
                                                                          where isActive__c=true AND ( NOT (Financial_External_ID__c like '%NONKEY' or Financial_External_ID__c like '%CONSOLIDATED') ) ) 
                                                                     From IPM_Project_Rollout__c  
                                                                     where id in : regionalRolloutIDs ]);
        
	   	if(!regionalRolloutsMap.isEmpty()) {
	         
	        for(ID rolloutId: regionalRolloutsMap.keySet()) {
	            IPM_Project_Rollout__c regionalRollout = regionalRolloutsMap.get(rolloutId);
	            String rolloutName;
	            Date targetLaunchDate;
	            for(IPM_Project_Rollout__c rollout: regionalRollout.Local_Rollouts__r) {
	                rolloutName = rollout.name;
	                targetLaunchDate = rollout.Target_Launch_Date__c;
	                for(IPM_Financial__c ipmFinancial: regionalRollout.IPM_Financials__r) {
	                    if(ipmFinancial.Financial_External_ID__c==rolloutName) {
	                        // update financial table's Target_Launch_Date__c
	                        ipmFinancial.Target_Launch_Date__c = targetLaunchDate;
				        	financialsMap.put(ipmFinancial.id, ipmFinancial);
	                        break;
	                    }
	                }
	            }
	        }
        }
        
        
        Set<ID> regionalProjectIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localKeyRollouts.values()) {
            if(projRollout.Regional_Project__c!=null) {
            	regionalProjectIDs.add(projRollout.Regional_Project__c);
            }
        }
    	if(!regionalProjectIDs.isEmpty()) {
	        List<IPM_Project__c> regionalProjList = [ SELECT ID, Name,IPM_Project_Type__c,IPMProject_Span__c,
	        											( Select Name, Target_Launch_Date__c, Local_Project__c 
	        											  From Regional_Project_Rollout__r 
	        											  where KeyMCO__c =true AND isActive__c=true),  
	        											( Select id, Financial_External_ID__c, Target_Launch_Date__c 
	        											  From IPM_Financials_Regional__r
	        											  where  isActive__c=true AND (NOT (Financial_External_ID__c like '%NONKEY' or Financial_External_ID__c like '%CONSOLIDATED')) )   
	        										  FROM IPM_Project__c 
	        										  WHERE id in : regionalProjectIDs];
        
		   	for(IPM_Project__c regionalProject: regionalProjList) {
        		// handle regional original project
	        	String rolloutName;
	            Date targetLaunchDate;
	            for(IPM_Project_Rollout__c rollout: regionalProject.Regional_Project_Rollout__r) {
		                rolloutName = rollout.name;
		                targetLaunchDate = rollout.Target_Launch_Date__c;
		                for(IPM_Financial__c ipmFinancial: regionalProject.IPM_Financials_Regional__r) {
		                    if(ipmFinancial.Financial_External_ID__c==rolloutName) {
		                        // update financial table's Target_Launch_Date__c
		                        ipmFinancial.Target_Launch_Date__c = targetLaunchDate;
					        	financialsMap.put(ipmFinancial.id, ipmFinancial);
		                        break;
		                    }
		                }
        		}
	        }
    	
    	}

    }
    private void updateConsolidatedFinTLDs(){
    	
    	Set<ID> globalPrjIDs = new Set<ID>();
    	Set<ID> regionalRolloutIDs = new Set<ID>();
    	
    	for(IPM_Project_Rollout__c  rollout : consolidationTLDList){
    		
    		if(!String.isEmpty(rollout.IPM_Project__c)){
    		   globalPrjIDs.add(rollout.IPM_Project__c);
    		}
    		
    		if(!String.isEmpty(rollout.Regional_Rollout__c)){
    		   regionalRolloutIDs.add(rollout.Regional_Rollout__c);
    		}
    	
    	 }
    	
    	List<IPM_Project_Rollout__c> regionalRolloutList =  [ Select Id, Target_Launch_Date__c,
	                                                           ( Select Target_Launch_Date__c  From Local_Rollouts__r 
	                                                              where  isActive__c=true ORDER BY Target_Launch_Date__c ASC NULLS LAST ), 
	                                                           ( Select Target_Launch_Date__c, Financial_External_ID__c 
	                                                              From IPM_Financials__r   where isActive__c=true
	                                                              AND (recordtypeId =:Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId()) ) 
	                                                         From IPM_Project_Rollout__c  where Id IN : regionalRolloutIDs AND isActive__c=true];
	  
	    if(!regionalRolloutList.isEmpty()) {    
	      
	      for(IPM_Project_Rollout__c regRlout : regionalRolloutList){
	      	
	      	Date regTLd = regRlout.Target_Launch_Date__c;
	      	Date earliestLocalTLd = regRlout.Local_Rollouts__r[0].Target_Launch_Date__c;
	      	Date earliestTLd = regTLd < earliestLocalTLd ? regTLd : earliestLocalTLd ;
	      	
	      	for(IPM_Financial__c conFin :regRlout.IPM_Financials__r){
	      	   
	      	   conFin.Target_Launch_Date__c=earliestTLd;  
	      	   financialsMap.put(conFin.id, conFin);
	      	   
	        }
	      
	      }
	      
	    }
	      
	    List<IPM_Project__c> globalPrjRLoutList = [ Select Id,
	                                                ( Select Target_Launch_Date__c From IPM_Project_Rollout__r
	                                                  where  isActive__c=true ORDER BY Target_Launch_Date__c ASC NULLS LAST ), 
	                                                ( Select Target_Launch_Date__c, Financial_External_ID__c From IPM_Financials_Consolidated__r 
	                                                  where isActive__c=true AND IPM_Project_Rollout__c=null AND (recordtypeId =:Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId()) ) 
	                                                 From IPM_Project__c  where Id in : globalPrjIDs AND Is_Archieved__c=false] ;
	   
	   
	    if(!globalPrjRLoutList.isEmpty()) {    
	      
	      for(IPM_Project__c prj: globalPrjRLoutList) {
	      	
	      	Date earliestTLd = prj.IPM_Project_Rollout__r[0].Target_Launch_Date__c;
	      	for(IPM_Financial__c conFin :prj.IPM_Financials_Consolidated__r) {
	      	   conFin.Target_Launch_Date__c=earliestTLd;
	      	   financialsMap.put(conFin.id, conFin);
	      	} 
	      
	      }
	      
	    }
	}
	
	private void updateFinancialTables() {
        if(!financialsMap.isEmpty()) {
           // removed exception handling as any exceptions/Messages  would be handled at controller 
	        Database.update(financialsMap.values(),false);
        }
    }
}