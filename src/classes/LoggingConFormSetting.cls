public class LoggingConFormSetting {
    
    Amr_Logging_Form_Setting__c r  {get; set;}
    
    public void LoggingConFormSetting() {
        r = [SELECT Introduction__c, Header__c, Footer__c FROM Amr_Logging_Form_Setting__c LIMIT 1];
    }

    public Amr_Logging_Form_Setting__c getSetting(){
        return r;
    }

 }