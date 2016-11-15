public class AF_UpdateBrandEstimateCatApproverValues
{

   /* public Static void UpdateBrandingEstimates(List<AF_Brand_Estimate__c> BrandRecords)
    {
    
        list<AF_Brand_Estimate__c>  afBrands=new list<AF_Brand_Estimate__c>();
        List<user> Userlist=new List<user>();
        Map<id,List<String>> usermap=new Map<id,List<String>>();
        List<string> BrandStrings=new list<String>();
        list<id> userids=new list<id>();
        Id DummyUserid;
        set<id> brandids=new set<id>();
        Map<id,string> brandMap=new Map<id,String>();
        List<AF_Category_Brand__c> CatBrands=new  List<AF_Category_Brand__c>();
        
        
        if(BrandRecords.size()>0)
        for(AF_Brand_Estimate__c br:BrandRecords)
        {
            if(br.Brand__c!=null)
            brandids.add(br.Brand__c); 
        }
        
        CatBrands=[select id,Name From AF_Category_Brand__c  where id IN:brandids ];
        if(CatBrands.size()>0)
        for(AF_Category_Brand__c cb:CatBrands)
        {
            brandMap.put(cb.id,cb.Name);
        }
        
        User dummy=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c  from  User  where  UserName=:'dummy@abc.com'  and IsActive=true  limit 1 ];
        if(dummy.id!=null)
        DummyUserid=dummy.id;
        List<User> users=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c  from  User  where  AF_UserTypeText__c=:'Category Finance'  and IsActive=true  Order by CreatedDate Limit 50000];
        System.debug('****************'+users.size());
        System.debug('****************'+users);
       
        System.debug('@@@@@@@@@@@@dummid='+ DummyUserid);
        if(BrandRecords.size()>0)
        for( AF_Brand_Estimate__c Brandest:BrandRecords)
        {  
            userids=new list<id>();
            String Brandname;
            if(Brandest.Brand__c!=null)
            {
                Brandname=brandMap.get(Brandest.Brand__c);
            }
            system.debug('&&&&&&&&&&&&&&&Brandname='+Brandname);
            if(users.size()>0)
            for(user u:users)
            {  
                system.debug('%%%%%%%%%%%%'+u.AF_Brand__c);
                BrandStrings=new list<String>();
                if(u.AF_Brand__c!=null && u.AF_Brand__c!='' )
                {
                   
                    String Brandvalue=u.AF_Brand__c;
                    BrandStrings=Brandvalue.split(';');          
                }
                if(BrandStrings.size()>0)
                For(String s:BrandStrings)
                {
                    if(s==Brandname)
                    {
                        userids.add(u.id);
                    }
                }    
            } 
            System.debug('^^^^^^^^^^^^^^^^^user id  size'+userids.size());  
            System.debug('^^^^^^^^^^^^^^^^^userids=='+userids);
            if(userids.size()==0)
            Brandest.addError('There are no user records with this Brand');
            else if(userids.size()==1)
            {
                Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
                Brandest.AF_Cat_Finance_Approver_2__c=DummyUserid;
                Brandest.AF_Cat_Finance_Approver_3__c=DummyUserid;
                Brandest.AF_Cat_Finance_Approver_4__c=DummyUserid;
                Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
            }
            else if(userids.size()==2)
            {
                Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
                Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
                Brandest.AF_Cat_Finance_Approver_3__c=DummyUserid;
                Brandest.AF_Cat_Finance_Approver_4__c=DummyUserid;
                Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
            }
            else if(userids.size()==3)
            {
                Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
                Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
                Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
                Brandest.AF_Cat_Finance_Approver_4__c=DummyUserid;
                Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
            }
            else if(userids.size()==4)
            {
                Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
                Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
                Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
                Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
                Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
            }
            else if(userids.size()>=5)
            {
                Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
                Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
                Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
                Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
                Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
            }
  
            
        }
        
        
    }*/
}