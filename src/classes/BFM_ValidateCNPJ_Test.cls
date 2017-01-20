@isTest
public class BFM_ValidateCNPJ_Test {
	private static testMethod void BFM_ValidateCNPJTestMethod(){
        Test.startTest();
        BFM_CT_e__c cte = new BFM_CT_e__c();
        cte.Taker_Type__c = '0';
        cte.CNPJ_Goods_Sender__c = '11806723000794';
        cte.City_Goods_Sender__c = 'Brazil';
        cte.City_Code_Goods_Sender__c = 'BR';
        cte.UF_Goods_Sender__c  = 'Test';  
        List<BFM_CT_e__c> cteList = new List<BFM_CT_e__c>();
        cteList.add(cte);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList);
        
        BFM_CT_e__c cte1 = new BFM_CT_e__c();
        cte1.Taker_Type__c = '1';
        cte1.CNPJ_Cargo_Dispatcher__c = '11806723000794';
        cte1.City_Cargo_Dispatcher__c = '3552809';
        cte1.City_Code_Cargo_Dispatcher__c = '1234';
        cte1.UF_Cargo_Dispatcher__c='SP';  
        List<BFM_CT_e__c> cteList1 = new List<BFM_CT_e__c>();
        cteList1.add(cte1);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList1);
        
        BFM_CT_e__c cte2 = new BFM_CT_e__c();
        cte2.Taker_Type__c = '1';
        cte2.CNPJ_Goods_Sender__c = '11806723000794';
        cte2.City_Goods_Sender__c = 'Brazil';
        cte2.City_Code_Goods_Sender__c = 'BR';
        cte2.UF_Goods_Sender__c  = 'Test';  
        List<BFM_CT_e__c> cteList2 = new List<BFM_CT_e__c>();
        cteList2.add(cte2);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList2);
        
        BFM_CT_e__c cte3 = new BFM_CT_e__c();
        cte3.Taker_Type__c = '2';
        cte3.CNPJ_Recipient__c = '48917702000160';
        cte3.City_Recipient__c='Test';
        cte3.City_Code_Recipient__c='Test';
        cte3.UF_Recipient__c='SP';                 
        List<BFM_CT_e__c> cteList3 = new List<BFM_CT_e__c>();
        cteList3.add(cte3);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList3);
        
        BFM_CT_e__c cte4 = new BFM_CT_e__c();
        cte4.Taker_Type__c = '2';
        cte4.CNPJ_Destination__c = '22799419000198';
        cte4.City_Destination__c='Test';
        cte4.City_Code_Destination__c='Test';
        cte4.UF_Destination__c='GO';     
        List<BFM_CT_e__c> cteList4 = new List<BFM_CT_e__c>();
        cteList4.add(cte4);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList4);
        
        BFM_CT_e__c cte5 = new BFM_CT_e__c();
        cte5.Taker_Type__c = '3';
        cte5.CNPJ_Destination__c = '22799419000198';
        cte5.City_Destination__c='Test';
        cte5.City_Code_Destination__c='Test';
        cte5.UF_Destination__c='GO';     
        List<BFM_CT_e__c> cteList5 = new List<BFM_CT_e__c>();
        cteList5.add(cte5);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList5);
        
        BFM_CT_e__c cte6 = new BFM_CT_e__c();
        cte6.Taker_Type__c = '3';
        cte6.CNPJ_Recipient__c = '11806723000794';
        cte6.City_Recipient__c='Test';
        cte6.City_Code_Recipient__c='Test';
        cte6.UF_Recipient__c='SP';                 
        List<BFM_CT_e__c> cteList6 = new List<BFM_CT_e__c>();
        cteList6.add(cte6);
        BFM_ValidateCNPJ.defineUnileverAccount(cteList6);
        
        Test.stopTest();
    }	
}