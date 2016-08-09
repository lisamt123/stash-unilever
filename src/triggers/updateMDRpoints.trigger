trigger updateMDRpoints on JE_Job_Evaluation__c (before insert) {
Map<String,JE_Points_Table__c> allCodes = JE_Points_Table__c.getAll();
list<JE_Points_Table__c> records = allCodes.values();
for(JE_Job_Evaluation__c je:trigger.new){
    for(JE_Points_Table__c jp:records){
        if(jp.Function__c== je.Job_Evaluation_Type__c && jp.Work_Level__c == je.WL_of_Line_Manager__c){
        je.Range_of_Salary_MDR_points__c = jp.Market_Data_Reference_Point__c;
        }
    }
}
}