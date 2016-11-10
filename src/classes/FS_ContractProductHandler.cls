public class FS_ContractProductHandler {
    FS_ContractProductHelper helper = new FS_ContractProductHelper();
    public void createPlan (List<Contract_Product__c> newObjList){
        helper.createClaimedCases(newObjList);
    }
    public void updatePlan(List<Contract_Product__c> newObjList){
        helper.updateClaimedCases(newObjList);
    }
}