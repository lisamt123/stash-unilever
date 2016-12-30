global class KpiValueDescriptor
    {
    public string level{get; set;}
    public string id{get; set;}
    public string kpiId{get; set;}
    public double value{get; set;}
        public KpiValueDescriptor() {}
        public KpiValueDescriptor(String promoId, String kpi, String level, double v){
            
        level = 'measure';
        id = promoId;
        kpiId = kpi;
         value =v ;
       
        }
    }