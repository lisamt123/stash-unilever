public class Brand_Controller_Review
{
    public static boolean BrandReview=true;
    Map<id,set<string>> mapgroups = new Map<id,set<string>>();
    list<AF_Controller_Review__c> lstReview=new list<AF_Controller_Review__c>();
    Map<id,set<string>> mapgroupCR = new Map<id,set<string>>();
    
    public void Create_Review(set<id> BrandId)
    {
        system.debug('@@@ Brand Ids='+BrandId);
        for(AF_Brand_Estimate__c AFB:[select id,(select id,Controller_Group__c from Controller_Reviews__r) from AF_Brand_Estimate__c where id in:BrandId])
        {
            if(mapgroupCR.containskey(AFB.id))
            {                
                set<string> setid=mapgroupCR.get(AFB.id);
                for(AF_Controller_Review__c ACR:AFB.Controller_Reviews__r)
                {
                    setid.add(ACR.Controller_Group__c);
                }
                mapgroupCR.put(AFB.id,setid);
            }
            Else
            {
                set<string> setid=new set<string>();
                for(AF_Controller_Review__c ACR:AFB.Controller_Reviews__r)
                {
                    setid.add(ACR.Controller_Group__c);
                }
                mapgroupCR.put(AFB.id,setid);
            }
        }
        
        for(AF_Agency_Estimate__c AgE:[select id,AF_Brand_Estimate__c,AF_Unilever_Entity__r.Controller_Group__c from AF_Agency_Estimate__c where AF_Brand_Estimate__c in:BrandId])
        {
            system.debug('@@@ Agency id='+AGE.id);
            system.debug('@@@ Agency Entity group='+AGE.AF_Unilever_Entity__r.Controller_Group__c);
            if(mapgroups.containskey(AgE.AF_Brand_Estimate__c))
            {
                set<string> setid=mapgroups.get(AgE.AF_Brand_Estimate__c);
                list<string> frontBack=new list<string>();
                if(AgE.AF_Unilever_Entity__r.Controller_Group__c!=null)
                    frontBack = AgE.AF_Unilever_Entity__r.Controller_Group__c.split(';');
                for(string str:frontBack)
                {
                    if(!setid.contains(str))
                    {
                        setid.add(str);
                    }
                }
                mapgroups.put(AgE.AF_Brand_Estimate__c,setid);                             
            }
            Else
            {
                set<string> setid=new set<string>();
                list<string> frontBack=new list<string>();
                if(AgE.AF_Unilever_Entity__r.Controller_Group__c!=null)
                    frontBack = AgE.AF_Unilever_Entity__r.Controller_Group__c.split(';');
                for(string str:frontBack)
                {
                    setid.add(str);
                }
                mapgroups.put(AgE.AF_Brand_Estimate__c,setid);
            }
        }
        
        system.debug('@@@ map Brand with set ='+mapgroups);
        if(!mapgroups.isempty())
        {
            for(id idval: mapgroups.keyset())
            {
                set<string> setCr=mapgroupCR.get(idval);                
                for(string setBr: mapgroups.get(idval))
                {
                    if(!setCr.contains(setBr))
                    {
                        AF_Controller_Review__c AFC=new AF_Controller_Review__c();
                        AFC.Brand_Estimate__c=idval;
                        AFC.Controller_Group__c=setBr;
                        lstReview.add(AFC);
                    }
                }
            }
        }
        
        system.debug('@@@ lstReview ='+lstReview);
        if(!lstReview.isempty())
            insert lstReview;
        
        checkRecursive.run=false;
    }
}