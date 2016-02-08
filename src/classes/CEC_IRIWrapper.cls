/**********************************************************************
Name:  CEC_IRIWrapper
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This is the wrapper class for IRI Webservice                                                                                                
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Naggesh K R       Jan-2016      INITIAL DEVELOPMENT   
***********************************************************************/

public class CEC_IRIWrapper{
    public Result RESULT;
    public class Result{
        public Integer SUCCESS_CODE;
        public List<Store> STORES;
    }
    public class Store{
        public boolean ISSELECTED{get;set;}
        public string STORE_ID{get;set;}
        public string PHONE{get;set;}
        public string ADDRESS{get;set;}
        public string DISTANCE{get;set;}
        public string LONGITUDE{get;set;}
        public string CITY{get;set;}
        public string NAME{get;set;}
        public string STATE{get;set;}
        public string STORE_NUMBER{get;set;}
        public string ZIP{get;set;}
        public string UPC_CODE{get;set;}
        public string LATITUDE{get;set;}
    }
}