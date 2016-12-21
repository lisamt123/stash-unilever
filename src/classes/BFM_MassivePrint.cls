/**
 * @author      Josep Vall-llobera <valnavjo_at_gmail.com>
 * @version     1.1.0
 * @since       03/02/2013
 */
public  with sharing class BFM_MassivePrint {

	public String zipFileName {get; set;}
	public String zipContent {get; set;}

	public PageReference uploadZip() {
		if (String.isEmpty(zipFileName) ||
			String.isBlank(zipFileName)) {
			zipFileName = 'my_zip.zip';
		}
		else {
			zipFileName.replace('.', '');
			zipFileName += '.zip';
		}
		
		Document doc = new Document();
		doc.Name = zipFileName;
		doc.ContentType = 'application/zip';
		doc.FolderId = UserInfo.getUserId();
		doc.Body = EncodingUtil.base64Decode(zipContent);
		
		insert doc;
		
		this.zipFileName = null;
		this.zipContent = null;

		PageReference pageRef = new PageReference('/' + doc.Id);
		pageRef.setRedirect(true);
		
		return pageRef;
	}

	public List<BFM_MDF_e__c> getAttachments() {
		return [select Id, Name,External_File_Path__c,Issuer_CNPJ__c
				from BFM_MDF_e__c
				limit 100];
	}
	
	@RemoteAction
	public static AttachmentWrapper getAttachment(String externalLink) {
		
		/*Attachment att = [select Id, Name, ContentType, Body
						  from Attachment
						  where Id = :attId];
		
		AttachmentWrapper attWrapper = new AttachmentWrapper();
		attWrapper.attEncodedBody = EncodingUtil.base64Encode(att.body);
		attWrapper.attName = att.Name;
						  
		return attWrapper;*/
        
       
        AttachmentWrapper attWrapper = new AttachmentWrapper();
		attWrapper.attEncodedBody = EncodingUtil.base64Encode(Blob.valueOf(BFM_AmazonConnector.getFile(externalLink)));
		attWrapper.attName = 'NFS';
						  
		return attWrapper;
        
	}
	
	public class AttachmentWrapper {
		public String attEncodedBody {get; set;}
		public String attName {get; set;}
	}
}