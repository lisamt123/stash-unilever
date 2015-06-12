@isTest(SeeAllData=true)
public class IPM_ProjectOverviewCtrl_Test
{
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Project_Resource__c projRes;
    public static IPM_Section__c secMst;
    public static IPM_Task__c tsk;
    public static IPM_Milestone__c mile;
    static void initializedData()
    { 
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Charter Full Gate';
        ipdt.IPM_Document_Type__c='Charter';
        insert ipdt;
        
        projTemp=new IPM_Project_Template__c();
        projTemp.IPM_Template_Complexity__c='Full';
        //insert projTemp;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='1.1';
        secMst.IPM_Section_Name__c='Ideas';
        insert secMst;
        
        project=new IPM_Project__c();
        project.Name='TestGate';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        project.IPM_Project_Leader__c=userinfo.getuserid();
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
        projDocSec.IPM_Section_Name__c='Section Name';
        projDocSec.IPM_FunctionalRole__c='BD';
        projDocSec.IPM_Negotiable__c=false;
        projDocSec.IPM_Section_Status__c='Not Started';
        insert projDocSec;  
        
        tsk=new IPM_Task__c();
        tsk.IPM_Project__c=project.Id;
        tsk.IPM_Project_Document_Section__c=projDocSec.Id;
        tsk.IPM_Completed__c=false;
        tsk.IPM_Task_Name__c='New task';
        insert tsk;
        
        mile=new IPM_Milestone__c();
        mile.IPM_Phase__c='Ideas';
        mile.IPM_Type_of_gate__c='Charter';
        mile.IPM_Project__c=project.Id;
        insert mile;
    }
    static testMethod void overControl()
    {
        initializedData();
        
        projDoc.IPM_Document_Status__c='In Progress';
        update projDoc;
        
        projDocSec.IPM_Gate_Document_Summary__c='dgasdfdaddsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
        projDocSec.IPM_FunctionalRole__c='CMI';
        projDocSec.IPM_Section_Name__c='Nameeeeee';
        update projDocSec;
        
        tsk.IPM_Task_Name__c='New task1';
        update tsk;
        
        Test.startTest();
        PageReference pRef1 = new PageReference('apex/ipmProjectOverview?Id='+project.ID);
        Test.setCurrentPage(pRef1);
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl();
        overCtrl.taskId=tsk.Id;
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        
        Test.stopTest();
    }
}