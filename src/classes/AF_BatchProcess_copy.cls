public class AF_BatchProcess_copy {
   Public pagereference confirm()
   {
       //pagereference p = new pagereference('/apex/AgencyHomePage');
         String Fisyear=string.valueOf(system.now().year()-1);
        // String Fisyear=string.valueOf(system.now().year());
         String statusBasefee='Ready for PO';
      
      string query = 'SELECT id,Name FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c =' + '\'' +statusBasefee +'\''+' AND AF_Fiscal_Year__c ='+'\''+Fisyear+'\' and AF_Copied__c= false and AF_Locked__c = false and AF_Active__c = true';
        
        AF_BrandEstimatesBatch batchApex=new AF_BrandEstimatesBatch(query);
        //apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Records have been submitted for processsing'));
        ID batchprocessid = Database.executeBatch(batchApex,1);
       return null;
   }
   public pagereference displayMsg(){
   apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Records have been submitted for processsing'));
   return null;
   }
}