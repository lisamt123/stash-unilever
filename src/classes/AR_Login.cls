global with sharing class AR_Login {
	
	global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        return Site.login(username, password, Site.getPrefix() + '/AR_LandingPage');
    }
    
   	global AR_Login () {}
   

}