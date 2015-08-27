/**********************************************************************
 Name:  cec_EmailMessageHelper
 Copyright ? 2014  Unilever
 ======================================================
======================================================
Purpose:  for EmailMessageHleper                                                    
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Aalokkumar       19/09/2014       INITIAL DEVELOPMENT     Email Message
   1.1 -   Pavan Kumar      09/02/2015       CR                      Email Message  
****************************************************************************/
public class cec_EmailMessageHelper{

Map<String, cec_Case_Brand_Mapping__c> incomingEmailAddresses = new Map<String, cec_Case_Brand_Mapping__c>();
List<Case> casesToUpdate = new List<Case>();
Boolean caseAssociated=false;
    public void emailMessage(List<EmailMessage> emList){
    
    // Get list of all branded emails
    Set<String> brandEmailSet = new Set<String>();
    List<cec_Case_Brand_Mapping__c> defaultBrandEmailList = [Select Brand_Market__c,skill__c,Country__c,Inbound_Email__c,Brand__c From cec_Case_Brand_Mapping__c where Inbound_Email__c!=null and Inbound_Email__c='unknown@unilever.com' limit 1];
    List<cec_Case_Brand_Mapping__c> branEmailList = [Select Inbound_Email__c,skill__c,Country__c From cec_Case_Brand_Mapping__c where Inbound_Email__c!=null and Inbound_Email__c!='unknown@unilever.com'];
    for(cec_Case_Brand_Mapping__c cbr: branEmailList){
        brandEmailSet.add(cbr.Inbound_Email__c);
    }
    
    for (EmailMessage em : emList) {
            
        System.debug('Inserting the email message: ' + em);                   
        System.debug('Parent Id is ' + em.ParentId);

        if (em.Incoming) {
            // Get the first occurrence of branded email from the To list
            String[] toEmail = em.ToAddress.split(';');
            System.debug('To Email Addresses:: '+toEmail);
            for(Integer i=0; i < toEmail.size(); i++){
                if(brandEmailSet.contains(toEmail[i].trim())){
                    incomingEmailAddresses.put(toEmail[i].trim(), null);
                    System.debug('First Branded Email:: '+toEmail[i]);        
                    break;
                }
            }            
        }
    }
    
    for (cec_Case_Brand_Mapping__c cbm: [Select Inbound_Email__c,     
                                                Brand_Market__c, 
                                                Brand__c,
                                                Auto_Response_Template__c, 
                                                External_Image_Address__c,
                                                Country__c,
                                                skill__c
                                         From cec_Case_Brand_Mapping__c 
                                         Where  Inbound_Email__c In :incomingEmailAddresses.keyset()]) {
        incomingEmailAddresses.put(cbm.Inbound_Email__c, cbm);
    }
    
    for (EmailMessage em : emList) {
        if (em.Incoming) {
        
        Case caseObj = [SELECT Brand__c FROM Case WHERE ID =: em.parentId];
        
        String[] toEmail = em.ToAddress.split(';');
        
        cec_Case_Brand_Mapping__c cbm = null;
        // Get the first occurrence of branded email from the To list
        for(Integer i=0; i < toEmail.size(); i++){
            cbm = incomingEmailAddresses.get(toEmail[i].trim());
            if(brandEmailSet.contains(toEmail[i].trim())){
                if (cbm != null) {
                    System.debug('here is the cbm: ' + cbm); 
                    Case c = new Case(id=em.parentId);
                    c.Set_Assignment_Fields__c = true;
                    c.Country__c=cbm.Country__c;
                    c.Case_Brand_Mapping__c = cbm.Id;
                    if(caseObj.Brand__c == null){
                        c.Brand__c = cbm.Brand__c;
                    }
                    c.Product_Skill__c=cbm.skill__c;
                    c.CMMFlag__C = TRUE;
                    System.debug('here is the case: ' + c);
                    caseAssociated=true;
                    casesToUpdate.add(c);       
                    break;
                }
            }
            
        }
        if(caseAssociated==false){
             if(defaultBrandEmailList.size()>0) {
                if(cbm == null) {
                    Case c = new Case(id=em.parentId);
                    c.Set_Assignment_Fields__c = true;
                    c.Country__c=defaultBrandEmailList[0].Country__c;
                    c.Case_Brand_Mapping__c = defaultBrandEmailList[0].Id;
                    if(caseObj.Brand__c == null){
                        c.Brand__c = defaultBrandEmailList[0].Brand__c;
                    }
                    c.Product_Skill__c=defaultBrandEmailList[0].skill__c;
                    c.CMMFlag__C = TRUE;
                    System.debug('here is the case: ' + c);
                    casesToUpdate.add(c);
                }
       }
            
  }
    }
    } 
    update casesToUpdate;
    
  }
}