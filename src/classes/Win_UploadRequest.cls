/*************************************************************** 
	Name: Win_UploadRequest
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Upload data structure
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	22/12/2016	Initial Dev 	First version
***************************************************************/
global class Win_UploadRequest {
	public List<String> recordList {get; set;}

	public Win_UploadRequest(){
		recordList = new List<String>();
	}

}