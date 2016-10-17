@isTest
private class BFM_GNREupload_CCTest{
private static testMethod void testBFM_GNREupload_CC(){

 Test.startTest();

Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        acc.Region__c='lo';
        insert acc;



list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
BFM_CT_e__c cte=new BFM_CT_e__c();
cte.CT_e_key__c='123456';
cte.Cte_original_Access_Key__c='123';
cte.CNPJ_Service_Taker__c='12345678900000';
cte.CNPJ_issuer__c='12345678900000';
cte.CT_e_Type__c='normal';
cte.CFOP__c='6.932';
cte.Carrier_Account__c=acc.id;
insert cte;
//ctelst.add(cte);
//insert ctelst ;
PageReference pageRef = Page.BFM_GNREupload_VF;
Test.setCurrentPage(pageRef);
ApexPages.currentPage().getParameters().put('Id',cte.id);
BFM_GNREupload_CC controller=new BFM_GNREupload_CC(new ApexPages.StandardController(cte));
 list<Attachment> attlst=new list<Attachment>(); 
  Attachment att=new Attachment();
  
  att.parentid=cte.id;
 att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        att.contenttype='application/pdf';
        //insert att;
        attlst.add(att);
        insert attlst;
        controller.gnreAtt=att ;
        controller.savefile();
        //controller.issuccess=true;
        //pagereference pgr = new pagereference('/'+cte.id);
                   
         List<Attachment> attachments=[select id, name from Attachment where parent.id=:cte.id];
        System.assertEquals(1, attachments.size());
controller.cancel();

BFM_GNREupload_CC controller1=new BFM_GNREupload_CC(new ApexPages.StandardController(cte));
 list<Attachment> attlst1=new list<Attachment>(); 
  Attachment att1=new Attachment();
   att1.contenttype='asda';
  att1.parentid=cte.id;
  
 //att.Name='Unit Test Attachment';
       // att.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        
        //insert att;
        attlst.add(att1);
        insert attlst1;
        controller1.gnreAtt=att1 ;
       controller1.savefile();
        
        
controller.cancel();
Test.stopTest();
}
}