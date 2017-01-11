global class PQN_SendEmailtoDC_ClusterScheduler implements Schedulable {
  global void execute(SchedulableContext  sc) {
    PQN_SendEmailtoDC_ClusterBatch job = new PQN_SendEmailtoDC_ClusterBatch();
    Database.executebatch(job,100);
  }
}