/*************************************************************** 
    Name: Win_Exception
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Generic exception
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Generic Exception 
***************************************************************/
global class Win_Exception extends Exception {
    
    /**
     *  Store the error code
     */ 
    private Integer errorCode;
    
    /**
     *  Constructor
     */ 
    public Win_Exception(Integer errorCode) {
        setErrorCode(errorCode);
        setMessage('WIN_Exception: ' + getErrorCode());
    }
    
    /**
     *  Set the error code
     */
    public void setErrorCode(Integer errorCode) {
        this.errorCode = errorCode;
    }
    
    /**
     *  Get the error code
     */
    public Integer getErrorCode() {
        return this.errorCode;
    }
    
}