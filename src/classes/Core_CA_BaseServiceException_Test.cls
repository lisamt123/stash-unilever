@istest(seeAlldata = true) 
public with sharing class Core_CA_BaseServiceException_Test {
public static Testmethod void DatabaseServiceUpsertMethodTest(){
         Core_CA_BaseServiceException.resolveExceptions('Hi',new Core_CA_BaseServiceException(
            'Exception occured: AccountServiceController : insertAccount method '));
            Core_CA_BaseServiceException.resolveExceptions(new Core_CA_BaseServiceException(
            'Exception occured: AccountServiceController : insertAccount method '));
            Core_CA_BaseServiceException.resolveExceptions('Hi',new Core_CA_BaseServiceException(
            'Exception occured: AccountServiceController : insertAccount method '),'Hello');
}
}