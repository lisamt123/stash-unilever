@isTest

private class IPM_QuestionShare_Trigger_Test{
    
    public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static IPM_Project_Template__c projTemp; 
    public static IPM_Project_Document_Section__c projDocSec;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Section__c secMst;
    static void initializedData()
    { 
        
        projTempl=new IPM_Project_Template__c();
        projTempl.IPM_Template_Complexity__c='Full';
        insert projTempl;
        
        ipdt=new IPM_Document_Template__c();
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Contract';
        ipdt.IPM_Document_Type__c='Charter';
        insert ipdt;
        
        secMst=new IPM_Section__c();
        secMst.IPM_Document_Template__c=ipdt.ID;
        secMst.IPM_Section_Sequence__c='1.1';
        secMst.IPM_Section_Name__c='Ideas';
        insert secMst;
        
        
        project=new IPM_Project__c();
        project.Name='TestGate';
        project.IPM_Phase__c='Ideas';
        project.IPM_Complexity__c='Full';
        insert project;
        
        projTemp=new IPM_Project_Template__c();
        projTemp.IPM_Template_Complexity__c='Full';
        insert projTemp;
        
        projDoc=new IPM_Project_Document__c();
        projDoc.IPM_GateDocuments__c='Charter'; 
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Project_Template__c=projTemp.Id;
        insert projDoc;     
        
        projDocSec=new IPM_Project_Document_Section__c();
        projDocSec.IPM_Project_Document__c=projDoc.ID;
        projDocSec.IPM_Section__c=secMst.Id;
        projDocSec.IPM_Negotiable__c=true;
        insert projDocSec;  
        
    }
    

    static testmethod void testCreateIPMQuestionaire(){
    
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        initializedData();
        Test.startTest();
        User  u= testData.testRunAs();
        
        
        IPM_Questionnaire__c  quest= testData.createIPMQuestionaire(project); 
        IPM_Questionnaire__share  questShare = new IPM_Questionnaire__share  ();
        List<IPM_Questionnaire__share> listIPMQuestionaire = new List<IPM_Questionnaire__share>();
        
        
        questShare.ParentId= quest.Id;
        System.debug('*********'+ u.id);
        questShare.userOrGroupId =u.Id ;
        questShare.accesslevel = 'Edit';
        listIPMQuestionaire.add(questShare);
        
        //IPM_Questionnaire__share  questShareCopy = questShare;
        //delete questShare;
        
        //insert questShareCopy;
        
        try{

            insert listIPMQuestionaire;
            testData.createIPMProjectResource ('BD',project);
            IPM_Questionnaire__c ipmQuestionaire = testData.createIPMQuestionaire(project); 
        }
        
        catch(Exception e){
        
        
        }
        
        finally{

        }
        

        
        
        Test.stopTest();  
        
    
    }
    
    


}