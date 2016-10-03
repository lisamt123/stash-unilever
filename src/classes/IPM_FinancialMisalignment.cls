public with sharing class IPM_FinancialMisalignment
 {
    private static final String FINANCIALS_STR1='The financials for ';
    private static final String FINANCIALS_STR2=' projects and ';
    private static final String FINANCIALS_STR3=' are no longer aligned. Please contact your BD/BB Finance partner to re-align the business cases';
    private static Set<Id> projectIds= new Set<Id>();
    private static Map<Id, String> subjectIdMessageMap = new Map<Id, String>();
    private static Map<Id,Set<Id>> subjectIdMentionIdMap = new Map<Id,Set<Id>>();
    
   @InvocableMethod
   public static void postChatterIfLocalRegionalMisaligned(List<Id> localProjIds)
      {
         clearData();
         set<Id> mentionIdLocal = new set<Id>();
         set<Id> mentionIdRegional = new set<Id>();
         set<Id> localProjectIds = new set<Id>();
         localProjectIds.addAll(localProjIds);
         
         List<IPM_Financial__c> regionalFins = new List<IPM_Financial__c>();

         regionalFins = [Select Id, Name, Misaligned__c, Misaligned_Date__c, Target_Launch_Date__c, Regional_Project__c, Regional_Project__r.Name, 
                        Regional_Project__r.Deputy_Project_Leader__c,Regional_Project__r.IPM_Finance_Lead__c,Regional_Project__r.IPM_Project_Leader__c,Regional_Project__r.IPM_Target_Launch_Dates__c, Local_Project__c, 
                        Local_Project__r.Deputy_Project_Leader__c,Local_Project__r.IPM_Project_Leader__c,Local_Project__r.IPM_Finance_Lead__c,Local_Project__r.Name, Local_Project__r.IPM_Target_Launch_Dates__c, Gate_Keeping_Model__c,
                        IPM_Project_Rollout__c,IPM_Project_Rollout__r.IPM_Project__c,IPM_Project_Rollout__r.IPM_Project__r.Name,IPM_Project_Rollout__r.IPM_Project__r.IPM_Finance_Lead__c, IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Leader__c,
                        IPM_Project_Rollout__r.IPM_Project__r.Deputy_Project_Leader__c  from IPM_Financial__c 
                        where Local_Project__c IN : localProjectIds and recordtype.Name =: IPM_ConstantUtils.DEFAULT_FINANCIAL_RT Limit: IPM_ConstantUtils.MaxLimit];
          
         String topLevelProjectName = IPM_ConstantUtils.BLANK;              
         for(IPM_Financial__c fin: regionalFins ){    
            if(fin.Misaligned__c && (fin.Local_Project__c != NULL )){
                 	   topLevelProjectName = IPM_ConstantUtils.BLANK;
                       if(fin.IPM_Project_Rollout__c != null && fin.IPM_Project_Rollout__r.IPM_Project__c != NULL && fin.Gate_Keeping_Model__c == IPM_ConstantUtils.GATE_KEEPING_MODEL_3)
                       {
                           projectIds.add(fin.IPM_Project_Rollout__r.IPM_Project__c); 
                           mentionIdRegional.add(fin.IPM_Project_Rollout__r.IPM_Project__r.IPM_Finance_Lead__c);
                           mentionIdRegional.add(fin.IPM_Project_Rollout__r.IPM_Project__r.IPM_Project_Leader__c);
                           mentionIdRegional.add(fin.IPM_Project_Rollout__r.IPM_Project__r.Deputy_Project_Leader__c);
                           mentionIdRegional.remove(null);
                           subjectIdMentionIdMap.put(fin.IPM_Project_Rollout__r.IPM_Project__c,mentionIdRegional);
                           subjectIdMessageMap.put(fin.IPM_Project_Rollout__r.IPM_Project__c,FINANCIALS_STR1+fin.IPM_Project_Rollout__r.IPM_Project__r.Name+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR3 );
                           topLevelProjectName = fin.IPM_Project_Rollout__r.IPM_Project__r.Name;
                       }
                       else if(fin.Regional_Project__c != NULL && fin.Gate_Keeping_Model__c != IPM_ConstantUtils.GATE_KEEPING_MODEL_3)
                       {    
                        
                           projectIds.add(fin.Regional_Project__c); 
                           mentionIdRegional.add(fin.Regional_Project__r.IPM_Finance_Lead__c);
                           mentionIdRegional.add(fin.Regional_Project__r.IPM_Project_Leader__c);
                           mentionIdRegional.add(fin.Regional_Project__r.Deputy_Project_Leader__c);
                           mentionIdRegional.remove(null);
                           subjectIdMentionIdMap.put(fin.Regional_Project__c,mentionIdRegional);
                           subjectIdMessageMap.put(fin.Regional_Project__c,FINANCIALS_STR1+fin.Regional_Project__r.Name+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR3 );
                           topLevelProjectName = fin.Regional_Project__r.Name;
                       }
                       projectIds.add(fin.Local_Project__c);
                       mentionIdLocal.add(fin.Local_Project__r.IPM_Finance_Lead__c);
                       mentionIdLocal.add(fin.Local_Project__r.IPM_Project_Leader__c);
                       mentionIdLocal.add(fin.Local_Project__r.Deputy_Project_Leader__c);
                       mentionIdLocal.remove(null);
                       subjectIdMentionIdMap.put(fin.Local_Project__c,mentionIdLocal);
                       
                       
                       subjectIdMessageMap.put(fin.Local_Project__c,FINANCIALS_STR1+topLevelProjectName+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR3 );
                 
            }
        }
        if(IPM_CheckRecursive.runOnce()) {
                IPM_ChatterUtils.postChatterFeedWithMention(projectIds,subjectIdMessageMap,subjectIdMentionIdMap); 
        }
          clearData();
        
     }
      public static void clearData()
   {
       projectIds.clear();
       subjectIdMessageMap.clear();
       subjectIdMentionIdMap.clear();
   }  
 }