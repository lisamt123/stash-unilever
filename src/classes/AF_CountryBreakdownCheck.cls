public class AF_CountryBreakdownCheck {
    
    public Boolean CheckCountryBreakdown(String pBrandEstimate)
    {
        Boolean retResult = false;
        //1st check to see if there are estimates which are central billing - only need to look at ones where total >0
        List<AF_Agency_Estimate__c> lstAgESt = [select id from AF_Agency_Estimate__c where AF_Brand_Estimate__c=: pBrandEstimate and AF_Total__c >0 and AF_CentralBilling__c =true];
        if(!lstAgESt.isEmpty())   
        {
            //now we need to check list of estimates and make sure they are all at 100%
            List<aggregateResult> lstAgEStExc=  [SELECT AF_Agency_Estimate__c,sum(AF_Value__c) total FROM AF_Entity_Exception__c where AF_Agency_Estimate__c in:lstAgESt group by AF_Agency_Estimate__c];
            //If there are no exception - need to stop the approval
            
            if(lstAgEStExc.isEmpty()) {retResult=true;}
            else
            {
                if(lstAgEStExc.size()<lstAgESt.size()) {retResult=true;}
                else
                {
                //Now check they all add up to 100%
                    for (AggregateResult ar : lstAgEStExc){
                    //system.debug('ar results:'+ ar.get('AF_Agency_Estimate__c')+' '+ ar.get('total'));
                    if(ar.get('total')!=100.00) retResult=true;
                    }
                }
            }
            
        }
        //system.debug('retResult:' + retResult);
        return retResult;
    }

}