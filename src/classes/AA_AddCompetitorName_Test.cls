/**
 * Name:        -   AA_AddCompetitorName_Test
 * @description -   This is the test class for AA_AddCompetitorName Trigger to verify the code  while adding new Competitor Name.
 * @Author      -   Aslesha R K     
 */

@isTest
private class AA_AddCompetitorName_Test {
/*******************************************************************
Purpose: Method to test if we could add brand category with competitor name and without competitor name.
********************************************************************/
    static testMethod void myUnitTest() {
    	Schema.DescribeSObjectResult R = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Brand')).getRecordTypeId();
        
        //with competitor name
       aa_Agent_Competitor__c compititorname=new aa_Agent_Competitor__c(Name='testCompititor');
       insert compititorname;
       aa_Agent_App_Competitor_Brand__c compbrand=new aa_Agent_App_Competitor_Brand__c(Name='testcompbrand',Competitor__c=compititorname.id,RecordTypeId=recTypeId);
       insert compbrand;
       aa_Agent_App_Brand_Category__c brandcat =new aa_Agent_App_Brand_Category__c(Brand_Id__c=compbrand.id);
       insert brandcat;
        system.assert(brandcat != null);
        
       //without competitor name
       aa_Agent_App_Competitor_Brand__c compbrand1=new aa_Agent_App_Competitor_Brand__c(Name='testcompbrand');
       insert compbrand1;
       aa_Agent_App_Brand_Category__c brandcat1 =new aa_Agent_App_Brand_Category__c(Brand_Id__c=compbrand.id);
       insert brandcat1;
       system.assert(brandcat1 != null);
    }
}