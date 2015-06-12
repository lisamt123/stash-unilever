trigger AF_Brand_Controller_Review on AF_Brand_Estimate__c (after update) 
{
    system.debug('@@@ run first='+checkRecursive.run);
    if(checkRecursive.run)
    {
        set<id> Brids = new set<id>();
        for(AF_Brand_Estimate__c Br : trigger.new)
        {
            if(Br.AF_Status_Base_Fees__c=='With CMCO' && Br.AF_Category_Finance_Approved__c==true)
                Brids.add(Br.id);
                
            system.debug('@@@ Brand Ids first='+Brids);
        }
        checkRecursive.run=false;
        system.debug('@@@ run last='+checkRecursive.run);
        if(!Brids.isempty())
        {
            AF_Brand_Controller_Review Brd=new AF_Brand_Controller_Review();
            Brd.Create_Review(Brids);
        }        
        
    }
}