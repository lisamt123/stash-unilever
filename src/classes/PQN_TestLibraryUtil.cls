public class PQN_TestLibraryUtil {
    
    public static PQN_Supplier__c createSupplier()
    {
        PQN_Supplier__c s = new PQN_Supplier__c(Name='Test Account Name',
        Supplier_Number__c='2312',
        Supplier_Type__c='DC');
        return s ;
    }
 
    
    public static PQN_Pallet_Quality_Non_Conformance__c createPQN_Pallet_Quality_Non_Conformance(id sid){
        PQN_Pallet_Quality_Non_Conformance__c PQN = new PQN_Pallet_Quality_Non_Conformance__c( 
        Region__c='Europe',
    Reporting_DC__c='fsdf',
    MCO__c='HUAD',
    DC_Country__c='India',
    Cluster__c='Europe',
    Delivery_Note_Number__c='20',
    SKU__c='153489',
    Product_Name__c='sdfsd',
    Date_Pallet_Received__c=date.newInstance(2014, 9, 15),
    Supplier_Number__c ='1234',
    Supplier_type__c='DC',
    Non_compliance_reason_code__c=12);
        return  PQN;
    }
    
   
}