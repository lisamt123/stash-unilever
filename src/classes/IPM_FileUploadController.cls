Public class IPM_FileUploadController
{
Public Id parentId{get; set;}
Public Id projectId{get; set;}
public string type{get; set;}
Transient Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
public IPM_FileUploadController()
{
    projectId=ApexPages.currentPage().getParameters().get('Id');
    parentId=ApexPages.currentPage().getParameters().get('projDocSecId');
    type=ApexPages.currentPage().getParameters().get('sectionType');
    System.debug('sectionType'+type);
}
Public Pagereference Savedoc()
    {
        Attachment a = new Attachment();
        try
        {
        a.parentId = parentId;
        a.name=myfile.name;
        a.body = myfile.body;
        a.Description=type; 
         /* insert the attachment */
         insert a;
         System.debug('sectionType'+type);
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
         return null;
        }
        catch(Exception e){
        return null;
        } 
            finally 
            {          
                a.body = null; // clears the viewstate          
               a= new Attachment();        
            }        
    } 
}