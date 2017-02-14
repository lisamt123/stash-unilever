/*************************************************************** 
	Name: Win_UploadResponse
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Upload response data structure
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	22/12/2016	Initial Dev 	First version
***************************************************************/
global class Win_UploadResponse extends Win_WebServiceResponse {
	
	public static final String OperationDelete = 'DELETE';
	public static final String OperationUpsert = 'UPSERT';
	
	public List<Win_UploadResponseItem> body {get; set;}

	/*
	 *	Default constructor
	 */
	public Win_UploadResponse(){
		super();
		body = new List<Win_UploadResponseItem>();
	}

	/*
	 *	Response item
	 */
	global class Win_UploadResponseItem {

		/*
		 *	Object API Name
		 */
		public String objectApiName{get; set;}	

		/*
		 *	Record
		 */
		public sObject record {get; set;}

		/*
		 *	Response ID
		 */
		public String responseId {get; set;}

		/*
		 *	Request Id
		 */
		public String requestId {get; set;}

		/*
		 *	Operation
		 */
		public String operation {get; set;}

		/*
		 *	Positive result
		 */
		public Boolean success {get; set;}

		/*
		 *	Error
		 */
		public Boolean executed {get; set;}

		/*
		 *	When it has changed
		 */
		public String changeDate {get; set;}

		/*
		 *	List of errors
		 */
		public List<String> errorList{get; set;}
		
		/*
		 *	Default constructor
		 */
		public Win_UploadResponseItem(String objectApiName, String requestId){
			this.errorList = new List<String>();
			this.success = true;
			this.objectApiName = objectApiName;
			this.requestId = requestId;
		}
	}
}