"use strict";

var AccountPlan = {
    onInstantiate: function() {
        var me = this;
        var instantiatePromises = []; // when.defer();
        this.fluxHandler = UI_EVENT_BUS.subscribe(EVENTS.FLUX, this.onDispatcher.bind(this));
        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError.bind(this));

        instantiatePromises = this.preLoad();
        this.tree = new AsyncTree();
        return instantiatePromises;
    },

    preLoad: function() {
        var me = this;
        var instantiatePromises = []; // when.defer();
        var loadParams = { 'readAll': true };

        this.modalMessages = [];

        instantiatePromises.push(this.LOAccount.load(null, loadParams));
        instantiatePromises.push(this.LOExtPrdFilters.load());
        instantiatePromises.push(this.LOView.load());
        return instantiatePromises;
    },

    postLoad: function() {
        var me = this;
        var instantiatePromises = [];

        //check timefilter values
        var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
         if (!loView) {
            //There is no calendar view so we have to create an empty one
            var LIView = {
                'Id': '',
                'Name': 'Default View',
                'Description': 'Default View',
                'IsDefault': true,
                'FilterCriteria': {
                    "accountfilter": {
                        "account_id__c": []
                    },
                    "promotionfilter": {
                        "promotion_template__c": [],
                        "tactic_template__c": [],
                    },
                    "productfilter": {
                        "category__c": []
                    }

                }
            };


            this.LOView.addItem(LIView);
            loView = _.find(this.LOView.getAllItems(), 'IsDefault');

        }

        loView.objectStatus |= STATE.DIRTY;
        if (loView && !loView.FilterCriteria['timefilter']){
             var now=new Date();
            loView.FilterCriteria.timefilter={

                datefrom : new Date((new Date(now.getFullYear(), 0, 1)).getTime() - (now.getTimezoneOffset()*60000)),
                datethru:  new Date((new Date(now.getFullYear(), 11, 31)).getTime() - (now.getTimezoneOffset()*60000))

            }
        }

        /*this.LOView.apex_read({ 'readAll': true, 'Usage': 'Account' }).then(data => {
           console.log("LOAccount_Extension returns: ");
           console.log(data);
           console.log(this.LOAccount_Extension.getItems());
       });*/
       this.setViewFilterOptions();
        me.serializeUI();
        me.loadGrid();

    },

    afterInstantiate: function() {
        this.postLoad();
    },

    updateFilterView: function(uiView) {
        var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
        var filterCriteria = loView.FilterCriteria;
        if (uiView != null) { //If it is null we maintain an empty initial view (user clicked the Continue Anyways button)
            filterCriteria.timefilter.datefrom= new Date(uiView.DateFrom);
            filterCriteria.timefilter.datethru= new Date(uiView.DateThru);
            ['accountfilter','productfilter'].forEach(c => {
                var uiCriteria = uiView[c];
                var viewCriteria = filterCriteria[c];
                uiCriteria.forEach(field => {
                    viewCriteria[field.fieldId] = _.filter(field.values, { Selected: true }).reduce((r, v) => {
                        r.push(v.Id);
                        return r;
                    }, []);
                });
            });
        }
        //Reload the Grid

    },
    getFilterCriteria: function() {

        var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
        var filterCriteria = AppContext.get('FilterCriteria');
        if (filterCriteria == null) {
            filterCriteria = loView.FilterCriteria;
        } else {
           filterCriteria.timefilter= loView.FilterCriteria.timefilter
        }

        return {
            timefilter:
            {
                datefrom: Utils.Converters.Date2TS( filterCriteria.timefilter.datefrom),
                datethru:Utils.Converters.Date2TS( filterCriteria.timefilter.datethru)
            },
            accountfilter:{
                account:filterCriteria.accountfilter.account_id__c
            },
            productfilter:filterCriteria.serialzeProductFilter

        }


    },
    loadGrid: function(Manual_Calculation_Input) {
        var criteria = JSON.stringify(this.getFilterCriteria()),
            metadata = this.LOExtMeasure.apex_getMeta(criteria).then(getData),
            data = this.LOExtMeasure.apex_getData(criteria).then(getData),
            measures = metadata.then( metadata => metadata.measures.filter(filterMeasures).map(mapMeasures) ),
            labels = measures.then( measures => APEXAbstraction.readCustomLabels(measures) ).then(getLabelsData, getLabelsData);

        function getData(response){
            if(!response.__Status) throw response;
            return response.data;
        }

        function filterMeasures(measure){
            return measure.display && measure.display.enabled;
        }

        function mapMeasures(measure){
            var prefix = '';

            // if (ACSFNamespace) prefix = ACSFNamespace+'.';
            // if (measure.customized) prefix = '';

            return prefix + measure.name;
        }

        function getLabelsData(response){
            return response.data || {};
        }
        var initTime=new Date();
        when.all([metadata, data]).then( ([metadata, data]) =>
            when.all([
                this.tree.init(metadata, ("string" == typeof data) ? JSON.parse(data) : data, Manual_Calculation_Input),
                labels
            ])
        ).then(


            // Success

            ( [treeData, labels] ) =>
            {
                 var finalTime = new Date();
            console.error(" TIME GRID:"+((finalTime-initTime))+ " ms" );
                 UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
                treeData: treeData,
                idToLabelMapping: labels,
                newTree: true
                });

            },

            // Error

            error => UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                title: 'Error loading grid',
                message: 'Error occurred, please contact the administrator.',
                type: 'E'
            })

        );

    },

    setViewFilterOptions: function(tree) {
        //Let's establish the metadata:
        this.filterMeta = {
            DateFrom: {
                label: 'Date From',
                type: 'date'
            },
            DateThru: {
                label: 'Date Thru',
                type: 'date'
            },
            KPISet: {
                label: 'KPI Set',
                type: 'picklist',
                getPicklistValues:()=>  [ //TODO: MOVE to new LO
                    { value: 1, label: 'KAM' },
                    { value: 2, label: 'Finance' },
                    { value: 3, label: 'Broker' },
                    { value: 4, label: 'Retailer' },

                ]
            },
            ProductLevel: {
                label: 'Product Level',
                type: 'picklist',
                getPicklistValues:()=> [ //TODO: MOVE to new LO
                    { value: 1, label: 'SKU' },
                    { value: 2, label: 'Other' },
                    { value: 3, label: 'Another option' }


                ]
            },
            TimeBlock: {
                label: 'Time Blocks',
                type: 'picklist',
               getPicklistValues:()=>  [ //TODO: MOVE to new LO
                    { value: 'week', label: 'Weeks' },
                    { value: 'month', label: 'Months' },
                    { value: 'quarter', label: 'Quarters' },
                    { value: 'year', label: 'Years' }


                ]
            }
        };


        //Default values:
        var filterCriteria = this.getFilterCriteria();
        this.displayFilterCriteria = {
            kpisetdisplayfilter: {
                kpiset: 1
            },
            timeleveldisplayfilter: {
                timelevel: "month"
            },
            productleveldisplayfilter: {
                productlevel: 1
            }
        }

        this.serializeUI();
    },

    serializeUI: function() {
        var me = this;
        var loView = _.find(this.LOView.getAllItems(), 'IsDefault');

        var filterCriteria =loView.FilterCriteria

        var serialzeProductFilter = function(fieldId) {
            return {
                fieldId: fieldId,
                label: _.find(me.LOExtPrdFilters.getAllItems(), { filterId: fieldId }).filterLabel,
                values: _.filter(me.LOExtPrdFilters.getAllItems(), { filterId: fieldId }).reduce((result, item) => {
                    result.push({
                        Label: item.filterValueLabel,
                        Id: item.filterValueId,
                        Selected: (filterCriteria != null && filterCriteria.productfilter != null && filterCriteria.productfilter[fieldId] &&
                            filterCriteria.productfilter[fieldId].indexOf(item.filterValueId) != -1)
                    });
                    return result;
                }, [])
            }
        };

        var accountPlan = {
            _acl:this._status.ACL,
            showInitialSettings: (loView==null),
            isFilterSet: true,

            view: {
                _meta: {
                    Name: {
                        label: "List Name",
                        type: "string"
                    }
                },
                Id: loView.Id,
                Name: loView.Name
            },
            FilterCriteria: {
                accountfilter: [{
                    fieldId: 'account_id__c',
                    label: AppManager.getLabel("PC_LBL_CUSTOMER_NAME") || 'Customer name',
                    values: this.LOAccount.getAllItems().reduce((result, acc) => {
                        result.push({
                            Label: acc.Name,
                            Id: acc.Id,
                            Selected: (filterCriteria != null  && filterCriteria.accountfilter != null  &&filterCriteria.accountfilter.account_id__c.indexOf(acc.Id) != -1)
                        });
                        return result;
                    }, [])
                }],

                productfilter: [],





                DateFrom: filterCriteria.timefilter.datefrom,
                DateThru: filterCriteria.timefilter.datethru,

            },
            viewList: this.LOView.getAllItems().reduce((result, view) => {
                result.push({
                    Id: view.Id,
                    Name: view.Name,
                    Selected: view.IsDefault
                });
                return result;
            }, [])

        };


        accountPlan.FilterCriteria.productfilter.push(serialzeProductFilter('category__c'));
        if (me.filterMeta != null) {
            accountPlan.FilterCriteria._meta = me.filterMeta,
                accountPlan.FilterCriteria.KPISet = me.displayFilterCriteria.kpisetdisplayfilter.kpiset,
                accountPlan.FilterCriteria.ProductLevel = me.displayFilterCriteria.productleveldisplayfilter.productlevel,
                accountPlan.FilterCriteria.TimeBlock = me.displayFilterCriteria.timeleveldisplayfilter.timelevel
        }
        accountPlan.isFilterSet = _.some(accountPlan.FilterCriteria.accountfilter[0].values, { Selected: true }) ||

            _.some(accountPlan.FilterCriteria.productfilter[0].values, { Selected: true });



        UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
            accountplan: accountPlan
        });
    },

    onUIError: function (message) {
        this.modalMessages.push(message);
        AppManager.init().then( () => UI_EVENT_BUS.put(EVENTS.UI_BINDING, {modalMessages: this.modalMessages}) );
    },

    onDispatcher: function(payload) {
        var action = payload;
        var self = this;

        switch (action.actionType) {


            case AccountPlanActionConstants.CHANGE_FILTER:
                console.log('CHANGE_FILTER ');
                this.updateFilterView(action.payload);
                this.loadGrid();

                this.serializeUI();
                break;
            case AccountPlanActionConstants.CANCEL_CHANGE_FILTER:
                console.log('Cancel CHANGE_FILTER ');
                this.serializeUI();
                break;
            case AccountPlanActionConstants.GRID_EVENT:

                this.tree.update(action.payload).then( treeData =>
                    UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
                        treeData: treeData,
                        newTree: true
                    })
                );

                break;

            //LOView
            case AccountPlanActionConstants.ADD_VIEW:
                var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
                this.LOView.apex_create(JSON.stringify({'Name': action.payload})).then(result => {
                    if (result.__Status) {
                        result.data.objectStatus = STATE.NEW;
                        self.LOView.addItem(result.data);
                       self.serializeUI();
                    }
                });
                break;

            case AccountPlanActionConstants.COPY_VIEW:
             var loView = _.find(this.LOView.getAllItems(), 'IsDefault');

             var serializedView={
                    Description:loView.Description,
                    FilterCriteria:loView.FilterCriteria,
                    IsDefault:loView.IsDefault,
                    Name:action.payload
               }

             this.LOView.apex_create(JSON.stringify(serializedView)).then(result => {
                    if (result.__Status) {
                       result.data.objectStatus = STATE.NEW;
                        self.LOView.addItem(result.data);
                       self.serializeUI();
                    }
             });
               //TODO Copy View
              break;

            case AccountPlanActionConstants.RENAME_VIEW:
                var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
                 loView.Name =action.payload;
                 //vv   This should be done byt the serialize function  vvv
                var serializedView={
                    Description:loView.Description,
                    FilterCriteria:loView.FilterCriteria,
                    Id:loView.Id,
                    IsDefault:loView.IsDefault,
                    Name:loView.Name
                }

                this.LOView.apex_write(JSON.stringify(serializedView)).then(result => {
                     if (result) {

                        self.serializeUI();
                     }
                })

                break;

            case AccountPlanActionConstants.DELETE_VIEW:
                var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
                 this.LOView.apex_delete(loView.Id).then(result => {
                    if (result) {
                        _.remove(self.LOView.getAllItems(), loView);
                        if (self.LOView.getAllItems().length)
                            self.LOView.getAllItems()[0].IsDefault=true;
                         self.serializeUI();
                    }
                });

                break;

            case AccountPlanActionConstants.SELECT_VIEW:
                var loView = _.find(this.LOView.getAllItems(), 'IsDefault');
                loView.IsDefault=false;
                var selectedloView = _.find(this.LOView.getAllItems(), {'Id':action.payload});
                selectedloView.IsDefault=true;
                self.serializeUI();
                break;


        }
    }
};

module.exports = AccountPlan;
