@isTest
public class IPM_GateCMIContorller_Test 
{
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project__c project1;
    public static IPM_Project_Document__c projDoc1;
    public static IPM_Project_Document_Section__c projDocSec1;
    public static IPM_Project_Document_Section_Content__c pscon;
    public static IPM_Gate_CMI__c gate;
    public static IPM_Country__c con =new IPM_Country__c();
    public static mdm_Geography__c geo=new mdm_Geography__c();
    public static IPM_Gate_CMI_KPI_Inputs__c cki;
    public static Set<Id> parentId;
    public static Set<Id> presentId;
    static testMethod void initializeData()
    {
        project=new IPM_Project__c();
        project.Name='TestCdsomments';
        project.IPM_Project_Gatekeeper__c=UserInfo.getUserId();
        project.IPM_Phase__c='Ideas';
        project.IPM_GateKeeping_Model__c='BOTH';
        insert project;
        
        parentId=new Set<Id>();
        parentId.add(project.Id);
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Document_Status__c='Proposed';
        insert projDoc;
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Selected_Channel_Name__c='Ideas';  
        projDocSec.IPM_Gate_Document_Summary__c='sfasdfsdafsdfsdfafadfdsf';
        insert projDocSec;
        
        project1=new IPM_Project__c();
        project1.Name='TestCdsomments';
        project1.IPM_Project_Gatekeeper__c=UserInfo.getUserId();
        project1.IPM_Phase__c='Ideas';
        project1.IPM_GateKeeping_Model__c='BOTH';
        insert project1;
        
        presentId=new Set<Id>();
        presentId.add(project1.Id);
        
        projDoc1=new IPM_Project_Document__c();
        projDoc1.IPM_GateDocuments__c='Contract'; 
        projDoc1.IPM_Project__c=project1.ID;
        projDoc1.IPM_Document_Status__c='Proposed';
        insert projDoc1;
        
        projDocSec1=new IPM_Project_Document_Section__c();
        projDocSec1.IPM_Project_Document__c=projDoc.ID;
        projDocSec1.IPM_Selected_Channel_Name__c='Ideas';  
        projDocSec1.IPM_Section_Sequence_Number__c='3.7';
        projDocSec1.IPM_Gate_Document_Summary__c='sfasdfsdafsdfsdfafadfdsf';
        insert projDocSec1;
        
       gate=new IPM_Gate_CMI__c();
       gate.Test__c='Test';
       gate.KPI__c='testkpi';
       gate.Gate__c='Contract';
       gate.IPM_Project__c=project.Id; 
        insert gate;
        
         pscon=new IPM_Project_Document_Section_Content__c();
        pscon.IPM_Project_Document_Section__c=projDocSec.Id;
        pscon.IPM_Gate_CMI__c=gate.Id; 
        insert pscon;
        
        cki=new IPM_Gate_CMI_KPI_Inputs__c(); 
        cki.IPM_Test__c='Test';
        cki.IPM_KPI__c='testkpi';
        cki.IPM_Inputs__c='Test Input1,Test Input2';
        cki.Name='settings1';
        insert cki;
       
        geo.ISO_Country_Dependency_Name__c='Uruguay'; 
        insert geo;
        
        con.IPM_Country_Name__c='Uruguay';
        con.geography__c=geo.id;
        con.IPM_Regional_Project__c=project1.Id; 
        insert con;
    }
    static testMethod void cmiControl()
    {
        initializeData();
        IPM_GateCMIContorller cmiControl=new IPM_GateCMIContorller();   
        
        cmiControl.projDocSecId=projDocSec.Id;
        cmiControl.secConId=pscon.Id;
        cmiControl.projectId=project.Id;
        cmiControl.getElements();
        cmiControl.getTests();
        cmiControl.projectId=con.IPM_Project__c;
        cmiControl.getCountries();
        cmiControl.getGates();
        cmiControl.cmiName='Charter/Test/Quant Pack test - PRS PackEval';
        cmiControl.gateCMIId=gate.Id;
        cmiControl.countryName='Bolivia,Uruguay';
        cmiControl.createCMISections();
        cmiControl.createCountryCMI();
        cmiControl.updateCMI();
        IPM_GateCMIContorller.copyCMISections(parentId,presentId,'Contract');
        cmiControl.createCountryCMI();
        cmiControl.deleteCountry();
       
        
    }
    static testMethod void cmiControl1()
    {
        initializeData();
        IPM_GateCMIContorller cmiControl1=new IPM_GateCMIContorller();   
        cmiControl1.projDocSecId=projDocSec.Id;
        cmiControl1.secConId=pscon.Id;
        cmiControl1.projectId=project.Id;
        cmiControl1.getElements();
        cmiControl1.getTests();
        cmiControl1.getCountries();
        cmiControl1.getGates();
        cmiControl1.cmiName='Charter/Test/Idea Screener - Nielsen';
        cmiControl1.countryName='Bolivia,Uruguay';
        cmiControl1.gateCMIId=gate.Id;
        cmiControl1.createCMISections();
        cmiControl1.updateCMI();
        cmiControl1.gateCMIId=gate.Id;
        cmiControl1.createCountryCMI();
        IPM_GateCMIContorller.copyCMISections(parentId,presentId,'Contract');
        cmiControl1.deleteCMI();
        cmiControl1.deleteCountry();
    }
    static testMethod void cmiControl2()
    {
        initializeData();
        IPM_GateCMIContorller cmiControl2=new IPM_GateCMIContorller();   
        cmiControl2.projDocSecId=projDocSec.Id;
        cmiControl2.secConId=pscon.Id;
        cmiControl2.projectId=project.Id;
        cmiControl2.getElements();
        cmiControl2.getTests();
        cmiControl2.getCountries();
        cmiControl2.getGates();
        cmiControl2.cmiName='Charter/Test/Snapshot - Nielsen';
        cmiControl2.countryName='Bolivia,Uruguay';
        cmiControl2.gateCMIId=gate.Id;
        cmiControl2.createCMISections();
        cmiControl2.createCountryCMI();
        cmiControl2.updateCMI();
        cmiControl2.gateCMIId=gate.Id;
        IPM_GateCMIContorller.copyCMISections(parentId,presentId,'Contract');
        cmiControl2.deleteCMI();
        cmiControl2.deleteCountry();
    }
    static testMethod void cmiControl3()
    {
        initializeData();
        IPM_GateCMIContorller cmiControl3=new IPM_GateCMIContorller();   
        cmiControl3.projDocSecId=projDocSec.Id;
        cmiControl3.secConId=pscon.Id;
        cmiControl3.projectId=project.Id;
        cmiControl3.getElements();
        cmiControl3.getTests();
        cmiControl3.getCountries();
        cmiControl3.getGates();
        cmiControl3.gateCMIId=gate.Id;
        cmiControl3.cmiName='Charter/Test/Innoscreen * ideas - Ipsos';
        cmiControl3.countryName='Bolivia,Uruguay';
        cmiControl3.createCMISections();
        cmiControl3.createCountryCMI();
        cmiControl3.updateCMI();
        cmiControl3.gateCMIId=gate.Id;
        IPM_GateCMIContorller.copyCMISections(parentId,presentId,'Contract');
        cmiControl3.deleteCMI();
        cmiControl3.deleteCountry();
    }
}