global class VPM_VendorDetailsType {

    public String ECC;
    public Integer VendorCode;
    public String BankCountry;
    public Integer BankKey;
    public Integer BankAccount;
    public Integer ControlKey;
    public String AccountHolder;
    public String IBAN;
    public String CompanyCode;
    public String BankName;
    public String SwiftKey;
    public Boolean Blocked;
    public Boolean Deleted;

    
    public static VPM_VendorDetailsType parse(String json) {
        return (VPM_VendorDetailsType ) System.JSON.deserialize(json, VPM_VendorDetailsType .class);
    }
}