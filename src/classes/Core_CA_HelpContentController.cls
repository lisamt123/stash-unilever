public with sharing class Core_CA_HelpContentController {

    public string  aribaURL {get; set;}  
    public string  gtesURL  {get; set;}  
    public string  aribaText {get; set;}  
    public string  gtesText  {get; set;}
    
    public void helpContentURL(){
        aribaURL = CORE_Chatter_Approval__c.getinstance('AribaHelpContentURL').Text_Value__c;
        gtesURL  = CORE_Chatter_Approval__c.getinstance('GtesHelpContentURL').Text_Value__c;
        aribaText = CORE_Chatter_Approval__c.getinstance('AribaHelpContent').Text_Value__c;
        gtesText = CORE_Chatter_Approval__c.getinstance('GtesHelpContent').Text_Value__c;
    }

}