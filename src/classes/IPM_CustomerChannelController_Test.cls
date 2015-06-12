@isTest
public class IPM_CustomerChannelController_Test {
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section_Content__c projDocSecCon;
    public static IPM_Customer_Channel_Priority_Order__c iccPO;
    public static IPM_Customer_Channel_Priority_Order__c iccPO1;
    public static ID projID;
    public static ID projDocSecID;

    static testMethod void initializeData()
    {
        project=new IPM_Project__c();
        project.Name='TestComments';
        
        project.IPM_Phase__c='Ideas';
        insert project;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        insert projDoc;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Selected_Channel_Name__c='HyperMarket';   
        insert projDocSec;
        
        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        projDocSecCon.IPM_Project_Document_Section__c=projDocSec.ID;
        projDocSecCon.IPM_Customer_Channel_Priority__c=1;
        insert projDocSecCon;
        
        projDocSecID=projDocSec.Id;
        projID=project.Id;
        
        iccPO=new IPM_Customer_Channel_Priority_Order__c();
        iccPO.Name='HyperMarket';
        iccPO.Priority_Order_Value__c='1';
        insert iccPO;
        
        iccPO1=new IPM_Customer_Channel_Priority_Order__c();
        iccPO1.Name='Hyper';
        iccPO1.Priority_Order_Value__c='2';
        insert iccPO1;
        
        
    }
    static testMethod void testCustomerChannel()
    {
        IPM_CustomerChannelContorller ipmCC=new IPM_CustomerChannelContorller();
        ipmCC.Names=new List<String>();
        
    }
    static testMethod void testshowContent()
    {
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        IPM_CustomerChannelContorller ipmCC=new IPM_CustomerChannelContorller();
        ipmcc.projDocSecId=projDocSec.Id;
        ipmcc.projectId=project.Id;
        ipmcc.showSectionContent();
    }
    
    static testMethod void testcreateChannel()
    {
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        IPM_CustomerChannelContorller ipmCC=new IPM_CustomerChannelContorller();
        ipmcc.projDocSecId=projDocSec.Id;
        ipmcc.projectId=project.Id;
        ipmcc.channelName='Hypermarket';
        ipmcc.conName=new List<String>();
    }
    static testMethod void testchangePriority()
    {
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        IPM_CustomerChannelContorller ipmCC=new IPM_CustomerChannelContorller();
        ipmcc.projDocSecId=projDocSec.Id;
        ipmcc.projectId=project.Id;
        ipmcc.secConId=projDocSecCon.Id;
    }
    
    static testMethod void testdeleteSectionContent()
    {
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        IPM_CustomerChannelContorller ipmCC=new IPM_CustomerChannelContorller();
        ipmcc.projDocSecId=projDocSec.Id;
        ipmcc.projectId=project.Id;
        ipmcc.secConId=projDocSecCon.Id;
        ipmcc.updatePriority();
    }
    
    static testMethod void testupdateSectionContent()
    {
        initializeData();
        PageReference pRef = new PageReference('apex/ipmProjectDocumentSectionEditorV1?Id='+project.ID+'&projDocSecId='+projDocSec.Id);
        Test.setCurrentPage(pRef);
        IPM_CustomerChannelContorller ipmCC=new IPM_CustomerChannelContorller();
        ipmcc.projDocSecId=projDocSec.Id;
        ipmcc.projectId=project.Id;
        ipmcc.secConId=projDocSecCon.Id;
        
        IPM_Project_Document_Section_Content__c projDocSecCon1=new IPM_Project_Document_Section_Content__c();
        projDocSecCon1.IPM_Project_Document_Section__c=projDocSec.ID;
        projDocSecCon1.IPM_Customer_Channels__c='Hyper';
        projDocSecCon1.IPM_Customer_Channel_Priority__c=2;
        insert projDocSecCon1;
        ipmcc.arrow='up';
        ipmcc.channelName='Hyper';
        ipmcc.createChannel();
        ipmcc.secConId=projDocSecCon1.Id;
        ipmcc.projDocSecId=projDocSec.ID;
        ipmcc.priorityNumber=1;
        ipmcc.changePriority();
        ipmcc.secConId=projDocSecCon1.Id;
        ipmcc.type='prepos';
        ipmcc.content='content';
        ipmcc.updateSectionContent();
        ipmcc.type='promo';
        ipmcc.content='content';
        ipmcc.updateSectionContent();
        ipmcc.type='pack';
        ipmcc.content='content';
        ipmcc.updateSectionContent();
        ipmcc.type='place';
        ipmcc.content='content';
        ipmcc.updateSectionContent();
        ipmcc.type='price';
        ipmcc.content='content';
        ipmcc.updateSectionContent();
        ipmcc.type='product';
        ipmcc.content='content';
        ipmcc.updateSectionContent();
        ipmcc.channelInfo='Experential';
        ipmcc.updateInfo();
        
        IPM_Project_Document_Section_Content__c projDocSecCon2=new IPM_Project_Document_Section_Content__c();
        projDocSecCon2.IPM_Project_Document_Section__c=projDocSec.ID;
        projDocSecCon2.IPM_Customer_Channels__c='Hyper';
        projDocSecCon2.IPM_Customer_Channel_Priority__c=2;
        insert projDocSecCon2;
        ipmcc.arrow='up';
        ipmcc.channelName='Hyper';
        ipmcc.createChannel();
        
        ipmcc.secConId=projDocSecCon1.Id;
        ipmcc.deleteSectionContent();
    }


}