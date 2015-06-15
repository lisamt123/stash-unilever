/* Type Name: ipmProjectController
Author: 
Created Date:
Reason: To meet requirements  REQ00003 */

public class IPM_ProjectController{

    //Initializing Variables    
    IPM_Project__c updatedProjectId;
    public Boolean isContainSpecialChars{get; set;}
    public Boolean IdGenerated{get;set;}
    public IPM_Project__c project {get; set;}
    public String selCat {get; set;}
    public IPM_Project__c project1 {get; set;}
    public List<IPM_Project__c> listofProjectName {get; set;}
    public Boolean isImage {get; set;}
    public String ImageId {get; set;}
    public Boolean isNameMandatory{get;set;}
    public String expectedTLD {get;set;}
    public String ProId{get;set;}
    public String selBrand {get; set;}
    public String selBrandPos {get; set;}
    public String projectId{get; set;}
    public Boolean isSaved{get; set;}
    public User userCat{get;set;}
    public Boolean initialised{get; set;}
    public string imgurl{get;set;}
    public boolean isEditable{get;set;}
    public boolean IsSaveProject{get;set;}
    public list<IPM_User_Profile__c>CompanyCard=new list<IPM_User_Profile__c>();
    public String CompanyType{get;set;}
    public string ProjectPhase{get;set;}
    public boolean isCateMandatory{get;set;}
    public boolean isBrandPoMandatory{get;set;}
    public boolean isTLDMandatory{get;set;}
    public boolean isProDescMandatory{get;set;}
    public Boolean isTaskeditable{get;set;}
    public Boolean isAllTask{get;set;}
    public Boolean isMilestoneEditable{get;set;}
    public Boolean isBDuser{get;set;}
    public Boolean isupdateDates{get;set;}
    public string FunctionRole{get;set;}      
    public boolean isvisible{get;set;}
    public string ComplexityType{get;set;}
    public boolean isTaskgenerated{get;set;}
    public id selectedCompany{get;set;}
    public list<selectoption>lstCompany{get;set;}
    public string ProjectTabName{get;set;}
    
    //Initializing Constructor
    public IPM_ProjectController(ApexPages.StandardController controller){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        Initialise();
        
    }
//Initialise
public void Initialise(){
        ProId='';
        isEditable=false;
        isTaskgenerated=false;
        ComplexityType='';
        projectId='';
        IdGenerated=false;
        isContainSpecialChars=false;
        isCateMandatory=false;
        isBrandPoMandatory=false;
        isTLDMandatory=false;
        isProDescMandatory=false;
        isupdateDates=true;
        ProjectPhase='';
        ProjectTabName='';
        initialised=false;
        string UserID=UserInfo.getUserId();
        imgurl=System.Label.IPM_image;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Skip_Bosscard));
        projectId= ApexPages.currentPage().getParameters().get('Pid');
        //userCat=[select id, IPM_Category__c,IPM_Brand_Positioning__c from User where Id=: UserID and IPM_Category__c !='' limit 1];
        /*CompanyCard=[select IPM_Company_Card__c,IPM_Company_Card__r.RecordType.Name,IPM_Project_Leader__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid()];
        if(CompanyCard.size()>0){
           // if(CompanyCard[0].IPM_Project_Leader__c!=null){
            string REType=CompanyCard[0].IPM_Company_Card__r.RecordType.Name;
               if(REType.contains('Global')){
               CompanyType='Global';
               ProjectPhase='Ideas';
               }else if(REType.contains('Regional')){
               ProjectPhase='Feasibility';
               CompanyType='Regional';
               }else{
               CompanyType='Local';
               ProjectPhase='Feasibility';
               }
                
           // }
            
            isEditable=true;   
            }*/
        if(projectId!=null){
            ProId=projectId;
            IdGenerated=true;
            initialised=true;
        }
        if (ProId== null || ProId== ''){
            project = new IPM_Project__c();

        } else {
           // IdGenerated=true;
            project = [Select Id,IPM_Complexity__c,IPM_Quit_Project_Tab__c,IPM_Project_Leader__c,IPM_Phase__c,IPM_GateKeeping_Model__c,IPM_PM_Approach__c,IPM_Company_Card__c,IPM_Project_Logo__c ,IPM_Target_Launch_Dates__c ,IPM_Project_Description__c,IPM_Project_Name__c,IPM_Category_Text__c,IPM_Brand__c,IPM_Brand_Positioning__c,IPM_Target_Launch_Date__c,IPM_Approver_of_Charter__c,IPM_Approver_of_Contract_Market_Ready__c,IPM_Fast_Track_Project__c from IPM_Project__c where Id=:projectId limit 1]; 
            selBrand=project.IPM_Brand__c;
            selCat=project.IPM_Category_Text__c;
            selBrandPos=project.IPM_Brand_Positioning__c;
            expectedTLD=project.IPM_Target_Launch_Date__c;
            ComplexityType=project.IPM_Complexity__c;
            ProjectTabName=project .IPM_Quit_Project_Tab__c;
            selectedCompany=project.IPM_Company_Card__c;
            isSaved=true;
            list<IPM_Task__c >ipmprojectTask=[select id from IPM_Task__c where IPM_Project__c=:projectId];
            if(ipmprojectTask.size()>0){
                isTaskgenerated=true;
                selectedCompany=project.IPM_Company_Card__c;
            }
            
        }
        listUpdatedProject();
        isNameMandatory=false; 
        ImageId=ApexPages.currentPage().getParameters().get('image');
        system.debug('ImageID......'+ImageId);
        if(ImageId!=null || ImageId!=''){
          isImage=true;
        }
        system.debug('ImageID......'+isImage);
    getIpmuserType();
    getMilesTaskIpmuserType();
    getCategory();
    getBrandPos();
} 
public class DatePicker 
{
    public String datename {get; set;}
} 
    
//Get Company card details
public void getCompanyCard(){

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
            //    IPM_Error_Log__c err = new IPM_Error_Log__c(IPM_Error_Description__c = e.getMessage());
            //    insert err;
            return null;
        }
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
            //    IPM_Error_Log__c err = new IPM_Error_Log__c(IPM_Error_Description__c = e.getMessage());
            //   insert err;
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
            //    IPM_Error_Log__c err = new IPM_Error_Log__c(IPM_Error_Description__c = e.getMessage());
            //    insert err;
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
            //     IPM_Error_Log__c err = new IPM_Error_Log__c(IPM_Error_Description__c = e.getMessage());
            //     insert err;
            return null;
        }
    }
 /* Type Name: getCharterApprovers()
Author: 
Parameter(s)
ReturnType: List
Reason: For getting charter approver */  
    public List<SelectOption> getCharterApprovers(){
            Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_Approver_of_Charter__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
      return options;
      }
/* Type Name: getContractApprovers()
Author: 
Parameter(s)
ReturnType: List
Reason: For getting contract and market ready approver*/  
    public List<SelectOption> getContractApprovers(){
            Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_GateKeeping_Model__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
      return options;
      }      
      
    /* Type Name: listUpdatedProject()
Author: 
Parameter(s)
ReturnType: void
Reason: For getting saved project names */
    Public void listUpdatedProject(){
        listofProjectName=[select id,name,IPM_Project_Description__c,IPM_Project_Name__c from IPM_Project__c where IPM_Project_Name__c !=:'' and id !=:ProId limit 999];
        
    }
    
    /* Type Name: save()
Author: 
Parameter(s)
ReturnType: void
Reason: For Saving the Project */  
    public void save(){
       /* if(project.IPM_Project_Name__c=='' || project.IPM_Project_Name__c==null ) {
            isNameMandatory=true;
        } else if(project.IPM_Project_Description__c !='' && project.IPM_Project_Description__c!= null && project.IPM_Project_Description__c.length()>255)  {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Description_Restricted)); 
        } else if(!Pattern.matches('[a-zA-Z0-9 ]+',project.IPM_Project_Name__c)) {
            
            isNameMandatory=false;
            isContainSpecialChars=true;                       
        }         
        else {*/
            try
            {
                    list<IPM_User_Profile__c>lstuserprofile=[select IPM_Company_Card__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() and IPM_Project_Leader__c=true limit 1];
                   
                        
                    list<IPM_Project__c> duplicateProject=new list<IPM_Project__c> ();
                    duplicateProject=[Select Id from IPM_Project__c where IPM_Project_Name__c=:project.IPM_Project_Name__c and Id !=:proId Limit 1];
                    if(duplicateProject.size()==0){
                    isNameMandatory=false;
                    isContainSpecialChars=false;
                    project.IPM_Project_Leader__c=UserInfo.getUserId();
                    project.IPM_Brand__c=selBrand;
                    project.IPM_Category_Text__c=selCat;
                    project.IPM_Brand_Positioning__c=selBrandPos;
                    project.IPM_Target_Launch_Date__c=expectedTLD;
                    //project.IPM_Complexity__c='Lite';
                   /* if(lstuserprofile.size()>0){
                        project.IPM_Company_Card__c=lstuserprofile[0].IPM_Company_Card__c;
                      }*/
                   
                    /*if(ImageId!='')
                    {
                        project.IPM_Project_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                        project.IPM_Project_Logo_Id__c=ImageId;
                    }*/    
                    System.debug('PROJECT ID'+ProId);
                    if(proId!=Null && proId!=''){
                    updatedProjectId=[Select Id from IPM_Project__c where Id=:proId Limit 1];
                    project.Id=updatedProjectId.Id;
                     update project;
                    }
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
                   }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                   } 
            }
            catch(Exception e)
            {
                if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                {   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Project Name should not contain special characters')); 
                }
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                }   
            }            
        //}
    }
 /* For Auto Save */
  /* Type Name: save()
Author: 
Parameter(s)
ReturnType: void
Reason: For Saving the Project */  
    public void autosave(){
       /* if(project.IPM_Project_Name__c=='' || project.IPM_Project_Name__c==null ) {
            isNameMandatory=true;
        } else if(project.IPM_Project_Description__c !='' && project.IPM_Project_Description__c!= null && project.IPM_Project_Description__c.length()>255)  {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Description_Restricted)); 
        } else if(!Pattern.matches('[a-zA-Z0-9 ]+',project.IPM_Project_Name__c)) {
            
            isNameMandatory=false;
            isContainSpecialChars=true;                       
        }         
        else {*/
            try
            {
                    list<IPM_User_Profile__c>lstuserprofile=[select IPM_Company_Card__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() and IPM_Project_Leader__c=true limit 1];
                   
                        
                    list<IPM_Project__c> duplicateProject=new list<IPM_Project__c> ();
                    duplicateProject=[Select Id from IPM_Project__c where IPM_Project_Name__c=:project.IPM_Project_Name__c and Id !=:proId Limit 1];
                    if(duplicateProject.size()==0){
                    isNameMandatory=false;
                    isContainSpecialChars=false;
                    project.IPM_Project_Leader__c=UserInfo.getUserId();
                    project.IPM_Brand__c=selBrand;
                    project.IPM_Category_Text__c=selCat;
                    project.IPM_Brand_Positioning__c=selBrandPos;
                    project.IPM_Target_Launch_Date__c=expectedTLD;
                   /* if(lstuserprofile.size()>0){
                        project.IPM_Company_Card__c=lstuserprofile[0].IPM_Company_Card__c;
                      }*/
                   
                    /*if(ImageId!='')
                    {
                        project.IPM_Project_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                        project.IPM_Project_Logo_Id__c=ImageId;
                    }*/    
                    System.debug('PROJECT ID'+ProId);
                    if(proId!=Null && proId!=''){
                    updatedProjectId=[Select Id from IPM_Project__c where Id=:proId Limit 1];
                    project.Id=updatedProjectId.Id;
                     update project;
                    }
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
                   }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                   } 
            }
            catch(Exception e)
            {
                if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                {   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Project Name should not contain special characters')); 
                }
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                }   
            }            
        //}
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

//find company card type
public void searchprojectpahse(){
list<IPM_Company_Card__c >CompanyCard=[select RecordType.Name from IPM_Company_Card__c where id=:selectedCompany];
    if(CompanyCard.size()>0){
           string REType=CompanyCard[0].RecordType.Name;
           if(REType.contains('Global')){
           CompanyType='Global';
           }else if(REType.contains('Regional')){
           CompanyType='Regional';
           }else{
           CompanyType='Local';
            }
       }
       project.IPMProject_Span__c=CompanyType;
       project.IPM_Company_Card__c=selectedCompany;     
       update project;   
       getCategory();    
}



    
/* Type Name: saveProceed()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: For Saving Project and Proceed to Next Step */ 
    public PageReference saveProceed(){
        boolean isAnyError=false;
        if(project.IPM_Project_Name__c=='' || project.IPM_Project_Name__c==null) {
            isAnyError=true;
            isNameMandatory=true;
          }
       /* if(project.IPM_Project_Description__c==null || project.IPM_Project_Description__c==''){
        isProDescMandatory=true;
        isAnyError=true;
        }  */
        if(selCat==null || selCat==''){
        isCateMandatory=true;
        isAnyError=true;
        }
        if(selBrandPos==null || selBrandPos==''){
        isBrandPoMandatory=true;
        isAnyError=true;
        }
        if(project.IPM_Target_Launch_Dates__c==null){
         isAnyError=true;
         isTLDMandatory=true;
         
        }
       if(isAnyError==true){
           return null;
       } 
        if(project.IPM_Project_Name__c=='' || project.IPM_Project_Name__c==null) {
            isNameMandatory=true;
            return null;            
        } else if(project.IPM_Project_Description__c !='' && project.IPM_Project_Description__c!= null && project.IPM_Project_Description__c.length()>255)  {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Description_Restricted)); 
            return null;
        } else if(!Pattern.matches('[a-zA-Z0-9 ]+',project.IPM_Project_Name__c)) {
            isNameMandatory=false;
            isContainSpecialChars=true;
            return null;            
        }else {
            try
            {
                    list<IPM_Project__c> duplicateProject=new list<IPM_Project__c> ();
                    duplicateProject=[Select Id from IPM_Project__c where IPM_Project_Name__c=:project.IPM_Project_Name__c and Id !=:proId Limit 1];
                    if(duplicateProject.size()==0){
                    isNameMandatory=false;
                    isContainSpecialChars=false;
                    project.IPM_Project_Leader__c=UserInfo.getUserId();
                    project.IPM_Brand__c=selBrand;
                    project.IPM_Category_Text__c=selCat;
                    project.IPM_Brand_Positioning__c=selBrandPos;
                    project.IPM_Target_Launch_Date__c=expectedTLD;
                    //project.IPM_Complexity__c='Lite';
                   
                   // project.IPMProject_Span__c=CompanyType;
                   // project.IPM_Phase__c=ProjectPhase;
                   /* if(CompanyCard.size()>0){
                        project.IPM_Company_Card__c=CompanyCard[0].IPM_Company_Card__c;
                     }*/
                    /*if(ImageId!='')
                    {
                        project.IPM_Project_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                        project.IPM_Project_Logo_Id__c=ImageId;
                    } */  
                    System.debug('PROJECT ID'+ProId);
                    if(proId!=Null && proId!=''){
                    updatedProjectId=[Select Id from IPM_Project__c where Id=:proId Limit 1];
                    project.Id=updatedProjectId.Id;
                     update project;
                     
                     if(project.IPM_Complexity__c==null){
                       project.IPM_Complexity__c='Lite';
                       update project;
                      }
                       //update project;

                     IsSaveProject=true;
                     isNameMandatory=false;
                     isProDescMandatory=false;
                     isCateMandatory=false;
                     isBrandPoMandatory=false;
                     isTLDMandatory=false;
                    }
                    PageReference url=new PageReference('/apex/ipmProject?isProject=true&id='+project.Id);
                    url.setRedirect(true);
                    return null;
                  }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                    return null;
                   } 
            }
            catch(Exception e)
            {
                if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                {   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Project Name should not contain special characters')); 
                }
                if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                }
                return null;
            }
        }
    } 
//Save records while uploading an image
public void SaveRecords(){
                    list<IPM_Project__c> duplicateProject=new list<IPM_Project__c> ();
                    duplicateProject=[Select Id from IPM_Project__c where IPM_Project_Name__c=:project.IPM_Project_Name__c and IPM_Project_Name__c !=:''  and Id !=:proId Limit 1];
                    if(duplicateProject.size()==0){
                    if(project.IPM_Project_Name__c=='' || project.IPM_Project_Name__c==null ) {
                    string uID=UserInfo.getUserId();
                    //project.IPM_Project_Name__c=uID.substring(0,14);
                    }
                    isNameMandatory=false;
                    isContainSpecialChars=false;
                    project.IPM_Project_Leader__c=UserInfo.getUserId();
                    project.IPM_Brand__c=selBrand;
                    project.IPM_Category_Text__c=selCat;
                    project.IPM_Brand_Positioning__c=selBrandPos;
                    project.IPM_Target_Launch_Date__c=expectedTLD;
                    if(ImageId!='')
                      // project.IPM_Project_Logo__c= '<img src='+imgurl + '/servlet/servlet.FileDownload?file='+ImageId+'"/>';
                    System.debug('PROJECT ID'+ProId);
                    if(proId!=Null && proId!=''){
                    updatedProjectId=[Select Id from IPM_Project__c where Id=:proId Limit 1];
                    project.Id=updatedProjectId.Id;
                    update project;
                    initialise();
                    }
                    }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                  } 
                

}      
    /* Type Name: ProjectIdGeneration()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: For Autosaving the project details when mouse out event on the project name*/ 
    public void ProjectIdGeneration()
    {
        try
        {
           if(project.IPM_Project_Name__c !=null && project.IPM_Project_Name__c!='' && Pattern.matches('[a-zA-Z0-9 ]+',project.IPM_Project_Name__c))
                {
                    
                    list<IPM_Project__c> duplicateProject=new list<IPM_Project__c> ();
                    duplicateProject=[Select Id from IPM_Project__c where IPM_Project_Name__c=:project.IPM_Project_Name__c and Id !=:proId Limit 1];
                    if(duplicateProject.size()>0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                    }
                   }
        }
        catch(Exception e)
        {
            
        }
    }
  

//Generate Project ID
public void createproject(){
   //try{
    projectId=ApexPages.currentPage().getParameters().get('PId');
    IdGenerated=true;
    initialised=true;
    /*if (!initialised){
    if(projectId=='' || projectId==Null){
        string uID=UserInfo.getUserId();
        
        list <IPM_Project__c > lstofemptyProjectname=new list<IPM_Project__c>();
        lstofemptyProjectname=[select name from IPM_Project__c where IPM_Project_Name__c=:'' and IPM_Bosscard__c='' and CreatedBy.ID=:UserInfo.getUserId()];
               
       if(lstofemptyProjectname.size()>0){
         delete lstofemptyProjectname;
        }
        project = new IPM_Project__c();
        project.IPM_Project_Leader__c=UserInfo.getUserId();
       // project.IPM_Project_Name__c=uID.substring(0,14);
        insert project;
        projectId=project.id;
        ProId=projectId;
        IdGenerated=true;
        initialised=true;
     }
     else{
        IdGenerated=true;
        initialised=true;
     }
    }*/
  // }
  // catch(exception e){
   // }  
    
  } 
 //core parameter refresh
 public void corerefresh(){
 }  
 // Get user type with access permission
 public void getIpmuserType(){
 
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() limit 1];
 if(lstProuser.size()>0){
    
    if(lstProuser[0].IPM_Role_Type__c=='BD'){
    isEditable=false;
       
    }else if(lstProuser[0].IPM_Role_Type__c=='CMI'){
     isEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='CD'){
     isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='R&D'){
    isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Supply Chain'){
     isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Finance'){
     isEditable=false;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='BB'){
     isEditable=true;
    }
 } 
 if(isEditable==false){
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c from IPM_Project__c where 
                                        id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() or IPM_Technical_Project_Leader__c=:userinfo.getuserid() 
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];

 if(lstofuser.size()>0){
 system.debug('isEditable....'+isEditable);
    isEditable=true;  
 }else{
  isEditable=false;
 }
}
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners'
                                            or PermissionSet.Name='IPM_BB_PL' or PermissionSet.Name='IPM_Deputy_Project_Leader' or 
                                             PermissionSet.Name='IPM_ProjectLeader') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isEditable=true;
}                                       

 system.debug('isEditable....'+isEditable);                                        
 } 
//Get Milestone and task access
public void getMilesTaskIpmuserType(){
list<IPM_Project_Resource__c>CountTaskSCUser=[select IPM_Role_Type__c,IPM_Project_Role_Owner__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Role_Type__c='Supply Chain' limit 1];
 if(CountTaskSCUser.size()>0){
 isTaskeditable=true;
 isAllTask=true; 
 }                                        
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid()  limit 1];
 
 if(lstProuser.size()>0){
    
    if(lstProuser[0].IPM_Role_Type__c!='Guest'){
    isMilestoneEditable=true;
    isTaskeditable=true;
    FunctionRole=lstProuser[0].IPM_Role_Type__c;
    if(lstProuser[0].IPM_Role_Type__c=='BD Marketing')
    FunctionRole='BD';
    }
    else {
    isMilestoneEditable=false;
    isTaskeditable=false;
    }
   if(lstProuser[0].IPM_Role_Type__c=='BD' || lstProuser[0].IPM_Role_Type__c=='BD Marketing'){
    isBDuser=true;
    }
    if(lstProuser[0].IPM_Role_Type__c=='CMI' || lstProuser[0].IPM_Role_Type__c=='CD' || lstProuser[0].IPM_Role_Type__c=='Finance' || lstProuser[0].IPM_Role_Type__c=='Guest'){
    isupdateDates=false;
    }
  } 
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c from IPM_Project__c where 
                                         id=:projectId limit 1];
 system.debug('size................'+lstofuser.size());
 if(lstofuser.size()>0){
    if(lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()){
    isMilestoneEditable=true;
    isTaskeditable=true;
    isAllTask=true;  
    }else if(lstofuser[0].IPM_Project_Gatekeeper__c==userinfo.getuserid()){
    isMilestoneEditable=false;
    isTaskeditable=false;
    isupdateDates=false;
    isAllTask=false;
    isvisible=false;  
    }else if(lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid()){
    isMilestoneEditable=true;
    isTaskeditable=true;
    isAllTask=true;    
    }else if(lstofuser[0].IPM_Technical_Project_Leader__c==userinfo.getuserid()){
    isMilestoneEditable=true;
    isTaskeditable=true;
    isAllTask=true;  
    }
   }
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isMilestoneEditable=true;
 isTaskeditable=true;
 isAllTask=true; 
 }                                       
} 
//save complexity type
public void SaveComplexityType(){
if(ComplexityType==''){
    ComplexityType='Lite';
}
project.IPM_Complexity__c=ComplexityType;
update project;
} 
//nothing to do

public void none(){
    System.debug('************1'+ project.IPM_Project_Leader__c);
    update project;
    System.debug('************2'+ project.IPM_Project_Leader__c);
    
} 
public void SaveIPMApproach(){
if(project.IPM_PM_Approach__c=='Internal'){
    project.IPM_PM_Approach__c='External';
}else{
    project.IPM_PM_Approach__c='Internal';
}

update project;
}  
public void Savetabname(){
project.IPM_Quit_Project_Tab__c=ProjectTabName;
update project;
ProjectTabName=project.IPM_Quit_Project_Tab__c;
}
public void SearchbrandPos(){
getbrandPos();
}

}