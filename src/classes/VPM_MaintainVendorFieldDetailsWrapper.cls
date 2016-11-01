public class VPM_MaintainVendorFieldDetailsWrapper {
    
    public Integer RequestID {get; set;}
    public string RequestorName {get; set;}
    public string RequestorPhone {get; set;}
    public string RequestorEmail {get; set;}
    public string RequestorCountry {get; set;}
    public string RequestorDepartment {get; set;}
    public string OriginatorEmail {get; set;}
    public string RequestDate {get; set;}
    public string VendorNumber {get; set;}
    
    //vendor code
    public integer VendorCode {get; set;}
    public string VendorName {get; set;}
    public string BpmComments {get; set;}
    //VPM_ECCSystem
    public string extendRegion {get; set;}
    public string Name1 {get; set;}
    public string Name2 {get; set;}
    public string Name3 {get; set;}
    public string Name4 {get; set;}
    public string SearchTerm1 {get; set;}
    public string SearchTerm2 {get; set;}
    
    public string Street {get; set;}
    public string Street2 {get; set;}
    public string Street3 {get; set;}
    public string Street4 {get; set;}
    public string HouseNumber {get; set;}
    public string HouseNumberSupplement {get; set;}
    
    public string CityPostalCode {get; set;}  // is it same 'PoPostalCode' ?
    public string Region {get; set;}
    public string Country {get; set;}
    public string City {get; set;}
    public string District {get; set;}
    
    public boolean SmeIndicator {get; set;}
    public boolean ExceptionIndicator {get; set;}
   // public string ExceptionType {get; set;}
    
    public string AttachmentLink;
    
    public string PoBox {get; set;}
    public string PoPostalCode {get; set;}
    
    public string TaxNumber1 {get; set;}
    public string TaxNumber2 {get; set;}
    public string TaxNumber3 {get; set;}
    public string TaxNumber4 {get; set;}
    public string VatRegistrationNumber {get; set;}
    public Boolean IsNaturalPerson {get; set;}
    public string TaxNumberType {get; set;}
    public string TaxJurisdictionCode {get; set;}
    public string taxNumAtResponsibleTaxAuthority {get; set;}
    public string ExternalManufacturer {get;set;}
    
    public string CreditInformationNumber {get; set;}
    public string corporateGrp {get; set;}
    public string InternationalLocationNumber1 {get; set;}
    public string InternationalLocationNumber2 {get; set;}
    public string TaxType {get; set;}
    public string CheckDigit {get; set;}
    public Boolean Cordillera;
    public Boolean U2K2;
    public Boolean Sirius;
    public Boolean Fusion;
    
}