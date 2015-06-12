public with sharing class IPM_ImageUploadController {
    public String project {get; set;}
    public String projectId {get; set;}
    public String imgid{get;set;}
    public boolean isError{get;set;}
    public IPM_Bosscard__c bosscard {get; set;}
    public string imgurl{get;set;}
    public IPM_Project__c projects {get; set;}
    public IPM_ImageUploadController()
    {
        imgid='';
        isError=false;
        bosscard=new IPM_Bosscard__c ();
        projects=new IPM_Project__c();
        imgurl=System.Label.IPM_image;
        project=ApexPages.currentPage().getParameters().get('isProject');
        projectId =ApexPages.currentPage().getParameters().get('id');
        System.debug('Project Id from Controller---------->'+projectId);
    } 
    public Document document {
        get {
            if (document == null)
            document = new Document();
            return document;
        }
        set;
    }

    public PageReference upload() {
        Document doc;
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); // put it in running user's folder

        
           try {
            system.debug('Inside try');
            if(document.name.toUpperCase().contains('.JPG') || document.name.toUpperCase().contains('.JPEG') || document.name.toUpperCase().contains('.PNG') || document.name.toUpperCase().contains('.GIF') ||
               document.name.toUpperCase().contains('.BMP') || document.name.toUpperCase().contains('.PDS') || document.name.toUpperCase().contains('.PSP') || document.name.toUpperCase().contains('.THM') ||
               document.name.toUpperCase().contains('.TIF') || document.name.toUpperCase().contains('.YUV'))
             {
             system.debug('Before insert');
             
            insert document;
            doc = [SELECT id, name, description FROM Document where Id=:document.Id];
            imgid=doc.Id;
            if(project=='true'){
            system.debug('inside true.........');
                projects.id=projectId;
                projects.IPM_Project_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+doc.Id+'"/>';
                update projects;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
             }else{
                bosscard.id=projectId;
                bosscard.IPM_Bosscard_Logo__c='<img src='+imgurl + '/servlet/servlet.FileDownload?file='+doc.Id+'"/>';
                bosscard.IPM_Bosscard_Logo_Id__c=imgid;
                update bosscard;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
      
             }  
            } 
             else{
              isError=true;
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_Image_format));
              return null;  
           }
            }catch (Exception e) {
            isError=true;
            system.debug('Inside Catch');
            String str = e.getMessage();
            system.debug('ErrorMessage'+str);
            if(str.contains('de-reference'))
              {
                 system.debug('helllllllllo');
                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The Maximum image size is 5MB'));
                 return null;
              }
            
            } finally {
                document.body = null; // clears the viewstate
                document = new Document();
            }
           
          
        
         if(project=='true')   
        {
            System.debug('Project Id----->'+projectId);
            PageReference url;
            if(projectId!=null && projectId !='')
            {
                url=new PageReference('/apex/ipmNewProject?image='+doc.Id+'&id='+projectId);
            }
            else
            {
                url=new PageReference('/apex/ipmNewProject?image='+doc.Id);
            }
            //url.setRedirect(true);
            return null;
        }
        else
        {
            PageReference url;
            if(projectId!=null && projectId !='')
            {
                url=new PageReference('/apex/ipmbosscard?image='+doc.Id+'&id='+projectId);
            }
            else
            {
                url=new PageReference('/apex/ipmbosscard?image='+doc.Id);
            }
            return null;
        }
    }
}