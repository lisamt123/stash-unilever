public class PQN_HelibronnJSON2Apex {

    public List<DataCollection> DataCollection;

    public class DataCollection {
        public String Month;
        //[JsonProperty(PropertyName = "Supplier Name")]
        public String DN;
        public String SourceFactory;
        public String SourceDC;
        public string ReportingDC;
        public string ProductGroup;
        public string ProductNumberSKU;
        public string LotCode;
        public string ProductName;
        public string LossCode;
        public string LossLevel1;
        public string LossLevel2;
        public string LossLevel3;
        public string LossLevel4;
        public string AdditionalInfo;
        public integer NumberPalletsaffected;
        
    }

    
    public static PQN_HelibronnJSON2Apex parse(String json) {
        return (PQN_HelibronnJSON2Apex) System.JSON.deserialize(json, PQN_HelibronnJSON2Apex.class);
    }
}