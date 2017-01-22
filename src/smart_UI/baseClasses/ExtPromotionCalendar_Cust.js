var ExtPromotionCalendar_Cust = {
    /**
     * Customize extension to the core preLoad function. Will be called at the end of the core method.
     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
     * @returns {promise[]} Array of promises adapted in customizing
     */
    preLoad: function (instantiatePromises) {
        return instantiatePromises;
    },
    /**
     * Customize extension to the core postLoad function. Will be called at the end of the core method.
     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
     * @returns {promise[]} Array of promises adapted in customizing
     */
    postLoad: function (instantiatePromises) {
        return instantiatePromises;
    },
    /**
     * Customize extension to the core serializeToUI function. Will be called at the end of the core method.
     * Input parameter is the already serialized BO as core would send it to the UI layer.
     * The project can manipulate the JSON to match its requirements. The reponse should again be a promotion state JSON.
     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
     * @returns {JSON} Serialized version of the BO adpated for project requirements
     */
    serializeToUI: function(serializedObject) {
        return serializedObject;
    },
    /**
     * Customize extension to the core addPromotion function. Will be called before the APEX request is sent.
     * Input parameter is the already serialized BO as core would send it to the UI layer.
     * The project can manipulate the JSON to match its requirements. The reponse should again be a promotion JSON.
     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
     * @returns {JSON} Serialized version of the BO adpated for project requirements     
     */
    addPromotion_beforeAPEX: function(serializedObject) {
        return serializedObject;
    },
    /**
     * Customize extension to the core addPromotion function. Will be called after the APEX call for the new promotion has returned.
     * Input parameter is the data as received from the APEX method. This means an empty promotion JSON in that case
     * The project can make adaptions to the data or execute additional action. The reponse should again be the empty tactic JSON.
     * @param {JSON} payload - Data received from the createLOCalPromotions APEX method
     * @returns {JSON} Data received from the createLOCalPromotions APEX method
     */
    addPromotion_afterAPEX: function(payload) {
        return payload;
    },
    /**
     * Customize extension to the core onDispatcher function. Will be called if an UI event is not found in core code.
     * @param {JSON} action - Payload as provided by the UI event bus
     */
    onDispatcher: function(action) {
        switch (action.actionType) {
            /*
            case PromCalendarActionConstants.MYACTION:
                // Do something here
                break;
            */
            default:
                console.log('Unknown action type ${action.actionType} detected. Cannot call appropriate action.');
                break;
        }
    },
    /**
     * Replace of getPromotionPlanningPageReference to point to the custom promotion planning page. 
     */
    getPromotionPlanningPageReference: function () {
        return 'MyPromotionPlanning';
    },
    
    /**
     * Replaced preLoad to support migration to R4
     * Load all data which must be available before the UI is rendered. 
     * The promises as returned by this function are handled in a synchronous way. Only once all of them are resolved the system continues.
     * Customization points:
     *  - Before the array of promises is returned. The project can use that to add additonal LOs
     * @returns {Promise[]} Array of promises created by asynchronous load of data
     */
    preLoad: function () {
        var me = this;
        var instantiatePromises = []; // when.defer();
        var loadParams = { 'readAll': true };

        this.modalMessages = [];

        instantiatePromises.push(this.LOTactic_Template.load(null, loadParams));
        instantiatePromises.push(this.LOPromotion_Template.load(null, loadParams));
        instantiatePromises.push(this.LOAccount.load(null, loadParams));
        instantiatePromises.push(this.LOExtPrdFilters.load());
        instantiatePromises.push(this.LOCalendarView.load());


        var fiscalYearLoadParams = {"Reference_Date": new Date().getTime()};

        instantiatePromises.push(this.LOExtFiscalYear.load(null, fiscalYearLoadParams));

      return instantiatePromises;
    },
    /**
     * Replaced refreshCalendarView to support migration to R4
     */
    refreshCalendarView: function () {
        var me = this;
       // var calendarView = this.LOCalendarView.getItems()[0];
       var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
       if (calendarView != null) {


           var loadParams = { "Date_From": this.initDate.getTime(), "Date_Thru": this.endDate.getTime() };
           loadParams.CalendarView = (calendarView != null) ? calendarView.serialize() : '';
           this.LOCalPromotions.removeAllItems();

           this.LOCalPromotions.load(null, loadParams).then(x => {
               this.refreshCalLegend();
               this.serializeCalendar();
           });
       }
       else
        this.serializeCalendar();
    },
    /**
     * Replaced updateCalendarView to support migration to R4
     */
 updateCalendarView: function (uiView) {
        var me = this;
        //var calendarView = this.LOCalendarView.getItems()[0];
        var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
        if (!calendarView){
            //There is no calendar view so we have to create an empty one
            var LICalendarView={
                    'Id': '',
                    'Name': 'Default View',
                    'Description': 'Default View',
                    'IsDefault': true,
                    'FilterCriteria': {
                        "accountfilter": {
                            "criteria": {
                                "account_id__c": []
                            }
                        },
                        "promotionfilter": {
                            "criteria": {
                                "promotion_template__c": [],
                                "tactic_template__c": [],

                            }
                        },
                        "productfilter": {
                            "criteria": {
                                "category__c": []
                            }
                        }

                    }
            };

            this.LOCalendarView.addItem(LICalendarView);
            calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');

        }

        calendarView.objectStatus |= STATE.DIRTY;
        var filterCriteria = calendarView.FilterCriteria;
        if (uiView!=null){ //If it is null we maintain an empty initial view (user clicked the Continue Anyways button)
             Object.keys(filterCriteria).forEach(c => {
            var uiCriteria = uiView[c];
            var viewCriteria = filterCriteria[c].criteria;
            uiCriteria.forEach(field => {
                viewCriteria[field.fieldId] = _.filter(field.values, {Selected: true}).reduce((r, v)=> {
                    r.push(v.Id);
                    return r;
                }, []);
            });
        });
        }
       
    
        this.refreshCalendarView();
        this.LOCalendarView.apex_write(calendarView.Id, JSON.stringify(calendarView.serialize())).then(result => {
            if (result.__Status) {
                var viewId = result.data.Id;
                var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
                calendarView.Id = viewId;
            }

        });
    },
     /**
     * Replaced serializeCalendar function to support migration to R4
     * Serialize the BO content into a JSON object and send it through the event bus to the UI.
     * The UI will then refresh the components depending on this data.
     * Customization points:
     *  - before the UI is refreshed, the serialized object can be adapted
     */
    serializeCalendar: function () {
        var me = this;
        var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');

        var serialzeProductFilter = function (fieldId) {
            return {
                fieldId: fieldId,
                label: _.find(me.LOExtPrdFilters.getAllItems(), {filterId: fieldId}).filterLabel,
                values: _.filter(me.LOExtPrdFilters.getAllItems(), {filterId: fieldId}).reduce((result, item) => {
                    result.push({
                        Label: item.filterValueLabel,
                        Id: item.filterValueId,
                        Selected: (calendarView!=null && calendarView.FilterCriteria.productfilter.criteria[fieldId] &&
                        calendarView.FilterCriteria.productfilter.criteria[fieldId].indexOf(item.filterValueId) != -1)
                    });
                    return result;
                }, [])
            }
        };

        var calendar = {
            initDate: this.initDate,
            endDate: this.endDate,
            showInitialSettings: (calendarView == null),
            isFilterSet: true,//TODO
            FilterCriteria: {
                accountfilter: [
                    {
                        fieldId: 'account_id__c',
                        label: AppManager.getLabel("PC_LBL_CUSTOMER_NAME") || 'Customer name',
                        values: this.LOAccount.getAllItems().reduce((result, acc) => {
                            result.push({
                                Label: acc.Name,
                                Id: acc.Id,
                                Selected: (calendarView!=null && calendarView.FilterCriteria.accountfilter.criteria.account_id__c.indexOf(acc.Id) != -1)
                            });
                            return result;
                        }, [])
                    }
                ],
                promotionfilter: [
                    {
                        fieldId: 'promotion_template__c',
                        label: AppManager.getLabel("PC_LBL_PROMOTION_TYPE") || 'Promotion type',
                        values: this.LOPromotion_Template.getAllItems().reduce((result, promo) => {
                            result.push({
                                Label: promo.Description__c,
                                Id: promo.Id,
                                Selected: (calendarView!=null && calendarView.FilterCriteria.promotionfilter.criteria.promotion_template__c.indexOf(promo.Id) != -1)
                            });
                            return result;
                        }, [])
                    },
                    {
                        fieldId: 'tactic_template__c',
                        label: AppManager.getLabel("PC_LBL_TACTIC_TYPE") || 'Tactic type',
                        values: this.LOTactic_Template.getAllItems().reduce((result, tactic) => {
                            result.push({
                                Label: tactic.Description__c,
                                Id: tactic.Id,
                                Selected: (calendarView!=null && calendarView.FilterCriteria.promotionfilter.criteria.tactic_template__c.indexOf(tactic.Id) != -1)
                            });
                            return result;
                        }, [])
                    }
                ],
                productfilter: []
            },

            accounts: this.LOAccount.getAllItems().reduce((result, acc) => {
                result.push({
                    Label: acc.Name,
                    Id: acc.Id
                });
                return result;
            }, []),

            accountSet: this.LOAccountSet.getAllItems().reduce((result, acc) => {
                result.push({
                    Label: acc.Description__c,
                    Id: acc.Id
                });
                return result;
            }, []),

            promotion_templates: this.LOPromotion_Template.getAllItems().reduce((result, promo) => {
                result.push({
                    Label: promo.Description__c,
                    Id: promo.Id,
                    Anchor_Type: promo.Anchor_Type__c
                });
                return result;
            }, []),
            
             active_promotion_templates: this.LOPromotion_Template.getItems().reduce((result, promo) => {
                result.push({
                    Label: promo.Description__c,
                    Id: promo.Id,
                    Anchor_Type: promo.Anchor_Type__c
                });
                return result;
            }, []),

            legend: this.LOExtCalLegend.getAllItems().reduce((result, legend) => {
                result.push({Name: legend.Name, Commit_Color: legend.Commit_Color});
                return result;
            }, []),

            periods: this.LOExtFiscalYear.getAllItems()[0].Periods,// TODO

            promotions: this.LOCalPromotions.getAllItems().reduce((result, promo) => {
                result.push(
                    {
                        'slogan': promo.Slogan,
                        'Account_Name': promo.Account_Name || promo.Account_Set_Description ,
                        'Commit_Color': promo.Commit_Color,
                        'Promotion_Template_Id': promo.Promotion_Template,
                        'dates': promo.Promotions.reduce((r, v)=> {
                            r.push({
                                'Id': v.Id,
                                'from': new Date(v.Date_From),
                                'to': new Date(v.Date_Thru),
                                'phase': v.Phase,
                                'isReady': (v.Phase == 'Committed')
                            });

                            return r;
                        }, [])
                    });
                return result;
            }, [])
        };

        calendar.FilterCriteria.productfilter.push(serialzeProductFilter('category__c'));

        calendar.isFilterSet = _.some(calendar.FilterCriteria.accountfilter[0].values, { Selected: true }) ||
            _.some(calendar.FilterCriteria.promotionfilter[0].values, { Selected: true }) ||
            _.some(calendar.FilterCriteria.promotionfilter[0].values, { Selected: true }) ||
            _.some(calendar.FilterCriteria.productfilter[0].values, { Selected: true });

       

        UI_EVENT_BUS.put(EVENTS.UI_BINDING, { calendar: calendar });
    }

};

module.exports = ExtPromotionCalendar_Cust;