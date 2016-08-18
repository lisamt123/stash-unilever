@isTest
public class JE_TestFactory{
public static void JE_Points_Insertion(Integer i){
    JE_Points_Table__c  jePoints = new JE_Points_Table__c();   
                    jePoints.Function__c = 'Brand Building';
                    jePoints.Market_Data_Reference_Point__c= 140;
                    jePoints.Max__c= 50+i;
                    jePoints.Min__c= i-1;
                    jePoints.Work_Level__c ='WL2';
                    jePoints.Name = 'first'+i;      
    Database.insert(jePoints);     
}
public static LIST<JE_Job_Evaluation__c> JE_Job_Insertion(Integer i){
    JE_Job_Evaluation__c je = new JE_Job_Evaluation__c();
    LIST<JE_Job_Evaluation__c> allJobs = new LIST<JE_Job_Evaluation__c>();
        for(Integer k = 1;k<=i;k++){
            je.CurrencyIsoCode = 'EUR';
            je.Name = 'test'+i;
            je.Job_Grade_of_Line_Manager__c = 'WL1';
            je.WL_of_Line_Manager__c = 'WL2';
            je.Job_Evaluation_Type__c ='Brand Building';
            allJobs.add(je);
        }    
     Database.insert(allJobs);
     return allJobs;
} 
}