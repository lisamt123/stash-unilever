public with sharing class Oblix_OuterPageTemplateController extends Oblix_SwopParentController {

	public String FXMessage {
        get{
            String TEXT_MESSAGE = Oblix_Utils.getOblixSettingValueByName('FX_TEXT_MESSAGE');
            String FX_TEXT_MESSAGE = TEXT_MESSAGE.replace('%date%', Oblix_Utils.getOblixSettingValueByName('FX_UPDATED_DATE'));
            return FX_TEXT_MESSAGE;
        }set;}

    public Boolean showFXMessage {get{
        String DateMsg = Oblix_Utils.getOblixSettingValueByName('FX_UPDATED_DATE');
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
        String FXDate = Oblix_Utils.getOblixSettingValueByName('FX_UPDATED_DATE');
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
            
            fxChange[0].FX_Date__c = Oblix_Utils.getOblixSettingValueByName('FX_UPDATED_DATE');
            fxChange[0].Acknowledged__c = true;
            update fxChange;
            
        }

    }

}