/*************************************************************************************
Name : BET_BETChangesLogger

Purpose : Logger for Bet related changes

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-09-2015  Initial
1.1        blessy.voola@accenture.com 24-Mar-2016    Do not send notification to inactive BET owner
*************************************************************************************/
/* Helper class takes sharing settings from its 'parent' */
public class BET_BETChangesLogger {

  private static final String BET_STATUS_CHANGED = 'BET Status has been changed. ';
  private static final String BET_LAUNCH_DATE_CHANGED = 'Target Launch Date for this BET has been changed to ';
  private static final String BET_PROJECT_CHANGED = 'BET Lead IPM Project has been changed. ';
  private static final String BET_CATEGORY_GROUP_CHANGED = 'BET Category group has been changed. ';
  private static final String BET_CATEGORY_CHANGED = 'BET Category has been changed. ';
  private static final String BET_BRAND_POSITIONING_CHANGED = 'BET Brand Position has been changed. ';
  private static final String BET_BRAND_CHANGED = 'BET Brand has been changed. ';
  private static final String BET_DESCRIPTION_CHANGED = 'BET Description has been changed. ';
  private static final String BET_ARCHIVED = ' has been archived. ';
  private static final String BET_UNARCHIVED = ' has been unarchived ';
  private static final String BET_TXT = 'BET ';
  private static final String PROJECT_TXT = 'Project ';
  private static final String BET_TO = ' to ';
  private static final String LEAD_PROJECT = ' is the lead project for BET ';

  private final Map<Id,String> projectsMap = new Map<Id,String>();
  private final Map<Id,String> categoryGroupsMap = new Map<Id,String>();
  private final Map<Id,String> categoriesMap = new Map<Id,String>();
  private final Map<Id,String> brandPositionsMap = new Map<Id,String>();
  private final Map<Id,String> brandsMap = new Map<Id,String>();

  private final Set<Id> projects = new Set<Id>();
  private final Set<Id> categoryGroups = new Set<Id>();
  private final Set<Id> categories = new Set<Id>();
  private final Set<Id> positionings = new Set<Id>();
  private final Set<Id> brands = new Set<Id>();

  public BET_BETChangesLogger() {}

  /************************************************************
    Purpose: Method logs BET related changes
    Parameters: -
    Returns: -
    Throws: -
  *************************************************************/
  public void logChanges(){	
    Map<Id, List<String>> feedsMap = fillFeeds();
    if(!feedsMap.isEmpty()){
      BET_BETHandlerClsHelper.insertFeeds(feedsMap);
    }  
  }

  /************************************************************
    Purpose: Method builds Chatter Feeds records related to made changes
    Parameters: -
    Returns: Map<Id, List<String>> 
    Throws: -
  *************************************************************/
  private Map<Id, List<String>> fillFeeds(){
    retrieveReletedReferencesIds();
    fillMapObjects();
    return buildFeedMap();
  }

  /************************************************************
    Purpose: Method builds bet group related feed map
    Parameters: -
    Returns: Map<Id, List<String>> 
    Throws: -
  *************************************************************/
  private Map<Id, List<String>> buildFeedMap(){
    Map<Id, List<String>> feedsMap = new Map<Id, List<String>>();
    Set<String> collaborationGroups = new Set<String>();
    Set<String> activeCollaborationGroups = new Set<String>();

    for(Integer i=0; i< Trigger.new.size(); i++){
      uw_BET__c oldRecord = (uw_BET__c)Trigger.old[i];
      collaborationGroups.add(oldRecord.Studio_Chatter_Group__c);
    }

    for(CollaborationGroup cg : [select id from CollaborationGroup where id in : collaborationGroups and IsArchived = false]){
      activeCollaborationGroups.add(cg.id);
    }

    for(Integer i=0; i< Trigger.new.size(); i++){
      uw_BET__c oldRecord = (uw_BET__c)Trigger.old[i];
      uw_BET__c newRecord = (uw_BET__c)Trigger.new[i];
      List<String> diffs = addDifferences(oldRecord,newRecord);
      if(!diffs.isEmpty()){
        if(activeCollaborationGroups.contains(oldRecord.Studio_Chatter_Group__c)) {
          feedsMap.put(oldRecord.Studio_Chatter_Group__c, diffs);
        }
      }
    }
    return feedsMap;
  }

  /************************************************************
    Purpose: Method finds differences on Bet records
    Parameters: -
    Returns: List<String> 
    Throws: -
  *************************************************************/
  private List<String> addDifferences(uw_BET__c oldRecord,uw_BET__c newRecord ){
    List<String> diffs = new List<String>();
	  addBETDifferences(oldRecord,newRecord,diffs);
	  addCategoryBrandDifferences(oldRecord,newRecord,diffs);
    return diffs;
  }
  
  private void addBETDifferences(uw_BET__c oldRecord,uw_BET__c newRecord,List<String> diffs){
  	if(oldRecord.Status__c != newRecord.Status__c){
      diffs.add(BET_STATUS_CHANGED+oldRecord.Status__c+BET_TO+newRecord.Status__c);
    }

    if(oldRecord.Launch_Date__c != newRecord.Launch_Date__c){
      String newDate = newRecord.Launch_Date__c == null ? '' : String.valueOf(newRecord.Launch_Date__c).substring(0,10);
      diffs.add(BET_LAUNCH_DATE_CHANGED+newDate);
    }

    if(oldRecord.IPM_Project__c != newRecord.IPM_Project__c){
      if(newRecord.IPM_Project__c == null) {
        diffs.add(BET_PROJECT_CHANGED+projectsMap.get(oldRecord.IPM_Project__c)+BET_TO+newRecord.IPM_Project__c);
      } else {
        diffs.add(PROJECT_TXT+projectsMap.get(newRecord.IPM_Project__c)+LEAD_PROJECT+newRecord.name);
        IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper(newRecord.IPM_Project__c);
        //Do not send notification if BET owner is inactive
        User owner=[select id,isactive from User where id=:newRecord.ownerid];
        if(owner.isactive)
        BET_EmailNotificationService.notifyBetOwnerOfNewLeadProject(newRecord,project); 
      }
    }
    
    if(oldRecord.Description__c != newRecord.Description__c){
      diffs.add(BET_DESCRIPTION_CHANGED+oldRecord.Description__c+BET_TO+newRecord.Description__c);
    }

    if(oldRecord.Is_Archived__c != newRecord.Is_Archived__c){
      if(newRecord.Is_Archived__c){
        diffs.add(BET_TXT+newRecord.name+BET_ARCHIVED);
      } else {
        diffs.add(BET_TXT+newRecord.name+BET_UNARCHIVED);
      }
    }
  }
  
  private void addCategoryBrandDifferences(uw_BET__c oldRecord,uw_BET__c newRecord,List<String> diffs){
  	if(oldRecord.Category_Group__c != newRecord.Category_Group__c){
      diffs.add(BET_CATEGORY_GROUP_CHANGED+categoryGroupsMap.get(oldRecord.Category_Group__c)+BET_TO+categoryGroupsMap.get(newRecord.Category_Group__c));
    }

    if(oldRecord.Product_Category__c != newRecord.Product_Category__c){
      diffs.add(BET_CATEGORY_CHANGED+categoriesMap.get(oldRecord.Product_Category__c)+BET_TO+categoriesMap.get(newRecord.Product_Category__c));
    }

    if(oldRecord.Brand_Position__c != newRecord.Brand_Position__c){
      diffs.add(BET_BRAND_POSITIONING_CHANGED+brandPositionsMap.get(oldRecord.Brand_Position__c)+BET_TO+brandPositionsMap.get(newRecord.Brand_Position__c));
    }

    if(oldRecord.Product_Brand__c != newRecord.Product_Brand__c){
      diffs.add(BET_BRAND_CHANGED+brandsMap.get(oldRecord.Product_Brand__c)+BET_TO+brandsMap.get(newRecord.Product_Brand__c));
    }
  }

  /************************************************************
    Purpose: Method gets related objects ids
    Parameters: -
    Returns: - 
    Throws: -
  *************************************************************/
  private void retrieveReletedReferencesIds(){
    for(Integer i=0; i< Trigger.new.size(); i++){

      uw_BET__c oldRecord = (uw_BET__c)Trigger.old[i];
      uw_BET__c newRecord = (uw_BET__c)Trigger.new[i];

      if(oldRecord.IPM_Project__c != newRecord.IPM_Project__c){
        projects.add(oldRecord.IPM_Project__c);
        projects.add(newRecord.IPM_Project__c);
      }

      if(oldRecord.Category_Group__c != newRecord.Category_Group__c){
        categoryGroups.add(oldRecord.Category_Group__c);
        categoryGroups.add(newRecord.Category_Group__c);
      }

      if(oldRecord.Product_Category__c != newRecord.Product_Category__c){
        categories.add(oldRecord.Product_Category__c);
        categories.add(newRecord.Product_Category__c);
      }

      if(oldRecord.Brand_Position__c != newRecord.Brand_Position__c){
        positionings.add(oldRecord.Brand_Position__c);
        positionings.add(newRecord.Brand_Position__c);
      }

      if(oldRecord.Product_Brand__c != newRecord.Product_Brand__c){
        brands.add(oldRecord.Product_Brand__c);
        brands.add(newRecord.Product_Brand__c);
      }
    }
  }

  /************************************************************
    Purpose: Method create set of maps with objects ids and related names
    Parameters: Set<Id>projects,Set<Id>categoryGroups,Set<Id>categories,Set<Id>positionings,Set<Id>brands
    Returns: -
    Throws: -
  *************************************************************/

  private void fillMapObjects(){
    for(IPM_Project__c project : [select id, name from IPM_Project__c where id in : projects]){
      projectsMap.put(project.id,project.name);
    }

    for(MDO_Category__c mdo : [select id, name from MDO_Category__c where id in : categoryGroups]){
      categoryGroupsMap.put(mdo.id,mdo.name);
    }

    for(MDO_Category__c mdo : [select id, name from MDO_Category__c where id in : categories]){
      categoriesMap.put(mdo.id,mdo.name);
    }

    for(MDO_BrandPosition__c mdo : [select id, name from MDO_BrandPosition__c where id in : positionings]){
      brandPositionsMap.put(mdo.id,mdo.name);
    }

    for(MDO_Brand__c mdo : [select id, name from MDO_Brand__c where id in : brands]){
      brandsMap.put(mdo.id,mdo.name);
    }
  }

}