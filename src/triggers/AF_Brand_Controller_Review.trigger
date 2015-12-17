trigger AF_Brand_Controller_Review on AF_Brand_Estimate__c (after update) 
{
    system.debug('@@@ run first='+AF_CheckRecursive.run);
    if(AF_CheckRecursive.run)
    {
        set<id> Brids = new set<id>();
        for(AF_Brand_Estimate__c Br : trigger.new)
        {
            if(Br.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WIHTCMCO && Br.AF_Category_Finance_Approved__c)
                Brids.add(Br.id);
                
            system.debug('@@@ Brand Ids first='+Brids);
        }
        AF_CheckRecursive.run=false;
        system.debug('@@@ run last='+AF_CheckRecursive.run);
        if(!Brids.isempty())
        {
            AF_Brand_Controller_Review Brd=new AF_Brand_Controller_Review();
            Brd.Create_Review(Brids);
        }        
        
    }
}