public class PQN_TestLibraryUtil {
    
    public static Supplier__c createSupplier()
    {
        Supplier__c s = new Supplier__c (Name='Test Account Name',
        Supplier_Number__c='2312',
        Supplier_Type__c='DC');
        return s ;
    }
 
    
    public static PQN_Pallet_Quality_Non_Conformance__c createPQN_Pallet_Quality_Non_Conformance(Id supplyid){
        PQN_Pallet_Quality_Non_Conformance__c PQN = new PQN_Pallet_Quality_Non_Conformance__c( Region__c='london',
    Reporting_DC__c='fsdf',
    MCO__c='erwer',
    DC_Country__c='India',
    Cluster__c='rfer',
    Delivery_Note_Number__c='20',
    SKU__c='153489',
    Product_Name__c='sdfsd',
    Date_Pallet_Received__c=date.newInstance(2014, 9, 15),
    Suppliers__c=supplyid,
    Non_compliance_reason_code__c=12
    
        );
        return PQN ;
    }
    
    
}