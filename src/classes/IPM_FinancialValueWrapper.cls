/**
* @author       Cognizant
* @date         27/04/2015
* @description  Wrapper class used to display financials on the ipmFinancial Page and in the Gate Documents
*/
public class IPM_FinancialValueWrapper {
    public Integer index {get; set;} //index
    public Decimal value {get; set;} //decimal value
    public Decimal difference {get; set;} //difference (For Misalignment)
    public Decimal regionalValue {get; set;} //Regional Value (For Misalignment)
    public Decimal localValue {get; set;} //Local Value (For Misalignment)
    public Integer scale {get; set;} //decimal digits
    public Boolean isValueInvalid {get; set;} //if the value invalid
    public Boolean isGrossTOValueInvalid {get; set;} //if the value invalid
    public Boolean isGrossTOGRTIto {get; set;} //if the value invalid
    public Boolean isMinorValueInvalid {get; set;}// this is differentiate below red and yellow highlights.
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param difference     difference
    * @return               NONE
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal difference){
        this.scale = 2;
        this.index = index;
        this.value = value.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isGrossTOValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
    }
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param difference     difference
    * @param scale          scale
    * @return               NONE
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal difference, Integer scale){
        this.scale = scale;
        this.index = index;
        this.value = value.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isGrossTOValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
    }
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param RegionalValue  RegionalValue for misalignment
    * @param LocalValue     LocalValue for misalignment
    * @param scale          scale
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal regionalValue, Decimal localValue, Decimal difference, Integer scale){
        this.scale = scale;
        this.index = index;
        this.value = value.setScale(scale);
        this.regionalValue = RegionalValue.setScale(scale);
        this.localValue = LocalValue.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isGrossTOValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
    }
    
    /*******************************************************************************************************
    * @description          Constructor
    * @param index          index
    * @param value          value
    * @param RegionalValue  RegionalValue for misalignment
    * @param LocalValue     LocalValue for misalignment
    * @param scale          scale
    */
    public IPM_FinancialValueWrapper(Integer index, Decimal value, Decimal regionalValue, Decimal localValue, Decimal difference){
        this.scale = 2;
        this.index = index;
        this.value = value.setScale(scale);
        this.regionalValue = RegionalValue.setScale(scale);
        this.localValue = LocalValue.setScale(scale);
        this.difference = difference.setScale(scale);
        this.isValueInvalid = false;
        this.isGrossTOValueInvalid = false;
        this.isMinorValueInvalid = false;
        this.isGrossTOGRTIto =false;
    }
}