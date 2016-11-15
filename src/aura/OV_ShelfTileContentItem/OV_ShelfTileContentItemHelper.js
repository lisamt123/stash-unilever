({
    getDocumentIconByType: function(documentFileType) {
        var baseIconUrl        = '/resource/bootstrapSF1/icons/doctype/';
        var icon               = 'unknown_120.png';

        if ($A.util.isEmpty(documentFileType) === false) {
            var iconToTypeMap = {
                'ppt_120.png'   : /POWER.*POINT/i,
                'word_120.png'  : /WORD/i,
                'excel_120.png' : /EXCEL/i,
                'pdf_120.png'   : /PDF/i,
                'image_120.png' : /PNG|JPG|JPEG|GIF|BMP/i,
                'video_120.png' : /MPG|MPEG|MP4|MOV|AVI|MKV|RMVB|RM|FLV|WEBM|WMV/i,
                'zip_120.png'   : /ZIP/i,
                'txt_120.png'   : /TXT/i,
                'csv_120.png'   : /CSV/i
            };

            for (var iconImg in iconToTypeMap) {
                if (iconToTypeMap.hasOwnProperty(iconImg) === true && documentFileType.match(iconToTypeMap[iconImg]) !== null) {
                    icon = iconImg;
                    break;
                }
            }
        }
        return baseIconUrl + icon;
    },
    formatNumber: function(val) {
        if (val < 1000) {
            return val;
        }

        var result = '';
        if (val / 100000 > 1) {
            result = (val / 100000).toFixed(1) + 'K';
        } else if (val / 10000 > 1) {
            result = (val / 10000).toFixed(1) + 'K';
        } else if (val / 1000 > 1) {
            result = (val / 1000).toFixed(1) + 'K';
        }

        return result.replace('\.0K', 'K');
    },
    recordView: function(component, operationType, deviceType) {
        var action   = component.get('c.saveUsageEntry');
        action.setParams({
            'reportId'          : component.get('v.reportItem.reportId'),
            'shelfTileId'       : $A.OV && $A.OV.selectedTab && $A.OV.selectedTab === 'MY VIEW' ? 'My View' : component.get('v.shelfTileId'),
            'operationType'     : operationType,
            'deviceType'        : deviceType
        });

        $A.enqueueAction(action);
    },
    increaseViewsCounter: function(component, reportId, callback) {
        // this is fire and forget type because we don't need to wait for response - jsut assume it worked
        var action  = component.get('c.increaseViewsCounter');
        action.setParams({
            'reportId'   : reportId
        });

        if ($A.util.isFunction(callback) === true) {
            action.setCallback(this, callback);
        }

        $A.enqueueAction(action);
    },
    getReport : function(component, reportId, inCallback) {
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            }
        };

        var action = component.get('c.getReport');
        action.setParams({
            'reportId'   : reportId
        });

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    addReportToFavourites : function(component, reportId, inCallback) {
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            }else{
                component.set('v.reportItem.reportIsFavourite',false);
            }
        };

        var action = component.get('c.addReportToFavourites');
        action.setParams({
            'reportId'    : reportId,
            'shelfTileId' : component.get('v.shelfTileId')
        });

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    deleteReportFromFavourites : function(component, reportId, inCallback) {
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            }else{
                component.set('v.reportItem.reportIsFavourite',true);
            }
        };

        var action = component.get('c.deleteReportFromFavourites');
        action.setParams({
            'reportId' : reportId
        });

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    requestFavouiriteUpdate: function(component, reportId, isFav){
        $A.get('e.c:OV_FavouriteUpdateEvent').setParams({
            reportId : reportId,
            isFav    : isFav
        }).fire();
    }
})