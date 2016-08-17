/*************************************************************************************************************************************************************
@ Class:          JE_UpdateMDRpointsHandler
@ Version:        1.0
@ Author:         vinod thupakula
@ Purpose:        Classs created for to get the market data reference point.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 09.08.2016 / vinod thupakula / Created the class.
**************************************************************************************************************************************************************/
public with sharing class JE_UpdateMDRpointsHandler{
    
    private Integer totalPoints = 0;
    private Integer penetrationPoint = 0;  
    
  /*@methodName- jobEvalutionsRecords
  *@description- method will return the JE points based on function & work level.
  *@param-  LIST
  *@return- LIST
  */ 
  public LIST<JE_Points_Table__c> jobEvalutionsRecords(list<JE_Job_Evaluation__c> jeJobs){
     try{
        LIST<JE_Points_Table__c> jePoints = new LIST<JE_Points_Table__c>();
        MAP<String,JE_Points_Table__c> allCodes = JE_Points_Table__c.getAll();         
        for(JE_Job_Evaluation__c jobEvalution:jeJobs){
            for(JE_Points_Table__c jePoint:allCodes.values()){
                if(jobEvalution.Job_Evaluation_Type__c.equalsIgnoreCase(jePoint.Function__c)
                    && jobEvalution.WL_of_Line_Manager__c.equalsIgnoreCase(jePoint.Work_Level__c)){                          
                    totalPoints =  (Integer)jobEvalution.Overall_Total_Score__c;                         
                    jePoints.add(jePoint);
                }
            }                    
        }
        return jePoints;
     }
     catch(Exception exceptionNull){
        System.debug('Exception :' + exceptionNull.getMessage());
        return null;
     }   
   }
  /*@methodName- determineMdrPoints
   *@description- Method will return market data reference point based on Min & Max values.
   *@param- LIST 
   *@return- Integer
   */     
   public Integer determineMdrPoints(LIST<JE_Points_Table__c> jePoints){
      try{         
         Integer mdrPoints = 0;                 
         for(JE_Points_Table__c jPoint:jePoints){
             if(jPoint.Min__c<=totalPoints && jPoint.Max__c>=totalPoints ){
                 mdrPoints = (Integer)jPoint.Market_Data_Reference_Point__c;
                 penetrationPoint = (Integer)(((totalPoints-jPoint.Min__c)/(jPoint.Max__c-jPoint.Min__c))*100);                  
             }
         }                  
         return mdrPoints; 
      }
      catch(Exception exceptionNull){
        System.debug('Exception :' + exceptionNull.getMessage());
        return null;
     } 
   }
  /*@methodName- updateJeEvalution
   *@description- Method will update the market data reference point.
   *@param- LIST,Integer 
   *@return- none
   */   
   public void updateJeEvalution(list<JE_Job_Evaluation__c> jeJobs,Integer mdrPoint){      
      try{       
           Integer max_mdrpoints = 0;
           Integer min_mdrpoints = 0;  
           Integer max_paypoint  = 0;
           Integer min_paypoint  = 0;               
                   max_mdrpoints = mdrPoint+15;
                   min_mdrpoints = mdrPoint-15;
                   max_paypoint = penetrationPoint+105;
                   min_paypoint = penetrationPoint+95;
                   LIST<JE_Job_Evaluation__c> mappedJeEvalution = new LIST<JE_Job_Evaluation__c>();              
                        for(JE_Job_Evaluation__c je:[select id,Market_Data_Reference_Point__c from JE_Job_Evaluation__c where id=:jeJobs[0].id]){    
                           je.Market_Data_Reference_Point__c = mdrPoint;
                           je.Penetration_Total_Points__c = penetrationPoint;
                               if(max_mdrpoints<=200 && min_mdrpoints>=100){ 
                                   je.Range_of_salary__c = min_mdrpoints +Label.JE_Notation+max_mdrpoints+Label.JE_NotationTwo;                       
                                }
                               else{ 
                                   je.Range_of_salary__c = Label.JE_Salary_Range_Error+min_mdrpoints +Label.JE_Notation+max_mdrpoints+Label.JE_NotationTwo;                             
                               }
                               if(max_paypoint<=200 && min_paypoint>=100){ 
                                   je.Paypoint_Based_on_Range_Penetration__c = min_paypoint+Label.JE_Notation+max_paypoint+Label.JE_NotationTwo;                       
                                }
                               else{ 
                                   je.Paypoint_Based_on_Range_Penetration__c = Label.JE_Penetration_Range_Error+min_paypoint+Label.JE_Notation+max_paypoint+Label.JE_NotationTwo;                             
                               }                               
                        mappedJeEvalution.add(je);    
                        }
                        if(jeJobs[0].Overall_Total_Score__c != null && jeJobs[0].Overall_Total_Score__c != 0){
                            JE_UtilRecursiveCtrl.isupdateRecord = false;  
                        }              
               Database.update(mappedJeEvalution);                
      }
      catch(Exception exceptionDml){
           System.debug('Exception :' + exceptionDml.getMessage());        
     } 
   }
}