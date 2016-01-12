public with sharing class IPM_SyncFinanceTableTLD {
    Map<ID, IPM_Project_Rollout__c> localKeyRollouts;
    Map<ID, IPM_Project_Rollout__c> localNonkeyRollouts;
    Map<ID, IPM_Project_Rollout__c> regionalRolloutsMap;
    Map<ID, IPM_Financial__c> financialsMap;
    Map<ID, IPM_Financial_Year__c> financialsYearMap;  
    Set<String> fYearExternalIds;  
    Set<String> updatedfYearExternalIds;  
    private static final String IPM_SYNCFINANCETABLETLD_STR = IPM_SyncFinanceTableTLD.class.getName();
    public void syncProjectRolloutFinancialTLD( Map<ID,IPM_Project_Rollout__c> updatedRollouts ) {
        // Get the local record type id
		String localRolloutRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
        
        financialsMap = new Map<ID,IPM_Financial__c>();  
        localKeyRollouts = new Map<ID, IPM_Project_Rollout__c>();
        localNonkeyRollouts = new Map<ID, IPM_Project_Rollout__c>();
        
        for(ID rolloutId: updatedRollouts.keySet()) {
            IPM_Project_Rollout__c projectRollout = updatedRollouts.get(rolloutId);
            if(projectRollout.RecordTypeId==localRolloutRecordTypeId) {
            	if(projectRollout.KeyMCO__c) {
                	localKeyRollouts.put(rolloutId,projectRollout);
                } else {
                	localNonkeyRollouts.put(rolloutId,projectRollout);
                }
            }

        }
        if(!localNonkeyRollouts.isEmpty()) {
            handleLocalNonkeyRollouts();
        }
        if(!localKeyRollouts.isEmpty()) {
            handleLoalKeyRollouts();
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
        // filter local projects 
    	Map<ID, IPM_Project__c> projects = new Map<ID, IPM_Project__c>(	
    																	[ Select ID, Name, IPM_Target_Launch_Dates__c, IPM_Parent_Project__c,
    																		( Select Name, Financial_External_ID__c 
    																		  From IPM_Financials_Local__r where isActive__c=true) 
    																	  From IPM_Project__c 
    																	  where id in: updatedProjects.keySet() and IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_LOCAL ]);
	
    	// collect projects which has associated financial records
    	Set<ID> projectIdsContainsFinancials = new Set<ID>();
    	Set<ID> projectIdsNotContainsFinancials = new Set<ID>();
    	Set<ID> parentProjectIds = new Set<ID>();
    	for(IPM_Project__c project: projects.values()) {
    		if(!project.IPM_Financials_Local__r.isEmpty()) {
    			projectIdsContainsFinancials.add(project.id);
    		} else if(project.IPM_Parent_Project__c!=null) {
    			parentProjectIds.add(project.IPM_Parent_Project__c);
    			projectIdsNotContainsFinancials.add(project.id);
    		}
    	}
    	if(!projectIdsContainsFinancials.isEmpty()) {
    		for(ID projId: projectIdsContainsFinancials){
    			IPM_Project__c project = projects.get(projId);
    			for(IPM_Financial__c ipmFinancial:project.IPM_Financials_Local__r) {
    				if(ipmFinancial.Financial_External_ID__c==project.name) {
    					ipmFinancial.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
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
    				if( ipmFinancial.Financial_External_ID__c==(parentProj.name+'_CONSOLIDATED') || ipmFinancial.Financial_External_ID__c==(parentProj.name+'_NONKEY') ) {
    					
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
	                                                                                                          where isActive__c=true AND (Financial_External_ID__c like '%NONKEY' or Financial_External_ID__c like '%CONSOLIDATED') ) 
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
			                    if(ipmFinancial.Financial_External_ID__c==regionalProject.name+'_NONKEY' || ipmFinancial.Financial_External_ID__c==regionalProject.name+'_CONSOLIDATED') {
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
    				if((rollout.Local_Project__c==null) || (regionalProject.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && regionalProject.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)) {
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

    }
    private void updateFinancialTables() {
        if(!financialsMap.isEmpty()) {
	        try {
	            Database.update(financialsMap.values(),false);
	        } catch (DMLException dmlException ){
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(	UserInfo.getUserId(),IPM_SYNCFINANCETABLETLD_STR,'handleLoalKeyRollouts',dmlException.getMessage(),dmlException,IPM_ConstantUtils.ERROR,null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION );
	        }
	        updateFinancialYearTables();
        }
    }
     /*
    	This method retrieves local and regional financials and financial year records.
    	Once retrieved the financial year's name & external id fields will be updated with financial's Target Launch Date. 
    	The complexity is due to handling Map/List retrieved from SOQL
    	This is required to minimise the number of SOQLs to avoid Too Many SOQL error 
    	@param  None
  		@return None
    */
    private void updateFinancialYearTables() {
        financialsYearMap = new Map<ID,IPM_Financial_Year__c>();
        fYearExternalIds = new Set<String>();
        updatedfYearExternalIds = new Set<String>();
        // retrieve financial year tabes of financial records
        Map<ID, IPM_Financial__c> retrievedFinancialMap = new Map<ID, IPM_Financial__c>(
                                                                    [Select id, Target_Launch_Date__c, Financial_External_ID__c,
                                                                        (   Select 
                                                                                Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                            From 
                                                                                IPM_Financial_Years__r 
                                                                            where 
                                                                                Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                                ) 
                                                                    From 
                                                                        IPM_Financial__c 
                                                                            where id in : financialsMap.keySet() AND isActive__c=true] );
        for(IPM_Financial__c ipmFinancial: retrievedFinancialMap.values()) {
            for(IPM_Financial_Year__c ipmFinancialYear:ipmFinancial.IPM_Financial_Years__r) {
                fYearExternalIds.add(ipmFinancialYear.External_Id__c);
            }
        }                                                                
        for( IPM_Financial__c ipmFinancial: retrievedFinancialMap.values()){
            Date tmpTLD = ipmFinancial.Target_Launch_Date__c;
            Integer startYear = tmpTLD.year();
            String yearName = '';
            List<IPM_Financial_Year__c> financialYearList = ipmFinancial.IPM_Financial_Years__r;
            if(!financialYearList.isEmpty()) {
	            for(IPM_Financial_Year__c fYear: financialYearList) {
	                if(fYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||fYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS ) {
            
	                    // update year 1 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
	                        yearName = String.valueOf(startYear);
	                        addYearToList(fYear, yearName);
            			}
	                    // update year 2 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
	                        yearName = String.valueOf(startYear+1);
	                        addYearToList(fYear, yearName);
            			}
	                    // update year 3 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
	                        yearName = String.valueOf(startYear+2);
	                        addYearToList(fYear, yearName);
            			}
	                    // update year 4 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y4_YEARINDEX) {
	                        yearName = String.valueOf(startYear+3);
	                        addYearToList(fYear, yearName);
            			}
	                    // update year 5 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y5_YEARINDEX) {
	                        yearName = String.valueOf(startYear+4);
	                        addYearToList(fYear, yearName);
            			}
	                    
	                }
	            }
            }
        } 
        if(!financialsYearMap.isEmpty()) {
            try {
                Database.update(financialsYearMap.values(),false);
            } catch (DMLException dmlException ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(	UserInfo.getUserId(),IPM_SYNCFINANCETABLETLD_STR,'updateFinancialTables',dmlException.getMessage(),dmlException,IPM_ConstantUtils.ERROR,null, null,null,IPM_ConstantUtils.IPM_NG_APPLICATION );
            }
        }
        
    }
    private void addYearToList( IPM_Financial_Year__c fYear, String yearName){
        IPM_Financial_Year__c updateYear = new IPM_Financial_Year__c(ID=fYear.id);
        String yearExtId = fYear.External_Id__c.replace(fYear.Name,yearName);
        if(!updatedfYearExternalIds.contains(yearExtId)) {
            updatedfYearExternalIds.add(yearExtId);
            updateYear.External_Id__c = yearExtId;
            updateYear.Name=yearName;
            financialsYearMap.put(updateYear.id,updateYear);
        }
    }
    public class SyncFinanceTableTLDException extends Exception {}
    
    
}