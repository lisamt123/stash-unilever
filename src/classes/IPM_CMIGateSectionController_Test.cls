/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_CMIGateSectionController class
*************************************************************/

@isTest
private class IPM_CMIGateSectionController_Test {
    
    public static IPM_Project__c project;// Project object initialization
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    private static PageReference pRef;
    private static List<user>userList=new List<user>();
    private static user testUser;
    public static List<IPM_Project_Rollout__c> regionalRolloutList;
    public static List<IPM_Project_Rollout__c> localRolloutList;
    public static IPM_Gate_CMI__c gateCmi;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_CMIGateSectionController ipmCmiCon;
    
    /*************************************************************************
    *@Description : to Intialize(insert) the data for Project, Project Document
                    project Document section, project Document section content
                    Customer_Channel_Priority_Order objects
    ***************************************************************************/
    static testMethod void initializeData(){ 
        testUser=IPM_TestFactory_Helper.createUser(false);
        insert testUser;
        userList.add(testUser);
        List<User>userLists=[SELECT id FROM user WHERE id=:testUser.id LIMIT 1];
        System.AssertEquals(userLists[0].id, testUser.id,'user id is:'+userLists[0].id);//positive test
        //creating Project Template
        IPM_Project_Template__c projTemplate = IPM_TestFactory_Helper.createIPMProjectTemplate(FALSE);
        insert projTemplate;
        
        List<IPM_Project_Template__c> projTemplList=[SELECT ID,IPM_Template_Complexity__c FROM IPM_Project_Template__c WHERE ID=:projTemplate.ID LIMIT 1];
        
        projTempl=projTemplList[0];        
        System.assertEquals(projTempl.IPM_Template_Complexity__c, IPM_ConstantUtils.COMPLEXITY_FULL);

        IPM_Document_Template__c ipdoctem = IPM_TestFactory_Helper.creteIPMDocumentTemplate(FALSE);
        ipdoctem.IPM_Project_Template__c = projTempl.ID;
        insert ipdoctem;
        
        List<IPM_Document_Template__c> projDocTemplList=[SELECT ID,IPM_Project_Template__c,IPM_Document_Template_Name__c,IPM_Document_Type__c FROM IPM_Document_Template__c WHERE ID=:ipdoctem.ID LIMIT 1];
        ipdt=projDocTemplList[0];
        
        System.assertEquals(projDocTemplList[0].id,ipdoctem.id );//positive test
        
        //Creating master Section
        IPM_Section__c secMast = IPM_TestFactory_Helper.createIPMSection(FALSE);
        secMast.IPM_Document_Template__c = ipdt.ID;
        insert secMast;
        
        List<IPM_Section__c> projSecMstlList=[SELECT ID,IPM_Document_Template__c,IPM_Section_Sequence__c,IPM_Section_Name__c FROM IPM_Section__c WHERE ID=:secMast.ID LIMIT 1];

        secMst=projSecMstlList[0];
        System.assertEquals(projSecMstlList[0].IPM_Document_Template__c,ipdt.ID);//positive test
        
        
        userList =IPM_TestFactory_Helper.createUserList();
        
        projectList=IPM_TestFactory_Helper.projectSetUp(1);
        project=projectList[0];
        
        List<IPM_Project__c> projlList=[SELECT ID,IPM_Company_Card__c,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
        
        System.assertEquals(projlList[0].IPM_Company_Card__c,project.IPM_Company_Card__c,'company card matched');//positive test
        
        
        // At this point Async process kicks in and starts creating Related Object information.

        IPM_Project_Document__c projDocument = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        projDocument.IPM_Project__c=project.ID;
        projDocument.IPM_Project_Template__c= projTempl.Id;  
        insert projDocument;
        
        projDocList=[SELECT IPM_GateDocuments__c,IPM_Project__c,IPM_Project_Template__c,IPM_Contract_GateKeeper_Model__c FROM IPM_Project_Document__c WHERE ID=:projDocument.ID LIMIT 1];
        projDoc=projDocList[0];
        System.assertEquals(projDocList[0].IPM_Project__c,project.ID);//positive test
        
        // Creationg Project Document Sections
        IPM_Project_Document_Section__c pojDocSection = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
        pojDocSection.IPM_Project_Document__c=projDoc.ID;
        
        pojDocSection.IPM_Section__c=secMst.Id;
        insert pojDocSection;

        List<IPM_Project_Document_Section__c> projDocSecList=[SELECT ID,IPM_Default_Section__c,IPM_Project_Document__c,IPM_Section__c FROM IPM_Project_Document_Section__c WHERE ID=:pojDocSection.ID LIMIT 1];
        projDocSec=projDocSecList[0];
        System.assertEquals(projDocSecList[0].IPM_Section__c,secMst.Id); //positive test 
        
        gateCmi=IPM_TestFactory_Helper.createGateCMI(project.Id,false);
        gateCmi.IPM_Skip_Test__c=false;
        insert gateCmi;
        
        List<IPM_Gate_CMI__c> cmiObj=[SELECT ID,IPM_Skip_Test__c FROM IPM_Gate_CMI__c WHERE ID=:gateCmi.ID LIMIT 1];
        System.assertEquals(cmiObj[0].IPM_Skip_Test__c,false);//positive test
        
        projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
        projDocSecCon.IPM_Project_Document_Section__c = projDocSec.ID;
        projDocSecCon.IPM_Content_Type__c='CMI Gate';
        projDocSecCon.IPM_Gate_CMI__c=gateCmi.Id;
        
        insert projDocSecCon;
        IPM_Project_Document_Section_Content__c projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where id=:projDocSecCon.Id];
        system.assertEquals(projectDocSecConObj.IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE);
        List<IPM_Project_Document_Section_Content__c>conList=new List<IPM_Project_Document_Section_Content__c>();
        conList.add(projDocSecCon);
        
        List<IPM_Project_Document_Section_Content__share>projectConShareList=IPM_TestFactory_Helper.shareIPMSectionContent(conList,userList);
        insert projectConShareList;
        
        list<IPM_Project_Document_Section_Content__share>shareList1=[SELECT ParentId,UserOrGroupId FROM IPM_Project_Document_Section_Content__share WHERE ParentId=:projDocSecCon.id AND UserOrGroupId=:userList[0].id LIMIT 1];
        system.assertEquals(shareList1[0].UserOrGroupId,userList[0].id,userList[0].id+'User should have edit access to project');//positive test
        
        pRef = Page.IPM_ProjectDocumentSectionEditor;
        pRef.getParameters().put('Id', project.Id);
        Test.setCurrentPage(pRef);
        
        ipmCmiCon=new IPM_CMIGateSectionController();
        
    } 
    
    /*************************************************************************
    *@Description : to call  the method for IPM_CMIGateSectionController object 
            
    ***************************************************************************/
    static testMethod void dotest1(){
        initializeData();
        Test.startTest();
        system.RunAs(userList[0]){
            ipmCmiCon.projectId=project.Id;
            ipmCmiCon.setprojDocSecId(projDocSec.ID);
            ipmCmiCon.gateType='Charter';
            ipmCmiCon.showTableData();
            List<IPM_Project_Document_Section_Content__c> projectDocSecConObj=[select IPM_Content_Type__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ipmCmiCon.projDocSecId];
            system.assertEquals(projectDocSecConObj[0].IPM_Content_Type__c,IPM_ConstantUtils.CMIGATE_CONTENT_TYPE,'content type matched');
            Test.stopTest();
        }
    }


}