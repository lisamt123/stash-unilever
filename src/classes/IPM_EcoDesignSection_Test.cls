@isTest
public class IPM_EcoDesignSection_Test{

 
 static testmethod void testIPM_EcoDesignSectionConstructor(){
 
     IPM_Project_Document_Section_Content__c IPM_SecContent = new IPM_Project_Document_Section_Content__c();
     IPM_EcoDesignSection ipmECODesignSection = new IPM_EcoDesignSection ();  
 }
 
 static testmethod void testGetEcodesign(){
     IPM_EcoDesignSection ipmECODesignSection = new IPM_EcoDesignSection ();
     ipmECODesignSection.getEcodesign();
 
 }

 static testmethod void testSaverecords(){
     IPM_EcoDesignSection ipmECODesignSection = new IPM_EcoDesignSection ();
     ipmECODesignSection.ecoDid = '';
     ipmECODesignSection.Saverecords();
 
 }

}