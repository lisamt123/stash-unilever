"use strict";

var jsforce = require('jsforce');
//var when = require('./when');
//var User = require('./models/User');

module.exports = (function () {
    return new function () {
        var self = this;
       

        self.connect = function () {
            var result = when.defer();
           
            self.conn = new jsforce.Connection({
                // you can change loginUrl to connect to sandbox or prerelease env.
                loginUrl: AppSettings.get('sfloginurl')
            });

            var username = AppSettings.get('sfuser');
            var password = AppSettings.get('sfpwd');

            self.conn.login(username, password, function (err, userId) {
                if (err) {
                    console.error(err);
                    result.reject(err);
                }

                self.conn.identity(function (err, userInfo) {
                    if (err) {
                        return console.error(err);
                        result.reject(err);
                    }
                    //TODO
                    //var appUser = new User();
                    var appUser = {};
                    // appUser.SFUserInfo = userInfo;//TODO
                    // AppContext.set('appUser', appUser);
                    result.resolve(appUser);
                });
            });

            return result.promise;
        };
        //call connect on load
        //  self.connect();

        self.customLabels = function (bundle) {
            var result = when.defer();
            // self.conn.metadata.read('CustomLabels',null,function (err, meta) {
            self.conn.metadata.list('CustomLabels', '36.0', function (err, meta) {

                if (err) {
                    return console.error(err);
                }

                // bo.setSfMeta(fields);
                result.resolve(meta);
            });

            return result.promise;
        };


        self.describe = function (sfTable) {
            var result = when.defer();
            LogManager.getLogger('SFDS').trace('Describe ', sfTable);
            self.conn.sobject(sfTable).describe(function (err, meta) {
                if (err) {
                    result.reject(err);
                    return;
                }
                console.log('Label : ' + meta.label);
                var fields = {};
                meta.fields.map(function (f) {
                    fields[f.name] = f
                    f.mandatory=!f.Nillable;
                });


                // bo.setSfMeta(fields);
                result.resolve(fields);
            });

            return result.promise;
        };

        self.apexCall = function (apexController, payload, handler) {
            self.conn.apex.post("/" + apexController + "/", payload, function (err, res) {
                if (err) {
                    return console.error(err);
                }
                console.log("response: ", res);
                // the response object structure depends on the definition of apex class
                handler(res);
            });
        };

        self.apexGet = function (apexController, handler) {
            self.conn.sobject("Product__c").retrieve("a0d61000000OEAXAA4", function (err, res) {
                if (err) {
                    return console.error(err);
                }
                handler(res);
            });
            /*self.conn.apex.get("/"+apexController+"/aa",  function(err, res) {
             if (err) { return console.error(err); }
             console.log("response: ", res);
             // the response object structure depends on the definition of apex class
             handler(res);
             });*/
        };

        self.query = function (bo, fields, jsonQuery) {
            var result = when.defer();
            var builtQuery = 'SELECT ' + fields.join(',') + ' FROM ' + bo.getSfTable() + ' WHERE ';

            var conditions = [];
            _.mapKeys(jsonQuery, function (k, v) {
                conditions.push(v + "='" + k + "'")
            });

            builtQuery += conditions.join(' AND ');

            self.conn.query(builtQuery, function (err, records) {
                if (err) {
                    return console.error(err);
                    result.reject(err);
                }
                result.resolve(records);
            });

            return result.promise;
        };
    };
})();
