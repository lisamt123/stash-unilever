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
    getReport : function(component, reportId, shelfTileId, inCallback) {
        var action   = component.get("c.getReport");
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            }
        };

        action.setParams({
            "reportId"   : reportId,
            "shelfTileId": shelfTileId,
            "deviceType" : 'Mobile'
        });

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    recordView: function(component, operationType, deviceType) {
        var action   = component.get('c.saveUsageEntry');
        action.setParams({
            'reportId'          : component.get('v.reportId'),
            'shelfTileId'       : $A.OV && $A.OV.selectedTab && $A.OV.selectedTab === 'MY VIEW' ? 'My View' : component.get('v.shelfTileId'),
            'operationType'     : operationType,
            'deviceType'        : deviceType
        });
        $A.enqueueAction(action);
    },
    addReportToFavourites : function(component, reportId, inCallback) {
        var action   = component.get("c.addReportToFavourites");
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            }else{
                component.set("v.reportIsFavourite", false);
            }
        };

        action.setParams({
            "reportId"    : reportId,
            "shelfTileId" : component.get("v.shelfTileId")
        });

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    deleteReportFromFavourites : function(component, reportId, inCallback) {
        var action   = component.get("c.deleteReportFromFavourites");
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            } else {
                component.set("v.reportIsFavourite", true);
            }
        };

        action.setParams({
            "reportId" : reportId
        });

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    requestFavouiriteUpdate: function(component, reportId, isFav){
        var favouiriteUpdateEvent = $A.get('e.c:OV_FavouriteUpdateEvent').setParams({
            reportId  : reportId,
            isFav : isFav
        }).fire();
    }
})