({
    DEFAULT_COMPONENT_NAME : 'markup://c:OV_Home',
    COMPONENT_NAME         : 'c:OV_Navigation',
    /**
     * Loads specified component into component body
     * @param Object component Parent component instance
     * @param String newComponent Name of the new component to create, f.ex: c:OV_Home
     * @param Object newComponentParams New component params (optional)
     */
    loadComponent: function(component, newComponent, newComponentParams) {
        // prepare state object
        var state = {
            timestamp    : Date.now(),
            componentDef : 'one:auraContainer',
            attributes   : {
                values : {
                    tag                 : this.COMPONENT_NAME,
                    componentDef        : newComponent,
                    componentAttributes : newComponentParams,
                    // need to copy componentAttributes to attributes
                    // as aura checks for attributes or values.attributes properties only :(
                    attributes          : newComponentParams
                }
            }
        };

        var hash         = this.getToken().encodeToken(state);
        var currentHash  = window.history.state ? window.history.state.hash : false;
        var decodedToken = currentHash !== false ? this.getToken()._decodeToken(currentHash) : null;

        // if hash changed -> add to history, do not store empty hash because it means home page
        var storeHistoryEntry = false;
        if (this.getToken().equalsIgnoreTimestamp(decodedToken !== null ? decodedToken.attributes.values : null, state.attributes.values) === false) {
            storeHistoryEntry = true;
        }

        this.destroyBody(component);

        $A.createComponent(
            newComponent,
            newComponentParams || {},
            function(newComponent) {
                if (component.isValid() === true && newComponent.isValid() === true) {
                    component.find('mainComponent').set('v.body', [newComponent]);

                    if (storeHistoryEntry === true) {
                        // update history after adding new component into wrapper body
                        window.history.pushState({"hash":hash}, null, "#" + hash);
                    }
                }
            }
        );
    },

    replaceHistoryEntry: function(component, activeTab) {
        if ($A.util.isEmpty(activeTab) === true) {
            return;
        }

        var currentHash  = window.history.state ? window.history.state.hash : false;

        if ($A.util.isEmpty(currentHash) === true) {
            return;
        }

        // decode current hash
        var decodedToken = this.getToken()._decodeToken(currentHash);

        if ($A.util.isEmpty(decodedToken) === true) {
            return;
        }

        if (decodedToken.attributes.values.componentAttributes.defaultMenuItem === activeTab) {
            return;
        }

        decodedToken.attributes.values.componentAttributes.defaultMenuItem = activeTab;
        decodedToken.attributes.values.attributes.defaultMenuItem          = activeTab;

        var hash = this.getToken().encodeToken(decodedToken);
        window.history.replaceState({"hash":hash}, null, "#" + hash);
    },

    getQueryVariable: function(variable) {
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split("=");
            if(pair[0] === variable){
                return decodeURIComponent(pair[1]);
            }
        }
        return(false);
    },

    removeParam: function(keys, searchPath) {
        var result = '';
        if (searchPath === '' || searchPath.indexOf('?') === -1) {
            return result;
        }

        var queryString = searchPath.split('?')[1];
        var params_arr, param;

        if (queryString !== '') {
            params_arr = queryString.split('&');
            for (var i = params_arr.length - 1; i >= 0; i -= 1) {
                param = params_arr[i].split('=')[0];
                if (keys.indexOf(param) !== -1) {
                    params_arr.splice(i, 1);
                }
            }
            result = result + '?' + params_arr.join('&');
        }
        return result;
    },

    redirect: function(component) {
        // redirectByUrlParams will return true in case window.location.href is called to avoid executing other logic

        if (this.redirectByUrlParams(component) === false) {
            this.redirectByToken(component);
        }
    },

    redirectByUrlParams: function(component) {
        var recordType = this.getQueryVariable('recordType');
        var recordId   = this.getQueryVariable('recordId');

        if (recordType !== false && recordId !== false && recordType === 'Report') {
            // prepare attributes object
            var componentDef        = 'c:OV_ComponentWrapper';
            var componentAttributes =  {
                renderBackArrow : true,
                wrappedObject   : {
                    componentDef        : 'c:OV_ReportDesktop',
                    componentAttributes : {
                        reportId    : recordId,
                        shelfColour : this.getQueryVariable('shelfColour') || '#0E5DB8',
                        shelfIcon   : this.getQueryVariable('shelfIcon')   || 'Custom68',
                        shelfTileId : this.getQueryVariable('shelfTileId') || null
                    }
                }
            };

            // prepare state object
            var state = {
                timestamp    : Date.now(),
                componentDef : 'one:auraContainer',
                attributes   : {
                    values : {
                        tag                 : this.COMPONENT_NAME,
                        componentDef        : componentDef,
                        componentAttributes : componentAttributes,
                        // need to copy componentAttributes to attributes
                        // as aura checks for attributes or values.attributes properties only :(
                        attributes          : componentAttributes
                    }
                }
            };

            var hash      = this.getToken().encodeToken(state);
            var targetUrl = window.location.origin + window.location.pathname + this.removeParam(['recordType', 'recordId', 'shelfColour', 'shelfIcon', 'shelfTileId'], window.location.search) + '#' + hash;
            window.history.replaceState({"hash":hash}, null, targetUrl);
            return false;
        }
        return false;
    },

    replaceShelfHistoryEntry: function(component, shelfTileId) {
        var currentHash  = window.history.state ? window.history.state.hash : false;

        if ($A.util.isEmpty(currentHash) === true) {
            return;
        }

        // decode current hash
        var decodedToken = this.getToken()._decodeToken(currentHash);

        if ($A.util.isEmpty(decodedToken) === true) {
            return;
        }

        if (decodedToken.attributes.values.componentAttributes.activeShelfTileId === shelfTileId) {
            return;
        }

        decodedToken.attributes.values.componentAttributes.activeShelfTileId  = shelfTileId;
        decodedToken.attributes.values.attributes.activeShelfTileId           = shelfTileId;

        // reset folder entry
        decodedToken.attributes.values.componentAttributes.activeFolderTileId = null;
        decodedToken.attributes.values.attributes.activeFolderTileId          = null;
        decodedToken.attributes.values.componentAttributes.activeFolderName   = null;
        decodedToken.attributes.values.attributes.activeFolderName            = null;

        var hash = this.getToken().encodeToken(decodedToken);
        window.history.replaceState({"hash":hash}, null, "#" + hash);
    },

    replaceShelfFolderHistoryEntry: function(component, shelfTileFolderId, folderName) {
        var currentHash  = window.history.state ? window.history.state.hash : false;

        if ($A.util.isEmpty(currentHash) === true) {
            return;
        }

        // decode current hash
        var decodedToken = this.getToken()._decodeToken(currentHash);

        if ($A.util.isEmpty(decodedToken) === true) {
            return;
        }

        if (decodedToken.attributes.values.componentAttributes.activeFolderTileId === shelfTileFolderId && decodedToken.attributes.values.componentAttributes.activeFolderName === folderName) {
            return;
        }

        decodedToken.attributes.values.componentAttributes.activeFolderTileId = shelfTileFolderId;
        decodedToken.attributes.values.attributes.activeFolderTileId          = shelfTileFolderId;

        decodedToken.attributes.values.componentAttributes.activeFolderName   = folderName;
        decodedToken.attributes.values.attributes.activeFolderName            = folderName;

        var hash = this.getToken().encodeToken(decodedToken);
        window.history.replaceState({"hash":hash}, null, "#" + hash);
    },

    /**
     * Returns Token class instance
     * @return Token class instance
     */
    getToken: function() {
        // if token is not stored in this class instance then find center stage and extract Token
        if (!this.Token && $('.oneCenterStage').length > 0 ) {
            this.Token = $A.services.component.getAttributeProviderForElement($('.oneCenterStage')[0]).helper.lib.Token;
        }
        return this.Token;
    },

    /**
     * Redirects to location specified in URL token attributes or to home if not specified
     *
     * @param Object Component Current component
     */
    redirectByToken: function(component) {
        var hash                = window.history.state ? window.history.state.hash : (window.location.hash ? window.location.hash.replace('#', '') : null);
        var componentDef        = this.DEFAULT_COMPONENT_NAME;
        var componentAttributes = {};

        if (hash !== false) {
            var decodedToken = this.getToken()._decodeToken(hash);
            if ($A.util.isObject(decodedToken) === true && decodedToken.attributes && decodedToken.attributes.values && decodedToken.attributes.values.componentDef) {
                componentDef        = decodedToken.attributes.values.componentDef;
                componentAttributes = decodedToken.attributes.values.componentAttributes || {};
            }
        }

        this.loadComponent(component, componentDef, componentAttributes);
    },

    /**
     * Removes all child components from component body
     *
     * @param Object Component Current component
     */
    destroyBody: function(component) {
        var oldComponents = component.find('mainComponent').get('v.body');

        if (oldComponents && oldComponents.length) {
            for (var i = 0, len = oldComponents.length; i < len; i++) {
                if (oldComponents[i].isValid() === true) {
                    oldComponents[i].unrender();
                    oldComponents[i].destroy(false);
                }
            }
        }
    },

    /**
     * Checks if location has changed based on location params
     *
     * @param Object newLocationParams Location params object
     * @return Boolean True if location has changed
     */
    isLocationChanged: function(newLocationParams) {
        var result = true;
        if ($A.util.isObject(newLocationParams) === true && newLocationParams.token) {
            var decodedToken = this.getToken()._decodeToken(newLocationParams.token);
            if ($A.util.isObject(decodedToken) === true && decodedToken.attributes && decodedToken.attributes.values && decodedToken.attributes.values.componentDef) {
                result = decodedToken.attributes.values.componentDef.indexOf(this.COMPONENT_NAME) === -1;
            }
        }
        return result;
    },

    /**
     *  Since other components do not exist and cannot catch filter event we need to store filters here
     */
    storeFilterSettings : function(component, filters) {
        var deviceType = '';
        if ($A.get('$Browser.formFactor') === 'PHONE') {
            deviceType = 'Mobile';
        } else if ($A.get('$Browser.isIOS') || $A.get('$Browser.isAndroid')) {
            deviceType = 'Tablet';
        } else {
            deviceType = 'Desktop';
        }

        var callback = function(response) {

        };

        var action = component.get('c.search');
        action.setParams({
            'geographyId'      : filters.reportGeography,
            'categoryId'       : filters.reportCategory,
            'functionId'       : filters.reportFunction,
            'mineOnly'         : filters.reportVisibleToMe,
            'recordTypeName'   : filters.recordTypeName,
            'deviceType'       : deviceType,
            'filtersFromCache' : false
        });

        action.setCallback(this, callback);

        //dh
        action.setExclusive();


        $A.enqueueAction(action);
    }
})