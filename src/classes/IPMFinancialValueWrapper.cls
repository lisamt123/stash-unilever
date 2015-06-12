public class IPMFinancialValueWrapper {
    public Integer index {get; set;}
    public Decimal value {get; set;}
    public Decimal difference {get; set;}
    public Integer scale {get; set;}
    
    public ipmFinancialValueWrapper(Integer index, Decimal value, Decimal difference){
        this.scale = 2;
        this.index = index;
        this.value = value.setScale(scale);
        this.difference = difference.setScale(scale);
    }
    
    public ipmFinancialValueWrapper(Integer index, Decimal value, Decimal difference, Integer scale){
        this.scale = scale;
        this.index = index;
        this.value = value.setScale(scale);
        this.difference = difference.setScale(scale);
    }
}