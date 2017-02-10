/******************************************************************************************************************************
* @author Cognizant 
* @date 03/02/2017
* @description Test Class for IPM_ProjectsClustersMappingController
*/
@isTest
public class IPM_ProjectsClustersMappiController_Test{
    
    private static IPM_Project__c projectWithCid;// Project object initialization
    private static IPM_Project__c projectWithoutCid;// Project object initialization
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static PageReference pageRef;
    private static final string TEST_COMMENTS1_STR='TestComments1';
    private static final string TEST_COMMENTS2_STR='TestComments2';
    private static final string TEST_CLUSTER_STR='SAMPLECL';
    private static User globalUser;
    private static User stdUser;
    private static IPM_Clusters__c pcluster = new IPM_Clusters__c();
    private static IPM_ProjectsClustersMappingController testCmc;
    private static final string positiveSearchString = 'TestComments1';
    private static final string negativeSearchString = 'TestComments3';
   
   /*************************************************************************************************************************
    * @description Test Data
    */
    @TestSetup static void initializeData(){
        
        test.startTest();
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            stdUser= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUser.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUser.id,'user not created properly');//positive test
        
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        pcluster = new IPM_Clusters__c(Name=TEST_CLUSTER_STR, IPM_Sum_Y3iTO__c=2);
        insert pcluster; 
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);   
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card not inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(2,stdUser);
        System.runAs(stdUser) {        
            insert projectList;
        } 

        List<IPM_Clusters__c> pcl1 = [SELECT ID, Name from IPM_Clusters__c WHERE Id = :pcluster.id LIMIT 1];
        System.assertEquals(pcl1[0].Name,TEST_CLUSTER_STR,'cluster insertion failed');//positive test
        
        projectWithCid=projectList[0];            
        List<IPM_Project__c> projlList1=[SELECT Id, Name, IPM_Project_Name__c, IPMProject_Span__c, IPM_Project_Type__c, IPM_Cluster__c FROM IPM_Project__c WHERE ID=:projectWithCid.ID LIMIT 1];
        System.assertEquals(projlList1[0].Name,TEST_COMMENTS1_STR,'project insertion failed');//positive test
        
        projectWithoutCid=projectList[1];            
        List<IPM_Project__c> projlList2=[SELECT Id, Name, IPM_Project_Name__c, IPMProject_Span__c, IPM_Project_Type__c, IPM_Cluster__c FROM IPM_Project__c WHERE ID=:projectWithoutCid.ID LIMIT 1];
        System.assertEquals(projlList2[0].Name,TEST_COMMENTS2_STR,'project insertion failed');//positive test                        
        
        test.stopTest();
                
    }
    
    static testMethod void projectsClustersMappingTest(){
       globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
       List<IPM_Clusters__c>pcClusterList = [SELECT name,IPM_Sum_Y3iTO__c FROM IPM_Clusters__c];
        system.RunAs(globalUser){
            test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(pcClusterList[0]);
                testCmc = new IPM_ProjectsClustersMappingController(sc);                
                
                pageRef = Page.IPM_ProjectsClustersMapping;
                pageRef.getParameters().put('id', String.valueOf(pcClusterList[0].Id));
                Test.setCurrentPage(pageRef);
        
                //load test for available projects
                testCmc.getProjects();
                System.assertEquals(testCmc.plwList.size()>0,true,'project retrieval failed');
                
                //load test for existing projects
                testCmc.getProjectsInCurrentCluster();
                System.assertEquals(testCmc.removalPlwList.size()==0,true,'project retrieval failed');
                
                //test for Y3iTO retrieval
                Decimal y3value = testCmc.getCurrentClusterY3ito();
                System.assertEquals(y3value>0,true,'Y3iTO retrieval failed');
                
                // test for selection in available projects
                testCmc.plwList[0].isSelected = true;
                testCmc.getSelectedProjects();
                System.assertEquals(testCmc.getselectedProjectMapSize()>0,true,'Selected projects Error');
                
                testCmc.plwList[1].isSelected = true;
                testCmc.getSelectedProjects();
                System.assertEquals(testCmc.getselectedProjectMapSize()>0,true,'Selected projects Error');
                
                //test for processing selected available projects
                testCmc.getProjects();
                testCmc.processSelectedProjects();
                testCmc.getProjects();
                System.assertEquals(testCmc.plwList.size()==0,true,'project retrieval failed');
                testCmc.getProjectsInCurrentCluster();
                System.assertEquals(testCmc.removalPlwList.size()>0,true,'project retrieval failed');
                
                //test for selection in existing projects
                testCmc.removalPlwList[0].isSelected = true;
                testCmc.getRemovalProjects();
                System.assertEquals(testCmc.getremovalProjectMapSize()>0,true,'Selected projects Error');
                
                testCmc.removalPlwList[1].isSelected = true;
                testCmc.getRemovalProjects();
                System.assertEquals(testCmc.getremovalProjectMapSize()>0,true,'Selected projects Error');
                
                //test for processing selected existing projects
                testCmc.getProjectsInCurrentCluster();
                testCmc.processRemovalProjects();
                testCmc.getProjectsInCurrentCluster();
                System.assertEquals(testCmc.removalPlwList.size()==0,true,'project retrieval failed');
                testCmc.getProjects();
                System.assertEquals(testCmc.plwList.size()>0,true,'project retrieval failed');
                
            test.stopTest();
        }
    }
    
    static testMethod void searchAndNavigationTest(){
       globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
       List<IPM_Clusters__c>pcClusterList = [SELECT name,IPM_Sum_Y3iTO__c FROM IPM_Clusters__c];
        system.RunAs(globalUser){
            test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(pcClusterList[0]);
                testCmc = new IPM_ProjectsClustersMappingController(sc);
                
                pageRef = Page.IPM_ProjectsClustersMapping;
                pageRef.getParameters().put('id', String.valueOf(pcClusterList[0].Id));
                Test.setCurrentPage(pageRef);
                
                //positive search test
                testCmc.searchProjectName = positiveSearchString;
                testCmc.searchProjects();
                testCmc.getProjects();
                System.assertEquals(testCmc.plwList.size()>0,true,'project retrieval failed');
                
                //negative search test
                testCmc.searchProjectName = negativeSearchString;
                testCmc.searchProjects();
                testCmc.getProjects();
                System.assertEquals(testCmc.plwList.size()==0,true,'project retrieval failed');
                
                // test for selection in available projects
                testCmc.searchProjectName = '';
                testCmc.searchProjects();
                testCmc.getProjects();
                testCmc.plwList[0].isSelected = true;
                testCmc.getSelectedProjects();
                System.assertEquals(testCmc.getselectedProjectMapSize()>0,true,'Selected projects Error');
                                
                //test for processing selected available projects
                testCmc.getProjects();
                testCmc.processSelectedProjects();
                testCmc.getProjects();
                System.assertEquals(testCmc.plwList.size()>0,true,'project retrieval failed');
                testCmc.getProjectsInCurrentCluster();
                System.assertEquals(testCmc.removalPlwList.size()>0,true,'project retrieval failed');
                                                                
                //test for cluster Id setter method
                testCmc.clusterId = pcClusterList[0].id;
                Id cid = testCmc.clusterId;
                System.assertEquals(cid,pcClusterList[0].id,'cluster id not set');
                
                //test for navigating available projects
                testCmc.first();
                testCmc.last();
                testCmc.previous();
                testCmc.next();
                integer noofrec = testCmc.getnoOfRecords();
                System.assertEquals(noofrec,1,'number of records retrieval failed');
                boolean hasnxt = testCmc.gethasNext();
                System.assertEquals(hasnxt,false,'navigation failed');
                boolean hasprev = testCmc.gethasPrevious();
                System.assertEquals(hasprev,false,'navigation failed');
                integer pno = testCmc.getPageNumber();
                System.assertEquals(pno,1,'navigation failed');
                                
                //test for navigating existing projects
                testCmc.cfirst();
                testCmc.clast();
                testCmc.cprevious();
                testCmc.cnext();
                integer cnoofrec = testCmc.getcnoOfRecords();
                System.assertEquals(cnoofrec,1,'number of records retrieval failed');
                boolean chasnxt = testCmc.getchasNext();
                System.assertEquals(chasnxt,false,'navigation failed');
                boolean chasprev = testCmc.getchasPrevious();
                System.assertEquals(chasprev,false,'navigation failed');
                integer cpno = testCmc.getcPageNumber();
                System.assertEquals(cpno,1,'navigation failed');
                                
            test.stopTest();
        }
    }
    
    static testMethod void errorsAndCatchBlockTest(){
       globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
       List<IPM_Clusters__c>pcClusterList = [SELECT name,IPM_Sum_Y3iTO__c FROM IPM_Clusters__c];
        system.RunAs(globalUser){
            test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(pcClusterList[0]);
                testCmc = new IPM_ProjectsClustersMappingController(sc);
                
                pageRef = Page.IPM_ProjectsClustersMapping;
                pageRef.getParameters().put('id', String.valueOf(pcClusterList[0].Id));
                Test.setCurrentPage(pageRef);
                
                //test for catch blocks - processSelectedProjects()
                testCmc.getProjects();
                testCmc.clusterId = globalUser.id;                
                testCmc.plwList[0].isSelected = true;
                testCmc.processSelectedProjects();
                testCmc.clusterId = Null;
                
                //test for catch blocks - processRemovalProjects()
                testCmc.removalProjectMap.put(globalUser.id, Null);
                testCmc.processRemovalProjects();
                
                //test for catch blocks - getSelectedProjects()
                testCmc.selectedProjectMap = null;
                testCmc.getSelectedProjects();
                
                //test for catch blocks - getRemovalProjects()
                testCmc.removalProjectMap = null;
                testCmc.getRemovalProjects();
                                
                //test when page parameters are not given - Available projects
                PageReference pageRefNull = Page.IPM_ProjectsClustersMapping;
                Test.setCurrentPage(pageRefNull);
                testCmc.clusterId = null;
                testCmc.setCon = null;
                integer noofrecnull = testCmc.getnoOfRecords();
                System.assertEquals(noofrecnull,0,'number of records retrieval failed');
                boolean hasnxtnull = testCmc.gethasNext();
                System.assertEquals(hasnxtnull,false,'navigation failed');
                boolean hasprevnull = testCmc.gethasPrevious();
                System.assertEquals(hasprevnull,false,'navigation failed');
                integer pnonull = testCmc.getPageNumber();
                System.assertEquals(pnonull,0,'navigation failed');
                                
                //test when page parameters are not given - Existing projects
                testCmc.setConInCluster = null;
                integer cnoofrecnull = testCmc.getcnoOfRecords();
                System.assertEquals(cnoofrecnull,0,'number of records retrieval failed');
                boolean chasnxtnull = testCmc.getchasNext();
                System.assertEquals(chasnxtnull,false,'navigation failed');
                boolean chasprevnull = testCmc.getchasPrevious();
                System.assertEquals(chasprevnull,false,'navigation failed');
                integer cpnonull = testCmc.getcPageNumber();
                System.assertEquals(cpnonull,0,'navigation failed');
                
                //test for Y3iTO catch block
                Decimal y3valuenull = testCmc.getCurrentClusterY3ito();
                System.assertEquals(y3valuenull,null,'Y3iTO catch block failed');
                               
                
            test.stopTest();
        }
    }

}