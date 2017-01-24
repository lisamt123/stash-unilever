public class SAJ_Data {
    
    //['ID', 'Life Expectancy', 'Fertility Rate', 'Region',     'Population'],
    
    public class bubbleChart{
       
        public string xTitle {get;set;}
        
        public string yTitle {get;set;}
        
        public string categoryTitle {get;set;}
        
        public Map<String, String> catOptions {get;set;}
        public Map<String, String> xOptions {get;set;}
        public Map<String, String> yOptions {get;set;}
        public Map<String, String> metricOptions {get;set;}
        
        public string metricTitle {get;set;}
        
        public List<bubbleItem> items {get;set;}
        
        public bubbleChart(){
            items = new List<BubbleItem>();
            catOptions = new Map<String, String>();
            xOptions = new Map<String, String>();
            yOptions = new Map<String, String>();
            metricOptions = new Map<String, String>();
        }
        
                              
    }
    
    
    public class bubbleItem{
        public string Id {get;set;}
        public string Name {get;set;}
        public double xValue {get;set;}
        public double yValue {get;set;}
        public string catValue {get;set;}
        public double metric {get;set;}
        public sObject sob {get;set;}
        
        public bubbleItem(){
            
        }
    }
    
    
}