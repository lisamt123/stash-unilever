var moment = require('moment');
var ExtPromotionCalendar = {
    /**
     * The onInstantiate function is call once when the BO is ready for user
     * @returns {Promise[]} Array of promises created by asynchronous load of data
     */
    // Core functionality - DO NOT CHANGE THE CONTENT OF THIS FUNCTION DURING CUSTOMIZING!
    onInstantiate: function () {
        var me = this;
        var instantiatePromises = []; // when.defer();
        this.fluxHandler=UI_EVENT_BUS.subscribe(EVENTS.FLUX, this.onDispatcher.bind(this));
        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError.bind(this));

        instantiatePromises = this.preLoad();

        return instantiatePromises;
    },
    /**
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

        var fiscalYearLoadParams = { "Reference_Date": new Date().getTime() };

        instantiatePromises.push(this.LOExtFiscalYear.load(null, fiscalYearLoadParams));

        return Utils.callCustomFunction(this, 'preLoad', null, instantiatePromises);
    },
    /**
     * Loads all data which is not needed immediately for rendering the UI.
     * The returned promises will be resolved asynchronously while the UI is already usable.
     * Customization points:
     *  - Before the processing is done. The project can use that to make adaptions based on the loaded data or to load additional LOs
     * @returns {Promise[]} Array of promises created by asynchronous load of data
     */
    postLoad: function () {
        var me = this;
        var instantiatePromises = [];
        //apply active filter and Creation_Platform__c<>Mobility 
        this.LOPromotion_Template.setFilterArray([{"Active__c":true,"op":"EQ"},{"Creation_Platform__c":"Mobility","op":"NE"}]);
        this.initDate = new Date(this.LOExtFiscalYear.getItems()[0].Date_From);
        this.endDate = new Date(this.LOExtFiscalYear.getItems()[0].Date_Thru);
        var loadParams = { 'readAll': true };
        this.LOAccountSet.load(null, loadParams);
        me.refreshCalendarView();
        /*var calendarView = _.find(this.LOCalendarView.getAllItems(), 'IsDefault');
         var loadParams = {"Date_From": this.initDate.getTime(), "Date_Thru": this.endDate.getTime()};
         loadParams.CalendarView = (calendarView!=null)?calendarView.serialize():'';
         instantiatePromises.push(this.LOCalPromotions.load(null, loadParams));
         instantiatePromises.push(this.LOAccountSet.load(null, {'readAll': true}));

         when.all(instantiatePromises).then(x=> {
         me.refreshCalLegend();
         me.serializeCalendar();
         });*/

         Utils.callCustomFunction(this, 'postLoad', null);
    },
    /**
     * Anchor for the postLoad function
     * Content is moved to postLoad since it may be called several times which would not match the purpose of this function
     */
    afterInstantiate: function () {
        this.postLoad();
    },

     refreshCalLegend: function () {
        this.LOExtCalLegend.removeAllItems();
        var uniqueTemplates = _.uniq(this.LOCalPromotions.getAllItems().map(item => item.Promotion_Template));
        var legendItems = [];
        uniqueTemplates.forEach(promoTemplateId => {
            var promoTemplate = _.find(this.LOPromotion_Template.getAllItems(), {Id: promoTemplateId});
            var promoSample = _.find(this.LOCalPromotions.getAllItems(), {Promotion_Template: promoTemplateId});
            var liCallLegend = {
                'Id': promoTemplate.getId(),
                'Name': promoTemplate.Description__c,
                'Commit_Color': promoSample.Commit_Color
            };
            
            legendItems.push(liCallLegend);
            
          //  this.LOExtCalLegend.addItem(liCallLegend);
        });
        legendItems = _.sortBy(legendItems,'Name');
        this.LOExtCalLegend.addItems(legendItems);
    },

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
     * This method is called after the user creates a new promotion through the UI wizard.
     * It creates a valid promotion object by calling the APEX backend. The result will be added to LOCalPromotions.
     * Customization points:
     *  - beforeAPEX - Parameter for APEX call is assembled and can be adapted
     *  - afterAPEX - Data for new promotion was received from APEX. Can be adapted before it is applied
     * @param {JSON} promotion - Promotion content as created by the UI through the wizard
     */
    addPromotion: function (promotion) {
        this.logger.info('Adding Promotion');
        var Date_Thru__c = new Date(promotion.Date_From__c);
        var Date_From__c = new Date(promotion.Date_From__c);
        switch (promotion.period) {
            case "day":
                Date_Thru__c = moment.utc(Date_From__c.getTime()).add(promotion.duration,'Day').add(-1,'Day').toDate();
                break;
            case "week":
                Date_Thru__c= moment.utc(Date_From__c.getTime()).add(promotion.duration,'Week').add(-1,'Day').toDate();
                break;

            case "month":
                Date_Thru__c= moment.utc(Date_From__c.getTime()).add(promotion.duration,'Month').add(-1,'Day').toDate();
                break;
        }
        var promoObject = {
            "Phase__c": "Planning",
            "Anchor_Account__c": promotion.account,
            "Anchor_Account_Set__c": promotion.accountSet,
            "Promotion_Template__c": promotion.promotion_template.Id,
            "Slogan_Language_1__c": promotion.Slogan__c,
            "Date_From__c": Date_From__c.getTime(),
            "Date_Thru__c": Date_Thru__c.getTime()
        };

        promoObject = Utils.callCustomFunction(this, 'addPromotion', 'beforeAPEX', promoObject);
        var win = self.open('');
        this.LOCalPromotions.apex_create(JSON.stringify(promoObject)).then(result => {
            if (result.__Status) {
                //     this.LOCalPromotions.addItem(result.data);
                result.data = Utils.callCustomFunction(this, 'addPromotion', 'afterAPEX', result.data);
                this.refreshCalendarView();
                Utils.HTTP.navigateTo(this.getPromotionPlanningPageReference(),{id:result.data},{newTab:true},win)
                //self.open(promotionPath + '?id=' + result.data);
            }
        });
    },

    /**
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

        calendar = Utils.callCustomFunction(this, 'serializeToUI', null, calendar);

        UI_EVENT_BUS.put(EVENTS.UI_BINDING, {calendar: calendar});
    },

    /**
     * Get the visual force page reference to PromotionPlanning page. 
     */
    getPromotionPlanningPageReference: function(){
        return 'PromotionPlanning';
    },
    /**
     * Serialize the content of the calendar to be sent as state to the React UI
     */
    serializeToUI: function () {
        return this.serializeCalendar();
    },

    onUIError: function (message) {
        this.modalMessages.push(message);
        AppManager.init().then(() => UI_EVENT_BUS.put(EVENTS.UI_BINDING, { modalMessages: this.modalMessages }));
    },
    onDispatcher: function (payload) {
        var action = payload;
        var self=this;

        switch (action.actionType) {
            case PromCalendarActionConstants.CALENDAR_LOAD:
                this.load();
                break;

            case  PromCalendarActionConstants.ADD_PROMOTION :
                console.log('Add Promotion');
                this.addPromotion(action.payload);
                break;

            case  PromCalendarActionConstants.PREVIOUS_PERIOD :
                console.log('PREVIOUS_PERIOD Promotion');
                var date_from = new Date(this.initDate);

                date_from.setFullYear(this.initDate.getFullYear() - 1);

                var loadParams = {"Reference_Date": date_from.getTime()};
                this.LOExtFiscalYear.apex_read(loadParams).then(fiscalYear => {
                    if (fiscalYear.__Status) {
                        this.LOExtFiscalYear.removeAllItems();
                        this.LOExtFiscalYear.addItem(fiscalYear.data[0]);
                        this.initDate = new Date(fiscalYear.data[0].Date_From);
                        this.endDate = new Date(fiscalYear.data[0].Date_Thru);
                        this.refreshCalendarView();
                    }
                    else {
                        alert('error moving to next period');
                        this.refreshCalendarView();
                    }
                });
                break;

            case  PromCalendarActionConstants.NEXT_PERIOD :
                console.log('NEXT_PERIOD Promotion');

                var date_from = new Date(this.initDate);

                date_from.setFullYear(this.initDate.getFullYear() + 1);

                var loadParams = {"Reference_Date": date_from.getTime()};
                this.LOExtFiscalYear.apex_read(loadParams).then(fiscalYear => {
                    if (fiscalYear.__Status) {
                        this.LOExtFiscalYear.removeAllItems();
                        this.LOExtFiscalYear.addItem(fiscalYear.data[0]);
                        this.initDate = new Date(fiscalYear.data[0].Date_From);
                        this.endDate = new Date(fiscalYear.data[0].Date_Thru);
                        this.refreshCalendarView();
                    }
                    else {
                        alert('error moving to next period');
                        this.refreshCalendarView();
                    }
                });
                break;

            case  PromCalendarActionConstants.CHANGE_FILTER :
                console.log('CHANGE_FILTER Promotion');
                this.updateCalendarView(action.payload);
                _.assign(this, action.payload);

                this.serializeCalendar();
                break;
            case PromCalendarActionConstants.CANCEL_CHANGE_FILTER:
                console.log('Cancel CHANGE_FILTER Promotion');
                this.serializeCalendar();
                break;

            case  PromCalendarActionConstants.GET_PROMOTION_DETAIL :
                console.log('GET_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
                var promoDetail = _.find(this.LOExtHoverContent.getAllItems(), {promotionId: action.payload});
                if (promoDetail) {

                    var promotionDetail = {
                        Id: promoDetail.promotionId,
                        Tactics: promoDetail.content.Tactics.reduce((result, tactic) => {
                            result.push({
                                'Id': tactic.Id,
                                'Date_From': new Date(tactic.Date_From),
                                'Date_Thru': new Date(tactic.Date_Thru),
                                'Description': tactic.Description
                            });
                            return result;
                        }, [])
                    };

                    UI_EVENT_BUS.put(EVENTS.UI_BINDING, {promotionDetailData: promotionDetail});
                }
                else {
                    this.LOExtHoverContent.apex_read({"promotionId": action.payload}).then(detail=> {
                        this.LOExtHoverContent.addItem(detail.data[0]);
                        var promotionDetail = {
                            Id: detail.data[0].promotionId,
                            Tactics: detail.data[0].content.Tactics.reduce((result, tactic) => {
                                result.push({
                                    'Id': tactic.Id,
                                    'Date_From': new Date(tactic.Date_From),
                                    'Date_Thru': new Date(tactic.Date_Thru),
                                    'Description': tactic.Description
                                });
                                return result;
                            }, [])
                        };

                        UI_EVENT_BUS.put(EVENTS.UI_BINDING, {promotionDetailData: promotionDetail});
                    });
                }
                break;

            case  PromCalendarActionConstants.OPEN_PROMOTION_DETAIL:
                console.log('OPEN_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
                //window.open(promotionPath + '?id=' + action.payload);
                 Utils.HTTP.navigateTo(this.getPromotionPlanningPageReference(),{id:action.payload})
                break;

            case  PromCalendarActionConstants.DERIVE_PROMOTION_DETAIL:

                console.log('DERIVE_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);

                this.LOCalPromotions.apex_derive(action.payload).then(result => {
                    if (result.__Status) {
                         Utils.HTTP.navigateTo(this.getPromotionPlanningPageReference(),{id:result.data.Promotions[0].Id},{newTab:true})
                       // self.open(promotionPath + '?id=' + result.data.Promotions[0].Id);
                    }
                });
                /*UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                 title: 'Unavailable Functionality',
                 message: 'Sorry, derive promotion functionality is not available yet.',
                 type: 'E'
                 });*/
                break;

            case PromCalendarActionConstants.COPY_PROMOTION_DETAIL:
                this.LOCalPromotions.apex_copy(action.payload).then(result => {
                    if (result.__Status) {
                          Utils.HTTP.navigateTo(this.getPromotionPlanningPageReference(),{id:result.data.Promotions[0].Id})
                       // self.open(promotionPath + '?id=' + result.data.Promotions[0].Id);

                    }
                });
                console.log('COPY_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
                break;

            case  PromCalendarActionConstants.DELETE_PROMOTION_DETAIL:
                this.LOCalPromotions.apex_delete(action.payload).then(result => {
                    if (result) {
                       var promotionGroup=_.find(self.LOCalPromotions.getAllItems(),(item)=>_.find(item.Promotions,{Id:action.payload}) );
                       if (promotionGroup.Promotions.length==1){
                            //remove whole promotion
                            _.remove(self.LOCalPromotions.getAllItems(),promotionGroup);
                       } else {
                            //delete promotion
                             _.remove(promotionGroup.Promotions,{Id:action.payload});
                       }
                       self.serializeCalendar();

                       //self.refreshCalendarView();
                    }
                });
                console.log('DELETE_PROMOTION_DETAIL Promotion for promotion : ' + action.payload);
                break;
            default: 
                Utils.callCustomFunction(this, 'onDispatcher', null, action);
                break;
        }
    }
};

module.exports = ExtPromotionCalendar;
