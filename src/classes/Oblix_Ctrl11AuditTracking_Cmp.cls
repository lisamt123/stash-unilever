public with sharing class Oblix_Ctrl11AuditTracking_Cmp {

  //******************************************************************************************************
//      THE CONTENT OF THIS CLASS HAS BEEN COMMENT OUT AS THIS CLASS IS NO LONGER USED
//      AS PART OF CODE REFACTORING, NEW CLASSES HAVE REPLACED THESE
//      S.M. 2016-03-30
//******************************************************************************************************/
	//public String sObjParentId {get;set;}
	//public String sObjApiName {get;set;}
	//public Map<String, Schema.SObjectField> fieldMap { get; set; }
	//public Oblix_Ctrl11AuditTracking_Cmp(){
	//}
	// /**
 //   * Run the main query for 
 //   * @param Sales_Id [Sales_Id]
 //   */

 //   public List<HistoryWrapper> getSowHistory() {
 //      sObjParentId = esc(sObjParentId);
 //      sObjApiName = esc(sObjApiName);
 //      fieldMap = getFieldMappings(sObjApiName);
 //      sObjApiName = sObjApiName.replace('__c','__History');
 //      if(sObjApiName != null && !sObjApiName.equalsIgnoreCase('') && sObjParentId != null){
 //         return getHistoryWrappers(Database.query('Select ParentId, OldValue, NewValue, IsDeleted, Id, Field, CreatedDate, CreatedById, CreatedBy.Name , Parent.Name From '+ sObjApiName +' WHERE ParentId =:sObjParentId ORDER BY CreatedDate DESC LIMIT 50'));
 //      }else{
 //       return null;
 //      }
 //   }
    
 //   private Map<String, Schema.SObjectField> getFieldMappings(String sObjApiName){
 //      String type = sObjApiName;
 //      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
 //      Schema.SObjectType schemaType = schemaMap.get(type);
 //      return schemaType.getDescribe().fields.getMap();
 //   }


 //   private List<HistoryWrapper> getHistoryWrappers(List<SObject> marketingHistoryList){
 //     system.debug('$$ ' + marketingHistoryList);
 //     List <HistoryWrapper> historyWrappers = new List<HistoryWrapper>();
 //     if(marketingHistoryList != null){
 //         for(SObject eachMarketingHistory: marketingHistoryList){
 //             System.DEBUG(marketingHistoryList.getSObjectType());
 //             System.DEBUG(marketingHistoryList.getSObjectType());
 //             if(String.valueOf(eachMarketingHistory.getSObjectType()).equalsIgnoreCase('Oblix_SOW_Projects__History')){
 //               Oblix_SOW_Projects__History sow = (Oblix_SOW_Projects__History) eachMarketingHistory;
               
 //               historyWrappers.add(new HistoryWrapper( sow.oldValue != null ? String.valueOf(sow.oldValue) : '', sow.newValue != null ? String.valueOf(sow.newValue) : '',  sow.Field != null && fieldMap.get(String.valueOf(sow.Field)) != null && !sow.Field.equalsIgnoreCase('created') && !sow.Field.equalsIgnoreCase('locked') ? fieldMap.get(String.valueOf(sow.Field)).getDescribe().getLabel() : String.valueOf(sow.Field), DateTime.valueOf(sow.createdDate), String.valueof(sow.CreatedBy.Name), String.valueof(sow.Parent.Name)));
 //             }else if(String.valueOf(eachMarketingHistory.getSObjectType()).equalsIgnoreCase('Marketing_SOW__History')){
 //               Marketing_SOW__History sow = (Marketing_SOW__History) eachMarketingHistory;
 //               historyWrappers.add(new HistoryWrapper( sow.oldValue != null ? String.valueOf(sow.oldValue) : '', sow.newValue != null ? String.valueOf(sow.newValue) : '',  sow.Field != null && fieldMap.get(String.valueOf(sow.Field)) != null && !sow.Field.equalsIgnoreCase('created') && !sow.Field.equalsIgnoreCase('locked') ? fieldMap.get(String.valueOf(sow.Field)).getDescribe().getLabel() : String.valueOf(sow.Field), DateTime.valueOf(sow.createdDate), String.valueof(sow.CreatedBy.Name), String.valueof(sow.Parent.Name)));
 //             }else if(String.valueOf(eachMarketingHistory.getSObjectType()).equalsIgnoreCase('Marketing_Basics__History')){
 //               Marketing_Basics__History sow = (Marketing_Basics__History) eachMarketingHistory;
 //               historyWrappers.add(new HistoryWrapper( sow.oldValue != null ? String.valueOf(sow.oldValue) : '', sow.newValue != null ? String.valueOf(sow.newValue) : '',  sow.Field != null && fieldMap.get(String.valueOf(sow.Field)) != null && !sow.Field.equalsIgnoreCase('created') && !sow.Field.equalsIgnoreCase('locked') ? fieldMap.get(String.valueOf(sow.Field)).getDescribe().getLabel() : String.valueOf(sow.Field), DateTime.valueOf(sow.createdDate), String.valueof(sow.CreatedBy.Name), String.valueof(sow.Parent.Name)));
 //             }
 //             //).getDescribe().getLabel()
 //         }
 //     }
 //     return historyWrappers;
 //   }  


 //   /**
 //    * Guard against SOQL injection
 //    */
 //   private String esc(String s) {
 //       return s != null ? String.escapeSingleQuotes(s) : null;
 //   }

 //   public class HistoryWrapper{
 //     public String oldValue { get; set; }
 //     public String newValue { get; set; }
 //     public String isDeleted { get; set; }
 //     public String Field { get; set; }
 //     public Datetime CreatedDate { get; set; }
 //     public String CreatedByName { get; set; }
 //     public String ParentName { get; set; }
      

 //     public HistoryWrapper(String oldValue, String newValue, String Field, Datetime CreatedDate, String CreatedByName, String ParentName){
        
 //       this.oldValue = oldValue;
 //       this.newValue = newValue;
 //       this.Field = Field;
 //       this.CreatedDate = CreatedDate;
 //       this.CreatedByName = CreatedByName;
 //       this.ParentName = ParentName;
 //     }
 //   }

}