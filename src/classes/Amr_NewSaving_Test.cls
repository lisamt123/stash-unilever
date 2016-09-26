@isTest
public class Amr_NewSaving_Test{


    static testMethod void methodToGetRecords(){
    
           Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
          
           Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = Amr_ConstantForAdManager.TEST,Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',Project_Description__c = Amr_ConstantForAdManager.EXECUTION
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObjTest = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObjTest;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObjTest.id, Name =  'test1',PPC_Costs_Euro_Amount__c = 4,PC_Costs_Euro_Amount__c = 1,
                                            CA_Costs_Euro_Amount__c = 3,Accepted_Final_Cost_PPC_Euro_Amount__c = 4,Accepted_Final_Cost_CA_Euro_Amount__c = 3,
                                            Accepted_Final_Cost_PC_Euro_Amou__c = 3,Saving_Type__c = 'Cost Avoidance');
        
       insert QuoteObj;
        
      
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
      //  Amr_NewSaving_CC controller = new Amr_NewSaving_CC();
        //controller.addRowQuote();
        Amr_Quote__c  QuoteObj1 = new Amr_Quote__c(Saving__c = savingObjTest.id, Name =  'test2');
        
         insert QuoteObj1;
        
        List<String> selectedCountryList = new List<String>();
        selectedCountryList.add(Amr_ConstantForAdManager.TEST);
        
        List<Amr_Quote__c> testQuoteList = new List<Amr_Quote__c>();
        testQuoteList.add(QuoteObj1);
        
        FeedItem feedObj = new FeedItem(ParentId =jobDetailsObj.id, Body = 'Attachment added');
        insert feedObj;
        
        FeedItem feedObjSec = new FeedItem(ParentId =jobDetailsObj.id, Body = 'Attachment New added');
        insert feedObjSec;  
        
        List<FeedItem> feedItemList = new List<FeedItem>();
        feedItemList.add(feedObj);
        
        List<FeedItem> fIList = new List<FeedItem>();
        fIList.add(feedObj);
        
        List<Amr_Saving__Feed> savingFeedList =  [select id from Amr_Saving__Feed where parentId = :jobDetailsObj.id];
         List<Amr_Quote__Feed> feedItemListQuote = [select id from Amr_Quote__Feed where parentId = :jobDetailsObj.id];
       
        Document testDoc = new Document(name = Amr_ConstantForAdManager.TEST, body = Blob.valueOf('Test Doc Bory'));
        
        Amr_Saving__c savingObjTest1 = new Amr_Saving__c(Production_Type__c = 'TV: Master',Stage_RAP_engaged__c = 'Before briefing the agency',Scope_re_brief__c = 'yes',Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                    Monthly_Submitted__c = 'January' );
                                  
        insert savingObjTest1;
        
        Amr_NewSaving_CC   savingObject = new Amr_NewSaving_CC ();
        
        savingObject.savingObj = savingObjTest;
        savingObject.jobId = jobDetailsObj.id;
        savingObject.jobDetailObj = jobDetailsObj;
        savingObject.adManagerNumber = 'Ego/12345';
        savingObject.selectedCountry = selectedCountryList;
        savingObject.acceptedQuote = QuoteObj;
        savingObject.quoteList = testQuoteList; 
        savingObject.document = testDoc;
        savingObject.IdDeleted = feedObj.id;
        savingObject.IdDeletedSaving = feedObjSec.id; 
        savingObject.attachedListSaving = savingFeedList;
        savingObject.attachedList = feedItemListQuote; 
        savingObject.pcTimeMangCategoryValue  = 1;
        savingObject.pcCostMangCategoryValue  = 1;
        savingObject.pcProcessMangCategoryValue = 1;
        savingObject.pcOutputQualityCategoryValue = 1;
        savingObject.pccTimeMangCategoryValue = 2;
        savingObject.pccCostMangCategoryValue = 2;
        savingObject.pccProcessMangCategoryValue = 2;
        savingObject.pccOutputQualityCategoryValue = 2;
        savingObject.caTimeMangCategoryValue = 5;
        savingObject.caCostMangCategoryValue = 5;
        savingObject.caProcessMangCategoryValue = 5;
        savingObject.caOutputQualityCategoryValue = 5;
        savingObject.pcTimeMangCategoryClass = 'pcTimeMangCategoryClass';
        savingObject.pcCostMangCategoryClass = 'pcCostMangCategoryClass';
        savingObject.pcProcessMangCategoryClass = 'pcProcessMangCategoryClass';
        savingObject.pcOutputQualityCategoryClass = 'pcOutputQualityCategoryClass';
        savingObject.pccTimeMangCategoryClass = 'pccTimeMangCategoryClass';
        savingObject.pccCostMangCategoryClass = 'pccCostMangCategoryClass';
        savingObject.pccProcessMangCategoryClass = 'pccProcessMangCategoryClass';
        savingObject.pccOutputQualityCategoryClass = 'pccOutputQualityCategoryClass';
        savingObject.caTimeMangCategoryClass = 'caTimeMangCategoryClass';
        savingObject.caCostMangCategoryClass = 'caCostMangCategoryClass';
        savingObject.caProcessMangCategoryClass = 'caProcessMangCategoryClass';
        savingObject.caOutputQualityCategoryClass = 'caOutputQualityCategoryClass';
        savingObject.AllValues();
        savingObject.SaveQuoteAndSavingData();
        savingObject.UploadAcceptedquoteDoc();
        savingObject.validateAccepted(QuoteObj);
        savingObject.UploadAdditionalDoc();
        savingObject.validateAdditional(savingObjTest);
        savingObject.AllValues();
        savingObject.deleteDocument();
        savingObject.deleteDocumentSaving();
        Amr_Job_Details__c jobDet = [select Project_Description__c from Amr_Job_Details__c where id = :jobDetailsObj.Id];
        system.assertEquals(jobDet.Project_Description__c, Amr_ConstantForAdManager.EXECUTION);
    }

         static testMethod void saveQuoteAndSavingDataTest(){
         
         
           Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
          
           Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = Amr_ConstantForAdManager.TEST,Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',Project_Description__c = Amr_ConstantForAdManager.EXECUTION
                                            );
        insert jobDetailsObj;
            
            Amr_Saving__c savingObjTest1 = new Amr_Saving__c(Production_Type__c = 'TV: Master',Stage_RAP_engaged__c = 'Before briefing the agency',Scope_re_brief__c = 'yes',Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                    Monthly_Submitted__c = 'January' ); 
          
              insert savingObjTest1;
           
           Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObjTest1.id, Name =  'test1',PPC_Costs_Euro_Amount__c = 4,PC_Costs_Euro_Amount__c = 1,
                                            CA_Costs_Euro_Amount__c = 3,Accepted_Final_Cost_PPC_Euro_Amount__c = 4,Accepted_Final_Cost_CA_Euro_Amount__c = 3,
                                            Accepted_Final_Cost_PC_Euro_Amou__c = 3,Saving_Type__c = 'Cost Avoidance');
        
           insert QuoteObj;   
          List<String> selectedCountryList = new List<String>();
          selectedCountryList.add(Amr_ConstantForAdManager.TEST); 
          
           Amr_NewSaving_CC   savingObject = new Amr_NewSaving_CC ();  
                                
          savingObject.selectedCountry = selectedCountryList;        
          savingObject.savingObj = savingObjTest1;
          savingObject.acceptedQuote = QuoteObj;
          savingObject.SaveQuoteAndSavingData();
            
          Amr_Job_Details__c jobDet = [select Project_Description__c from Amr_Job_Details__c where id = :jobDetailsObj.Id];
          system.assertEquals(jobDet.Project_Description__c, Amr_ConstantForAdManager.EXECUTION);
        
         }
         

}