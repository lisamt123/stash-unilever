@isTest
public class Amr_LoggingFormController_tst {
    
  /*  static testMethod void method1(){
        
        List<Amr_Job_Allocation__c> listOptionsAlloc = new List<Amr_Job_Allocation__c>();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
            
    Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
    insert projDetail;    
    Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
    
    Amr_Job_Details__c jobDetailNew=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id,Tv__c=true,Cinema__c=false,Radio__c=false,Print__c=false,Internal_Video__c=false,Out_Of_Home_Moving_Image__c=false,In_Store_Audio__c=false,In_Store_Moving_Image__c=false,In_Store_Still_Image__c=false,Digital_Moving_Image__c=false,Digital_Audio__c=false,Digital_Still_Image__c=false,Digital_Editorial__c=false);
    insert jobDetailNew;
    
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id,Tv__c=true,Cinema__c=false,Radio__c=false,Print__c=false,Internal_Video__c=false,Out_Of_Home_Moving_Image__c=false,In_Store_Audio__c=false,In_Store_Moving_Image__c=false,In_Store_Still_Image__c=false,Digital_Moving_Image__c=false,Digital_Audio__c=false,Digital_Still_Image__c=false,Digital_Editorial__c=false);
    insert jobDetail;
    
    Amr_Logging_Form_Setting__c setting = new Amr_Logging_Form_Setting__c(Allocation__c='manual',Footer__c='testFooter',Header__c='testHeader',Introduction__c='testIntro');
    insert setting;
    Amr_CurrencyConversionRate__c currencyRate =new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=12.34);
    insert currencyRate;
    
    List<selectOption> options = new List<selectOption>();
    options.add(new SelectOption('--None--','--None--'));
    List<Amr_CurrencyConversionRate__c> lstcov = Amr_CurrencyConversionRate__c.getAll().values();
    for (Amr_CurrencyConversionRate__c cc: lstcov){
        options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+'-'+cc.Currency_Unit__c));
    }
      
      
    String Clust ='testClust';
    String Count='testCount';
    String Id = jobDetail.Id;
    String AdManagertxt = 'ABC/12345';
        
    Amr_LoggingFormController controller = new Amr_LoggingFormController();
    controller.currencyRecords =options;
    //controller.jobDetails=jobDetail;
    
    controller.categoryName=category1.id;
    controller.brandPosName=brandPos.Id;
    controller.brandNameFromPage=brand.Id;
    controller.selectedCountry ='12.34';
    controller.updateSetting();
    controller.getCategoryList();
    controller.getBrandPositioningList();
    controller.getBrandList();
   
    List<SelectOption>catList=new List<SelectOption>();
    catList.add(new selectOption(category1.Id,category1.Name));
    
    List<SelectOption>brandposList=new List<SelectOption>();
    brandposList.add(new selectOption(brandpos.Id,brandpos.Name));
    
    List<SelectOption>brandList=new List<SelectOption>();
    brandList.add(new selectOption(brand.Id,brand.Name));
    
           
    controller.listOfCategory = catList;
    controller.listOfBrandPosition = brandposList;
    controller.listOfBrand =brandList;
    controller.getMethodToPassProjectNames();
    
    controller.getSubmitForm();
    Amr_LoggingFormController.InnerJobDetail innerJob = new Amr_LoggingFormController.InnerJobDetail(Clust,Count,Id,AdManagertxt);
    PageReference pageRef = Page.Am_CAPJobportfolio;
    Test.setCurrentPage(pageRef);
    controller.Redirect();
    
    String obj = JSON.serialize(innerJob);
    Amr_LoggingFormController.automaticJobAllocation(obj);
    controller.compareThresold(jobDetail,category1.id,brandPos.Id,brand.Id);
    //controller.adManagerNumberCreation();
    //controller.insertJobAllocationData();
    
    }
    
    static testMethod void method2(){
    List<Amr_Job_Allocation__c> listOptionsAlloc = new List<Amr_Job_Allocation__c>();
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
            
    Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
    insert projDetail;    
    Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
    Amr_Job_Details__c jobDetail1=new Amr_Job_Details__c(Out_Of_Home__c=true,In_Store__c=true,Digital__c=true,GBVM_Email__c='abc12@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Name__c='testProj',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Digital_Agency_Name__c='testAgency',AdManagerText__c ='ABC/00001',Any_other_agencies_involved__c='Yes',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id,Tv__c=false,Cinema__c=false,Radio__c=false,Print__c=false,Internal_Video__c=false,Out_Of_Home_Moving_Image__c=false,In_Store_Audio__c=false,In_Store_Moving_Image__c=false,In_Store_Still_Image__c=false,Digital_Moving_Image__c=false,Digital_Audio__c=false,Digital_Still_Image__c=false,Digital_Editorial__c=false);
    insert jobDetail1;
    Amr_Logging_Form_Setting__c setting = new Amr_Logging_Form_Setting__c(Allocation__c='manual',Footer__c='testFooter',Header__c='testHeader',Introduction__c='testIntro');
    insert setting;
      system.debug('jobDetail!!'+jobDetail1);
    Amr_LoggingFormController controller = new Amr_LoggingFormController();
    controller.jobDetails=jobDetail1;
    controller.categoryName = '--None--';
    controller.brandPosName ='--None--';
    controller.brandNameFromPage ='--None--';
    controller.selectedCountry ='--None--';
   
     controller.getSubmitForm();
     
  
    }*/

}