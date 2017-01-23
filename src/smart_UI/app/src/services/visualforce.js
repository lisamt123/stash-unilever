var fetchs = {};

function f(url){
    return fetchs[url] = fetchs[url] || fetch(url,{credentials: 'include'}).then(request => request.text());
}

function login({endpoint, username, password}){
    if(sessionStorage.skipLogin == 'true') return Promise.resolve();
    return fetch(endpoint,{
        credentials: 'include',
        method: 'POST',
        headers: {
            "Content-type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: (() => {
            var data = '',
                params = {
                    un: username,
                    username: username,
                    pw: password,
                    Login: 'Log In',
                    width: '1600',
                    height: '900',
                    hasRememberUn: 'true',
                    startURL: '',
                    loginURL: '',
                    loginType: '',
                    useSecure: 'true',
                    local: '',
                    lt: 'standard',
                    qs: '',
                    locale: '',
                    oauth_token: '',
                    oauth_callback: '',
                    login: '',
                    serverid: '',
                    display: 'page',
                    ExtraLog: `%5B%7B%22width%22:1600%7D,%7B%22height%22:900%7D,%7B%22language%22:%22es%22%7D,%7B%22offset%22:-1%7D,%7B%22scripts%22:%5B%7B%22size%22:249,%22summary%22:%22if%20(self%20==%20top)%20%7Bdocument.documentElement.style.v%22%7D,%7B%22size%22:585,%22summary%22:%22var%20SFDCSessionVars=%7B%5C%22server%5C%22:%5C%22https://login.sales%22%7D,%7B%22url%22:%22${endpoint}/jslibrary/SfdcSessionBase204.js%22%7D,%7B%22url%22:%22${endpoint}/jslibrary/LoginHint204.js%22%7D,%7B%22size%22:26,%22summary%22:%22LoginHint.hideLoginForm();%22%7D,%7B%22size%22:36,%22summary%22:%22LoginHint.getSavedIdentities(false);%22%7D,%7B%22url%22:%22${endpoint}/jslibrary/baselogin2.js%22%7D,%7B%22url%22:%22${endpoint}/jslibrary/LoginMarketingSurveyResponse.js%22%7D,%7B%22size%22:357,%22summary%22:%22function%20handleLogin()%7Bdocument.login.un.value=doc%22%7D%5D%7D,%7B%22scriptCount%22:9%7D,%7B%22iframes%22:%5B%22https://c.salesforce.com/login-messages/promos.html%22,%22https://login.salesforce.com/login/sessionserver204.html%22%5D%7D,%7B%22iframeCount%22:2%7D%5D`
                };

            for(let key of Object.keys(params)) data += encodeURIComponent(key) + '=' + encodeURIComponent(params[key]) + '&';
            data = data.slice(0,-1);
            return data;
        })()
    }).then(() => sessionStorage.skipLogin = 'true');
}

function getInitializationData(endpoint){
    return f(endpoint)
    .then(text =>
        JSON.parse(
            (text.match(/<script type="text\/javascript">\s*Visualforce\.remoting\.Manager\.add\(\s*new\s*\$VFRM\.RemotingProviderImpl\(([^]*?)\)\s*\)/) || [])[1]
        )
    );
};

function getSessionId(endpoint){
    return f(endpoint)
    .then(text => (text.match(/sforce\.connection\.sessionId\s*\=\s*(['"`])(.*?)\1/) || [])[2]);
}

function initializeJSRemoting({login: loginOptions, endpoint}){
    return login(loginOptions).
    then(() => getInitializationData(endpoint)).
    then(data => {
        data.vf.dev = data.vf.tst = true;
        Visualforce.remoting.Manager.add(
            new $VFRM.RemotingProviderImpl(data)
        );
    }).
    then(() => getSessionId(endpoint)).
    then(sessionId => global.sforce ? sforce.connection.sessionId = sessionId : null).
    then(null,function(err){
        delete sessionStorage.skipLogin;
        throw err;
    });
};

function initFromConfig(){
    var configuration = require("json!../configuration.json");

    AppSettings.pushSettings(configuration);
    global.VF_REMOTING_HOST = AppSettings.get('vfhost');

    return initializeJSRemoting({
        endpoint: `https://${VF_REMOTING_HOST}/apex/${VF_PATH}`,
        login: {
            username: AppSettings.get('sfuser'),
            password: AppSettings.get('sfpwd'),
            endpoint: AppSettings.get('sfloginurl')
        }
    });
}

module.exports = {login, getInitializationData, getSessionId, initializeJSRemoting, initFromConfig};
