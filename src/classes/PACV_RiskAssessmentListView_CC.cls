/**
 * Name:        -   PACV_RiskAssessmentListView_CC
 * @Description -   This is the Controller for Display of Risk Assessments.On Click of Project Assessment Display of Questions and answers.Functionality for Save or Submit of Questions and answers in PACV_Response object 
 * @Author      -   Submit functionality by Chandru, Mindtree Ltd ; Save and Pagination functionality By Sibatri,Delegate Functionality By Sagar     
 */
public with sharing class PACV_RiskAssessmentListView_CC{ 

    public Id riskAssesmentId{get;set;}
    public string selectedTab{get;set;}
    public Set<Id> questionIdSet {get;set;}
    public static String selectedAns{get;set;}
    public String questionId{get;set;}
    public static List<PACV_Questions__c > questionList = new List<PACV_Questions__c >();
    public List<Question> questionWrapperList {get;set;} //= new List<Question>();//{get;set;} ;
    public static List<Question> questionWrapperListtemp = new List<Question>();//{get;set;} ;
    public ApexPages.StandardController stdController;
    public static Map<Id, List<String>> selectedAnswerMap {get;set;}
    public Boolean selected {get; set;}
    List<String> patternCheckResponse = new List<String>();//By sibatri
    List<PACV_Answers__c > ansId = new List<PACV_Answers__c >();//By sibatri
    public Integer completedCount{ get; set; }//By sibatri
    public Integer NotcompletedCount{ get; set; }//By sibatri
   integer totalRecs = 0;//By sibatri
   integer count= 0;//By sibatri
   integer limitSize= 5;//By sibatri
    public  Id responseId {get; set;}//By sibatri
   public boolean showStatus{ get; set; }//By sibatri
   public String id1 {get;set;}//By sibatri  
   
   // by sagar for Deleagte Popup Integration
    public Boolean displayPopup {get;set;}
    public string ExtUserEmail {get; set;}
    public List<User> UserTemp = new List<User>();    
    public string userid {get; set;}
    //public string QuestionID {get; set;}
    public String searchTerm {get; set;}
    public String selecteduser {get; set;}
 
   public void showPopup()
    {       
        //System.debug('user Name is: '+searchTerm );
        displayPopup = true;    
        QuestionID = Apexpages.currentPage().getParameters().get('QuestionID');
    }    
     
    public void closePopup() 
    {    
        selecteduser = '';
        displayPopup = false;    
    }   
    
    @RemoteAction
    public static List<User> searchuser(String searchTerm) {
        System.debug('user Name is: '+searchTerm );
        List<User> user = Database.query('SELECT Name,Id FROM User where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' Limit 20');        
        return user;
    }
    
      // Click on Save button in Delegate popup
    
    public Pagereference redirectPopup()
    {        
        //System.debug('Check this selected: ' +selecteduser);
       // System.debug('Check this exntuser: ' +ExtUserEmail);
        if(selecteduser == '' && ExtUserEmail == '')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Alteast Internal/External User'));
            return null;
        }
        else
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            if(selecteduser == '')
            {
                message.toAddresses = new String[] { ExtUserEmail , ExtUserEmail };                              
            }
            else
            {           
                User UserEmail = [SELECT Email FROM User where ID =: selecteduser LIMIT 1];
                string InternalUserEmail = UserEmail.Email;
                message.toAddresses = new String[] { InternalUserEmail , InternalUserEmail };
            }
            message.optOutPolicy = 'FILTER';
            message.subject = 'PACV Email test';
            message.plainTextBody = 'PACV Delegate Email Testing Mail.';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }   
            SaveDelegateData();
            selecteduser = '';
            ExtUserEmail = '';
            displayPopup = false;
            //PageReference p=new Pagereference('/apex/PACV_QuestionaireTabTest');
            //p.setRedirect(true);
            return null;        
        }
    } 
    
    // To save Delegated to and External user's email id into the object
    
    public void SaveDelegateData()
    {        
       
        PACV_Questions__c PACVQuestionToUpdate;
        try 
            {   
            PACVQuestionToUpdate = [SELECT Delegated_To_Email__c FROM PACV_Questions__c WHERE ID=: QuestionID LIMIT 1];
            PACVQuestionToUpdate.Delegated_To_Email__c = ExtUserEmail;
            update PACVQuestionToUpdate;
            } 
            catch(DmlException e) 
            {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
    }      
    
    // End of Delegate Functionality

   public PACV_RiskAssessmentListView_CC (ApexPages.StandardController controller) 
   { 
       this.stdController = stdController;
       totalRecs = [select count() from PACV_Risk_Assessment__c where PACV_Risk_Assessment__c.PACV_Status__c ='Not Completed'];
        NotcompletedCount=[SELECT count() FROM PACV_Risk_Assessment__c WHERE  PACV_Risk_Assessment__c.PACV_Status__c ='Not Completed'];
        completedCount =[SELECT count() FROM PACV_Risk_Assessment__c WHERE  PACV_Risk_Assessment__c.PACV_Status__c ='Completed']; 
        showStatus=true;
   }
    
    public PACV_RiskAssessmentListView_CC(){}
    
   /*to show list of Risk Assessments*/
    
   public List<PACV_Risk_Assessment__c> getResponseList() {
   List<PACV_Risk_Assessment__c> ResponseList=[SELECT OwnerID,CreatedById,Id,PACV_Project_Name__c,PACV_Project_End_Date__c,PACV_Project_Start_Date__c,PACV_Risk_Status__c,PACV_Solution_Name__c,PACV_Status__c,Name FROM PACV_Risk_Assessment__c WHERE  PACV_Risk_Assessment__c.PACV_Status__c ='Not Completed'  LIMIT:limitsize OFFSET:count];
    return ResponseList;
    }
 /* Risk Assessments List as pagination implementation*/
     public PageReference Firstbtn() {
     count=0;
        return null;
    }
     /* Risk Assessments List as pagination implementation*/
      public PageReference prvbtn() {
      count=count-limitsize;
        return null;
    }
    /* Risk Assessments List as pagination implementation*/
     public PageReference Nxtbtn() {
     count=count+limitsize;system.debug(count);
            return null;
        }
     /* Risk Assessments List as pagination implementation*/
     public PageReference lstbtn() {
     count= totalrecs - math.mod(totalRecs,LimitSize);
            return null;
        }

     /* Risk Assessments List as pagination implementation*/
    public Boolean getNxt() {
        if((count+ LimitSize) > totalRecs)
           return true;
         else
           return false;
    }
    /* Risk Assessments List as pagination implementation*/
     public Boolean getPrv() {
      if(count== 0)
          return true;
        else
          return false;
             }

    /* On Click Project Assessment Button List of Questions and Options will be displayed.Risk Assessment Id is passes with processLinkClick action */
     
    public PageReference processLinkClick(){ 
         id1 = system.CurrentPageReference().getParameters().get('id1');
         riskAssesmentId = id1;
         Set<Id> questionIdSet = new Set<Id>();
        
        questionWrapperList = new List<Question>();
         
        PACV_Risk_Assessment_Questionnaire__c questionnaire = [Select id, (Select id,PACV_Answering_Method__c,PACV_Question__c,PACV_Question_Status__c,PACV_Weightage__c from Questions__r)  from PACV_Risk_Assessment_Questionnaire__c where  PACV_Status__c =: 'Published' LIMIT 1];
        for(PACV_Questions__c question : questionnaire.Questions__r)
        {
            if(question.PACV_Question_Status__c == 'Activated')
                questionIdSet.add(question.Id);
        }
        // Map<Id, List<String>> selectedAnswerMap = new Map<Id, List<String>>();
       selectedAnswerMap = new Map<Id, List<String>>();
        questionList = [Select id,Name,PACV_Answering_Method__c,PACV_Question__c,PACV_Question_Status__c,PACV_Weightage__c, (Select id,Name, PACV_Score_Value__c,PACV_Question__c,PACV_Comments__c from Answers__r) from PACV_Questions__c where Id IN :questionIdSet and  PACV_Question_Status__c=:'Activated' ];
        Integer counter =0;
        List<PACV_Responses__c> responseDetail=[select Id,Name,PACV_Question__c,PACV_Answer__c from PACV_Responses__c where PACV_Risk_Assessment__r.Id =: riskAssesmentId ] ; 
      
        for(PACV_Questions__c question : questionList )
        {
            Question q  = new Question();
            q.questionValue = question.PACV_Question__c;
            q.Id = question.Id; //Question ID
            counter ++;
            q.qNo = counter;
            q.AnsweringMethod = question.PACV_Answering_Method__c;
           
            if(q.AnsweringMethod != null && q.AnsweringMethod != '')
            {
                if(q.AnsweringMethod.equalsIgnoreCase('Radio Button Objective Answering')){
                   q.singleSelect = true;
                }
                else if (q.AnsweringMethod.equalsIgnoreCase('Checkbox Objective Answering')){
                    q.multiSelect = true;
                }
            }
                
            q.answerIdMap= new Map<Id,Answer>();
            q.answerOptions = new List<SelectOption>();
            
            for(PACV_Answers__c answer : question.Answers__r)
            {
                Answer a = new Answer();
                a.Id = answer.Id;
                a.answerValue = answer.Name;
                a.score = answer.PACV_Score_Value__c;
                q.answerIdMap.put(a.Id,a);
                SelectOption so = new SelectOption(a.Id,a.answerValue);
               
                q.answerOptions.add(so);
                
            }
            //Code for Response by Sibatri for answer selection if a question is saved already
            
            for(Integer i=0;i<responseDetail.size();i++)
            {
              
              if(q.questionValue==responseDetail[i].PACV_Question__c)
               {
                   for(PACV_Answers__c answer : question.Answers__r)
                    {
                        if(q.singleSelect && answer.Name == responseDetail[i].PACV_Answer__c)
                        {
                            q.answerSelected = answer.Id;
                            break;                           
                        }
                        if(q.multiSelect )
                        {
                            boolean result = responseDetail[i].PACV_Answer__c.CONTAINS(answer.Name);  
                            if(result==true)
                            {
                                q.selectedAnswersList.add(answer.Id);
                               
                           }
                        }
                    }
                }
            }
            //Code End for Response by Sibatri
            questionWrapperList.add(q);
            questionWrapperListtemp.add(q);
        }
       showStatus = false;
        return null;
    
       }
        public class Question
    {
        public  boolean selected{get;set;}
        public  String Id{get;set;}
        public  integer qNo{get;set;}
        public  String questionValue{get;set;}
        public  String AnsweringMethod{get;set;}
        public  Boolean singleSelect{get;set;}
        public  Boolean multiSelect{get;set;}
        public  Map<Id,Answer> answerIdMap{get;set;}
        public  String answerSelected{get;set;}
        public  List<SelectOption> answerOptions{get;set;}
        public  List<String> selectedAnswersList{get;set;}
        public List<PACV_Responses__c> responseList{get;set;}
        public Question()
        {
            answerSelected = '';
            singleSelect = false;
            multiSelect = false;
            qNo = 0;
            selectedAnswersList = new List<String>();
            responseList = new List<PACV_Responses__c>();
            
        }
        
       public void setAnswerOptions(List<SelectOption> l)
        {
            answerOptions=l;
        }
        public List<SelectOption> getAnswerOptions()
        {
            return answerOptions;
        }
        
       public void setSelectedAnswersList(List<String> l)
        {
            selectedAnswersList=l;
        }
        public List<String> getSelectedAnswersList()
        {
            return selectedAnswersList;
        }
        
        public void setAnswerSelected(String l)
        {
            answerSelected=l;
        }
        public String getAnswerSelected()
        {
            return answerSelected;
        }
      
    }
   //  public void actionSave1(){
       // System.debug('Selected ans' + selectedAns);
   // }
    
    Public class Answer
    {
        public String answerValue;
        public Decimal score;
        public String Id;
    }
     
   /* public void showPopup() {  // commented by sagar      
        displayPopup = true;    
    } */
/*On click of Save button ,All the Questions and its answers will be saved in PACV_Response Object.If it is saved ,it can be updated next time */
    public Integer getResponseDetailFromQuestionValue(String questionValue)
    {
        List<PACV_Responses__c> responseDetail=[select Id,Name,PACV_Question__c,PACV_Answer__c from PACV_Responses__c where PACV_Risk_Assessment__r.Id =: riskAssesmentId ] ;
        for(Integer i=0;i<responseDetail.size();i++)
        {
            if(questionValue == responseDetail[i].PACV_Question__c)
            { 
                return i;
            }
        }  
        return -1;
    }
  /*On click of Save button ,All the Questions and its answers will be saved in PACV_Response Object.If it is saved ,it can be updated next time */
   public void saveQuestionAnswerResponseObj()
   {
        integer resIndex;
        showStatus=true;
       
        List<PACV_Responses__c> responseDetail=[select Id,Name,PACV_Question__c,PACV_Answer__c from PACV_Responses__c where PACV_Risk_Assessment__r.Id =: riskAssesmentId ] ; 
        List<PACV_Responses__c> ResListInsert= new List<PACV_Responses__c>();
        List<PACV_Responses__c> ResListUpdate= new List<PACV_Responses__c>();
      
        for(Question q :  questionWrapperList )
        {
            resIndex = getResponseDetailFromQuestionValue(q.questionValue);
            if(q.singleSelect && q.answerSelected != null && q.answerSelected != '')
            {
                if(q.answerIdMap.containsKey(String.valueOf(q.answerSelected )))
                {
                    PACV_Responses__c resp1= new PACV_Responses__c();
                    Answer ans = q.answerIdMap.get(q.answerSelected);
                    resp1.PACV_Question__c = q.questionValue;
                    resp1.PACV_Answer__c = ans.answerValue;
                    resp1.PACV_Score_Value__c = ans.score;
                    resp1.PACV_Risk_Assessment__c = riskAssesmentId;
                    
                    if(resIndex != -1)
                    {
                        resp1.id = responseDetail[resIndex].id;
                        ResListUpdate.add(resp1);
                    }
                    else
                    {
                        ResListInsert.add(resp1);
                    }
                }
            }
            else if(q.multiSelect && q.selectedAnswersList.size()>0)
            {
                PACV_Responses__c resp1= new PACV_Responses__c();
                resp1.PACV_Question__c = q.questionValue;
                resp1.PACV_Answer__c='';
                resp1.PACV_Score_Value__c = 0;
                resp1.PACV_Risk_Assessment__c = riskAssesmentId;
                
                for(String ans : q.selectedAnswersList)
                {
                    if(q.answerIdMap.containsKey(ans))
                    {
                        Answer a = q.answerIdMap.get(ans);
                        resp1.PACV_Answer__c +=  a.answerValue + ';';
                        resp1.PACV_Score_Value__c = resp1.PACV_Score_Value__c + a.score; 
                    }
                }
               
                 if(resIndex != -1)
                 {
                     resp1.id = responseDetail[resIndex].id;
                     ResListUpdate.add(resp1);
                 }
                 else 
                 {
                    ResListInsert.add(resp1);     
                 }
            }
            else if(q.multiSelect && q.selectedAnswersList.size() == 0)
            {
               if(resIndex != -1)
               {
                   delete responseDetail[resIndex];
               } 
            }  
       }
       
       if(ResListInsert.size()>0)
       {
           insert ResListInsert;
       }
       if(ResListUpdate.size()>0)
       {
           update ResListUpdate;
       }
    }
  /*On click of Submit button ,All the Questions and its answers will be saved in PACV_Response Object.Once it is saved ,it can not be updated next time */   
    public void submitQuestionAnswerResponseObj()
    {
       saveQuestionAnswerResponseObj(); 
        //Code to  Update the status of Risk Assessment
         PACV_Risk_Assessment__c riskAssessmentToUpdate;
             riskAssessmentToUpdate = [SELECT PACV_Status__c  FROM PACV_Risk_Assessment__c WHERE id =: riskAssesmentId]; 
            riskAssessmentToUpdate.PACV_Status__c = 'Completed';
            // Make the update call.
             update riskAssessmentToUpdate;
    }
    
}