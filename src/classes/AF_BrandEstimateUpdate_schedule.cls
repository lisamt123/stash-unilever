global class AF_BrandEstimateUpdate_schedule implements Schedulable{



global void execute(SchedulableContext  SC){
AF_BrandEstimateUpdate BradestiamteUpdate =new AF_BrandEstimateUpdate();
database.executebatch(BradestiamteUpdate,1);


}


}