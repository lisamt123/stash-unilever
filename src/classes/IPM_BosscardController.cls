/* Type Name: ipmBosscardController
Author: 
Created Date:
Reason: To meet requirements  REQ00005,REQ00006,REQ00352,REQ00360,REQ00363,REQ00364,REQ00367 and REQ00368 */

public class IPM_BosscardController 
{

    public IPM_BosscardController() {

    }

    //Initializing Variables    
    IPM_Project__c updatedProjectId;
    public User usr{get; set;}
    public IPM_Project__c project {get; set;}
    public IPM_Bosscard__c bosscard {get; set;}
    public List<IPM_Bosscard__c> listofProjectName{get; set;}
    public Boolean prjMsg{get; set;}
    public Boolean isNewWindow {get; set;}
    public Boolean isSave {get; set;}
    public String selBrand {get; set;}
    public String selBrandPos {get; set;}
    public String selGate {get; set;}
    public String selCat {get; set;}
    public String selSub {get; set;}    
    public Boolean isImage {get; set;}
    public Boolean isAccept {get; set;}
    public String ImageId {get; set;}
    public String expectedTLD {get;set;}
    public Boolean isNameMandatory{get;set;}
    public String bossId{get;set;}
    public String bosscardId;
    public IPM_Bosscard__c bosscard1 {get; set;}
    public IPM_Bosscard__c pdfRecord {get; set;}
    public String dupException;
    public Boolean isDuplicate{get; set;}
    public Boolean IdGenerated{get;set;}
    public string BossCUrl_ID{get;set;}
    public Boolean initialised{get; set;}
    public String ProjectID{get;set;}
    public Boolean isContainSpecialChars{get;set;}
    public string imgurl{get;set;}
    public string Status{get; set;}
    public boolean isEditable{get;set;}
    public list<IPM_User_Profile__c>CompanyCard=new list<IPM_User_Profile__c>();
    public list<IPM_User_Profile__c>lstGatekeeper=new list<IPM_User_Profile__c>();
    public boolean isPL{get;set;}
    public boolean gotopage{get;set;}
    public id selectedCompany{get;set;}
    public list<selectoption>lstCompany{get;set;}
    public string ProjectTabName{get;set;}
    public string SelectedCategory{get;set;}
    public string SlectedBrandP{get;set;}
    
    
    //Save Msg Variable
    public Boolean saveMsg{get;set;}
    //Initializing Constructor
    public IPM_BosscardController (ApexPages.StandardController controller)
    {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        project = new IPM_Project__c();
        isPL=false;
        gotopage=false;
        isNameMandatory=false;
        BossCUrl_ID='';
        initialised=false;
        ProjectID='';
        isContainSpecialChars=false;
        imgurl=System.Label.IPM_image;
        //Getting Bosscard Id from URL
        bosscardId = ApexPages.currentPage().getParameters().get('Id');
        System.debug(bosscardId+'Coming Constructor');
        BossCUrl_ID=ApexPages.currentPage().getParameters().get('Id');
        if(BossCUrl_ID==null || BossCUrl_ID==''){
        isEditable=true;
        }
        isDuplicate=false;
        IdGenerated=false;
        if (bosscardId == null)
        {
            bosscard = new IPM_Bosscard__c();
        } 
        else 
        {
            bossId=bosscardId ;
            bosscard = ipmSoqlUtilities.getBosscardMap(bosscardId).get(bosscardId);
            selectedCompany=bosscard.IPM_Company_Card__c;
            selCat= bosscard.IPM_Category__c;
            selBrandPos=bosscard.IPM_Brand_Positioning__c;
            pdfRecord=[Select Id,IPM_Category__c,CreatedById,CreatedBy.Name,IPM_Bosscard_Logo_Id__c,IPM_Bosscard_Status__c,IPM_Bosscard_Approver_Comments__c,IPM_Filled_In_Percent__c,IPM_BosscardName__c,IPM_Target_Launch_Date__c,IPM_Bosscard_Logo__c,IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c from IPM_Bosscard__c where Id=:bosscardId];
            Status=pdfRecord.IPM_Bosscard_Status__c;
            
            System.debug('PDF Chatter Data'+pdfRecord);
            usr=[SELECT Id,IPM_Brand_Name__c,IPM_Category__c,IPM_Role__c,Name FROM User where Id=:UserInfo.getUserId()];
        }
        
        listofProjectName=[select id,name,IPM_BosscardName__c from IPM_Bosscard__c where IPM_BosscardName__c !='' and id !=:ProjectID limit 999];
        isSave=false; 
        isAccept=false;
        
        //Getting Image Id from URL
        ImageId=ApexPages.currentPage().getParameters().get('image');
        if(ImageId!=null && ImageId!='')
        {
            isImage=true;
            bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
        }
        string CCardid='';
        CompanyCard=[select IPM_Company_Card__c,IPM_Project_Leader__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid()];
            if(CompanyCard.size()>0){
                CCardid=CompanyCard[0].IPM_Company_Card__c;   
             }
           if(CCardid !=''){
            lstGatekeeper=[select IPM_User__c from IPM_User_Profile__c where IPM_Company_Card__c=:CCardid];
            }
    getIpmuserType();
    }
/* Type Name: getStatusValue()
Author: 
Parameter(s)
ReturnType: List
Reason: For getting Bosscard Status Values*/  
    public List<SelectOption> getStatusValue(){
            Schema.sObjectType sobject_type = IPM_Bosscard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_Bosscard_Status__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
      return options;
      }      
          
    /*
Type Name: getListOfQuarter()
Author: 
Parameter(s)
ReturnType: List
Reason: Values for Target Launch Period */
    public List<SelectOption> getListOfQuarter() {
        Date currentDate = system.today();
        Map<Integer, Integer> currQuarterMap = new Map<Integer, Integer>{1 => 1, 
            2  => 1,
            3  => 1,
            4  => 2,
            5  => 2,
            6  => 2,
            7  => 3,
            8  => 3,
            9  => 3,
            10 => 4,
            11 => 4,
            12 => 4};
        try
        {
            List<SelectOption> options = new List<SelectOption>();
            for(Integer eachYear=currentDate.year(); eachYear <= currentDate.year()+5;eachYear++) {
                for(Integer eachQuarter=1; eachQuarter <= 4;eachQuarter++) {
                    if(eachYear == currentDate.year() 
                            && eachQuarter<currQuarterMap.get(currentDate.month())) {
                        continue;
                    }else {
                        options.add(new SelectOption('Q'+eachQuarter+' '+eachYear,'Q'+eachQuarter+' '+eachYear));
                    }
                }
            }
            return options;
        }
        catch(Exception e)
        {
            return null;
        }
    }

    /* Type Name: getBrands()
Author: 
Parameter(s)
ReturnType: List
Reason: Getting List of Brands */
    public List<SelectOption> getBrands()
    {   
        try
        {
            List<Selectoption> optns=new List<Selectoption>(); 

            List<User> userBrand=[select id, IPM_Brand_Name__c from User where Id=: UserInfo.getUserId() and IPM_Brand_Name__c!='' ];
            
            for(User u:userBrand)
            {
                String[] brandName=u.IPM_Brand_Name__c.split(';');
                for(Integer i=0;i<brandName.size();i++)
                {
                    optns.add(new Selectoption(brandName[i],brandName[i]));
                }
            }   
            
            return optns;
        }
        catch(Exception e)
        {
            return null;
        }    
    }
    
    /* Type Name: getBrandPos()
Author: 
Parameter(s)
ReturnType: List
Reason: Getting List of Brand Positionings */   
    public List<SelectOption> getBrandPos()
    {
        try
        {
             system.debug('selCat.....'+selCat);
            List<Selectoption> optns=new List<Selectoption>(); 
            string CatName='';
            set<string>UniqueBrandP=new set<string>();
            if(selCat.equals('HHC')){
            CatName='Household Care';
            }else{
            CatName=selCat;
            }
            system.debug('CatName.....'+CatName);
            optns.add(new Selectoption('' ,'Select Brand Positioning' ));
            List<mdm_Brand_Position__c> userBrandPos=[select id, Brand_Position_Name__c from mdm_Brand_Position__c where Category_Name__c=: CatName and Brand_Position_Name__c !='' ];
            if(!userBrandPos.isEmpty())
            {
                for(mdm_Brand_Position__c u:userBrandPos)
                {
                    UniqueBrandP.add(u.Brand_Position_Name__c);
                   
                } 
                for(string BrandPos:UniqueBrandP){
                 optns.add(new Selectoption(BrandPos ,BrandPos ));
                }           
            }
            return optns;
        }
        catch(Exception e)
        {
            return null;
        }
    }

    /* Type Name: getBrandPos()
Author: 
Parameter(s)
ReturnType: List
Reason: Getting List of Gatekeepers */     
    public List<SelectOption> getGates()
    {
        try
        {
            List<Selectoption> optns=new List<Selectoption>(); 

            List<IPM_User_Profile__c > userGate=[select id,IPM_User__c,IPM_User__r.name from IPM_User_Profile__c where IPM_User_Function__c='Gatekeeper'];
            if(!userGate.isEmpty())
            {
                for(IPM_User_Profile__c u:userGate)
                {
                    optns.add(new Selectoption(u.IPM_User__c,u.IPM_User__r.name));
                }   
            }
            return optns;
        }
        catch(Exception e)
        {
            return null;
        }
    }
    
    /* Type Name: getCategory()
Author: 
Parameter(s)
ReturnType: List
Reason: Getting List of Categories */    
    public List<SelectOption> getCategory()
    {   
        try
        {
            List<Selectoption> optns=new List<Selectoption>(); 

            List<IPM_Company_Card__c> userCat=[select id, IPM_Managed_category__c from IPM_Company_Card__c where Id=:selectedCompany and IPM_Managed_category__c !='' limit 1];
            optns.add(new Selectoption('','Select Category'));
            if(!userCat.isEmpty())
            {
                String[] splitCatString = userCat[0].IPM_Managed_category__c.split(';');
                for(string catg:splitCatString)
                {
                    optns.add(new Selectoption(catg,catg));
                }   
            }
            return optns;
        }
        catch(Exception e)
        {
            return null;
        }
    }
 public List<SelectOption> getAllcompanycard()
     {
       
       lstCompany= new List<SelectOption>();
       lstCompany.add(new selectoption('','Select Company Card'));
       List<IPM_User_Profile__c> ipmcompanycard=[select ID,IPM_Company_Card__c,IPM_Company_Card__r.name from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() and  IPM_Company_Card__c <>null and IPM_Company_Card__r.name!=null order by IPM_Company_Card__r.name ASC]; 
        if(ipmcompanycard.size()>0)
        {
             for(IPM_User_Profile__c pro:ipmcompanycard)
              {
                  lstCompany.add(new selectoption(pro.IPM_Company_Card__c,pro.IPM_Company_Card__r.name));
              }
              
        }
        return lstCompany;
    }  
    /*  Type Name: getSubCategory()
Author: 
Parameter(s)
ReturnType: List
Reason: Getting List of Sub-Categories */    
    public List<SelectOption> getSubCategory()
    {
        try
        {
            List<Selectoption> optns=new List<Selectoption>(); 

            List<User> userSubCat=[select id, IPM_Sub_Category__c from User where Id=: UserInfo.getUserId() and IPM_Sub_Category__c!=''];
            if(!userSubCat.isEmpty())
            {
                for(User u:userSubCat)
                {
                    optns.add(new Selectoption(u.IPM_Sub_Category__c,u.IPM_Sub_Category__c));
                }   
            }
            return optns;
        }
        catch(Exception e)
        {
            return null;
        }
    }
    
    /* Type Name: save()
Author: 
Parameter(s)
ReturnType: void
Reason: For Saving the Project and Bosscard */     
    public void save()
    {
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
        {
            System.debug(isNameMandatory+'isNameMandatory');
            isNameMandatory=true;             
        }
        else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
        }                        
        else {
            try
            {
                Integer count=0;
                if(bosscard.IPM_Assumptions__c.length()>15)
                count++;
                if(bosscard.IPM_Background__c.length()>15)
                count++;
                if(bosscard.IPM_Constraints__c.length()>15)
                count++;
                if(bosscard.IPM_Consumer_Need__c.length()>15)
                count++;
                if(bosscard.IPM_Deliverables__c.length()>15)
                count++;
                if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                count++;
                if(bosscard.IPM_Resources__c.length()>15)
                count++;
                if(bosscard.IPM_Scope__c.length()>15)
                count++;
                if(bosscard.IPM_Sustainibility__c.length()>15)
                count++;
                bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);
                list<IPM_Bosscard__c>Bossupdatedlst=new list<IPM_Bosscard__c>();
                Bossupdatedlst=new list<IPM_Bosscard__c>();
                isNameMandatory=false;
                isSave=true;      
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                bosscard.IPM_Is_Archived__c=false;
                bosscard.IPM_Company_Card__c=selectedCompany;
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                system.debug('BossID............'+BossCUrl_ID);
                bosscard.id=BossCUrl_ID;
                if(bosscard.id!=null)
                {
                    Bossupdatedlst.add(bossCard);
                    update Bossupdatedlst;
                }

                isSave=true; 
                isAccept=false;
                saveMsg=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
                
                
            } 
            catch(Exception e)
            {
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists));  
                e.getMessage();
    
            }
            
        }
        
    }
    /* Type Name: exportToPdf()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: To Craete PDF for Bosscard */     
    public PageReference exportToPdf()
    {   
        ApexPages.getMessages().clear();   
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
        {
            System.debug(isNameMandatory+'isNameMandatory');
            isNameMandatory=true; 
            return null;    
        }
        else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
            return null;
        }                        
        else {
            try
            {
                isNameMandatory=false;
                isSave=true;    
                Integer count=0;
                if(bosscard.IPM_Assumptions__c.length()>15)
                count++;
                if(bosscard.IPM_Background__c.length()>15)
                count++;
                if(bosscard.IPM_Constraints__c.length()>15)
                count++;
                if(bosscard.IPM_Consumer_Need__c.length()>15)
                count++;
                if(bosscard.IPM_Deliverables__c.length()>15)
                count++;
                if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                count++;
                if(bosscard.IPM_Resources__c.length()>15)
                count++;
                if(bosscard.IPM_Scope__c.length()>15)
                count++;
                if(bosscard.IPM_Sustainibility__c.length()>15)
                count++;
                bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);  
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                bosscard.IPM_Is_Draft__c = true;                
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                bosscard.id=BossCUrl_ID;
                update bossCard;
                bossId=bosscard.id;
                PageReference url = null;
                url = Page.IPM_ExportBosscardPDF;
                url.setRedirect(false);
                bosscardData(bosscard.Id);
                return url;
            }
            catch(Exception e)
            {
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                return null;
            }       
        }  
    }   
    /* Type Name: archive()
Author: 
Parameter(s)
ReturnType: void 
Reason: For Archieving Bosscard */     
    public void archive() {
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
        {
            System.debug(isNameMandatory+'isNameMandatory');
            isNameMandatory=true;             
        }
        else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
        }                        
        else {
            try
            {
                isNameMandatory=false;
                isSave=true;
                Integer count=0;
                if(bosscard.IPM_Assumptions__c.length()>15)
                count++;
                if(bosscard.IPM_Background__c.length()>15)
                count++;
                if(bosscard.IPM_Constraints__c.length()>15)
                count++;
                if(bosscard.IPM_Consumer_Need__c.length()>15)
                count++;
                if(bosscard.IPM_Deliverables__c.length()>15)
                count++;
                if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                count++;
                if(bosscard.IPM_Resources__c.length()>15)
                count++;
                if(bosscard.IPM_Scope__c.length()>15)
                count++;
                if(bosscard.IPM_Sustainibility__c.length()>15)
                count++;
                bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);      
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                bosscard.IPM_Is_Draft__c = false;
                bosscard.IPM_Is_Archived__c=true;
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                if(BossCUrl_ID!=Null){
                    bosscard.id=BossCUrl_ID;
                    update bossCard;
                }
                project.id=ProjectId;
                project.IPM_Project_Name__c=bosscard.IPM_BosscardName__c;
                project.IPM_Project_Leader__c=UserInfo.getUserId();
                project.IPM_Brand__c=selBrand;
                project.IPM_Category_Text__c=selCat;
                project.IPM_Sub_Category__c=selSub;
                project.IPM_Brand_Positioning__c=selBrandPos;
                project.IPM_Project_Gatekeeper__c=selGate;
                project.IPM_Target_Launch_Date__c=expectedTLD;
                project.IPM_Bosscard__c=BossCUrl_ID;
                project.Is_Archieved__c=true;
                
                //If project name contains brand name and estimated LTD 
                if((selBrand !=null && project.IPM_Project_Name__c.contains(selBrand)) || project.IPM_Project_Name__c.contains(expectedTLD))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.Project_Name_Contains_Brand_Name_Target_Launch_Date));
                    //return null;
                } 
                if(ImageId!='' && ImageId!=null)
                {
                    project.IPM_Project_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    project.IPM_Project_Logo_Id__c=ImageId;
                }
                update project;
                bossId=bosscard.id;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Saved_Archives));
            }   
            catch(Exception e)
            {
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
            }               
        }  
        
        
    }
    /* Type Name: shareViaChatter()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: For Sharing Bosscard through Chatter */  
    public PageReference shareViaChatter(){
        //If project is not saved yet
        if(isSave==false && bosscard.IPM_Is_Accepted__c==false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.IPM_Bosscard_Save_Before_Share));
            return null;
        }    
        else
        {
            //If project name is null show warning message
            if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
            {
                System.debug(isNameMandatory+'isNameMandatory');
                isNameMandatory=true;      
                return null;    
            }
            else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
                isNameMandatory=false;
                isContainSpecialChars=true;
                return null;
            }                        
            else {
                try
                {
                    isNameMandatory=false;
                    isSave=true;
                    Integer count=0;
                    if(bosscard.IPM_Assumptions__c.length()>15)
                    count++;
                    if(bosscard.IPM_Background__c.length()>15)
                    count++;
                    if(bosscard.IPM_Constraints__c.length()>15)
                    count++;
                    if(bosscard.IPM_Consumer_Need__c.length()>15)
                    count++;
                    if(bosscard.IPM_Deliverables__c.length()>15)
                    count++;
                    if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                    count++;
                    if(bosscard.IPM_Resources__c.length()>15)
                    count++;
                    if(bosscard.IPM_Scope__c.length()>15)
                    count++;
                    if(bosscard.IPM_Sustainibility__c.length()>15)
                    count++;
                    bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);      
                    bosscard.IPM_Brand__c=selBrand;
                    bosscard.IPM_Category__c=selCat;
                    bosscard.IPM_Brand_Positioning__c=selBrandPos;
                    bosscard.IPM_Gate_Keeper__c=selGate;
                    bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                    bosscard.IPM_Is_Draft__c = false;
                    bosscard.IPM_Is_Archived__c=false;
                     bosscard.IPM_Company_Card__c=selectedCompany;
                    if(ImageId!='' && ImageId!=null)
                    {
                        bosscard.IPM_Bosscard_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                        bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                    }
                    if(BossCUrl_ID!=Null){
                        bosscard.id=BossCUrl_ID;
                        update bossCard;
                    }       
                    IPM_Bosscard__c BD =[select Id,IPM_BosscardName__c,IPM_Bosscard_Status__c,IPM_Bosscard_Approver_Comments__c,IPM_Filled_In_Percent__c,IPM_Target_Launch_Date__c,IPM_Bosscard_Logo__c,IPM_Bosscard_Logo_Id__c,IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c from IPM_Bosscard__c  where id=: BossCUrl_ID];
                    System.debug('Chatter Data'+BD);
                    //Sharing Bosscard pdf through chatter
                    if(BD!=null)          
                    { 
                        PageReference PR=Page.IPM_ExportBosscardPDF;
                        PR.getParameters().put('id',BD.Id);
                        PR.getParameters().put('image',ImageId);
                        blob pdf = PR.getContent();
                        feeditem a = new feeditem();
                        a.ContentData = pdf;
                        System.debug(pdf+'pdfdata'+PR.getcontentasPDF());
                        a.Type = 'ContentPost';
                        a.ContentFileName = BD.IPM_BosscardName__c+'_BOSSCARD-'+system.today().format()+'.pdf';
                        a.Title=BD.IPM_BosscardName__c+'_BOSSCARD-'+system.today().format()+'.pdf';
                        a.parentid = UserInfo.getUserId();
                        try {
                            insert a;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Bosscard_Shared_Chatter));
                        }
                        catch (Exception e)
                        {
                            return null;
                        }        
                        return null;       
                    }                    
                    return null;
                }
                catch(Exception e)
                {
                    if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                    return null;
                }
            }
            
        }  
    }
    /* Type Name: beforeAccept()
Author: 
Parameter(s)
ReturnType: void 
Reason: For Self-Approval of Bosscard  */ 
    public void beforeAccept(){
        isNameMandatory=false;
        isContainSpecialChars=false;
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null) {
            isNameMandatory=true;
        }
        if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
        }    
    }
    
    /* Type Name: accept()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: For Self-Approval of Bosscard  */ 
    public PageReference accept(){        
        ApexPages.getMessages().clear();   
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
        {
            System.debug(isNameMandatory+'isNameMandatory');
            isNameMandatory=true;    
            return null;    
        }
        else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
            return null;
        }                        
        else {
            try
            {
                isNameMandatory=false;
                isSave=true;
                Integer count=0;
                if(bosscard.IPM_Assumptions__c.length()>15)
                count++;
                if(bosscard.IPM_Background__c.length()>15)
                count++;
                if(bosscard.IPM_Constraints__c.length()>15)
                count++;
                if(bosscard.IPM_Consumer_Need__c.length()>15)
                count++;
                if(bosscard.IPM_Deliverables__c.length()>15)
                count++;
                if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                count++;
                if(bosscard.IPM_Resources__c.length()>15)
                count++;
                if(bosscard.IPM_Scope__c.length()>15)
                count++;
                if(bosscard.IPM_Sustainibility__c.length()>15)
                count++;
                bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);      
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                bosscard.IPM_Is_Draft__c = false;
                bosscard.IPM_Is_Accepted__c=true;
                bosscard.IPM_Is_Archived__c=false;
                 bosscard.IPM_Company_Card__c=selectedCompany;
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                if(BossCUrl_ID!=Null){
                    bosscard.id=BossCUrl_ID;
                    update bossCard;
                }       
                
                project.id=ProjectId;
                project.IPM_Project_Name__c=bosscard.IPM_BosscardName__c;
                project.IPM_Project_Leader__c=UserInfo.getUserId();
                project.IPM_Brand__c=selBrand;
                project.IPM_Category_Text__c=selCat;
                project.IPM_Sub_Category__c=selSub;
                project.IPM_Brand_Positioning__c=selBrandPos;
                project.IPM_Project_Gatekeeper__c=selGate;
                project.IPM_Target_Launch_Date__c=expectedTLD;
                project.IPM_Bosscard__c=BossCUrl_ID;
                if(lstGatekeeper.size()>0){
                  project.IPM_Project_Gatekeeper__c=lstGatekeeper[0].IPM_User__c;
                 }
                 if(CompanyCard.size()>0){
                  project.IPM_Company_Card__c=CompanyCard[0].IPM_Company_Card__c;
                 }
                //If project name contains brand name and estimated LTD 
                if((selBrand !=null && project.IPM_Project_Name__c.contains(selBrand)) || project.IPM_Project_Name__c.contains(expectedTLD))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.Project_Name_Contains_Brand_Name_Target_Launch_Date));
                    return null;
                } 
                if(ImageId!='' && ImageId!=null)
                {
                    project.IPM_Project_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    project.IPM_Project_Logo_Id__c=ImageId;
                }
                update project;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
                return null;
            }
            Catch(Exception e)
            {
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                return null;
            }
        }
        
    }   
    
    /* Type Name: ProjectIdGeneration()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: For Self-Approval of Bosscard  */   
    public PageReference ProjectIdGeneration()
    {
        try
        {   
            Boolean isBosscardUpdated=false;
            if(bosscard.IPM_BosscardName__c !=null && bosscard.IPM_BosscardName__c!='')
            {
                isNameMandatory=false;
                isSave=true;      
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                if(BossCUrl_ID!=Null){
                    bosscard.id=BossCUrl_ID;
                    update bossCard;
                    isBosscardUpdated=true;
                }
                project.id=ProjectId;
                project.IPM_Project_Name__c=bosscard.IPM_BosscardName__c;
                project.IPM_Project_Leader__c=UserInfo.getUserId();
                project.IPM_Brand__c=selBrand;
                project.IPM_Category_Text__c=selCat;
                project.IPM_Sub_Category__c=selSub;
                project.IPM_Brand_Positioning__c=selBrandPos;
                project.IPM_Project_Gatekeeper__c=selGate;
                project.IPM_Target_Launch_Date__c=expectedTLD;
                project.IPM_Bosscard__c=BossCUrl_ID;
                if(ImageId!='' && ImageId!=null)
                {
                    project.IPM_Project_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    project.IPM_Project_Logo_Id__c=ImageId;
                }
                if(BossCUrl_ID!=Null && isBosscardUpdated==true){
                    updatedProjectId=[Select Id from IPM_Project__c where IPM_Bosscard__c=:BossCUrl_ID Limit 1];
                    project.Id=updatedProjectId.Id;
                    update project;
                }
            }   
            return null;
        }
        catch(DMLException e)
        {
            if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
            {   
                System.debug('hi exception'+e.getMessage()+IPM_ConstantUtils.DUPLICATE_EXCEPTION+System.Label.IPM_Project_Name_Exists);
            }
            return null;
        }
    }
    
    /* Type Name: bosscardData()
Author: 
Parameter(s): Id
ReturnType: PageReference 
Reason: For Exporting Bosscard Data in PDF  */
    public void bosscardData(Id bId)
    {
        system.debug('here...');
        pdfRecord=[Select Id,IPM_Category__c,IPM_BosscardName__c,CreatedById,CreatedBy.Name,IPM_Bosscard_Status__c,IPM_Bosscard_Approver_Comments__c,IPM_Filled_In_Percent__c,IPM_Bosscard_Logo_Id__c,IPM_Target_Launch_Date__c,IPM_Bosscard_Logo__c,IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c from IPM_Bosscard__c where Id=:bId];
        
        usr=[SELECT Id,IPM_Brand_Name__c,IPM_Category__c,IPM_Role__c,Name FROM User where Id=:UserInfo.getUserId()];
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+Bosscard.IPM_BosscardName__c+'_BOSSCARD-'+system.today().format()+'.pdf');
    }
    public void showMsg()
    {
        System.debug('Entering Empty Method');
        // isNameMandatory=true;
        if(bossId == ''  || bossId == null)
        
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Please Save the Bosscard Name before any other activity'));
        }
    }
    //onload create bosscard and project
    public void createBossCAndproject()
    {
        BossCUrl_ID=ApexPages.currentPage().getParameters().get('Id');
        if (!initialised){
            if(BossCUrl_ID =='' || BossCUrl_ID==Null){
                list <IPM_Bosscard__c> lstofemptybossCname=new list<IPM_Bosscard__c>();
                lstofemptybossCname=[select name from IPM_Bosscard__c where IPM_BosscardName__c =:'' and CreatedBy.ID=:UserInfo.getUserId()];
                list <IPM_Project__c> lstofemptyProjectname=new list<IPM_Project__c>();
                Set<string>bossIDtoDelete=new set<string>();
                for(IPM_Bosscard__c  BC:lstofemptybossCname){
                    bossIDtoDelete.add(BC.id);
                }
                
                lstofemptyProjectname=[select name from IPM_Project__c where IPM_Bosscard__c=:bossIDtoDelete ];
                if(lstofemptyProjectname.size()>0){
                    delete lstofemptyProjectname;
                }
                
                if(lstofemptybossCname.size()>0){
                    delete lstofemptybossCname;
                }
                bosscard=new IPM_Bosscard__c ();
                project = new IPM_Project__c();
                insert bosscard;
                BossCUrl_ID =bosscard.id;
                project.IPM_Bosscard__c=bosscard.id;
                project.IPM_Project_Leader__c=userinfo.getuserid();
                project.IPM_Phase__c='';
                insert project;
                ProjectId= project.id;
                IdGenerated=true;
                initialised=true;
            }else{
                project = new IPM_Project__c();
                project=[select id,IPM_Project_Name__c  from IPM_Project__c where IPM_Bosscard__c=:BossCUrl_ID];
                ProjectId=project.id;    
                IdGenerated=true;
                initialised=true;
            }
        }
    getIpmuserType();
    } 
    public PageReference printBosscard()
    {
        System.debug('Entering');
        ApexPages.getMessages().clear();   
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
        {
            System.debug(isNameMandatory+'isNameMandatory');
            isNameMandatory=true;  
            return null;    
        }
        else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
            return null;
        }                        
        else {
            try
            {
                isNameMandatory=false;
                isSave=true;
                Integer count=0;
                if(bosscard.IPM_Assumptions__c.length()>15)
                count++;
                if(bosscard.IPM_Background__c.length()>15)
                count++;
                if(bosscard.IPM_Constraints__c.length()>15)
                count++;
                if(bosscard.IPM_Consumer_Need__c.length()>15)
                count++;
                if(bosscard.IPM_Deliverables__c.length()>15)
                count++;
                if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                count++;
                if(bosscard.IPM_Resources__c.length()>15)
                count++;
                if(bosscard.IPM_Scope__c.length()>15)
                count++;
                if(bosscard.IPM_Sustainibility__c.length()>15)
                count++;
                bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);      
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                System.debug(ImageId+'Image Id from Export to PDF');
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                bosscard.id=BossCUrl_ID;
                update bossCard;
                PageReference url = new PageReference('/apex/ipmPrintBosscard?id='+bosscard.Id);
                url.setRedirect(false);
                return url;
            }
            catch(Exception e)
            {
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                return null;
            }   
        }
    } 
    public PageReference cancel()
    {
        PageReference url;
        if (bosscard.IPM_IsSaved__c == false){  
            System.debug('coming inside');
            IPM_Project__c delProj=[Select Id from IPM_Project__c where IPM_Bosscard__c=:bosscard.Id];
            IPM_Bosscard__c delBosscard=[Select Id from IPM_Bosscard__c where Id=:bosscard.Id];
            //delete delProj;
           // delete delBosscard;     
            url=new PageReference('/apex/ipmHomeRevamp2');
            return url;
        }   
        else if(bosscardId!=null)
        {
            System.debug('coming inside here');
            url=new PageReference('/apex/ipmBosscard_revamp?id='+bosscardId);
            return url;
        }   
        System.debug('coming nowhere'+bosscard.IPM_IsSaved__c+bosscardId);
        return null;
    }
    public void updateStatus()
    {
        System.debug('Insideeeeeee'+bosscard.Id+''+bosscard.IPM_BosscardName__c);
        IPM_Bosscard__c boss=[Select Id,IPM_BosscardName__c,IPM_Bosscard_Status__c from IPM_Bosscard__c where Id=:bosscard.Id];
        if(status=='In Progress')
        {
            boss.IPM_Bosscard_Status__c=status;
            update boss;
        }
        else if(status=='Not Approved')
        {
            boss.IPM_Bosscard_Status__c=status;
            update boss;
        }
        else if(status=='Approved')
        {
            boss.IPM_Bosscard_Status__c=status;
            boss.IPM_BosscardName__c=bosscard.IPM_BosscardName__c;
            update boss;
            accept();
        }
        else if(status=='Discard')
        {
            boss.IPM_Bosscard_Status__c=status;
            update boss;
            archive();
        }
       /* if(bosscard.IPM_Bosscard_Status__c=='In Progress')
        {
            update bosscard;
        }
        else if(bosscard.IPM_Bosscard_Status__c=='Not Approved')
        {
            update bosscard;
        }
        else if(bosscard.IPM_Bosscard_Status__c=='Approved')
        {
            accept();
        }
        else if(bosscard.IPM_Bosscard_Status__c=='Discard')
        {
            archive();    
        }*/
    }
 //Delete bosscard when we skip
 public void DeleteBosscard(){
    IPM_Project__c UpdateProject =new IPM_Project__c();//[Select Id from IPM_Bosscard__c where Id=:bosscard.Id];
    UpdateProject.id=ProjectId;
    UpdateProject.IPM_Project_Name__c=bosscard.IPM_BosscardName__c;
    UpdateProject.IPM_Project_Leader__c=UserInfo.getUserId();
    UpdateProject.IPM_Brand__c=selBrand;
    UpdateProject.IPM_Category_Text__c=selCat;
    UpdateProject.IPM_Sub_Category__c=selSub;
    UpdateProject.IPM_Brand_Positioning__c=selBrandPos;
    UpdateProject.IPM_Project_Gatekeeper__c=selGate;
    UpdateProject.IPM_Target_Launch_Date__c=expectedTLD;
    update UpdateProject;
 }   
// Get user type with access permission
public void getIpmuserType(){
if(BossCUrl_ID!='' || BossCUrl_ID!=null){
 list<IPM_Bosscard__c >lstBooslCreatedBy=[select name from IPM_Bosscard__c where id=:BossCUrl_ID and CreatedBy.ID=:UserInfo.getUserId()];
 if(lstBooslCreatedBy.size()>0){
     isEditable=true;
 }
}
list<IPM_User_Profile__c>lstuserprofile=[select id,IPM_User_Role__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() limit 1];

if(lstuserprofile.size()>0){
    if(lstuserprofile[0].IPM_User_Role__c =='Reporting'){
    isEditable=false;
    }else{
    isEditable=true;
    }
}
 
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPMNG_Business_Partner'
                                       or PermissionSet.Name='IPM_ProjectLeader'    ) and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isEditable=true;
 isPL=true;
 gotopage=true;
}                                       

                                       
 }    
   /* Type Name: autosave()
Author: 
Parameter(s)
ReturnType: void
Reason: For Auto Saving the Project and Bosscard     */

    public void autosave()
    {
    
        //If project name is null show warning message
        if(bosscard.IPM_BosscardName__c=='' || bosscard.IPM_BosscardName__c==null)
        {
            System.debug(isNameMandatory+'isNameMandatory');
            isNameMandatory=true;             
        }
        else if(!Pattern.matches('[a-zA-Z0-9 ]+',bosscard.IPM_BosscardName__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
        }                        
        else {
            try
            {
                Integer count=0;
                if(bosscard.IPM_Assumptions__c.length()>15)
                count++;
                if(bosscard.IPM_Background__c.length()>15)
                count++;
                if(bosscard.IPM_Constraints__c.length()>15)
                count++;
                if(bosscard.IPM_Consumer_Need__c.length()>15)
                count++;
                if(bosscard.IPM_Deliverables__c.length()>15)
                count++;
                if(bosscard.IPM_Potential_Business_Opportunity__c.length()>15)
                count++;
                if(bosscard.IPM_Resources__c.length()>15)
                count++;
                if(bosscard.IPM_Scope__c.length()>15)
                count++;
                if(bosscard.IPM_Sustainibility__c.length()>15)
                count++;
                bosscard.IPM_Filled_In_Percent__c=Math.round((Decimal.valueOf(count)/9.0)*100);
                list<IPM_Bosscard__c>Bossupdatedlst=new list<IPM_Bosscard__c>();
                Bossupdatedlst=new list<IPM_Bosscard__c>();
                isNameMandatory=false;
                isSave=true;      
                bosscard.IPM_Brand__c=selBrand;
                bosscard.IPM_Category__c=selCat;
                bosscard.IPM_Brand_Positioning__c=selBrandPos;
                bosscard.IPM_Gate_Keeper__c=selGate;
                bosscard.IPM_Target_Launch_Date__c=expectedTLD;
                bosscard.IPM_Is_Archived__c=false;
                 bosscard.IPM_Company_Card__c=selectedCompany;
                if(ImageId!='' && ImageId!=null)
                {
                    bosscard.IPM_Bosscard_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    bosscard.IPM_Bosscard_Logo_Id__c=ImageId;
                }
                system.debug('BossID............'+BossCUrl_ID);
                bosscard.id=BossCUrl_ID;
                if(bosscard.id!=null)
                {
                    Bossupdatedlst.add(bossCard);
                    update Bossupdatedlst;
                }

                isSave=true; 
                isAccept=false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
                
            } 
            catch(Exception e)
            {
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists));  
                e.getMessage();
       
            }
            
        }
      
       
    }
    
    public void hideSaveMsg()
    {
        saveMsg=false;
    }
    public void searchprojectpahse(){
        getCategory();
    }
    public void getBrandposition(){
        getbrandPos();
    }
}