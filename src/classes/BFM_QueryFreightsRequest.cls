public class BFM_QueryFreightsRequest {
    public class QueryFreights{
        public Set<String> shipmentNumbers;
        public String queryType;
    }
    public QueryFreights QueryFreights;
    
    public BFM_QueryFreightsRequest(Set<String> shipmentNumber, String queryType){
        this.QueryFreights = new BFM_QueryFreightsRequest.QueryFreights();
        this.QueryFreights.shipmentNumbers = shipmentNumber;
        this.QueryFreights.queryType = queryType;
    }
}