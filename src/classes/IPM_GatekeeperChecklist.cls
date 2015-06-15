public class IPM_GatekeeperChecklist
{

    public static list<IPM_Questionnaire__c> gkChecklist{get;set;}
    public static  ID recTypeGK {get;set;}

    public static  ID recTypeRnD {get;set;}
    public static list<IPM_Questionnaire__c> rndQuesList{get;set;}
    
    public IPM_Questionnaire__c gkCheck{get; set;}
    public Id quesId{get; set;}
    public string comment{get; set;}
    public string ans{get; set;}
    public boolean cmts{get;set;}
    public Boolean isEditable{get;set;}
    public string gateType{ 
        get {
            return gateType ;
        }
        set {
            gateType = value;
            getGKChecklist();
            
        }}
    //created to reduce number of Queries   
    public string gateTypeRND{ 
        get {
            return gateType ;
        }
        set {
            gateTypeRND = value;
           getrndChecklist();
        }}
    
    
    
    public boolean editTable{ 
        get {
            return editTable;
        }
        set {
            editTable= value;
            //getGKChecklist();
        }}
    
    public ID projectID{get;set;} //Project Id
    
    public ID SecId{ 
        get {
            return SecId;
        }
        set {
            SecId= value;
            getSectioWiseGKChecklist();
        }}// document Section Id
    
    public IPM_Project_Document_Section__c  projDocSec {get;set;}
    public static list<IPM_Questionnaire__c> gkC= new list<IPM_Questionnaire__c>();
    public static list<IPM_Questionnaire__c> rndQ= new list<IPM_Questionnaire__c>();
    

    public static List<IPM_Project_Document_Section__c>  projDocSeclist {get;set;}
    
    //constructor
    
    public IPM_GatekeeperChecklist()
    {
        projectID=ApexPages.currentPage().getParameters().get('Id'); 
        // projDocSecId=ApexPages.currentPage().getParameters().get('projDocSecId');
        
       // getGKChecklist();
       // getrndChecklist();
        System.debug('Number of Queries used in this Apex code so far: ' + Limits.getQueries());
        // generateRnDQuestion();
        /*   if(SecId!=null || SecId!='')
    {
        getSectioWiseGKChecklist();
    }*/
    }
    //generate GK checklist for Gate Document call from trigger
    public static void generateGKChecklist(String gateType,List<Id> projectIDs)
    {
        recTypeGK =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
        Set<Id> projectID=new Set<Id>();
        for(Id i:projectIDs)
        {
            projectID.add(i);
        }
        System.debug(projectID+'projectID');
        gkChecklist=[Select IPM_Question__c,IPM_Project_Document_Section__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_Partly__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,RecordTypeId,IPM_Project__c from IPM_Questionnaire__c where IPM_Project__c='' and IPM_RQS_Gate_Type__c=:gateType and RecordTypeId=:recTypeGK and Is_Master__c=true];
        System.debug(gkChecklist+'gkChecklist');
        if(gkChecklist.size()>0)
        {
            for(Integer i=0;i<projectIDs.size();i++)
            {
                for(IPM_Questionnaire__c gkQ : gkChecklist)
                {
                    IPM_Questionnaire__c tempGKQ= new IPM_Questionnaire__c();
                    tempGKQ.IPM_Project__c=projectIDs[i];
                    tempGKQ.IPM_Question_Help_Text__c=gkQ.IPM_Question_Help_Text__c;
                    tempGKQ.IPM_HelpText_Yes__c=gkQ.IPM_HelpText_Yes__c;
                    tempGKQ.IPM_HelpText_Partly__c=gkQ.IPM_HelpText_Partly__c;
                    tempGKQ.IPM_HelpText_No__c=gkQ.IPM_HelpText_No__c;              
                    tempGKQ.IPM_Question__c=gkQ.IPM_Question__c;
                    tempGKQ.IPM_RQS_Gate_Type__c=gateType;
                    tempGKQ.IPM_GK_Answers__c=gkQ.IPM_GK_Answers__c;
                    tempGKQ.RecordTypeId=recTypeGK;
                    tempGKQ.IPM_Sequence_Number__c=gkQ.IPM_Sequence_Number__c;
                    tempGKQ.IPM_Section_Sequence_Number__c=gkQ.IPM_Section_Sequence_Number__c;  
                    gkC.add(tempGKQ);
                }
            }
            if (gkC.isEmpty() == false) 
            {
                try 
                {
                    insert gkC;
                    System.debug(gkC+'gkC');
                    updateSectionGKChecklist(gateType,projectID);
                    generateRnDQuestion(gateType,projectIDs);
                } 
                catch (DmlException e) {
                    // Process exception here
                }
            }
        }
        // generateRnDQuestion(projectID);
    }
    public static void updateSectionGKChecklist(String gateType,Set<Id> projectID)
    {
        List<IPM_Questionnaire__c> gkQuestions=new List<IPM_Questionnaire__c>();
        recTypeGK =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
        gkQuestions=[Select IPM_Question__c,IPM_Project_Document_Section__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_Partly__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,RecordTypeId,IPM_Project__c from IPM_Questionnaire__c where IPM_Project__c In: projectID and IPM_RQS_Gate_Type__c=:gateType and RecordTypeId=:recTypeGK];
        projDocSeclist=[Select ID,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__r.IPM_Project__c from IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c In:projectID and IPM_Project_Document__r.IPM_GateDocuments__c=:gateType];
        for(IPM_Project_Document_Section__c pds:projDocSeclist)
        {
            for(Integer i=0;i<gkQuestions.size();i++)
            {
                if(gkQuestions[i].IPM_Project__c==pds.IPM_Project_Document__r.IPM_Project__c && gkQuestions[i].IPM_Section_Sequence_Number__c==pds.IPM_Section_Sequence__c)
                {
                    gkQuestions[i].IPM_Project_Document_Section__c=pds.Id;
                }
            }
        }
        update gkQuestions;
        System.debug('Updated gkQuestions'+gkQuestions);
    }
    
    // List the questions in the gate document edit page
    public void getGKChecklist()
    {
        recTypeGK =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('GateKeeperChecklist').RecordTypeId;
        
        // projDocSec=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c from IPM_Project_Document_Section__c where Id=:projDocSecId];

        gkChecklist=[Select ID,IPM_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_Partly__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,IPM_Comments__c ,IPM_Project__c,RecordTypeId,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Section_Name__c from IPM_Questionnaire__c where IPM_RQS_Gate_Type__c=:gateType and RecordTypeId=:recTypeGK and IPM_Project__c=:projectID ORDER BY IPM_Sequence_Number__c ASC ];
        
    }
    
    
    // to update the Answers and Comments in the gate keeper Checklist
    public pageReference updateGKchecklist()
    {
        System.debug(quesId+'id...........');
        gkCheck=[Select ID,IPM_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_Partly__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,IPM_Comments__c ,IPM_Project__c,RecordTypeId from IPM_Questionnaire__c where Id=:quesId];
        if(cmts==false)
        gkCheck.IPM_GK_Answers__c=ans;
        if(cmts==true)
        gkCheck.IPM_Comments__c =comment;
        update gkCheck;
        //getGKChecklist();
        //gkChecklist=[Select ID,IPM_Question__c,IPM_Question_Help_Text__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,IPM_Comments__c ,IPM_Project__c,RecordTypeId from IPM_Questionnaire__c where IPM_RQS_Gate_Type__c=:gateType and RecordTypeId=:recTypeGK and IPM_Project__c=:projectID ORDER BY IPM_Sequence_Number__c ASC ];
        return null;
    }


    // to fetch section wise gatekeeper question

    public void getSectioWiseGKChecklist()
    {
        system.debug('documetn section id'+SecId);
        projDocSec=[Select Id,IPM_Section_Sequence__c from IPM_Project_Document_Section__c where Id=:SecId];
        getGKChecklist();
    }
    
    
    // Function to generate question for the RnD section 5.1
    public static void generateRnDQuestion(String gateType,List<Id> projectIDs)
    {
        recTypeRnD =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RNDQuestion').RecordTypeId;
        Set<Id> projectID=new Set<Id>();
        for(Id i:projectIDs)
        {
            projectID.add(i);
        }
        rndQuesList=[Select IPM_Question__c,IPM_RQS_Gate_Type__c,IPM_GK_Answers__c,RecordTypeId,IPM_Project__c from IPM_Questionnaire__c where IPM_Project__c='' and RecordTypeId=:recTypeRnD and Is_Master__c=true];
        
        if(rndQuesList.size()>0)
        {
            for(Integer i=0;i<projectIDs.size();i++)
            {
            for(IPM_Questionnaire__c rndQu : rndQuesList)
            {
                IPM_Questionnaire__c temprdQ= new IPM_Questionnaire__c();
                temprdQ.IPM_Project__c=projectIDs[i];
                temprdQ.IPM_Question__c=rndQu.IPM_Question__c;
                temprdQ.IPM_GK_Answers__c=rndQu.IPM_GK_Answers__c;
                temprdQ.RecordTypeId=recTypeRnD;
                rndQ.add(temprdQ);
            }
            }
            if (rndQ.isEmpty() == false) {
                try {
                    insert rndQ;
                } 
                catch (DmlException e) {
                    // Process exception here
                }
                
            }
        }
    }
    
    //get Rnd Question List
    public void getrndChecklist()
    {
        recTypeRnD =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RNDQuestion').RecordTypeId;
        system.debug('I am here insid RND'+projectID);
        // projDocSec=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c from IPM_Project_Document_Section__c where Id=:projDocSecId];

        rndQuesList=[Select ID,IPM_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,IPM_Comments__c ,IPM_Project__c,RecordTypeId from IPM_Questionnaire__c where RecordTypeId=:recTypeRnD and IPM_Project__c=:projectID];
        
    }
    

}