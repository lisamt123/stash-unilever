"use strict";

var MetaDataService = {
    getMetaData: function (txId, bo, sfObject, isExternal, handler) {
        var result = when.defer();
        if (MetaDataRemoteActionExtension)
            MetaDataRemoteActionExtension.getMetaData(txId, bo, sfObject, isExternal, function (res, event) {
                    if (event.status) {
                        handler(res);
                        result.resolve(true);
                    }
                    else {
                        ErrorHandler.treatJSRemotingError(event);
                        result.resolve(false);
                    }
                },
                {buffer: false}
            );
        else
            result.resolve(true);
        return result.promise;
    },

    connect: function () {
        var result = when.defer();
        result.resolve(true);
        return result.promise;
    }
};

module.exports.MetaDataService = MetaDataService;

