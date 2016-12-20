@isTest
public class BFM_Link_MDFCTe_Onsave_Test{
    private static testMethod void testLinkMdfCte(){
        //BFM_Link_MDFCTe_onsave_Test onsave = new BFM_Link_MDFCTe_onsave_Test();
        List<BFM_MDF_e__c> linkList = new List<BFM_MDF_e__c>();
        List<BFM_CT_e__c> listCTe = new List<BFM_CT_e__c>();
        
        
      
        BFM_MDF_e__c mdf1 = new BFM_MDF_e__c();                
        mdf1.CT_e_Access_Key__c='12345567787';
        //mdf1.Taker_CNPJ__c='4566776544434343';
        mdf1.MDF_e_Status__c='In Progress';
        mdf1.MDF_e_Duplicate_Record_Check__c=true;
        mdf1.MDF_e_Valid_CNPJ_Check__c=true;
        //mdf1.MDF_e_Sefaz_Status__c='Safaz Ok';
        mdf1.MDF_e_Duplicate_Record_Status__c ='Duplicate Record';
        mdf1.MDF_e_Valid_CNPJ_Status__c='Valid CNPJ';
        //mdf1.MDF_e_Status__c = 'Link Ok';
        linkList.add(mdf1);
        
        BFM_CT_e__c cte = new BFM_CT_e__c();
        cte.CT_e_key__c = '4566788943';
        //mdf3.Cte_Status__c = '';
        cte.MDF_e__c = mdf1.id;
        listCTe.add(cte);
        
        BFM_MDF_e__c mdf2 = new BFM_MDF_e__c();    
        mdf2.CT_e_Access_Key__c='2766542312';
        //mdf2.Taker_CNPJ__c='678976544333322';
        mdf2.MDF_e_Status__c='In Progress';
        mdf2.MDF_e_Duplicate_Record_Check__c=true;
        mdf2.MDF_e_Valid_CNPJ_Check__c=false;
        //mdf2.MDF_e_Sefaz_Status__c='Safaz Ok';
        mdf2.MDF_e_Duplicate_Record_Status__c ='Validation Error';
        mdf2.MDF_e_Valid_CNPJ_Status__c='Invalid CNPJ';
        //mdf2.MDF_e_Status__c = 'Link Ok';
        linkList.add(mdf2);
        
        BFM_MDF_e__c mdf3 = new BFM_MDF_e__c();    
        mdf3.CT_e_Access_Key__c='4566788943';
        //mdf3.Taker_CNPJ__c='467853222334509';
        mdf3.MDF_e_Status__c='Pending Link';
        mdf3.MDF_e_Duplicate_Record_Check__c=false;
        mdf3.MDF_e_Valid_CNPJ_Check__c=false;
        //mdf3.MDF_e_Sefaz_Status__c='Safaz Ok';
        mdf3.MDF_e_Duplicate_Record_Status__c ='Validation Ok';
        mdf3.MDF_e_Valid_CNPJ_Status__c='Valid CNPJ';
        //mdf3.MDF_e_Status__c = 'Pending Link';
        linkList.add(mdf3);
               
        test.starttest();
        insert linkList;
        insert listCTe;
        system.assertEquals('Validation Ok',mdf3.MDF_e_Duplicate_Record_Status__c);
        BFM_Link_MDFCTe_onsave.linkmdfcte(linkList);
        test.stoptest();
        //insert mdfcte;  
        
    }
}