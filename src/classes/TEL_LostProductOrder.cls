/**********************************************************************
Name: TEL_LostProductOrder
Copyright © 2016 Unilever

Purpose:
Handles Closed Lost Opportunities

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Diego Maranhão  22/11/2016  Class creation  
***********************************************************************/
public with sharing class TEL_LostProductOrder {
    
    //Variables
    TEL_TelesalesWrapper.ProductInfo wrapperProduct;
    
    //Constructor
    public TEL_LostProductOrder() {
        this.wrapperProduct = new TEL_TelesalesWrapper.ProductInfo();
    }
    
    //Creates only one wrapper product to show closed lost 
    //opportunities message
    public List<TEL_TelesalesWrapper.ProductInfo> getWrapperProduct() {
        List<TEL_TelesalesWrapper.ProductInfo> wrapperProductsList = new List<TEL_TelesalesWrapper.ProductInfo>();
        this.wrapperProduct.lostOrderMessage = Label.TEL_Closed_Lost_Opp_Message;
        wrapperProductsList.add(this.wrapperProduct);
        
        return wrapperProductsList;
    }
}