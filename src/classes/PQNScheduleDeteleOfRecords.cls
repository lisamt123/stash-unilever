Global Class PQNScheduleDeteleOfRecords implements Schedulable{

    //This class will implements the Schedulable interface which is used a schedule a class 
    global void execute (SchedulableContext sc){
        
        //Create a instance of the batch class "PQNBatchDeleteRecords" 
        
        PQNBatchDeleteRecords bc = new PQNBatchDeleteRecords();
        database.executebatch(bc);
    }
}