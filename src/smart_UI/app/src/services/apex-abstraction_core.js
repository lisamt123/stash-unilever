'use strict';

module.exports = apexAbstractionCore;

function apexAbstractionCore() {
}

apexAbstractionCore.prototype = {
    invokeRemoteCall: function (method, extension, managed, compressed, buffer, isManagedObject, ...args) {
        var startTime = new Date();
        var me = this;
        var result = when.defer();

        var transactionId = Utils.guid();
        const remoteCall = (ACSFNamespace && managed) ? ACSFNamespace + '.' + extension + '.' + method : extension + '.' + method;
        // TODO: Check this syntax once UI is running. Should solve the namespace issue
        //const remoteCall = '{!$RemoteAction.' + extension + '.' + method + className + '}';

        var callback = function (callResult, event) {
            var rex = /[A-Z]/g;

            console.log(callResult,event);
            if (event.status) {
                //  result.resolve({'__Model': className, '__Status': event.status, 'data': callResult});
                if (!compressed) {
                    if (isManagedObject)
                        callResult = AppManager.removeACSFNamespace(callResult);
                    LogManager.getLogger("APEXAbstraction").info({txid: transactionId}, "END: RemoteCall: ", remoteCall, "==> Duration ", new Date() - startTime, " ms", callResult);

                    result.resolve({
                        '__Model': event.method.substring(rex.exec(event.method).index),
                        '__Status': event.status,
                        'data': callResult
                    });
                }
                else {
                    me.readPagedResponse(callResult).then(pagedResult => {
                        try {
                            if (isManagedObject)
                                callResult = AppManager.removeACSFNamespace(pagedResult);
                            LogManager.getLogger("APEXAbstraction").info({txid: transactionId}, "END: RemoteCall: ", remoteCall, "==> Duration ", new Date() - startTime, " ms", callResult);

                            result.resolve({
                                '__Model': event.method.substring(rex.exec(event.method).index),
                                '__Status': event.status,
                                'data': callResult
                            });
                        }
                        catch (e) {
                            ExceptionHandler.treatJSError(e);
                        }
                    });
                }
            }
            else {
                //result.resolve({'__Model': className, '__Status': event.status, 'ExceptionType': event.type, 'ExceptionMessage': event.message, 'ExceptionWhere': event.where});
                ExceptionHandler.treatJSError(event);
                LogManager.getLogger("APEXAbstraction").error({txid: transactionId}, "Exception: RemoteCall: ", remoteCall, event.action, event.method, event.message, event.data);
                result.resolve({
                    '__Model': event.action,
                    '__Status': event.status,
                    'ExceptionType': event.type,
                    'ExceptionMessage': event.message,
                    'ExceptionWhere': event.where
                });
            }
        };
        if (isManagedObject)
            args = args.map(param=> {
                return AppManager.addACSFNamespace(param);
            });

        LogManager.getLogger("APEXAbstraction").info({txid: transactionId}, "START: RemoteCall: ", remoteCall, ", Managed: ", managed, ", Compressed:", compressed, ", Buffer:", buffer, ", isManagedObject", isManagedObject);

        var logError = console.error;
        console.error = error => {
            ExceptionHandler.treatJSError(error);
            result.reject(error);
        };

        if($VFRM.last) $VFRM.last.setTimeout = request => request.timeout = 1e7;
        Visualforce.remoting.Manager.invokeAction(remoteCall, transactionId, ...args, callback, {
            escape: false,
            buffer: buffer
        });

        console.error = logError;

        return result.promise;
    },

    readPagedResponse: function (response) {
        var result = when.defer();
        var startTime = new Date();
        var method = "getMessageContinuation";
        var extension = "ContinuationRemoteActionExtension";
        var firstMsg = JSON.parse(response);
        var pages = firstMsg.pages;
        var id = firstMsg.responseid;
        var promises = [];

        for (var i = 2; i <= pages; i++) {
            promises.push(this.invokeRemoteCall(method, extension, true, false, false, true, id, i.toString()));
        }

        when.all(promises).then(function (dataArray) {
            LogManager.getLogger("APEXAbstraction").info("Reading ", pages, "from cache", id, "==> Duration ", new Date() - startTime, " ms");
            var msgs = dataArray.map(function (data) {
                return JSON.parse(data.data).response;
            });
            msgs.unshift(firstMsg.response);
            Utils.Zip.unzip(msgs).then(uncompressedMsg => {
                result.resolve(uncompressedMsg);
            });
        });

        return result.promise;
    },

    read: function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
        var loadParams = (objectId instanceof Object) ? JSON.stringify(objectId) : objectId;
        return this.invokeRemoteCall('read' + className, extension, managed, compressed, buffer, isManagedObject, loadParams);
    },

    readAll: function (className, extension, managed, compressed, buffer) {
        return this.invokeRemoteCall('readAll' + className, extension);
    },

    write: function (objectId, objectContent, className, extension, managed, compressed, buffer, isManagedObject) {
        return this.invokeRemoteCall('write' + className, extension, managed, compressed, buffer, isManagedObject, objectId, objectContent);
    },

    create: function (objectContent, className, extension, managed, compressed, buffer, isManagedObject) {
        return this.invokeRemoteCall('create' + className, extension, managed, compressed, buffer, isManagedObject, objectContent);
    },

    delete: function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
        return this.invokeRemoteCall('delete' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
    },

    getEARights: function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
        var loadParams = (objectId instanceof Object) ? JSON.stringify(objectId) : objectId;
        return this.invokeRemoteCall('getEARights' + className, extension, managed, compressed, buffer, isManagedObject, loadParams);
    },
    copy : function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('copy' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
},

getData : function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('getData' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
},

getMeta : function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
    return this.invokeRemoteCall('getMeta' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
},
    /**/
    // Helper methods. Not related to any business object.
    // Should maybe be moved into a separate class. For the moment they recide here, however
    /*readContractById: function (classNames) {
     var contractPromise = when.defer();
     this.invokeRemoteCall('readContractById', 'ContractRemoteActionExtension', classNames).then(contracts => {
     var contractArray = [];
     contracts.forEach(function(contract) {
     contractArray.push(JSON.parse(contract));
     });
     contractPromise.resolve(contractArray);
     });
     return contractPromise;
     },
     readBaseclassById: function (baseClassName, blObject, methods) {
     var methodPromise = when.defer();
     this.invokeRemoteCall('readContractById', 'ContractRemoteActionExtension', baseClassName).then(classString => {
     this.eval(baseClassContent);
     methods.forEach(function (method) {
     blObject.Methods[method.Name] = this[baseClass][method.Name];
     });
     methodPromise.resolve(true);
     });
     return methodPromise.promise;
     },*/

  
    readCustomLabels: function (labelCategory) {
        var customLabelsAPEX = AppManager.getCustomLabelsApex();
        return this.invokeRemoteCall(customLabelsAPEX.Type, customLabelsAPEX.Extension, customLabelsAPEX.Managed, customLabelsAPEX.Compressed, customLabelsAPEX.Buffer, true, labelCategory);
    },

    getLocale: function () {
        var localeAPEX = AppManager.getLocaleApex();
        return this.invokeRemoteCall(localeAPEX.Type, localeAPEX.Extension, localeAPEX.Managed, localeAPEX.Compressed, localeAPEX.Buffer, true);
    },

    getMetaData: function (boName, sfObjectName, isExternal, isManagedObject) {
        var metaDataAPEX = AppManager.getMetaDataApex(),
            promise,deferred,i;

        if(metaDataAPEX.Aggregation === false){
            promise = this.invokeRemoteCall(metaDataAPEX.Type, metaDataAPEX.Extension, metaDataAPEX.Managed, metaDataAPEX.Compressed, metaDataAPEX.Buffer, isManagedObject, boName, sfObjectName, isExternal);
        }else{

            if(!this._metaDataBuffer){

                deferred = when.defer();
                this._metaDataBuffer = [];
                this._metaDataPromise = deferred.promise;

                setTimeout(() => {
                    var list = this._metaDataBuffer;
                    delete this._metaDataBuffer;
                    delete this._metaDataPromise;
                    deferred.resolve( this.getMetaDataList(list, isManagedObject) );
                },10);

            }

            i = this._metaDataBuffer.length;
            this._metaDataBuffer.push(arguments);
            promise = this._metaDataPromise.then(result => ({
                '__Model': result.__Model,
                '__Status': result.__Status,
                'data': result.data ? result.data[i].fields : null,
                'ExceptionType': result.ExceptionType,
                'ExceptionMessage': result.ExceptionMessage,
                'ExceptionWhere': result.ExceptionWhere
            }));

        }

        return promise.then(response => {
            var hasPickLists = false;

            var hasCheckoutFlagSet = (AppManager.getArtifact(
                (AppManager.getArtifact(boName).Artifact || {}).DataSource
            ).Artifact || {}).CheckLayout || false;

            if(!response.data){
                response.data = {fields: []};
                return response;
            }

            for(let field of response.data.fields){
                field.getPicklistValues = getPicklistValues;
                field.recordTypes = {};
                if(field.type == 'PICKLIST') hasPickLists = true;
            }

            if(!hasCheckoutFlagSet) return response;
            if(!sfObjectName) return response;

            if(hasPickLists){

                let deferred = when.defer();

                if(isManagedObject) sfObjectName = AppManager.addACSFNamespace(sfObjectName);
                sforce.connection.describeLayout(sfObjectName, null, null, {
                    onSuccess: result => deferred.resolve(result),
                    onFailure: error => deferred.reject(error)
                });

                deferred.promise.then(layout => {
                    var recordTypes = {};

                    if(isManagedObject) layout = AppManager.removeACSFNamespace(layout);
                    _.extend(response, layout);

                    for(let mapping of getArray(layout.recordTypeMappings)){
                        for(let picklist of getArray(mapping.picklistsForRecordType)){

                            recordTypes[picklist.picklistName] = recordTypes[picklist.picklistName] || {};
                            recordTypes[picklist.picklistName][mapping.recordTypeId] = picklist;
                            for(let value of getArray(picklist.picklistValues)){
                                value.active = value.active == 'true';
                                value.defaultValue = value.defaultValue == 'true';
                            }

                        }
                    }

                    for(let field of response.data.fields){
                        field.recordTypes = recordTypes[field.name] || {};
                    }

                });

            }

            return response;
        });
    },

    getMetaDataList: function (list, isManagedObject) {
        var metaDataAPEX = AppManager.getMetaDataListApex();
        var query = [];
        var args;

        for(args of list) query.push({
            businessObject: args[0],
            sfObject: args[1],
            isExternal: args[2]
        });

        return this.invokeRemoteCall(metaDataAPEX.Type, metaDataAPEX.Extension, metaDataAPEX.Managed, metaDataAPEX.Compressed, metaDataAPEX.Buffer, isManagedObject, JSON.stringify(query));
    },

    getLoggingConfig: function () {
        return this.invokeRemoteCall('getLogConfig', "LogRemoteActionExtension", true, false, true, true);
    },

    writeLogs: function (logs) {
        return this.invokeRemoteCall('writeLogs', "LogRemoteActionExtension", true, false, true, true, logs);
    }
};

function getPicklistValues(recordTypeId){
    return (this.recordTypes[recordTypeId] || this).picklistValues || [];
}

function getArray(arr){
    if(arr instanceof Array) return arr;
    return [arr];
}

var ExceptionHandler = {
    treatJSError: function (event) {
        var msg = event.message || event + '';
        UI_EVENT_BUS.put(EVENTS.UI_ERROR, {title: 'Service Error',  message:msg,   type:'E'});
    }
};

module.exports.ExceptionHandler = ExceptionHandler;
