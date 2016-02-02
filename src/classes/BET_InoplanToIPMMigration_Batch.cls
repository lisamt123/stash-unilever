/*****************************************************************************************************************************
Name: BET_InoplanToIPMMigration_Batch
Copyright © 2015 Unilever. 

Purpose: Update existing BETs records for given category to point to IPM project instead of Inoplan.

!!!NOTE!!!
Since for each found IPM is created seprate follow request then this batch size should be 1

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   piotr.czechumski@gmail.com      04/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
/*Batch class with sharing is not needed*/
global class BET_InoplanToIPMMigration_Batch implements Database.Batchable<sObject> {
	
	private final String catName;
    @TestVisible
    private static final String IPM_BET_TOOLKIT_VALUE = 'Link to existing BET';
    @TestVisible
    private static final String IPM_INOPLAN_SUFFIX = '0000';

	global BET_InoplanToIPMMigration_Batch(String categoryName) {
		this.catName = categoryName;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([select Id,name, IPM_Project__c, Product_Category__c, Inoplan_Project__c, Inoplan_Project__r.Project_Id__c 
										from uw_BET__c
										where IPM_Project__c = null and Inoplan_Project__c <> null and Product_Category__r.name = :catName
											and Inoplan_Project__r.Project_Id__c <> null and Is_Archived__c = false]);
	}

    global void execute(Database.BatchableContext BC, List<uw_BET__c> scope) {
        System.debug('Entering BET_InoplanToIPMMigration_Batch.execute : ' + scope);

        Set<String> sInoplanExtIds = new Set<String>();
        Map<String, IPM_Project__c> mIPMs = new Map<String, IPM_Project__c> (); // key - IPM Project.Project_External_ID__c
        List<IPM_Project__c> projects = new List<IPM_Project__c>();

        // get Inoplans External Id
        for (uw_BET__c bet : scope){
            sInoplanExtIds.add(bet.Inoplan_Project__r.Project_Id__c);
            // IPM Inoplan Id contains 0000 on the end - since this can be potential migration issue query will try to match
            // on both Inoplan with and without 0000 suffix
            sInoplanExtIds.add(bet.Inoplan_Project__r.Project_Id__c + IPM_INOPLAN_SUFFIX);
            
        }

        // get related IPM records
         for (IPM_Project__c ipmProject : [select Id, Project_External_ID__c, IPM_Project_Leader__c, Deputy_Project_Leader__c, BET_Link_Requested__c 
                                            from IPM_Project__c where Project_External_ID__c in :sInoplanExtIds]){
            mIPMs.put(ipmProject.Project_External_ID__c, ipmProject);
         }

         // Update ipm links
         for (uw_BET__c bet : scope){
         	IPM_Project__c ipmProject = mIPMs.get(bet.Inoplan_Project__r.Project_Id__c);
         	if (ipmProject == null){
                ipmProject = mIPMs.get(bet.Inoplan_Project__r.Project_Id__c + IPM_INOPLAN_SUFFIX);
            }

            if (ipmProject == null) {
                logIPMProjectNotFound(bet);
            } else {
	         	ipmProject.BET_Link_Requested__c = bet.Id;
	            ipmProject.IPM_BET_Toolkit__c = IPM_BET_TOOLKIT_VALUE;
	            projects.add(ipmProject);
        	}
         }
         update projects;

         // Create follow request for each valid BET
         for (uw_BET__c bet : scope){
         	IPM_Project__c ipmProject = mIPMs.get(bet.Inoplan_Project__r.Project_Id__c);
	         if (ipmProject == null){
	            ipmProject = mIPMs.get(bet.Inoplan_Project__r.Project_Id__c + IPM_INOPLAN_SUFFIX);
	         }
	         if (ipmProject != null) {
	         	List<Id> managersIds = new List<Id>{ipmProject.IPM_Project_Leader__c};
	            if (ipmProject.Deputy_Project_Leader__c != null){
	                managersIds.add(ipmProject.Deputy_Project_Leader__c);
	            }
	            BET_linkingService.Follow(ipmProject.Id, bet.Id, managersIds);
           	}
        }       
        System.debug('Exit BET_InoplanToIPMMigration_Batch.execute : ');

        
    }
	
	global void finish(Database.BatchableContext BC) {
		System.debug('Finish BET_InoplanToIPMMigration_Batch');
	}

	private void logIPMProjectNotFound(uw_BET__c bet){
		System.debug('Error: IPM project not found for BET = ' + bet);
		ExceptionLoggingHelper.createErrorLog(
				UserInfo.getUserId(),
				'BET_InoplanToIPMMigration_Batch',
				'execute',
				'Error: IPM project not found for BET = ' + bet,
				new BET_CustomBETException('Error: IPM project not found for BET = ' + bet),'ERROR',null,null,
				(Integer)DateTime.now().getTime(),
				'BET'
			);
	}
}