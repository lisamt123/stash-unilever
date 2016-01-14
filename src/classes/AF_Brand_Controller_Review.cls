/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_Brand_Controller_Review
   @CreateDate : 6/7/2014
   @Description : This is a controller class for AF_UL_AgencyMatrix Page, 
   @              this is used to query and update the controller review object.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_Brand_Controller_Review
{
    public static boolean BrandReview=true;
    Map<id,set<string>> mapgroups = new Map<id,set<string>>();
    list<AF_Controller_Review__c> lstReview=new list<AF_Controller_Review__c>();
    Map<id,set<string>> mapgroupCR = new Map<id,set<string>>();
    /***********************************************************************************
*  @Description: this method is used to query and check's the review for all
*  @              records in brandestimate and update it in controller review object
*  @name : Create_Review
*  @param : BrandId
*  @return: none.
*************************************************************************************/
    public void Create_Review(set<id> BrandId)
    {
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
        for(AF_Agency_Estimate__c AgE:[select id,AF_Brand_Estimate__c,AF_Unilever_Entity__r.Controller_Group__c from AF_Agency_Estimate__c where AF_Total__c > 0 and AF_Brand_Estimate__c in:BrandId])
        {
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
        if(!lstReview.isempty())
        {
            insert lstReview;
        }
        else
        {
            //Need to check if we have any review not completed - if so leave at current status
            List<AF_Controller_Review__c> exstReviews = new List<AF_Controller_Review__c>([select id from AF_Controller_Review__c where Brand_Estimate__c in:BrandId and Review_Completed__c=false]);
            if (exstReviews.isempty())
            {
                List<AF_Brand_Estimate__c> lstbrandestimates =new List<AF_Brand_Estimate__c>();
                for(AF_Brand_Estimate__c AFB:[select id,(select id,Controller_Group__c from Controller_Reviews__r) from AF_Brand_Estimate__c where id in:BrandId])
                {
                    AFB.AF_Status_Base_Fees__c = 'With CMCO';
                    lstbrandestimates.add(AFB);
                }
                if(!lstbrandestimates.IsEmpty())
                update lstbrandestimates;
                for(AF_Brand_Estimate__c bEstimates:lstbrandestimates){
                    Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                    request.setObjectId(bEstimates.Id);
                    request.setComments('Submitted for approval. Please approve.');
                    request.setNextApproverIds(new ID[]{UserInfo.getUserId()});
                    // submit the approval request for processing
                    Approval.ProcessResult result = Approval.process(request);
                }
            }
        }
        AF_CheckRecursive.run=false;
    }
}