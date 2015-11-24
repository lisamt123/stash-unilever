/**********************************************************************
 Name:  FAU_Participant_Biography_Doc_Controller
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: This is controller for Participant_Biography_Doc VF Page to query and 
-------  populate data.               
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0   Kumar Ravula    27/11/2014      INITIAL DEVELOPMENT   Controller for FAU_Participant_Biography_Doc 
***********************************************************************/


public with sharing class FAU_Participant_Biography_Doc_Controller {

    public static final String PARTICIPANT_DECLINE = 'Declined';
    public Id parentId {get;set;}
    public String image{get;set;}
    public string resourceURL{get;set;}
    public List<FAU_Participant__c> participantList{get; set;}
    
   /*******************************************************************
   Purpose:  Constructor to initialize variables and Lists                                                         
   Parameters: Not Required
   Returns: Nothing
   Throws [Exceptions]: No                                                      
  ********************************************************************/

    
    public FAU_Participant_Biography_Doc_Controller(ApexPages.StandardController controller){
                
        parentId = apexpages.currentpage().getparameters().get('id');
        participantList = new List<FAU_Participant__c>();
        
        List<FAU_Program__c> program = [Select Id, FAU_Program_Banner_URL__c From FAU_Program__c Where Id = :parentId];
        String str = program[0].FAU_Program_Banner_URL__c;
        system.debug('###imageStr....'+ str);
        string[] str2 = str.split('/');
        system.debug('###image Arrray....'+ str2);
        string imageURL = str2[1];
        system.debug('###imageURL....'+ imageURL);
        resourceURL = getResourceURL(imageURL);
        system.debug('###resourceURL....'+ resourceURL);
        
        //image = URL.getSalesforceBaseUrl().toExternalForm() +'/Resource/' + str.subString(str.indexOf('/')+1);
        
        participantList = [select Id,Name,FAU_User__c, FAU_Company_City__c, FAU_User__r.Name,FAU_User__r.Email,FAU_User__r.Title, FAU_User__r.UserName, FAU_User__r.FullPhotoURL, FAU_Biography_Deadline__c, FAU_Job_Title__c, FAU_Biography__c, FAU_Unilever_Career__c,
                        FAU_Prior_Career__c, FAU_Education__c, FAU_Personal__c, Current_Role_Responibilities__c,FAU_Company_Name__c From FAU_Participant__c where FAU_Program_Wave__c = :parentId AND FAU_Invite_State__c != :PARTICIPANT_DECLINE Limit 50000];
    }
    Public static String getResourceURL(string resourceName){
      List<staticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
            //Checking if the result is returned or not  
            if(resourceList.size() == 1){  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL
           string retURL = '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
           system.debug('###retURL....'+ retURL);
           return retURL;   
        }
        else return '';  
    }
}