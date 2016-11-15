Public class AF_Assign_Category_Brand
{
  Public boolean catpanel{set;get;}
    public AF_Assign_Category_Brand(ApexPages.StandardController controller) {
          Lead1 =  (Lead) controller.getRecord();
          catpanel = false;
    }

    Public lead lead1{set;get;}
    Public void update_user()
    {
         
         if(lead1.user__c != null)
         {
              user u;
            
             string User_category;
             string user_brand;
              for(user uu : [select id,name,AF_Category__c,AF_Brand__c from user where id =: lead1.user__C limit 1])
              {
                  u =uu;
                  User_category =uu.AF_Category__c;
                  user_brand = (uu.AF_Brand__c);
              }
               if(u != null ) 
              {
              string cname;
              string bname;
              if(lead1.Category_Brands__c != null)
                      cname = [select id,name from AF_Category_Brand__c where id=: lead1.Category_Brands__c limit 1].name;
                 if(lead1.Brand__c != null)
                     bname =  [select id,name from AF_Category_Brand__c where id=: lead1.Brand__c limit 1].name;
              
             
                
                 if(cname!= null && User_category != null &&User_category.contains(cname))
                 {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.AF_Category);
                    ApexPages.addMessage(myMsg);
                 }
                 else if(bname!= null && User_brand!= null &&  User_brand.contains(bname))
                 {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,system.label.af_brand);
                    ApexPages.addMessage(myMsg);
                 }
                 else {
                         if(lead1.Category_Brands__c != null) {
                              if(u.AF_Category__c == null)
                                 u.AF_Category__c = cname;
                              else
                                 u.AF_Category__c = u.AF_Category__c + ';' + cname;
                           } 
                         if(lead1.Brand__c != null) {   
                              if(u.AF_Brand__c == null)
                                 u.AF_Brand__c =  bname;
                              else
                                 u.AF_Brand__c = u.AF_Brand__c + ';' + bname;
                             
                          }
                         Database.SaveResult us = Database.update(u, false);
                         if(us.issuccess())
                         {
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.AF_Success);
                             ApexPages.addMessage(myMsg);
                         }
                    }   
              } 
         }
    }
    Public user ulist{set;get;}
    Public void categories_brands()
    {
        catpanel = true;
         for(user uu : [select id,name,AF_Category__c,AF_Brand__c from user where id =: lead1.user__C limit 1])
              {
                 ulist = uu;
              }
    }
   /* public list<user> getuserdata()
    {
       return ulist;
    }*/
}