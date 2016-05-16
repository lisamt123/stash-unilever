/**********************************************************************
 Name:  cec_SmartTemplateLoaderHelper
 Copyright � 2014  Unilever
 ======================================================
======================================================
Purpose:  for Smart Template for Case Feed                                                  
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Aalokkumar       19/09/2014       INITIAL DEVELOPMENT       cec_SmartTemplateLoaderHelper
 ****************************************************************************/ 
//Support.EmailTemplateSelector  
global class cec_SmartTemplateLoaderHelper implements Support.EmailTemplateSelector{

    global cec_SmartTemplateLoaderHelper (){}

    global ID getDefaultEmailTemplateId(id  caseId){

        system.debug('----------getDefaultEmailTemplateId caseId----'+caseId);

        //Case c = [SELECT id,Status,Reason,Market__c,Brand__c,Case_Brand_Mapping__c FROM Case where id =: caseId];
        Case c = [SELECT id, Status, Reason, Market__c, Case_Market__c, Case_Brand__c, Case_Brand_Mapping__c FROM Case where id =: caseId];
        system.debug('------------------------------------------c '+c);
        cec_Case_Brand_Mapping__c conf = null;
        List<cec_Case_Brand_Mapping__c> confs = null;
        if(c != null){
            if(c.Case_Brand_Mapping__c != null){
                //query on cec_Case_Brand_Mapping__c where Case_Brand_Mapping__c

                confs = [SELECT id,Default_Template_Name__c FROM cec_Case_Brand_Mapping__c WHERE id =:c.Case_Brand_Mapping__c  AND Default_Outbound_Email__c = True];
                system.debug('-----------Inside if got template: confs '+confs );           
                if (!confs.isEmpty()) {
                    conf = confs[0];
                    System.debug('Inside if got template: ' + conf.Default_Template_Name__c);
                }



            }else{

                // get template from case status + case reason
                /* confs = [SELECT id,Default_Template_Name__c,Brand__c,Market__c FROM cec_Case_Brand_Mapping__c 
                WHERE Market__c =: c.Market__c AND Brand__c =: c.Brand__c AND Default_Outbound_Email__c = True  
                ORDER BY Default_Outbound_Email__c,LastModifiedDate DESC ];*/

                if(c.Case_Market__c!=null || c.Case_Market__c !=''){       
                    confs = [SELECT id, Default_Template_Name__c, Brand__c, Brand_Market__c FROM cec_Case_Brand_Mapping__c 
                             WHERE Brand_Market__c =: c.Case_Market__c AND Brand__c =: c.Case_Brand__c AND Default_Outbound_Email__c = True  
                             ORDER BY Default_Outbound_Email__c,LastModifiedDate DESC ];
                }else{
                    confs = [SELECT id, Default_Template_Name__c, Brand__c, Brand_Market__c FROM cec_Case_Brand_Mapping__c 
                             WHERE Brand_Market__c =: c.Market__c AND Brand__c =: c.Case_Brand__c AND Default_Outbound_Email__c = True  
                             ORDER BY Default_Outbound_Email__c, LastModifiedDate DESC ];
                }
                system.debug('Inside Else ------------------------------------------confs '+confs );            

                if(!confs.isEmpty()){
                    conf = confs[0];
                    System.debug('got template: ' + conf.Default_Template_Name__c+'----conf.id'+conf.id);        

                }


                // get default template 
                if (conf==null) {
                    confs = [SELECT id,Default_Template_Name__c FROM cec_Case_Brand_Mapping__c WHERE Brand_Market__c = '' AND Brand__c = ''];

                    if (!confs.isEmpty()) {
                        conf = confs[0];
                        System.debug('got template: ' + conf.Default_Template_Name__c);
                    }
                }   

            }
        }else{
            return null;
        }       
        // get the template ID
        if (conf!=null){ 
            List<EmailTemplate> ets = [SELECT id FROM EmailTemplate WHERE DeveloperName =: conf.Default_Template_Name__c ];
            //Return the ID of the template selected      
            if(!ets.isEmpty()){
                EmailTemplate et = ets[0];
                System.debug('template: ' + conf.Default_Template_Name__c + ' -- id: ' + et.id);         
                return et.id;
            }
            System.debug('No template with the name: ' + conf.Default_Template_Name__c );
        }

        return null;

    }

}