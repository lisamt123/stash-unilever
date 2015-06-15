trigger Af_AfterInsertBrandEstShare on AF_Brand_Estimate__c (after insert,after update) {
    
    Set<id> BrandEstids=new set<id>();
    Set<id> POReportBrandEstids=new set<id>();
    Set<id> BrandEstDeleteActionids=new set<id>();
    List<AF_Agency_Estimate__c> updateAgencyEstimates=new List<AF_Agency_Estimate__c>();
    List<AF_Agency_Estimate__c> poReportAgencyEstimates=new List<AF_Agency_Estimate__c>();
    AF_Bonus_Threshold__c bonuspilotrecord = new AF_Bonus_Threshold__c();
    String Agency;
    String estimateBrand;
    String year;
    Boolean pilot;
    //Call the method to share this records to Users who belongs to category
    if(Trigger.isInsert)
    {
    AF_BrandEstimateHelper.shareRecordToUser(trigger.new);
    
    }
     System.debug('TRIGGER BEING EXECUTED....');
   // try
    //{
       if(Trigger.isUpdate)
        {       
            for(AF_Brand_Estimate__c  brand:Trigger.new )   
            {
                System.debug('brand.AF_Status_Base_Fees__c: ' + brand.AF_Status_Base_Fees__c);
                AF_Brand_Estimate__c oldBrandEstimate = Trigger.oldMap.get(brand.id);
                //if(brand.AF_Status_Base_Fees__c=='Ready for PO')
                if(oldBrandEstimate.AF_Status_Base_Fees__c != 'Ready for PO' &&  brand.AF_Status_Base_Fees__c=='Ready for PO')            
                {               
                    BrandEstids.add(brand.Id);      
                }
                
                //PO Report
                if(oldBrandEstimate.AF_Status_Base_Fees__c != brand.AF_Status_Base_Fees__c){
                    POReportBrandEstids.add(brand.Id);
                }
                /*
                else if(oldBrandEstimate.AF_Status_Base_Fees__c == 'Ready for PO' &&  brand.AF_Status_Base_Fees__c !='Ready for PO')
                {
                    BrandEstDeleteActionids.add(brand.Id);
                }
                */              
                //Delete                     
            }
            System.debug('BrandEstids.size(): ' + BrandEstids.size());      
            if(BrandEstids.size()>0)        
            for(AF_Agency_Estimate__c agencyEst:[select id,Name,AF_Status__c,AF_Agency_Entity__c,AF_Unilever_Entity__c,AF_Agency_Spot_Rate__c,Unilever_Code__c,AF_Agency_Exchange_Rate__c,AF_Traditional__c,AF_Traditional_Local__c ,AF_Digital__c,AF_Digital_Local__c,AF_Adaptation__c ,AF_Adaptation_Local__c,Indicative_Gain_in_USD__c,Indicative_Gain_Loss_in_EUR__c,AF_Matrix_Data_Entry_Currency__c,AF_Ready_For_PO_Entry_Currency__c from AF_Agency_Estimate__c   where AF_Brand_Estimate__c IN : BrandEstids limit 50000 ])
            { 
                 if(agencyEst.AF_Status__c!='Ready for PO')
                 {  
                     agencyEst.AF_Status__c='Ready for PO';
                     updateAgencyEstimates.add(agencyEst);  
                 }         
            }        
            
            If(updateAgencyEstimates.size()>0)
                update updateAgencyEstimates;
            
            //PO Report agency estimate status changed based on brand estimate
            System.debug('POReportBrandEstids.size(): ' + POReportBrandEstids.size());
            if(POReportBrandEstids.size()>0)
            {
                for(AF_Agency_Estimate__c agencyEst:[select AF_Status__c,AF_Brand_Estimate__r.AF_Status_Base_Fees__c from AF_Agency_Estimate__c where AF_Brand_Estimate__c IN : POReportBrandEstids limit 50000 ])
                { 
                 if(agencyEst.AF_Brand_Estimate__r.AF_Status_Base_Fees__c!='')
                 {  
                     agencyEst.AF_Status__c=agencyEst.AF_Brand_Estimate__r.AF_Status_Base_Fees__c;
                     poReportAgencyEstimates.add(agencyEst);  
                 }         
                } 
            }
            
            If(poReportAgencyEstimates.size()>0)
                update poReportAgencyEstimates;
            
            if(BrandEstids.size() > 0)
            {
                //The Ids added to the BrandEstids collection will now be used to create OOPS records.
                //AF_OOPSRecordManager OOPSRecordManager = new AF_OOPSRecordManager(BrandEstids);
                //OOPSRecordManager.CreateOOPSEstimateRecordsByCollection();
                system.debug('BrandEstids:'+BrandEstids);
                //string[] inputIds =new string;
                //for(string id : BrandEstids) {inputIds.add(id);}
                //system.debug('inputIds:'+inputIds);
                
                AF_OOPSRecordManagerAsyncWrapper.CreateOOPSEstimateRecordsByCollection(BrandEstids);

                AF_BonusRecordManagerAsyncWrapper.CreateMultiObjectRecordsAsync(BrandEstids);
                
                

                
               // AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager(BrandEstids);
                //bonusRecordManager.CreateMultiObjectRecords();
                //if(bonusRecordManager.IsMatrixError == true && bonusRecordManager.MatrixErrorMessage.length() > 0)
                //{
                //    trigger.new[0].name.addError(bonusRecordManager.MatrixErrorMessage); 
                //}
            }        
            else if(BrandEstDeleteActionids.size() > 0)
            {
                    AF_OOPSRecordManager OOPSRecordManager = new AF_OOPSRecordManager(BrandEstDeleteActionids);
                    //OOPSRecordManager.DeleteOOPSActualRecordsByCollection();
            }        
        } 
        for(AF_Brand_Estimate__c  brand:Trigger.new ){
         Agency = brand.AF_Agency__c;
         estimateBrand = brand.Brand__c;
         year = brand.AF_Fiscal_Year__c;
         pilot = brand.AF_Pilot_Model__c;
        }
        if(Agency!=null && estimateBrand != null && year!=null){
        /*
        if(pilot){
                bonuspilotrecord.Agency_Name__c = Agency;
                bonuspilotrecord.Brand_Name__c = estimateBrand ;
                bonuspilotrecord.Year__c = year;
                insert bonuspilotrecord;
        }
        else{
            AF_Bonus_Threshold__c[] b;
            if(Agency!=null && estimateBrand != null && year!=null){
            try{
             
             b = [select id from AF_Bonus_Threshold__c where Agency_Name__c=:Agency and Brand_Name__c=:estimateBrand and Year__c=:year and AF_Country__c=null];
             if(b != null)
                delete b;
            }
            catch(Exception e){
                system.debug(e);
            }
            }    
        }
        */
        }
    /*
    }
    catch(Exception ex)
    {
        System.debug('Fatal Error: ' + ex);
    }
    */
    
}