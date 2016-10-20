@isTest
public class BFM_Link_CCECTE_Test{
    private static testMethod void testlinkCCECTE(){
        List<BFM_CT_e__c> listCte = new List<BFM_CT_e__c>();
        List<BFM_CC_e__c> listCce = new List<BFM_CC_e__c>();
        BFM_CT_e__c cte = new BFM_CT_e__c();
        
        cte.CT_e_key__c = '634565265';
        cte.CT_e_type__c = 'Normal';
             
        BFM_CC_e__c cce1 = new BFM_CC_e__c();
        cce1.CC_e_Valid_CNPJ_Status__c='Valid CNPJ';
        cce1.CC_e_Link_Check_Status__c='Link Ok';
        cce1.Reference_Object_Type__c = 'CTE';
        cce1.Related_CT_e_NF_e_DF_Key__c='6464646';
        cce1.CC_e_Status__c='Link Ok';
        
        BFM_CC_e__c cce2 = new BFM_CC_e__c();
        cce2.CC_e_Valid_CNPJ_Status__c='Valid CNPJ';
        cce2.CC_e_Link_Check_Status__c='Link Ok';
        cce2.Reference_Object_Type__c = 'NFE';
        cce2.Related_CT_e_NF_e_DF_Key__c='6464646';
        cce2.CC_e_Status__c='Link Ok';
        
        listCte.add(cte);
        listCce.add(cce1);
        listCce.add(cce2);
        
        test.starttest();
        insert listCte;
        system.assertEquals('634565265', cte.CT_e_key__c);
        insert listCce;
        system.assertEquals('6464646', cce2.Related_CT_e_NF_e_DF_Key__c);
        BFM_Link_CCECTE.linkCCECTE(listCce);
        //ccecte.linkCCECTE(listCce);
        test.stoptest();
            
    }
}