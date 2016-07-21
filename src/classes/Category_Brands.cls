public class Category_Brands 
{
   /* List<SelectOption> options = new List<SelectOption>();
    public Category_Brands(ApexPages.StandardController controller) 
    {
        category =new AF_Category_Brand__c();
        maprectype=new map<string,string>();        
        for(Recordtype rec:[select id,name from Recordtype where SobjectType=:'AF_Category_Brand__c' and IsActive=:true])
           {
               if(RecTypeValue==null)
                   RecTypeValue=rec.name;
               options.add(new SelectOption(rec.name,rec.name));
               maprectype.put(rec.name,string.valueof(rec.id));
           }
    }

    public AF_Category_Brand__c category{set;get;}
    public string CategoryValue{set;get;}
    public string BrandValue{set;get;}
    public string RecTypeValue{set;get;}
    public Category_Brands()
    {
       category =new AF_Category_Brand__c();
       
    }
    public map<string,string> maprectype{set;get;}
    public List<SelectOption> getRecTypes() 
    {
        
        return options;
    }
    
    public void OnchangeType()
    {}
    
    public pagereference Save_Record()
    {
        try
        {     
            pagereference ref;
            category.recordtypeid=maprectype.get(RecTypeValue);
            if(RecTypeValue=='Brand')
            {
                if(BrandValue!=null && BrandValue!='')
                {
                    
                    category.name=BrandValue;
                    category.Brand__c=BrandValue;
                    category.AF_Super_category__c=null;
                    upsert category;
                    ref=new pagereference('/'+category.id);
                    
                
                }    
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please Enter Brand value'));
                    
                }
            }
            Else if(RecTypeValue=='Category')
            {
               if(CategoryValue!=null && CategoryValue!='')
               {
                    
                    category.name=CategoryValue;
                    category.Brand__c=null;
                    category.AF_Category_Brands__c=null;
                    category.AF_Brand_Logo__c=null;
                    upsert category;
                    ref=new pagereference('/'+category.id);
                    
                    
               }    
               else
               {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please Enter Category Value '));
                }           
            }
            
            
           
            return ref;
        }
        Catch(Exception ex)
        {
            apexpages.addmessages(ex);
            return null; 
        }
    }*/
}