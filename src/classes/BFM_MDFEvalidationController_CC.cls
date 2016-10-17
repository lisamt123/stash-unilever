/**
    * @author Chaitanya Daggumati
    * @date 22/08/2016
    * @description: This Class gets invoked by process builder: MDF-e Duplicate Record Check. This class creates an Error log record if a duplicate record is detected.  
    *                                                                                                   
    /Class Header Starts
    //Class Name:[BFM_CTEValidationsController_CC]
    ---------------------------------------------------------------------------------------------------------------------------------
    //        DateTime           |  Email_id                    |     Description
    ---------------------------------------------------------------------------------------------------------------------------------
    //        22/08/2016     |~:Chaitanya.Daggumati@unilever.com |    This Class gets invoked by process builder: MDF-e Duplicate Record Check. This class creates an Error log record if a duplicate record is detected.   
**/


public class BFM_MDFEvalidationController_CC {
    @Invocablemethod
    public static void DuplicateRecordCheck(){
     List<BFM_MDF_e__c> MDFeRecord=New List<BFM_MDF_e__c>();
      Map<string,id> NewKeyMap=New Map<string,id>();
     Map<string,id> NewRecordMap=New Map<string,id>(); 
    //Get new record details that are created by MuleSoft for Validation. 
    MDFeRecord = [Select id,MDFE_Access_Key__c,MDF_e_Duplicate_Record_Check__c,MDF_e_Status__c from BFM_MDF_e__c];
        
        for (BFM_MDF_e__c rec:MDFeRecord){
            NewRecordMap.put(rec.MDFE_Access_Key__c,rec.id);
             IF(rec.MDF_e_Status__c=='In Progress' && rec.MDF_e_Duplicate_Record_Check__c==false){
                  NewKeyMap.put(rec.MDFE_Access_Key__c,rec.id);
              }
        }
        if(NewKeyMap!=null && NewRecordMap!=null ){
        BFM_RecordValidationUtilityController_CC utility=new BFM_RecordValidationUtilityController_CC();
        utility.DuplicateRecordCheck(NewKeyMap,NewRecordMap,'MDF-e');
        }
    }
}