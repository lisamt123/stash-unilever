global class TEL_SalesCallCreationScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        TEL_OpportunitySalesCallCreation.getInstance().createOpportunities();
    }
}