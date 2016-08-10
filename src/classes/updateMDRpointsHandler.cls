/*************************************************************************************************************************************************************
@ Class:          updateMDRpointsHandler
@ Version:        1.0
@ Author:         vinod thupakula
@ Purpose:        Classs created for to get the market data reference point.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 09.08.2016 / vinod thupakula / Created the class.
**************************************************************************************************************************************************************/
public class updateMDRpointsHandler{
    
    private Integer totalPoints = 0;
    
  /*@methodName- jobEvalutionsRecords
  *@description- method will return the JE points based on function & work level
  *@param-  LIST
  *@return- LIST
  */ 
  public LIST<JE_Points_Table__c> jobEvalutionsRecords(list<JE_Job_Evaluation__c> jeJobs){
            LIST<JE_Points_Table__c> jePoints = new LIST<JE_Points_Table__c>();
            MAP<String,JE_Points_Table__c> allCodes = JE_Points_Table__c.getAll();
            LIST<JE_Points_Table__c> mdrPoints= allCodes.values();
            for(JE_Job_Evaluation__c jobEvalution:jeJobs){
                for(JE_Points_Table__c jePoint:mdrPoints){
                    if(jobEvalution.Job_Evaluation_Type__c.equalsIgnoreCase(jePoint.Function__c)
                        && jobEvalution.WL_of_Line_Manager__c.equalsIgnoreCase(jePoint.Work_Level__c)){
                        totalPoints =  (Integer)jobEvalution.Overall_Total_Score__c;
                        jePoints.add(jePoint);
                    }
                }
                    
            }
         return jePoints;   
   }
  /*@methodName- determineMdrPoints
   *@description- Method will return market data reference point based on Min & Max values
   *@param- LIST 
   *@return- Integer
   */     
   public Integer determineMdrPoints(LIST<JE_Points_Table__c> jePoints){
         Integer mdrPoints = null;
         for(JE_Points_Table__c jPoint:jePoints){
             if(jPoint.Min__c<=totalPoints && jPoint.Max__c>=totalPoints ){
                 mdrPoints = (Integer)jPoint.Market_Data_Reference_Point__c;
             }
         }  
         return mdrPoints; 
   }
}