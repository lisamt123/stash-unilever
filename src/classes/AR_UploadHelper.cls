/*
	Unilever

	Class Name: AR_UploadHelper

	Created by: Marc Saelzler | 2013-09-04

	Description: Controller to upload files into sfdc as attachment.

	Timeline
	Date 					| Name 				| Description
	2013-09-04 17:25 (CET)	| Marc Saelzler 	| Initial development.
	2013-09-12 11:04 (CET)	| Marc Saelzler 	| Changed several parts to get and set the holder and the holder's information correctly.
*/

public class AR_UploadHelper
{
	// Constructor
	public AR_UploadHelper()
	{
		
	}
	
	// Includes the sObjectHolder to manage the file information.
	public AR_SObjectHolder a_holder
	{
		get;
		set;
	}
	
	// Placeholder for the origin name of the file.
	public String a_fileName
	{
		get
		{
			if(a_fileName == null)
			{
				a_fileName = '';
			}
			
			return a_fileName;
		}
		
		set;
	}
	
	// Prefix should be used as a recall value to know which data has been saved within the database.
	public String a_fileNamePrefix
	{
		get
		{
			if(a_fileNamePrefix == null)
			{
				a_fileNamePrefix = '';
			}
			
			return a_fileNamePrefix;
		}
		
		set;
	}
	
	// Identifier for the page, if the user decides to reupload a file.
	public Boolean a_reupload
	{
		get
		{
			if(a_reupload == null)
			{
				a_reupload = false;
			}
			
			return a_reupload;
		}
		
		set;
	}
	
	// Placeholder for the body (content) of the upload file.
	public Blob a_body
	{
		get;
		
		set
		{
			if(value != null)
			{
				a_holder.getFiles().get(a_fileNamePrefix).body = value;
				
				a_holder.SetFiletoInsert(a_fileNamePrefix);
				
				a_reupload = false;
			}
		}
	}
}