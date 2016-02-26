public with sharing Class PworfSubmitController{



    public CPA_PWORF__c objPworf{get;set;}
    public    Id SetId ;
    public PworfSubmitController(){    
        SetId = apexpages.currentpage().getparameters().get('id');
        
    
    }
        public pagereference checkAndRedirect(){
        pagereference  redirect = new PageReference('/'+objPworf.ID);

        List<CPA_PWORF__c > lst = [Select Id,pkl_Status__c  from CPA_PWORF__c where Id =:SetId ];
            if(lst[0].pkl_Status__c == 'Withhold' || lst[0].pkl_Status__c == 'Returned'||lst[0].pkl_Status__c =='Submitted' || lst[0].pkl_Status__c == 'Resubmitted' || lst[0].pkl_Status__c == 'Resubmitted' ||
            lst[0].pkl_Status__c == 'Saved'|| lst[0].pkl_Status__c == 'Saved'|| lst[0].pkl_Status__c == 'Returned'){

        
            lst[0].pkl_Status__c = 'Submitted';
            update objPworf;
            
        }
                    return redirect ;
         }
}