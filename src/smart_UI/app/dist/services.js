webpackJsonp([1],{

/***/ 0:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	global.ErrorHandler = __webpack_require__(199).ErrorHandler;
	global.APEXAbstraction = __webpack_require__(200);
	global.Tree = __webpack_require__(201);
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 199:
/***/ function(module, exports) {

	'use strict';

	function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

	module.exports = apexAbstractionCore;

	function apexAbstractionCore() {}

	apexAbstractionCore.prototype = {
	    invokeRemoteCall: function invokeRemoteCall(method, extension, managed, compressed, buffer, isManagedObject) {
	        for (var _len = arguments.length, args = Array(_len > 6 ? _len - 6 : 0), _key = 6; _key < _len; _key++) {
	            args[_key - 6] = arguments[_key];
	        }

	        var _Visualforce$remoting;

	        var startTime = new Date();
	        var me = this;
	        var result = when.defer();

	        var transactionId = Utils.guid();
	        var remoteCall = ACSFNamespace && managed ? ACSFNamespace + '.' + extension + '.' + method : extension + '.' + method;
	        // TODO: Check this syntax once UI is running. Should solve the namespace issue
	        //const remoteCall = '{!$RemoteAction.' + extension + '.' + method + className + '}';

	        var callback = function callback(callResult, event) {
	            var rex = /[A-Z]/g;

	            console.log(callResult, event);
	            if (event.status) {
	                //  result.resolve({'__Model': className, '__Status': event.status, 'data': callResult});
	                if (!compressed) {
	                    if (isManagedObject) callResult = AppManager.removeACSFNamespace(callResult);
	                    LogManager.getLogger("APEXAbstraction").info({ txid: transactionId }, "END: RemoteCall: ", remoteCall, "==> Duration ", new Date() - startTime, " ms", callResult);

	                    result.resolve({
	                        '__Model': event.method.substring(rex.exec(event.method).index),
	                        '__Status': event.status,
	                        'data': callResult
	                    });
	                } else {
	                    me.readPagedResponse(callResult).then(function (pagedResult) {
	                        try {
	                            if (isManagedObject) callResult = AppManager.removeACSFNamespace(pagedResult);
	                            LogManager.getLogger("APEXAbstraction").info({ txid: transactionId }, "END: RemoteCall: ", remoteCall, "==> Duration ", new Date() - startTime, " ms", callResult);

	                            result.resolve({
	                                '__Model': event.method.substring(rex.exec(event.method).index),
	                                '__Status': event.status,
	                                'data': callResult
	                            });
	                        } catch (e) {
	                            ExceptionHandler.treatJSError(e);
	                        }
	                    });
	                }
	            } else {
	                //result.resolve({'__Model': className, '__Status': event.status, 'ExceptionType': event.type, 'ExceptionMessage': event.message, 'ExceptionWhere': event.where});
	                ExceptionHandler.treatJSError(event);
	                LogManager.getLogger("APEXAbstraction").error({ txid: transactionId }, "Exception: RemoteCall: ", remoteCall, event.action, event.method, event.message, event.data);
	                result.resolve({
	                    '__Model': event.action,
	                    '__Status': event.status,
	                    'ExceptionType': event.type,
	                    'ExceptionMessage': event.message,
	                    'ExceptionWhere': event.where
	                });
	            }
	        };
	        if (isManagedObject) args = args.map(function (param) {
	            return AppManager.addACSFNamespace(param);
	        });

	        LogManager.getLogger("APEXAbstraction").info({ txid: transactionId }, "START: RemoteCall: ", remoteCall, ", Managed: ", managed, ", Compressed:", compressed, ", Buffer:", buffer, ", isManagedObject", isManagedObject);

	        var logError = console.error;
	        console.error = function (error) {
	            ExceptionHandler.treatJSError(error);
	            result.reject(error);
	        };

	        if ($VFRM.last) $VFRM.last.setTimeout = function (request) {
	            return request.timeout = 1e7;
	        };
	        (_Visualforce$remoting = Visualforce.remoting.Manager).invokeAction.apply(_Visualforce$remoting, [remoteCall, transactionId].concat(_toConsumableArray(args), [callback, {
	            escape: false,
	            buffer: buffer
	        }]));

	        console.error = logError;

	        return result.promise;
	    },

	    readPagedResponse: function readPagedResponse(response) {
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
	            Utils.Zip.unzip(msgs).then(function (uncompressedMsg) {
	                result.resolve(uncompressedMsg);
	            });
	        });

	        return result.promise;
	    },

	    read: function read(objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	        var loadParams = objectId instanceof Object ? JSON.stringify(objectId) : objectId;
	        return this.invokeRemoteCall('read' + className, extension, managed, compressed, buffer, isManagedObject, loadParams);
	    },

	    readAll: function readAll(className, extension, managed, compressed, buffer) {
	        return this.invokeRemoteCall('readAll' + className, extension);
	    },

	    write: function write(objectId, objectContent, className, extension, managed, compressed, buffer, isManagedObject) {
	        return this.invokeRemoteCall('write' + className, extension, managed, compressed, buffer, isManagedObject, objectId, objectContent);
	    },

	    create: function create(objectContent, className, extension, managed, compressed, buffer, isManagedObject) {
	        return this.invokeRemoteCall('create' + className, extension, managed, compressed, buffer, isManagedObject, objectContent);
	    },

	    delete: function _delete(objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	        return this.invokeRemoteCall('delete' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	    },

	    getEARights: function getEARights(objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	        var loadParams = objectId instanceof Object ? JSON.stringify(objectId) : objectId;
	        return this.invokeRemoteCall('getEARights' + className, extension, managed, compressed, buffer, isManagedObject, loadParams);
	    },
	    copy: function copy(objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	        return this.invokeRemoteCall('copy' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	    },

	    getData: function getData(objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	        return this.invokeRemoteCall('getData' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	    },

	    getMeta: function getMeta(objectId, className, extension, managed, compressed, buffer, isManagedObject) {
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

	    readCustomLabels: function readCustomLabels(labelCategory) {
	        var customLabelsAPEX = AppManager.getCustomLabelsApex();
	        return this.invokeRemoteCall(customLabelsAPEX.Type, customLabelsAPEX.Extension, customLabelsAPEX.Managed, customLabelsAPEX.Compressed, customLabelsAPEX.Buffer, true, labelCategory);
	    },

	    getLocale: function getLocale() {
	        var localeAPEX = AppManager.getLocaleApex();
	        return this.invokeRemoteCall(localeAPEX.Type, localeAPEX.Extension, localeAPEX.Managed, localeAPEX.Compressed, localeAPEX.Buffer, true);
	    },

	    getMetaData: function getMetaData(boName, sfObjectName, isExternal, isManagedObject) {
	        var _this = this;

	        var metaDataAPEX = AppManager.getMetaDataApex(),
	            promise,
	            deferred,
	            i;

	        if (metaDataAPEX.Aggregation === false) {
	            promise = this.invokeRemoteCall(metaDataAPEX.Type, metaDataAPEX.Extension, metaDataAPEX.Managed, metaDataAPEX.Compressed, metaDataAPEX.Buffer, isManagedObject, boName, sfObjectName, isExternal);
	        } else {

	            if (!this._metaDataBuffer) {

	                deferred = when.defer();
	                this._metaDataBuffer = [];
	                this._metaDataPromise = deferred.promise;

	                setTimeout(function () {
	                    var list = _this._metaDataBuffer;
	                    delete _this._metaDataBuffer;
	                    delete _this._metaDataPromise;
	                    deferred.resolve(_this.getMetaDataList(list, isManagedObject));
	                }, 10);
	            }

	            i = this._metaDataBuffer.length;
	            this._metaDataBuffer.push(arguments);
	            promise = this._metaDataPromise.then(function (result) {
	                return {
	                    '__Model': result.__Model,
	                    '__Status': result.__Status,
	                    'data': result.data ? result.data[i].fields : null,
	                    'ExceptionType': result.ExceptionType,
	                    'ExceptionMessage': result.ExceptionMessage,
	                    'ExceptionWhere': result.ExceptionWhere
	                };
	            });
	        }

	        return promise.then(function (response) {
	            var hasPickLists = false;

	            var hasCheckoutFlagSet = (AppManager.getArtifact((AppManager.getArtifact(boName).Artifact || {}).DataSource).Artifact || {}).CheckLayout || false;

	            if (!response.data) {
	                response.data = { fields: [] };
	                return response;
	            }

	            var _iteratorNormalCompletion = true;
	            var _didIteratorError = false;
	            var _iteratorError = undefined;

	            try {
	                for (var _iterator = response.data.fields[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
	                    var field = _step.value;

	                    field.getPicklistValues = getPicklistValues;
	                    field.recordTypes = {};
	                    if (field.type == 'PICKLIST') hasPickLists = true;
	                }
	            } catch (err) {
	                _didIteratorError = true;
	                _iteratorError = err;
	            } finally {
	                try {
	                    if (!_iteratorNormalCompletion && _iterator.return) {
	                        _iterator.return();
	                    }
	                } finally {
	                    if (_didIteratorError) {
	                        throw _iteratorError;
	                    }
	                }
	            }

	            if (!hasCheckoutFlagSet) return response;
	            if (!sfObjectName) return response;

	            if (hasPickLists) {
	                (function () {

	                    var deferred = when.defer();

	                    if (isManagedObject) sfObjectName = AppManager.addACSFNamespace(sfObjectName);
	                    sforce.connection.describeLayout(sfObjectName, null, null, {
	                        onSuccess: function onSuccess(result) {
	                            return deferred.resolve(result);
	                        },
	                        onFailure: function onFailure(error) {
	                            return deferred.reject(error);
	                        }
	                    });

	                    deferred.promise.then(function (layout) {
	                        var recordTypes = {};

	                        if (isManagedObject) layout = AppManager.removeACSFNamespace(layout);
	                        _.extend(response, layout);

	                        var _iteratorNormalCompletion2 = true;
	                        var _didIteratorError2 = false;
	                        var _iteratorError2 = undefined;

	                        try {
	                            for (var _iterator2 = getArray(layout.recordTypeMappings)[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
	                                var mapping = _step2.value;
	                                var _iteratorNormalCompletion4 = true;
	                                var _didIteratorError4 = false;
	                                var _iteratorError4 = undefined;

	                                try {
	                                    for (var _iterator4 = getArray(mapping.picklistsForRecordType)[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
	                                        var picklist = _step4.value;


	                                        recordTypes[picklist.picklistName] = recordTypes[picklist.picklistName] || {};
	                                        recordTypes[picklist.picklistName][mapping.recordTypeId] = picklist;
	                                        var _iteratorNormalCompletion5 = true;
	                                        var _didIteratorError5 = false;
	                                        var _iteratorError5 = undefined;

	                                        try {
	                                            for (var _iterator5 = getArray(picklist.picklistValues)[Symbol.iterator](), _step5; !(_iteratorNormalCompletion5 = (_step5 = _iterator5.next()).done); _iteratorNormalCompletion5 = true) {
	                                                var value = _step5.value;

	                                                value.active = value.active == 'true';
	                                                value.defaultValue = value.defaultValue == 'true';
	                                            }
	                                        } catch (err) {
	                                            _didIteratorError5 = true;
	                                            _iteratorError5 = err;
	                                        } finally {
	                                            try {
	                                                if (!_iteratorNormalCompletion5 && _iterator5.return) {
	                                                    _iterator5.return();
	                                                }
	                                            } finally {
	                                                if (_didIteratorError5) {
	                                                    throw _iteratorError5;
	                                                }
	                                            }
	                                        }
	                                    }
	                                } catch (err) {
	                                    _didIteratorError4 = true;
	                                    _iteratorError4 = err;
	                                } finally {
	                                    try {
	                                        if (!_iteratorNormalCompletion4 && _iterator4.return) {
	                                            _iterator4.return();
	                                        }
	                                    } finally {
	                                        if (_didIteratorError4) {
	                                            throw _iteratorError4;
	                                        }
	                                    }
	                                }
	                            }
	                        } catch (err) {
	                            _didIteratorError2 = true;
	                            _iteratorError2 = err;
	                        } finally {
	                            try {
	                                if (!_iteratorNormalCompletion2 && _iterator2.return) {
	                                    _iterator2.return();
	                                }
	                            } finally {
	                                if (_didIteratorError2) {
	                                    throw _iteratorError2;
	                                }
	                            }
	                        }

	                        var _iteratorNormalCompletion3 = true;
	                        var _didIteratorError3 = false;
	                        var _iteratorError3 = undefined;

	                        try {
	                            for (var _iterator3 = response.data.fields[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
	                                var field = _step3.value;

	                                field.recordTypes = recordTypes[field.name] || {};
	                            }
	                        } catch (err) {
	                            _didIteratorError3 = true;
	                            _iteratorError3 = err;
	                        } finally {
	                            try {
	                                if (!_iteratorNormalCompletion3 && _iterator3.return) {
	                                    _iterator3.return();
	                                }
	                            } finally {
	                                if (_didIteratorError3) {
	                                    throw _iteratorError3;
	                                }
	                            }
	                        }
	                    });
	                })();
	            }

	            return response;
	        });
	    },

	    getMetaDataList: function getMetaDataList(list, isManagedObject) {
	        var metaDataAPEX = AppManager.getMetaDataListApex();
	        var query = [];
	        var args;

	        var _iteratorNormalCompletion6 = true;
	        var _didIteratorError6 = false;
	        var _iteratorError6 = undefined;

	        try {
	            for (var _iterator6 = list[Symbol.iterator](), _step6; !(_iteratorNormalCompletion6 = (_step6 = _iterator6.next()).done); _iteratorNormalCompletion6 = true) {
	                args = _step6.value;
	                query.push({
	                    businessObject: args[0],
	                    sfObject: args[1],
	                    isExternal: args[2]
	                });
	            }
	        } catch (err) {
	            _didIteratorError6 = true;
	            _iteratorError6 = err;
	        } finally {
	            try {
	                if (!_iteratorNormalCompletion6 && _iterator6.return) {
	                    _iterator6.return();
	                }
	            } finally {
	                if (_didIteratorError6) {
	                    throw _iteratorError6;
	                }
	            }
	        }

	        return this.invokeRemoteCall(metaDataAPEX.Type, metaDataAPEX.Extension, metaDataAPEX.Managed, metaDataAPEX.Compressed, metaDataAPEX.Buffer, isManagedObject, JSON.stringify(query));
	    },

	    getLoggingConfig: function getLoggingConfig() {
	        return this.invokeRemoteCall('getLogConfig', "LogRemoteActionExtension", true, false, true, true);
	    },

	    writeLogs: function writeLogs(logs) {
	        return this.invokeRemoteCall('writeLogs', "LogRemoteActionExtension", true, false, true, true, logs);
	    }
	};

	function getPicklistValues(recordTypeId) {
	    return (this.recordTypes[recordTypeId] || this).picklistValues || [];
	}

	function getArray(arr) {
	    if (arr instanceof Array) return arr;
	    return [arr];
	}

	var ExceptionHandler = {
	    treatJSError: function treatJSError(event) {
	        var msg = event.message || event + '';
	        UI_EVENT_BUS.put(EVENTS.UI_ERROR, { title: 'Service Error', message: msg, type: 'E' });
	    }
	};

		module.exports.ExceptionHandler = ExceptionHandler;

/***/ },

/***/ 200:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var apexAbstractionCoreClass = __webpack_require__(199);

	var apexAbstractionBL = new apexAbstractionCoreClass();

	//unilever workflow function
	apexAbstractionBL.invokeWF = function (objectId, wfState, jsonContent, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('invokeWf' + className, extension, managed, compressed, buffer, isManagedObject, objectId, wfState, jsonContent);
	};

	apexAbstractionBL.CreatePush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('CreatePush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};

	apexAbstractionBL.cleanUpPush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('cleanUpPush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};

	apexAbstractionBL.finalizePush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('finalizePush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};

	apexAbstractionBL.UpdateEnablePush = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('UpdateEnablePush' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};

	apexAbstractionBL.validate = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('validate' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};

	//PMA - START CODE - 2017-01-13 - Threshold button
	apexAbstractionBL.invokePromotionThresholdCheck = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('invokePromotionThresholdCheck' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};
	apexAbstractionBL.invokeAuditTrail = function (objectId, className, extension, managed, compressed, buffer, isManagedObject) {
	    return this.invokeRemoteCall('invokeAuditTrail' + className, extension, managed, compressed, buffer, isManagedObject, objectId);
	};
	//PMA - END CODE - 2017-01-13 - Threshold button

	module.exports = apexAbstractionBL;

/***/ },

/***/ 201:
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	/* globals CasException */

	if (true) {
	    var _ = __webpack_require__(202);
	    var bunyan = __webpack_require__(203);
	    var benchmark = __webpack_require__(267);
	    var metaParser = __webpack_require__(268);
	    var calcHelper = __webpack_require__(270);
	    var TreeBuilder = __webpack_require__(271);
	    var TreeNode = __webpack_require__(272);
	    var ManualChangesSerializer = __webpack_require__(273).ManualChangesSerializer;
	    var CalculationVariableParser = __webpack_require__(274).CalculationVariableParser;
	}

	var TOTAL_COLUMN_NAME = "Total";

	var logger = bunyan.createLogger({
	    name: "CasAnalytics",
	    streams: [{
	        level: 'info',
	        stream: new MyRawStream(),
	        type: 'raw'
	    }]
	});

	/**
	 *
	 * @constructor
	 */
	var Tree = function Tree() {
	    var log = logger.child({ widget_type: 'Tree' });

	    var dataMeta = {};
	    var rootNode = null;
	    var helper = null;
	    var variables = null;
	    var manualChangesSerializer = null;

	    var meta = {};
	    var nodeCounter = 0;

	    /**
	     * Gets an instance of the serializer for manual changes
	     * @return {ManualChangesSerializer}
	     */
	    this.getManualChangesSerializer = function () {
	        if (manualChangesSerializer === null) {
	            manualChangesSerializer = new ManualChangesSerializer(dataMeta, meta, logger, benchmark);
	        }

	        return manualChangesSerializer;
	    };

	    /**
	     * Gets the MetaInformation of this Tree
	     * @returns {*}
	     */
	    this.getMeta = function () {
	        return meta;
	    };

	    /**
	     * gets the DataMeta Information of this Tree
	     * @returns {{}}
	     */
	    this.getDataMeta = function () {
	        return dataMeta;
	    };

	    this.getVariables = function () {
	        return variables;
	    };

	    /**
	     * Gets all lookup values of the specified column
	     * @param {string} dimensionName
	     * @returns {string[]}
	     */
	    function getLookupValues(dimensionName) {
	        //FixMe: Will only work on dimensions!
	        var values = [];
	        var dimension = _.find(dataMeta.dimensions, ["name", dimensionName]);
	        if (dimension !== undefined) {
	            if (dimension.type === "time") {
	                values = dimension.details;
	            } else {
	                values = dimension.lookups;
	            }
	        } else {
	            log.warn("Missing dimension named: " + dimensionName + "!");
	        }

	        return values;
	    }

	    function processDimensionInformation() {
	        var measureDimension = _.find(dataMeta.dimensions, ["type", "measure"]);
	        if (measureDimension !== undefined) {
	            dataMeta.measureDimensionName = measureDimension.name;
	            dataMeta.isMeasureDimensionName = isMeasureDimensionName;
	        } else {
	            throw new CasException.CasException("The Data does not contain a dimension of type 'measure'.");
	        }

	        processTimeDimensionInformation();
	    }

	    function processTimeDimensionInformation() {
	        var timeDimension = _.find(dataMeta.dimensions, ["type", "time"]);

	        if (timeDimension !== undefined) {
	            dataMeta.today = new Date().setHours(0, 0, 0, 0);
	            dataMeta.timeDimensionName = timeDimension.name;
	            dataMeta.timeDetails = timeDimension.details;
	            dataMeta.noOfDataColumns = timeDimension.details.length + 1;

	            dataMeta.currentWeekIndex = -1;
	            for (var detailsIndex = 0; detailsIndex < timeDimension.details.length; detailsIndex++) {
	                var timeDetails = timeDimension.details[detailsIndex];
	                var dateFrom = new Date(timeDetails.datefrom);
	                var dateThru = new Date(timeDetails.datethru);

	                if (dateFrom <= dataMeta.today && dataMeta.today <= dateThru) {
	                    // correct week found (current week is today)
	                    dataMeta.currentWeekIndex = detailsIndex;
	                    break;
	                } else if (dateThru < dataMeta.today) {
	                    // current week lies in the past
	                    dataMeta.currentWeekIndex = detailsIndex + 1;
	                }
	            }
	        } else {
	            throw new CasException.CasException("The Data does not contain a dimension of type 'time'.");
	        }
	    }

	    /**
	     * Indicates if the given dimensionName is equal to the name of the measure dimension
	     * @param {string} dimensionName
	     * @return {boolean}
	     */
	    function isMeasureDimensionName(dimensionName) {
	        return dataMeta.measureDimensionName === dimensionName;
	    }

	    function computeAllLevels(yAxis, dimensionsInformation) {
	        dataMeta.allLevels = [];
	        dataMeta.levelNameDimensionIndexMapping = {};
	        dataMeta.levelNameDimensionNameMapping = {};
	        dataMeta.dimensionByName = {};

	        for (var dimensionIndex = 0; dimensionIndex < yAxis.length; dimensionIndex++) {
	            var hierarchicalMapping = [];

	            var dimensionName = yAxis[dimensionIndex];
	            if (dimensionName === "measures") {
	                dimensionName = dataMeta.measureDimensionName;
	            }

	            var dimensionInfo = _.find(dimensionsInformation, ["name", dimensionName]);
	            if (dimensionInfo !== undefined) {
	                dataMeta.dimensionByName[dimensionName] = dimensionInfo;

	                do {
	                    dataMeta.levelNameDimensionIndexMapping[dimensionInfo.name] = dimensionIndex;
	                    dataMeta.levelNameDimensionNameMapping[dimensionInfo.name] = dimensionName;

	                    hierarchicalMapping.unshift(dimensionInfo.name);
	                    dimensionInfo = dimensionInfo.hierarchy;
	                } while (dimensionInfo !== undefined);

	                dataMeta.allLevels = _.concat(dataMeta.allLevels, hierarchicalMapping);
	            } else {
	                throw new CasException.CasException("The dimension with the name " + dimensionName + " is not part of the data.");
	            }
	        }

	        dataMeta.getLevelIndex = getLevelIndex;
	        dataMeta.getDimensionIndex = getDimensionIndex;
	        dataMeta.getDimensionName = getDimensionName;
	        dataMeta.getDimensionByName = getDimensionByName;
	    }

	    function getDimensionByName(dimensionName) {
	        if (dataMeta.dimensionByName[dimensionName] !== undefined) {
	            return dataMeta.dimensionByName[dimensionName];
	        } else {
	            throw new CasException.CasException("Cannot find the dimension with the name " + dimensionName);
	        }
	    }

	    function getLevelIndex(levelName) {
	        var adjustedLevelName = levelName;
	        if (levelName === "measures") {
	            adjustedLevelName = dataMeta.measureDimensionName;
	        }
	        var levelIndex = _.indexOf(dataMeta.allLevels, adjustedLevelName);

	        if (levelIndex >= 0) {
	            return levelIndex;
	        } else {
	            throw new CasException.CasException("Cannot find the level with the name " + levelName);
	        }
	    }

	    function getDimensionIndex(levelName) {
	        if (levelName in dataMeta.levelNameDimensionIndexMapping) {
	            return dataMeta.levelNameDimensionIndexMapping[levelName];
	        } else {
	            throw new CasException.CasException("Cannot identify the dimension of the level with the name " + levelName);
	        }
	    }

	    function getDimensionName(levelName) {
	        if (levelName in dataMeta.levelNameDimensionNameMapping) {
	            return dataMeta.levelNameDimensionNameMapping[levelName];
	        } else {
	            throw new CasException.CasException("Cannot identify the dimension of the level with the name " + levelName);
	        }
	    }

	    /**
	     * Creates and stores allHeaders
	     * Includes the TotalColumn if necessary
	     * @param {string} xAxis
	     * @param {string[]} yAxis
	     */
	    function computeAllHeaders(xAxis, yAxis) {
	        var xAxisValues = getLookupValues(xAxis);

	        meta.allHeaders = _.concat(yAxis, TOTAL_COLUMN_NAME, xAxisValues);
	        meta.dataColumnHeaders = _.concat(TOTAL_COLUMN_NAME, xAxisValues);
	    }

	    /**
	     * Loads all Data, Meta and Variables into the Tree
	     * @param {Object} data The data itself and information about the structure of the Data
	     * @param {number[][]} data.data The Data itself and the MetaData about the given Data
	     * @param {*} data.relations The Data itself and the MetaData about the given Data
	     * @param {Object[]} data.dimensions Collection of all dimensions information of the tableData
	     * @param {String} data.dimensions[].name Name of the Column
	     * @param {String[]} data.dimensions[].lookups 0-Indexed lookUp-Values for the tableData
	     * @param {Object} metaInfo Information about the resulting structure (ColumnOrder, CalculationFormulas,...)
	     * @param {Object} metaInfo.axis Information about the axis of the grid
	     * @param {string} metaInfo.axis.x Reference to the dimensions in data.dimensions
	     * @param {string[]} metaInfo.axis.y Reference to the dimensions in data.dimensions. Must include "measures" as KeyWord
	     * @param {Object[]} metaInfo.measures Collection of all measures of the grid
	     * @param {string} metaInfo.measures[].name Name of the measures (for displaying and as reference to columns if provided in data.data)
	     * @param {boolean} metaInfo.measures[].display Indicates if the measure shall be displayed or is only necessary for calculation
	     * @param {boolean} metaInfo.measures[].editable Indicates if this measure can be edited
	     * @param {boolean} metaInfo.measures[].writeBack Indicates if the edited values of this measure shall be persisted (only in use with editable=true)
	     * @param {boolean} metaInfo.measures[].computed Indicates if this measure must be calculated
	     * @param {string} metaInfo.measures[].formula Formula used for the calculation of this measure (only in use with computed=true), must be a valid JS-Function. Can reference measures and VARS
	     * @param {string} metaInfo.measures[].aggregation Instruction how to aggregate this measure (null|sum|min|max...)
	     * @param {string} metaInfo.measures[].totalCalculation Instruction how to aggregate the TotalColumn (null|sum|min|max...) (see meta.total.display)
	     * @param {Object} metaInfo.total Information if the TotalColumn should be calculated/displayed
	     * @param {boolean} metaInfo.total.display Indicates if the TotalColumn shall be calculated and displayed (see data.dimensions[].totalCalculation)
	     * @param {string} metaInfo.total.label Label to be displayed/returned for the TotalColumn
	     * @param {Array} vars Additional Variables as Key-Value-Pairs (used for calculation)
	     * @param {Object} manualChanges
	     */
	    this.loadData = function (data, metaInfo, vars, manualChanges) {
	        benchmark.startMeasurement('loadData');
	        log.trace("loadData() - Start");

	        log.trace("Parsing Variables");
	        var startDate = Date.now();
	        var variableParser = new CalculationVariableParser();
	        variableParser.setBenchmark(benchmark);
	        variableParser.setLogger(log);

	        variableParser.parse(vars);
	        variables = vars;
	        log.trace("Parsing Variables done: " + (Date.now() - startDate));

	        log.trace("Parsing Meta:");
	        startDate = Date.now();
	        meta = metaParser.parseMeta(metaInfo);
	        log.trace("Parsing Meta done: " + (Date.now() - startDate));

	        dataMeta.dimensions = data.dimensions;
	        dataMeta.relations = data.relations;

	        log.trace("processDimensionInformation:");
	        startDate = Date.now();
	        processDimensionInformation();
	        log.trace("processDimensionInformation done: " + (Date.now() - startDate));

	        log.trace("computeAllLevels:");
	        startDate = Date.now();
	        computeAllLevels(meta.axis.y, data.dimensions);
	        log.trace("computeAllLevels done: " + (Date.now() - startDate));

	        log.trace("computeAllHeaders:");
	        startDate = Date.now();
	        computeAllHeaders(meta.axis.x, meta.axis.y);
	        log.trace("computeAllHeaders done: " + (Date.now() - startDate));

	        helper = new calcHelper.CalcHelper(meta, dataMeta, vars, log);

	        TreeNode.setCalcHelper(helper);
	        TreeNode.setLogger(log);
	        TreeNode.setDataMeta(dataMeta);
	        TreeNode.setMeta(meta);

	        log.trace("getTreeBuilder:");
	        startDate = Date.now();
	        var treeBuilder = this.getTreeBuilder(data);
	        log.trace("getTreeBuilder done: " + (Date.now() - startDate));

	        log.trace("buildTree:");
	        startDate = Date.now();
	        this.buildTree(treeBuilder);
	        log.trace("buildTree done: " + (Date.now() - startDate));

	        log.trace("fillTree:");
	        startDate = Date.now();
	        this.fillTree(data.data);
	        log.trace("fillTree done: " + (Date.now() - startDate));

	        log.trace("applyManualChanges:");
	        startDate = Date.now();
	        this.applyManualChanges(manualChanges);
	        log.trace("applyManualChanges done: " + (Date.now() - startDate));

	        log.trace("loadData() - End");
	        benchmark.endMeasurement('loadData');
	    };

	    /**
	     * @private
	     * @memberOf Tree
	     */
	    this.applyManualChanges = function applyManualChanges(manualChanges) {
	        log.debug("Applying manual changes");
	        benchmark.startMeasurement("applyManualChanges");
	        var deserializedChanges = {};

	        var serializer = this.getManualChangesSerializer();

	        if (serializer.isValid(manualChanges)) {
	            deserializedChanges = serializer.deserialize(manualChanges);
	        } else {
	            log.debug("No valid manual changes found");
	        }

	        if (deserializedChanges.length > 0) {
	            var rootNode = this.getRootNode();

	            for (var changeIndex = 0; changeIndex < deserializedChanges.length; changeIndex++) {
	                var change = deserializedChanges[changeIndex];
	                var currentNode = rootNode.getNode(change.path);

	                if (currentNode !== undefined) {
	                    currentNode.set(change.columnIndex, change.value);
	                } else {
	                    log.info("Could not apply a change. As the path could not be resolved");
	                }
	            }

	            log.debug("Applied " + deserializedChanges.length + " manual changes");
	        } else {
	            log.debug("No changes to be applied");
	        }

	        benchmark.endMeasurement("applyManualChanges");
	    };

	    /**
	     * @private
	     * @memberOf Tree
	     * @param {[][]}data
	     */
	    this.fillTree = function fillTree(data) {
	        log.debug("Filling the Tree");
	        benchmark.startMeasurement("fillTree");
	        this.fillTreeNode(this.getRootNode(), data, 0);
	        benchmark.endMeasurement("fillTree");
	    };

	    /**
	     *
	     * @private
	     * @memberOf Tree
	     * @param {TreeNode} parentNode
	     * @param {[][]} data
	     * @param {number} dimensionIndex
	     */
	    this.fillTreeNode = function fillTreeNode(parentNode, data, dimensionIndex) {
	        // getName of the dimension (Tactic/measures/Prd,...)
	        var dimensionName = meta.axis.y[dimensionIndex];
	        var correctedDimensionName = dimensionName;
	        if (dimensionName === "measures") {
	            correctedDimensionName = dataMeta.measureDimensionName;
	        }

	        // get Dimension via its name from dataMeta.dimensions.find(
	        var dataMetaDimensionIndex = _.findIndex(dataMeta.dimensions, { "name": correctedDimensionName });
	        var dataMetaDimension = dataMeta.dimensions[dataMetaDimensionIndex];

	        for (var nodeId = -1; nodeId < dataMetaDimension.lookups.length; nodeId++) {
	            var correctedNodeId = nodeId;
	            if (dimensionName === "measures") {
	                correctedNodeId = _.findIndex(meta.measures, ["name", dataMetaDimension.lookups[nodeId]]);
	            }

	            // get only this part of the data where the value {nodeId} on the index {dataMetaDimensionIndex} matches
	            var partitionedData = _.partition(data, [dataMetaDimensionIndex, nodeId]);
	            var dimensionData = partitionedData[0];
	            data = partitionedData[1];

	            if (dimensionData.length > 0) {

	                var node = this.getDimensionNode(parentNode, correctedNodeId, dataMetaDimension.hierarchy);

	                if (node.isLeaf()) {
	                    var dataIndex = _.findIndex(dataMeta.dimensions, ["name", meta.axis.x]);
	                    var rawData = dimensionData[0][dataIndex]; // check if here a check is necessary due to missing data

	                    node.setRawData(rawData);
	                } else {
	                    this.fillTreeNode(node, dimensionData, dimensionIndex + 1);
	                }
	            }
	        }

	        if (data.length > 0) {
	            log.warn("fillTreeNode: Could not set all data. Remaining data: " + JSON.stringify(data));
	        }
	    };

	    /**
	     *
	     * @param {Object} hierarchy
	     * @param {string} hierarchy.name
	     * @param {Object|undefined} hierarchy.hierarchy
	     * @param {string[]} hierarchy.lookups
	     * @param {string} oldLevel
	     * @param {SimpleTree} filters
	     * @param {Object[]} allLevels
	     * @param {number} dimensionIndex
	     * @param {number} hierarchyIndex
	     * @return {string}
	     */
	    this.getLevelsForTreeBuilder = function (hierarchy, oldLevel, filters, allLevels, dimensionIndex, hierarchyIndex) {
	        var newLevel = hierarchy.name;
	        if (hierarchy.hierarchy !== undefined && hierarchy.hierarchy.lookups !== undefined) {
	            oldLevel = this.getLevelsForTreeBuilder(hierarchy.hierarchy, oldLevel, filters, allLevels, dimensionIndex, hierarchyIndex + 1);
	            var levels = [oldLevel, newLevel];
	            var mapping = [1, 0];
	            var filter = TreeBuilder.addIndex(hierarchy.hierarchy.mapping);
	            filters.push(TreeBuilder.createFilterTree(filter, mapping, levels));
	        }
	        var lookups = hierarchy.lookups;
	        var level = {};
	        level.startIndex = newLevel === dataMeta.measureDimensionName || hierarchyIndex > 0 ? 0 : -1;
	        level.endIndex = lookups.length - 1;
	        level.dimensionIndex = dimensionIndex;
	        level.hierarchyIndex = hierarchyIndex;
	        level.name = newLevel;
	        allLevels.push(level);
	        return newLevel;
	    };

	    /**
	     * gets all filters to build up the tree
	     * @param data response from the web service with the data
	     */
	    this.getTreeBuilder = function (data) {
	        // dimension info
	        var measureDimensionName = dataMeta.measureDimensionName;
	        var filters = [];
	        var allLevels = [];
	        var oldLevel = "ROOT";
	        //for (var dimIndex in dimensions) {
	        for (var i = 0; i < meta.axis.y.length; i++) {
	            var dimName = meta.axis.y[i];
	            if (dimName === "measures") {
	                dimName = measureDimensionName;
	            }
	            var dimension = dataMeta.getDimensionByName(dimName);
	            oldLevel = this.getLevelsForTreeBuilder(dimension, oldLevel, filters, allLevels, i, 0);
	        }

	        // relations:
	        var relations = data.relations;
	        for (var relIndex = 0; relIndex < relations.length; relIndex++) {
	            var relation = relations[relIndex];
	            if (relation === undefined) {
	                continue;
	            } else {
	                var levels = relation.dimensions;
	                var filter = relation.mapping;
	                var mapping = levels.map(function (name, index) {
	                    return index;
	                });
	                filters.push(TreeBuilder.createFilterTree(filter, mapping, levels));
	            }
	        }

	        // fix number of measures
	        // Do not delete. Still in use: Needs to be optimized!
	        var measures = meta.measures;
	        var measureLevel = _.find(allLevels, { "name": measureDimensionName });
	        measureLevel.endIndex = measures.length - 1;

	        // implicite relations
	        for (var i = 0; i < meta.axis.y.length; i++) {
	            var dimName = meta.axis.y[i];
	            if (dimName === "measures") {
	                continue;
	            } else {
	                var dimension = dataMeta.getDimensionByName(dimName);
	                var levels = [measureDimensionName, dimension.name];
	                var mapping = [0, 1];
	                var filter = [];
	                for (var measureIndex = 0; measureIndex < measures.length; measureIndex++) {
	                    var measure = measures[measureIndex];
	                    if (measure.isDimensionSkipped(i)) {
	                        filter.push([measureIndex, -1]); // only the imaginary item
	                    } else {
	                        for (var itemIndex = 0; itemIndex < dimension.lookups.length; itemIndex++) {
	                            // all real items
	                            filter.push([measureIndex, itemIndex]);
	                        }
	                    }
	                }
	                filters.push(TreeBuilder.createFilterTree(filter, mapping, levels));
	            }
	        }
	        return new TreeBuilder.TreeBuilder(0, allLevels, filters);
	    };

	    /**
	     * Builds up the entire tree
	     * @private
	     * @memberOf Tree
	     */
	    this.buildTree = function buildTree(treeBuilder) {
	        log.debug("Building the tree");
	        benchmark.startMeasurement("buildTree");

	        var globalId = nodeCounter++;
	        rootNode = new TreeNode.TreeNode(globalId, 0, -1, 0, -1, TreeNode._NodeTypes.ROOT, null, null, null);

	        this.createTreeNode(rootNode, 0, -1, null, treeBuilder);
	        benchmark.endMeasurement("buildTree");
	        log.debug("Total number of Nodes: " + nodeCounter);
	    };

	    var getHierarchyHeight = function getHierarchyHeight(hierarchyInformation) {
	        if (hierarchyInformation === undefined) {
	            return -1;
	        } else {
	            var parent = hierarchyInformation.hierarchy;
	            return getHierarchyHeight(parent) + 1;
	        }
	    };

	    /**
	     * Creates new TreeNodes recursively below the given parent including the hierarchy of the dimensions
	     * @private
	     * @memberOf Tree
	     * @param {TreeNode} parentNode
	     * @param {number} dimensionIndex
	     * @param {Object} hierarchyHeight
	     * @param {Object} measureDefinition
	     * @param {Object} treeBuilder
	     */
	    this.createTreeNode = function createTreeNode(parentNode, dimensionIndex, hierarchyHeight, measureDefinition, treeBuilder) {
	        var maxDimensionIndex = meta.axis.y.length - 1;
	        if (dimensionIndex > maxDimensionIndex) {
	            return;
	        }

	        // getName of the dimension (Tactic/measures/Prd,...)
	        var measureDimensionName = dataMeta.measureDimensionName;
	        var dimensionName = meta.axis.y[dimensionIndex];
	        if (dimensionName === "measures") {
	            dimensionName = measureDimensionName;
	        }
	        if (hierarchyHeight === -1) {
	            var dataMetaDimension = dataMeta.getDimensionByName(dimensionName);
	            hierarchyHeight = getHierarchyHeight(dataMetaDimension);
	        }
	        var isLeafLevel = dimensionIndex === maxDimensionIndex && hierarchyHeight === 0;
	        var nodeType = isLeafLevel ? TreeNode._NodeTypes.LEAF : TreeNode._NodeTypes.GROUPING;

	        var measures;
	        if (dimensionName === measureDimensionName) {
	            measures = meta.measures;
	        }
	        var children = treeBuilder.getChildren();
	        var startIndex = hierarchyHeight > 0 ? 0 : -1;
	        for (var childId = startIndex; childId < children.length; childId++) {
	            var childTreeBuilder = children[childId];
	            if (childTreeBuilder) {
	                if (dimensionName === measureDimensionName) {
	                    measureDefinition = measures[childId];
	                }
	                var root = this.getRootNode();
	                var node = new TreeNode.TreeNode(nodeCounter++, childId, dimensionIndex, hierarchyHeight, parentNode.getLevel() + 1, nodeType, parentNode, root, measureDefinition);
	                node._data = new Array(dataMeta.noOfDataColumns);
	                _.fill(node._data, null);
	                if (nodeType === TreeNode._NodeTypes.LEAF) {
	                    parentNode.childAreLeafs = true;
	                }
	                if (isLeafLevel) {
	                    parentNode.addChild(node);
	                } else {
	                    if (hierarchyHeight === 0) {
	                        this.createTreeNode(node, dimensionIndex + 1, -1, measureDefinition, childTreeBuilder);
	                    } else {
	                        this.createTreeNode(node, dimensionIndex, hierarchyHeight - 1, measureDefinition, childTreeBuilder);
	                    }

	                    if (node._children[-1] || node._children.length > 0) {
	                        parentNode.addChild(node);
	                    }
	                }
	            }
	        }
	    };

	    /**
	     * Gets a specific dimensionNode (steps through the hierarchy if necessary)
	     * @private
	     * @memberOf Tree
	     * @param {TreeNode} parentDimensionNode
	     * @param {number} childId
	     * @param {Object} hierarchyInformation
	     * @return {TreeNode|undefined}
	     */
	    this.getDimensionNode = function getDimensionNode(parentDimensionNode, childId, hierarchyInformation) {
	        var parentNode;

	        if (hierarchyInformation === undefined) {
	            parentNode = parentDimensionNode;
	        } else {
	            var hierarchyParentId = hierarchyInformation.mapping[childId];
	            parentNode = this.getDimensionNode(parentDimensionNode, hierarchyParentId, hierarchyInformation.hierarchy);
	        }

	        return parentNode.getChildNode(childId);
	    };

	    /**
	     * Gets the RootNode
	     * @public
	     * @returns {TreeNode}
	     */
	    this.getRootNode = function () {
	        return rootNode;
	    };

	    /**
	     * Gets a ChildNode via its global unique Id
	     * @param {number} globalId Id of the node to be searched
	     * @returns {TreeNode|null}
	     */
	    this.getChild = function (globalId) {
	        log.trace("getChild() - Start");

	        var childNode = null;

	        if (globalId === 0) {
	            childNode = rootNode;
	        } else {
	            childNode = getChildRecursive(rootNode, globalId);
	        }

	        log.trace("getChild() - End");
	        return childNode;
	    };

	    /**
	     * Gets a ChildNode below its parentNode via its global unique Id
	     * @param {TreeNode} parentNode Starting Node
	     * @param {number} globalId Global unique Id of the node to be searched
	     * @returns {TreeNode|null} Node to be found or undefined
	     */
	    function getChildRecursive(parentNode, globalId) {
	        var childNode = null;
	        parentNode._children.forEach(function (child) {
	            if (child.id === globalId) {
	                childNode = child;
	            } else if (!childNode) {
	                childNode = getChildRecursive(child, globalId);
	            }
	        });

	        return childNode;
	    };

	    /**
	     * Collection all WriteBack relevant rows and wor-Identifier
	     * @param {[]} result Collection of rows which shall be written back to the DB
	     * @param {Object} identifiers
	     * @param {TreeNode[]} nodes Collection of nodes which must be check if they are relevant for the writeBack
	     */
	    this.getWriteBackDataRecursive = function (result, identifiers, nodes) {
	        benchmark.startMeasurement('getWriteBackDataRecursive');

	        for (var i = -1; i < nodes.length; i++) {
	            var currentNode = nodes[i];

	            if (currentNode !== undefined) {
	                var measureDefinition = currentNode.getMeasureDefinition();
	                var dimensionId = currentNode.getDimensionId();
	                var dimensionName = meta.axis.y[dimensionId];
	                var currentIdentifiers = _.clone(identifiers);
	                if (dimensionName === "measures") {
	                    currentIdentifiers[dataMeta.measureDimensionName] = measureDefinition.storageOptions.code;
	                } else {
	                    currentIdentifiers[dimensionName] = currentNode.getLabel();
	                }

	                if (measureDefinition !== null) {
	                    if (measureDefinition.storageOptions.writeBack === true) {
	                        if (_.find(measureDefinition.storageOptions.levels, ["levelIndex", currentNode.getLevel()])) {
	                            var resultRow = _.clone(currentIdentifiers);
	                            resultRow.data = currentNode.getData();

	                            result.push(resultRow);
	                        }
	                    } else {
	                        // nothing to write back => continue!
	                        continue;
	                    }
	                }

	                this.getWriteBackDataRecursive(result, currentIdentifiers, currentNode.getChildren());
	            }
	        }

	        benchmark.endMeasurement('getWriteBackDataRecursive');
	    };

	    /**
	     * Corrects and enhances the writeBack-Information of all relevant KPIs
	     * @param {Object} meta
	     * @param {Object} dataMeta
	     */
	    this.updateWriteBackLevelInformation = function (meta, dataMeta) {
	        benchmark.startMeasurement('updateWriteBackLevelInformation');
	        var writeBackMeasures = meta.getWriteBackKPIs();

	        for (var measureIndex = 0; measureIndex < writeBackMeasures.length; measureIndex++) {
	            var measure = writeBackMeasures[measureIndex];

	            if (measure !== undefined) {
	                var levelsInformation = [];
	                for (var levelIndex = 0; levelIndex < measure.storageOptions.levels.length; levelIndex++) {
	                    var levelName = measure.storageOptions.levels[levelIndex];

	                    if (levelName === "measures") {
	                        levelName = dataMeta.measureDimensionName;
	                    }

	                    if (levelName in dataMeta.levelNameDimensionIndexMapping) {
	                        var levelInfo = {
	                            levelName: levelName,
	                            levelIndex: dataMeta.getLevelIndex(levelName),
	                            dimensionName: dataMeta.getDimensionName(levelName),
	                            dimensionIndex: dataMeta.getDimensionIndex(levelName)
	                        };

	                        levelsInformation.push(levelInfo);
	                    } else {
	                        log.error("The level with the name '" + levelName + "' cannot be found and will be ignored for the writeback!");
	                    }
	                }

	                measure.storageOptions.levels = levelsInformation;
	            }
	        }

	        benchmark.endMeasurement('updateWriteBackLevelInformation');
	    };
	};

	/**
	 *
	 * @return {Object[]}
	 */
	Tree.prototype.getTimeDetails = function () {
	    return this.getDataMeta().timeDetails;
	};

	/**
	 * Gets the number of all data columns (including the total column)
	 * @return {number}
	 */
	Tree.prototype.getNumberOfDataColumns = function () {
	    return this.getDataMeta().noOfDataColumns;
	};

	/**
	 * Collects all writeBackData of the tree via the measureDefinition of the KPIs
	 * @memberOf Tree
	 * @return {Object} Collection of all writeBack-Information
	 */
	Tree.prototype.getWriteBackData = function () {
	    benchmark.startMeasurement('getWriteBackData');
	    var meta = this.getMeta();
	    var dataMeta = this.getDataMeta();
	    var variables = this.getVariables();

	    for (var promotionId in variables.promotions) {
	        break;
	    }

	    this.updateWriteBackLevelInformation(meta, dataMeta);

	    var timeDimension = _.find(dataMeta.dimensions, { "type": "time" });
	    var startRecord = timeDimension.details[0];
	    var endRecord = timeDimension.details[timeDimension.details.length - 1];

	    // prepare the Result
	    var writeBackResult = {
	        id: promotionId,
	        startweek: startRecord.week,
	        endweek: endRecord.week,
	        startyear: startRecord.calendaryear,
	        endyear: endRecord.calendaryear,
	        firstdayofweek: timeDimension.firstdayofweek,
	        firstweekofyear: timeDimension.firstweekofyear,
	        data: []
	    };

	    // get all writeBack-Rows
	    var writeBackRows = [];
	    var currentRowIdentifiers = {};
	    var startNode = this.getRootNode();

	    this.getWriteBackDataRecursive(writeBackRows, currentRowIdentifiers, startNode.getChildren());
	    writeBackResult.data = writeBackRows;

	    benchmark.endMeasurement('getWriteBackData');
	    return writeBackResult;
	};

	/**
	 * Gets all manual changes
	 * returns {Object}
	 */
	Tree.prototype.getManualChanges = function () {
	    benchmark.startMeasurement("getManualChanges");

	    var rootNode = this.getRootNode();
	    var meta = this.getMeta();
	    var initialIdentifiers = {};
	    initialIdentifiers[meta.axis.x] = undefined;
	    var internalChanges = rootNode.getManualChanges(initialIdentifiers);
	    var serializer = this.getManualChangesSerializer();

	    var manualChanges = serializer.serialize(internalChanges);

	    benchmark.endMeasurement("getManualChanges");
	    return manualChanges;
	};

	/**
	 * Creates a new instance of the Tree
	 * @param data Data of the Tree
	 * @param meta MetaData of the Tree
	 * @param variables Additional Variables
	 * @param {Object} manualChanges
	 * @returns {Tree}
	 */
	var instantiate = function instantiate(data, meta, variables, manualChanges) {
	    var tree = new Tree();
	    tree.loadData(data, meta, variables, manualChanges);

	    return tree;
	};

	if (true) {
	    module.exports.instantiate = instantiate;
	    module.exports.Tree = Tree;
	}

	function MyRawStream() {}

	MyRawStream.prototype.write = function (rec) {
	    console.log('[%s] %s: %s', rec.time.toISOString(), bunyan.nameFromLevel[rec.level], rec.msg);
		};

/***/ },

/***/ 267:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	if (true) {
	    var _ = __webpack_require__(202);
	}

	var measurements = [];
	var enabled = false;
	var lastParent = null;

	// Globals for output of measurements
	var logDuration = 0.003;
	var defaultDigits = 4;

	var enable = function enable(state) {
	    enabled = state;
	};

	var clearMeasurements = function clearMeasurements() {
	    measurements = [];
	};

	var startMeasurement = function startMeasurement(name) {
	    if (!enabled) {
	        return;
	    }

	    var existingMeasure = _.findIndex(measurements, function (measure) {
	        return measure.name === name;
	    });

	    if (existingMeasure < 0) {
	        var newMeasure = {
	            state: 0,
	            startTime: Date.now(),
	            firstStartTime: Date.now(),
	            overallDuration: -1,
	            occurrences: 0,
	            lastRecursionOccurrences: 0,
	            lowerLevelOccurrences: 0,
	            name: name,
	            recursionLevel: 1,
	            maxRecursion: 1,
	            parent: lastParent,
	            childOccurrences: 0,
	            minDuration: 9999999999,
	            maxDuration: 0
	        };

	        lastParent = newMeasure;

	        measurements.push(newMeasure);
	    } else {
	        if (measurements[existingMeasure].recursionLevel > 0) {
	            measurements[existingMeasure].recursionLevel++;
	            measurements[existingMeasure].occurrences++;
	            measurements[existingMeasure].lastRecursionOccurrences++;
	            if (measurements[existingMeasure].recursionLevel > measurements[existingMeasure].maxRecursion) {
	                measurements[existingMeasure].maxRecursion = measurements[existingMeasure].recursionLevel;
	            }
	            if (measurements[existingMeasure].recursionLevel > 1) {
	                measurements[existingMeasure].lowerLevelOccurrences++;
	            }
	        } else {
	            measurements[existingMeasure].startTime = Date.now();
	            measurements[existingMeasure].state = 0;
	            measurements[existingMeasure].recursionLevel = 1;
	            measurements[existingMeasure].parent = lastParent;
	            measurements[existingMeasure].lastRecursionOccurrences = 0;
	            lastParent = measurements[existingMeasure];
	        }
	    }
	};

	var endMeasurement = function endMeasurement(name) {
	    if (!enabled) {
	        return;
	    }

	    var measureIdx = _.findIndex(measurements, function (measure) {
	        return measure.name === name;
	    });

	    if (measureIdx < 0) {
	        throw new Error('ERROR: Tried to stop a benchmark which does not exists: ' + name);
	    }

	    var measure = measurements[measureIdx];

	    measure.recursionLevel--;

	    if (measure.recursionLevel < 0) {
	        throw new Error('ERROR: Tried to close measurement with negative recursion level: ' + name);
	    } else if (measure.recursionLevel === 0) {
	        var duration = Date.now() - measure.startTime;
	        measure.occurrences++;
	        measure.lastRecursionOccurrences++;
	        measure.overallDuration += duration;
	        measure.lastStopTime = Date.now();
	        measure.state = 1;
	        if (measure.parent) {
	            measure.parent.childOccurrences += measure.lastRecursionOccurrences;
	        }
	        lastParent = measure.parent;
	        measure.minDuration = _.min([measure.minDuration, duration]);
	        measure.maxDuration = _.max([measure.maxDuration, duration]);
	    }
	};

	var printMeasurements = function printMeasurements(digits, all) {
	    if (!digits) {
	        digits = defaultDigits;
	    }

	    var printJSONArray = [];

	    measurements.forEach(function (element) {
	        var clearedDuration = round(element.overallDuration - (element.childOccurrences + element.lowerLevelOccurrences) * logDuration, digits);

	        if (all) {
	            printJSONArray.push({
	                name: element.name,
	                overallDuration: round(element.overallDuration, digits),
	                minDuration: element.minDuration,
	                maxDuration: element.maxDuration,
	                clearedDuration: clearedDuration,
	                averageDuration: round(element.overallDuration / element.occurrences, digits),
	                averageClearedDuration: round(clearedDuration / element.occurrences, digits),
	                measureLifeTime: element.lastStopTime - element.firstStartTime,
	                occurrences: element.occurrences,
	                maxRecursion: element.maxRecursion,
	                childOccurrences: element.childOccurrences
	            });
	        } else {
	            printJSONArray.push({
	                name: element.name,
	                clearedDuration: clearedDuration,
	                averageClearedDuration: round(clearedDuration / element.occurrences, digits),
	                measureLifeTime: element.lastStopTime - element.firstStartTime,
	                occurrences: element.occurrences,
	                maxRecursion: element.maxRecursion
	            });
	        }
	    });

	    return JSON.stringify(printJSONArray);
	};

	function round(value, digits) {
	    return Math.round(value * Math.pow(10, digits)) / Math.pow(10, digits);
	}

	if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {
	    module.exports.enable = enable;
	    module.exports.startMeasurement = startMeasurement;
	    module.exports.endMeasurement = endMeasurement;
	    module.exports.printMeasurements = printMeasurements;
	    module.exports.clearMeasurements = clearMeasurements;
	} else {
	    window.enable = enable;
	    window.startMeasurement = startMeasurement;
	    window.endMeasurement = endMeasurement;
	    window.printMeasurements = printMeasurements;
	    window.clearMeasurements = clearMeasurements;
	}

/***/ },

/***/ 268:
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	/* globals CasException */

	if (true) {
	    var _ = __webpack_require__(202);
	    var bunyan = __webpack_require__(203);
	    var benchmark = __webpack_require__(267);
	    var reducers = __webpack_require__(269).ArrayReducer;
	}

	var logger = bunyan.createLogger({
	    name: "CasAnalytics",
	    streams: [{
	        level: 'info',
	        stream: new MyRawStream(),
	        type: 'raw'
	    }]
	});

	// CONSTANTS
	var KEYWORD_AGGREGATION = "aggregation";
	var KEYWORD_AGGREGATION_RULE = "rule";
	var KEYWORD_AGGREGATION_SKIPPED_DIMENSIONS = "skippeddimensions";
	var KEYWORD_AXIS = "axis";
	var KEYWORD_DATASOURCE = "datasource";
	var KEYWORD_DATASOURCE_TABLENAME = "tablename";
	var KEYWORD_DATASOURCE_MEASURECODE = "measurecode";
	var KEYWORD_DATASOURCE_WEEKOFFSET = "weekoffset";
	var KEYWORD_DISPLAY = "display";
	var KEYWORD_EDITABLE = "editable";
	var KEYWORD_EDITABLE_CODE = "code";
	var KEYWORD_EDITABLE_DISTRIBUTION = "distribution";
	var KEYWORD_EDITABLE_ENABLEPASTWEEKS = "enablepastweeks";
	var KEYWORD_EDITABLE_EDITMODE = "editmode";
	var KEYWORD_FORMULA = "formula";
	var KEYWORD_TYPE = "type";
	var KEYWORD_TYPE_EDITABLE = "editable";
	var KEYWORD_TYPE_CALCULATED = "calculated";
	var KEYWORD_TYPE_READ = "read";
	var KEYWORD_MEASURES = "measures";
	var KEYWORD_NAME = "name";
	var KEYWORD_STORAGEOPTIONS = "storageoptions";
	var KEYWORD_STORAGEOPTIONS_CODE = "code";
	var KEYWORD_STORAGEOPTIONS_STORAGELEVELS = "storagelevels";
	var KEYWORD_STORAGEOPTIONS_WRITEBACK = "writeback";
	var KEYWORD_TOTAL = "total";
	var KEYWORD_TOTALCALCULATION = "totalcalculation";
	var KEYWORD_TOTALCALCULATION_RULE = "rule";

	/**
	 *
	 * @typedef {Object} MeasureDefinitionCollection
	 * @property {MeasureDefinition[]} measures
	 * @property {Object} axis
	 * @property {Object.<string, number|undefined>} measureIndexMapping
	 * @property {Object.<string, number>} editableCodeIndexMapping
	 * @property {Object.<string, number>} dimensionIndexMapping
	 * @property {Object.<string, number>} levelIndexMapping
	 * @property {number} _levelOfMeasures
	 */

	/**
	 * @typedef {{}} MeasureDefinition
	 * @property {number} id
	 * @property {string} name
	 */

	/**
	 *
	 * @type {MeasureDefinitionCollection}
	 */
	var meta = {};

	var log = logger.child({ widget_type: 'MetaParser' });

	var parseMeta = function parseMeta(metaInformation) {

	    if (typeof metaInformation === "string") {
	        throw new CasException.CasException("Could not parse the KPI-Definitions. Use a JSON-Validator and correct all errors before retrying.");
	    }

	    if (KEYWORD_AXIS in metaInformation) {
	        meta.axis = metaInformation[KEYWORD_AXIS];
	        computeDimensionIndexMapping(metaInformation[KEYWORD_AXIS].y);
	        computeLevelIndexMapping(metaInformation[KEYWORD_AXIS].y);
	    } else {
	        throw new CasException.CasException("Axis are missing");
	    }

	    if (KEYWORD_MEASURES in metaInformation) {
	        computeMeasureDefinitions(metaInformation[KEYWORD_MEASURES]);
	    } else {
	        throw new CasException.CasException("Measures are missing!");
	    }

	    addMetaFunctions();

	    return meta;
	};

	var addMetaFunctions = function addMetaFunctions() {
	    meta.getLevelOfMeasures = getLevelOfMeasures;
	    meta.getMeasureIndex = getMeasureIndex;
	    meta.getLevelIndex = getLevelIndex;
	    meta.getDimensionIndex = getDimensionIndex;
	    meta.getDataSourceBasedKPIs = getDataSourceBasedKPIs;
	    meta.getWriteBackKPIs = getWriteBackKPIs;
	};

	/**
	 * Gets the information which grouping level the "measures"-level is
	 * @function
	 * @returns {number}
	 */
	var getLevelOfMeasures = function getLevelOfMeasures() {
	    return meta._levelOfMeasures;
	};

	function parseSkippedDimensions(measureDefinition, aggregationInformation) {

	    measureDefinition.hasSkippedDimensions = false;
	    measureDefinition.skippedDimensions = [];
	    measureDefinition.isDimensionSkipped = function (dimensionId) {
	        return measureDefinition.skippedDimensions[dimensionId] !== undefined;
	    };

	    if (KEYWORD_AGGREGATION_SKIPPED_DIMENSIONS in aggregationInformation) {
	        var skippedDimensions = aggregationInformation[KEYWORD_AGGREGATION_SKIPPED_DIMENSIONS];

	        // Validate the Dimensions (Throws an error if a Dimension is not specified)
	        for (var i = 0; i < skippedDimensions.length; i++) {
	            var skippedDimensionName = skippedDimensions[i];
	            measureDefinition.skippedDimensions[getDimensionIndex(skippedDimensionName)] = true;

	            measureDefinition.hasSkippedDimensions = true;
	        }
	    } else {
	        log.debug("No skipped Dimensions specified");
	    }
	}

	/**
	 * Parses all KPI-Type related information of the measure
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {string} measure.type
	 * @param {string} measure.formula
	 * @param {Object} measure.datasource
	 * @param {Object} measure.editable
	 */
	function parseKPITypeInstruction(measureDefinition, measure) {

	    measureDefinition.computed = false;
	    measureDefinition.isDataSourceBased = false;
	    measureDefinition.isEditable = false;

	    if (KEYWORD_TYPE in measure) {
	        var KPIType = measure[KEYWORD_TYPE];

	        switch (KPIType) {
	            case KEYWORD_TYPE_CALCULATED:
	                parseKpiAsFormula(measureDefinition, measure);
	                break;
	            case KEYWORD_TYPE_READ:
	                parseKpiAsDataSource(measureDefinition, measure);
	                break;
	            case KEYWORD_TYPE_EDITABLE:
	                parseKpiAsEditable(measureDefinition, measure);
	                break;
	            default:
	                log.warn("Unknown KPITYPE. Implementation incomplete");
	                throw new CasException.CasException("Error while parsing the KPI '" + measureDefinition.name + "'. Unknown KpiType '" + KPIType + "'");
	        }
	    } else {
	        throw new CasException.CasException("Error while parsing the KPI '" + measureDefinition.name + "'. " + KEYWORD_TYPE + " not specified");
	    }
	}

	/**
	 * Parses a KPI as a TableBased KPI (Baseline, Shipment,...)
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {Object} measure.datasource
	 * @param {string} measure.datasource.tablename
	 * @param {string} measure.datasource.measurecode
	 * @param {number} measure.datasource.weekoffset
	 * @throws {CasException}
	 */
	function parseKpiAsDataSource(measureDefinition, measure) {
	    measureDefinition.isDataSourceBased = true;
	    measureDefinition.dataSource = {
	        tableName: "",
	        measureCode: "",
	        weekOffset: 0
	    };

	    if (KEYWORD_DATASOURCE in measure) {
	        var dataSource = measure[KEYWORD_DATASOURCE];

	        if (KEYWORD_DATASOURCE_TABLENAME in dataSource) {
	            measureDefinition.dataSource.tableName = dataSource[KEYWORD_DATASOURCE_TABLENAME];
	        } else {
	            log.error("The TableName for the KPI " + measureDefinition.name + " is missing!");
	        }

	        if (KEYWORD_DATASOURCE_MEASURECODE in dataSource) {
	            measureDefinition.dataSource.measureCode = dataSource[KEYWORD_DATASOURCE_MEASURECODE];
	        } else {
	            log.error("The MeasureCode for the KPI " + measureDefinition.name + " is missing!");
	        }

	        if (KEYWORD_DATASOURCE_WEEKOFFSET in dataSource) {
	            measureDefinition.dataSource.weekOffset = dataSource[KEYWORD_DATASOURCE_WEEKOFFSET];
	        } else {
	            log.warn("The WeekOffset for the KPI " + measureDefinition.name + " is missing!");
	        }
	    } else {
	        throw new CasException.CasException("The Data-Source-Information for the KPI " + measureDefinition.name + " is missing!");
	    }
	}

	/**
	 * Parses a KPI as a formula based one
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {string} measure.formula
	 */
	function parseKpiAsFormula(measureDefinition, measure) {
	    measureDefinition.computed = true;

	    if (!(KEYWORD_FORMULA in measure)) {
	        log.error(measureDefinition.name + ": Specified a computed measure but no formula! Using fallback (null-Value).");
	        measure.formula = "() => null";
	    }

	    try {
	        var formula = parseFormula(measure[KEYWORD_FORMULA]);
	        measureDefinition.func = formula.func;
	        measureDefinition.args = formula.args;
	    } catch (e) {
	        throw new CasException.CasException("Error while parsing the formula for KPI: '" + measureDefinition.name + "'.", e);
	    }
	}

	/**
	 * Parses the information of editable KPIs
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {Object} measure.editable
	 * @param {string} measure.editable.distribution
	 */
	function parseKpiAsEditable(measureDefinition, measure) {
	    measureDefinition.isEditable = true;
	    measureDefinition.distributionInformation = {
	        code: "",
	        enablePastWeeks: false,
	        measureName: "",
	        measureIndex: -1,
	        mode: "week"
	    };

	    if (KEYWORD_EDITABLE in measure) {
	        var editableInformation = measure[KEYWORD_EDITABLE];

	        if (KEYWORD_EDITABLE_CODE in editableInformation) {
	            var editCode = editableInformation[KEYWORD_EDITABLE_CODE];

	            measureDefinition.distributionInformation.code = editCode;
	            meta.editableCodeIndexMapping[editCode] = measureDefinition.id;
	        } else {
	            throw new CasException.CasException("The measure on index " + measureDefinition.id + " with the name " + measureDefinition.name + " is defined as editable but has no code assigned!");
	        }

	        if (KEYWORD_EDITABLE_EDITMODE in editableInformation) {
	            var mode = editableInformation[KEYWORD_EDITABLE_EDITMODE];
	            if (mode === "total") {
	                measureDefinition.distributionInformation.mode = "total";
	            } else if (mode === "week") {
	                measureDefinition.distributionInformation.mode = "week";
	            } else {
	                measureDefinition.distributionInformation.mode = "week";
	                log.warn("The measure on index " + measureDefinition.id + " with the name " + measureDefinition.name + " has an unknown or missing editmode '" + mode + "'!. Using fallback 'week'");
	            }
	        }

	        if (measureDefinition.distributionInformation.mode === "week") {
	            if (KEYWORD_EDITABLE_ENABLEPASTWEEKS in editableInformation) {
	                measureDefinition.distributionInformation.enablePastWeeks = editableInformation[KEYWORD_EDITABLE_ENABLEPASTWEEKS] === true;
	            }

	            if (KEYWORD_EDITABLE_DISTRIBUTION in editableInformation) {
	                var referencedMeasureName = editableInformation[KEYWORD_EDITABLE_DISTRIBUTION];

	                measureDefinition.distributionInformation.measureName = referencedMeasureName;
	                measureDefinition.distributionInformation.measureIndex = getMeasureIndex(referencedMeasureName);
	            } else {
	                throw new CasException.CasException("The KPI " + measureDefinition.name + " is specified as editable but the distribution information is missing.");
	            }
	        }
	    } else {
	        throw new CasException.CasException("The KPI " + measureDefinition.name + " is specified as editable but the information is incomplete.");
	    }
	}

	/**
	 * Parses all information for the aggregation
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {Object} measure.aggregation
	 * @param {string} measure.aggregation.rule
	 * @param {string[]} measure.aggregation.skippeddimensions
	 */
	function parseAggregationInstruction(measureDefinition, measure) {
	    measureDefinition.aggregation = reducers.none;
	    measureDefinition.aggregationIsFormulaBased = false;

	    if (KEYWORD_AGGREGATION in measure) {
	        var aggregationInformation = measure[KEYWORD_AGGREGATION];

	        if (aggregationInformation[KEYWORD_AGGREGATION_RULE] !== undefined) {
	            if (aggregationInformation[KEYWORD_AGGREGATION_RULE] === "formula") {
	                measureDefinition.aggregationIsFormulaBased = true;
	            } else if (aggregationInformation[KEYWORD_AGGREGATION_RULE] in reducers) {
	                measureDefinition.aggregation = reducers[aggregationInformation[KEYWORD_AGGREGATION_RULE]];
	            } else {
	                log.warn("The Aggregation rule of the KPI " + measureDefinition.name + " is not available");
	            }
	        } else {
	            log.warn("The KPI " + measureDefinition.name + " has no Aggregation rule specified.");
	        }

	        parseSkippedDimensions(measureDefinition, aggregationInformation);
	    } else {
	        log.warn("The KPI " + measureDefinition.name + " has no Aggregation information specified.");
	    }
	}

	/**
	 * Parses all information for the calculation of the total
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {Object} measure.totalcalculation
	 * @param {string} measure.totalcalculation.rule
	 */
	function parseTotalCalculationInstruction(measureDefinition, measure) {
	    measureDefinition.totalCalculation = reducers.none;
	    measureDefinition.totalCalculationIsFormulaBased = false;

	    if (KEYWORD_TOTALCALCULATION in measure) {
	        var totalCalculationInformation = measure[KEYWORD_TOTALCALCULATION];

	        if (totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE] !== undefined) {
	            if (totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE] === "formula") {
	                measureDefinition.totalCalculationIsFormulaBased = true;
	            } else if (totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE] in reducers) {
	                measureDefinition.totalCalculation = reducers[totalCalculationInformation[KEYWORD_TOTALCALCULATION_RULE]];
	            } else {
	                log.warn("The TotalCalculation rule of the KPI " + measureDefinition.name + " is not available");
	            }
	        } else {
	            log.warn("The KPI " + measureDefinition.name + " has no TotalCalculation rule specified.");
	        }
	    } else {
	        log.warn("The KPI " + measureDefinition.name + " has no TotalCalculation information specified.");
	    }
	}

	/**
	 * Parses all information for the displaying
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {Object} measure.display
	 * @param {boolean} [measure.display.enabled = true]
	 * @param {number} [measure.display.round = 2]
	 */
	function parseDisplayInstruction(measureDefinition, measure) {
	    var displayInformation = {
	        enabled: true,
	        round: 2
	    };

	    if (KEYWORD_DISPLAY in measure) {
	        var display = measure[KEYWORD_DISPLAY];

	        if (display.enabled !== undefined) {
	            displayInformation.enabled = display.enabled;
	        }

	        if (display.round !== undefined) {
	            displayInformation.round = display.round;
	        }
	    } else {

	        log.info("The measure " + measureDefinition.name + "on index " + measureDefinition.id + " has no display property defined. Using fallback.");
	    }

	    measureDefinition.display = displayInformation;
	}

	/**
	 *
	 * @param measureDefinition
	 * @param measure
	 */
	function parseStorageInstructions(measureDefinition, measure) {
	    measureDefinition.storageOptions = {
	        code: "",
	        writeBack: false,
	        levels: []
	    };

	    if (KEYWORD_STORAGEOPTIONS in measure) {
	        var storageOptions = measure[KEYWORD_STORAGEOPTIONS];

	        measureDefinition.storageOptions.writeBack = storageOptions[KEYWORD_STORAGEOPTIONS_WRITEBACK] === true;

	        if (measureDefinition.storageOptions.writeBack) {

	            if (KEYWORD_STORAGEOPTIONS_CODE in storageOptions) {
	                measureDefinition.storageOptions.code = storageOptions[KEYWORD_STORAGEOPTIONS_CODE];
	            } else {
	                throw new CasException.CasException("The measure on index " + measureDefinition.id + " with the name " + measureDefinition.name + " is defined as writeBack but has no code assigned!");
	            }

	            if (KEYWORD_STORAGEOPTIONS_STORAGELEVELS in storageOptions) {
	                var levels = storageOptions[KEYWORD_STORAGEOPTIONS_STORAGELEVELS];
	                if (_.isArray(levels)) {
	                    levels.forEach(function (levelName) {
	                        measureDefinition.storageOptions.levels.push(levelName);
	                    });
	                } else {
	                    log.error("The measure " + measureDefinition.name + "on index " + measureDefinition.id + " has malformed storageOptions-Information.");
	                }
	                measureDefinition.storageOptions.levels = storageOptions[KEYWORD_STORAGEOPTIONS_STORAGELEVELS];
	            }

	            if (measureDefinition.storageOptions.levels.length === 0) {
	                measureDefinition.storageOptions.writeBack = false;
	                log.warn(measureDefinition.name + ": Writeback activated but no StorageLevel defined. Deactivating writeback for this measure temporary.");
	            }
	        }
	    }
	}

	/**
	 * Parses the name of the measure
	 * @param measureDefinition
	 * @param {Object} measure
	 * @param {string} measure.name
	 */
	function parseMeasureName(measureDefinition, measure) {
	    if (KEYWORD_NAME in measure) {
	        measureDefinition.name = measure[KEYWORD_NAME];
	    } else {
	        measureDefinition.name = "Undefined";
	        throw new CasException.CasException("The measure on index " + measureDefinition.id + " has no name assigned!");
	    }
	}

	function computeMeasureDefinitions(measures) {
	    meta.measures = [];
	    meta.editableCodeIndexMapping = {};
	    computeMeasureIndexMapping(measures);

	    for (var i = 0; i < measures.length; i++) {
	        var measure = measures[i];
	        var measureDefinition = {};

	        measureDefinition.id = i;

	        parseMeasureName(measureDefinition, measure);

	        parseDisplayInstruction(measureDefinition, measure);

	        parseAggregationInstruction(measureDefinition, measure);

	        parseTotalCalculationInstruction(measureDefinition, measure);

	        parseKPITypeInstruction(measureDefinition, measure);

	        parseStorageInstructions(measureDefinition, measure);

	        meta.measures[i] = measureDefinition;

	        measureDefinition.dependingMeasures = [];

	        /**
	         * Registers a measureDefinition as a dependent measure.
	         * @param dependingMeasure
	         */
	        var addDependency = function addDependency(dependingMeasure) {
	            if (this.id === dependingMeasure.id) {
	                throw new CasException.CasException("The KPI '" + dependingMeasure.name + "' cannot depend on itself!");
	            } else if (this.dependingMeasures[dependingMeasure.id] === undefined) {
	                this.dependingMeasures[dependingMeasure.id] = dependingMeasure;
	            } else {
	                log.debug("KPI '" + dependingMeasure.name + "' already added as a dependency");
	            }
	        };

	        measureDefinition.registerDependency = addDependency;

	        /**
	         * indicates whether the aggregation uses a formula or not
	         */
	        measureDefinition.isAggregationBasedOnFormula = function () {
	            return this.aggregationIsFormulaBased;
	        };

	        /**
	         * indicates whether the total calculation uses a formula or not
	         */
	        measureDefinition.isTotalCalculationBasedOnFormula = function () {
	            return this.totalCalculationIsFormulaBased;
	        };
	    }

	    computeMeasureDependencies(meta.measures);
	}

	/**
	 * Computes all direct dependencies between two KPIs
	 * @param {Object[]} measureDefinitions
	 */
	function computeMeasureDependencies(measureDefinitions) {

	    for (var i = 0; i < measureDefinitions.length; i++) {
	        var measureDefinition = measureDefinitions[i];

	        // only necessary for computed KPIs
	        if (measureDefinition.computed) {
	            for (var argIndex = 0; argIndex < measureDefinition.args.length; argIndex++) {
	                var functionArgument = measureDefinition.args[argIndex];
	                measureDefinitions[functionArgument.measureIndex].registerDependency(measureDefinition);
	            }
	        }
	    }
	}

	function computeMeasureIndexMapping(measures) {
	    meta.measureIndexMapping = {};
	    for (var i = 0; i < measures.length; i++) {
	        var measure = measures[i];

	        if (meta.measureIndexMapping[measure.name] === undefined) {
	            meta.measureIndexMapping[measure.name] = i;
	        } else {
	            throw new CasException.CasException("KPI-Names must be unique, but found the KPI '" + measure.name + "' multiple times.");
	        }
	    }
	}

	function computeDimensionIndexMapping(dimensions) {
	    meta.dimensionIndexMapping = {};
	    for (var i = 0; i < dimensions.length; i++) {
	        var dimensionName = dimensions[i];
	        meta.dimensionIndexMapping[dimensionName] = i;

	        if (dimensionName === KEYWORD_MEASURES) {
	            meta._levelOfMeasures = i;
	        }
	    }
	}

	function getDimensionIndex(dimensionName) {
	    if (dimensionName in meta.dimensionIndexMapping) {
	        return meta.dimensionIndexMapping[dimensionName];
	    } else {
	        throw new CasException.CasException("Could not find the dimension with the name: " + dimensionName);
	    }
	}

	var computeLevelIndexMapping = function computeLevelIndexMapping(levels) {
	    meta.levelIndexMapping = {};
	    for (var i = 0; i < levels.length; i++) {
	        var levelName = levels[i];
	        meta.levelIndexMapping[levelName] = i;

	        if (levelName === KEYWORD_MEASURES) {
	            meta._levelOfMeasures = i;
	        }
	    }
	};

	/**
	 * Gets the index of a specific level via its name
	 * @throws {CasException} Throws an exception if the levelName does not exist.
	 * @todo Check if this is helpful after changing to dimensions!
	 * @param levelName
	 */
	function getLevelIndex(levelName) {
	    if (levelName in meta.levelIndexMapping) {
	        return meta.levelIndexMapping[levelName];
	    } else {
	        throw new CasException.CasException("Could not find the level with the name: " + levelName);
	    }
	}

	/**
	 * Parses all function arguments
	 * @param {string} argumentString
	 * @return {Object}
	 */
	function parseFunctionArguments(argumentString) {
	    var functionArguments = [];

	    if (argumentString.trim() !== "") {
	        var argumentStrings = argumentString.split(/,/g);
	        for (var i = 0; i < argumentStrings.length; i++) {
	            var functionArgument = { "isComplexArgument": false };
	            var argumentInformation = argumentStrings[i].split(/\$/g);

	            if (argumentInformation.length > 3) {
	                throw new CasException.CasException("Invalid number of function-argument-delimiter. There are no more than 2 delimiters allowed, but found " + (argumentInformation.length - 1) + " delimiters.");
	            } else {
	                functionArgument.measureName = argumentInformation[0].trim();
	                functionArgument.measureIndex = getMeasureIndex(functionArgument.measureName);

	                if (argumentInformation.length > 1) {
	                    functionArgument.isComplexArgument = true;
	                    functionArgument.levelName = argumentInformation[1].trim();
	                    //FixMe: This cannot be solved without the Data/Hierarchy-Information!
	                    functionArgument.levelIndex = getLevelIndex(functionArgument.levelName);
	                } else {
	                    functionArgument.levelName = undefined;
	                    functionArgument.levelIndex = undefined;
	                }

	                if (argumentInformation.length > 2) {
	                    argumentInformation[2] = argumentInformation[2].trim().toLowerCase();
	                    functionArgument.useTotal = argumentInformation[2] === KEYWORD_TOTAL;
	                } else {
	                    functionArgument.useTotal = false;
	                }
	            }

	            functionArguments.push(functionArgument);
	        }
	    }

	    return functionArguments;
	}

	function parseFormula(formulaString) {
	    var parsingResult = {};

	    var formulaParts = formulaString.split("=>");
	    var args = formulaParts[0];
	    var body = formulaParts[1];

	    // replace opening and closing parenthesis
	    args = args.replace(/[\(\)]/g, "").trim();

	    // Create function with args as parameters (if exists) and VARS as additional Parameter
	    parsingResult.func = new Function("calcHelper" + (args.length > 0 ? ", " + args : ""),
	    // Add the Body of the function
	    (body.indexOf("{") < 0 ? "return " : "") + body);

	    // Split the Function Arguments by "," and whitespaces if any exist
	    parsingResult.args = parseFunctionArguments(args);

	    return parsingResult;
	}

	/**
	 * Gets the index of a measure based on its name.
	 * @param measuresName
	 * @returns {number} the index of the measure (0...n)
	 * @throws {Error} Throws an error if the measureName is not valid/cannot be found.
	 */
	function getMeasureIndex(measuresName) {
	    if (measuresName in meta.measureIndexMapping) {
	        return meta.measureIndexMapping[measuresName];
	    } else {
	        throw new CasException.CasException("Could not find the measure with the name: " + measuresName);
	    }
	}

	/**
	 * Gets all MeasureDefinitions which are based on database tables
	 * @return {Array}
	 */
	function getDataSourceBasedKPIs() {
	    return _.filter(meta.measures, function (measureDefinition) {
	        return measureDefinition.isDataSourceBased;
	    });
	}

	/**
	 * Gets all MeasureDefinitions where writeBack is enabled
	 * @return {Object[]}
	 */
	function getWriteBackKPIs() {
	    return _.filter(meta.measures, function (measureDefinition) {
	        return measureDefinition.storageOptions.writeBack;
	    });
	}

	if (true) {
	    module.exports.parseMeta = parseMeta;
	}

	function MyRawStream() {}

	MyRawStream.prototype.write = function (rec) {
	    console.log('[%s] %s: %s', rec.time.toISOString(), bunyan.nameFromLevel[rec.level], rec.msg);
		};

/***/ },

/***/ 269:
/***/ function(module, exports) {

	"use strict";

	/**
	 * Created by carl.r.rieger on 08-Jul-16.
	 */

	/**
	 * Calculates the sum of all values in the array
	 * @param {number} previousValue
	 * @param {number} currentValue
	 * @return {number}
	 */
	function sum(previousValue, currentValue) {
	    if (previousValue === null || previousValue === undefined || isNaN(previousValue)) {
	        return currentValue;
	    } else if (currentValue === null || currentValue === undefined || isNaN(currentValue)) {
	        return previousValue;
	    } else {
	        return previousValue + currentValue;
	    }
	}

	/**
	 * Calculates the minimum of all values in the array
	 * @param {number} previousValue
	 * @param {number} currentValue
	 * @return {number}
	 */
	function min(previousValue, currentValue) {
	    if (previousValue === null || previousValue === undefined || isNaN(previousValue)) {
	        return currentValue;
	    } else if (currentValue === null || currentValue === undefined || isNaN(currentValue)) {
	        return previousValue;
	    } else {
	        return Math.min(previousValue, currentValue);
	    }
	}

	/**
	 * Calculates the maximum of all values in the array
	 * @param {number} previousValue
	 * @param {number} currentValue
	 * @return {number}
	 */
	function max(previousValue, currentValue) {
	    if (previousValue === null || previousValue === undefined || isNaN(previousValue)) {
	        return currentValue;
	    } else if (currentValue === null || currentValue === undefined || isNaN(currentValue)) {
	        return previousValue;
	    } else {
	        return Math.max(previousValue, currentValue);
	    }
	}

	/**
	 * Calculates the average of all values in the array excluding null values
	 * @param {number} previousValue
	 * @param {number} currentValue
	 * @param {number} currentIndex
	 * @param {number[]} array
	 * @return {number}
	 */
	function average(previousValue, currentValue, currentIndex, array) {
	    var returnValue;

	    // set the values to 0 if they are null, undefined or NaN
	    previousValue = previousValue || 0;
	    currentValue = currentValue || 0;

	    returnValue = previousValue + currentValue;

	    // at the and of the reduce-function count the number of notNullValues to calculate the average
	    if (currentIndex === array.length - 1) {
	        var countIsNotNull = 0;
	        for (var i = 0; i < array.length; i++) {
	            if (array[i] !== null && array[i] !== undefined && !isNaN(array[i])) {
	                countIsNotNull++;
	            }
	        }

	        if (countIsNotNull > 0) {
	            returnValue = returnValue / countIsNotNull;
	        } else {
	            returnValue = null;
	        }
	    }

	    return returnValue;
	}

	/**
	 * Returns null as aggregated value
	 * @return {null}
	 */
	function none() {
	    return null;
	}

	var reducers = {
	    "sum": sum,
	    "min": min,
	    "max": max,
	    "avg": average,
	    "null": none,
	    "none": none
	};

		module.exports.ArrayReducer = reducers;

/***/ },

/***/ 270:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

	var _ = __webpack_require__(202);

	Date.prototype.ACSF_dayDiff = function (date) {
	    var timestamp = this.getTime();
	    var dateTimestamp = date.getTime();
	    return (timestamp - dateTimestamp) / 86400000; // milliseconds per day
	};

	/**
	 * Provides helper methods for a calculation formula
	 * @param {Object} meta Information about the resulting structure (ColumnOrder, CalculationFormulas,...)
	 * @param {Object} meta.axis Information about the axis of the grid
	 * @param {string} meta.axis.x Reference to the columns in data.columns
	 * @param {string[]} meta.axis.y Reference to the columns in data.columns. Must include "measures" as KeyWord
	 * @param {Object[]} meta.measures Collection of all measures of the grid
	 * @param {string} meta.measures[].name Name of the measures (for displaying and as reference to columns if provided in data.data)
	 * @param {boolean} meta.measures[].display Indicates if the measure shall be displayed or is only necessary for calculation
	 * @param {boolean} meta.measures[].editable Indicates if this measure can be edited
	 * @param {boolean} meta.measures[].writeBack Indicates if the edited values of this measure shall be persisted (only in use with editable=true)
	 * @param {boolean} meta.measures[].computed Indicates if this measure must be calculated
	 * @param {string} meta.measures[].formula Formula used for the calculation of this measure (only in use with computed=true), must be a valid JS-Function. Can reference measures and VARS
	 * @param {string} meta.measures[].aggregation Instruction how to aggregate this measure (null|+|min|max...)
	 * @param {string} meta.measures[].totalColumnCalc Instruction how to aggregate the TotalColumn (null|+|min|max...) (see meta.total.display)
	 * @param {Object} meta.total Information if the TotalColumn should be calculated/displayed
	 * @param {boolean} meta.total.display Indicates if the TotalColumn shall be calculated and displayed (see data.columns[].totalColumnCalc)
	 * @param {string} meta.total.label Label to be displayed/returned for the TotalColumn
	 * @param {Object} metaData The data itself and information about the structure of the Data
	 * @param {number[][]} metaData.data The Data itself and the MetaData about the given Data
	 * @param {Object[]} metaData.dimensions Collection of all columns information of the tableData
	 * @param {String} metaData.dimensions[].name Name of the Column
	 * @param {String[]} metaData.dimensions[].lookups 0-Indexed lookUp-Values for the tableData
	 * @param {Object} variables promotion variables of the current promotion
	 * @param {Object} logger object
	 */
	var CalcHelper = function CalcHelper(meta, metaData, variables, logger) {
	    /**
	     * Current TreeNode
	     * @type {TreeNode}
	     * @private
	     */
	    var _node = null;

	    /**
	     * Currently calculated Week
	     * @type number|null
	     * @private
	     */
	    var _weekIndex = null;

	    /**
	     * Current position within the Tree
	     * @type {number[]|null}
	     * @private
	     */
	    var _position = null;

	    var _contextVariables = {};

	    var self = this;
	    var _externalLogger = logger.child({ widget_type: "formula" }); // logger for formulas
	    var _internalLogger = logger.child({ widget_type: 'calcHelper' });
	    var _weekVariables = _.find(metaData.dimensions, function (dim) {
	        return dim.type === "time";
	    });

	    /**
	     * sets the node into the context
	     * @param {TreeNode} node The node that defines the new context
	     */
	    this.setNode = function (node) {
	        _node = node;
	        _position = null;
	        _weekIndex = null;
	        _contextVariables = {};
	    };

	    this.setWeekIndex = function (weekIndex) {
	        _weekIndex = weekIndex;
	    };

	    /**
	     * Gets the position of the current node in the tree (path)
	     * @return {number[]}
	     */
	    this.getPosition = function () {
	        if (_position === null) {
	            _position = _node.getPositionInTree();
	        }
	        return _position;
	    };

	    /**
	     * Returns the level of the current node as text
	     * return {string|null}
	     */
	    this.getLevelName = function () {
	        if (_node === null) {
	            _internalLogger.fatal(this.formatLogMessage('getLevelName: No node defined.'));
	            return null;
	        }
	        // todo: hierarchy levels
	        var level = _node.getDimensionId();

	        return meta.axis.y[level];
	    };

	    /**
	     * Gets a set of variables based on the current context and the defined dimension
	     * @param {String} dimensionName
	     * @returns {null|Object}
	     */
	    var getContextVariables = function getContextVariables(dimensionName) {
	        if (_contextVariables[dimensionName] !== undefined) {
	            // get cached variables
	            return _contextVariables[dimensionName];
	        } else {
	            var levelVariables;
	            var id;

	            if (dimensionName === "Promotion") {
	                levelVariables = variables["promotions"];
	                for (id in levelVariables) {
	                    break;
	                } // get the 'first' promotion id
	            } else {
	                var dimension = metaData.getDimensionByName(dimensionName);
	                var levelIdx = metaData.getLevelIndex(dimensionName);
	                var lookupIndex = self.getPosition()[levelIdx];
	                id = dimension.lookups[lookupIndex];
	                var levelNamePlural = dimensionName.toLowerCase() + 's';

	                levelVariables = variables[levelNamePlural];
	                if (levelVariables === undefined) {
	                    _internalLogger.error(self.formatLogMessage('getVariable: ' + dimensionName + " variables are not supported"));
	                    _contextVariables[dimensionName] = null;
	                    return null;
	                }
	            }

	            var levelObjectVariables = levelVariables[id];
	            if (levelObjectVariables !== undefined) {
	                _contextVariables[dimensionName] = levelObjectVariables;
	            } else {
	                _contextVariables[dimensionName] = null;
	                _internalLogger.error(self.formatLogMessage('getVariable: ' + dimensionName + ' with id ' + id + ' does not exist'));
	            }

	            return levelObjectVariables;
	        }
	    };

	    /**
	     * gets a value of a promotion variable
	     * @param levelName "Promotion"|"Tactic"
	     * @param variableName name of the variable
	     */
	    var getPromotionVariable = function getPromotionVariable(levelName, variableName) {
	        var levelObjectVariables = getContextVariables(levelName);

	        if (levelObjectVariables !== null) {
	            var result = levelObjectVariables[variableName];
	            if (result !== undefined) {
	                return result;
	            } else {
	                _internalLogger.error(self.formatLogMessage('getVariable: variable ' + variableName + ' is not available for ' + levelName + ' with Id: ' + _node.getLabel()));
	            }
	        }

	        return null;
	    };

	    /**
	     * Gets a value from the details of the Week dimension
	     * @param variableName name of the week variable
	     */
	    var getWeekVariable = function getWeekVariable(variableName) {
	        if (_weekIndex > 0) {
	            if (_weekVariables != null) {
	                var week = _weekIndex - 1; // skip the total
	                if (week in _weekVariables.details) {
	                    var weekVariablesCurrentWeek = _weekVariables.details[week];
	                    if (variableName in weekVariablesCurrentWeek) {
	                        return weekVariablesCurrentWeek[variableName];
	                    } else {
	                        _internalLogger.error(self.formatLogMessage('getVariable: variable ' + variableName + ' is not supported for week ' + week));
	                    }
	                } else {
	                    _internalLogger.error(self.formatLogMessage('getVariable: no variables given for week ' + week));
	                }
	            } else {
	                _internalLogger.error(self.formatLogMessage("getVariable: week variables are not supported"));
	            }
	        } else {
	            return null;
	        }
	    };

	    /**
	     * Determines the value of a variable
	     * @param {string} levelName The level on which the variable is defined
	     * @param {string} variableName The name of the variable
	     * @return {string|number|null|object}
	     */
	    this.getVariable = function (levelName, variableName) {
	        var result;

	        if (levelName === "Week") {
	            result = getWeekVariable(variableName);
	        } else {
	            result = getPromotionVariable(levelName, variableName);
	        }

	        return result;
	    };

	    /**
	     * calculates the fixed costs
	     * @param {number} Volume The volume of the current node
	     * @param {number} Volume$Tactic$Total The volume of the whole tactic
	     * @return {number|null}
	     */
	    this.calculateFixedCosts = function (Volume, Volume$Tactic$Total) {
	        var compensationModel = this.getVariable('Tactic', 'compensationmodel');
	        var calculatedCosts = null;

	        switch (compensationModel) {
	            case "LumpSum":
	                var amount = this.getVariable('Tactic', 'amount');
	                calculatedCosts = amount * Volume / Volume$Tactic$Total;
	                break;
	            case "PerCase":
	            case "Percentage":
	                _internalLogger.trace(this.formatLogMessage('calculateFixedCosts: Compensation model ' + compensationModel + ' is not supported'));
	                break;
	            default:
	                _internalLogger.warn(this.formatLogMessage('calculateFixedCosts: Compensation model ' + compensationModel + ' is not supported'));
	        }

	        return calculatedCosts;
	    };

	    /**
	     * calculates the variable costs
	     * @param {number} Volume The volume of the current node
	     * @param {number} Price The price of one item
	     * @return {number|null}
	     */
	    this.calculateVariableCosts = function (Volume, Price) {
	        var compensationModel = this.getVariable('Tactic', 'compensationmodel');
	        var amount = this.getVariable('Tactic', 'amount');
	        var calculatedCosts = null;

	        switch (compensationModel) {
	            case "PerCase":
	                calculatedCosts = Volume * amount;
	                break;
	            case "Percentage":
	                calculatedCosts = Volume * Price * amount / 100;
	                break;
	            case "LumpSum":
	                _internalLogger.trace(this.formatLogMessage('calculateVariableCosts: Compensation model ' + compensationModel + ' is not supported'));
	                break;
	            default:
	                _internalLogger.warn(this.formatLogMessage('calculateVariableCosts: Compensation model ' + compensationModel + ' is not supported'));
	        }

	        return calculatedCosts;
	    };

	    /**
	     * Gets the name of the current measure
	     * @return {string}
	     */
	    this.getMeasureName = function () {
	        var measureName = "";
	        var measureDefinition = _node.getMeasureDefinition();

	        if (measureDefinition !== null) {
	            measureName = measureDefinition.name;
	        }

	        return measureName;
	    };

	    /**
	     * length of the intersection of two given timeframes (in weeks)
	     * @param {Date} weekStart start date of the first period
	     * @param {Date} weekEnd end date of the first period
	     * @param {Date} timeframeStart start date of the second period
	     * @param {Date} timeframeEnd end date of the second period
	     * @return {number|null}
	     */
	    var weekShareAux = function weekShareAux(weekStart, weekEnd, timeframeStart, timeframeEnd) {
	        var result = null;
	        var start = weekStart > timeframeStart ? weekStart : timeframeStart;
	        var end = weekEnd < timeframeEnd ? weekEnd : timeframeEnd;
	        if (start <= end) {
	            result = (1 + end.ACSF_dayDiff(start)) / 7;
	        }

	        return result;
	    };

	    /**
	     * fraction of the currently calculate calender week which belong to the timeframe of the current tactic or promotion
	     * @return {number}
	     */
	    this.weekShare = function () {
	        var level = this.getLevelName();
	        var weekValidFrom = new Date(this.getVariable('Week', 'datefrom'));
	        var weekValidThru = new Date(this.getVariable('Week', 'datethru'));
	        var levelName = level === 'measures' ? "Promotion" : "Tactic";
	        var validFrom = new Date(this.getVariable(levelName, 'datefrom'));
	        var validThru = new Date(this.getVariable(levelName, 'datethru'));

	        return weekShareAux(weekValidFrom, weekValidThru, validFrom, validThru);
	    };

	    /**
	     * Number of days from today to the currently calculated week
	     * @return {number}
	     */
	    this.daysUntilStart = function () {
	        return new Date(this.getVariable('Week', 'datefrom')).ACSF_dayDiff(new Date());
	    };

	    /**
	     * Is the currently calculated week the start week of the promotion/tactic?
	     * @return {Boolean}
	     */
	    this.isStartWeek = function () {
	        var weekStart = new Date(this.getVariable('Week', 'datefrom'));
	        var levelName = this.getLevelName() === 'measures' ? 'Promotion' : 'Tactic';
	        var timeframeStart = new Date(this.getVariable(levelName, 'datefrom'));
	        return weekStart <= timeframeStart && timeframeStart.ACSF_dayDiff(weekStart) <= 6;
	    };

	    /**
	     * Is the currently calculated week the end week of the promotion/tactic?
	     * @return {Boolean}
	     */
	    this.isEndWeek = function () {
	        var weekEnd = new Date(this.getVariable('Week', 'datethru'));
	        var levelName = this.getLevelName() === 'measures' ? 'Promotion' : 'Tactic';
	        var timeframeEnd = new Date(this.getVariable(levelName, 'datethru'));
	        return weekEnd >= timeframeEnd && timeframeEnd.ACSF_dayDiff(weekEnd) >= -6;
	    };

	    /**
	     * @typedef {{}} TierDefinition
	     * @property {TierItem[]} tier
	     */

	    /**
	     * @typedef {{}} TierItem
	     * @property {number} fromValue
	     * @property {number} toValue
	     * @property {number} amount
	     */

	    /**
	     * Get the tiered rate of the tactic based on the given amount
	     * @param {string} variableName Name of the attribute in the tactic containing the tiered rates
	     * @param {number} amount
	     * @returns {number}
	     */
	    this.getTieredRate = function (variableName, amount) {
	        var tieredRate = 0;

	        if (amount >= 0) {

	            /**
	             * @type TierDefinition|null
	             */
	            var tierDefinition = this.getVariable('Tactic', variableName);

	            if (tierDefinition !== null && (typeof tierDefinition === "undefined" ? "undefined" : _typeof(tierDefinition)) === "object") {

	                var tiers = tierDefinition.tier;
	                if (tiers !== undefined && Array.isArray(tiers) && tiers.length > 0) {
	                    var matchingTierRateFound = false;

	                    for (var tierIndex = 0; tierIndex < tiers.length; tierIndex++) {
	                        var tier = tiers[tierIndex];

	                        if (tier.fromValue <= amount && amount < tier.toValue) {
	                            tieredRate = tier.amount;
	                            matchingTierRateFound = true;
	                            break;
	                        }
	                    }

	                    if (!matchingTierRateFound) {
	                        var highestTier = tiers[tiers.length - 1];
	                        if (amount >= highestTier.toValue) {
	                            tieredRate = highestTier.amount;
	                        }
	                    }
	                } else {
	                    _internalLogger.warn(this.formatLogMessage('Expected tiered rates!'));
	                }
	            }
	        }

	        return tieredRate;
	    };

	    /**
	     * Formats the message (prepends the measureName if available)
	     * @param {string} msg
	     * @return {string}
	     */
	    this.formatLogMessage = function (msg) {
	        var measureName = this.getMeasureName();

	        if (measureName !== "") {
	            msg = measureName + ": " + msg;
	        }

	        return msg;
	    };

	    /**
	     * Logs a message with priority 'trace'
	     * @param {string} msg
	     */
	    this.trace = function (msg) {
	        _externalLogger.trace(this.formatLogMessage(msg));
	    };

	    /**
	     * Logs a message with priority 'trace'
	     * @param {string} msg
	     */
	    this.debug = function (msg) {
	        _externalLogger.debug(this.formatLogMessage(msg));
	    };

	    /**
	     * Logs a message with priority 'info'
	     * @param {string} msg
	     */
	    this.info = function (msg) {
	        _externalLogger.info(this.formatLogMessage(msg));
	    };

	    /**
	     * Logs a message with priority 'warn'
	     * @param {string} msg
	     */
	    this.warn = function (msg) {
	        _externalLogger.warn(this.formatLogMessage(msg));
	    };

	    /**
	     * Logs a message with priority 'error'
	     * @param {string} msg
	     */
	    this.error = function (msg) {
	        _externalLogger.error(this.formatLogMessage(msg));
	    };

	    /**
	     * Logs a message with priority 'fatal'
	     * @param {string} msg
	     */
	    this.fatal = function (msg) {
	        _externalLogger.fatal(this.formatLogMessage(msg));
	    };
	};

	module.exports.CalcHelper = CalcHelper;

/***/ },

/***/ 271:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var _ = __webpack_require__(202);

	/**
	 * simple tree class to maintain filter
	 * @constructor
	 */
	var SimpleTree = function SimpleTree() {
	    this.value = null;
	    this.children = [];
	    this.level = null;
	};

	/**
	 * simple tree as a string
	 * @param tree an instance of simple tree
	 * @param indent {number} number of spaces used for indention
	 */
	var treeToString = function treeToString(tree, indent) {
	    var spaces = " ".repeat(indent);
	    var result = spaces + tree.level + ": " + tree.value + "\n";
	    for (var i in tree.children) {
	        var child = tree.children[i];
	        result += treeToString(child, indent + 1);
	    }
	    return result;
	};

	/**
	 * overwriting the toString function of simple trees
	 */
	SimpleTree.prototype.toString = function () {
	    return treeToString(this, 0);
	};

	/**
	 * converts a simple array to a filter array
	 * @param {number[]} array the array
	 * @returns {number[][]} e.g. [4,3,6,2] => [[0,4],[1,3],[2,6],[3,2]]
	 */
	var addIndex = function addIndex(array) {
	    var result = [];
	    for (var idx = 0; idx < array.length; idx++) {
	        result.push([idx, array[idx]]);
	    }
	    return result;
	};

	/**
	 * helper to build a tree using lookups and filter
	 * @param {number} levelIndex name of the root level
	 * @param getNextLevelName {function} gives the next level name
	 * @param levels {object[]} list of level name, items, startIndex, endIndex, dimensionIndex, hierarchyIndex
	 * @param filterTrees {SimpleTree[]} list of filters
	 */
	var TreeBuilder = function TreeBuilder(levelIndex, allLevels, filterTrees) {
	    /**
	     * get the indices of the children with a tree builder for the sub trees
	     * @ returns {Array} maps a index of a node to the tree builder for the sub tree
	     */
	    this.getChildren = function () {
	        var result = [];
	        var nextLevel = allLevels[levelIndex];
	        if (nextLevel === undefined) {
	            return result;
	        }
	        var nextLevelName = nextLevel.name;
	        for (var childIndex = nextLevel.startIndex; childIndex <= nextLevel.endIndex; childIndex++) {
	            var add = true;
	            var filterTreesRec = [];
	            for (var i = 0; i < filterTrees.length; i++) {
	                var filterTree = filterTrees[i];
	                var filterLevelName = filterTree.level;
	                if (nextLevelName == filterLevelName) {
	                    if (childIndex === -1 && filterTree.value === null) {
	                        // filter ignored
	                    } else if (childIndex in filterTree.children) {
	                        // filter applied
	                        var subtree = filterTree.children[childIndex];
	                        filterTreesRec.push(subtree);
	                    } else {
	                        // filter removed
	                        add = false;
	                        break;
	                    }
	                } else {
	                    // filter forwarded
	                    filterTreesRec.push(filterTrees[i]);
	                }
	            }
	            if (add) {
	                // add
	                if (nextLevelName == undefined) {
	                    result.value = childIndex;
	                } else {
	                    result[childIndex] = new TreeBuilder(levelIndex + 1, allLevels, filterTreesRec);
	                }
	            }
	        }
	        return result;
	    };
	};

	/**
	 * helper to split the filters into equivalence classes defined by the relation f1[pos] == f2[pos]
	 * @param {number[][]} filters
	 * @param {number} pos indicator position
	 * @returns {number[][][]}
	 */
	var partition = function partition(filters, pos) {
	    var subFilters = [];
	    for (var i = 0; i < filters.length; i++) {
	        var filter = filters[i];
	        var key = filter[pos];
	        if (key in subFilters) {
	            subFilters[key].push(filter);
	        } else {
	            subFilters[key] = [filter];
	        }
	    }
	    return subFilters;
	};

	/**
	 * recursive function to build up a filter as a (sub) tree
	 * @param {number[][]} filters list of all allowed combinations
	 * @param {[]} map defines in which order the items in filter must be considers
	 * @param {string[]} levels name of the levels
	 * @param {number} step skip the first items in the map
	 * @returns {SimpleTree} tree defining the filter
	 */
	var createFilterTreeRec = function createFilterTreeRec(filters, map, levels, step) {
	    var result = new SimpleTree();

	    if (step < levels.length) {
	        result.level = levels[step];
	    }

	    if (step < map.length) {
	        var pos = map[step];
	        var subFilters = partition(filters, pos);
	        for (var i = -1; i < subFilters.length; i++) {
	            var filter = subFilters[i];
	            if (filter !== undefined) {
	                var child = createFilterTreeRec(filter, map, levels, step + 1);
	                child.value = filter[0][pos];
	                result.children[i] = child;
	            }
	        }
	    }

	    return result;
	};

	/**
	 * creates a filter tree based on the list of allowed combinations
	 * @param {number[][]} filters list of all allowed combinations
	 * @param {[]} map defines in which order the items in filter must be considers
	 * @param {string[]} levels name of the levels
	 * @return {SimpleTree}
	 */
	var createFilterTree = function createFilterTree(filters, map, levels) {
	    return createFilterTreeRec(filters, map, levels, 0);
	};

	module.exports.addIndex = addIndex;
	module.exports.createFilterTree = createFilterTree;
	module.exports.TreeBuilder = TreeBuilder;

/***/ },

/***/ 272:
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	/* globals CasException */

	var _ = __webpack_require__(202);
	var benchmark = __webpack_require__(267);

	/**
	 *
	 * @type {CalcHelper}
	 */
	var calculationHelper = undefined;
	var meta = undefined;
	var dataMeta = undefined;
	var log = undefined;

	/**
	 *
	 * @type {{UNKNOWN: number, ROOT: number, GROUPING: number, LEAF: number}}
	 * @readonly
	 * @enum {number}
	 * @private
	 */
	var _NodeTypes = {
	    UNKNOWN: 0,
	    ROOT: 1,
	    GROUPING: 2,
	    LEAF: 3
	};

	/**
	 * Gets the Data of all given leafs
	 * @param {TreeNode[]} leafs Array of leafs to get
	 * @returns {number[][]}
	 * @Todo Check if this method could be reused (modified) for calculation + distribution
	 */
	function getLeafDataRows(leafs) {
	    var leafData = [];

	    for (var i = 0; i < leafs.length; i++) {
	        var leaf = leafs[i];
	        if (leaf !== undefined) {
	            leafData[i] = leaf.getData();
	        }
	    }

	    return leafData;
	}

	/**
	 * Sums up the the data in the specified column of all given Rows
	 * @param {number[][]} dataRows Rows to be summed up
	 * @param {number} columnIndex Index of the column to be summed up
	 * @returns {number}
	 * @Todo Check if this is needed / could be reused
	 */
	function sumColumn(dataRows, columnIndex) {
	    var sum = 0;

	    for (var i = 0; i < dataRows.length; i++) {
	        var dataRow = dataRows[i];
	        if (dataRow !== undefined) {
	            if (dataRow[columnIndex] !== undefined && dataRow[columnIndex] !== null) {
	                sum += dataRow[columnIndex];
	            }
	        }
	    }

	    return sum;
	}

	/**
	 * Calculates the TotalColumn
	 * Considers if the totalColumn shall be displayed.
	 */
	function calculateTotal(row, measureDefinition) {
	    if (measureDefinition !== null) {
	        // if the total calculation uses a formula, the correct value is already calculated in executeCalculationFormula()
	        if (!measureDefinition.isTotalCalculationBasedOnFormula()) {
	            row[0] = row.slice(1).reduce(measureDefinition.totalCalculation);
	        }
	    } else {
	        row[0] = null;
	    }
	}

	/**
	 * Gets a single column out of a 2D-Array a single row
	 * @param {number[][]} rows
	 * @param {number} columnId
	 */
	function getColumnInRows(rows, columnId) {
	    var column = [];

	    for (var rowId = 0; rowId < rows.length; rowId++) {
	        if (rows[rowId] !== undefined) {
	            column.push(rows[rowId][columnId]);
	        }
	    }

	    return column;
	}

	/**
	 * Breaks down a value over a column based on on a reference column
	 * @param {TreeNode} originNode The source node where the distribution started to happen
	 * @param {number} columnIndex The column within the DataRow where the value needs to be distributed across
	 * @param {number|null} value The Value to be distributed
	 * @param {number} measureIndex The Index of the KPI to be used as reference for the proportional distribution
	 */
	var breakDownProportionalTo = function breakDownProportionalTo(originNode, columnIndex, value, measureIndex) {
	    log.trace("breakDownProportionalTo() - Start");
	    // Get all leafs
	    var leafs = originNode.getLeafs();
	    log.debug("breakDownProportionalTo() - Found " + leafs.length + "Leafs");

	    // Get the reference KPI
	    var nodePosition = originNode.getPositionInTree();
	    var levelOfMeasures = meta.getLevelOfMeasures();
	    nodePosition[levelOfMeasures] = measureIndex;

	    // Todo: Check what would happen if the requested node does not exist! E.g. Tactic-Agnostic!
	    var proportionalNode = originNode.getNode(nodePosition);
	    var proportionalLeafs = proportionalNode.getLeafs();

	    var sumOfReferenceColumn = sumColumn(getLeafDataRows(proportionalLeafs), columnIndex);

	    distributeProportional(leafs, columnIndex, measureIndex, sumOfReferenceColumn, value, originNode);

	    log.trace("breakDownProportionalTo() - End");
	};

	/**
	 * Distributes a value over a column proportional to a reference column
	 * @param {TreeNode[]} leafs Nodes which will be affected by the distribution
	 * @param {number} columnIndex Identifier of the column where the distribution shall occur
	 * @param {number} measureIndex Reference KPI
	 * @param {number} sumOfReferenceColumn Sum of the reference column
	 * @param {number|null} value The value which shall be distributed over all given leafs
	 * @param {TreeNode} originNode The node where the Distribution started
	 */
	var distributeProportional = function distributeProportional(leafs, columnIndex, measureIndex, sumOfReferenceColumn, value, originNode) {
	    // FixMe: Will most likely need rework due to new concept
	    var levelOfMeasures = meta.getLevelOfMeasures();
	    for (var i = 0; i < leafs.length; i++) {
	        var leaf = leafs[i];
	        if (leaf !== undefined) {
	            var nodePosition = leaf.getPositionInTree();

	            if (value === null) {
	                leaf.setData(columnIndex, null);
	            } else if (sumOfReferenceColumn !== 0 && value !== 0) {

	                nodePosition[levelOfMeasures] = measureIndex;
	                // Todo: Check what would happen if the requested node does not exist!
	                var referenceNode = originNode.getNode(nodePosition);

	                leaf.setData(columnIndex, referenceNode.getRawData()[columnIndex] / sumOfReferenceColumn * value);
	            } else {
	                leaf.setData(columnIndex, 0);
	            }
	        }
	    }
	};

	/**
	 *
	 * @param {TreeNode} sourceNode
	 * @param {number|null} value
	 */
	var distributeViaCopy = function distributeViaCopy(sourceNode, value) {
	    var leafNodes = sourceNode.getLeafs();

	    for (var leafIndex = 0; leafIndex < leafNodes.length; leafIndex++) {
	        var leafNode = leafNodes[leafIndex];

	        if (leafNode !== undefined) {
	            for (var columnIndex = 1; columnIndex < dataMeta.noOfDataColumns; columnIndex++) {
	                leafNode.setData(columnIndex, value);
	            }
	        }
	    }
	};

	/**
	 * Class TreeNode
	 * Used to store all information as part of a tree
	 * @class
	 * @param {number} globalId Unique Id of the node within the whole tree
	 * @param {number} nodeId Id of the Node within the subtree
	 * @param {number} dimensionId
	 * @param {number} hierarchyLevel
	 * @param {number} nodeLevel Level of the Node (Root is 0)
	 * @param {_NodeTypes} nodeType
	 * @param {TreeNode} parentNode Reference to the parent of this Node
	 * @param {TreeNode} rootNode Reference to the root
	 * @param {Object} measureDefinition
	 * @constructor
	 */
	var TreeNode = function TreeNode(globalId, nodeId, dimensionId, hierarchyLevel, nodeLevel, nodeType, parentNode, rootNode, measureDefinition) {
	    this.id = globalId;
	    this.nodeId = nodeId;
	    this._dimensionId = dimensionId;
	    this._hierarchyLevel = hierarchyLevel;
	    this.parentNode = parentNode;
	    this.rootNode = rootNode;
	    this.nodeLevel = nodeLevel;
	    this.nodeType = nodeType;
	    this._children = [];
	    this._measureDefinition = measureDefinition;
	    this._manualChanges = [];

	    /**
	     * Sets a value in the specified column on this node
	     * Will be distributed down if this column is editable and this node a grouping-node
	     * @public
	     * @memberOf TreeNode
	     * @param {number} columnIndex
	     * @param {number|null} value
	     */
	    this.set = function (columnIndex, value) {
	        log.trace("set() - Start");
	        benchmark.startMeasurement('Set');

	        if (value === undefined || value === _.trim(value)) {
	            value = null;
	        }

	        if (this.isEditable(columnIndex)) {

	            this.addManualChange(columnIndex, value);

	            if (columnIndex === 0) {
	                distributeViaCopy(this, value);
	            } else {
	                var measureDefinition = this.getMeasureDefinition();
	                var measureIndex = measureDefinition.distributionInformation.measureIndex;
	                // distribute the value proportional
	                breakDownProportionalTo(this, columnIndex, value, measureIndex);
	            }

	            this.setDependingNodesDirty();
	        } else {
	            throw new CasException.CasException("Trying to change content of non-editable KPI ");
	        }

	        log.trace("set() - End");
	        benchmark.endMeasurement('Set');
	    };
	};

	/**
	 * Id of the TreeNode. Must be globally unique!
	 * @public
	 * @memberOf TreeNode
	 * @type {number}
	 */
	TreeNode.prototype.id = -1;

	/**
	 * Id of this node relative to the parentNode
	 * @public
	 * @memberOf TreeNode
	 * @type {number}
	 */
	TreeNode.prototype.nodeId = -1;

	/**
	 * Reference to the parent of this node
	 * @memberOf TreeNode
	 * @public
	 * @type {TreeNode}
	 */
	TreeNode.prototype.parentNode = null;

	/**
	 * Reference to the root of this tree
	 * @public
	 * @memberOf TreeNode
	 * @type {TreeNode}
	 */
	TreeNode.prototype.rootNode = null;

	/**
	 * Level inside of the Tree
	 * The RootNode has -1. The next 0 and so on
	 * @public
	 * @memberOf TreeNode
	 * @type {number}
	 */
	TreeNode.prototype.nodeLevel = -1;

	/**
	 * NodeType of the TreeNode
	 * @memberOf TreeNode
	 * @type {_NodeTypes}
	 */
	TreeNode.prototype.nodeType = _NodeTypes.UNKNOWN;

	/**
	 * Indicates if the children of the TreeNode are LeafNodes
	 * @memberOf TreeNode
	 * @type {boolean}
	 */
	TreeNode.prototype.childAreLeafs = false;

	/**
	 * Collection of all direct children of this node
	 * @private
	 * @memberOf TreeNode
	 * @type {TreeNode[]}
	 */
	TreeNode.prototype._children = undefined;

	/**
	 * Storage for the data in this node
	 * @private
	 * @memberOf TreeNode
	 * @type {number[]|null}
	 */
	TreeNode.prototype._data = null;

	/**
	 * Dirty flag which indicates that the node must be recalculated
	 * @private
	 * @memberOf TreeNode
	 * @type {boolean}
	 */
	TreeNode.prototype._dirty = true;

	/**
	 * References the definition of the Measure, if available
	 * @private
	 * @memberOf TreeNode
	 * @type {null|Object}
	 */
	TreeNode.prototype._measureDefinition = null;

	/**
	 * Id of the Dimension this TreeNode represents
	 * @memberOf TreeNode
	 * @type {number}
	 * @private
	 */
	TreeNode.prototype._dimensionId = -1;

	/**
	 * The level in the hierarchy
	 *
	 * 0 = Dimension
	 * 1 = Dimension.Parent
	 * 2 = Dimension.Parent.Parent ...
	 * @memberOf TreeNode
	 * @type {number}
	 * @private
	 */
	TreeNode.prototype._hierarchyLevel = -1;

	/**
	 * Indicates if this object is the root or not
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.isRoot = function () {
	    return this.nodeType === _NodeTypes.ROOT;
	};

	/**
	 * Indicates if this object is a leaf or not
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.isLeaf = function () {
	    return this.nodeType === _NodeTypes.LEAF;
	};

	/**
	 * Indicates if this object is a grouping level or not
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.isGrouping = function () {
	    return this.nodeType === _NodeTypes.GROUPING;
	};

	/**
	 * Indicates if this node needs to be recalculated
	 * @public
	 * @memberOf TreeNode
	 * @return {boolean}
	 */
	TreeNode.prototype.isDirty = function () {
	    return this._dirty;
	};

	/**
	 * Indicates if this node is a dimension
	 * @public
	 * @memberOf TreeNode
	 * @return {boolean} TRUE this node is a dimension. FALSE this node is a HierarchyNode
	 */
	TreeNode.prototype.isDimensionNode = function isDimensionNode() {
	    return this._hierarchyLevel === 0;
	};

	/**
	 * Indicates if this node is a hierarchy node
	 * @public
	 * @memberOf TreeNode
	 * @return {boolean} TRUE this node is a HierarchyNode. FALSE this node is a dimension
	 */
	TreeNode.prototype.isHierarchyNode = function isHierarchyNode() {
	    return this._hierarchyLevel > 0;
	};

	/**
	 * Gets the Level in the hierarchy
	 * @public
	 * @memberOf TreeNode
	 * @return {number}
	 */
	TreeNode.prototype.getHierarchyLevel = function getHierarchyLevel() {
	    return this._hierarchyLevel;
	};

	/**
	 * Gets the Id of the dimension this node represents
	 * @public
	 * @memberOf TreeNode
	 * @return {number}
	 */
	TreeNode.prototype.getDimensionId = function getDimensionId() {
	    return this._dimensionId;
	};

	/**
	 * Indicates if this node is an imaginary/dummy node because a level/dimension has been skipped
	 * @public
	 * @memberOf TreeNode
	 * @return {boolean}
	 */
	TreeNode.prototype.isImaginary = function () {
	    return this.nodeId === -1;
	};

	/**
	 * Indicates if this node has an imaginary childNode
	 * @public
	 * @return {boolean}
	 */
	TreeNode.prototype.hasImaginaryChild = function () {
	    return -1 in this._children;
	};

	/**
	 * Gets the Label of the current node
	 * @public
	 * @memberOf TreeNode
	 * @return {string}
	 */
	TreeNode.prototype.getLabel = function getLabel() {
	    // FixMe: Remove this!
	    if (this.isRoot()) {
	        return "Root";
	    }

	    var dimensionName = meta.axis.y[this._dimensionId];
	    var label = "missing Information";

	    if (dimensionName !== "measures") {
	        var dimensionInformation = dataMeta.getDimensionByName(dimensionName);

	        for (var hierarchyLevelIndex = 0; hierarchyLevelIndex < this._hierarchyLevel; hierarchyLevelIndex++) {
	            // go up the hierarchy if necessary
	            dimensionInformation = dimensionInformation.hierarchy;
	        }

	        var lookUps = dimensionInformation.lookups;
	        label = lookUps[this.nodeId];
	    } else {
	        label = meta.measures[this.nodeId].name;
	    }

	    return label;
	};

	/**
	 * Gets the level of this node within the Tree
	 * @public
	 * @memberOf TreeNode
	 * @return {number}
	 */
	TreeNode.prototype.getLevel = function () {
	    return this.nodeLevel;
	};

	/**
	 * Gets all labels for the current node (row in the grid)
	 * @public
	 * @memberOf TreeNode
	 * @returns {string[]}
	 */
	TreeNode.prototype.getLabels = function () {
	    var labels = [];

	    var node = this;
	    while (!node.isRoot()) {
	        labels.unshift(node.getLabel());
	        node = node.parentNode;
	    }

	    return labels;
	};

	/**
	 * Gets all ChildRows (recursively!)
	 * @private
	 * @memberOf TreeNode
	 * @returns {number[][]}
	 */
	TreeNode.prototype.getChildRows = function () {
	    var childRows = [];

	    if (this.childAreLeafs) {
	        childRows = this._children.map(function (row) {
	            return row.calculate();
	        });

	        if (this.hasImaginaryChild()) {
	            childRows.push(this._children[-1].calculate());
	        }
	    } else {
	        childRows = this._children.map(function (child) {
	            return child.aggregate();
	        });

	        if (this.hasImaginaryChild()) {
	            childRows.push(this._children[-1].aggregate());
	        }
	    }
	    return childRows;
	};

	/**
	 * Indicates if the given column is editable
	 * @param {number} columnIndex id of the column
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.isEditable = function (columnIndex) {
	    var isEditable = false;

	    var measureDefinition = this.getMeasureDefinition();

	    if (measureDefinition) {

	        if (measureDefinition.isEditable) {
	            if (columnIndex > 0) {
	                if (columnIndex < dataMeta.noOfDataColumns) {
	                    isEditable = true;
	                } else {
	                    log.warn("Out of upper bounds!");
	                }
	            } else if (columnIndex === 0) {
	                isEditable = true;
	            } else {
	                log.warn("Out of lower bounds!");
	            }
	        }
	    } else {
	        log.warn("Cannot edit above KPI-Level!");
	    }

	    return isEditable;
	};

	/**
	 * Indicates if the given column is editable and if it is allowed
	 *
	 * Additionally checks if the cell is editable in the past or not.
	 * @param {number} columnIndex id of the column
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.isEditAllowed = function (columnIndex) {
	    var isEditAllowed = false;
	    var isEditableColumn = this.isEditable(columnIndex);

	    if (isEditableColumn) {
	        var measureDefinition = this.getMeasureDefinition();

	        if (measureDefinition.distributionInformation.mode === "week") {
	            // Edits in edit-mode week are only allowed in weekly columns, not in the total column.
	            if (columnIndex > 0) {
	                if (measureDefinition.distributionInformation.enablePastWeeks) {
	                    isEditAllowed = true;
	                } else {
	                    isEditAllowed = dataMeta.currentWeekIndex <= columnIndex;
	                }
	            }
	        } else {
	            // Edits in edit-mode total are only allowed in the total column.
	            isEditAllowed = columnIndex === 0;
	        }
	    }

	    return isEditAllowed;
	};

	/**
	 * Gets the current position in the tree.
	 * Can be used to identify the GroupingNames
	 * @example root = [], root.child[3].child[5] = [3,5]...
	 * @public
	 * @memberOf TreeNode
	 * @returns {number[]}
	 */
	TreeNode.prototype.getPositionInTree = function () {
	    var position = [];
	    if (!this.isRoot()) {
	        position = this.parentNode.getPositionInTree();
	        position.push(this.nodeId);
	    }

	    return position;
	};

	/**
	 * Adds a childNode to the current Node
	 * Uses the nodeId (not the global unique!) as index
	 * @public
	 * @memberOf TreeNode
	 * @param {TreeNode} child Node to be added as child to the current Node
	 * @param {number} child.nodeId Id of the node (IndexReference in the dataTable
	 */
	TreeNode.prototype.addChild = function (child) {
	    this._children[child.nodeId] = child;
	};

	/**
	 * Gets a childNode based on its relative Id
	 *
	 * To use the globalId use Tree.getChild(id)
	 * @public
	 * @memberOf TreeNode
	 * @see Tree.getChild(id) Use Tree.getChild(id)
	 * @param {number} nodeId
	 * @returns {TreeNode|undefined}
	 */
	TreeNode.prototype.getChildNode = function (nodeId) {
	    return this._children[nodeId];
	};

	/**
	 * Indicates if this object has child objects or not (includes Imaginary children)
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.hasChildren = function () {
	    return this._children.length > 0 || this.hasImaginaryChild();
	};

	/**
	 * Gets all children of this TreeNode
	 * @public
	 * @memberOf TreeNode
	 * @return {TreeNode[]}
	 */
	TreeNode.prototype.getChildren = function () {
	    var children;

	    if (this.hasImaginaryChild() && this._children.length > 0) {
	        log.error("Not Implemented: Imaginary and non-Imaginary Children found!");
	        children = [];
	    } else if (this.hasImaginaryChild()) {
	        log.debug("getChildren: Skipping Imaginary Child.");
	        children = this._children[-1].getChildren();
	    } else {
	        children = this._children;
	    }

	    return children;
	};

	/**
	 * Indicates if the Children of this node should be shown in the UI
	 * @public
	 * @memberOf TreeNode
	 * @return {boolean}
	 */
	TreeNode.prototype.showChildren = function () {
	    return !this.isLeaf();
	};

	/**
	 * Gets the number of digits for correct rounding in the UI
	 * @public
	 * @memberOf TreeNode
	 * @returns {number} The number of digits if specified else 2 digits as fallback
	 */
	TreeNode.prototype.getRounding = function () {
	    var roundingDigits = 2;
	    var measureDefinition = this.getMeasureDefinition();

	    if (measureDefinition !== null) {
	        roundingDigits = measureDefinition.display.round;
	    }

	    return roundingDigits;
	};

	/**
	 * Sets the data for the specified column
	 * Assumes that the totalColumn is at index 0!
	 *
	 * @memberOf TreeNode
	 * @param {number} index Position in the Data
	 * @param {number|null} value Value to be set
	 * @throws {Error} Throws an error if the index is out of bounds.
	 * @throws {Error} Throws an error if initData(size) is not called before setting the data.
	 */
	TreeNode.prototype.setData = function (index, value) {
	    if (index >= 0 && index <= dataMeta.noOfDataColumns) {
	        this._data[index] = value;
	    } else if (index < 0) {
	        throw new CasException.CasException("Out of Lower-Bounds!");
	    } else {
	        throw new CasException.CasException("Out of Upper-Bounds!");
	    }
	};

	/**
	 * Sets the raw Data
	 * @memberOf TreeNode
	 * @param {(number|null)[]} rawData
	 */
	TreeNode.prototype.setRawData = function setRawData(rawData) {
	    if (rawData === undefined) {
	        log.warn("inserting undefined data");
	    }

	    if (this.isLeaf()) {
	        rawData.unshift(null); // add total column
	        this._data = rawData;
	    } else {
	        throw new CasException.CasException("Not implemented: Cannot set data on a none-leaf TreeNode!");
	    }
	};

	/**
	 * Gets the raw Data of a leaf
	 *
	 * Should only be called on Leaf-Level!
	 * Should not be called on calculated nodes!
	 * @memberOf TreeNode
	 * @returns (number[])
	 */
	TreeNode.prototype.getRawData = function () {
	    //benchmark.startMeasurement('getRawData');
	    log.trace("getRawData() - Start");
	    var computedRowData;

	    if (this.isLeaf()) {
	        computedRowData = this._data;
	    } else {
	        log.warn("getRawData() - Unexpected Call on level: " + this.nodeType.toString() + " in KPI: " + this.getMeasureDefinition().name);
	        computedRowData = createAndFillArray(dataMeta.noOfDataColumns, null);
	    }

	    log.trace("getRawData() - End");
	    //benchmark.endMeasurement('getRawData');
	    return computedRowData;
	};

	/**
	 * Gets the MeasureDefinition of this Node
	 * Returns null if the measure is below the current level
	 * @public
	 * @memberOf TreeNode
	 * @returns {Object|null}
	 */
	TreeNode.prototype.getMeasureDefinition = function () {
	    return this._measureDefinition;
	};

	/**
	 * Gets all (calculated) rows which are referenced by the current Node on the current level
	 * @private
	 * @memberOf TreeNode
	 * @param {Object} measureDefinition
	 * @return {number[][]}
	 */
	TreeNode.prototype.getReferencedRowsForCalculation = function (measureDefinition) {
	    var posInTree = this.getPositionInTree();
	    var measureLevel = meta.getLevelOfMeasures();

	    // get all referenced Rows
	    var argRowList = [];
	    for (var i = 0; i < measureDefinition.args.length; i++) {
	        var functionArgument = measureDefinition.args[i];
	        // Copy the nodePosition as it could be truncated later on for KPIs on a higher level
	        var nodePosition = posInTree.slice();
	        nodePosition[measureLevel] = functionArgument.measureIndex;

	        if (functionArgument.isComplexArgument) {
	            // manipulate the nodePosition the get values on a higher level if needed
	            //nodePosition = nodePosition.slice(0, functionArgument.levelIndex + 1);
	            var levelIndex = dataMeta.getLevelIndex(functionArgument.levelName);
	            nodePosition = nodePosition.slice(0, levelIndex + 1);
	        }

	        var node = this.getNode(nodePosition);

	        if (node !== undefined) {
	            var data = node.getData();

	            if (functionArgument.isComplexArgument && functionArgument.useTotal) {
	                // Use the TotalValue for all weeks
	                data = createAndFillArray(dataMeta.noOfDataColumns, data[0]);
	            }

	            argRowList[i] = data;
	        } else {
	            // Use a fallback as no node could be found
	            argRowList[i] = createAndFillArray(dataMeta.noOfDataColumns, null);
	        }
	    }
	    return argRowList;
	};

	/**
	 * Executes the specified calculation formula
	 * @private
	 * @memberOf TreeNode
	 * @param {Object} measureDefinition
	 * @param {number[][]} argRowList
	 * @return {number[]}
	 */
	TreeNode.prototype.executeCalculationFormula = function (measureDefinition, argRowList) {
	    var resultRow = [];
	    var funcArguments = [];

	    calculationHelper.setNode(this);

	    var startIndex = 1;
	    var weekIterator;
	    if (measureDefinition.isTotalCalculationBasedOnFormula()) {
	        // calculate the total the same way as the weekly values
	        startIndex = 0;
	    }

	    var numberOfArguments = measureDefinition.args.length;
	    benchmark.startMeasurement('executeCalculation.' + measureDefinition.name);

	    switch (numberOfArguments) {
	        case 0:
	            benchmark.startMeasurement('executeCalculationWith0Arguments');
	            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
	                calculationHelper.setWeekIndex(weekIterator);
	                resultRow[weekIterator] = measureDefinition.func(calculationHelper);
	            }
	            benchmark.endMeasurement('executeCalculationWith0Arguments');
	            break;

	        case 1:
	            benchmark.startMeasurement('executeCalculationWith1Arguments');
	            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
	                calculationHelper.setWeekIndex(weekIterator);
	                resultRow[weekIterator] = measureDefinition.func(calculationHelper, undefinedToNull(argRowList[0][weekIterator]));
	            }
	            benchmark.endMeasurement('executeCalculationWith1Arguments');
	            break;

	        case 2:
	            benchmark.startMeasurement('executeCalculationWith2Arguments');
	            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
	                calculationHelper.setWeekIndex(weekIterator);
	                resultRow[weekIterator] = measureDefinition.func(calculationHelper, undefinedToNull(argRowList[0][weekIterator]), undefinedToNull(argRowList[1][weekIterator]));
	            }
	            benchmark.endMeasurement('executeCalculationWith2Arguments');
	            break;

	        case 3:
	            benchmark.startMeasurement('executeCalculationWith3Arguments');
	            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
	                calculationHelper.setWeekIndex(weekIterator);
	                resultRow[weekIterator] = measureDefinition.func(calculationHelper, undefinedToNull(argRowList[0][weekIterator]), undefinedToNull(argRowList[1][weekIterator]), undefinedToNull(argRowList[2][weekIterator]));
	            }
	            benchmark.endMeasurement('executeCalculationWith3Arguments');
	            break;

	        default:
	            funcArguments.push(calculationHelper);
	            for (weekIterator = startIndex; weekIterator < dataMeta.noOfDataColumns; weekIterator++) {
	                calculationHelper.setWeekIndex(weekIterator);
	                for (var j = 0; j < numberOfArguments; j++) {
	                    funcArguments[j + 1] = undefinedToNull(argRowList[j][weekIterator]);
	                }
	                benchmark.startMeasurement('applyFunction.' + measureDefinition.name);
	                resultRow[weekIterator] = measureDefinition.func.apply(this, funcArguments);

	                benchmark.endMeasurement('applyFunction.' + measureDefinition.name);
	            }
	    }

	    benchmark.endMeasurement('executeCalculation.' + measureDefinition.name);

	    return resultRow;
	};

	/**
	 * Converts a value to null if it is undefined
	 * @param value
	 * @returns {*}
	 */
	function undefinedToNull(value) {
	    if (value === undefined) {
	        return null;
	    } else {
	        return value;
	    }
	}

	/**
	 * Create an array and fills it with the specified value
	 * @param {number} size
	 * @param {number|null} value
	 * @returns {Array}
	 */
	function createAndFillArray(size, value) {
	    var result = new Array(size);
	    _.fill(result, value);
	    return result;
	}

	/**
	 * Gets the values of the row and calculates computed fields if necessary
	 * If this method is called on a non-leaf node, the result will be undefined
	 * @private
	 * @memberOf TreeNode
	 */
	TreeNode.prototype.calculate = function () {
	    log.debug("calculate() - Start");
	    var row;

	    var measureDefinition = this.getMeasureDefinition();

	    if (!this.isDirty()) {
	        benchmark.startMeasurement('calculate.' + measureDefinition.name + '.Cached');
	        row = this._data;
	        benchmark.endMeasurement('calculate.' + measureDefinition.name + '.Cached');
	    } else {
	        benchmark.startMeasurement('calculate.' + measureDefinition.name + '.NotCached');

	        if (measureDefinition && measureDefinition.computed) {
	            // Calculates the current row if it depends on other measures.
	            var argRowList = this.getReferencedRowsForCalculation(measureDefinition);
	            row = this.executeCalculationFormula(measureDefinition, argRowList);
	        } else {
	            // Gets the basic data in the row without any calculation
	            row = this.getRawData();
	        }

	        calculateTotal(row, measureDefinition);

	        this._data = row;
	        this.setDirty(false);
	        benchmark.endMeasurement('calculate.' + measureDefinition.name + '.NotCached');
	    }

	    log.debug("calculate() - End");
	    return row;
	};

	/**
	 * Sets the node to dirty dependent on the flag
	 * @private
	 * @memberOf TreeNode
	 * @param {Boolean} flag
	 */
	TreeNode.prototype.setDirty = function (flag) {
	    this._dirty = flag;
	};

	/**
	 * Aggregates all rows below to a single row based on the measureDefinition
	 * @private
	 * @memberOf TreeNode
	 * @returns {number[]}
	 */
	TreeNode.prototype.aggregate = function () {
	    var measureDefinition = this.getMeasureDefinition();

	    var noColumns = dataMeta.noOfDataColumns;
	    var aggregationResult;

	    if (!this._dirty) {
	        aggregationResult = this._data;
	    } else {
	        if (measureDefinition === null) {
	            // if measures is not on top level it could be below
	            // Example: Tactic,measures,PrdGroup,Prd => Aggregating the measures up to TacticLevel does not make any sense!
	            aggregationResult = createAndFillArray(noColumns, null);
	        } else {
	            if (measureDefinition.isAggregationBasedOnFormula()) {
	                benchmark.startMeasurement("aggregate.BasedOnFormula");
	                aggregationResult = this.calculate();
	                benchmark.endMeasurement("aggregate.BasedOnFormula");
	            } else {
	                benchmark.startMeasurement("aggregate.GetChildRows");
	                var childRows = this.getChildRows();
	                benchmark.endMeasurement("aggregate.GetChildRows");

	                benchmark.startMeasurement("aggregate.Standard");
	                aggregationResult = [];
	                // Aggregate up to the current level
	                // Iterate of each column of the 2-dim-Array
	                for (var columnIndex = 0; columnIndex < noColumns; columnIndex++) {
	                    var calcRow = getColumnInRows(childRows, columnIndex);

	                    // Aggregate the column
	                    if (calcRow.length > 0) {
	                        aggregationResult[columnIndex] = calcRow.reduce(measureDefinition.aggregation);
	                    } else {
	                        aggregationResult[columnIndex] = null;
	                    }
	                }
	                calculateTotal(aggregationResult, measureDefinition);
	                benchmark.endMeasurement("aggregate.Standard");
	            }
	        }

	        this._data = aggregationResult;
	        this.setDirty(false);
	    }

	    return aggregationResult;
	};

	/**
	 * Gets the data of a row
	 * @public
	 * @memberOf TreeNode
	 * @throws CasException If the function is called on another level than Leaf or GroupingLevel
	 * @return {number[]}
	 */
	TreeNode.prototype.getData = function () {
	    var result;

	    if (this.isRoot()) {
	        throw new CasException("Invalid Operations. Use Tree.getHeader() to get the header");
	    } else if (this.isLeaf()) {
	        result = this.calculate();
	    } else if (this.isGrouping()) {
	        result = this.aggregate();
	    } else {
	        throw new CasException("Invalid NodeType: '" + this.nodeType + "'");
	    }

	    return result;
	};

	/**
	 * Sets this node and all of its children to dirty to trigger a recalculation
	 * @private
	 * @memberOf TreeNode
	 */
	TreeNode.prototype.setChildrenDirty = function () {
	    this.setDirty(true);
	    for (var i = -1; i < this._children.length; i++) {
	        var child = this._children[i];

	        if (child !== undefined) {
	            child.setChildrenDirty();
	        }
	    }
	};

	/**
	 * Sets all parents (ancestors) dirty to trigger a recalculation
	 */
	TreeNode.prototype.setParentsDirty = function () {
	    var parent = this.parentNode;

	    if (!parent.isRoot()) {
	        parent.setDirty(true);
	        parent.setParentsDirty();
	    }
	};

	/**
	 * Gets a Node in the Tree via its relative Ids
	 * @public
	 * @memberOf TreeNode
	 * @param {number[]} positionInTree
	 * @returns {TreeNode|undefined}
	 */
	TreeNode.prototype.getNode = function (positionInTree) {
	    var currentNode = this.isRoot() ? this : this.rootNode;

	    for (var i = 0; i < positionInTree.length; i++) {
	        if (currentNode !== null && currentNode !== undefined) {
	            if (currentNode.hasImaginaryChild()) {
	                currentNode = currentNode.getChildNode(-1);
	            } else {
	                currentNode = currentNode.getChildNode(positionInTree[i]);
	            }
	        }
	    }

	    return currentNode;
	};

	/**
	 * Gets all leaf nodes below this node
	 * @memberOf TreeNode
	 * @returns {TreeNode[]}
	 */
	TreeNode.prototype.getLeafs = function () {
	    log.debug("getLeafs() - Start");
	    var leafs = [];

	    if (this.isLeaf()) {
	        leafs.push(this);
	    } else if (this.childAreLeafs) {
	        leafs = leafs.concat(this._children);
	    } else {
	        for (var i = -1; i < this._children.length; i++) {
	            var leaf = this._children[i];

	            if (leaf !== undefined) {
	                leafs = leafs.concat(leaf.getLeafs());
	            }
	        }
	    }

	    log.debug("getLeafs() - End");
	    return leafs;
	};

	/**
	 * Indicates if this node should be displayed.
	 * Mainly this depends on the measure.
	 * @public
	 * @memberOf TreeNode
	 * @returns {boolean}
	 */
	TreeNode.prototype.showInUI = function () {
	    var showInUI = true;
	    var measureDefinition = this.getMeasureDefinition();

	    if (measureDefinition !== null) {
	        showInUI = measureDefinition.display.enabled;
	    }

	    return showInUI;
	};

	/**
	 * Sets all dependent Nodes to dirty to trigger a recalculation
	 * @private
	 * @memberOf TreeNode
	 */
	TreeNode.prototype.setDependingNodesDirty = function () {

	    // set this node and all siblings and children to dirty
	    if (!this.isDirty()) {
	        this.setChildrenDirty();
	        this.setParentsDirty();

	        var positionInTree = this.getPositionInTree();
	        var levelOfMeasures = meta.getLevelOfMeasures();

	        var measurePositionInTree = positionInTree.slice(0, levelOfMeasures + 1);
	        var measureDefinition = this.getMeasureDefinition();

	        for (var i = 0; i < measureDefinition.dependingMeasures.length; i++) {
	            if (measureDefinition.dependingMeasures[i] !== undefined) {
	                var dependentMeasure = measureDefinition.dependingMeasures[i];

	                measurePositionInTree[levelOfMeasures] = dependentMeasure.id;

	                var dependentNode = this.getNode(measurePositionInTree);
	                dependentNode.setDependingNodesDirty();
	            }
	        }
	    }
	};

	/**
	 * Adds a manual change to the history
	 *
	 * Clears all changes below the current level
	 * @private
	 * @memberOf TreeNode
	 * @param {number} index
	 * @param {number|null} value
	 */
	TreeNode.prototype.addManualChange = function (index, value) {
	    this._manualChanges[index] = value;

	    if (index === 0) {
	        for (var columnIndex = 0; columnIndex < dataMeta.noOfDataColumns; columnIndex++) {
	            this.clearDescendantChanges(columnIndex);
	        }
	    } else {
	        this.clearDescendantChanges(index);
	    }
	};

	/**
	 * Gets all manual changes (recursively).
	 * @public
	 * @memberOf TreeNode
	 * @param {Object} parentIdentifiers
	 * @return {Array}
	 */
	TreeNode.prototype.getManualChanges = function (parentIdentifiers) {
	    var manualChanges = [];
	    var measureDefinition = this.getMeasureDefinition();
	    var identifiers = _.clone(parentIdentifiers, false);

	    if (measureDefinition === null || measureDefinition.isEditable) {
	        if (!this.isRoot()) {
	            var dimensionName = meta.axis.y[this._dimensionId];
	            var currentLabel = this.getLabel();

	            identifiers[dimensionName] = currentLabel;

	            for (var dataIndex = 0; dataIndex < this._manualChanges.length; dataIndex++) {
	                var value = this._manualChanges[dataIndex];

	                if (value !== undefined) {

	                    var manualChange = { dimensions: _.clone(identifiers, false), value: value };
	                    manualChange.dimensions[meta.axis.x] = dataIndex; // FixMe

	                    manualChanges.push(manualChange);
	                }
	            }
	        }

	        for (var childIndex = -1; childIndex < this._children.length; childIndex++) {
	            var childNode = this._children[childIndex];

	            if (childNode !== undefined) {
	                manualChanges = manualChanges.concat(childNode.getManualChanges(identifiers));
	            }
	        }
	    }

	    return manualChanges;
	};

	/**
	 * Clears the manual changes of all descendants (recursively).
	 * @private
	 * @memberOf TreeNode
	 * @param {number} index Index where the clearing of the change shall happen.
	 */
	TreeNode.prototype.clearDescendantChanges = function (index) {
	    if (this.hasChildren()) {
	        for (var childIndex = -1; childIndex < this._children.length; childIndex++) {
	            var childNode = this._children[childIndex];

	            if (childNode !== undefined) {
	                childNode.clearManualChange(index);
	                childNode.clearDescendantChanges(index);
	            }
	        }
	    }
	};

	/**
	 * Clears a single manual change
	 * @private
	 * @memberOf TreeNode
	 * @param {number} index Index where the clearing of the change shall happen.
	 */
	TreeNode.prototype.clearManualChange = function (index) {
	    delete this._manualChanges[index];
	};

	/**
	 * Indicates if this node has any manual changes
	 * @memberOf TreeNode
	 * @return {boolean}
	 */
	TreeNode.prototype.hasManualChanges = function () {
	    return this._manualChanges.length > 0;
	};

	/**
	 * Sets the Logging-Object
	 * @param logger
	 */
	function setLogger(logger) {
	    log = logger.child({ widget_type: "TreeNode" });
	}

	/**
	 * Sets the CalculationHelper Object
	 * @param {CalcHelper} calcHelper
	 */
	function setCalcHelper(calcHelper) {
	    calculationHelper = calcHelper;
	}

	/**
	 * Sets the Meta-Information
	 * @param {Object} metaObject
	 */
	function setMeta(metaObject) {
	    meta = metaObject;
	}

	/**
	 * Sets the DataMeta-Information
	 * @param {Object} dataMetaObject
	 */
	function setDataMeta(dataMetaObject) {
	    dataMeta = dataMetaObject;
	}

	module.exports.TreeNode = TreeNode;
	module.exports._NodeTypes = _NodeTypes;
	module.exports.setLogger = setLogger;
	module.exports.setCalcHelper = setCalcHelper;
	module.exports.setMeta = setMeta;
	module.exports.setDataMeta = setDataMeta;

/***/ },

/***/ 273:
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	/* globals CasException */

	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

	var _ = __webpack_require__(202);
	var _logWidgetName = "ManualChangesSerializer";

	/**
	 *
	 * @param dataMeta
	 * @param {MeasureDefinitionCollection} meta
	 * @param logger
	 * @param {benchmark} benchmark
	 * @constructor
	 */
	var ManualChangesSerializer = function ManualChangesSerializer(dataMeta, meta, logger, benchmark) {
	    if (logger === undefined) {
	        var bunyan = __webpack_require__(203);
	        logger = bunyan.createLogger();
	    }

	    /**
	     * @type {XMLList}
	     */
	    this.log = logger.child({ widget_type: _logWidgetName });

	    if (benchmark === undefined) {
	        benchmark = __webpack_require__(267);
	        benchmark.enable(false);
	    }

	    /**
	     * @type {benchmark}
	     */
	    this.benchmark = benchmark;

	    this.getDataMeta = function () {
	        return dataMeta;
	    };

	    /**
	     * Gets the MetaInformation
	     * @return {MeasureDefinitionCollection}
	     */
	    this.getMeta = function () {
	        return meta;
	    };
	};

	/**
	 * Serializes the manual changes into a minimized storable format
	 * @param {Object[]} manualChanges
	 * @return {{dimensions: *[], data: *[]}}
	 */
	ManualChangesSerializer.prototype.serialize = function (manualChanges) {
	    this.benchmark.startMeasurement("serialize");

	    var result = compressManualChanges(manualChanges, this.getDataMeta(), this.getMeta());

	    this.benchmark.startMeasurement("serialize");

	    return result;
	};

	/**
	 * Deserializes the minimized format of the manual changes for applying them in the tree
	 * @param manualChanges
	 * @return {{dimensions: Object[], data: Array}}
	 */
	ManualChangesSerializer.prototype.deserialize = function (manualChanges) {
	    this.benchmark.startMeasurement("serialize");

	    var deserializedDimension = translateDimensions(manualChanges.dimensions, this.getDataMeta(), this.getMeta(), this.log, this.benchmark);

	    var translatedData = translateData(deserializedDimension, manualChanges.data, this.getDataMeta(), this.getMeta(), this.log, this.benchmark);

	    this.benchmark.endMeasurement("serialize");

	    return translatedData;
	};

	/**
	 * Indicates if the given manualChanges Object could be valid
	 * @param {Object} manualChanges
	 * @return {boolean}
	 */
	ManualChangesSerializer.prototype.isValid = function (manualChanges) {
	    this.benchmark.startMeasurement("isValid");

	    var isObject = false;
	    var hasArrayData = false;
	    var hasArrayDimensions = false;

	    if (manualChanges !== undefined && manualChanges !== null && manualChanges !== "") {
	        if ((typeof manualChanges === "undefined" ? "undefined" : _typeof(manualChanges)) === 'object') {
	            isObject = true;
	        }
	    }

	    if (isObject && "dimensions" in manualChanges) {
	        hasArrayDimensions = Array.isArray(manualChanges.dimensions);
	    }

	    if (isObject && "data" in manualChanges) {
	        hasArrayData = Array.isArray(manualChanges.data);
	    }

	    this.benchmark.endMeasurement("isValid");

	    return isObject && hasArrayData && hasArrayDimensions;
	};

	var translateData = function translateData(dimensions, data, dataMeta, meta, log, benchmark) {
	    benchmark.startMeasurement("translateData");

	    var translatedData = [];

	    for (var dataIndex = 0; dataIndex < data.length; dataIndex++) {
	        var manualChange = { path: [], columnIndex: -1, value: undefined };
	        var rawPath = data[dataIndex][0];
	        var value = data[dataIndex][1];
	        var errorOccurred = false;

	        for (var dimensionIndex = 0; dimensionIndex < rawPath.length; dimensionIndex++) {
	            var oldValue = rawPath[dimensionIndex];
	            var dimension = dimensions[dimensionIndex];
	            var translatedValue;
	            if (oldValue > -1) {
	                translatedValue = dimension.translatedValues[oldValue];
	            } else {
	                translatedValue = -1;
	            }

	            if (translatedValue !== undefined) {
	                if (dimension.axis === "x") {
	                    if (translatedValue.length == 1) {
	                        manualChange.columnIndex = translatedValue[0] + 1;
	                    } else {
	                        errorOccurred = true;
	                        log.error("Not implemented: The values on the x-axis cannot be hierarchical!");
	                    }
	                } else {
	                    manualChange.path = manualChange.path.concat(translatedValue);
	                }
	            } else {
	                errorOccurred = true;
	                log.debug("Could not find value for manual change with index " + dataIndex + " for dimension " + dimension.name + ". Ignoring this change!");
	            }
	        }

	        manualChange.value = value;

	        if (!errorOccurred) {
	            translatedData.push(manualChange);
	        }
	    }

	    benchmark.endMeasurement("translateData");

	    return translatedData;
	};

	/**
	 *
	 * @param {Object[]} dimensions
	 * @param {String} dimensions[].name
	 * @param {String} dimensions[].type
	 * @param {Object} dataMeta
	 * @param {MeasureDefinitionCollection} meta
	 * @param log
	 * @param benchmark
	 */
	var translateDimensions = function translateDimensions(dimensions, dataMeta, meta, log, benchmark) {
	    var result = [];

	    for (var dimensionIndex = 0; dimensionIndex < dimensions.length; dimensionIndex++) {
	        var translatedDimension;
	        var dimension = dimensions[dimensionIndex];

	        switch (dimension.type) {
	            case "measure":
	                translatedDimension = translateMeasureDimension(dimension, dimensionIndex, dataMeta, meta, log, benchmark);
	                break;
	            case "time":
	                translatedDimension = translateTimeDimension(dimension, dimensionIndex, dataMeta, meta, log, benchmark);
	                break;
	            case "regular":
	                translatedDimension = translateRegularDimension(dimension, dimensionIndex, dataMeta, meta, log, benchmark);
	                break;
	            default:
	                throw new CasException("Unknown dimension-type: " + dimension.type);
	        }

	        result[dimensionIndex] = translatedDimension;
	    }
	    //var dimension = {name: "", originalValues: [], translatedValues: []};
	    // 1) refactor dimensions
	    // 1.1 keep original values for backtracking/logging


	    return result;
	};

	/**
	 *
	 * @param {Object} oldDimension
	 * @param {String} oldDimension.name
	 * @param {String} oldDimension.type
	 * @param {Object[]} oldDimension.details
	 * @param {number} oldDimension.details.calendaryear
	 * @param {number} oldDimension.details.week
	 * @param {number} oldDimensionIndex
	 * @param dataMeta
	 * @param {MeasureDefinitionCollection} meta
	 * @param log
	 * @param benchmark
	 * @return {{name: String, type: String, originalValues: Object[], originalIndex: number, translatedValues: number[], translatedIndex: number}}
	 */
	var translateTimeDimension = function translateTimeDimension(oldDimension, oldDimensionIndex, dataMeta, meta, log, benchmark) {
	    benchmark.startMeasurement("translateTimeDimension");
	    var translatedDimension = {
	        name: oldDimension.name,
	        type: oldDimension.type,
	        originalValues: oldDimension.details,
	        originalIndex: oldDimensionIndex,
	        translatedValues: [],
	        translatedIndex: -1,
	        axis: "",
	        axisIndex: -1
	    };

	    /**
	     * Transforms a timeDetailObject to a string-comparable-value
	     * @param {Object} timeDetail
	     * @param {number} timeDetail.calendaryear
	     * @param {number} timeDetail.week
	     * @return {string}
	     */
	    var timeDetailsToString = function timeDetailsToString(timeDetail) {
	        return timeDetail.calendaryear + " - " + timeDetail.week;
	    };

	    var currentTimeDimensionIndex = _.findIndex(dataMeta.dimensions, { "name": oldDimension.name, "type": "time" });
	    if (currentTimeDimensionIndex > -1) {
	        var currentTimeDimension = dataMeta.dimensions[currentTimeDimensionIndex];

	        translatedDimension.translatedIndex = currentTimeDimensionIndex;

	        var translatedValueKeys = toValueKeyCollection(currentTimeDimension.details, timeDetailsToString);

	        var translatedValues = [];
	        for (var oldDetailsIndex = 0; oldDetailsIndex < oldDimension.details.length; oldDetailsIndex++) {
	            var oldTimeDetails = oldDimension.details[oldDetailsIndex];
	            if (oldTimeDetails === -1) {
	                translatedValues[oldDetailsIndex] = [-1]; // TOTAL value
	            } else {
	                var comparableString = timeDetailsToString(oldTimeDetails);
	                var currentIndex = translatedValueKeys[comparableString];

	                if (currentIndex !== undefined) {
	                    translatedValues[oldDetailsIndex] = [currentIndex];
	                } else {
	                    log.info("The entry '" + comparableString + "' in dimension '" + oldDimension.name + "' is no longer valid and will be ignored.");
	                }
	            }
	        }

	        translatedDimension.translatedValues = translatedValues;
	        translatedDimension.axis = getAxisOfDimension(oldDimension.name, meta, log, benchmark);
	    } else {
	        throw new CasException("Could not find the oldDimension with the name " + oldDimension.name + " of type 'time'");
	    }

	    //  1b) time => match week + year -> to new []internalNodeId (remember totalValue +1), if not present null) -> timeframe no longer valid -> will be ignoring these changes

	    benchmark.endMeasurement("translateTimeDimension");

	    return translatedDimension;
	};

	/**
	 *
	 * @param dimensionName
	 * @param meta
	 * @param log
	 * @param benchmark
	 * @return {string}
	 */
	var getAxisOfDimension = function getAxisOfDimension(dimensionName, meta, log, benchmark) {
	    benchmark.startMeasurement("getAxisOfDimension");

	    var axis = "";

	    if (meta.axis.x === dimensionName) {
	        axis = "x";
	    } else {
	        var dimensionIndex = _.findIndex(meta.axis.y, function (dimName) {
	            return dimensionName === dimName;
	        });

	        if (dimensionIndex > -1) {
	            axis = "y";
	        } else {
	            log.warn("The dimension with the name '" + dimensionName + "' is no longer used and will be ignored!");
	        }
	    }

	    benchmark.endMeasurement("getAxisOfDimension");

	    return axis;
	};

	/**
	 *
	 * @param {Object} oldDimension
	 * @param {String} oldDimension.name
	 * @param {String} oldDimension.type
	 * @param {String[]} oldDimension.lookups
	 * @param {number} dimensionIndex
	 * @param dataMeta
	 * @param {MeasureDefinitionCollection} meta
	 * @param log
	 * @param benchmark
	 * @return {{name: String, type: String, originalValues: String[], originalIndex: number, translatedValues: number[], translatedIndex: number}}
	 */
	var translateMeasureDimension = function translateMeasureDimension(oldDimension, dimensionIndex, dataMeta, meta, log, benchmark) {
	    benchmark.startMeasurement("translateMeasureDimension");
	    var translatedDimension = {
	        name: oldDimension.name,
	        type: oldDimension.type,
	        originalValues: oldDimension.lookups,
	        originalIndex: dimensionIndex,
	        translatedValues: [],
	        translatedIndex: -1,
	        axis: "",
	        axisIndex: -1
	    };

	    var currentMeasureDimensionIndex = _.findIndex(dataMeta.dimensions, { "type": "measure" });
	    if (currentMeasureDimensionIndex > -1) {
	        var currentMeasureDimension = dataMeta.dimensions[currentMeasureDimensionIndex];

	        translatedDimension.translatedIndex = currentMeasureDimensionIndex;

	        var translatedValueKeys = meta.editableCodeIndexMapping;

	        var translatedValues = [];
	        for (var oldLookUpIndex = 0; oldLookUpIndex < oldDimension.lookups.length; oldLookUpIndex++) {
	            var oldEditableCode = oldDimension.lookups[oldLookUpIndex];
	            var currentIndex = translatedValueKeys[oldEditableCode];

	            if (currentIndex !== undefined) {
	                translatedValues[oldLookUpIndex] = [currentIndex];
	            } else {
	                log.info("The measure with the editable code '" + oldEditableCode + "' in dimension '" + currentMeasureDimension.name + "' is no longer valid and will be ignored.");
	            }
	        }

	        translatedDimension.translatedValues = translatedValues;
	        translatedDimension.axis = getAxisOfDimension("measures", meta, log, benchmark);
	    } else {
	        throw new CasException("Could not find the the dimension of type 'measure'");
	    }

	    benchmark.endMeasurement("translateMeasureDimension");

	    return translatedDimension;
	};

	/**
	 * This callback type is called when a conversion of any type to a string should be done
	 *
	 * @callback toStringCallback
	 * @param {*} input
	 * @return {string}
	 */

	/**
	 *
	 * @param {Array} keyValueCollection
	 * @param {toStringCallback} [toString]
	 * @return {{}}
	 */
	var toValueKeyCollection = function toValueKeyCollection(keyValueCollection, toString) {
	    if (!isFunction(toString)) {
	        toString = defaultToStringFunction;
	    }

	    var result = {};

	    for (var index = 0; index < keyValueCollection.length; index++) {
	        result[toString(keyValueCollection[index])] = index;
	    }

	    return result;
	};

	/**
	 * Returns the same value as result
	 * @param {string} input
	 * @return {string}
	 */
	var defaultToStringFunction = function defaultToStringFunction(input) {
	    return input;
	};

	/**
	 * Checks if the given argument is a function.
	 * @function
	 * @private
	 */
	var isFunction = function isFunction(func) {
	    return typeof func === 'function';
	};

	/**
	 *
	 * @param {Object} oldDimension
	 * @param {String} oldDimension.name
	 * @param {String} oldDimension.type
	 * @param {String[]} oldDimension.lookups
	 * @param {number} dimensionIndex
	 * @param dataMeta
	 * @param {MeasureDefinitionCollection} meta
	 * @param log
	 * @param benchmark
	 * @return {{name: String, type: String, originalValues: String[], originalIndex: number, translatedValues: number[], translatedIndex: number}}
	 */
	var translateRegularDimension = function translateRegularDimension(oldDimension, dimensionIndex, dataMeta, meta, log, benchmark) {
	    benchmark.startMeasurement("translateRegularDimension");
	    var translatedDimension = {
	        name: oldDimension.name,
	        type: oldDimension.type,
	        originalValues: oldDimension.lookups,
	        originalIndex: dimensionIndex,
	        translatedValues: [],
	        translatedIndex: -1,
	        axis: "",
	        axisIndex: -1
	    };

	    var currentDimensionIndex = _.findIndex(dataMeta.dimensions, { "name": oldDimension.name, "type": "regular" });
	    if (currentDimensionIndex > -1) {
	        var currentDimension = dataMeta.dimensions[currentDimensionIndex];

	        translatedDimension.translatedIndex = currentDimensionIndex;

	        var translatedValueKeys = {};
	        resolveHierarchicalLookUps(translatedValueKeys, currentDimension);

	        var translatedValues = [];
	        for (var oldLookUpIndex = 0; oldLookUpIndex < oldDimension.lookups.length; oldLookUpIndex++) {
	            var compareString = oldDimension.lookups[oldLookUpIndex];
	            var currentPath = translatedValueKeys[compareString];

	            if (currentPath !== undefined) {
	                translatedValues[oldLookUpIndex] = currentPath;
	            } else {
	                log.info("The entry '" + compareString + "' in dimension '" + oldDimension.name + "' is no longer valid and will be ignored.");
	            }
	        }

	        translatedDimension.translatedValues = translatedValues;
	        translatedDimension.axis = getAxisOfDimension(oldDimension.name, meta, log, benchmark);
	    } else {
	        log.warn("Could not find the dimension with the name '" + oldDimension.name + "' of type 'regular'. This could lead to invalid results!");
	    }

	    //  1c) regular => match id with id -> to new []internalNodeId + hierarchy if necessary + -1 if currently is -1 (Tactic) -> no validation! + log info

	    benchmark.endMeasurement("translateRegularDimension");

	    return translatedDimension;
	};

	var resolveHierarchicalLookUps = function resolveHierarchicalLookUps(translatedValues, hierarchyInformation) {

	    var hasParentInHierarchy = hierarchyInformation.hierarchy !== undefined;
	    if (hasParentInHierarchy) {
	        resolveHierarchicalLookUps(translatedValues, hierarchyInformation.hierarchy);
	    }

	    for (var i = 0; i < hierarchyInformation.lookups.length; i++) {
	        var ownId = hierarchyInformation.lookups[i];

	        if (hasParentInHierarchy) {
	            var parentLookUpIndex = hierarchyInformation.hierarchy.mapping[i];
	            var parentLookUpValue = hierarchyInformation.hierarchy.lookups[parentLookUpIndex];
	            var parentPath = translatedValues[parentLookUpValue].slice();
	            parentPath.push(i);

	            translatedValues[ownId] = parentPath;
	        } else {
	            translatedValues[ownId] = [i];
	        }
	    }
	};

	/**
	 *
	 * @param {Object[]} manualChanges
	 * @param dataMeta
	 * @param meta
	 * @return {{dimensions: [], data: *[]}}
	 */
	var compressManualChanges = function compressManualChanges(manualChanges, dataMeta, meta) {
	    var compressedChanges = { dimensions: [], data: [] };

	    var dimensionNameLookupResolution = { dimensionCounter: 0, dimensions: {} };

	    for (var changeIndex = 0; changeIndex < manualChanges.length; changeIndex++) {
	        var manualChange = manualChanges[changeIndex];
	        var manualRecord = [[], manualChange.value];

	        for (var dimensionName in manualChange.dimensions) {
	            if (manualChange.dimensions.hasOwnProperty(dimensionName)) {
	                var dimensionValue = manualChange.dimensions[dimensionName];

	                manualRecord[0].push(resolveDimensionLookupIndex(dimensionNameLookupResolution, dimensionName, dimensionValue));
	            }
	        }

	        compressedChanges.data.push(manualRecord);
	    }

	    compressedChanges.dimensions = correctDimensionLookup(dimensionNameLookupResolution, dataMeta, meta);

	    return compressedChanges;
	};

	/**
	 * @param {Object} dimensionInformation
	 * @param {Number} dimensionInformation.dimensionCounter
	 * @param {Object} dimensionInformation.dimensions
	 * @param {string} dimensionName
	 * @param {string} itemName
	 */
	var resolveDimensionLookupIndex = function resolveDimensionLookupIndex(dimensionInformation, dimensionName, itemName) {
	    if (!(dimensionName in dimensionInformation.dimensions)) {
	        dimensionInformation.dimensions[dimensionName] = {
	            lookups: [],
	            resolution: {},
	            dimensionId: dimensionInformation.dimensionCounter++,
	            dimensionName: dimensionName
	        };
	    }

	    var dimensionInfo = dimensionInformation.dimensions[dimensionName];

	    if (!(itemName in dimensionInfo.resolution)) {
	        dimensionInfo.resolution[itemName] = dimensionInfo.lookups.length;
	        dimensionInfo.lookups.push(itemName);
	    }

	    return dimensionInfo.resolution[itemName];
	};

	/**
	 *
	 * @param {Object} dimensionInformation
	 * @param {Number} dimensionInformation.dimensionCounter
	 * @param {Object} dimensionInformation.dimensions
	 * @param dataMeta
	 * @param meta
	 * @return {Object[]}
	 */
	var correctDimensionLookup = function correctDimensionLookup(dimensionInformation, dataMeta, meta) {
	    var reducedDimensionInformation = [];

	    for (var dimensionName in dimensionInformation.dimensions) {
	        var dimensionObject = dimensionInformation.dimensions[dimensionName];
	        var correctedDimensionObject = dimensionObject;
	        var dimensionMeta;
	        if (dimensionName !== "measures") {
	            dimensionMeta = _.find(dataMeta.dimensions, { "name": dimensionName });
	        } else {
	            dimensionMeta = _.find(dataMeta.dimensions, { "type": "measure" });
	        }

	        if (dimensionMeta.type === "time") {
	            correctedDimensionObject = correctTimeDimensionInformation(dimensionObject, dimensionMeta, meta);
	        } else if (dimensionMeta.type === "measure") {
	            correctedDimensionObject = correctMeasureDimensionInformation(dimensionObject, dimensionMeta, meta);
	        } else if (dimensionMeta.type === "regular") {
	            correctedDimensionObject = correctRegularDimensionInformation(dimensionObject, dimensionMeta, meta);
	        } else {
	            throw new CasException("Unknown DimensionType: " + dimensionMeta.type);
	        }

	        reducedDimensionInformation[dimensionObject.dimensionId] = correctedDimensionObject;
	    }

	    return reducedDimensionInformation;
	};

	/**
	 *
	 * @param {Object} dimensionObject
	 * @param {String} dimensionObject.dimensionName
	 * @param {number} dimensionObject.dimensionId
	 * @param {Object} dimensionObject.resolution
	 * @param {String[]} dimensionObject.lookups
	 * @param dimensionMeta
	 * @param meta
	 * @return {{name: string, type: string, details: Array}}
	 */
	var correctTimeDimensionInformation = function correctTimeDimensionInformation(dimensionObject, dimensionMeta, meta) {
	    var correctedDimensionInformation = { name: dimensionMeta.name, type: "time", details: [] };

	    for (var lookUpIndex = 0; lookUpIndex < dimensionObject.lookups.length; lookUpIndex++) {
	        var weekIndex = dimensionObject.lookups[lookUpIndex] - 1; // total correction
	        if (weekIndex < 0) {
	            correctedDimensionInformation.details[lookUpIndex] = -1; // TOTAL VALUE!
	        } else {
	            correctedDimensionInformation.details[lookUpIndex] = dimensionMeta.details[weekIndex];
	        }
	    }

	    return correctedDimensionInformation;
	};

	/**
	 *
	 * @param {Object} dimensionObject
	 * @param {String} dimensionObject.dimensionName
	 * @param {number} dimensionObject.dimensionId
	 * @param {Object} dimensionObject.resolution
	 * @param {String[]} dimensionObject.lookups
	 * @param dimensionMeta
	 * @param meta
	 */
	var correctMeasureDimensionInformation = function correctMeasureDimensionInformation(dimensionObject, dimensionMeta, meta) {
	    var correctedDimensionInformation = { name: dimensionMeta.name, type: "measure", lookups: [] };

	    for (var measureIndex = 0; measureIndex < meta.measures.length; measureIndex++) {
	        var measureDefinition = meta.measures[measureIndex];
	        if (measureDefinition.name in dimensionObject.resolution) {
	            var lookupIndex = dimensionObject.resolution[measureDefinition.name];
	            correctedDimensionInformation.lookups[lookupIndex] = measureDefinition.distributionInformation.code;
	        }
	    }

	    return correctedDimensionInformation;
	};

	/**
	 *
	 * @param {Object} dimensionObject
	 * @param {String} dimensionObject.dimensionName
	 * @param {number} dimensionObject.dimensionId
	 * @param {Object} dimensionObject.resolution
	 * @param {String[]} dimensionObject.lookups
	 * @param dimensionMeta
	 * @param meta
	 * @return {{name: (string|*|String), type: string, lookups: *}}
	 */
	var correctRegularDimensionInformation = function correctRegularDimensionInformation(dimensionObject, dimensionMeta, meta) {
	    var correctedDimensionInformation = {
	        name: dimensionObject.dimensionName,
	        type: "regular",
	        lookups: dimensionObject.lookups
	    };

	    return correctedDimensionInformation;
	};

	module.exports.ManualChangesSerializer = ManualChangesSerializer;

/***/ },

/***/ 274:
/***/ function(module, exports) {

	"use strict";

	/**
	 *
	 * @constructor
	 * @public
	 */

	var CalculationVariableParser = function CalculationVariableParser() {};

	/**
	 *
	 * @type {null|Object}
	 * @memberOf CalculationVariableParser
	 * @private
	 */
	CalculationVariableParser.prototype._logger = null;

	/**
	 *
	 * @type {benchmark}
	 * @memberOf CalculationVariableParser
	 * @private
	 */
	CalculationVariableParser.prototype.benchmark = null;

	/**
	 *
	 * @type {null|Object}
	 * @memberOf CalculationVariableParser
	 * @private
	 */
	CalculationVariableParser.prototype.log = null;

	/**
	 *
	 * @param logger
	 * @memberOf CalculationVariableParser
	 * @public
	 */
	CalculationVariableParser.prototype.setLogger = function (logger) {
	    this._logger = logger;
	    this.log = logger.child({ widget_type: 'CalculationVariableParser' });
	};

	/**
	 *
	 * @param {benchmark} benchmark
	 * @memberOf CalculationVariableParser
	 * @public
	 */
	CalculationVariableParser.prototype.setBenchmark = function (benchmark) {
	    this.benchmark = benchmark;
	};

	/**
	 * Parses all variables
	 *
	 * @param {Object} calculationVariables
	 * @memberOf CalculationVariableParser
	 * @public
	 */
	CalculationVariableParser.prototype.parse = function (calculationVariables) {
	    this.benchmark.startMeasurement("CalculationVariableParser.parse()");

	    for (var dimensionName in calculationVariables) {
	        if (calculationVariables.hasOwnProperty(dimensionName)) {
	            var dimension = calculationVariables[dimensionName];

	            this.parseDimension(dimension);
	        }
	    }

	    this.benchmark.endMeasurement("CalculationVariableParser.parse()");
	};

	/**
	 * Parses each member of the given dimension
	 *
	 * @param {Object} dimension
	 * @memberOf CalculationVariableParser
	 * @private
	 */
	CalculationVariableParser.prototype.parseDimension = function (dimension) {
	    for (var dimensionMemberName in dimension) {
	        if (dimension.hasOwnProperty(dimensionMemberName)) {
	            var dimensionMember = dimension[dimensionMemberName];

	            this.parseDimensionItem(dimensionMember);
	        }
	    }
	};

	/**
	 * Parses each attribute of the given dimension member
	 *
	 * @param {Object} dimensionMember
	 * @memberOf CalculationVariableParser
	 * @private
	 */
	CalculationVariableParser.prototype.parseDimensionItem = function (dimensionMember) {
	    for (var attributeName in dimensionMember) {
	        if (dimensionMember.hasOwnProperty(attributeName)) {

	            if (typeof dimensionMember[attributeName] === "string") {
	                this.parseAttributeTypeString(dimensionMember, attributeName);
	            }
	        }
	    }
	};

	/**
	 * Parses an attribute of type String
	 *
	 * If the string starts with '{' and ends with '}', the value is assumed to be of type Object and will be parsed as such
	 *
	 * @param {Object} dimensionItem
	 * @param {String} attributeName
	 * @memberOf CalculationVariableParser
	 * @private
	 */
	CalculationVariableParser.prototype.parseAttributeTypeString = function (dimensionItem, attributeName) {
	    var attribute = dimensionItem[attributeName];

	    if (attribute.length >= 2) {
	        if (attribute[0] === "{" && attribute[attribute.length - 1] === "}") {
	            try {
	                attribute = JSON.parse(attribute);
	            } catch (ex) {
	                attribute = {};
	                this.log.warn("Could not parse the attribute '" + attributeName + "'. Using fallback empty Object.");
	                this.log.debug("Parsing the attribute '" + attributeName + "' caused the following exception: " + ex);
	            }

	            dimensionItem[attributeName] = attribute;
	        }
	    }
	};

	module.exports.CalculationVariableParser = CalculationVariableParser;

/***/ }

});
//# sourceMappingURL=services.js.map