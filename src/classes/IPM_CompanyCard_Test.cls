/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : To test IPM_CompanyCard class functionalities
*********************************************/
@isTest
private class  IPM_CompanyCard_Test {
    private static IPM_CompanyCard ipmComCardGlobal;
    private static IPM_CompanyCard ipmComCardRegional;
    private static IPM_CompanyCard ipmComCardLocal;
    private static IPM_Company_Card__c gcomCard=new IPM_Company_Card__c();
    private static IPM_Company_Card__c rcomCard=new IPM_Company_Card__c();
    private static IPM_Company_Card__c lcomCard=new IPM_Company_Card__c();
    private static final String AFRICAEMERGINGMARKETS_STR = 'Other South Asia';
    private static final String ANGELO_STR = 'Afghanistan';
    private static final String county_code='AF';
    private static final String clusterName = 'South Asia';
    private static final String status='Active';
    private static final String clusterCode='GEO0023';
    private static final String mcoMDM= 'LV4_GEO0077';
    private static final String  equalString ='Value Should be same as';
    private static MDO_Geography__c mdoGeographyCluster;
    private static MDO_Geography__c mdoGeographyMCO;
    private static MDO_Geography__c mdoGeographyCountry;
    private static string space_STR=' ';
    private static string userLastName='IPMUSER_LASTNAME';
    private static string sameName='Name should be '+space_STR+userLastName;
    private static final string SAVORY='Savory';
    private static final string CURRENCY_STR='AED';
    private static final string GLOBAL_STR='Global';
  private static final string NEW_BPUSER='New_BP_User';
    private static User userInitialize; 
    private static User userBP;  
    private static User systemAdimUser; 
    private static string inValidName='invalid name name name namename namename namename namename namename namename namename namename namename namename namename namename namevname name';
    private static list<IPM_Company_Card__c>companyBulkList=new List<IPM_Company_Card__c>();
    private static string bulkCompanyCardName='GlobalCard';
    private static string bulkUpdateCompanyCardName='GlobalCards';
    private static string globalCompanyName='GlobalCC';
    private static string regionalCompanyName='RegionalCC';
    private static string localCompanyName='LocalCC';
    
    /******************************************************************************
    *@Description :Testmethod To create MDO_Geography,Company card and User
    */
    @TestSetup static void initializeData(){
        //In appllication , Only system admin's can create company card no other users have permissions to create
        
        //insert users
        List<User>userList=new List<User>();
        userInitialize = IPM_TestFactory_Helper.createUser(false);
        userList.add(userInitialize);
        userBP=IPM_TestFactory_Helper.createUser(false);
    userBP.LastName=NEW_BPUSER;
        userList.add(userBP);
        insert userList;//insert users
        List<User>userAllList=[SELECT LastName FROM User WHERE LastName=:userLastName LIMIT 1];
        System.assertEquals(userAllList[0].LastName,userLastName,sameName);//positive test
        systemAdimUser=IPM_TestFactory_Helper.createUserAdmin(false);
        system.runAS(systemAdimUser){
      //Geography for Unilever Cluster
      mdoGeographyCluster = IPM_TestFactory_Helper.createMDOGeography(false);
      mdoGeographyCluster.Name = clusterName;
      mdoGeographyCluster.geography_type__c=IPM_ConstantUtils.IPM_GEOGRAPHY_UNILEVERCLUSTER;
      mdoGeographyCluster.mdm_id__c=clusterCode;
      mdoGeographyCluster.Status__c=status;
      insert mdoGeographyCluster;//insert unilever cluster geography
        
      List<MDO_Geography__c> mdoCluster =[SELECT Id,mdm_id__c,Name FROM MDO_Geography__c WHERE id =:mdoGeographyCluster.Id LIMIT 1];
      system.assertEquals(mdoGeographyCluster.id,mdoCluster[0].Id,equalString+mdoGeographyCluster.id);//positive test
      system.assertEquals(mdoCluster[0].Name,clusterName,equalString+mdoCluster[0].Name);//positive test
      
      //Geography for MCO
      mdoGeographyMCO = IPM_TestFactory_Helper.createMDOGeography(false);
      mdoGeographyMCO.Name = AFRICAEMERGINGMARKETS_STR;
      mdoGeographyMCO.geography_type__c=IPM_ConstantUtils.COUNTRY_CLUSTER;
      mdoGeographyMCO.mdm_id__c=mcoMDM;
      mdoGeographyMCO.parent_L2__c= mdoGeographyCluster.Id;
      mdoGeographyMCO.parent_id__c= mdoGeographyCluster.Id;
      mdoGeographyMCO.parent_id__r=mdoGeographyCluster;
      mdoGeographyMCO.Status__c=status;
      insert mdoGeographyMCO;//insert mco geography
      
      List<MDO_Geography__c> mco =[SELECT Id,mdm_id__c,Name,parent_L2__r.Name,parent_L2__r.mdm_id__c FROM MDO_Geography__c WHERE id =:mdoGeographyMCO.Id LIMIT 1];
      system.assertEquals(mco[0].Name,AFRICAEMERGINGMARKETS_STR,equalString+mco[0].Name);//positive test
      system.assertEquals(mco[0].parent_L2__r.Name,clusterName,equalString+mco[0].parent_L2__r.Name); //positive test     
       
      //Geography for Country
      mdoGeographyCountry = IPM_TestFactory_Helper.createMDOGeography(false);
      mdoGeographyCountry.Name = ANGELO_STR;
      mdoGeographyCountry.geography_type__c=IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY;
      mdoGeographyCountry.mdm_id__c=county_code;
      mdoGeographyCountry.parent_L2__c=mdoGeographyMCO.Id;
      mdoGeographyCountry.parent_L2__r=mdoGeographyMCO;
      mdoGeographyCountry.name_ISO_medium__c=ANGELO_STR;
      mdoGeographyCountry.name_ISO_short__c=ANGELO_STR;
      mdoGeographyCountry.name_ISO_office_english__c =ANGELO_STR;
      mdoGeographyCountry.name_united_nations__c='UIM00009';
      mdoGeographyCountry.ISO_3166_1_alpha__c='AFG';
      mdoGeographyCountry.ISO_3166_1_numeric__c='4';
      mdoGeographyCountry.parent_id__c=mdoGeographyMCO.Id;
      mdoGeographyCountry.ISO_3166_1_code__c = county_code;
      mdoGeographyCountry.Status__c=status;
      insert mdoGeographyCountry;//insert country geography
      
      
      List<MDO_Geography__c> geoCountry =[SELECT Id,Name,parent_L2__r.Name,parent_L2__r.mdm_id__c, parent_L2__r.parent_L2__r.Name,parent_L2__r.parent_L2__r.mdm_id__c FROM MDO_Geography__c WHERE id =:mdoGeographyCountry.Id LIMIT 1];
      system.assertEquals(geoCountry[0].Name, ANGELO_STR,equalString+geoCountry[0].Name);//positive test
      system.assertEquals(geoCountry[0].parent_L2__r.Name,AFRICAEMERGINGMARKETS_STR,equalString+geoCountry[0].parent_L2__r.Name);//positive test
      //Global company card
      List<IPM_Company_Card__c>ccardallList=new List<IPM_Company_Card__c>();
      gcomCard=IPM_TestFactory_Helper.createGlobalCompanyCard(false);
      gcomCard.Name=globalCompanyName;
      gcomCard.IPM_Managed_Category__c=SAVORY;
      gcomCard.IPM_Currency__c=CURRENCY_STR;
      gcomCard.IPM_TxtGeographical_Scope__c=GLOBAL_STR;
      gcomCard.IPM_Business_Partner__c=userBP.id;
      ccardallList.add(gcomCard);
      
      //Regional company card
      rcomCard=IPM_TestFactory_Helper.createRegionalCompanyCard(false);
      rcomCard.Name=regionalCompanyName;
      rcomCard.IPM_Managed_Category__c=SAVORY;
      rcomCard.IPM_Currency__c=CURRENCY_STR;
      rcomCard.IPM_TxtGeographical_Scope__c=clusterName;
      rcomCard.IPM_Business_Partner__c=userBP.id;
      ccardallList.add(rcomCard);
      
      //Local company card
      lcomCard=IPM_TestFactory_Helper.createLocalCompanyCard(false);
      lcomCard.Name=localCompanyName;
      lcomCard.IPM_Managed_Category__c=SAVORY;
      lcomCard.IPM_Currency__c=CURRENCY_STR;
      lcomCard.IPM_TxtGeographical_Scope__c=ANGELO_STR;
      lcomCard.IPM_Market_Cluster__c=clusterName;
      lcomCard.IPM_MCO__c=AFRICAEMERGINGMARKETS_STR;
      lcomCard.IPM_Business_Partner__c=userBP.id;
      ccardallList.add(lcomCard);
      insert ccardallList;//insert company cards
      
      list<IPM_Company_Card__c>ccardList=[SELECT Name FROM IPM_Company_Card__c WHERE Name=:globalCompanyName LIMIT 1];
      system.assertEquals(ccardList[0].Name,gcomCard.Name,'Company card name is '+ccardList[0].Name);//positive test
      //call bulkification for creating company card
      for(Integer i=0;i<200;i++){
        IPM_Company_Card__c newGlobalCard=IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        newGlobalCard.Name=bulkCompanyCardName+string.valueof(i);
        newGlobalCard.IPM_Managed_Category__c=SAVORY;
        newGlobalCard.IPM_Currency__c=CURRENCY_STR;
        newGlobalCard.IPM_TxtGeographical_Scope__c=GLOBAL_STR;
        newGlobalCard.IPM_Business_Partner__c=userBP.id;
        companyBulkList.add(newGlobalCard);     
      }
      insert companyBulkList;
      string cQuery=bulkCompanyCardName+'%';
      list<IPM_Company_Card__c>bulkCCardList=[SELECT Name FROM IPM_Company_Card__c WHERE Name like:cQuery LIMIT 200];
      system.assertEquals(bulkCCardList.size(),companyBulkList.size(),'Total comapany card inserted count is:'+bulkCCardList.size());//positive test
      
      list<IPM_Company_Card__c>ccsList=[SELECT id FROM IPM_Company_Card__c LIMIT 50000];
      list<IPM_Company_Card__Share>ccShareList=IPM_TestFactory_Helper.shareCompanyCard(ccsList,userList);//share company card records
      insert ccShareList;
      list<IPM_Company_Card__Share>ccShareAllList=[SELECT ParentId,UserOrGroupId FROM IPM_Company_Card__Share WHERE ParentId=:gcomCard.id AND UserOrGroupId=:userInitialize.id LIMIT 1];
      system.assertEquals(ccShareAllList[0].UserOrGroupId,userInitialize.id,userInitialize.id+'User should have edit access to company card');//positive test
      
    }
        
        
        
        
     }
    /**************************************************************************
    *@Description : testmethod To call methods for global company card,Only system admin can permform this tastk
    */
    static testMethod void testGlobalCC(){
        
    systemAdimUser=IPM_TestFactory_Helper.createUserAdmin(false);
    gcomCard=[SELECT id,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE Name=:globalCompanyName LIMIT 1];
    ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, gcomCard.id);
        ipmComCardGlobal=new IPM_CompanyCard();
        system.runAS(systemAdimUser){
            Test.StartTest();
            ipmComCardGlobal.showDropdown();
            ipmComCardGlobal.IPMCompanyCard.id=gcomCard.Id;
            ipmComCardGlobal.CCRecordType=GLOBAL_STR;
            ipmComCardGlobal.SaveCC();//save global company card 
            List<IPM_Company_Card__c>ccSaveList=[SELECT IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE id=:gcomCard.Id LIMIT 1];
            system.assertEquals(ccSaveList[0].IPM_TxtGeographical_Scope__c, GLOBAL_STR ,'Geographical Scope value should be Global');//positive test
            Test.StopTest();
        }
      }
      /**************************************************************************
    *@Description : testmethod To call methods for regional company card,Only system admin can permform this tastk
    */
    static testMethod void testRegionalCC(){
       
    systemAdimUser=IPM_TestFactory_Helper.createUserAdmin(false);
    rcomCard=[SELECT id,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE Name=:regionalCompanyName LIMIT 1];
    ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, rcomCard.id);
        ipmComCardRegional=new IPM_CompanyCard();
        system.runAS(systemAdimUser){
            Test.StartTest();
            ipmComCardRegional.IPMCompanyCard.id=rcomCard.Id;
            ipmComCardRegional.CCRecordType='Regional';
            ipmComCardRegional.OneUnileverCluster=clusterName;
            ipmComCardRegional.SaveCC();//save regional company card 
            List<IPM_Company_Card__c>ccSaveList=[SELECT IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE id=:rcomCard.Id LIMIT 1];
            system.assertEquals(ccSaveList[0].IPM_TxtGeographical_Scope__c,clusterName,'Geographical Scope value should be '+clusterName);//positive test
            Test.StopTest();
        }    
    }
    /**************************************************************************
    *@Description : testmethod To call methods for local company card,Only system admin can permform this tastk
    */
    static testMethod void testLocalCC(){
        
    systemAdimUser=IPM_TestFactory_Helper.createUserAdmin(false);
    lcomCard=[SELECT id,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE Name=:localCompanyName LIMIT 1];
    ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, lcomCard.id);
        ipmComCardLocal=new IPM_CompanyCard();
        system.runAS(systemAdimUser){
            Test.StartTest();
            ipmComCardLocal.IPMCompanyCard.id=lcomCard.Id;
            ipmComCardLocal.getSelectedManagedCatagory();//get selected category
            ipmComCardLocal.OneUnileverCluster=clusterName;
            ipmComCardLocal.onUnileverClusterSelection();//get list of MCO
            system.assertEquals(ipmComCardLocal.countryClusterSet.Contains(AFRICAEMERGINGMARKETS_STR),true,'MCO wil be '+AFRICAEMERGINGMARKETS_STR);//positive test
            
            ipmComCardLocal.SelectedCountryCluster=AFRICAEMERGINGMARKETS_STR;
            ipmComCardLocal.onCountryClusterSelection();//get list of country
            system.assertEquals(ipmComCardLocal.isoCountryDependencyNameSet.Contains(ANGELO_STR),true,'Country wil be '+ANGELO_STR);//positive test
            
            ipmComCardLocal.CCRecordType='Local';
            ipmComCardLocal.IPMCompanyCard.IPM_Company_Turnover__c=50;
            ipmComCardLocal.IPMCompanyCard.Name='LocalCompanyCard';
            ipmComCardLocal.SaveCC();//save local company card 
            List<IPM_Company_Card__c>ccSaveList=[SELECT IPM_Market_Cluster__c FROM IPM_Company_Card__c WHERE id=:lcomCard.Id LIMIT 1];
            system.assertEquals(ccSaveList[0].IPM_Market_Cluster__c,clusterName,'MCO should be '+clusterName);//positive test
            
            ipmComCardLocal.IPMCompanyCard.IPM_Managed_Category__c=null;
            ipmComCardLocal.SaveCC();//save local company card 
            system.assertEquals(ipmComCardLocal.ManagedErrMsgLocal,true,'category is mandatory');//Negative test
            
            ipmComCardLocal.IPMCompanyCard.IPM_Managed_Category__c=SAVORY;
            ipmComCardLocal.IPMCompanyCard.Name=inValidName;
            ipmComCardLocal.OneUnileverCluster='Test';
            ipmComCardLocal.SaveCC();//save local company card 
            List<IPM_Company_Card__c>testSaveList=[SELECT ID FROM IPM_Company_Card__c WHERE Name=:inValidName LIMIT 1];
            system.assertEquals(testSaveList.isEmpty(),true,'DML Failed');//Negative test
            Test.StopTest();
        }
          
    }
     /**************************************************************************
    *@Description : testmethod To call methods for regional company card
    */
    static testMethod void testEdituser(){
        
    userInitialize=[SELECT ID FROM USER WHERE LastName=:userLastName LIMIT 1];
    rcomCard=[SELECT id,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE Name=:regionalCompanyName LIMIT 1];
    ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, rcomCard.id);
        ipmComCardRegional=new IPM_CompanyCard();
        system.runAs(userInitialize){
            Test.StartTest();
            ipmComCardRegional.IPMCompanyCard.id=rcomCard.Id;
            ipmComCardRegional.CCRecordType='RegionalTest';
            ipmComCardRegional.OneUnileverCluster=clusterName;
            ipmComCardRegional.SaveCC();//save regional company card name 
            List<IPM_Company_Card__c>ccSaveList=[SELECT id FROM IPM_Company_Card__c WHERE Name='RegionalTest' LIMIT 1];
            system.assertEquals(ccSaveList.isEmpty(),true,'Validation checked,only admin user can change the company card name');// Negative Test
            Test.StopTest();
        }     
            
    }
     /**************************************************************************
    *@Description : testmethod To call methods for regional company card (BP user access)
    */
    static testMethod void testBPtuser(){
        
    userBP=[SELECT ID FROM USER WHERE LastName=:NEW_BPUSER LIMIT 1];
    rcomCard=[SELECT id,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE Name=:regionalCompanyName LIMIT 1];
    ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, rcomCard.id);
        ipmComCardRegional=new IPM_CompanyCard();
        system.runAs(userBP){
            Test.StartTest();
            ipmComCardRegional.IPMCompanyCard.id=rcomCard.Id;
            ipmComCardRegional.CCRecordType=regionalCompanyName;
            ipmComCardRegional.OneUnileverCluster=clusterName;
            ipmComCardRegional.IPMCompanyCard.IPM_Company_Turnover__c=100;
            ipmComCardRegional.SaveCC();//save regional company card 
            List<IPM_Company_Card__c>ccSaveList=[SELECT IPM_Company_Turnover__c FROM IPM_Company_Card__c WHERE Name=:regionalCompanyName LIMIT 1];
            system.assertEquals(ccSaveList[0].IPM_Company_Turnover__c,100,'Validation checked,BP user can change the company turn over');// Positive Test
            Test.StopTest();
        }     
            
    }
     /**************************************************************************
    *@Description : testmethod To call methods for regional company card (BP user access)
    */
    static testMethod void testBulkUpdate(){
        //call bulkification for update company card
       
        userBP=[SELECT ID FROM USER WHERE LastName=:NEW_BPUSER LIMIT 1];
    string cQuery=bulkCompanyCardName+'%'; 
    companyBulkList=[SELECT Name,id FROM IPM_Company_Card__c WHERE Name like:cQuery LIMIT 200];
    systemAdimUser=IPM_TestFactory_Helper.createUserAdmin(false);  
        Test.StartTest();
        system.runAS(systemAdimUser){
            integer i=0;
            List<IPM_Company_Card__c>oldCCList=new List<IPM_Company_Card__c>();
            for(IPM_Company_Card__c cCardUpdate:companyBulkList){
                IPM_Company_Card__c oldGlobalCard=IPM_TestFactory_Helper.createGlobalCompanyCard(false);
                oldGlobalCard.Name=bulkUpdateCompanyCardName+string.valueof(i);
                oldGlobalCard.IPM_Managed_Category__c=SAVORY;
                oldGlobalCard.IPM_Currency__c=CURRENCY_STR;
                oldGlobalCard.IPM_TxtGeographical_Scope__c=GLOBAL_STR;
                oldGlobalCard.IPM_Business_Partner__c=userBP.id;
                oldGlobalCard.id=cCardUpdate.id;
                oldGlobalCard.RecordTypeId=IPM_TestFactory_Helper.regionalCompanyCardRecId;
                oldCCList.add(oldGlobalCard);   
                i++; 
                    
            }
            update oldCCList;
            
            list<IPM_Company_Card__c>bulkCCardList=[SELECT Name FROM IPM_Company_Card__c WHERE Name like:cQuery LIMIT 200];
            system.assertEquals(bulkCCardList.size(),oldCCList.size(),'Total comapany card updated count is:'+bulkCCardList.size());//positive test
            delete oldCCList;//delete company card
      list<IPM_Company_Card__c>bulkCCardsList=[SELECT Name FROM IPM_Company_Card__c WHERE Name like:cQuery LIMIT 200];
            system.assertEquals(bulkCCardsList.isEmpty(),true,'all company card got deleted');//positive test
            
      }  
      Test.StopTest();  
    }
}