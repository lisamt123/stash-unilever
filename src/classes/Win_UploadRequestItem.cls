/*************************************************************** 
	Name: Win_UploadRequestItem
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Upload request item data structure
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	22/12/2016	Initial Dev 	First version
***************************************************************/
global class Win_UploadRequestItem {
	public String objectApiName {get; set;}
	public String Id {get; set;}
	public String record {get; set;}
	public String changeDate {get; set;}
	
	/**
	 *	Empty constructor
	 */
	public Win_UploadRequestItem() {}
	
	/**
	 *	Constructor
	 *	@param objectApiName Object API Name
	 *	@param objectId Object Id
	 *	@param objectId Record to upload
	 */
	public Win_UploadRequestItem(String objectApiName, String objectId, String record){
		this(objectApiName, objectId, record, null);
	}
		
	/**
	 *	Constructor
	 *	@param objectApiName Object API Name
	 *	@param objectId Object Id
	 *	@param objectId Record to upload
	 *	@param changeDate when it has been changed
	 */
	public Win_UploadRequestItem(String objectApiName, String objectId, String record, String changeDate){
		this.objectApiName = objectApiName;
		this.Id = objectId;
		this.record = record;
		this.changeDate = changeDate;
	}

}