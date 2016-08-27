global class ICB_PriceTable_CC {
    
    public static List<PriceBookEntry> listPB = new List<PriceBookEntry>();

   //00519000000PPjb 
    @AuraEnabled
    public static List<PriceBookEntry> getProducts() {
        system.debug('Starting method: getProducts');
        String strAccountName 	= null;
        String strContactId 	= null;
        
        try {
            strContactId = ICB_ContactDAO.getInstance().getContactId(UserInfo.getUserId());
            
            Contact contato = ICB_ContactDAO.getInstance().getContact(strContactId);
            
            strAccountName = ICB_AccountDAO.getInstance().getAccount(contato);
            
            listPB = ICB_PriceBookEntryDAO.getInstance().getPricebook(strAccountName);            
            
        } catch (Exception e) {   
            system.debug('Method getProducts error: ' + e.getCause());
        }
        system.debug('Finishing method: getProducts');
        return listPB;
        
    }
    
    @AuraEnabled
    public static void updateValues(List<PriceBookEntry> listProduct) {
        System.debug('Entering <listProduct>: '+listProduct);
        if(listProduct.isEmpty()) {
            return;
        } else {
        	Database.update(listProduct);    
        }
    }

    
}