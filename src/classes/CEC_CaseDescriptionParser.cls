public with sharing class CEC_CaseDescriptionParser {
    
    public static String getPersonMailingStreet(String caseDescription) {
        try{
            String address1 = getFieldValue(caseDescription, CEC_Constants.ADDRESS1);
            String address2 = getFieldValue(caseDescription, CEC_Constants.ADDRESS2);
            String mailingStreet= (String.isNotBlank(address1)? address1 : '');
            mailingStreet= (String.isNotBlank(address2)? (mailingStreet = mailingStreet +' '+address2) : mailingStreet);
            if(String.isNotBlank(mailingStreet)) {
                return mailingStreet;
            } else {
                return null;
            }
        }catch(exception e){
            return null;
        }
    }
    
    public static String getCaseEmail(String caseDescription) {
        try{
            String email = getFieldValue(caseDescription, CEC_Constants.EMAIL_ADDRESS);
            if(String.isEmpty(email)) {
                email = getFieldValue(caseDescription, CEC_Constants.EMAIL);
            }
            return email;
        }catch(exception e){
            return null;
        }
    }
    
    public static String getFirstName(String caseDescription) {
        try{
            String firstName = getFieldValue(caseDescription, CEC_Constants.FIRSTNAME_v1);
            if(String.isEmpty(firstName)) {
                firstName = getFieldValue(caseDescription, CEC_Constants.FIRSTNAME_v2);
            }
            return firstName;
        }catch(exception e){
            return null;
        }
    }
    
    public static String getLastName(String caseDescription) {
        try{
            String lastName = getFieldValue(caseDescription, CEC_Constants.LASTNAME_v1);
            if(String.isEmpty(lastName)) {
                lastName = getFieldValue(caseDescription, CEC_Constants.LASTNAME_v2);
            }
            return lastName;
        }catch(exception e){
            return null;
        }
    }
    
    public static String getBrand(String caseDescription) {
        try{    
            return getFieldValue(caseDescription, CEC_Constants.BRAND);
        }catch(exception e){
            return null;
        }
    }
    
    public static String getCaseUPC(String caseDescription) {        
        try{    
            return getFieldValue(caseDescription, CEC_Constants.UPC);
        }catch(exception e){
            return null;
        }
    }
    
    public static String getStoreName(String caseDescription) {        
        try{    
            return getFieldValue(caseDescription, CEC_Constants.STORE_NAME);
        }catch(exception e){
            return null;
        }
    }
    
    public static String getPersonMailingCity(String caseDescription) {        
        try{    
            return getFieldValue(caseDescription, CEC_Constants.CITY);
        }catch(exception e){
            return null;
        }
    }
        
    public static String getPersonMailingState(String caseDescription) {
        try{
            String state = getFieldValue(caseDescription, CEC_Constants.STATE);
            if(String.isEmpty(state)) {
                state = getFieldValue(caseDescription, CEC_Constants.PROVINCE);
            }
            return state;
        }catch(exception e){
            return null;
        }
    }
     
    public static String getPersonMailingPostalCode(String caseDescription) {
        try{
            String zipCode = getFieldValue(caseDescription, CEC_Constants.ZIP);
            if(String.isEmpty(zipCode)) {
                zipCode = getFieldValue(caseDescription, CEC_Constants.POSTAL);
            }
            if(String.isEmpty(zipCode)) {
                zipCode = getFieldValue(caseDescription, CEC_Constants.ZIPCODE);
            }
            return zipCode;
        }catch(exception e){
            return null;
        }
    }
    
    public static String getPersonMailingCountry(String caseDescription) {
        try{
            return getFieldValue(caseDescription, CEC_Constants.COUNTRY);
        }catch(exception e){
            return null;
        }
    }
    
    private static String getFieldValue(String description, String searchString ){
        String value = '';
        String upperCaseDescription;
        // Convert description to uppercase
        upperCaseDescription = description.toUpperCase();
        // extract required value and format result
        if(upperCaseDescription.contains(searchString)){
            Integer index = description.indexOfIgnoreCase(searchString);
            System.debug('value :'+ value + ' index: '+ index);      
            value = description.substring(index + searchString.length(), description.indexOf('\n', index + searchString.length()));
            value = value.removeStart(' : ').removeStart(' :').removeStart(': ').removeStart(':').replace(']','').trim();
            if(searchString == 'EMAIL' || searchString == 'EMAIL ADDRESS'){
                value = value.removeStartIgnoreCase('Address');
                if(value.indexOf('<') != -1){
                    value = value.subString(0, value.indexOf('<'));
                }
            }
            System.debug('value :'+ value + ' index: '+ index);
            return value;
        }else{
            return null;
        }        
    }
}