@RestResource(urlMapping='/DragAndDropJoe/*')
global with sharing class Oblix_DragAndDropRESTAPI
{
    @HttpPost
    global static String attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String fName = req.params.get('FileName'); 
        String parId = req.params.get('parId');  
        Blob postContent = req.requestBody; 
          
        Attachment a = new Attachment (ParentId = parId,
                                       Body = postContent, 
                                       Name = fName);
         
        insert a;
        return a.Id;
   }
}