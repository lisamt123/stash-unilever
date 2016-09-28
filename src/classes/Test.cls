public with sharing class Test {

    List<Account> acts =[Select Name,Type,Industry,Fax,Phone from Account Where Type ='Customer'];
    
    Public List<Account> getacts(){
    
    return acts;
    }
}