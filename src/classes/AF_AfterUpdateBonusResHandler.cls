public class AF_AfterUpdateBonusResHandler {
 
    public static void AF_AfterUpdHandler(AF_Bonus_Results__c[] bonResultList) {
        List<AF_Bonus_Results__c> BonusResultsCollection;  
     Set<String> BonusResultIds = new Set<String>();
      
         
            for(AF_Bonus_Results__c  brandResults:bonResultList)   
            {
             BonusResultIds.add(brandResults.Id);          
            }
        List<String> bonResultsStrList = new List<String>(BonusResultIds);

            updateBonusMatrix(bonResultsStrList);

        
        
        }
       @future(callOut=false)
        public static void updateBonusMatrix(String[] BonusResultIds) {
           
            if(BonusResultIds.size() > 0)
         {
          try
          {
           List<AF_Bonus_Matrix__c> BonusMatrixCollection = [Select a.AF_Bonus_Results__c From AF_Bonus_Matrix__c a where a.AF_Bonus_Results__c IN :BonusResultIds];
           update BonusMatrixCollection;
          }
          catch(Exception ex){
          System.debug(ex);
          }
         }  
        }   
    
}