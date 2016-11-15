public class AF_FieldHistoryCompController {

    public String ParentRecordId {get;set;}
    public String ParentObjectType {get;set;} 
    public List<AF_Agency_Estimate__History> AgencyEstimateHistoryCollection {get;set;}
    public List<AF_OOPS_Estimate__History> OOPSEstimateHistoryCollection {get;set;}
    public List<AF_Bonus_Matrix__History> BonusMatrixHistoryCollection {get;set;} 
    public List<AF_Controller_Review__History> ControllerReviewHistoryCollection {get;set;} 
    public List<WrapperHistory> wrp {get;set;}
    public String IsViewAll{get;set;}
    public Boolean IsViewAllLink{get;set;}
    public String IsViewAllValue{get;set;}
    private string SOQLFields;
    public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
   /* public String getParentRecordId(){ return ParentRecordId; }
    public void setParentRecordId(String s){
        ParentRecordId = s;
        
    }
    public String getParentObjectType(){ return ParentObjectType; }
    public void setParentObjectType(String s){
        ParentObjectType = s;
    }
    public String getIsViewAll(){ return IsViewAll; }
    public void setIsViewAll(String s){
        IsViewAll = s;
        AF_FieldHistoryCompController();
    }*/
    public List<WrapperHistory> getFieldHistoryList()
    {
            
            system.debug('ParentRecordId.....'+ParentRecordId);
            system.debug('ParentObjectType.....'+ParentObjectType);
            System.debug('IsViewAll: ' + IsViewAll);
            string parentURL = ApexPages.currentPage().getUrl();
            System.debug('parentURL: ' + parentURL);
            if(ApexPages.currentPage().getParameters().get('CHParentId') != null){ParentRecordId = ApexPages.currentPage().getParameters().get('CHParentId');}
            User userObj = new User();
            userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
            if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
                isAgencyFlag=true;
            }              
            wrp = new List<WrapperHistory>();
            string type; 
            Schema.SObjectType objSchema;
            Map<String, Schema.SObjectField> fieldMap;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

         String oldvaluestring;
                        String newvaluestring; 
                        double oldvalueno;
                        double newvalueno;
        List<String> args = new String[]{'0','number','###,###,##0.00'};
            
        try
        {
          
            if(ParentObjectType == 'AF_Agency_Estimate__c')
            {
                system.debug('inside AF_Agency_Estimate__c');
                ParentObjectType = 'AF_Agency_Estimate__c';  
                System.debug('ParentObjectType: ' + ParentObjectType);              
                if(IsViewAll == 'true')
                {
                    AgencyEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Agency_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC ];
                    IsViewAllLink = false;
                    system.debug('AgencyEstimateHistoryCollection...'+AgencyEstimateHistoryCollection);
                }
                else
                {
                    AgencyEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Agency_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5];
                    IsViewAllLink = true;
                    system.debug('AgencyEstimateHistoryCollection...'+AgencyEstimateHistoryCollection);
                }
                
                for(AF_Agency_Estimate__History afaeh : AgencyEstimateHistoryCollection)
                {
                    if(afaeh.OldValue != null)
                    {
                    WrapperHistory wh = new WrapperHistory();
                    wh.CreatedBy = afaeh.CreatedBy.Name;
                    wh.CreatedDate = afaeh.CreatedDate; 
                    wh.FieldName =  afaeh.Field;
                    wh.OldValue =  afaeh.OldValue; 
                    wh.NewValue =  afaeh.NewValue;                              
                   
                                //oldvaluestring=(String)afaeh.OldValue;
                                //newvaluestring =(String)afaeh.NewValue; 
                              
                                try{oldvalueno=double.valueOf(afaeh.OldValue);oldvaluestring = String.format(oldvalueno.format(), args);wh.OldValue =oldvaluestring;                    
                                }
                                    catch(TypeException te)
                                {
                                   wh.OldValue =  afaeh.OldValue; 
                                }
                                try{newvalueno=double.valueOf(afaeh.NewValue);newvaluestring = String.format(newvalueno.format(), args);wh.NewValue =newvaluestring;}
                                catch(TypeException te)
                                {
                                   wh.NewValue =  afaeh.NewValue; 
                                }                                              
                                objSchema = schemaMap.get(ParentObjectType);                
                                fieldMap = objSchema.getDescribe().fields.getMap();                                
                                wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
                                wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
                                wrp.add(wh);
                                
                    }
                } 
                    system.debug('wrp...'+wrp);
            }            
            else if(ParentObjectType == 'AF_OOPS_Estimate__c')
            {
                system.debug('inside AF_OOPS_Estimate__c');
                //ParentObjectType = 'AF_OOPS_Estimate__c';
                System.debug('ParentObjectType: ' + ParentObjectType);
                System.debug('ParentRecordId: ' + ParentRecordId);
                
                if(IsViewAll == 'true')
                {
                    OOPSEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_OOPS_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC];
                    IsViewAllLink = false;
                }
                else
                {
                OOPSEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_OOPS_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5];   
                IsViewAllLink = true;
                }
                
                System.debug('OOPSEstimateHistoryCollection: ' + OOPSEstimateHistoryCollection);
                
                for(AF_OOPS_Estimate__History oopseh : OOPSEstimateHistoryCollection)
                {
                    if(oopseh.OldValue != null)
                    {
                    WrapperHistory wh = new WrapperHistory();
                    wh.CreatedBy = oopseh.CreatedBy.Name;
                    wh.CreatedDate = oopseh.CreatedDate;
                    wh.FieldName =  oopseh.Field;
                    wh.OldValue =  oopseh.OldValue; 
                    wh.NewValue =  oopseh.NewValue;                             
                         //oldvaluestring=(String)afaeh.OldValue;
                        //newvaluestring =(String)afaeh.NewValue; 
                        try{
                        oldvalueno=double.valueOf(oopseh.OldValue);
                        oldvaluestring = String.format(oldvalueno.format(), args);
                        wh.OldValue =oldvaluestring;                    
                        }
                            catch(TypeException te)
                        {
                           wh.OldValue =  oopseh.OldValue; 
                        }
                        try{
                        newvalueno=double.valueOf(oopseh.NewValue);
                        newvaluestring = String.format(newvalueno.format(), args);
                        wh.NewValue =newvaluestring;
                        }
                        catch(TypeException te)
                        {
                           wh.NewValue =  oopseh.NewValue; 
                        }                                              
                        objSchema = schemaMap.get(ParentObjectType);                
                        fieldMap = objSchema.getDescribe().fields.getMap();                                
                        wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
                        wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
                        wrp.add(wh);
                    }
                } 
                system.debug('wrp...'+wrp);
            }
            else if(ParentObjectType == 'AF_Bonus_Matrix__c')               
            {
                system.debug('inside AF_Bonus_Matrix__c');
                ParentObjectType = 'AF_Bonus_Matrix__c';
                System.debug('ParentObjectType: ' + ParentObjectType);
                if(IsViewAll == 'true')
                {
                    BonusMatrixHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Bonus_Matrix__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC];
                    IsViewAllLink = false;
                }
                else
                {
                BonusMatrixHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Bonus_Matrix__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5]; 
                IsViewAllLink = true;
                }
                
                
                for(AF_Bonus_Matrix__History bmh : BonusMatrixHistoryCollection)
                {
                    if(bmh.OldValue != null)
                    {
                    WrapperHistory wh = new WrapperHistory();
                    wh.CreatedBy = bmh.CreatedBy.Name;
                    wh.CreatedDate = bmh.CreatedDate;
                    wh.FieldName =  bmh.Field;
                    wh.OldValue =  bmh.OldValue; 
                    wh.NewValue =  bmh.NewValue;                                
                        //oldvaluestring=(String)afaeh.OldValue;
                        //newvaluestring =(String)afaeh.NewValue; 
                        try{oldvalueno=double.valueOf(bmh.OldValue);oldvaluestring = String.format(oldvalueno.format(), args);wh.OldValue =oldvaluestring;                    
                        }
                            catch(TypeException te)
                        {
                           wh.OldValue =  bmh.OldValue; 
                        }
                        try{newvalueno=double.valueOf(bmh.NewValue);newvaluestring = String.format(newvalueno.format(), args);wh.NewValue =newvaluestring;}
                        catch(TypeException te)
                        {
                           wh.NewValue =  bmh.NewValue; 
                        }                                              
                        objSchema = schemaMap.get(ParentObjectType);                
                        fieldMap = objSchema.getDescribe().fields.getMap();                                
                        wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
                        wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
                        wrp.add(wh);
                    }
                }                           
            } 
            else if(ParentObjectType == 'AF_Controller_Review__c')               
            {
                system.debug('inside AF_Controller_Review__c');
                ParentObjectType = 'AF_Controller_Review__c';
                System.debug('ParentObjectType: ' + ParentObjectType);
                if(IsViewAll == 'true')
                {
                    ControllerReviewHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Controller_Review__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC];
                    IsViewAllLink = false;
                }
                else
                {
                ControllerReviewHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Controller_Review__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5]; 
                IsViewAllLink = true;
                }
                
                
                for(AF_Controller_Review__History bmh : ControllerReviewHistoryCollection)
                {
                    if(bmh.OldValue != null)
                    {
                    WrapperHistory wh = new WrapperHistory();
                    wh.CreatedBy = bmh.CreatedBy.Name;
                    wh.CreatedDate = bmh.CreatedDate;
                    wh.FieldName =  bmh.Field;
                    wh.OldValue =  bmh.OldValue; 
                    wh.NewValue =  bmh.NewValue;                                
                        //oldvaluestring=(String)afaeh.OldValue;
                        //newvaluestring =(String)afaeh.NewValue; 
                        try{oldvalueno=double.valueOf(bmh.OldValue);oldvaluestring = String.format(oldvalueno.format(), args);wh.OldValue =oldvaluestring;                    
                        }
                            catch(TypeException te)
                        {
                           wh.OldValue =  bmh.OldValue; 
                        }
                        try{newvalueno=double.valueOf(bmh.NewValue);newvaluestring = String.format(newvalueno.format(), args);wh.NewValue =newvaluestring;}
                        catch(TypeException te)
                        {
                           wh.NewValue =  bmh.NewValue; 
                        }                                              
                        objSchema = schemaMap.get(ParentObjectType);                
                        fieldMap = objSchema.getDescribe().fields.getMap();                                
                        wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
                        wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
                        wrp.add(wh);
                    }
                }                           
            }   
        }
        catch(Exception ex)
        {
            system.debug(ex);
        } 
            return wrp;
    }  
    
    public class WrapperHistory
    {
        public string FieldLabel {get;set;}
        public string FieldName {get;set;}
        public string Description {get;set;}
        public Object OldValue {get;set;}
        public Object NewValue {get;set;}
        public string CreatedBy {get;set;}
        public DateTime CreatedDate {get;set;}

    }
    
}