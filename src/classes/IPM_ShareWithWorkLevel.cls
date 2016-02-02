/****************************************************************************
@Description : Share all records to same company card and same category for WL2+ users
@Created Date: 10/03/2015
@Author: Cognizant
****************************************************************************/

public with sharing class IPM_ShareWithWorkLevel{

    /****************************************************************************
    @Description : check user category with company card category
    @param:list of user profile records
    *****************************************************************************/
    public static void CategoryValidation(list<IPM_User_Profile__c>newprofile){
         /****************************************************************************
         @Description : set of company id's
         */
        set<id>companyids=new set<id>();
        for(IPM_User_Profile__c nprofile1:newprofile){
            if(nprofile1.IPM_Company_Card__c !=null)
            {
                companyids.add(nprofile1.IPM_Company_Card__c);
            }
        }

        List<IPM_Company_Card__c>lstcc=[SELECT IPM_Managed_Category__c FROM IPM_Company_Card__c WHERE id IN:companyids LIMIT 50000];
        for(IPM_User_Profile__c nprofile:newprofile)
        {
            for(IPM_Company_Card__c cc:lstcc)
            {
                if(nprofile.IPM_Company_Card__c !=null && nprofile.IPM_Company_Card__c==cc.id)
                {
                    set<string>catename=new set<string>();
                    String[] ucat=(nprofile.IPM_User_Category__c).split(';');
                    for(Integer i=0;i<ucat.size();i++) 
                    {
                        catename.add(ucat[i]);
                    }
                    set<string>Ccatename=new set<string>();
                    String[] cucat=(cc.IPM_Managed_Category__c).split(';');
                    for(Integer i=0;i<cucat.size();i++) 
                    {
                        Ccatename.add(cucat[i]);
                    }
                    integer catsize=catename.size(); 
                    for(string ccategory:Ccatename)
                    {
                        for(String cccat:catename)
                        {
                            if(cccat==ccategory)
                            {
                                catsize=catsize-1;
                            }
                        }
                    }
                    if(catsize>0)
                    {
                        nprofile.IPM_User_Category__c.adderror(system.label.IPM_User_Category_Error);
                    }
                }
            }
        }  
    }
}