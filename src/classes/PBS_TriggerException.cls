/**
 * Custom trigger exception class
 *
 * @author Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public class PBS_TriggerException extends Exception {
    /**
     * Error code - so we can distinguish exceptions not just by the message or type but also by code
     */
    private Integer code = 0;

    /**
     * Class constructor
     *
     * @param Integer code Code value
     * @param String message Message to assign
     */
    public PBS_TriggerException(Integer code, String message)
    {
        this.setMessage(message);
        this.setCode(code);
    }

    /**
     * @description Sets code value
     * @param Integer newCode Code to assing
     * @return PBS_TriggerException Instance of this object
     */
    public PBS_TriggerException setCode(Integer newCode)
    {
        this.code = newCode;
        return this;
    }

    /**
     * @description Returns currently assigned code
     * @return Integer Current code
     */
    public Integer getCode()
    {
        return this.code;
    }
}