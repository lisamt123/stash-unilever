/*************************************************************************************
Name : BET_BETHandlerCls

Purpose : Class contains logic used by BET_BETHandler class

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  22-07-2015  Initial
*************************************************************************************/

/* Withour sharing due to this is ITrigger implementation class  */

public without sharing class BET_BETHandlerCls {

  private BET_BETHandlerCls(){}

  /************************************************************
    Purpose: Method verifies if bet was soft deleted
    Parameters: List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap
    Returns: -
    Throws: -
  *************************************************************/
  public static void deleteBet(List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap){
    System.debug('Entering deleteBet : ' + newBetList + ', ' + oldBetMap);
    List<uw_BET__c> deletedBets = new List<uw_BET__c>();
    for(uw_BET__c bet : newBetList){
       if(bet.Is_Deleted__c && bet.Is_Deleted__c != oldBetMap.get(bet.id).Is_Deleted__c){
        deletedBets.add(bet);
      }
    }
    if(!deletedBets.isEmpty()){
      BET_BETHandlerClsHelper.softDelete(deletedBets);
    }
    System.debug('Exit deleteBet');
  }

  /************************************************************
    Purpose: Method verifies if bet ws archive/unarchived and runs related logic
    Parameters: List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap
    Returns: -
    Throws: -
  *************************************************************/
  public static void unarchiveBet(List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap){
    System.debug('Entering unarchiveBet : ' + newBetList + ', ' + oldBetMap);
    List<uw_BET__c> unArchivedBets = new List<uw_BET__c>();
    for(uw_BET__c bet : newBetList){
      if(!bet.Is_Archived__c && bet.Is_Archived__c != oldBetMap.get(bet.id).Is_Archived__c){
        unArchivedBets.add(bet);
      }
    }
    if(!unArchivedBets.isEmpty()){
      BET_BETHandlerClsHelper.archiveUnarchiveChatterGroups(unArchivedBets,false);
    }
    System.debug('Exit unarchiveBet');
  }

    /************************************************************
    Purpose: Method verifies if bet ws archive/unarchived and runs related logic
    Parameters: List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap
    Returns: -
    Throws: -
  *************************************************************/
  public static void archiveBet(List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap){
    System.debug('Entering archiveBet : ' + newBetList + ', ' + oldBetMap);
    List<uw_BET__c> archivedBets = new List<uw_BET__c>();
    for(uw_BET__c bet : newBetList){
      if(bet.Is_Archived__c && bet.Is_Archived__c != oldBetMap.get(bet.id).Is_Archived__c){
        archivedBets.add(bet);
      }
    }
    if(!archivedBets.isEmpty()) {
      BET_BETHandlerClsHelper.archiveUnarchiveChatterGroups(archivedBets,true);
    }
    System.debug('Exit archiveBet');
  }

  /************************************************************
    Purpose: Method updates IPM when changes on Bet made.
    Parameters: List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap
    Returns: -
    Throws: -
  *************************************************************/
  public static void informIPMOnBetChanges(List<uw_BET__c> newBetList,Map<Id,uw_BET__c> oldBetMap){
    System.debug('Entering informIPMOnBetChanges : ' + newBetList + ', ' + oldBetMap);
    List<String> updatedFields = new List<String>();
    for(uw_BET__c bet : newBetList){
      Boolean changesDone = false;

      if(bet.status__c != oldBetMap.get(bet.id).Status__c){
        changesDone = true;
        updatedFields.add('Status');
      }
      if(bet.ownerid != oldBetMap.get(bet.id).ownerid){
        changesDone = true;
        updatedFields.add('BetOwner');
      }
      if(bet.FinalReleaseDate__c != oldBetMap.get(bet.id).FinalReleaseDate__c){
        changesDone = true;
        updatedFields.add('FinalReleaseDate');
      }
      if(bet.FirstReleaseDate__c != oldBetMap.get(bet.id).FirstReleaseDate__c){
        changesDone = true;
        updatedFields.add('FirstReleaseDate');
      }
      if(bet.Final_Release_Due_Date__c != oldBetMap.get(bet.id).Final_Release_Due_Date__c){
        changesDone = true;
        updatedFields.add('FinalReleaseDueDate');
      }
      if(bet.First_Release_Due_Date__c != oldBetMap.get(bet.id).First_Release_Due_Date__c) {
        changesDone = true;
        updatedFields.add('FirstReleaseDueDate');
      }
      if(bet.Is_Archived__c != oldBetMap.get(bet.id).Is_Archived__c) {
        changesDone = true;
        updatedFields.add('isArchived');
      }
      if(changesDone) {
        BET_BETWrapper wrapper = new BET_BETWrapper(bet);
        IPM_BETUpdateService.updateIPM(bet.id,wrapper,updatedFields, UserInfo.getUserId());
      }
      
    }
    System.debug('Exit informIPMOnBetChanges');
  }

  /************************************************************
    Purpose: Method updates final due dates of BET
    Parameters: List<uw_BET__c> bets
    Returns: -
    Throws: -
  *************************************************************/
  public static void updateReleaseDueDates(List<uw_BET__c> bets){
    System.debug('Entering updateReleaseDueDates : ' + bets);
    for(uw_BET__c bet : bets){
      bet.Final_Release_Due_Date__c = BET_BETService.getFinalReleaseDueDate(bet.Launch_Date__c);
      bet.First_Release_Due_Date__c = BET_BETService.getFirstReleaseDueDate(bet.Launch_Date__c);
    }
    System.debug('Exit updateReleaseDueDates');
  }

  /************************************************************
    Purpose: Builds BET map from sObject map
    Parameters: Map<Id,SObject> sobjectMap
    Returns: Map<Id,uw_BET__c>
    Throws: -
  *************************************************************/
	public static Map<Id,uw_BET__c> buildBetMap(Map<Id,SObject> sobjectMap){
    	System.debug('Entering buildBetMap : ' + sobjectMap);
		Map<Id,uw_Bet__c> betmap = new Map<Id,uw_Bet__c>();
		for(Id id : sobjectMap.keySet()){
			betmap.put(id,(uw_Bet__c)sobjectMap.get(id));
		}
    	System.debug('Exit updateReleaseDueDates : ' + betmap);
		return betmap;
	}

  /************************************************************
    Purpose: Logs chnges made on BET object
    Parameters: -
    Returns: -
    Throws: -
  *************************************************************/
	public static void logChanges(){
    System.debug('Entering logChanges');
		Boolean enableLogging = !uw_CustomSettingsManager.getCustomSettingBooleanVal(uw_CustomSettingsManager.BET_DISABLE_LOG_CHANGE_TRIGGER, false);
    if (enableLogging) {
    	BET_BETChangesLogger logger = new BET_BETChangesLogger();
      logger.logChanges();
  	}
    System.debug('Exit logChanges');    
	}

  /************************************************************
    Purpose: Method deletes BET related collaboration group
    Parameters: -
    Returns: -
    Throws: -
  *************************************************************/
	public static void deleteBETRelatedCollaborationGroup(){ // Taken from uw_BET_before_delete trigger
    System.debug('Entering deleteBETRelatedCollaborationGroup');
		List<Id> delete_BET_group_Ids = new List<Id>();
    	List<Id> BET_Ids = new List<Id>();
    	List<uw_BET_Team_Member__c> delete_BET_Team_Member = new List<uw_BET_Team_Member__c>();
    
    	for(SObject uobj : Trigger.old){ //for loop for BET related chatter grouo id and BET ids.
    		uw_BET__c u = (uw_BET__c)uobj;
            delete_BET_group_Ids.add(u.Studio_Chatter_Group__c);//BET related chatter group
            BET_Ids.add(u.Id);//BET ids
            System.debug('Group Id'+u.CollaborationGroupId__c+'second group id'+u.Studio_Chatter_Group__c);      
    	}
    
    	/* Below code is added to delete the Chatter groupo associated with the deleted BET */
    	try {
       		Database.delete(delete_BET_group_Ids,false);//deleted BET related Chatter group
    	} catch(System.DmlException e) {
        	System.debug('Error in deleting the BET Group');
    	}

    	/* Below code is added to delete the BET Team members associated with the deleted BET */

    	try {
        	delete_BET_Team_Member = [Select u.Id, u.BET__c From uw_BET_Team_Member__c u where u.BET__c in:BET_Ids];//BET team members
    	} catch(Exception e) {
          System.debug('Error in retrieving team member');
    	}

    	try {
       	  Database.delete(delete_BET_Team_Member,false);//deleted BET team members
    	} catch(System.DmlException e) {
        	System.debug('Error in deleting the BET Member');
    	}
      System.debug('Exit deleteBETRelatedCollaborationGroup');
	}

}