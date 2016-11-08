public class PQN_CannockJSON2Apex {

    public List<Sheet1> Sheet1;

    public class Sheet1 {
        public String Month;
        //[JsonProperty(PropertyName = "Supplier Name")]
        public String SupplierName;
        public String Depot;
        public String ProductCode;
        public integer RejectCode;
        public integer NumberPalletsAffected;
    }

    
    public static PQN_CannockJSON2Apex parse(String json) {
        return (PQN_CannockJSON2Apex) System.JSON.deserialize(json, PQN_CannockJSON2Apex.class);
    }
}