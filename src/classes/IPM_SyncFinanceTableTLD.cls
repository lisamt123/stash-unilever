public class IPM_SyncFinanceTableTLD {
    Map<ID, IPM_Project_Rollout__c> localKeyRollouts;
    Map<ID, IPM_Project_Rollout__c> localNonkeyRollouts;
    Map<ID, IPM_Project_Rollout__c> regionalRolloutsMap;
    Map<ID, IPM_Financial__c> financialsMap;    
    private static final String IPM_SYNCFINANCETABLETLD_STR = IPM_SyncFinanceTableTLD.class.getName();
    public IPM_SyncFinanceTableTLD() {
        
    }
    public void syncProjectRolloutFinancialTLD( Map<ID,IPM_Project_Rollout__c> updatedRollouts ) {
        //System.debug('RTDebug updatedRollouts ' + updatedRollouts);
        // Get the local record type id
        String localRolloutRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
        
        
        localKeyRollouts = new Map<ID, IPM_Project_Rollout__c>();
        localNonkeyRollouts = new Map<ID, IPM_Project_Rollout__c>();
        
        for(ID rolloutId: updatedRollouts.keySet()) {
            IPM_Project_Rollout__c projectRollout = updatedRollouts.get(rolloutId);
            if(projectRollout.RecordTypeId==localRolloutRecordTypeId) {
            	if(projectRollout.KeyMCO__c==true) {
                	localKeyRollouts.put(rolloutId,projectRollout);
                } else {
                	localNonkeyRollouts.put(rolloutId,projectRollout);
                }
            }

        }
        if(localNonkeyRollouts.size()>0) {
            System.debug('RTDebug localNonkeyRollouts ' + localNonkeyRollouts);
            handleLocalNonkeyRollouts();
        }
        if(localKeyRollouts.size()>0) {
            System.debug('RTDebug localKeyRollouts ' + localKeyRollouts);
            handleLoalKeyRollouts();
        }
        
    }
    public void syncProjectFinancialTLD( Map<ID,IPM_Project__c> updatedProjects ) {
    	System.debug('RTDebug syncProjectFinancialTLD updatedProjects ' + updatedProjects);
    	financialsMap = new Map<ID,IPM_Financial__c>();
        List<IPM_Financial__c> financialsList = new List<IPM_Financial__c>();
        // filter local projects 
    	Map<ID, IPM_Project__c> projects = new Map<ID, IPM_Project__c>(	
    																	[ Select ID, Name, IPM_Target_Launch_Dates__c, IPM_Parent_Project__c,
    																		( Select Name, Financial_External_ID__c 
    																		  From IPM_Financials_Local__r) 
    																	  From IPM_Project__c 
    																	  where id in: updatedProjects.keySet() and IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_LOCAL ]);
	
    	// collect projects which has associated financial records
    	Set<ID> projectIdsContainsFinancials = new Set<ID>();
    	Set<ID> projectIdsNotContainsFinancials = new Set<ID>();
    	Set<ID> parentProjectIds = new Set<ID>();
    	for(IPM_Project__c project: projects.values()) {
    		if(project.IPM_Financials_Local__r.size()>0) {
    			projectIdsContainsFinancials.add(project.id);
    		} else if(project.IPM_Parent_Project__c!=null) {
    			parentProjectIds.add(project.IPM_Parent_Project__c);
    			projectIdsNotContainsFinancials.add(project.id);
    		}
    	}
    	if(projectIdsContainsFinancials.size()>0) {
    		for(ID projId: projectIdsContainsFinancials){
    			IPM_Project__c project = projects.get(projId);
    			for(IPM_Financial__c ipmFinancial:project.IPM_Financials_Local__r) {
    				if(ipmFinancial.Financial_External_ID__c==project.name) {
    					ipmFinancial.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
				        financialsList.add(ipmFinancial);
				        financialsMap.put(ipmFinancial.id, ipmFinancial);
    				}
    			}
    		}
    	}
    	if(parentProjectIds.size()>0) {
    		
        // filter local projects 
    		Map<ID, IPM_Project__c> parentProjects = new Map<ID, IPM_Project__c>(	
		    																	[ Select ID, Name,
		    																		( Select Name, IPM_Target_Launch_Dates__c 
		    																		  From IPM_Projects__r ),
		    																		( Select Name, Financial_External_ID__c 
		    																		  From IPM_Financials_Regional__r ) 
		    																	  From IPM_Project__c 
		    																	  where id in: parentProjectIds and IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ]);
    		
    		for(IPM_Project__c parentProj: parentProjects.values()){
    			for(IPM_Financial__c ipmFinancial:parentProj.IPM_Financials_Regional__r) {
    				if( ipmFinancial.Financial_External_ID__c==(parentProj.name+'_CONSOLIDATED') || ipmFinancial.Financial_External_ID__c==(parentProj.name+'_NONKEY') ) {
    					
    					for(IPM_Project__c proj:parentProj.IPM_Projects__r) {
    						if(projectIdsNotContainsFinancials.contains(proj.id)) {
		     					ipmFinancial.Target_Launch_Date__c = proj.IPM_Target_Launch_Dates__c;
						        financialsList.add(ipmFinancial);
						        financialsMap.put(ipmFinancial.id, ipmFinancial);
    						}
    					}
    				}
    			}
    		}
    	}
 		if(financialsList.size()>0) {
	 		try {
	            update financialsList;
	        } catch (DMLException dmlException ){
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                
                ExceptionLoggingHelper.createErrorLog(	UserInfo.getUserId(),
                										IPM_SYNCFINANCETABLETLD_STR,
                    									'handleLocalNonkeyRollouts',
                    									dmlException.getMessage(),
                    									dmlException, 
                    									IPM_ConstantUtils.ERROR, 
                    									null, 
                    									null, 
                    									null, 
                    									IPM_ConstantUtils.IPM_NG_APPLICATION );
	        }
 		}
        if(financialsMap.size()>0) {
            updateFinancialTables();
        }
    }
   	private void handleLocalNonkeyRollouts() {
        // Get regional rollout ids from local rollouts. 
        // We need this ids to retrieve sibling local rollouts. 
        // The latest Target_Launch_Date__c of the sibling local rollouts is going to be the TLD  of finalcial and financial year records
        //System.debug('RTDebug handleLocalNonkeyRollouts localNonkeyRollouts ' + localNonkeyRollouts);
        Set<ID> regionalRolloutIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localNonkeyRollouts.values()) {
            System.debug('RTDebug handlelocalNonkeyRollouts projRollout ' + projRollout.name);
            if(projRollout.Regional_Rollout__c!=null) {
            	regionalRolloutIDs.add(projRollout.Regional_Rollout__c);
            }
            
        }
        System.debug('RTDebug regionalRolloutIDs ' + regionalRolloutIDs);
        List<IPM_Financial__c> financialsList = new List<IPM_Financial__c>();
        financialsMap = new Map<ID,IPM_Financial__c>();
        if(regionalRolloutIDs.size()>0) {
	        // Get the local  rollouts of the regional rollouts. The rocords are order by Target_Launch_Date__c, so the first record in the list is latest TLD
	        // Get the non-key and consolidated finalcial records of regionla rollout as well
	        regionalRolloutsMap = new Map<ID, IPM_Project_Rollout__c>(  [ Select name, id, External_Id__c, IPM_Project__r.IPM_Phase__c, 
	                                                                                                        ( Select Target_Launch_Date__c 
	                                                                                                          From Local_Rollouts__r
	                                                                                                          where KeyMCO__c !=true 
	                                                                                                          ORDER BY Target_Launch_Date__c ASC NULLS LAST ), 
	                                                                                                        ( Select Financial_External_ID__c 
	                                                                                                          From IPM_Financials__r 
	                                                                                                          where Financial_External_ID__c like '%NONKEY' or Financial_External_ID__c like '%CONSOLIDATED' ) 
	                                                                                                     From IPM_Project_Rollout__c  
	                                                                                                     where id in : regionalRolloutIDs ]);
	        if(regionalRolloutsMap.size()>0) {
		        //System.debug('RTDebug regionalRolloutsMap ' + regionalRolloutsMap);
		        for(ID rolloutId: regionalRolloutsMap.keySet()) {
		            
		            IPM_Project_Rollout__c regionalRollout = regionalRolloutsMap.get(rolloutId);
		            if(regionalRollout.Local_Rollouts__r.size()>0) {
		            	IPM_Project_Rollout__c localRollout = regionalRollout.Local_Rollouts__r[0];
			            Date earliestTargetLaunchDate = localRollout.Target_Launch_Date__c;
			            // check to see the updated is earliest
			           // if(localNonkeyRollouts.containsKey(localRollout.id)) {
				            System.debug('RTDebug latest rollout ' + regionalRollout.name);
				            System.debug('RTDebug earliestTargetLaunchDate ' + earliestTargetLaunchDate);
				                    
				            if(regionalRollout.IPM_Financials__r.size()>0) {
				                for(IPM_Financial__c ipmFinancial: regionalRollout.IPM_Financials__r) {
				                    // update financial table's Target_Launch_Date__c
				                    ipmFinancial.Target_Launch_Date__c = earliestTargetLaunchDate;
				                    System.debug('RTDebug ipmFinancial ' + ipmFinancial.Financial_External_ID__c);
				                    System.debug('RTDebug ipmFinancial year ' + ipmFinancial.Target_Launch_Date__c);
				            		financialsList.add(ipmFinancial);
				                    financialsMap.put(ipmFinancial.id, ipmFinancial);
				                
				                }
				            }
			           // }
		            }
		        }
	        }
        }
        // In Feasibility phase the financial records are associated with regional PROJECT
        Set<ID> regionalProjectIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localNonkeyRollouts.values()) {
            System.debug('RTDebug handleLocalRollouts projRollout ' + projRollout);
            if(projRollout.Regional_Project__c!=null) {
            	regionalProjectIDs.add(projRollout.Regional_Project__c);
            }
        }
        if(regionalProjectIDs.size()>0) {
	        List<IPM_Project__c> regionalProjList = [ SELECT ID, Name, 
	        											( Select id, Financial_External_ID__c, Target_Launch_Date__c 
	        											  From IPM_Financials_Regional__r )   
	        										  FROM IPM_Project__c 
	        										  WHERE id in : regionalProjectIDs];
	        // collect finalcials records for update. 
	        for(IPM_Project_Rollout__c projRollout: localNonkeyRollouts.values()) {
	        	for(IPM_Project__c regionalProject: regionalProjList) {
	        		for(IPM_Financial__c financial: regionalProject.IPM_Financials_Regional__r) {
	        			if(financial.Financial_External_ID__c==projRollout.name) {
	        				financial.Target_Launch_Date__c = projRollout.Target_Launch_Date__c;
	        				System.debug('RTDebug ipmFinancial ' + financial.Financial_External_ID__c);
				            System.debug('RTDebug ipmFinancial year ' + financial.Target_Launch_Date__c);
				            financialsList.add(financial);
	        				financialsMap.put(financial.id, financial);
	        				break;
	        			}
	        		}
	        	}
	        }
        }
 		if(financialsList.size()>0) {
	 		try {
	            update financialsList;
	        } catch (DMLException dmlException ){
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                
                ExceptionLoggingHelper.createErrorLog(	UserInfo.getUserId(),
                										IPM_SYNCFINANCETABLETLD_STR,
                    									'handleLocalNonkeyRollouts',
                    									dmlException.getMessage(),
                    									dmlException, 
                    									IPM_ConstantUtils.ERROR, 
                    									null, 
                    									null, 
                    									null, 
                    									IPM_ConstantUtils.IPM_NG_APPLICATION );
	        }
 		}
        if(financialsMap.size()>0) {
            updateFinancialTables();
        }
    }
    private void handleLoalKeyRollouts() {
        // Get regional rollout ids from local rollouts. 
        // We need this ids to retrieve sibling key local rollouts. 
        // The Target_Launch_Date__c of the sibling key local rollouts is going to be the TLD of finalcial and financial year records
        System.debug('RTDebug handleLoalKeyRollouts localKeyRollouts ' + localKeyRollouts);
        Set<ID> regionalRolloutIDs = new Set<ID>();
        for(IPM_Project_Rollout__c projRollout: localKeyRollouts.values()) {
            System.debug('RTDebug handleLoalKeyRollouts projRollout ' + projRollout);
            regionalRolloutIDs.add(projRollout.Regional_Rollout__c);
        }
        System.debug('RTDebug regionalRolloutIDs ' + regionalRolloutIDs);
        // Get the local rollouts of the regional rollouts. The rocords are order by Target_Launch_Date__c, so the first record in the list is latest TLD
        // Get the key finalcial records of regionla rollout as well
        regionalRolloutsMap = new Map<ID, IPM_Project_Rollout__c>(  [ Select id, External_Id__c, 
                                                                                                        ( Select Target_Launch_Date__c, Name 
                                                                                                          From Local_Rollouts__r
                                                                                                          where KeyMCO__c =true ), 
                                                                                                        ( Select Financial_External_ID__c 
                                                                                                          From IPM_Financials__r 
                                                                                                          where NOT (Financial_External_ID__c like '%NONKEY' or Financial_External_ID__c like '%CONSOLIDATED') ) 
                                                                                                     From IPM_Project_Rollout__c  
                                                                                                     where id in : regionalRolloutIDs ]);
        
        List<IPM_Financial__c> financialsList = new List<IPM_Financial__c>();
	    if(regionalRolloutsMap.size()>0) {
	        System.debug('RTDebug regionalRolloutsMap ' + regionalRolloutsMap);
	        financialsMap = new Map<ID,IPM_Financial__c>();
	         
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
	                        System.debug('RTDebug ipmFinancial ' + ipmFinancial);
	                        financialsList.add(ipmFinancial);
	                        financialsMap.put(ipmFinancial.id, ipmFinancial);
	                        break;
	                    }
	                }
	            }
	        }
        }
        if(financialsList.size()>0) {
	        try {
	            update financialsList;
	        } catch (DMLException dmlException ){
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                
                ExceptionLoggingHelper.createErrorLog(	UserInfo.getUserId(),
                										IPM_SYNCFINANCETABLETLD_STR,
                    									'handleLoalKeyRollouts',
                    									dmlException.getMessage(),
                    									dmlException, 
                    									IPM_ConstantUtils.ERROR, 
                    									null, 
                    									null, 
                    									null, 
                    									IPM_ConstantUtils.IPM_NG_APPLICATION );
	        }
        }
        if(financialsMap.size()>0) {
            updateFinancialTables();
        }
        
    }
    private void updateFinancialTables() {
        //System.debug('RTDebug financialsMap  ' + financialsMap);
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
                                                                            where id in : financialsMap.keySet()] );
                                                                        
        //System.debug('RTDebug retrievedFinancialMap  ' + retrievedFinancialMap);
        List<IPM_Financial_Year__c> financialYearsList = new List<IPM_Financial_Year__c>();
        for( ID financialsId: retrievedFinancialMap.keySet()){
        	IPM_Financial__c ipmFinancial = retrievedFinancialMap.get(financialsId);
            System.debug('RTDebug updateFinancialTables ipmFinancial  ' + ipmFinancial.Financial_External_ID__c);
            Date tmpTLD = ipmFinancial.Target_Launch_Date__c;
            Integer startYear = tmpTLD.year();
            String yearName = '';
            List<IPM_Financial_Year__c> tmpFinancialYearList = ipmFinancial.IPM_Financial_Years__r;
            if(tmpFinancialYearList.size()>0) {
	            for(IPM_Financial_Year__c fYear: tmpFinancialYearList) {
	                if(fYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||fYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS ) {
	                    System.debug('RTDebug updateFinancialTables fYear.External_Id__c  ' + fYear.External_Id__c);
            
	                    // update year 1 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
	                        yearName = String.valueOf(startYear);
	                        fYear.External_Id__c = fYear.External_Id__c.replace(fYear.Name,yearName);
	                        fYear.Name=yearName;
	                        financialYearsList.add(fYear);
	                    System.debug('RTDebug updateFinancialTables fYear.External_Id__c after  ' + fYear.External_Id__c);
            			}
	                    // update year 2 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
	                        yearName = String.valueOf(startYear+1);
	                        fYear.External_Id__c = fYear.External_Id__c.replace(fYear.Name,yearName);
	                        fYear.Name=yearName;
	                        financialYearsList.add(fYear);
	                    System.debug('RTDebug updateFinancialTables fYear.External_Id__c after  ' + fYear.External_Id__c);
            			}
	                    // update year 3 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
	                        yearName = String.valueOf(startYear+2);
	                        fYear.External_Id__c = fYear.External_Id__c.replace(fYear.Name,yearName);
	                        fYear.Name=yearName;
	                        financialYearsList.add(fYear);
	                    System.debug('RTDebug updateFinancialTables fYear.External_Id__c after  ' + fYear.External_Id__c);
            			}
	                    // update year 4 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y4_YEARINDEX) {
	                        yearName = String.valueOf(startYear+3);
	                        fYear.External_Id__c = fYear.External_Id__c.replace(fYear.Name,yearName);
	                        fYear.Name=yearName;
	                        financialYearsList.add(fYear);
	                    System.debug('RTDebug updateFinancialTables fYear.External_Id__c after  ' + fYear.External_Id__c);
            			}
	                    // update year 5 and exteral id fields
	                    if( fYear.Year__c==IPM_ConstantUtils.Y5_YEARINDEX) {
	                        yearName = String.valueOf(startYear+4);
	                        fYear.External_Id__c = fYear.External_Id__c.replace(fYear.Name,yearName);
	                        fYear.Name=yearName;
	                        financialYearsList.add(fYear);
	                    System.debug('RTDebug updateFinancialTables fYear.External_Id__c after  ' + fYear.External_Id__c);
            			}
	                    
	                }
	            }
            }
        }   
       // System.debug('RTDebug financialYearsList  ' + financialYearsList);
        try {
            update financialYearsList;
        } catch (DMLException dmlException ){
 	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                
                ExceptionLoggingHelper.createErrorLog(	UserInfo.getUserId(),
                										IPM_SYNCFINANCETABLETLD_STR,
                    									'updateFinancialTables',
                    									dmlException.getMessage(),
                    									dmlException, 
                    									IPM_ConstantUtils.ERROR, 
                    									null, 
                    									null, 
                    									null, 
                    									IPM_ConstantUtils.IPM_NG_APPLICATION );
        }
        
    }
    public class SyncFinanceTableTLDException extends Exception {}
    
    
}