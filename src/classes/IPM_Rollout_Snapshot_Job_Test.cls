@isTest
public class IPM_Rollout_Snapshot_Job_Test {
	//Initializing Variables
    private static User platformUser;
    public static final String EMPTY_STRING=''; 
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static final string TEST_COMMENTS_STR='TestComments1';
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
    
    private static testMethod void rolloutsnapshotjobQueueTest(){
       
       Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
       
       IPM_Project_Document__c doc = [SELECT id,IPM_GateDocuments__c,IPM_Project__c	FROM IPM_Project_Document__c WHERE IPM_Project__r.Name in:projectNameSet LIMIT 1];
      // IPM_Rollout_Snapshot_Job_Queue sjq = new IPM_Rollout_Snapshot_Job_Queue();
       System.assertEquals(doc.IPM_GateDocuments__c,'Charter','Gate Document Not created for Project');
       IPM_Rollout_Snapshot_Job_Queue snapshotJobQueue = new IPM_Rollout_Snapshot_Job_Queue(doc.IPM_Project__c,doc);
       System.enqueueJob(snapshotJobQueue);
        
       doc.IPM_GateDocuments__c = IPM_ConstantUtils.CONTRACT_GATE;
       IPM_Fin_Alignment_Snapshot_Job_Queue finSnapshotJobQueue = new IPM_Fin_Alignment_Snapshot_Job_Queue(doc.IPM_Project__c,doc.Id, doc.IPM_GateDocuments__c );
       System.enqueueJob(finSnapshotJobQueue);
       
    }
    
    private static testMethod void finSnapshotJobQueueTest(){
       
       		platformUser = [Select Id,name,LastName from User where LastName='PLATFORM_USER' limit 1];  
			
        
			
			system.RunAs(platformUser)
     		{
                Test.startTest();
            	List<IPM_Project__c> projectAssertList = [Select Id,Name,IPM_Project_Type__c,IPM_Project_Name__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_ProjectGKM__c,IPM_CompanyCardText__c from IPM_Project__c where IPM_Project_Name__c != 'IPM_MasterProject' AND IPMProject_Span__c ='Global' LIMIT 10 ];
                
                List<IPM_Project_Rollout__c> projectRolloutList = [SELECT Id,IPM_Rollout_Project__c,IPM_Rollout_Span__c,IPM_Regional_PL__c,IPM_Regional_PL_Text__c,isActive__c,(SELECT ID FROM IPM_Countries_Local__r)  from IPM_Project_Rollout__c where IPM_Project__c =:projectAssertList[0].Id];
                
                List<IPM_Project__c> regionalProjList = IPM_TestFactory_Helper.createIPMProjectList(false,4);
                
                for(IPM_Project__c regProj: regionalProjList){
                    regProj.IPM_Project_Name__c = regProj.IPM_Project_Name__c+'Regional';
                    regProj.Name = regProj.Name+'Regional';
                    regProj.IPMProject_Span__c = 'Regional';
                    regProj.IPM_Parent_Project__c = projectAssertList[0].Id;
                }
                
                insert regionalProjList;
                
                List<IPM_Project__c> localProjList = IPM_TestFactory_Helper.createIPMProjectList(false,4);
                
                integer count =0;
                
                for(IPM_Project__c locProj: localProjList){
                    locProj.IPM_Project_Name__c = locProj.IPM_Project_Name__c+'Local';
                    locProj.Name = locProj.Name+'Local';
                    locProj.IPMProject_Span__c = 'Local';
                    locProj.IPM_Parent_Project__c = regionalProjList[count++].Id;
                }
                
                insert localProjList;
                
                IPM_Financial__c locProjFin = new IPM_Financial__c();
                locProjFin =  IPM_TestFactory_Helper.createIPMFinancial(false);
                
                
                //locProjFin.Regional_Project__r.IPM_Parent_Project__c  = projectAssertList[0].Id;
                locProjFin.Regional_Project__c = regionalProjList[0].Id;
                locProjFin.IPM_Project_Rollout__c = projectRolloutList[0].Id;
                locProjFin.Local_Project__c = localProjList[0].Id;
                locProjFin.isActive__c = true;
                locProjFin.IPM_Financial_Postfix__c = 'Global';
                //locProjFin.Local_Project_isNull__c = 'false';
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
                insert locProjFin;
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
                
                IPM_Financial_Year__c finYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
     			finYear.Year_Type__c = 'Innovation';
                finYear.Year__c = '3';
                finYear.IPM_Financial__c = locProjFin.Id;
                
                IPM_Financial_Year__c finYear2 = IPM_TestFactory_Helper.createIPMFinancialYear(false);
     			finYear2.Year_Type__c = 'Innovation';
                finYear2.Year__c = '3';
                finYear2.IPM_Financial__c = locProjFin.Id;
                
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
                insert finYear;
                insert finYear2;
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
                
                List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(new List<Id>{projectAssertList[0].Id},platformUser); 
         	    IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                update projectListPhaseChange;
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
                
                IPM_Project_Document__c doc = [SELECT id,IPM_GateDocuments__c,IPM_Project__c FROM IPM_Project_Document__c Where IPM_Project__c = :projectAssertList[0].Id LIMIT 1];
                
                doc.IPM_GateDocuments__c = 'Contract';
                Update doc;
                   
                
               // IPM_Fin_Alignment_Snapshot_Job_Queue finSnapshotJobQueue = new IPM_Fin_Alignment_Snapshot_Job_Queue(doc.IPM_Project__c,doc.Id, doc.IPM_GateDocuments__c );
       			//System.enqueueJob(finSnapshotJobQueue);
                Test.stopTest();
                
                List<IPM_Project__c> regionalProjectList = [SELECT ID FROM IPM_Project__c where IPM_Parent_Project__c = :projectAssertList[0].Id and IPMProject_Span__c = 'Regional'];
	         	
                regionalProjectList[0].IPM_ProjectGKM__c = 'GKM1';
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                Update regionalProjectList[0];
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
                
                locProjFin.IPM_Financial_Postfix__c = 'Regional';
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
                Update locProjFin;
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
                
                
 				System.assertEquals(regionalProjectList.size(),4,'Regional Project Creation Failed !!!');
                
                
                IPM_Project_Document__c doc2 = [SELECT id,IPM_GateDocuments__c,IPM_Project__c FROM IPM_Project_Document__c Where IPM_Project__c = :projectAssertList[0].Id LIMIT 1];
                doc.IPM_GateDocuments__c = 'Market Ready';
                Update doc2;
                
                IPM_Fin_Alignment_Snapshot_Job_Queue finSnapshotJobQueueRegional = new IPM_Fin_Alignment_Snapshot_Job_Queue(regionalProjectList[0].Id,doc2.Id, doc2.IPM_GateDocuments__c );
       			System.enqueueJob(finSnapshotJobQueueRegional);
                
                List<IPM_Project__c> localProjectList = [SELECT ID FROM IPM_Project__c where IPMProject_Span__c = 'Local'];
                localProjectList[0].IPM_ProjectGKM__c = 'GKM1';
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                Update localProjectList[0];
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
                
                locProjFin.IPM_Financial_Postfix__c = 'Regional';
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = true;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = true;
                Update locProjFin;
                IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION = false;
     			IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION = false;
                
                IPM_Fin_Alignment_Snapshot_Job_Queue finSnapshotJobQueueLocal = new IPM_Fin_Alignment_Snapshot_Job_Queue(localProjectList[0].Id,doc2.Id, doc2.IPM_GateDocuments__c );
       			System.enqueueJob(finSnapshotJobQueueLocal);
            }
    }
    
}