/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_AssortStrategy class
*************************************************************/

@isTest
private class IPM_AssortmentStrategy_Test {
    
    private static IPM_Project__c project;// Project object initialization
    
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    private static User stdUserForAssort;
    private static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    private static PageReference pRef;
    private static IPM_AssortmentStrategy  ipmAssort;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static string LOCAL_STR='Local';
    private static string REGIONAL_STR='Regional';
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static User globalUser;
    private static final String TEST_TESTING='Test,Testing';
    private static IPM_Project_Document_Section_Content__c projDocSecCon;
    private static final string HYPERMARKET_STR='HyperMarket';
    private static final string INCUMBENT_STR='CU CIF BANO REP ECON DOYP 450ML DOM';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForAssort= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForAssort.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForAssort.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForAssort);
        System.runAs(stdUserForAssort) {
            insert projectList;
            
            project=projectList[0];
            project.Name='ProChgStatus';
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForAssort,stdUserForAssort,stdUserForAssort});
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForAssort});  
            
            insert localRolloutList; 
            
            List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout created');//positive test
            
        }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    public static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r )
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projDocSecCon.IPM_Project_Document_Section__c = projectDocSecListObj[0].ID;
            projDocSecCon.IPM_Customer_Channels__c=HYPERMARKET_STR;
            projDocSecCon.IPM_Assort_Channel_Name__c=HYPERMARKET_STR;
            projDocSecCon.IPM_Incumbent_CUs__c=INCUMBENT_STR;
            projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE;
            projDocSecCon.IPM_Assortment_CU_Priority__c = 1;
            projDocSecCon.IPM_Incumbent_CUs__c = 'Test';
            
            insert projDocSecCon;
            IPM_Project_Document_Section_Content__c projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where id=:projDocSecCon.Id];
            system.assertEquals(projectDocSecConObj.IPM_Content_Type__c,IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE,'Project Document Section Content Type is :'+projectDocSecConObj.IPM_Content_Type__c);
            
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('Id', project.Id);
            pRef.getParameters().put('projDocSecId', projectDocSecListObj[0].Id);
            pRef.getParameters().put('gateType',IPM_ConstantUtils.CHARTER_GATE);
            pRef.getParameters().put('IsEditable',IPM_ConstantUtils.TEAM_TRUE);
            Test.setCurrentPage(pRef);
            
            ipmAssort=new IPM_AssortmentStrategy ();
            System.assertEquals(ipmAssort.isEditable,false,'To check read only or editable');
            
        }
    }
    
    
    
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
            to cover CreateAssortStrategy method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testcreateChannel(){
        
        Test.startTest();
        initializeTestMethodData();
        system.RunAs(globalUser){
            
            set<string>cuname=new set<string>();
            cuname.add(HYPERMARKET_STR);
            set<string>cuname1=new set<string>();
            cuname1.add(INCUMBENT_STR);
            ipmAssort.ProdocSecId=projectDocSecListObj[0].Id;
            ipmAssort.setProdocSecId(projectDocSecListObj[0].Id);
            ipmAssort.setchannelName=cuname;
            ipmAssort.IPMProdocContent.IPM_Distribution_Type__c='Numeric';
            ipmAssort.setSelectedCUsNames=new set<string>();
            ipmAssort.setSelectedCUsNames.clear();
            ipmAssort.channelName='';
            ipmAssort.CreateAssortStrategy();
            ipmAssort.channelName=TEST_TESTING;
            ipmAssort.selectedCUsNames=TEST_TESTING;
            ipmAssort.setSelectedCUsNames=cuname1;
            ipmAssort.HoldCustomesChannels();
            ipmAssort.HoldCUsNames();
            ipmAssort.CreateAssortStrategy();
            List<IPM_Project_Document_Section_Content__c> secConLst=[select IPM_Content_Type__c  from IPM_Project_Document_Section_Content__c where ID=:projDocSecCon.Id];
            system.assertEquals(secConLst[0].IPM_Content_Type__c,IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE,'Data is created');
            Test.stopTest();
        }
    }
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
                    to cover updateAssortS method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testUpdateAssortS(){
        
        
        
        Test.startTest();
        initializeTestMethodData();
        system.RunAs(globalUser){
            
            ipmAssort.AssortPriority='1';
            ipmAssort.ProdocSecId=projectDocSecListObj[0].Id;
            ipmAssort.setProdocSecId(projectDocSecListObj[0].Id);
            ipmAssort.selecteAssort=projDocSecCon.Id;
            ipmAssort.updateAssortS();
            List<IPM_Project_Document_Section_Content__c> secConLst1=[select IPM_Content_Type__c,IPM_Assortment_Strategy_Priority__c  from IPM_Project_Document_Section_Content__c where ID=:projDocSecCon.Id];
            system.assertEquals(secConLst1[0].IPM_Assortment_Strategy_Priority__c,'1','Data is updated');
            
            
            Test.stopTest();
            
        }
    }
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
                    to cover DltAllAssort method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testdeleteSectionContent(){
        
        Test.startTest();
        initializeTestMethodData();
        system.RunAs(globalUser){
            
            ipmAssort.selecteAssortName=INCUMBENT_STR;
            ipmAssort.ProdocSecId=projDocSecCon.Id;
            ipmAssort.DltAllAssort();
            List<IPM_Project_Document_Section__c> secConLst=[select ID  from IPM_Project_Document_Section__c where Id=:ipmAssort.ProdocSecId];
            system.assertEquals(secConLst.size(),0,'record is deleted');
            
            Test.stopTest();
        } 
    } 
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
                    to cover ChangePriority method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testChangePriority(){
        
        
        
        Test.startTest();
        initializeTestMethodData();
        system.RunAs(globalUser){
            
            ipmAssort.priorityNumber=2;
            ipmAssort.arrow=IPM_ConstantUtils.UP_ARROW;
            ipmAssort.priorityCU = 'Test';
            ipmAssort.ProdocSecId=projectDocSecListObj[0].Id;           
            ipmAssort.ChangePriority();
            List<IPM_Project_Document_Section_Content__c> secConLst1=[select IPM_Content_Type__c,IPM_Assortment_Strategy_Priority__c  from IPM_Project_Document_Section_Content__c where ID=:projDocSecCon.Id];
            system.assertEquals(secConLst1[0].IPM_Assortment_Strategy_Priority__c,'1','Data is not updated properly');
            
            
            Test.stopTest();
            
        }
    }   
}