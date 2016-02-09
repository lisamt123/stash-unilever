trigger SOWProjectBusinessValueDriverScore on Oblix_SOW_Projects__c (before insert, before update) {
    //if(project.Brand_Led_Growth__c != null || project.Innovation_Projects__c != null || project.Project_Scale_1__c != null || project.Project_Scale_2__c != null || project.Campaign_Idea__c != null){
        TriggerFactory.createHandler(Oblix_SOW_Projects__c.sObjectType);
   
}