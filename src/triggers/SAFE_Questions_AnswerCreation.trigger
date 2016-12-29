/**
 * Name:        -   SAFE_Questions_AnswerCreation
 * @description -   This is the Trigger for inserting SAFE_Questions__c and SAFE_Answers__c record. 
 * @Author      -   Deepika Gulati, Mindtree Ltd     
 */
trigger SAFE_Questions_AnswerCreation on SAFE_Questions__c (after insert) {
if(Label.SAFE_Trigger_Switch.equalsIgnoreCase('True') &&  trigger.isInsert)
    {
        
        List<SAFE_Answers__c> answersCreated = new List<SAFE_Answers__c>();
        for(SAFE_Questions__c question : Trigger.New)
        {
            try
            {    
                List<String> answers = new List<String>();
                if(question.SAFE_Answers__c != null)
                {
                    
                  answers = question.SAFE_Answers__c.split(';');
                    
                }
                List<String> scores = new List<String>();
              
                {
                    
                    scores = question.SAFE_Scores__c.split(';');
                }
                if(answers.size() == scores.size())
                {
                    Pattern isnumbers = Pattern.Compile('^[-]?[0-9.]+$');
                    Matcher numberMatch;
                    for(integer i=0;i<answers.size();i++)
                    {
                        SAFE_Answers__c answerRecord = new SAFE_Answers__c();
                        answerRecord.Name = answers[i];
                        
                        numberMatch = isnumbers.matcher(scores[i]);
                        if(numberMatch.Matches())
                        {
                            answerRecord.SAFE_Score_Value__c = Decimal.valueOf(scores[i]);
                            
                        }     
                        else
                        {
                            question.addError('Data Type mismatch. Please enter numeric values in Score field.');
                            break;
                        }
                        
                             
                        answerRecord.SAFE_Question__c = question.Id;
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
        
        
        if(answersCreated.size()>0 )system.debug('sibatri'+answersCreated);
            insert answersCreated;
    
       
    }

}