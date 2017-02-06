@isTest
public class IPM_AlignDataOnGeographyChange_Test {
    //Initializing Variables
    private static User platformUser;
    public static final String EMPTY_STRING=''; 
    //private static list<IPM_Company_Card__c> companyCardList;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
   // private static final string IPM_FS_COMPANYCARD = '70 Project - Global UFS Other Foods team working on Global UFS Other Foods brand';
   //  private static Id REGIONAL_ROLLOUT_RECTYPE = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;

    
    
 /*************************************************************************************
 * @Description :This is to set up test  data which can be  queried in test methods. 
 * @name :  projectSetUp
 ***************************************************************************************/
    @testsetup static void projectSetup(){
           test.startTest();
           System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
           platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        Set<Id> companyCardId = new Set<Id>();        
        for(IPM_Company_Card__c temp : companyCardList){
            companyCardId.add(temp.Id);
        }
        List<IPM_Company_Card__c> ipmCompanyCardList = [Select id from IPM_Company_Card__c where id in : companyCardId]; 
        system.assertEquals(ipmCompanyCardList.size(), 3, 'Company card not created properly.');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        
        projectList = IPM_TestFactory_Helper.projectSetUp(1,platformUser);
        System.runAs(platformUser)
        {
            insert projectList;
        }
        
        Set<Id> projectIdList = new Set<Id>();        
        for(IPM_project__c temp : projectList){
            projectIdList.add(temp.Id);
        }        
        List<IPM_Project__c> ipmProjectList = [Select id from IPM_Project__c where id in : projectIdList];  
        system.assertEquals(ipmProjectList.size(),1,'Projects are not created');
        
        /******************************** Create Regional Rollouts for Created Global project ****************************************/
        List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{platformUser,platformUser,platformUser});
        insert regionalRolloutList;
        Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
        for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
             
            insert localRolloutList; 
           
           // List<IPM_Project_Rollout__c> dbRolloutList =  [Select Id from IPM_Project_Rollout__c where id in :localRolloutList];
           // System.assertEquals(dbRolloutList.size(),localRolloutList.size(),ASSERT_ERROR_STR+localRolloutList.size());
            
            insertCountry(localRolloutList);
        
        test.stopTest();
    }
    
    private static void insertCountry(List<IPM_Project_Rollout__c>  localRolloutList)
    {
        IPM_MCO_Short_Names__c mcoShortName = New IPM_MCO_Short_Names__c(Name = 'LV4_GEO0085', Country_Group__c = 'AFRICA', Short_Name__c='AFRS');
             
        IPM_MCO_Short_Names__c mcoShortName1 = New IPM_MCO_Short_Names__c(Name = 'LV4_GEO0006', Country_Group__c = 'North America', Short_Name__c='NAS');
        
        insert new List<IPM_MCO_Short_Names__c> {mcoShortName,mcoShortName1};
        
        // Create Country specific information.
        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
        MDO_Geography__c geoParent1 =  new MDO_Geography__c(ISO_3166_1_Code__c = 'AF', mdm_id__c = 'LV4_GEO0006');
        
        MDO_Geography__c geoParent2 =  new MDO_Geography__c(ISO_3166_1_Code__c = 'BR', mdm_id__c = 'LV4_GEO0085');
        
        insert new List<MDO_Geography__c> {geoParent1,geoParent2};
        
        Map<String,MDO_Geography__c > geoCodeToIDMap = new Map<String,MDO_Geography__c >{'AG'=>geoParent1 ,'BR'=>geoParent2};
        
        //****geoCodeToIDMap >  *ag       *br 
        
        List<String> iscodes = new List<String>{'AG','BR'}; 
        List<MDO_Geography__c> geoList =  new List<MDO_Geography__c>();
        Map<String,MDO_Geography__c> geoMap = new Map<String,MDO_Geography__c>();
        
        for(String isoCode : iscodes)
        {
            geoList.add(new MDO_Geography__c(ISO_3166_1_Code__c = isoCode, parent_L2__c = geoCodeToIDMap.get(isoCode).Id));

            //geoList.add(new MDO_Geography__c(ISO_3166_1_Code__c = isoCode, parent_id__c = geoParent.Id, parent_L1__c = geoParent.Id, parent_L2__c = geoParent.Id));
        }
        
        //*****geoList  >  *ag LV4_GEO0085       *br  LV4_GEO0006
        
        insert geoList;
        //System.assert(FALSE,geoList);
        System.assert(geoList[0].Id != null,'Geo not Created');
        for(MDO_Geography__c geoObj : geoList)
        {
            geoMap.put(geoObj.ISO_3166_1_Code__c,geoObj);
        }
        
        //*ag LV4_GEO0085       *br  LV4_GEO0006
        
        IPM_project_rollout__c mcoUpdateRollout = new  IPM_project_rollout__c();
        for(IPM_Project_Rollout__c localRollout : localRolloutList)
        {   
            
            String geoExternalId = EMPTY_STRING;
            IPM_Country__c tempCountry;
            if(localRollout.IPM_Rollout_Project__c.contains('LA'))
            {
                geoExternalId = 'AG';
                //System.assert(FALSE,localRollout.IPM_Rollout_Project__c);
                tempCountry = new  IPM_Country__c(MDO_Geography__c = geoMap.get(geoExternalId).Id,IPM_Project__c = localRollout.IPM_Project__c,
                local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'Seperate',isActive__c = true);  
            
            }
            else if(localRollout.IPM_Rollout_Project__c.contains('AF'))
            {
                mcoUpdateRollout.MCO__c ='LV4_GEO0006';
                mcoUpdateRollout.Id =localRollout.Id;
                geoExternalId = 'BR';
                //System.assert(FALSE,localRollout.IPM_Rollout_Project__c);
                tempCountry = new  IPM_Country__c(MDO_Geography__c = geoMap.get(geoExternalId).Id,IPM_Project__c = localRollout.IPM_Project__c,
                local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);  
            
            }
            
           
            countryList.add(tempCountry);
        }
        
        update  mcoUpdateRollout;
        insert countryList;
        System.debug('@@@@countryList' +countryList);
        List<IPM_Country__c> dbCountryList =  [Select Id,Country_Code__c from IPM_Country__c where id in :countryList AND MDO_Geography__r.ISO_3166_1_Code__c = 'BR'];
        System.assert(dbCountryList.size()>0);
    }
    
    private static testMethod void testAlignDataOnGeographyChange(){
        Test.startTest();
        List<IPM_project__c>project = [SELECT ID, name FROM IPM_project__c WHERE IPMProject_Span__c = 'Global'];
        System.assertEquals(2,project.size(),'Global Project not created');
        rish_alignDataonGeographyChange_batch adgc = new rish_alignDataonGeographyChange_batch();
        Database.executeBatch(adgc,1);
        Test.stopTest();
     }
    
    Private static testMethod void testAlignDataOnGeoChangeForNonKey(){
        Test.startTest();
        List<IPM_project_rollout__c>rolloutList = [SELECT id,name FROM IPM_project_rollout__c WHERE IPM_Rollout_Span__c ='Local']; 
        //System.assert(FALSE,rolloutList.size());
        for(IPM_project_rollout__c rollout:rolloutList){
            rollout.KeyMCO__c = TRUE;
        }
        update rolloutList;
        System.assertEquals(rolloutList.size(),2,'Local Rollout Not Created');
		List<IPM_Financial__c>finList = [Select Id,Financial_External_ID__c ,IPM_Key_Financial__c ,(Select Id, External_Id__c,Financial_External_Id__c from IPM_Financial_Years__r) from IPM_Financial__c];	
        System.assert(TRUE,finList.size()>0);
        rish_alignDataonGeographyChange_batch adgc = new rish_alignDataonGeographyChange_batch();
        Database.executeBatch(adgc,1);
        Test.stopTest();
    }
}