/*******************************************************
 * @Description: Test class for IPM_AddManageSection
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/
@isTest
public class IPM_AddManageSection_Test {
    
    private static IPM_Project__c project;// Project object initialization
    private static IPM_Project_Document__c projDoc;
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static IPM_Project_Document_Section__c projDocSec;
    private static IPM_Document_Template__c ipdt;
    private static IPM_Project_Template__c projTempl;
    private static IPM_Section__c secMst;
    private static PageReference pRef;
    private static IPM_AddManageSection adMng;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static user testUser;
    private static string userLastName_STR='user lastname is:';
    /***********************************
     * @Description: Test Data Creation
     * *********************************/
    static void initializeData()
    {
        //Creation test user
        testUser=IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        List<User>userLists=[SELECT LastName FROM user WHERE id=:testUser.id LIMIT 1];
        System.AssertEquals(userLists[0].LastName, testUser.LastName,userLastName_STR+userLists[0].LastName);//positive test
        
        //create system admin to create master data
        User newAdminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        insert newAdminUser;
        List<User>userList=[SELECT LastName FROM user WHERE id=:newAdminUser.id LIMIT 1];
        System.AssertEquals(userList[0].LastName, newAdminUser.LastName,userLastName_STR+userList[0].LastName);//positive test
        
        system.runAs(newAdminUser){
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
        }
        system.runAs(testUser){
            // Create Project
            IPM_Project__c projectRecord = IPM_TestFactory_Helper.createIPMProject(FALSE);
            insert projectRecord;
            projectList.add(projectRecord);
            List<IPM_Project__c> projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectRecord.ID LIMIT 1];
            project=projlList[0];
            System.assertEquals(projlList[0].id,projectRecord.id);//positive test
            
            //insert project document
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
            
            pRef =Page.IPM_AddManageSections;
            pRef.getParameters().put('id',project.Id);
            pRef.getParameters().put('DocType',projDoc.IPM_GateDocuments__c);
            Test.setCurrentPage(pRef);
            adMng=new IPM_AddManageSection();
        }
    }
    
    /***********************************
     * @Description: Test Method invocation
     * *********************************/
    
    static testMethod void testAddManage()
    {
         initializeData();
         test.startTest();
         system.runAs(testUser){
             //checking for negative case
             adMng.IsModified=true;
             projDocSec.IPM_Default_Section__c=null;//null value can not be save
             adMng.projSubSectionList.add(projDocSec);
             adMng.SaveAddManage();
             List<IPM_Project_Document_Section__c>proDocSec=[SELECT IPM_Default_Section__c FROM 
                                                    IPM_Project_Document_Section__c WHERE ID=:projDocSec.ID LIMIT 1];
             system.assertEquals(proDocSec[0].IPM_Default_Section__c,true, 'IPM Project Document Section- IPM_Default_Section__c is False');//negative test                                      
         }
         test.stopTest();
    }
    
     /*******************************************
     * @Description: Test Method Save Add Manage
     * ******************************************/
    static testMethod void testSaveAddManage()
    {
         initializeData();
         test.startTest();
         system.runAs(testUser){
             //positive test
             projDocSec.IPM_Default_Section__c=false;
             adMng.projSubSectionList.add(projDocSec);
             adMng.SaveAddManage();
             List<IPM_Project_Document_Section__c>proDocSec=[SELECT IPM_Default_Section__c FROM 
                                                    IPM_Project_Document_Section__c WHERE ID=:projDocSec.ID LIMIT 1];
             system.assertEquals(proDocSec[0].IPM_Default_Section__c,false, 'IPM Project Document Section- IPM_Default_Section__c is True');//positive test 
            
         }
         test.stopTest();
    }
}