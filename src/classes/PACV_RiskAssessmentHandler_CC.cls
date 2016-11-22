public with sharing class PACV_RiskAssessmentHandler_CC {
  
    public Id riskAssesmentId {get;set;}
    public Set<Id> questionIdSet {get;set;}
    public String selectedAns{get;set;}
    public String questionId{get;set;}
    List<PACV_Questions__c > questionList = new List<PACV_Questions__c >();
    public List<Question> questionWrapperList {get;set;}
    public ApexPages.StandardController stdController;
    public Map<Id, List<String>> selectedAnswerMap {get;set;}
    
    
    public PACV_RiskAssessmentHandler_CC (ApexPages.StandardController controller) 
    {
        this.stdController = stdController;
        riskAssesmentId = Apexpages.currentPage().getParameters().get('id');
        questionIdSet = new Set<Id>();
        PACV_Risk_Assessment_Questionnaire__c questionnaire = [Select id, (Select id,PACV_Answering_Method__c,PACV_Question__c,PACV_Question_Status__c,PACV_Weightage__c from Questions__r)  from PACV_Risk_Assessment_Questionnaire__c where  PACV_Status__c =: 'Published' LIMIT 1];
        for(PACV_Questions__c question : questionnaire.Questions__r)
        {
            if(question.PACV_Question_Status__c == 'Activated')
                questionIdSet.add(question.Id);
            
        }
        
        selectedAnswerMap = new Map<Id, List<String>>();
        questionList = [Select id,Name,PACV_Answering_Method__c,PACV_Question__c,PACV_Question_Status__c,PACV_Weightage__c, (Select id,Name, PACV_Score_Value__c,PACV_Question__c,PACV_Comments__c from Answers__r) from PACV_Questions__c where Id IN :questionIdSet and  PACV_Question_Status__c=:'Activated' ];
        

    }
    
    public void mapQuestionAnswerList()
    {
        
        //system.debug(' In block :mapQuestionAnswerList()');
        questionWrapperList = new List<Question>();
        Integer counter =0;
        for(PACV_Questions__c question : questionList )
        {
            Question q  = new Question();
            q.questionValue = question.PACV_Question__c;
            q.Id = question.Id;
            counter ++;
            q.qNo = counter;
            q.AnsweringMethod = question.PACV_Answering_Method__c;
            if(q.AnsweringMethod != null && q.AnsweringMethod != '')
            {
               if(q.AnsweringMethod.equalsIgnoreCase('Radio Button Objective Answering'))
                   q.singleSelect = true;
               else if(q.AnsweringMethod.equalsIgnoreCase('Checkbox Objective Answering'))
                    q.multiSelect = true;
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
                System.debug('mapQuestionAnswerList: SlectOption -- '+ so);
                q.answerOptions.add(so);
                
            }
            system.debug('Question ' + q);
            questionWrapperList.add(q);
        }
        System.debug('Question Wrapper List' + questionWrapperList);
        //saveQuestionAnswerResponseObj(questionWrapperList);
        
    }
    
    public void actionSave1(){
        System.debug('Selected ans' + selectedAns);
    }
    
    
    
    public class Question
    {
        public String Id{get;set;}
        public integer qNo{get;set;}
        public String questionValue{get;set;}
        public String AnsweringMethod{get;set;}
        public Boolean singleSelect{get;set;}
        public Boolean multiSelect{get;set;}
        public Map<Id,Answer> answerIdMap{get;set;}
        public String answerSelected{get;set;}
        public List<SelectOption> answerOptions{get;set;}
        public List<String> selectedAnswersList{get;set;}
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
    
    Public class Answer
    {
        public String answerValue;
        public Decimal score;
        public String Id;
    }
    
   
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public void saveQuestionAnswerResponseObj()
    {
            
        
        //throw new NullPointerException();
        List<PACV_Responses__c> ResList= new List<PACV_Responses__c>();
        System.debug('selectedAnswerMap' + selectedAnswerMap);
        System.debug('SelectedAns' + selectedAns);
        System.debug('questionWrapperList '+questionWrapperList );
        for(Question q :  questionWrapperList )
        {
            System.debug('q.singleSelect ' + q.singleSelect);
            System.debug('q.Multiselect' + q.multiSelect);
            System.debug('q.answerSelected' + q.answerSelected);
            System.debug('q.selectedAnswersList' + q.selectedAnswersList);
            
            
            
            //if(q.answerSelected!=null)
            if(q.singleSelect)
            {
                if(q.answerSelected != null && q.answerSelected != '')
                {
                    String answerSelectd = q.answerSelected;
                  
                   
                    if(q.answerIdMap.containsKey(String.valueOf(answerSelectd )))
                    {
                        PACV_Responses__c resp1= new PACV_Responses__c();
                        Answer ans = q.answerIdMap.get(answerSelectd);
                        resp1.PACV_Question__c = q.questionValue;
                        resp1.PACV_Answer__c = ans.answerValue;
                        resp1.PACV_Score_Value__c = ans.score;
                        resp1.PACV_Risk_Assessment__c = riskAssesmentId;
           
                        ResList.add(resp1);
                        
                                       // system.debug('dummy value');
    
                        System.debug('q.singleSelect =' + q.singleSelect);
                      System.debug('resp1 object' + resp1);
                    }
                }
                   
            }
            
            
           if(q.multiSelect && q.selectedAnswersList.size()>0)
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
                System.debug('q.multiSelect =' + q.multiSelect );
                System.debug('resp1 object' + resp1);
                ResList.add(resp1);
            }
        }
        System.debug('ResList'+ ResList);
        
        if(ResList.size()>0){
        System.debug('Demo');
        insert ResList;

        }
        
                displayPopup = false;     
    }
  
 
}