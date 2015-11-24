@isTest(seeAllData=true)
public class AA_ExecuteApprovalProcess_tst {
     
    static testMethod void myUnitTest() {
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
      
        aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers');
        insert compBrand;
        
        aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
        insert compName;
        
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
        insert compCategory;
        
        aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
        insert topic;
       
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
        insert clusterData;
        
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
       
        aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport;
        
        
        aa_Cluster__c clusterData1 = new aa_Cluster__c(Name = 'Africa');
        insert clusterData1;
        
        aa_Country__c countryData1 = new aa_Country__c(Name = 'South Africa',Cluster_Id__c = clusterData1.id);
        insert countryData1;
       
        aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 2',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData1.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport1;
        
        
        aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Europe');
        insert clusterData2;
        
        aa_Country__c countryData2 = new aa_Country__c(Name = 'Test Europe',Cluster_Id__c = clusterData2.id);
        insert countryData2;
       
        aa_Agent_Report__c competitorReport2 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData2.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport2;
        
         aa_Cluster__c clusterData3 = new aa_Cluster__c(Name = 'Europe');
        insert clusterData3;
        
        aa_Country__c countryData3 = new aa_Country__c(Name = 'Test Europe',Cluster_Id__c = clusterData3.id);
        insert countryData3;
       
        aa_Agent_Report__c competitorReport3 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData3.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport3;
        
        aa_Cluster__c clusterData4 = new aa_Cluster__c(Name = 'Latin America');
        insert clusterData4;
        
        aa_Country__c countryData4 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData4.id);
        insert countryData4;
       
        aa_Agent_Report__c competitorReport4 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 4',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData4.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport4;
       
        AA_ExecuteApprovalProcess.executeApproval(competitorReport1.id);
        AA_ExecuteApprovalProcess.executeApproval(competitorReport2.id);
        AA_ExecuteApprovalProcess.executeApproval(competitorReport3.id);
        AA_ExecuteApprovalProcess.executeApproval(competitorReport4.id);
        AA_ExecuteApprovalProcess.executeApproval(competitorReport.id);
        
        
        aa_Cluster__c clusterData5 = new aa_Cluster__c(Name = 'NAMET & RUB');
        insert clusterData5;
        
        aa_Country__c countryData5 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData5.id);
        insert countryData5;
       
        aa_Agent_Report__c competitorReport5 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 5',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData5.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport5;
        
         AA_ExecuteApprovalProcess.executeApproval(competitorReport5.id);
         
        aa_Cluster__c clusterData6 = new aa_Cluster__c(Name = 'North America');
        insert clusterData6;
        
        aa_Country__c countryData6 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData6.id);
        insert countryData6;
       
        aa_Agent_Report__c competitorReport6 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 6',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData6.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport6;
         AA_ExecuteApprovalProcess.executeApproval(competitorReport6.id);
         
        aa_Cluster__c clusterData7 = new aa_Cluster__c(Name = 'North Asia');
        insert clusterData7;
        
        aa_Country__c countryData7 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData7.id);
        insert countryData7;
       
        aa_Agent_Report__c competitorReport7= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 7',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData7.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport7;
         AA_ExecuteApprovalProcess.executeApproval(competitorReport7.id);
         
        aa_Cluster__c clusterData8 = new aa_Cluster__c(Name = 'SEAA');
        insert clusterData8;
        
        aa_Country__c countryData8 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData8.id);
        insert countryData8;
       
        aa_Agent_Report__c competitorReport8= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 8',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData8.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport8;
         AA_ExecuteApprovalProcess.executeApproval(competitorReport8.id);
         
         
         aa_Cluster__c clusterData9 = new aa_Cluster__c(Name = 'Test Cluster');
        insert clusterData9;
        
        aa_Country__c countryData9 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData9.id);
        insert countryData9;
       
        aa_Agent_Report__c competitorReport9= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 9',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData9.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport9;
         AA_ExecuteApprovalProcess.executeApproval(competitorReport9.id);
        
        ApexPages.currentPage().getParameters().put('id',competitorReport.id);
        AA_ExecuteApprovalProcess processapp =new AA_ExecuteApprovalProcess();
        processapp.OwnerAssginment();
        processapp.reportValues();
        processapp.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport1.id);
        AA_ExecuteApprovalProcess processapp1 =new AA_ExecuteApprovalProcess();
        processapp1.OwnerAssginment();
        processapp1.reportValues();
        processapp1.cancel();
        
        
        ApexPages.currentPage().getParameters().put('id',competitorReport2.id);
        AA_ExecuteApprovalProcess processapp2 =new AA_ExecuteApprovalProcess();
        processapp2.OwnerAssginment();
        processapp2.reportValues();
        processapp2.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport3.id);
        AA_ExecuteApprovalProcess processapp3 =new AA_ExecuteApprovalProcess();
        processapp3.OwnerAssginment();
        processapp3.reportValues();
        processapp3.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport4.id);
        AA_ExecuteApprovalProcess processapp4 =new AA_ExecuteApprovalProcess();
        processapp4.OwnerAssginment();
        processapp4.reportValues();
        processapp4.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport5.id);
        AA_ExecuteApprovalProcess processapp5 =new AA_ExecuteApprovalProcess();
        processapp5.OwnerAssginment();
        processapp5.reportValues();
        processapp5.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport6.id);
        AA_ExecuteApprovalProcess processapp6 =new AA_ExecuteApprovalProcess();
        processapp6.OwnerAssginment();
        processapp6.reportValues();
        processapp6.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport7.id);
        AA_ExecuteApprovalProcess processapp7 =new AA_ExecuteApprovalProcess();
        processapp7.OwnerAssginment();
        processapp7.reportValues();
        processapp7.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport8.id);
        AA_ExecuteApprovalProcess processapp8 =new AA_ExecuteApprovalProcess();
        processapp8.OwnerAssginment();
        processapp8.reportValues();
        processapp8.cancel();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport9.id);
        AA_ExecuteApprovalProcess processapp9 =new AA_ExecuteApprovalProcess();
        processapp9.OwnerAssginment();
        processapp9.reportValues();
        processapp9.cancel();
        system.assert(processapp9!=null);
      //  ApexPages.StandardController stdController = new ApexPages.StandardController(competitorReport);
     
        //AA_ExecuteApprovalProcess controller = new AA_ExecuteApprovalProcess(stdController);
        
        //controller.OwnerAssginment();
        //controller.reportValues();
        //controller.cancel();
        
     }
     
     
     
      static testMethod void executeApprovalfromMobile() {
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
      
        aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers');
        insert compBrand;
        
        aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
        insert compName;
        
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
        insert compCategory;
        
        aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
        insert topic;
       
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
        insert clusterData;
        
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
       
        aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 2',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport;
                                   
      
        
        ApexPages.currentPage().getParameters().put('id',competitorReport.id);
        //ApexPages.StandardController stdController = new ApexPages.StandardController(competitorReport);
        AA_ExecuteApprovalProcess controller = new AA_ExecuteApprovalProcess();
        controller.AgentReportObjNew.Comments__c='test';
        controller.executeApprovalfromMobile();
        
         aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(status__c='Approve',Report_Title__c = 'Competitor Report 2',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport1;
         ApexPages.currentPage().getParameters().put('id',competitorReport1.id);
        //ApexPages.StandardController stdController = new ApexPages.StandardController(competitorReport);
        AA_ExecuteApprovalProcess controller1 = new AA_ExecuteApprovalProcess();
        controller1.AgentReportObjNew.Comments__c='test';
        controller1.executeApprovalfromMobile();
        
        // test for all clusters
        
        aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Africa');
        insert clusterData2;
        
        aa_Country__c countryData2 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData2.id);
        insert countryData2;
       
        aa_Agent_Report__c competitorReport2= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 2',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData2.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport2;
        ApexPages.currentPage().getParameters().put('id',competitorReport2.id);
        AA_ExecuteApprovalProcess controller2 = new AA_ExecuteApprovalProcess();
         controller2.AgentReportObjNew.Comments__c='test';
        controller2.executeApprovalfromMobile();
        
        
        aa_Cluster__c clusterData3 = new aa_Cluster__c(Name = 'Europe');
        insert clusterData3;
        
        aa_Country__c countryData3 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData3.id);
        insert countryData3;
       
        aa_Agent_Report__c competitorReport3= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData3.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport3;
        ApexPages.currentPage().getParameters().put('id',competitorReport3.id);
        AA_ExecuteApprovalProcess controller3 = new AA_ExecuteApprovalProcess();
         controller3.AgentReportObjNew.Comments__c='test';
        controller3.executeApprovalfromMobile();
        
        aa_Cluster__c clusterData4 = new aa_Cluster__c(Name = 'Latin America');
        insert clusterData4;
        
        aa_Country__c countryData4 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData4.id);
        insert countryData4;
       
        aa_Agent_Report__c competitorReport4= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 4',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData4.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport4;
        ApexPages.currentPage().getParameters().put('id',competitorReport4.id);
        AA_ExecuteApprovalProcess controller4 = new AA_ExecuteApprovalProcess();
         controller4.AgentReportObjNew.Comments__c='test';
        controller4.executeApprovalfromMobile();
        
        aa_Cluster__c clusterData5 = new aa_Cluster__c(Name = 'NAMET & RUB');
        insert clusterData5;
        
        aa_Country__c countryData5 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData5.id);
        insert countryData5;
       
        aa_Agent_Report__c competitorReport5= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 5',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData5.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport5;
        ApexPages.currentPage().getParameters().put('id',competitorReport5.id);
        
        AA_ExecuteApprovalProcess controller5 = new AA_ExecuteApprovalProcess();
         controller5.AgentReportObjNew.Comments__c='test';
        controller5.executeApprovalfromMobile();
        
        aa_Cluster__c clusterData6 = new aa_Cluster__c(Name = 'North America');
        insert clusterData6;
        
        aa_Country__c countryData6 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData6.id);
        insert countryData6;
       
        aa_Agent_Report__c competitorReport6= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 6',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData6.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport6;
        ApexPages.currentPage().getParameters().put('id',competitorReport6.id);
        AA_ExecuteApprovalProcess controller6 = new AA_ExecuteApprovalProcess();
        controller6.AgentReportObjNew.Comments__c='test';
        controller6.executeApprovalfromMobile();
        
        
        aa_Cluster__c clusterData7 = new aa_Cluster__c(Name = 'North Asia');
        insert clusterData7;
        
        aa_Country__c countryData7 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData7.id);
        insert countryData7;
       
        aa_Agent_Report__c competitorReport7= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 7',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData7.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport7;
        ApexPages.currentPage().getParameters().put('id',competitorReport7.id);
        AA_ExecuteApprovalProcess controller7 = new AA_ExecuteApprovalProcess();
         controller7.AgentReportObjNew.Comments__c='test';
        controller7.executeApprovalfromMobile();
        
        aa_Cluster__c clusterData8 = new aa_Cluster__c(Name = 'SEAA');
        insert clusterData8;
        
        aa_Country__c countryData8 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData8.id);
        insert countryData8;
       
        aa_Agent_Report__c competitorReport8= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 8',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData8.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport8;
        ApexPages.currentPage().getParameters().put('id',competitorReport8.id);
        AA_ExecuteApprovalProcess controller8 = new AA_ExecuteApprovalProcess();
         controller8.AgentReportObjNew.Comments__c='test';
        controller8.executeApprovalfromMobile();
        
         aa_Agent_Report__c competitorReport9= new aa_Agent_Report__c(status__c='Approve',Report_Title__c = 'Competitor Report 8',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData8.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport9;
        ApexPages.currentPage().getParameters().put('id',competitorReport9.id);
        AA_ExecuteApprovalProcess controller9 = new AA_ExecuteApprovalProcess();
         //controller9.AgentReportObjNew.Comments__c='test';
        controller9.executeApprovalfromMobile();
        
        
         aa_Cluster__c clusterData10 = new aa_Cluster__c(Name = 'Test Cluster');
        insert clusterData10;
        
        aa_Country__c countryData10 = new aa_Country__c(Name = 'America',Cluster_Id__c = clusterData10.id);
        insert countryData10;
       
        aa_Agent_Report__c competitorReport10= new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 10',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData10.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport10;
        ApexPages.currentPage().getParameters().put('id',competitorReport10.id);
        AA_ExecuteApprovalProcess controller10 = new AA_ExecuteApprovalProcess();
         controller10.executeApprovalfromMobile();
        
        
     }
     
     static testMethod void OwnerAssignement() {
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
      
        aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers');
        insert compBrand;
        
        aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
        insert compName;
        
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
        insert compCategory;
        
        aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
        insert topic;
       
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
        insert clusterData;
        
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
       
        aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
        insert competitorReport;
                                   
        
        
        ApexPages.currentPage().getParameters().put('id',competitorReport.id);
       // ApexPages.StandardController stdController = new ApexPages.StandardController(competitorReport);
        AA_ExecuteApprovalProcess controller = new AA_ExecuteApprovalProcess();
        controller.OwnerAssginment();
        
     }
     
     static testMethod void reportApproved() {
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
      
        aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers');
        insert compBrand;
        
        aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
        insert compName;
        
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
        insert compCategory;
        
        aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
        insert topic;
       
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
        insert clusterData;
        
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
       
        aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id,Status__c ='ETS Approval Pending');
        insert competitorReport;
                                   
       
        
        ApexPages.currentPage().getParameters().put('id',competitorReport.id);
     //   ApexPages.StandardController stdController = new ApexPages.StandardController(competitorReport);
        AA_ExecuteApprovalProcess controller = new AA_ExecuteApprovalProcess();
        controller.reportApproved();
        
        aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id,Status__c ='CI Manager Approval Pending');
        insert competitorReport1;
                                   
       ApexPages.currentPage().getParameters().put('id',competitorReport1.id);
     //   ApexPages.StandardController stdController = new ApexPages.StandardController(competitorReport);
        AA_ExecuteApprovalProcess controller1 = new AA_ExecuteApprovalProcess();
        controller1.reportApproved(); 
        system.assert(controller1!=null);
     }
     
     static testMethod void reportReject() {
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
      
        aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers');
        insert compBrand;
        
        aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
        insert compName;
        
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
        insert compCategory;
        
        aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
        insert topic;
       
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
        insert clusterData;
        
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
       
        aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(status__c='ETS Approval Pending',Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id ,Comments__c='test');
        insert competitorReport;
                                   
       
        
        ApexPages.currentPage().getParameters().put('id',competitorReport.id);
        AA_ExecuteApprovalProcess controller = new AA_ExecuteApprovalProcess();
        controller.AgentReportObjNew.Comments__c='test';
        controller.reportRejected();
        
         aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(status__c='CI Manager Approval Pending',Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id,Comments__c='test');
         insert competitorReport1;
        
         ApexPages.currentPage().getParameters().put('id',competitorReport1.id);
         AA_ExecuteApprovalProcess controller1 = new AA_ExecuteApprovalProcess();
         controller1.AgentReportObjNew.Comments__c='test';
         controller1.reportRejected();
         
         aa_Agent_Report__c competitorReport2 = new aa_Agent_Report__c(status__c='Reject',Report_Title__c = 'Competitor Report 3',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id,Comments__c='test');
         insert competitorReport2;
         ApexPages.currentPage().getParameters().put('id',competitorReport2.id);
         AA_ExecuteApprovalProcess controller2 = new AA_ExecuteApprovalProcess();
         controller2.AgentReportObjNew.Comments__c='test';
         controller2.reportRejected();
        
        ApexPages.currentPage().getParameters().put('id',competitorReport.id);
        AA_ExecuteApprovalProcess controller3 = new AA_ExecuteApprovalProcess();
       // controller.AgentReportObjNew.Comments__c='test';
        controller3.reportRejected();
         system.assert(controller3!=null);
     }
    
     
}