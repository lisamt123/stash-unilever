global class MyPromotionRemoteActionExtension2 {
    
    private static String nameSp = Constants.NAMESPACEPREFIX;//variable for Namespace
    private static String className = String.valueOf(MyPromotionRemoteActionExtension2.class);
    public static final Integer ObjectStatus_UNCHANGED = 1;
    public static final Integer ObjectStatus_NEW = 2;
    public static final Integer ObjectStatus_MODIFIED = 4 ;
    public static final Integer ObjectStatus_DELETED = 8 ;
    private static final String DEFAULT_CALENDAR_COLOUR = '0x555555';
    global class PromotionRemoteActionException extends Exception {}
    global MyPromotionRemoteActionExtension2 (ApexPages.StandardController ctr) {}
    
    /** initPromotionAttachmentLinks method reads the promotion Json Data from the UI and parse it back to List<Promotion_Attachment_Link__c>
     *  @name   :  initPromotionAttachmentLinks
     *  @param  :  txId              GUI id for each transcation we do from UI
     *  @param  :  content           Json Data containing Promotion and Tactic Data
     *  @return :  List<Promotion_Attachment_Link__c>  List of custom object
     *  @throws :
     *  @author  : yolanda.braojos@accenture.com
     */
     public static List<Promotion_Attachment_Link__c> initPromotionAttachmentLinks(String txId,String content)
     {
        List<Promotion_Attachment_Link__c> promotionAttachmentLinkList = new List<Promotion_Attachment_Link__c>();
        Map<String, Object> promotionDeserializedMap = (Map<String, Object>) JSON.deserializeUntyped(content);
        Map<String, Object> boPromotion = (Map<String, Object>) promotionDeserializedMap.get('BOPromotion');
        List<Promotion_Attachment__c> promotionAttachmentListToUpdate = new List<Promotion_Attachment__c>();
        String boPromotionId = (String)boPromotion.get('Id');
        System.debug('@@@boPromotion.id:' + boPromotionId);

        List<String> deletedPromotionAttachment = new List<String>();

       if(boPromotion.containsKey('LOExtPromotionAttachment')){
            List<Object> loExtPromotionAttachmentList=(List<Object>) boPromotion.get('LOExtPromotionAttachment');
            if(loExtPromotionAttachmentList.size()>0) {
                Map<String, Object> LOExtPromotionAttachment = null;
                for (Object o:LOExtPromotionAttachmentList) {
                    loExtPromotionAttachment = (Map<String, Object>) o;
                    System.debug('@@@loExtPromotionAttachment : ' + loExtPromotionAttachment);

                    Integer status = Integer.valueOf(loExtPromotionAttachment.get('__ObjectStatus'));
                    System.debug('@@@loExtPromotionAttachment.status:' + status);
                    String promotionAttachmentID = (String)loExtPromotionAttachment.get('Id');
                    System.debug('@@@loExtPromotionAttachment.id:' + promotionAttachmentID);


                    if ((status & MyPromotionRemoteActionExtension2.ObjectStatus_DELETED) > 0 ) {
                      deletedPromotionAttachment.add(promotionAttachmentID);
                    } else {
                        if ((status & MyPromotionRemoteActionExtension2.ObjectStatus_NEW) > 0) {
                            Promotion_Attachment_Link__c promotionAttachmentLink = new Promotion_Attachment_Link__c();
                            promotionAttachmentLink.Promotion__c = boPromotionId;
                            promotionAttachmentLink.Promotion_Attachment__c = promotionAttachmentID;
                            System.debug('@@@promotionAttachmentLink:' + promotionAttachmentLink);
                            promotionAttachmentLinkList.add(promotionAttachmentLink);
                        }

                        if ((status & MyPromotionRemoteActionExtension2.ObjectStatus_MODIFIED) > 0) {

                            Promotion_Attachment__c pAttachment = new Promotion_Attachment__c();
                            pAttachment.Description_Language_1__c = (String)loExtPromotionAttachment.get('Description_Language_1__c');
                            pAttachment.Description_Language_2__c = (String)loExtPromotionAttachment.get('Description_Language_2__c');
                            pAttachment.Description_Language_3__c = (String)loExtPromotionAttachment.get('Description_Language_3__c');
                            pAttachment.Description_Language_4__c = (String)loExtPromotionAttachment.get('Description_Language_4__c');
                            pAttachment.name = (String)loExtPromotionAttachment.get('Name');
                            pAttachment.Type__c = (String)loExtPromotionAttachment.get('Type__c');
                            pAttachment.Size__c = (String)loExtPromotionAttachment.get('Size__c');
                            pAttachment.id = promotionAttachmentID;

                            promotionAttachmentListToUpdate.add(pAttachment);

                        }
                    }

                }

            }


            if(promotionAttachmentListToUpdate.size() > 0){

                System.debug('promotionAttachmentListToUpdate: ' + promotionAttachmentListToUpdate);

                Database.update(promotionAttachmentListToUpdate);
            }


            if(deletedPromotionAttachment.size()>0){

                System.debug('@@@deletedPromotionAttachment' + deletedPromotionAttachment);
                List<Promotion_Attachment_Link__c> deletePromotionAttachmentLink = [select Id,Promotion__c,Promotion_Attachment__c    from Promotion_Attachment_Link__c where Promotion_Attachment__c in :deletedPromotionAttachment ];
                if(deletePromotionAttachmentLink != null && deletePromotionAttachmentLink.size() > 0){
                    Database.delete(deletePromotionAttachmentLink,true);
                }

                deleteAttachmentList(deletedPromotionAttachment,boPromotionId);

            }
        }
        else {
            throw new UL_CustomException('Json is not having LOExtPromotionAttachment Valid Structure');
        }

        return promotionAttachmentLinkList;
    }

    /**
    * This internal class is to return the correct structure of data to UI*/
    global class WrapperPromotionAttachment{


        Promotion_Attachment__c PromotionAttachment;
        String previewUrl;
        String attachmentUrl;


        WrapperPromotionAttachment(Promotion_Attachment__c PromotionAttachment, String previewUrl, String attachmentUrl) {
            this.PromotionAttachment = PromotionAttachment;
            this.previewUrl = previewUrl;
            this.attachmentUrl = attachmentUrl;
        }


    }
    
    /**  This method reads the promotion Json Data from the UI and create a Promotion_Attachment__c
     *  @param txId GUI id for each transcation we do from UI
     *  @param promotionAttachmentObject Json Data containing Promotion Attachment Data
     *  @return Promotion_Attachment__c The custom object Promotion_Attachment__c created
     *  @author  : r.cereto.arredondo@accenture.com
     */
    @RemoteAction
    global static Promotion_Attachment__c createLOExtPromotionAttachment(String txId, String promotionAttachmentObject)
    {
        
        system.debug('createPromotionAttachment ... txId  = ' + txId + ',  promotionAttachment ' + promotionAttachmentObject);
        Promotion_Attachment__c createdPromotionAttachment;                       
        try{
            Promotion_Attachment__c promotionAttachment =(Promotion_Attachment__c) JSON.deserialize(promotionAttachmentObject, Promotion_Attachment__c.class);
            
            Database.insert(promotionAttachment);

            List<Promotion_Attachment__c> promotionAttachmentList = [SELECT id,name,  Description_Language_1__c, Description_Language_2__c,  Description_Language_3__c,  Description_Language_4__c,
                                    CreatedById,LastModifiedById, OwnerId,CreatedDate,Type__c,LastModifiedDate,Size__c
                                   FROM  Promotion_Attachment__c WHERE id=: promotionAttachment.id];
            if (promotionAttachmentList.size() > 0 ) {
               createdPromotionAttachment = promotionAttachmentList[0];
            }
        }catch(Exception e){
             throw new PromotionRemoteActionException('Error creating LOExtPromotionAttachment: ' + e.getMessage());
        }
 
        return createdPromotionAttachment;
    }


    @RemoteAction
    global static List<WrapperPromotionAttachment> readLOExtPromotionAttachment(String txId, String promotionId){

        List<Promotion_Attachment_Link__c> promotionAttachmentLinkList = new List<Promotion_Attachment_Link__c>();
        List<Promotion_Attachment__c> promotionsAttachments = new List<Promotion_Attachment__c>();
        List<Attachment> attachments = new List<Attachment>();

        try{

            promotionAttachmentLinkList = getPromotionAttachmentLinks(promotionId);
            promotionsAttachments = getPromotionsAttachments(promotionAttachmentLinkList);
            attachments = getAttachmentsOfAPromotionAttachment(promotionsAttachments);

        }catch(Exception e){
            throw new UL_CustomException(e.getMessage());
        }

        return mountWrapperPromotionAttachments(attachments,promotionsAttachments);


    }

    /*Get Promotion_attachment_Link from a promotion Id*/
    private static List<Promotion_Attachment_Link__c> getPromotionAttachmentLinks(String promotionId){

        List<Promotion_Attachment_Link__c> promotionAttachmentLinkList = new List<Promotion_Attachment_Link__c>();

        try{
            for(List<Promotion_Attachment_Link__c> attachmentLinks: [SELECT Id, Promotion_Attachment__c, Promotion__c FROM Promotion_Attachment_Link__c WHERE Promotion__c =: promotionId ]){

                promotionAttachmentLinkList.addAll(attachmentLinks);
            }

        }catch(Exception e){
            throw  new UL_CustomException('getPromotionAttachmentLinks:' + e.getMessage());
        }

        return promotionAttachmentLinkList;
    }

    //get promotions attachments from a list of promotion_Attachment_Link
    private static List<Promotion_Attachment__c> getPromotionsAttachments(List<Promotion_Attachment_Link__c> promotionsAttachmentsLink){

        List<Promotion_Attachment__c> promotionAttachments;
        List<Id> promotionAttachmentsLinkIds = new List<Id>();

        for( Promotion_Attachment_Link__c promotionattachmentLink : promotionsAttachmentsLink){
            promotionAttachmentsLinkIds.add(promotionattachmentLink.Promotion_Attachment__c );
        }

        try{
            promotionAttachments = [SELECT Id, Name, LastModifiedDate,CreatedDate ,CreatedById, Description_Language_1__c, Description_Language_2__c, Description_Language_3__c, Description_Language_4__c, Size__c, Type__c FROM Promotion_Attachment__c WHERE id IN: promotionAttachmentsLinkIds];
        }catch(Exception e){
            throw new UL_CustomException('error getPromotionsAttachments: ' + e.getMessage());
        }


        return promotionAttachments;
    }


    /*This method return a list of attachemnt from a list of Promotion_Attachment__c*/
    private static  List<Attachment> getAttachmentsOfAPromotionAttachment(List<Promotion_Attachment__c> promotionAttachments){

        List<Id> promotionAttachmentsIds = new List<Id>();
        List<Attachment> attachments = new List<Attachment>();


        try{
            /*get the ids of promotion_attachment*/
            for(Promotion_Attachment__c promotionAttachment : promotionAttachments){

                promotionAttachmentsIds.add(promotionAttachment.id);

            }
            /*get attachments which parentid is one of promotions_attachments*/
            for(List<Attachment> attachments2:[SELECT id,Description,ParentId FROM Attachment WHERE parentId IN : promotionAttachmentsIds]){
                attachments.addAll(attachments2);
            }


        }catch (Exception e){

            throw  new UL_CustomException('error getPromotionsAttachments: ' + e.getMessage());
        }

        return attachments;

    }

    /*this method mount a List of wrapperPromotionAttachment from a list of Attachments and a list of Promotion_Attachment__c*/
    private static List<WrapperPromotionAttachment> mountWrapperPromotionAttachments(List<Attachment> attachments, List<Promotion_Attachment__c> promotionAttachments){

        List<WrapperPromotionAttachment> wrapperPromotionAttachments = new List<WrapperPromotionAttachment>();
        Map<Id,PromotionAttachmentUrl> myMap = new Map<Id,PromotionAttachmentUrl>();
        try {

            myMap = mountMapParentIdAttachmentList(attachments);

            for(Promotion_Attachment__c pa: promotionAttachments ){

                wrapperPromotionAttachments.add(new WrapperPromotionAttachment(pa,myMap.get(pa.id).thumbnailUrl, myMap.get(pa.id).attachmentUrl));

            }

        }catch (Exception e){

            throw new UL_CustomException('error mountWrapperPromotionAttachments: ' + e.getMessage() );
        }

        System.debug('@@@@@ wrapperPromotionAttachments: ' + wrapperPromotionAttachments);
        return wrapperPromotionAttachments;

    }

    /*Helper class**/
    global class PromotionAttachmentUrl{

        String attachmentUrl{get;set;}
        String thumbnailUrl{get;set;}


        PromotionAttachmentUrl(String attachmentUrl,String thumbnailUrl){
            this.thumbnailUrl = thumbnailUrl;
            this.attachmentUrl = attachmentUrl;
        }

    }

    /*this method mount a map with the parentId and out object PromotionAttachmentUrl**/
    private static Map<Id,PromotionAttachmentUrl> mountMapParentIdAttachmentList(List<Attachment> attachments){

        Map<Id,PromotionAttachmentUrl> mapParentIdAttachment = new Map<Id, PromotionAttachmentUrl>();
        System.debug('@@@@@ Attachments: ' + attachments);
        try{

            for(Attachment at: attachments){
                System.debug('@@@@ at: ' + at);
              if(mapParentIdAttachment != null && mapParentIdAttachment.containsKey(at.parentId) ){
                  PromotionAttachmentUrl paURL = mapParentIdAttachment.get(at.parentId);
                  if(at != null && at.Description != null && at.Description.equals(Constants.ATTACHMENT_THUMBNAIL_KEY)){
                      paURL.thumbnailUrl = '/servlet/servlet.FileDownload?file='+at.Id;

                  }else if(at != null ){
                      paURL.attachmentUrl = '/servlet/servlet.FileDownload?file='+at.Id;

                  }

              }else{
                  if(at != null && at.Description != null && at.Description.equals(Constants.ATTACHMENT_THUMBNAIL_KEY)){
                      mapParentIdAttachment.put(at.parentId,new PromotionAttachmentUrl(null,'/servlet/servlet.FileDownload?file='+at.Id));
                  }else{

                      mapParentIdAttachment.put(at.parentId,new PromotionAttachmentUrl('/servlet/servlet.FileDownload?file='+at.Id,null));
                      System.debug('@@@@mountMapParentIdAttachmentList: ' + '/servlet/servlet.FileDownload?file='+at.Id);
                  }
              }
            }

        }catch(Exception e){
            throw new UL_CustomException('error mountMapParentIdAttachmentList: ' + e.getMessage());
        }

        if(mapParentIdAttachment.containsKey('a1x41000000nEwoAAE')){
            System.debug('AQUIIIIIII' +mapParentIdAttachment.get('a1x41000000nEwoAAE'));
        }
        System.debug('-----> mapParentIdAttachment: ' + mapParentIdAttachment);
        return mapParentIdAttachment;

     }
    
    private static void deleteAttachmentList(List<String> promotionsAttachments, String promotionAttachmentId){

        List<Promotion_Attachment__c> promotionAttachmentToDelete = new List<Promotion_Attachment__c>();
        List<Attachment> attachmentsToDelete = new List<Attachment>();
        List<String> promotionIdStrings = new List<String>();

        try{

            List<Promotion_Attachment_Link__c> promotionsAttachmentLinks = [SELECT id,Promotion_Attachment__c From Promotion_Attachment_Link__c WHERE Promotion__c != : promotionAttachmentId AND Promotion_Attachment__c in: promotionsAttachments];
            Map<String,String> mapPromotionAttachmentId = new Map<String,String>();

            for(Promotion_Attachment_Link__c promotionAttachmentLink : promotionsAttachmentLinks ){

                mapPromotionAttachmentId.put(promotionAttachmentLink.Promotion_Attachment__c, promotionAttachmentLink.id);

            }


            for(String idPromotionAttachment : promotionsAttachments){
                if(!mapPromotionAttachmentId.containsKey(idPromotionAttachment)){
                    promotionIdStrings.add(idPromotionAttachment );
                }
            }

            if(promotionIdStrings.size() > 0){
                promotionAttachmentToDelete = [SELECT id FROM Promotion_Attachment__c WHERE id IN : promotionIdStrings];
                attachmentsToDelete = [SELECT id FROM Attachment WHERE parentId IN : promotionIdStrings ];
            }


            if(attachmentsToDelete.size() > 0){
                Database.delete(attachmentsToDelete);
            }

            if(promotionAttachmentToDelete.size() > 0){
                Database.delete(promotionAttachmentToDelete,true);
            }


        }catch(Exception e){
            throw new UL_CustomException('Error on deleteAttachmentList: ' + e.getMessage());
        }


    }
    
    



}