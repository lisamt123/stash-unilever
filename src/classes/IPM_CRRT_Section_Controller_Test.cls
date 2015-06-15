@isTest
public class IPM_CRRT_Section_Controller_Test 
{

    public static IPM_Project__c project;
    public static IPM_Project__c project1;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Document__c projDoc1;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Project_Document_Section__c projDocSec1;
    public static IPM_Project_Document_Section__c projDocSec2;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    public static List<IPM_Country__c> countryList;
    public static IPM_Country__c  con;
    public static IPM_Project_Document_Section_Content__c  pscon;
    public static IPM_Project_Document_Section_Content__c  pscon1;
    public static mdm_CU_Sales_SKU_Count_Mapping__c mdMapping;
    public static mdm_Consumer_unit__c cus;
    static testMethod void initializedData()
    { 
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Charter Gate Full';
        ipdt.IPM_Document_Type__c='Charter';
        insert ipdt;
        
        projTemp=new IPM_Project_Template__c();
        projTemp.IPM_Template_Complexity__c='Full';
        insert projTemp;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='3.2.1';
        secMst.IPM_Section_Name__c='Ideas';
        insert secMst;
        
        project=new IPM_Project__c();
        project.Name='TestGate';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        insert project;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Document_Status__c='Not Started';
        insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Gate_Document_Summary__c='dgadsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
        projDocSec.IPM_FunctionalRole__c='BD';
        projDocSec.IPM_Negotiable__c=false;
        projDocSec.IPM_Section_Sequence_Number__c='3.2.1';
        insert projDocSec;  
        
        pscon=new IPM_Project_Document_Section_Content__c();
        pscon.IPM_Project_Document_Section__c=projDocSec.Id;
        pscon.IPM_CU_Volume__c=22;
        insert pscon;
        
        mdm_Geography__c g=new mdm_Geography__c();
        g.ISO_Country_Dependency_Name__c='Test Country1';
        insert g;
        
        con=new IPM_Country__c();
        con.IPM_Project__c=project.Id;
        con.Geography__c=g.Id;
        insert con;
        
        countryList=new List<IPM_Country__c>();
        countryList=[Select Id,IPM_Project__c,Geography__c,Country_Name__c from IPM_Country__c where IPM_Project__c=:project.Id];
        
        cus=new mdm_Consumer_unit__c();
        insert cus;
        
        mdMapping=new mdm_CU_Sales_SKU_Count_Mapping__c();
        mdMapping.Country__c='Test Country1';
        mdMapping.CU_Volume__c=2343;
        mdMapping.CU_Code__c=cus.Id;
        mdMapping.Name='NameCU';
        insert mdMapping;
    }
    static testMethod void initializedData1()
    { 
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Contract Gate Full';
        ipdt.IPM_Document_Type__c='Contract';
        insert ipdt;
        
        projTemp=new IPM_Project_Template__c();
        projTemp.IPM_Template_Complexity__c='Full';
        insert projTemp;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='3.3.3';
        secMst.IPM_Section_Name__c='Ideas';
        insert secMst;
        
        project1=new IPM_Project__c();
        project1.Name='TestGate';
        project1.IPM_Phase__c='Charter';
        project1.IPM_Complexity__c='Full';
        insert project1;
        
        project=new IPM_Project__c();
        project.Name='TestGate';
        project.IPM_Phase__c='Feasibility';
        project.IPM_Complexity__c='Full';
        project.IPM_Parent_Project__c=project1.Id;
        insert project;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Contract'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Document_Status__c='Not Started';
        insert projDoc;   
        
        projDoc1=new IPM_Project_Document__c();
        projDoc1.IPM_GateDocuments__c='Charter'; 
        projDoc1.IPM_Project__c=project1.ID;
        projDoc1.IPM_Document_Status__c='Not Started';
        insert projDoc1;  
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Gate_Document_Summary__c='dgadsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
        projDocSec.IPM_FunctionalRole__c='BD';
        projDocSec.IPM_Negotiable__c=false;
        projDocSec.IPM_Section_Sequence_Number__c='3.3.3';
        insert projDocSec;  
        
        projDocSec1=new IPM_Project_Document_Section__c();
        projDocSec1.IPM_Project_Document__c=projDoc1.ID;
        projDocSec1.IPM_Section__c=secMst.Id;
        projDocSec1.IPM_Gate_Document_Summary__c='dgadsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
        projDocSec1.IPM_FunctionalRole__c='BD';
        projDocSec1.IPM_Negotiable__c=false;
        projDocSec1.IPM_Section_Sequence_Number__c='3.2.1';
        insert projDocSec1;
        
        projDocSec2=new IPM_Project_Document_Section__c();
        projDocSec2.IPM_Project_Document__c=projDoc.ID;
        projDocSec2.IPM_Section__c=secMst.Id;
        projDocSec2.IPM_Gate_Document_Summary__c='dgadsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
        projDocSec2.IPM_FunctionalRole__c='BD';
        projDocSec2.IPM_Negotiable__c=false;
        projDocSec2.IPM_Section_Sequence_Number__c='3.3.3';
        insert projDocSec2;
        
        pscon=new IPM_Project_Document_Section_Content__c();
        pscon.IPM_Project_Document_Section__c=projDocSec.Id;
        pscon.IPM_CU_Volume__c=22;
        insert pscon;
        
        pscon1=new IPM_Project_Document_Section_Content__c();
        pscon1.IPM_Project_Document_Section__c=projDocSec1.Id;
        pscon1.IPM_CU_Volume__c=22;
        insert pscon1;
        
        mdm_Geography__c g=new mdm_Geography__c();
        g.ISO_Country_Dependency_Name__c='Test Country';
        insert g;
        
        con=new IPM_Country__c();
        con.IPM_Project__c=project.Id;
        con.Geography__c=g.Id;
        insert con;
        
        countryList=new List<IPM_Country__c>();
        countryList=[Select Id,IPM_Project__c,Geography__c,Country_Name__c from IPM_Country__c where IPM_Project__c=:project.Id];
        
        cus=new mdm_Consumer_unit__c();
        insert cus;
        
        mdMapping=new mdm_CU_Sales_SKU_Count_Mapping__c();
        mdMapping.Country__c='Test Country';
        mdMapping.CU_Volume__c=2343;
        mdMapping.CU_Code__c=cus.Id;
        mdMapping.Name='NameCU';
        insert mdMapping;
    }
    static testMethod void crrtControl()
    {
        initializedData();
        IPM_CRRT_Section_Controller crrtControl=new IPM_CRRT_Section_Controller();
        crrtControl.projDocSecId=projDocSec.Id;
        IPM_CRRT_Section_Controller.createCRRTSections('Charter',countryList,'GCLT');
        crrtControl.conId=pscon.Id;
        crrtControl.projDocSec=projDocSec;
        crrtControl.updateCRRTStatus();
        crrtControl.createCRRTSection();
        crrtControl.projDocSecId=projDocSec.Id;
        crrtControl.showCountryUnitList();
        crrtControl.conId=pscon.Id;
        crrtControl.removeCRRTSection();
        crrtControl.filterNoChange();
        ApexPages.StandardController controller = new ApexPages.StandardController(project);
        Test.setCurrentPageReference(new PageReference('Page.IPM_GateDocument')); 
        System.currentPageReference().getParameters().put('id', project.Id); 
        IPM_GenericExtCtrl ge=new IPM_GenericExtCtrl(controller);
        ge.red();
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(project);
        Test.setCurrentPageReference(new PageReference('Page.IPM_GateDocument')); 
        System.currentPageReference().getParameters().put('id', projDoc.Id); 
        IPM_GenericExtCtrl ge1=new IPM_GenericExtCtrl(controller);
        ge1.red();
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(project);
        Test.setCurrentPageReference(new PageReference('Page.IPM_GateDocument')); 
        System.currentPageReference().getParameters().put('id', projDocSec.Id); 
        IPM_GenericExtCtrl ge2=new IPM_GenericExtCtrl(controller);
        ge2.red();
        
       
    }   
    static testMethod void crrtControl1()
    {
        initializedData1();
        IPM_CRRT_Section_Controller crrtControl1=new IPM_CRRT_Section_Controller();
        crrtControl1.projDocSecId=projDocSec.Id;
        IPM_CRRT_Section_Controller.createCRRTSections('Contract',countryList,'GCLT & RCLT');
        crrtControl1.conId=pscon.Id;
        crrtControl1.projDocSec=projDocSec;
        crrtControl1.updateCRRTStatus();
        crrtControl1.createCRRTSection();
        crrtControl1.projDocSecId=projDocSec.Id;
        crrtControl1.showCountryUnitList();
        IPM_CRRT_Section_Controller.deleteCRRTSection(countryList);
    }
    static testMethod void crrtControl2()
    {
        initializedData();
        initializedData1();
        IPM_CRRT_Section_Controller crrtControl1=new IPM_CRRT_Section_Controller();
        crrtControl1.projDocSecId=projDocSec.Id;
        IPM_CRRT_Section_Controller.createCRRTSections('Market Ready',countryList,'GCLT & RCLT');
        crrtControl1.conId=pscon.Id;
        crrtControl1.projDocSec=projDocSec;
        crrtControl1.updateCRRTStatus();
        crrtControl1.createCRRTSection();
        crrtControl1.projDocSecId=projDocSec.Id;
        crrtControl1.showCountryUnitList();
        //IPM_CRRT_Section_Controller.deleteCRRTSection(countryList);
        delete countryList;
        
    }   
}