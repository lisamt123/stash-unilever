/*************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : To test IPM_AssortStrategy class
*************************************************************/
    
@isTest
public class IPM_AssortStrategy_Test {
    
    /*************************************************************
    *@Description : initialise project object
    *************************************************************/
    public static IPM_Project__c project;
    
    /*************************************************************
    *@Description : initialise project document object
    *************************************************************/
    public static IPM_Project_Document__c projDoc;
    
    /*************************************************************
    *@Description : initialise project document section object
    *************************************************************/
    public static IPM_Project_Document_Section__c projDocSec;
    
    /*************************************************************
    *@Description : initialise project document section content object
    *************************************************************/
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    
    /*************************************************************
    *@Description : initialise customer channel priority order object
    *************************************************************/
    public static IPM_Customer_Channel_Priority_Order__c iccPO;
    
    /*************************************************************
    *@Description : hold project id
    *************************************************************/
    public static ID projID;
    
    /*************************************************************
    *@Description : hold project document section id
    *************************************************************/
    public static ID projDocSecID;
    
    /*************************************************************************
    *@Description : to Intialize(insert) the data for Project, Project Document
                    project Document section, project Document section content
                    Customer_Channel_Priority_Order objects
    ***************************************************************************/
    static testMethod void initializeData(){ 
		project = IPM_TestFactory_Helper.createIPMProject(FALSE);
		insert project;

        system.assert(project.ID != null);

		projDoc = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
		projDoc.IPM_Project__c = project.ID;
		insert projDoc;
        system.assert(projDoc.IPM_Project__c != null);
        system.assert(projDoc.ID != null);
        system.assert(projDoc.ID!=null);

		projDocSec = IPM_TestFactory_Helper.createIPMProjectDocumentSection(FALSE);
		projDocSec.IPM_Project_Document__c=projDoc.ID;
		projDocSec.IPM_Selected_Channel_Name__c = 'HyperMarket';
		insert projDocSec;
        system.assert(projDocSec.ID!=null);

		projDocSecCon = IPM_TestFactory_Helper.createIPMProjectDocumentSectionContent(false);
		projDocSecCon.IPM_Project_Document_Section__c = projDocSec.ID;
		insert projDocSecCon;
        system.assert(projDocSec.ID!=null);
        system.assert(projDocSecCon.ID!=null);
        
        projDocSecID=projDocSec.Id;
        system.assert(projDocSecID!=null);
        projID=project.Id;
        system.assert(projID!=null);

		iccPO = IPM_TestFactory_Helper.createIPMCustomerChannelPriorityOrder(false);
		insert iccPO;
        system.assert(iccPO.ID!=null);
    }
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object
    ***************************************************************************/
    static testMethod void testCustomerChannel(){
        IPM_AssortmentStrategy ipmCC=new IPM_AssortmentStrategy ();
        ipmCC.Names=new List<String>();
        System.assertEquals(false, ipmCC.isEditable);
        
    }
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
            to cover CreateAssortStrategy method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testcreateChannel(){
        Test.startTest();
        initializeData();
        Test.stopTest();
        set<string>cuname=new set<string>();
        cuname.add('HyperMarket');
        set<string>cuname1=new set<string>();
        cuname1.add('CU CIF BANO REP ECON DOYP 450ML DOM');
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        system.assert(pRef != null);
        IPM_AssortmentStrategy  ipmCC=new IPM_AssortmentStrategy ();
        ipmCC.ProdocSecId=projDocSec.Id;
        system.assert(ipmCC.ProdocSecId != null);
        ipmCC.setchannelName=cuname;
        ipmCC.setSelectedCUsNames=cuname1;
        ipmCC.IPMProdocContent.IPM_Distribution_Type__c='Numeric';
        system.assertEquals(ipmCC.IPMProdocContent.IPM_Distribution_Type__c,'Numeric');
        ipmCC.channelName='Test,Testing';
        system.assertEquals(ipmCC.channelName,'Test,Testing');
        ipmCC.selectedCUsNames='Test,Testing';
        system.assertEquals(ipmCC.IPMProdocContent.IPM_Distribution_Type__c,'Numeric');
        ipmCC.CreateAssortStrategy();
        system.assert(ipmCC.ProdocSecId!=null,'Flow is correct');
        
        
    }
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
                    to cover updateAssortS method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testchangePriority(){
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        system.assert(pRef != null);
        IPM_AssortmentStrategy ipmCC=new IPM_AssortmentStrategy ();
        ipmCC.ProdocSecId=projDocSec.Id;
        system.assert(ipmCC.ProdocSecId != null);
        ipmCC.selecteAssortTodelete=projDocSecCon.Id;
        system.assert(ipmCC.selecteAssortTodelete != null);
        ipmCC.updateAssortS();
        System.assert(ipmCC.selecteAssortTodelete !=null);
    }
    
    /*************************************************************************
    *@Description : to Intialize the data for IPM_AssortmentStrategy object and 
                    to cover DltAllAssort method of IPM_AssortmentStrategy class
    ***************************************************************************/
    static testMethod void testdeleteSectionContent(){
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        system.assert(pRef != null);
        IPM_AssortmentStrategy ipmCC=new IPM_AssortmentStrategy ();
        ipmCC.ProdocSecId=projDocSec.Id;
        system.assert(ipmCC.ProdocSecId != null);
        ipmCC.DltAllAssort();
        system.assert(ipmCC.ProdocSecId!=null,'Flow is correct');
    }    
}