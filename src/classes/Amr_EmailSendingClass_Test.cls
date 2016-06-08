@isTest
public class Amr_EmailSendingClass_Test{


   
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
    
         Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',
                                         Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',
                                         Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='no',Job_Reported__c='no',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),
                                         Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c='Yes',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,
                                         Brand_Final__c=brand.Id,Brodcast_Market__c='broadMarket',Project_Description__c = Amr_ConstantForAdManager.EXECUTION); 
         insert jobDetail;
        
        List<String> emailAddress = new List<String>();
        emailAddress.add('xyz@test.com');
       // Amr_EmailSendingClass emailObj = new Amr_EmailSendingClass();
        Amr_Job_Details__c jobDet = [select Project_Description__c from Amr_Job_Details__c where id = :jobDetail.Id];
        system.assertEquals(jobDet.Project_Description__c, Amr_ConstantForAdManager.EXECUTION);
        
        Amr_EmailSendingClass_CC.emailSending(String.valueOf(jobDetail.id),emailAddress,'Amr_RAPSharedJob');
    }        
}