/* global when, self, window, fs, baseClass, ACSFNamespace, AppManager, MetaDataService, Localization */

function apexAbstractionCore() {
}

function getPicklistValues() {
    return this.picklistValues || [];
}

apexAbstractionCore.prototype = {
    metaDataAPEX: {},

    read: function (objectId, className, extension) {
        const result = when.defer();

        let objectContent;
        try {
            if (objectId['readAll'] === undefined) {
                objectContent = self[className + 'Mock'].read(objectId);
            }
            else {
                objectContent = self[className + 'Mock'].readAll(objectId);
            }
        }
        catch (e) {
            objectContent = {'data': [], '__Model': className};
        }

        // Fake an asychronous call
        setTimeout(() => {
            result.resolve(objectContent);
        }, self[className + 'Mock'].responseTime || 100);

        return result.promise;
    },

    write: function (objectId, objectData, className, extension) {
        const result = when.defer();
        // Nothing to do in mock scenario
        setTimeout(() => {
            console.log('Save method for object', className, 'with Id', objectId, 'on extension', extension, 'called');
            result.resolve({'__Model': className, '__Status': true, 'data': true});
        }, 100);

        return result.promise;
    },

    create: function (objectData, className, extension) {
        const result = when.defer();
        let returnValue = 'NewId';
        const objJSON = JSON.parse(objectData);
        const timeStamp = (new Date()).getTime();
        switch (className) {
            case 'LOTactic':
                returnValue = {
                    'Id': 'NEW' + timeStamp,
                    'Tactic_Template__c': objJSON.Tactic_Template_Id__c,
                    'Name': 'Test',
                    'Pct_of_Stores__c': 0,
                    'Compensation_Model__c': 0,
                    'Date_From__c': '2016-04-08',
                    'Date_Thru__c': '2099-04-08',
                    'Amount__c': 0,
                    'Lift__c': 0
                };
                break;

            case 'LOCalPromotions':
                break;

            case 'LOView':
                returnValue = {
                    Description: (objJSON.Description) ? objJSON.Description : '',
                    FilterCriteria: (objJSON.FilterCriteria) ? objJSON.FilterCriteria : {},
                    Id: 'NEW' + timeStamp,
                    IsDefault: false,
                    Name: objJSON.Name
                };
                break;

            default:
                break;
        }

        // Nothing to do in mock scenario
        setTimeout(() => {
            console.log('Create method for object', className, 'on extension', extension, 'called');
            result.resolve({'__Model': className, '__Status': true, 'data': returnValue});
        }, 100);

        return result.promise;
    },

    delete: function (objectId, className, extension) {
        const result = when.defer();
        // Nothing to do in mock scenario
        setTimeout(() => {
            console.log('Delete method for object', className, 'with Id', objectId, 'on extension', extension, 'called');
            result.resolve(true);
        }, 100);

        return result.promise;
    },

    getEARights: function (objectId, className, extension) {
        const result = when.defer();
        // Nothing to do in mock scenario
        setTimeout(() => {
            console.log('EA rights for object', className, 'with Id', objectId, 'on extension', extension, 'requested');
            let objectContent = self[className + 'EAR'];
            if (objectContent === undefined) {
                objectContent = [];
            }
            result.resolve({'data': objectContent});
        }, 100);

        return result.promise;
    },

    copy :function (objectId, className, extension) {
    return this.create(objectId, className, extension);
},

getData : function (objectId, className, extension) {
    var result = when.defer();

    var objectContent = self[className + 'Mock'].getData(objectId);

    // Nothing to do in mock scenario
    setTimeout(function () {
        console.log('getData called for ', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve(objectContent);
    }, 100);

    return result.promise;
},

getMeta : function (objectId, className, extension) {
    var result = when.defer();
    var objectContent = self[className + 'Mock'].getMeta(objectId);
    // Nothing to do in mock scenario
    setTimeout(function () {
        console.log('getMeta method for object', className, 'with Id', objectId, 'on extension', extension, 'called');

        result.resolve(objectContent);
    }, 100);

    return result.promise;
},

    

    readCustomLabels: function (labelCategory) {
        const result = when.defer();

        //const objectContent = require('json!../mock_data/labelCategoryMock.json');

        setTimeout(() => {
            //  result.resolve(objectContent);
            result.resolve({data: Object.assign(Localization.labels,LocalizationCust.labels)});
        }, 100);

        return result.promise;
    },

    getMetaData: function (boName, sfName, isExternal, isManagedObject) {
        const result = when.defer();
        if (isManagedObject && ACSFNamespace) {
            sfName = AppManager.addACSFNamespace(sfName);
        }
        MetaDataService.getMetaData('txid', boName, sfName, isExternal).then((objectContent) => {
            if (isManagedObject && ACSFNamespace) {
                objectContent = AppManager.removeACSFNamespace(objectContent);
            }

            Object.keys(objectContent).forEach((key) => {
                (objectContent[key] || {}).getPicklistValues = getPicklistValues;
            });

            result.resolve(objectContent);
        }, error => {
            if(isManagedObject) return this.getMetaData(boName, arguments[1], isExternal, false);
            throw error;
        });


        //const objectContent = require('json!../mock_data/labelCategoryMock.json');

        //result.resolve(objectContent);
        return result.promise;
    },

    getLoggingConfig: function () {
        const result = when.defer();

        const objectContent = self['LogConfigMock'].config();

        // Fake an asychronous call
        setTimeout(() => {
            result.resolve(objectContent);
        }, 100);

        return result.promise;
    },

    getLocale: function () {
        const result = when.defer();

        const objectContent = {data: {LocaleSidKey: 'es-ES', LanguageLocaleKey: 'es'}};

        // Fake an asychronous call
        setTimeout(() => {
            result.resolve(objectContent);
        }, 100);

        return result.promise;
    },

    writeLogs: function (logs) {
        const result = when.defer();

        console.log(logs);

        // Fake an asychronous call
        setTimeout(() => {
            result.resolve(true);
        }, 100);

        return result.promise;
    }
};

module.exports = apexAbstractionCore;
