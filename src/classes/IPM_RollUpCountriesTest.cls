@istest(seealldata = true)
Public class IPM_RollUpCountriesTest
{
   Public static testmethod void rollcountries()
   {
        IPM_Project__c ip = new IPM_Project__c();
        ip.name = 'test';
        ip.IPM_PM_Approach__c = 'External';
        insert ip;
        
         mdm_Geography__c g = new mdm_Geography__c();
         g.name = 'test';
         insert g;
        
        IPM_Country__c ic = new IPM_Country__c();
        ic.IPM_Local_Project__c = ip.id;
        ic.Geography__c = g.id;
        ic.IPM_Project__c = ip.id;
        insert ic;
        
        IPM_Country__c ic1 = new IPM_Country__c();
        ic1.IPM_Local_Project__c = ip.id;
        ic1.Geography__c = g.id;
        ic1.IPM_Project__c = ip.id;
        insert ic1;
        
        update ic1;
        
        delete ic1;
   		System.assert(ip.Id !=null);
   }
   
}