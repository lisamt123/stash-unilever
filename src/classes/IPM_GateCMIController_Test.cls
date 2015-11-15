/******************************************************************************************************************************
* @author Cognizant 
* @date 15/12/2014
* @description Test Class for IPM_GateCMIController
*/
@isTest
public class IPM_GateCMIController_Test{    
    public static IPM_Project__c project;// Project object initialization
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static User stdUserForGateCMI;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static List<SelectOption> secOpt=new List<SelectOption>();
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    public static PageReference  pRef;
    public static IPM_GateCMIController ipmCmiControl;
    private static final string TEST_COMMENTS_STR='TestComments1';
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static IPM_Project_Document_Section_Content__c projectDocSecConObj=new IPM_Project_Document_Section_Content__c();
    public static User globalUser;
    private static string LOCAL_STR='Local';
    private static string REGIONAL_STR='Regional';
    public static IPM_Project_Document_Section__c docSec;
    public static IPM_Project_Document__c document;
    public static IPM_Gate_CMI__c gateCMICountry;
    public static IPM_Gate_CMI__c gateCMI;
    public static IPM_Project_Document_Section_Content__c projectDocSecConListObj=new IPM_Project_Document_Section_Content__c();
    public static IPM_CMI_Color_Mapping__c color=new IPM_CMI_Color_Mapping__c();
    public static IPM_CMI_Overall_Color_Mapping__c overallColor=new IPM_CMI_Overall_Color_Mapping__c();
    private static final string COUNTRY_NAME_STR='contry name';
    private static final string RESULT_STR='result';
    private static final string NAME_STR='cmi color';
    private static final string NAME_OVERALL_STR='cmi color overall';
     public static mdo_Geography__c mdoGeo=new mdo_Geography__c();
    private static final string INDIA_STR='IND';
    public static List<IPM_Country__c>countryList=new List<IPM_Country__c>();
   
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
      {
          // user has to be created as system admin 
            stdUserForGateCMI= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
       
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForGateCMI.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForGateCMI.id,'user id is:'+userLists[0].id);//positive test
       
           // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForGateCMI);
        System.runAs(stdUserForGateCMI) {
            insert projectList;
        
        project=projectList[0];
        project.Name='ProChgStatus';
        List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
        System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
        
        List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForGateCMI,stdUserForGateCMI,stdUserForGateCMI});
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForGateCMI});  
            
            insert localRolloutList; 
           
           List<IPM_Project_Rollout__c> proLocListObj=[SELECT IPM_Rollout_Span__c from IPM_Project_Rollout__c WHERE ID =:localRolloutList[0].ID LIMIT 1];
            System.assertEquals(proLocListObj[0].IPM_Rollout_Span__c,LOCAL_STR,'local rollout created');//positive test
            
            // Create Country specific information.
            
            for(IPM_Project_Rollout__c localRolloutObj : localRolloutList)
            {
                String geoExternalId = '';
                if(localRolloutObj.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRolloutObj.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
            
             MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId);
                 
                insert mdo;
                List<MDO_Geography__c>mdoList=[select Id from MDO_Geography__c where id=:mdo.Id limit 1];
                system.assertNotEquals(mdoList[0].Id,null,'mdo created');
       
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
                IPM_Project__c = localRolloutObj.IPM_Project__c,local_Rollout__c = localRolloutObj.Id,IPM_Rollout_Status__c = 'With MCO');    
                countryList.add(tempCountry);
            }
            
            insert countryList;
            
           List<IPM_Country__c>counList=[select Id,IPM_Rollout_Status__c from IPM_Country__c where Id=:countryList[0].Id limit 1];
            system.assertEquals(counList[0].IPM_Rollout_Status__c,'With MCO','country inserted');
    }
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].id,project.id);//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
           
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            projectDocSecListObj[0].IPM_CMI_Selected_Test_Concepts__c='concept';
            projectDocSecListObj[0].IPM_CMI_Selected_Countries__c=INDIA_STR;
            update projectDocSecListObj[0];
             
             document=projDocList[0];
            docSec=projectDocSecListObj[0];
            
            
            gateCMICountry=IPM_TestFactory_Helper.createGateCMI(project.Id, false);
            gateCMICountry.IPM_Project__c = project.Id;
            gateCMICountry.Results__c=RESULT_STR;
            gateCMICountry.Test__c=RESULT_STR;
            gateCMICountry.Country__c=INDIA_STR;
            insert gateCMICountry;
            List<IPM_Gate_CMI__c>cmicounList=[select Results__c from IPM_Gate_CMI__c where Id=:gateCMICountry.Id];
            System.assertEquals(cmicounList[0].Results__c,RESULT_STR,'cmi created');
            
            gateCMI=IPM_TestFactory_Helper.createGateCMI(project.Id, false);
            gateCMI.IPM_Project__c = project.Id;
            insert gateCMI;
            List<IPM_Gate_CMI__c>cmiList=[select IPM_Project__c from IPM_Gate_CMI__c where Id=:gateCMI.Id];
            System.assertEquals(cmiList[0].IPM_Project__c,project.Id,'cmi created');
            
            
            color.IPM_CMI_Color__c='red';
            color.Name=NAME_STR;
            insert color;
            List<IPM_CMI_Color_Mapping__c>clorList=[select Id,Name from IPM_CMI_Color_Mapping__c where Id=:color.Id];
            System.assertEquals(clorList[0].Name,NAME_STR,'color mapping created');
            
            overallColor.IPM_CMI_Test__c=RESULT_STR;
            overallColor.Name=NAME_OVERALL_STR;
            insert overallColor;
            List<IPM_CMI_Overall_Color_Mapping__c>colorList=[select Id,Name from IPM_CMI_Overall_Color_Mapping__c where Id=:overallColor.Id];
            System.assertEquals(colorList[0].Name,NAME_OVERALL_STR,'color mapping created');
            
        
            
            projectDocSecConListObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConListObj.IPM_Project_Document_Section__c = docSec.ID;
            projectDocSecConListObj.IPM_Gate_Type__c='Charter';
            projectDocSecConListObj.IPM_Gate_CMI__c=gateCMICountry.Id; 
            projectDocSecConListObj.IPM_CMI_Country__c = INDIA_STR;
            projectDocSecConListObj.IPM_CMI_Is_Free_Text__c=true;
            projectDocSecConListObj.IPM_CMI_Result__c=RESULT_STR;
            projectDocSecConListObj.IPM_CMI_Results_Acheived__c='achieved';
            projectDocSecConListObj.IPM_CMI_Country__c=COUNTRY_NAME_STR;
            insert projectDocSecConListObj;
            
            List<IPM_Project_Document_Section_Content__c>conList=[select Id,IPM_CMI_Result__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConListObj.Id];
            System.assertEquals(conList[0].IPM_CMI_Result__c,RESULT_STR,'content created');
            
            projectDocSecConObj = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
            projectDocSecConObj.IPM_Project_Document_Section__c = docSec.ID;
            projectDocSecConObj.IPM_Gate_Type__c='Charter';
            projectDocSecConObj.IPM_Gate_CMI__c=gateCMI.Id; 
            projectDocSecConObj.IPM_CMI_Country__c = INDIA_STR;
            projectDocSecConObj.IPM_CMI_Is_Free_Text__c=true;
            projectDocSecConObj.IPM_CMI_Result__c=RESULT_STR;
            projectDocSecConObj.IPM_CMI_Results_Acheived__c='achieved';
            projectDocSecConObj.IPM_CMI_Country__c=COUNTRY_NAME_STR;
            insert projectDocSecConObj;
            
            List<IPM_Project_Document_Section_Content__c>contentList=[select Id,IPM_CMI_Result__c from IPM_Project_Document_Section_Content__c where Id=:projectDocSecConObj.Id];
            System.assertEquals(contentList[0].IPM_CMI_Result__c,RESULT_STR,'content created');
            
              
            
            pRef = Page.IPM_CMIGateView;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, projectListObj[0].Id);
            Test.setCurrentPage(pRef);
            ipmCmiControl=new IPM_GateCMIController();
            
        }
    }
    
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testgetCountries() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
             
            ipmCmiControl.isEditable=true;
            ipmCmiControl.resultTiming=system.today();
            ipmCmiControl.overallColorMethod='color method';
            ipmCmiControl.overallScore='over all score';
            ipmCmiControl.overallComments='overall comment';
            ipmCmiControl.isEditActionStandard=true;
            ipmCmiControl.elements=new List<SelectOption>();
            ipmCmiControl.elements.add(new SelectOption('elements','elements'));
            ipmCmiControl.tests=new List<SelectOption>();
            ipmCmiControl.tests.add(new SelectOption('test','test'));
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.gateType='Charter';
            ipmCmiControl.projDocSec=docSec;
            ipmCmiControl.projDocSecId=docSec.Id;
            
            ipmCmiControl.gateType=IPM_ConstantUtils.CHARTER_GATE;
            ipmCmiControl.getCountries();
            ipmCmiControl.gateType=IPM_ConstantUtils.CONTRACT_GATE;
            ipmCmiControl.getCountries();
            
          List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where Id=:ipmCmiControl.projDocSecId];
           System.assertEquals(secList[0].IPM_Project_Document__r.IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,'gate value');
            Test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testgetGates() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.getGates();
            ipmCmiControl.gateType=IPM_ConstantUtils.CONTRACT_GATE;
            ipmCmiControl.getGates();
            ipmCmiControl.gateType=IPM_ConstantUtils.MARKET_READY_GATE;
            ipmCmiControl.getGates();
            ipmCmiControl.gateType=IPM_ConstantUtils.CHARTER_GATE;
            List<IPM_Project_Document_Section__c>secList=[select Id,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where Id=:ipmCmiControl.projDocSecId];
            System.assertEquals(secList[0].IPM_Project_Document__r.IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,'gate value');
            Test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testcreateCMISections() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.cmiName='Charter/Test/Quant Pack test - PRS PackEval';
            ipmCmiControl.createCMISections();
            docSec.IPM_CMI_Selected_Test_Concepts__c='';
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.createCMISections();
            docSec.IPM_CMI_Selected_Test_Concepts__c='';
            update docSec;
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.createCMISections();
            List<IPM_Project_Document_Section__c>secList=[SELECT Id,IPM_CMI_Selected_Countries__c,IPM_CMI_Selected_Test_Concepts__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                    FROM IPM_Project_Document_Section__c WHERE Id=:projectDocSecListObj[0].Id];
            System.assertEquals(secList[0].IPM_Project_Document__c,document.Id,'cmi section value');
            Test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testcreateCountryCMI() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();  
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;         
            ipmCmiControl.isComment =true;
            ipmCmiControl.countryName='abc';
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.createCountryCMI();
            ipmCmiControl.countryName=INDIA_STR;
            
            ipmCmiControl.createCountryCMI();
            List<IPM_Gate_CMI__c>cmiListData=[SELECT id,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,IPM_CMI_Overall_Colour_Score_Method__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                 FROM IPM_Gate_CMI__c WHERE Id=:ipmCmiControl.gateCMIId];
            System.assertEquals(cmiListData[0].Country__c,'IND;abc','country value');
            gateCMICountry.Country__c='abc';
            update gateCMICountry;
            Test.stopTest();
        }
    }
    
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testupdateCMI() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.isComment=true;
            ipmCmiControl.isEditActionStandard=false;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;  
            Map<String,IPM_CMI_Color_Mapping__c> colorMap=new Map<String,IPM_CMI_Color_Mapping__c>();  
            colorMap.put(RESULT_STR,color);          
            ipmCmiControl.updateCMI();
            ipmCmiControl.isComment=false;          
            ipmCmiControl.updateCMI();
            projectDocSecConListObj.IPM_CMI_Is_Free_Text__c=false;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            update projectDocSecConListObj;
            ipmCmiControl.colorMapping=colorMap;
            ipmCmiControl.resultCMI=RESULT_STR;
            ipmCmiControl.updateCMI();
            ipmCmiControl.isEditActionStandard=true;
            ipmCmiControl.updateCMI();
            ipmCmiControl.isEditActionStandard=false;
            color.IPM_Color_Score_Value__c='1';
            update color;
            ipmCmiControl.updateCMI();
            ipmCmiControl.isEditActionStandard=true;
            ipmCmiControl.updateCMI();
            ipmCmiControl.gateType=IPM_ConstantUtils.CONTRACT_GATE;
            ipmCmiControl.updateCMI();
            ipmCmiControl.countryName = INDIA_STR;
            ipmCmiControl.createCountryCMI();
            List<IPM_Gate_CMI__c>cmiListData=[SELECT id,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,IPM_CMI_Overall_Colour_Score_Method__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                 FROM IPM_Gate_CMI__c WHERE Id=:ipmCmiControl.gateCMIId];
            System.assertEquals(cmiListData[0].Country__c,INDIA_STR,'update cmi');
            Test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testmethod void testupdateSkipTestReason(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.isSkip = true;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.skipComment='reason';
            ipmCmiControl.skipTest();
            ipmCmiControl.updateSkipTestReason();
            List<IPM_Gate_CMI__c>cmiListData=[SELECT id,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,IPM_CMI_Overall_Colour_Score_Method__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                 FROM IPM_Gate_CMI__c WHERE Id=:ipmCmiControl.gateCMIId];
            System.assertEquals(cmiListData[0].IPM_Skip_Test_Reason__c,'reason','skip test');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testmethod void testoverallScoreColor(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.isSkip = true;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            Map<String,IPM_CMI_Overall_Color_Mapping__c> overallColorMap=new Map<String,IPM_CMI_Overall_Color_Mapping__c>();  
            overallColorMap.put(RESULT_STR,overallColor);
            ipmCmiControl.overallColorMapping=new Map<String,IPM_CMI_Overall_Color_Mapping__c>();
            ipmCmiControl.overallColorMapping=overallColorMap;
            ipmCmiControl.gateType=IPM_ConstantUtils.CONTRACT_GATE;
            ipmCmiControl.isEditActionStandard=true;
           
            ipmCmiControl.overallScoreColor(COUNTRY_NAME_STR,string.valueOf(gateCMICountry.Id),true);
            ipmCmiControl.isEditActionStandard=false;
            ipmCmiControl.overallScoreColor(COUNTRY_NAME_STR,string.valueOf(gateCMICountry.Id),true);
            ipmCmiControl.gateType=IPM_ConstantUtils.CHARTER_GATE;
            ipmCmiControl.isEditActionStandard=true;
            ipmCmiControl.overallScoreColor(COUNTRY_NAME_STR,string.valueOf(gateCMICountry.Id),true);
            ipmCmiControl.isEditActionStandard=false;
            ipmCmiControl.overallScoreColor(COUNTRY_NAME_STR,string.valueOf(gateCMICountry.Id),true);
             List<IPM_Project_Document_Section_Content__c>secColorList=[SELECT Id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Result__c,IPM_CMI_Country__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Gate_Test__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                      FROM IPM_Project_Document_Section_Content__c 
                      WHERE IPM_Gate_CMI__c=:ipmCmiControl.gateCMIId];
            System.assertEquals(secColorList[0].IPM_CMI_Country__c,COUNTRY_NAME_STR,'overall score test');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testmethod void testupdateResultTiming(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.isSkip = true;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.updateResultTiming();
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testmethod void testupdateOverallScore(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.isSkip = true;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.countryNameStr=COUNTRY_NAME_STR;
            ipmCmiControl.isEditActionStandard=false;
            ipmCmiControl.updateOverallScore();
            List<IPM_Project_Document_Section_Content__c>secColorList=[SELECT id,IPM_CMI_Country__c,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Result_Timing__c,IPM_Gate_CMI__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c FROM IPM_Project_Document_Section_Content__c 
                                        WHERE IPM_Gate_CMI__c=:ipmCmiControl.gateCMIId];
            System.assertEquals(secColorList[0].IPM_CMI_Country__c,COUNTRY_NAME_STR,'overall score test');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testdeleteCountry() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConListObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.gateCMIId=gateCMICountry.Id;
            ipmCmiControl.countryNameStr=COUNTRY_NAME_STR;
            ipmCmiControl.deleteCountry();
            List<IPM_Project_Document_Section_Content__c>secColorList=[SELECT Id FROM IPM_Project_Document_Section_Content__c
                            WHERE IPM_Gate_CMI__c=:ipmCmiControl.gateCMIId];
             System.assertEquals(secColorList.size(),0,'country deleted');
            Test.stopTest();
        }
    }           
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void testdeleteCMI() {
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmCmiControl.projDocSecId=docSec.Id;
            ipmCmiControl.secConId=projectDocSecConObj.Id;
            ipmCmiControl.projectId=project.Id;
            ipmCmiControl.gateCMIId=gateCMI.Id;         
            ipmCmiControl.deleteCMI();
            List<IPM_Project_Document_Section_Content__c>secColorList=[SELECT Id FROM IPM_Project_Document_Section_Content__c
                            WHERE IPM_Gate_CMI__c=:ipmCmiControl.gateCMIId];
             System.assertEquals(secColorList.size(),0,'country deleted');
            Test.stopTest();
        }
    }
    
    
}