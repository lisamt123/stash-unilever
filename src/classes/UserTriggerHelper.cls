public class UserTriggerHelper {
    public static void checkisocurrency(Map<ID,User> mapNewUser)
    {
        if(!mapNewUser.isEmpty())
        {
            for (User user:mapNewUser.values())
            {
                if(user.CannotChangeMC__c && (User.DefaultCurrencyIsoCode !=User.CurrencyIsoCode))
                    user.DefaultCurrencyIsoCode=user.CurrencyIsoCode;
            }
        }
        
    }
    
}