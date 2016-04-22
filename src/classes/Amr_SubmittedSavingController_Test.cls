@isTest
public class Amr_SubmittedSavingController_Test{

       static testMethod void method1(){
    
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
            Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
            insert projDetail;    
            MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
            insert category1;
            MDO_BrandPositions__c brandPos = new MDO_BrandPositions__c(product_category_id__c =category1.id);
            insert brandpos;
            
            MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
            insert brand;
            
             Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
            
            Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='no',Job_Reported__c='no',Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c='broadMarket'); 
            insert jobDetail;

            Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetail.id,
                  Monthly_Submitted__c = 'January' );
                  
            insert savingObj;
            
            Amr_Quote__c  quoteObj1 = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1',Quote_Number__c = 1,Is_PC_part_of_the_Roster__c = 'no',PC_name__c = 'test',
                                        PC_Country__c= 'Aruba' ,Service_Company_Name__c = 'svc' ,Local_Currency_of_PC_Costs__c = 'Peso',Local_Amount_of_PC__c = 1,PPC_Costs_Euro_Amount__c = 5,
                                        Is_the_PPC_part_of_the_Roster__c = 'no',PPC_Name__c = 'testPPC',PPC_Country__c = 'Aruba',Local_Currency_of_PPC_Costs__c = 'Peso',
                                        Local_Amount_of_PPC__c = 3,CA_Costs_Euro_Amount__c = 6,CA_Additional_agency_Name__c = 'testCa',CA_Location__c  = 'Aruba', Is_Accepted__c = true, Local_Currency_of_CA_Costs__c= 'Peso',
                                        Local_Amount_of_CA__c = 5, PC_Costs_Euro_Amount__c= 7, Folder__c= 'Brief');
                                        
            insert QuoteObj1;
            
            List<String> selCountry = new List<String>();
            selCountry.add('Thailand'); 
            
           Document documentObj = new Document(body = Blob.valueOf('test'),name = 'test1');
           
            List<Amr_Quote__c> quoteList = new List<Amr_Quote__c>();
            quoteList.add(quoteObj1);
            
            FeedItem feedObj = new FeedItem(ParentId = jobDetail.id, Body = 'Attachment added');
            insert feedObj;
            FeedItem feedObj2 = new FeedItem(ParentId = jobDetail.id, Body = 'Attachment added');
            insert feedObj2;
            
            List<FeedItem> feedItemList = new List<FeedItem>();
            feedItemList.add(feedObj);
            feedItemList.add(feedObj2);
              Test.setCurrentPageReference(new PageReference('Page.Amr_SubmittedSavingPage')); 
              System.currentPageReference().getParameters().put('id', savingObj.id);
            
        Amr_SubmittedSavingController_CC  submittedSavings = new Amr_SubmittedSavingController_CC();
        
        submittedSavings.savObj = savingObj;
        submittedSavings.document = documentObj;
        submittedSavings.savObjNum = savingObj; 
        submittedSavings.savingIdFromPage = savingObj.id;
        submittedSavings.adManagerNumber = 'Ego/12345';
        submittedSavings.editedSavingMode = TRUE;
        submittedSavings.viewSavingMode = TRUE;
        submittedSavings.saveRecordValue = savingObj.id;
        submittedSavings.selectedCountry = selCountry;
        submittedSavings.acceptedQuote = quoteObj1;
        submittedSavings.quoteRelatedToSavingList = quoteList;
        submittedSavings.savingId = savingObj.id;
        submittedSavings.acceptedQuoteId = quoteObj1.id;
        submittedSavings.feedItemAcceptedList = feedItemList;
        submittedSavings.feedItemAdditionalList = feedItemList;
        submittedSavings.pcTimeMangCategoryValue = 2;
        submittedSavings.pcCostMangCategoryValue = 1;
        submittedSavings.pcProcessMangCategoryValue = 3;
        submittedSavings.pcOutputQualityCategoryValue = 1;
        submittedSavings.pccTimeMangCategoryValue = 4;
        submittedSavings.pccCostMangCategoryValue = 5;
        submittedSavings.pccProcessMangCategoryValue = 1;
        submittedSavings.pccOutputQualityCategoryValue = 3;
        submittedSavings.caTimeMangCategoryValue = 2;
        submittedSavings.caCostMangCategoryValue = 4;
        submittedSavings.caProcessMangCategoryValue = 1;
        submittedSavings.caOutputQualityCategoryValue = 3;
        submittedSavings.pcTimeMangCategoryClass = 'sendPcTimeMangCategory';
        submittedSavings.pcCostMangCategoryClass = 'sendPcCostMangCategory';
        submittedSavings.pcProcessMangCategoryClass = 'sendPcProcessMangCategory';
        submittedSavings.pcOutputQualityCategoryClass = 'sendPcOutputQualityCategory';
        submittedSavings.pccTimeMangCategoryClass = 'sendPpcTimeMangCategory';
        submittedSavings.pccCostMangCategoryClass = 'sendPpcCostMangCategory';
        submittedSavings.pccProcessMangCategoryClass = 'sendPpcProcessMangCategory';
        submittedSavings.pccOutputQualityCategoryClass = 'sendPpcOutputQualityCategory';
        submittedSavings.caTimeMangCategoryClass = 'sendCaTimeMangCategory';
        submittedSavings.caCostMangCategoryClass = 'sendCaCostMangCategory';
        submittedSavings.caProcessMangCategoryClass = 'sendCaProcessMangCategory';
        submittedSavings.caOutputQualityCategoryClass = 'sendCaOutputQualityCategory';
        
        submittedSavings.quoteInformation();
        PageReference  pageRef = submittedSavings.uploadAcceptedData();
        submittedSavings.edit();
        submittedSavings.saveData();
        submittedSavings.uploadAdditionalData();
        submittedSavings.getFeedItemAdditionalData();
        submittedSavings.getSelectedRatingStar(); 
        submittedSavings.SubmitWholeSaving();
        submittedSavings.deleteFile();
        submittedSavings.deleteOtherFile();
        submittedSavings.deleteSaving();
        
        System.assertEquals(pageRef,null);
              
    }   
    
    static testMethod void method2(){
    
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'stan322', Email='standuser321@testorg2.com', 
            EmailEncodingKey='UTF-8', LastName='Testing322', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser2@org.com');
            insert u;
            Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
            insert projDetail;    
            MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
            insert category1;
            MDO_BrandPositions__c brandPos = new MDO_BrandPositions__c(product_category_id__c =category1.id);
            insert brandpos;
            
            MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
            insert brand;
            
             Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
            
            Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='no',Job_Reported__c='no',Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c='broadMarket'); 
            insert jobDetail;

            Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetail.id,
                  Monthly_Submitted__c = 'January' );
                  
            insert savingObj;
                                     
         Test.setCurrentPageReference(new PageReference('Page.Amr_SubmittedSavingPage')); 
              System.currentPageReference().getParameters().put('id', savingObj.id);
        
          Amr_SubmittedSavingController_CC  submittedSavings = new Amr_SubmittedSavingController_CC();        
        submittedSavings.savingIdFromPage = savingObj.id;
        submittedSavings.pcTimeMangCategoryValue = 2;
        submittedSavings.pcCostMangCategoryValue = 1;
        submittedSavings.pcProcessMangCategoryValue = 3;
        submittedSavings.pcOutputQualityCategoryValue = 1;
        submittedSavings.pccTimeMangCategoryValue = 4;
        submittedSavings.pccCostMangCategoryValue = 5;
        submittedSavings.pccProcessMangCategoryValue = 1;
        submittedSavings.pccOutputQualityCategoryValue = 3;
        submittedSavings.caTimeMangCategoryValue = 2;
        submittedSavings.caCostMangCategoryValue = 4;
        submittedSavings.caProcessMangCategoryValue = 1;
        submittedSavings.caOutputQualityCategoryValue = 3;
        submittedSavings.pcTimeMangCategoryClass = '';
        submittedSavings.pcCostMangCategoryClass = '';
        submittedSavings.pcProcessMangCategoryClass = '';
        submittedSavings.pcOutputQualityCategoryClass = '';
        submittedSavings.pccTimeMangCategoryClass = '';
        submittedSavings.pccCostMangCategoryClass = '';
        submittedSavings.pccProcessMangCategoryClass = '';
        submittedSavings.pccOutputQualityCategoryClass = '';
        submittedSavings.caTimeMangCategoryClass = '';
        submittedSavings.caCostMangCategoryClass = '';
        submittedSavings.caProcessMangCategoryClass = '';
        submittedSavings.caOutputQualityCategoryClass = '';
        
        submittedSavings.AllValues();
        Amr_Saving__c savingData = [select PC_Appraisal_Time_Management__c from Amr_Saving__c where id = :savingObj.id]; 
        System.assertEquals(savingData.PC_Appraisal_Time_Management__c,'0');
    }

}