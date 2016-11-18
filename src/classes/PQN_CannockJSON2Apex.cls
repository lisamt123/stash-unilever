public class PQN_CannockJSON2Apex {

    public List<DataCollection> DataCollection;

    public class DataCollection {
        public String Month;
        //[JsonProperty(PropertyName = "Supplier Name")]
        public String SupplierName;
        public String Depot;
        public String ProductCode;
        public String RejectCode;
        public integer NumberPalletsAffected;
    }

    
    public static PQN_CannockJSON2Apex parse(String json) {
        return (PQN_CannockJSON2Apex) System.JSON.deserialize(json, PQN_CannockJSON2Apex.class);
    }
}