/**
 * Name:        -   PACV_Questions_AnswerCreation
 * @description -   This is the Trigger for inserting PACV_Questions__c and PACV_Answers__c record. 
 * @Author      -   Deepika Gulati, Mindtree Ltd     
 */
trigger PACV_Questions_AnswerCreation on PACV_Questions__c (after insert) {
if(Label.PACV_Trigger_Switch.equalsIgnoreCase('True') &&  trigger.isInsert)
    {
        
        List<PACV_Answers__c> answersCreated = new List<PACV_Answers__c>();
        for(PACV_Questions__c question : Trigger.New)
        {
            try
            {    
                List<String> answers = new List<String>();
                if(question.PACV_Answers__c != null)
                {
                    
                  answers = question.PACV_Answers__c.split(';');
                    
                }
                List<String> scores = new List<String>();
              
                {
                    
                    scores = question.PACV_Scores__c.split(';');
                }
                if(answers.size() == scores.size())
                {
                    Pattern isnumbers = Pattern.Compile('^[-]?[0-9.]+$');
                    Matcher numberMatch;
                    for(integer i=0;i<answers.size();i++)
                    {
                        PACV_Answers__c answerRecord = new PACV_Answers__c();
                        answerRecord.Name = answers[i];
                        
                        numberMatch = isnumbers.matcher(scores[i]);
                        if(numberMatch.Matches())
                        {
                            answerRecord.PACV_Score_Value__c = Decimal.valueOf(scores[i]);
                            
                        }     
                        else
                        {
                            question.addError('Data Type mismatch. Please enter numeric values in Score field.');
                            break;
                        }
                        
                             
                        answerRecord.PACV_Question__c = question.Id;
                        answersCreated.add(answerRecord);
                    }
                 }
                 else
                 {
                       question.addError('There is a mismatch in the number of answer and score values. Please add a score corresponding to each answer.');  
                 }
                
            }
            catch(DMLException e)
            {
                question.addError(e.getMessage());
            }
            
        }
        
        
        if(answersCreated.size()>0)
            insert answersCreated;
    
       
    }

}