/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_BBCountryList class 
*/
@isTest
public class IPM_BBCountryList_Test{

    public static IPM_Project__c project;// Project object initialization
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static IPM_BBCountryList ipm_bbcountryList;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static string LOCAL_STR='Local';
    private static string REGIONAL_STR='Regional';
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static PageReference  pRef;
    public static User globalUser;
    public static User stdUserForBBCountryList;
    public static mdo_Geography__c mdoGeo=new mdo_Geography__c();
    public static IPM_Financial__c fin;
  
     public static List<IPM_Country__c>countryList=new List<IPM_Country__c>();
    public static List<MDO_Geography__c> mdoGeoList=new List<MDO_Geography__c>();
    public static IPM_Project__c ParentProject;// Project object initialization
      /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForBBCountryList= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForBBCountryList.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForBBCountryList.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForBBCountryList);
        System.runAs(stdUserForBBCountryList) {
            insert projectList;
            
            project=projectList[0];
            project.Name='ProChgStatus';
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForBBCountryList,stdUserForBBCountryList,stdUserForBBCountryList});
            insert regionalRolloutList;
            List<IPM_Project_Rollout__c> proRegListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:regionalRolloutList[0].ID LIMIT 1];
            System.assertEquals(proRegListObj[0].IPM_Rollout_Span__c,REGIONAL_STR,'regional rollout created');//positive test
            
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForBBCountryList});  
            
            insert localRolloutList; 
            
            List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout created');//positive test
            
            // Create Country specific information.
            String geoExternalId = '';
            for(IPM_Project_Rollout__c localRolloutObj : localRolloutList)
            {
                
                if(localRolloutObj.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRolloutObj.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId); 
                mdoGeoList.add(mdo);    
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
                IPM_Project__c = localRolloutObj.IPM_Project__c,local_Rollout__c = localRolloutObj.Id,IPM_Rollout_Status__c = 'With MCO');    
                countryList.add(tempCountry);
            }
            
                    
             insert mdoGeoList;
             List<MDO_Geography__c>mdoList=[select Id from MDO_Geography__c where id=:mdoGeoList[0].Id limit 1];
             system.assertNotEquals(mdoList[0].Id,null,'mdo created'); 
            
            insert countryList;
           
            
            List<IPM_Country__c>counList=[select Id,IPM_Rollout_Status__c from IPM_Country__c where Id=:countryList[0].Id limit 1];
            system.assertEquals(counList[0].IPM_Rollout_Status__c,'With MCO','country inserted');
        }
    }
    
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        
        system.runAs(globalUser){
           ParentProject= IPM_TestFactory_Helper.createIPMProject(FALSE);
           ParentProject.Name='parent project';
           insert ParentProject;
           List<IPM_Project__c>parProList=[select Id,Name from IPM_Project__c where Id=:ParentProject.Id];
           System.assertEquals(parProList[0].Name,'parent project','parent project not created');
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r )
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            project.IPM_Parent_Project__c=ParentProject.Id;
            update project;
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].Name,TEST_COMMENTS_STR,'project not created');//positive test
            
            
            
            
        }
    }
    
       /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void saveScoreTest(){
        
        test.startTest();
        initializeTestMethodData();
        system.runAs(globalUser){
         pRef = Page.IPM_ProjectDocumentSectionEditor;
         pRef.getParameters().put('id', ParentProject.Id);
         Test.setCurrentPage(pRef);
         ipm_bbcountryList=new IPM_BBCountryList();
         List<IPM_Project__c>prjList=[SELECT Id FROM IPM_Project__c WHERE Id=:ParentProject.Id LIMIT 500];
         System.assertEquals(prjList[0].Id,ParentProject.Id,'constructor not called');       
         test.stopTest();
         }
     }
 }