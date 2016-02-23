public class apxCancelPworfController {
    ApexPages.StandardSetController setCon;
    public CPA_PWORF__c objPworf;
    public CPA_PWORF__c getPWORF()
    {
      if(objPworf==null)objPworf= new CPA_PWORF__c();
      return objPworf;
    }
    public apxCancelPworfController (Apexpages.Standardsetcontroller cont)
    {
        objPworf = [SELECT id, ltxt_Reason_for_Cancellation__c FROM CPA_PWORF__c WHERE id =: ApexPages.currentPage().getParameters().get('id')];

    }
    
    
    public Pagereference doSave()
    {
        CPA_PWORF__c objPworf1;
        objPworf1.ltxt_Reason_for_Cancellation__c = objPworf.ltxt_Reason_for_Cancellation__c;
        update objPworf1;

        return new Pagereference('/'+CPA_PWORF__c.getSObjectType().getDescribe().getKeyPrefix()+'/o');
        
    }
}