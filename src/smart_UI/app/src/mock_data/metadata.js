"use strict";

var SFDS = require('./salesforceDS');
var MetadataMock = require('./metadatamock');
var configuration = require("json!../configuration.json");

var MetaDataService = {
    getMetaData: function (txId, bo, sfObject, isExternal, handler) {
        var result = when.defer();
        if (sfObject) {
            if (AppSettings.get('metadataMock')) {
                if (MetadataMock[sfObject]) {
                    result.resolve(MetadataMock[sfObject])
                } else {
                    throw("METADATA MOCK for " + sfObject + " does not exist!!");
                }
            } else {
                var describe = SFDS.describe(sfObject);
                describe.then((res) =>{
                    AppContext.setOnGroup('Metadata', sfObject, res);
                    result.resolve(res);
                }, error => {
                    result.reject(error);
                });
            }
        } else {
            result.resolve({});
        }
        return result.promise;
    },

    connect: function () {
        AppSettings.pushSettings(configuration);
        if (!AppSettings.get('metadataMock'))
            return SFDS.connect();
        else {
            var result = when.defer();
            result.resolve();
            return result.promise;
        }
    },

    getLoggingStreams: function (handler) {
        var result = '[{"level":"error","target":"ConsoleTarget"}]';

        var res = JSON.parse(result);
        var configarr = res.map(c => {
            return {"level": c.level, "stream": new window[c.target](), "type": "raw"};
        });
        handler(configarr);
    }
};

module.exports.MetaDataService = MetaDataService;

