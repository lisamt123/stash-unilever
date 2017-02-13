/*************************************************************** 
	Name: Win_ErrorRequest
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Error request item
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/01/2017	Initial Dev 	First version
***************************************************************/
global class Win_ErrorRequest {
	public List<Win_ErrorRequest.Win_ErrorRequestItem> errorList {get; set;}

	/*
	 *	Default Constructor
	 */
	public Win_ErrorRequest() {
		errorList = new List<Win_ErrorRequest.Win_ErrorRequestItem>();
	}

	/*
	 *	Inner class to describe 
	 */
	public class Win_ErrorRequestItem {
		public String errorArea {get;set;} 
		public String errorDescription {get;set;}
		public String errorLevel {get;set;}

		public Win_ErrorRequestItem(String errorArea, String errorDescription, String errorLevel) {
			this.errorArea = errorArea;
			this.errorDescription = errorDescription;
			this.errorLevel = errorLevel;
		}
	}

}