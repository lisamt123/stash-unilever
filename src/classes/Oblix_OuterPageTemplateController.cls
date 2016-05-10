public with sharing class Oblix_OuterPageTemplateController extends Oblix_SwopParentController {

	public String FXMessage {
        get{
            Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Date fxDate = orgDate.Org_FX_Date__c;
            String TEXT_MESSAGE = Oblix_Utils.getOblixSettingValueByName('FX_TEXT_MESSAGE');
            String FX_TEXT_MESSAGE = TEXT_MESSAGE.replace('%date%', Oblix_Utils.toLocaleDate(fxDate));
            return FX_TEXT_MESSAGE;
        }set;}

    public Boolean showFXMessage {get{
        Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
        Date fxDate = orgDate.Org_FX_Date__c;
        String DateMsg = string.valueof(fxDate);
        List<Oblix_FX_Change__c> fxChange = [SELECT Id, FX_Date__c, Acknowledged__c FROM Oblix_FX_Change__c WHERE SetupOwnerId = :UserInfo.getUserId() AND FX_Date__c =: DateMsg];
        if(fxChange.isEmpty() && 
            (Oblix_PermissionHandler.hasUL1permissionSet() || Oblix_PermissionHandler.hasUL2permissionSet() 
                    || Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin())){
            return true;
        }else{
            return false;
        }
    } set;}

	public Oblix_OuterPageTemplateController() {
		
	}

	public void updateFX(){
        Date csDate;
        Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
        if(orgDate != null){
            if(orgDate.Org_FX_Date__c != null)
                csDate = orgDate.Org_FX_Date__c;
        }else{
            Oblix_FX_Change__c newObOrg = new Oblix_FX_Change__c(SetupOwnerId = UserInfo.getOrganizationId(),
                                                                Org_FX_Date__c = date.today(),
                                                                Acknowledged__c = true);
            insert newObOrg;
        }
        String FXDate = string.valueof(csDate);
        List<Oblix_FX_Change__c> fxChange = [SELECT Id, FX_Date__c, Acknowledged__c FROM Oblix_FX_Change__c WHERE SetupOwnerId = :UserInfo.getUserId()];
        if(fxChange.isEmpty()){
            Oblix_FX_Change__c newOb = new Oblix_FX_Change__c(SetupOwnerId = UserInfo.getUserId(),
                                                            FX_Date__c = '01/01/2000',
                                                            Acknowledged__c = true);
            insert newOb;

        }
        fxChange = [SELECT Id, FX_Date__c, Acknowledged__c FROM Oblix_FX_Change__c WHERE SetupOwnerId = :UserInfo.getUserId()];
        if(FXDate != fxChange[0].FX_Date__c && 
            (Oblix_PermissionHandler.hasUL1permissionSet() || Oblix_PermissionHandler.hasUL2permissionSet() 
                    || Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin())){
            
            fxChange[0].FX_Date__c = FXDate;
            fxChange[0].Acknowledged__c = true;
            update fxChange;
            
        }

    }

}