/*************************************************************** 
	Name: Win_WebServiceResponse
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Generic response data structure
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	22/12/2016	Initial Dev 	First version
***************************************************************/
global abstract class Win_WebServiceResponse {
	
	public final static Integer SUCCESS = 0;
	public final static Integer CLIENT_GENERIC_ERROR = -400;
	public final static Integer SERVER_GENERIC_ERROR = -500;
	
	/**
	 *	Status of the Response
 	 */	
	private Integer status;
	
	/**
	 *	Verbose error
 	 */	
	private String error;
	
	
	/**
	 *	Default constructor
 	 */
	public Win_WebServiceResponse() {}
	
	/**
	 *	Getter of the status
 	 */
	public Integer getStatus() {
		return this.status;
	}
	
	/**
	 *	Setter of the status
 	 */
	public void setStatus(Integer status) {
		this.status = status;
	}
	
	/**
	 *	Getter of the error
 	 */
	public String getError() {
		return this.error;
	}
	
	/**
	 *	Setter of the error
 	 */
	public void setError(String error) {
		this.error = error;
	}

}