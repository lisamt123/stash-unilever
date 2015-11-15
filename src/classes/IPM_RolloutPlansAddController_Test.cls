@isTest
public class IPM_RolloutPlansAddController_Test{
    public static IPM_Project__c project;
    public static IPM_Project__c project1;
    public static IPM_Project_Rollout__c proRoll;
    public static  mdm_Geography__c mdmGeography = new mdm_Geography__c();
    public static String projectId;
    public static  List<String> lstTemp=new  List<String>();
    public static  IPM_Country__c ipmCountry = new IPM_Country__c();
    public static  IPM_MCO_Short_Names__c mco=new  IPM_MCO_Short_Names__c();
    public static IPM_Country__c con=new IPM_Country__c();
    
    public static String emerging_Africa = 'Africa Emerging Markets';
    public static String local_angola = 'Angola';
    
    static void initializeData(){
        project=new IPM_Project__c();
        project.Name='Test Finanace D';
        project.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c =IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
        insert project;
        
        project1=new IPM_Project__c();
        project1.Name='Test Finanace D1';
        project1.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
        project1.Sustainability_Period__c='3';
        project1.IPMProject_Span__c =IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
        insert project1;

        ApexPages.CurrentPage().getparameters().put('id', project.id);
         
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        insert proRoll;
        
       
        mdmGeography.Unilever_Cluster__c = 'Africa';
        mdmGeography.Country_Group__c = emerging_Africa;
        mdmGeography.ISO_3166_1_Alpha_Code__c= 'AGO';
        mdmGeography.Region__c ='Asia/RAM';
        mdmGeography.Region_Code__c ='GEO0003';
        mdmGeography.Country_Sub_Group_Code__c = 'LV5_GEO0085';
        mdmGeography.Country_Sub_Group_Name__c = emerging_Africa;
        mdmGeography.Unilever_Cluster_Code__c = 'GEO0060';
        mdmGeography.ISO_Country_Dependency_Code__c = 'UIM00015';
        mdmGeography.Country_Cluster__c = emerging_Africa;
        mdmGeography.ISO_Country_Dependency_Medium_Name__c = local_angola;
        mdmGeography.Country_Cluster_Code__c = 'GEO0085';
        mdmGeography.ISO_Country_Dependency_Short_Name__c = local_angola;
        mdmGeography.Country_Group__c = emerging_Africa;
        mdmGeography.ISO_Country_Dependency_Office_EN_Name__c = local_angola;
        mdmGeography.Country_Group_Code__c = 'LV4_GEO0085';
        mdmGeography.Market_Type__c = 'Developing & Emerging';
        mdmGeography.ISO_Country_Dependency_Name__c = local_angola;
        mdmGeography.Market_Type_Code__c='D002';
        mdmGeography.ISO_3166_1_Num_Code__c ='024';
        mdmGeography.UN_Independent_Country__c =local_angola;
        mdmGeography.ISO_3166_1_Code__c = 'AO';
        mdmGeography.World__c = 'World';
        mdmGeography.World_Code__c='GEO0001';

        
        mdmGeography.ISO_Country_Dependency_Name__c = local_angola;
        insert mdmGeography;
        
        MDO_Geography__c newG = new MDO_Geography__c();
        newG.name = 'test';
        insert newG;        
       
		insert new IPM_MCO_Short_Names__c(Name='fgdfg',Country_Group__c='LV4_GEO0085',Short_Name__c='gdfg');

        con.Geography__c=mdmGeography.Id;
        
       
        insert con;
      
              
    }


    static testMethod void testChangeCluster() {
        Test.startTest();
        initializeData();
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.project=project;
        irp.globalCountries='abc,abc';
     	irp.regionalMco='abc1,abc1';
   		irp.regionalCountry='abc2,abc2';
	    irp.regionalNoRoll='abc3,abc3';
	    irp.project=project;
     IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('sdfs','fsd','fsdf');
     geoWrp.code='fds1';
     geoWrp.name='fds2';
     geoWrp.parentCode='dfd1';
     geoWrp.rolloutStatus='fdsf2';
     geoWrp.key=true;
     
     geoWrp.selected=true;
     geoWrp.clusterDisabled=true;
     geoWrp.mcoDisabled=true;
     geoWrp.countryDisabled =true;
     geoWrp.noRolloutDisabled=true;
     
     irp.lstClusterWrappers.add(geoWrp);
        
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        irp.changeCluster();
        irp.changeMCO();
       	irp.generateRollouts();
        PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
        PageReference rolloutPlansActual = irp.redirectPage();
        irp.cancel();
        irp.project=project1;
        System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        Test.stopTest();  
    } 
    
 }