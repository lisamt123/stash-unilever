@isTest
public class IPM_RolloutPlansAddController_Test{
    public static IPM_Project__c project;
    //public static IPM_Project__c project1;
    //public static IPM_Project_Rollout__c proRoll;
    public static List<IPM_Project_Rollout__c> regionalRolloutList;
    public static List<IPM_Project_Rollout__c> localRolloutList;
    public static  mdm_Geography__c mdmGeography = new mdm_Geography__c();
    public static  String projectId;
    //public static  List<String> lstTemp = new  List<String>();
    //public static  IPM_Country__c ipmCountry = new IPM_Country__c();
    //public static  IPM_MCO_Short_Names__c mco = new  IPM_MCO_Short_Names__c();
    //public static IPM_Country__c con = new IPM_Country__c();
    //public static MDO_Geography__c mdo = new MDO_Geography__c(); 
    public static MDO_Geography__c geo; 
    public static MDO_Geography__c goegraphiesCluster;
    public static MDO_Geography__c goegraphiesMCO;
    public static MDO_Geography__c goegraphiesCountry;
    public static List<IPM_Project__c> projectList;
   
     @testSetup static void projectSetUp() 
     {
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         User globalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
         
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            // Inserting Master Data whose OWD are set to readOnly    
            IPM_TestFactory_Helper.getProjectMasterData();
        }   
        
        System.runAs(globalProjectLeader)
        {   
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList; 
		}
     }
   
     public static testmethod void createProject()
     {
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
          
        User globalUser = [Select Id,Name from User where LastName ='GLOBAL_PL' limit 1];
        
           
        System.RunAs(globalUser)
        {
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
            }
           
            
            User regionalProjectLeader = [Select Id,Name from User where LastName ='REGIONAL_PL' limit 1];
             Test.startTest();    
            // Create Regional Rollouts for Created Global project.
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
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
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
             
            insert localRolloutList; 
            
	        goegraphiesCluster = new MDO_Geography__c();
	        goegraphiesCluster.Name = 'AsiaParent';
	        goegraphiesCluster.parent_L2__c =goegraphiesCluster.id;
	        goegraphiesCluster.geography_type__c = 'Unilever Cluster';
	        goegraphiesCluster.Status__c = 'Active';
	        insert goegraphiesCluster;
	        system.assertNotEquals(null, goegraphiesCluster.id);
	        
	        goegraphiesMCO = new MDO_Geography__c();
	        goegraphiesMCO.Name = 'Asia';
	        goegraphiesMCO.parent_L2__c =goegraphiesCluster.id;
	        goegraphiesMCO.geography_type__c = 'Country Group';
	        goegraphiesMCO.Status__c = 'Active';
	        insert goegraphiesMCO;
	        system.assertNotEquals(null, goegraphiesMCO.id);
	        
	        goegraphiesCountry = new MDO_Geography__c();
	        goegraphiesCountry.Name = 'India';
	        goegraphiesCountry.parent_L2__c =goegraphiesMCO.id;
	        goegraphiesCountry.geography_type__c = 'Country';
	        goegraphiesCountry.Status__c = 'Active';
	        insert goegraphiesCountry;
	        system.assertNotEquals(null, goegraphiesCountry.id);
	            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AGO';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BRA';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
        }
   
        
        ApexPages.currentPage().getParameters().put('id',projectList[0].Id);
        projectId = ApexPages.currentPage().getParameters().get('id');
        //system.debug('@@@ project id -->>'+projectId);
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        irp.project=projectList[0];
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
	    //system.debug('@@@ geowrapper -->>'+geoWrp);
	    
	    irp.lstClusterWrappers.add(geoWrp);
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+regionalRolloutList[0].Id);
        Test.setCurrentPageReference(pRef);
        //irp.changeCluster();
        //irp.changeMCO();
       	irp.generateRollouts();
        PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
        //PageReference rolloutPlansActual = irp.redirectPage();
        irp.cancel();
        //irp.project=project1;
        //System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        Test.stopTest();  
    } 
    
 }