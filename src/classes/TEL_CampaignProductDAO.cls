/**********************************************************************
Name: TEL_CampaignProductDAO
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
DAO class for retrieve queries in objet Campaign_Product
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  09/12/2016  Class creation  
***********************************************************************/

public class TEL_CampaignProductDAO {
    
    // Instance Class
    private static final TEL_CampaignProductDAO instance = new TEL_CampaignProductDAO();
        
    // Construtor 
    public TEL_CampaignProductDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static TEL_CampaignProductDAO getInstance()
    {
    	return instance;
	}
    
    // Retrieve products campaign based related to campaign id.  
    public List<TEL_Campaign_Products__c> getCampaignProduct(Id campaignId)
    {
        System.debug('Entering <getCampaignProduct>');
        return [Select 		Name, 
                			TEL_Campaign__c, 
                			TEL_Product_Name__c
               	From 		TEL_Campaign_Products__c
                Where 		TEL_Campaign__c =: campaignId ];
    }

}