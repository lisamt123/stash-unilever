/*************************************************************** 
    Name: Win_MetadataResponse
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Web Service Response for the Metadata Webservice
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Metadata response
***************************************************************/
global class Win_MetadataResponse extends Win_WebServiceResponse {
    
    public final static Integer SERVER_ERROR_CUSTOMSETTING = -501;          //Error loading required custom settings
    public final static Integer SERVER_ERROR_OBJECTNOTFOUND = -502;         //Error loading the custom setting for a tracked object
    
    
    /**
     *  Response items for the metadata request
     */ 
    private List<Win_MetadataResponseItem> body;
    
    /**
     *  Getters & Setters
     */
    public List<Win_MetadataResponseItem> getBody() {
        return this.body;
    }
    public void setBody(List<Win_MetadataResponseItem> body) {
        this.body = body;
    }

    
    /**
     *  Descriptor for a single Object
     */
    public class Win_MetadataResponseItem {
        
        /**
         *  API Name of the object
         */ 
        public String objectApiName {get; set;}
        
        /**
         *  Layout needed 
         */
        public Boolean layoutNeeded {get; set;}
        
        /**
         *  Displayable
         */
        public Boolean displayable {get; set;}
        
        /**
         * Only metadata object
         */
        public Boolean onlyMetadataNeeded {get; set;}
        
        /**
         *  List of all the custom indexes 
         */
        public List<String> objectCustomIndexList {get; set;}
        
        /**
         *  List of field set descriptors
         */
        public List<Win_MetadataResponseFieldSet> fieldSetList {get; set;}
        
        /**
         *  List of all the custom indexes 
         */
        public List<String> detailFieldSet {get; set;}
        
        /**
         *  List of all custom indexes + required fields + references + system fields
         **/
        public List<String> rawRecordFieldSet {get; set;}
        
        /**
         *  List of all creatable indexes
         **/
        public List<String> createFieldSet {get; set;}
        
        /**
         *  List of all updatable indexes
         **/
        public List<String> editFieldSet {get; set;}
                
        /**
         *  List of all fields used on list
         */
        public List<String> listHeaderFieldSet {get; set;}
        
        /**
        * SObject-map containing all the default values
        */
        public SObject defaultValuesMap {get; set;}
        
        
        /**
         *  Getters & Setters
         */
        public String getObjectApiName() {
            return this.objectApiName;
        }
        public void setObjectApiName(String objectApiName) {
            this.objectApiName = objectApiName;
        }
        public Boolean getLayoutNeeded() {
            return this.layoutNeeded;
        }
        public void setLayoutNeeded(Boolean layoutNeeded) {
            this.layoutNeeded = layoutNeeded;
        }
        public Boolean getOnlyMetadataNeeded() {
            return this.onlyMetadataNeeded;
        }
        public void setOnlyMetadataNeeded(Boolean onlyMetadataNeeded) {
            this.onlyMetadataNeeded = onlyMetadataNeeded;
        }
        public Boolean getDisplayable() {
            return this.displayable;
        }
        public void setDisplayable(Boolean displayable) {
            this.displayable = displayable;
        }
        public List<Win_MetadataResponseFieldSet> getFieldSetList() {
            return this.fieldSetList;
        }
        public void setFieldSetList(List<Win_MetadataResponseFieldSet> fieldSetList) {
            this.fieldSetList = fieldSetList;
        }
        public List<String> getObjectCustomIndexList() {
            return this.objectCustomIndexList;
        }
        public void setObjectCustomIndexList(List<String> objectCustomIndexList) {
            this.objectCustomIndexList = objectCustomIndexList;
        }
        public List<String> getDetailFieldSet() {
            return this.detailFieldSet;
        }
        public void setDetailFieldSet(List<String> detailFieldSet) {
            this.detailFieldSet = detailFieldSet;
        }
        public List<String> getListHeaderFieldSet() {
            return this.listHeaderFieldSet;
        }
        public void setListHeaderFieldSet(List<String> listHeaderFieldSet) {
            this.listHeaderFieldSet = listHeaderFieldSet;
        }

    }
    
    /**
     *  Descriptor for a single FieldSet
     */
    public class Win_MetadataResponseFieldSet {
        
        /**
         *  API Name of the field
         */
        private String name;
        
        /**
         *  List of field API names for this field set
         */
        private List<String> fieldList;
        
        public Win_MetadataResponseFieldSet(String name, List<String> fieldList) {
            this.setName(name);
            this.setFieldList(fieldList);
        }
        
        /**
         *  Getters & Setters
         */
        public String getName() {
            return this.name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public List<String> getFieldList() {
            return this.fieldList;
        }
        public void setFieldList(List<String> fieldList) {
            this.fieldList = fieldList;
        }
    }
    
}