@isTest
private class BFM_CreateUser_Test{

    static testMethod void passwordresettest(){
        list<User> userList = new list<User>([Select languagelocalekey, localesidkey, TimezoneSidKey from User where id = '0058A000000erKy']);
        Contact cont = new Contact();
        User userToCreate = new User();
        userToCreate.ContactId = cont.id;
        userToCreate.ProfileId = '00eE0000000ZkiK';
        userToCreate.username = 'test@test.com';
        userToCreate.FirstName = 'First';
        cont.LastName = 'Last';
        userToCreate.LastName = cont.LastName;
        userToCreate.email = 'test@test.com';
        String alias = userToCreate.username;
        if(alias.length() > 5){
            alias = alias.substring(0,5);
        }
        userToCreate.alias = alias;
        userToCreate.languagelocalekey = userList [0].languagelocalekey;
        userToCreate.localesidkey = userList [0].localesidkey;
        userToCreate.emailencodingkey = 'UTF-8';
        userToCreate.TimezoneSidKey = userList[0].TimezoneSidKey;
        insert cont;
        try{
        	insert userToCreate;
        }catch(Exception e){}
        }
}