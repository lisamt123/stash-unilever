global class CoreNTDeleteMPPDocsScheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
           CoreNTDeleteMPPDocsBatch b = new CoreNTDeleteMPPDocsBatch();
           database.executebatch(b,25);
        }
}