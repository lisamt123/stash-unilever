public class IPM_ChannelImageController
 {
    Public Id parentId{get; set;}
    Public Id projectId{get; set;}
    public Id projDocSectId{get; set;}
    public string type{get; set;}
    Transient Attachment myfile;
    public IPM_Project_Document_Section_Content__c content{get; set;}
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
    public IPM_ChannelImageController()
    {
        projectId=ApexPages.currentPage().getParameters().get('Id');
        projDocSectId=ApexPages.currentPage().getParameters().get('projDocSecId');
        parentId=ApexPages.currentPage().getParameters().get('contentId');
        type=ApexPages.currentPage().getParameters().get('desc');
    }
    Public Pagereference Savedoc()
    {
        Attachment a = new Attachment();
        try
        {
            if(myfile.name.toUpperCase().contains('.JPG') || myfile.name.toUpperCase().contains('.JPEG') || myfile.name.toUpperCase().contains('.PNG') || myfile.name.toUpperCase().contains('.GIF') ||
                    myfile.name.toUpperCase().contains('.BMP') || myfile.name.toUpperCase().contains('.PDS') || myfile.name.toUpperCase().contains('.PSP') || myfile.name.toUpperCase().contains('.THM') ||
                    myfile.name.toUpperCase().contains('.TIF') || myfile.name.toUpperCase().contains('.YUV'))
            {
                a.parentId = parentId;
                a.name=myfile.name;
                a.body = myfile.body;
                a.description=type;
                /* insert the attachment */
                insert a;
                content=[Select Id,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,IPM_Product_Image_2_Id__c,IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c,IPM_Place_Image_2_Id__c from IPM_Project_Document_Section_Content__c where Id=:parentId];
                if(type=='p1')
                content.IPM_Preposition_Image_1_Id__c=a.Id;
                else if(type=='p2')
                content.IPM_Preposition_Image_2_Id__c=a.Id;
                else if(type=='p3')
                content.IPM_Promotion_Image_1_Id__c=a.Id;
                else if(type=='p4')
                content.IPM_Promotion_Image_2_Id__c=a.Id;
                else if(type=='p5')
                content.IPM_Product_Image_1_Id__c=a.Id;
                else if(type=='p6')
                content.IPM_Product_Image_2_Id__c=a.Id;
                else if(type=='p7')
                content.IPM_Pack_Image_1_Id__c=a.Id;
                else if(type=='p8')
                content.IPM_Pack_Image_2_Id__c=a.Id;
                else if(type=='p9')
                content.IPM_Price_Image_1_Id__c=a.Id;
                else if(type=='p10')
                content.IPM_Price_Image_2_Id__c=a.Id;
                else if(type=='p11')
                content.IPM_Place_Image_1_Id__c =a.Id;
                else if(type=='p12')
                content.IPM_Place_Image_2_Id__c =a.Id;
                update content;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Image uploaded successfully'));
                return null;
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.label.IPM_Image_format));
                return null;  
            }
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