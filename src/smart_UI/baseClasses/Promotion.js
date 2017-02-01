var Promotion = {
    /**
     * The onInstantiate function is call once when the BO is ready for user
     *
     * @param data - Empty in most circumstances
     * @returns {Promise[]} Array of promises created by asynchronous load of data
     */
    // Core functionality - DO NOT CHANGE THE CONTENT OF THIS FUNCTION DURING CUSTOMIZING!
    onInstantiate: function (data) {
        var me = this;
        var instantiatePromises = []; // when.defer();
        this.fluxHandler = UI_EVENT_BUS.subscribe(EVENTS.FLUX, this.onDispatcher.bind(this));
        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError.bind(this));
        this.Id = promotionId;

        instantiatePromises = this.preLoad();
        this.isEditable = false;
        this.editMode = false;

        return instantiatePromises;
    },
    /**
     * Load all data which must be available before the UI is rendered.
     * The promises as returned by this function are handled in a synchronous way. Only once all of them are resolved the system continues.
     * @returns {Promise[]} Array of promises created by asynchronous load of data
     */
    preLoad: function () {
        var me = this;
        var instantiatePromises = [];

        this.loadPhase = 'preload';
        instantiatePromises.push(this.load(promotionId, false));
        instantiatePromises.push(this.LOTactic.load(null));
        instantiatePromises.push(this.LOTactic_Template.load());
        instantiatePromises.push(this.LOPromotion_Template.load());
        instantiatePromises.push(this.LOAccount.load());
        //instantiatePromises.push(this.LOAccountSet.load());
        instantiatePromises.push(this.LOTacticProductFilter.load());

        // Reset the availability of the Chart controls after each load
        this.isKPIInvalid = false;

        return Utils.callCustomFunction(this, 'preLoad', null, instantiatePromises);
    },
    /**
     * Load all data which must be available before the UI is rendered.
     * The promises as returned by this function are handled in a synchronous way. Only once all of them are resolved the system continues.
     * @returns {Promise[]} Array of promises created by asynchronous load of data
     */
    postLoad: function () {
        var me = this;

        // Build JSON object of promotion content needed as parameter for APEX calls
        var promoObject = this.serializePromotion();

        // Remove all deleted tactics from the serialized LOTactic as they are not needed for these calls
        var tacticIdMap = this.LOTactic._hidden.idMapping;
        _.remove(promoObject.LOTactic, item => item.__ObjectStatus & STATE.DELETED);

        var template = _.find(this.LOPromotion_Template.getAllItems(), {Id: this.Promotion_Template__c});
        var chartPromise = (template && template.Calculation_Mode__c === 'Writeback') ? this.LOExtChartValues.load(null, promoObject) : true;

        // Callback executed once all tasks are done
        var onceDone = () => {
            this.loadPhase = 'postload';
            this.changeHandler();
            Utils.callCustomFunction(this, 'postLoad', null);
        };

        when.all([

            chartPromise,

            this.LOFund.load(null, promoObject),

            when.all([

                this.LOExtPrdFilters.load(function (data) {
                    me.LOExtProductFilter.addItems(me.getMergedProductFilters(me.LOTacticProductFilter, data));
                })

            ]).then(() =>
                this.LOExtProduct.apex_read(JSON.stringify(this.serializePromotion()))
            ).then(prods => {

                this.LOExtProduct.removeAllItems();

                if (prods.data) {
                    //temporary handling of 15 digit tactic id from product resolution
                    _.each(prods.data, function (p) {
                        if (p.Tactics != undefined) {
                            _.each(p.Tactics, function (t) {
                                t.tacticId = tacticIdMap[t.tacticId];
                            });
                        }
                    });

                    me.LOExtProduct.addItems(prods.data);
                    me.LOExtProduct.onLoad();
                }

            })

        ]).then(onceDone, onceDone);

        // Define event handler 
        // TODO: This should be obsolete and be done through the event bus
        this.setChangeHandler(function () {
            UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
                promotion: this.serializeTree(),
                productFilters: this.serializeProductFilters(),
                selectedTactic: this.serializeSelectedTactic()
            });
        });

        setTimeout(() => this.changeHandler(), 0);
    },

    /**
     * Anchor for the postLoad function
     * Content is moved to postLoad since it may be called several times which would not match the purpose of this function
     */

    afterInstantiate: function () {
        this.postLoad();
    },

    /**
     * Serialize the content of the promotion to be sent as parameter to an APEX method
     */
    serializeToAPEX: function () {
        return this.serializePromotion();
    },

    /**
     * Serialize the content of the promotion to be sent as state to the React UI
     */
    serializeToUI: function () {
        return this.serializeTree();
    },
    /**
     * Serialize the content of the selected tactic to be sent as state to the React UI
     */
    serializeSelectedTacticToUI: function () {
        return this.serializeSelectedTactic();
    },
    updateTacticProductFilter: function (tacticID, extProductFilter) {
        var productfilter = {};

        var productFilter = this.LOTacticProductFilter.getAllItems().filter(item => item.tacticId == tacticID);
        if (productFilter.length > 0) {
            productfilter = productFilter[0].productfilter;
        }

        var criteria = {};
        productfilter.criteria = criteria;
        _.each(extProductFilter, function (filter) {
            if (filter.selected) {
                if (criteria[filter.filterId] === undefined) criteria[filter.filterId] = [];
                criteria[filter.filterId].push(filter.filterValueId);
            }
        });

        _.find(this.LOTacticProductFilter.getAllItems(), {tacticId: tacticID}).productfilter = productfilter;
        _.find(this.LOTactic.getItems(), {Id: tacticID}).objectStatus |= STATE.DIRTY;
        return productfilter;
    },

    getDurationInWeeks: function () {
        var duration = Utils.Converters.Date2TS(this.Date_Thru__c) - Utils.Converters.Date2TS(this.Date_From__c);
        var weekDuration = 7 * 24 * 60 * 60000;
        return Math.floor(duration / weekDuration) + ' weeks';
    },
    /**
     * Internal implementation of the serialization to APEX. Is called and customized through serializeToAPEX
     * @returns {JSON} Serialized version for the BO as required by the APEX layer
     */


    serializePromotion: function () {
        var me = this;
        var saveObject = this.serialize();
        saveObject.Slogan_Language_1__c = saveObject.Slogan__c;
        saveObject.LOTactic = this.LOTactic.serialize();
        if (saveObject.LOTactic)
            saveObject.LOTactic.forEach(tactic => {
                var productFilter = me.LOTacticProductFilter.getAllItems().filter(item => item.tacticId == tactic.Id);
                if (productFilter.length > 0) {

                    tactic.productfilter = productFilter[0].productfilter;
                    if (productFilter[0].productfilter != undefined && productFilter[0].productfilter.manualproducts != undefined)
                        tactic.productfilter.manualproducts = productFilter[0].productfilter.manualproducts;
                }
                //added to handle the case when filter is undefined return empty filter.
                if (tactic.productfilter === undefined) {
                    tactic.productfilter = {};
                    tactic.productfilter.criteria = {};
                    tactic.productfilter.manualproducts = null;
                }
                tactic.Pct_of_Stores__c = parseFloat(tactic.Pct_of_Stores__c);
                tactic.Amount__c = parseFloat(tactic.Amount__c);
                tactic.Lift__c = parseFloat(tactic.Lift__c);
                // tactic.__ObjectStatus = me.LOTactic.getAllItems().find(item => item.Id == tactic.Id).getObjectStatus();
                tactic.__ObjectStatus = _.find(me.LOTactic.getAllItems(), {Id: tactic.Id}).getObjectStatus();
            });
        saveObject.LOExtPromotionAttachment = SerializationHelper.serializeWithStatus(this.LOExtPromotionAttachment);
        // We do not get a state for the tactic relation of a fund. This is because of the LO structure (tactic
        // is array in LI). The APEX controller needs to take care of that.
        saveObject.LOFund = this.LOFund.serialize() || {};
        if (saveObject.LOFund)
            saveObject.LOFund.forEach(fund => {
                var tactics;
                me.LOFund.getAllItems().forEach(function (f) {
                    if (f.Id === fund.Id)
                        tactics = f.Tactics;

                });
                if (tactics != undefined) {
                    fund.tactics = tactics;
                }
                if (fund.tactics === undefined) {
                    fund.tactics = [];
                }
            });
        return {"BOPromotion": Utils.callCustomFunction(this, 'serializeToAPEX', null, saveObject)};
    },
    /**
     * getMergedProductFilters
     * @param {model} loTactic - Representation of the tactic LO
     * @param {JSON} extPrdFilters - Product filters
     */
    getMergedProductFilters: function (loTactic, extPrdFilters) {
        var extProductFilters = [];
        var me = this;
        if (loTactic) {
            var dictIncludedTactics = {};
            _.each(loTactic.getAllItems(), function (tactic) {
                extProductFilters = me.getMergedProductFilterForTactic(tactic, extPrdFilters, extProductFilters);
                dictIncludedTactics[tactic.tacticId] = "";

            });

            //below code won't be necessary if all tactics get atleast null productfilter defined.
            _.each(this.LOTactic.getAllItems(), function (tactic) {
                if (dictIncludedTactics[tactic.Id] == undefined)
                    extProductFilters = me.getMergedProductFilterForTactic(tactic, extPrdFilters, extProductFilters);
            });
        }
        return extProductFilters;
    },

    getMergedProductFilterForTactic: function (tactic, extPrdFilters, currentFilters) {
        var map = {};
        if (tactic.productfilter) {
            var criteria = tactic.productfilter.criteria;
            for (var key in criteria) {
                map[key] = {};
                _.each(criteria[key], function (selected) {
                    map[key][selected] = "True"
                });
            }
        }
        _.each(extPrdFilters.getAllItems(), function (f) {
            var extPrdFilter = _.clone(f);
            extPrdFilter["tacticId"] = (tactic.Id != undefined) ? tactic.Id : tactic.tacticId;
            if (map[extPrdFilter.filterId] && map[extPrdFilter.filterId][extPrdFilter.filterValueId])
                extPrdFilter["selected"] = true;
            else
                extPrdFilter["selected"] = false;
            currentFilters.push(extPrdFilter);
        });
        return currentFilters;
    },
    /**
     * Saves the BO to the SF backend. Does not leave the edit mode!
     */
    save: function () {
        console.log('PERFORMED ACTION SAVE PROMOTION');
        var saveObject = this.serializePromotion();
        this.apex_write(this.getIdValue(), JSON.stringify(saveObject)).then(saveResult => {
            // TODO: Use correct event bus here! This is just dummy code
            if (saveResult.__Status) {
                // Send event to UI that save has succeeded and appropriate action can be done
                console.log('Save of data succeeded!');
                UI_EVENT_BUS.put(EVENTS.BO_SAVE_SUCCEEDED);
            } else {
                // Error during saving. Edit mode should not be closed and user needs to be informed!
                console.log('Save of data failed!', saveResult.ExceptionType, saveResult.ExceptionMessage, saveResult.ExceptionWhere);
                UI_EVENT_BUS.put(EVENTS.BO_SAVE_FAILED, saveResult);
            }
        });
    },
    /**
     * Save the promotion to SF calling writeBOPromotion. The BO will then be reloaded and the UI newly rendered with the loaded content.
     * The edit mode is NOT left by this function
     */
    saveAndRefresh: function () {
        console.log('PERFORMED ACTION SAVE PROMOTION');
        var saveObject = this.serializePromotion();
        var promoId = this.getId();
        saveObject.target = "Salesforce";
        this.apex_write(this.getIdValue(), JSON.stringify(saveObject)).then(saveResult => {
            // TODO: Use correct event bus here! This is just dummy code
            if (saveResult.__Status) {
                // Send event to UI that save has succeeded and appropriate action can be done
                console.log('Save of data succeeded!');
                //trigger save to heroku
                saveObject.target = "WebService";
                this.apex_write(this.getIdValue(), JSON.stringify(saveObject));
                this.refreshPromotion();

                UI_EVENT_BUS.put(EVENTS.BO_SAVE_SUCCEEDED);
            } else {
                // Error during saving. Edit mode should not be closed and user needs to be informed!
                console.log('Save of data failed!', saveResult.ExceptionType, saveResult.ExceptionMessage, saveResult.ExceptionWhere);
                // this.refreshPromotion(); //refresh anyway
                //don't refresh promotion stay in edit mode'
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {enableToolbar: true, editMode: true});
                UI_EVENT_BUS.put(EVENTS.BO_SAVE_FAILED, saveResult);
            }
        });
    },
    /**
     * Returns all products for a given tactic
     */
    getProductsForTacticID: function (tacticID, relation) {
        return _.filter(this.LOExtProduct.getAllItems(), function (product) {
            if (relation != null) {
                return _.find(product.Tactics, {tacticId: tacticID, relationship: relation})
            } else
                return _.find(product.Tactics, {tacticId: tacticID})
        });
    },

    addTactic: function (tacticTemplate) {
        this.logger.info('PERFORMED ADD TACTIC WITH TACTIC TEMPLATE ' + tacticTemplate);

        var saveObject = {'BOPromotion': this.serialize(), 'Tactic_Template_Id__c': tacticTemplate.Id};
        saveObject = Utils.callCustomFunction(this, 'addTactic', 'beforeAPEX', saveObject);

        var me = this;
        this.LOTactic.apex_create(JSON.stringify(saveObject)).then(createResult => {
            if (createResult.__Status) {
                createResult.data = Utils.callCustomFunction(this, 'addTactic', 'afterAPEX', createResult.data);
                createResult.data.objectStatus = STATE.NEW;
                me.LOTactic.addItem(createResult.data);
                //addtactic to LOTacticProductFilter
                var tacticFilter = {
                    tacticId: createResult.data.Id,
                    productfilter: {criteria: {}, manualproducts: null}
                };
                me.LOTacticProductFilter.addItem(tacticFilter);
                me.LOTactic.onLoad(); //added for tacticId handling
                // this.LOTacticProductFilter.addItem({tacticId:createResult.data.Id, productfilter={}});
                var loExtProductFilters = [];
                //load filters again
                loExtProductFilters = this.getMergedProductFilterForTactic(createResult.data, this.LOExtPrdFilters, loExtProductFilters);

                this.LOExtProductFilter.addItems(loExtProductFilters);

                this.setFilter(tacticFilter.tacticId);
                var tacticItem = this.serializeSelectedTactic();
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {selectedItem: tacticItem});
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {selectedNode: tacticItem});
                Utils.callCustomFunction(this, 'addTactic', 'post', saveObject);
                this.changeHandler();

            } else {
                // Error during tactic creation. The user needs to be informed!
                console.log('Create of a new tactic failed!', saveResult.ExceptionType, saveResult.ExceptionMessage, saveResult.ExceptionWhere);
                UI_EVENT_BUS.put(EVENTS.BO_TACTIC_CREATE_FAILED, saveResult);
            }
        });
    },
    /**
     * Logically deletes a selected tactic from LOTactic. The actual deletion only happens when the BO is saved
     * @param {string} tacticID - Id of the tactic to be deleted
     */
    deleteTactic: function (tacticID) {
        console.log("PERFORMED ACTION DELETE TACTIC FOR TACTIC ID:" + tacticID);
        // Current tactic is selected. GetItems() only returns one record!
        this.LOTactic.getItems()[0].setObjectStatus(STATE.DELETED);

        this.resetAllFilters();
        this.changeHandler();
    },

    duplicateTactic: function (tacticID) {
        var promoObject = this.serializePromotion();
        var me = this;
        promoObject.Tactic__c = tacticID;
        this.LOTactic.apex_copy(JSON.stringify(promoObject)).then(copyResult => {
            if (copyResult.__Status) {
                copyResult.data.objectStatus = STATE.NEW;

                //addtactic to LOTacticProductFilter
                var tacticFilter = {
                    tacticId: copyResult.data.Id,
                    productfilter: _.clone(this.LOTacticProductFilter.getItems()[0].productfilter)

                };
                copyResult.data.productfilter = tacticFilter.productfilter;
                this.LOTactic.addItem(copyResult.data);
                this.LOTacticProductFilter.addItem(tacticFilter);

                this.LOTactic.onLoad(); //added for tacticId handling
                // this.LOTacticProductFilter.addItem({tacticId:createResult.data.Id, productfilter={}});
                var loExtProductFilters = [];
                //load filters again
                loExtProductFilters = this.getMergedProductFilterForTactic(copyResult.data, this.LOExtPrdFilters, loExtProductFilters);

                this.LOExtProductFilter.addItems(loExtProductFilters);

                this.setFilter(tacticFilter.tacticId);
                var tacticItem = this.serializeSelectedTactic();
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {selectedItem: tacticItem});
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {selectedNode: tacticItem});
                this.changeHandler();

                console.log('PERFORMED ACTION DUPLICATE TACTIC FOR TACTIC ID:', tacticID);
            }
            else {
                console.log('Duplicate tactic', tacticID, 'failed. APEX RemoteAction returned no data.');
            }
        });
    },
    /**
     * Helper function to reset the LO filters possibly set by user actions
     */
    resetAllFilters: function () {
        this.LOTactic.resetAllFilters();
        this.LOExtProductFilter.resetAllFilters();
        this.LOExtProduct.resetAllFilters();
        this.LOFund.resetAllFilters();
        this.LOTacticProductFilter.resetAllFilters();
    },
    /**
     * Helper function called when the user selects a tactic in the drilldown control.
     * The system sets filters on all relevant LOs to ensure that the right data is displayed
     *  @param {string} id - Id of the tactic to be filtered on
     */
    setFilter: function (id) {
        this.LOTactic.setFilter('Id', id, 'EQ');
        this.LOExtProductFilter.setFilter('tacticId', id, 'EQ');
        this.LOExtProduct.setFilter('Tactics', '{"Field": "tacticId", "Value":"' + id + '"}', 'CONTAINS');
        this.LOFund.setFilter('Tactics', '{"Field": "tacticId", "Value":"' + id + '"}', 'CONTAINS');
        this.LOTacticProductFilter.setFilter('tacticId', id, 'EQ');
    },
    /**
     * Helper function called when the user applies a product filter in the manage products dialog.
     * The system makes a callout to SF to get the corresponding list of products from the backend
     * @param {string} tacticID - Id of the active tactic
     * @param {string} productFilter - Product filter selected by the user
     */
    applyProductFilter: function (tacticID, productFilter) {
        this.updateTacticProductFilter(tacticID, productFilter);
        var promoObject = this.serializePromotion();
        _.remove(promoObject.LOTactic, item => item.__ObjectStatus & STATE.DELETED);
        var tacticIdMap = this.LOTactic._hidden.idMapping;
        this.LOExtProduct.apex_read(JSON.stringify(promoObject)).then(prods => {
            this.LOExtProduct.removeAllItems();
            if (prods.data) {
                _.each(prods.data, function (p) {
                    if (p.Tactics != undefined) {
                        _.each(p.Tactics, function (t) {
                            t.tacticId = tacticIdMap[t.tacticId];
                        });
                    }
                });
                this.LOExtProduct.addItems(prods.data);
                this.LOExtProduct.onLoad();
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {productFilters: this.serializeProductFilters()});
                console.log('PERFORMED ACTION APPLY FILTER TACTIC FOR TACTIC ID:', tacticID);

            }
        });
    },

    toggleTacticProductFilter: function (filterID, filterValueID, tactic, selected) {
        console.log("PERFORMED ACTION Toggle FILTER TACTIC FOR TACTIC ID:" + tactic.Id);
        _.find(this.LOExtProductFilter.getItems(), {
            tacticId: tactic.Id,
            filterId: filterID,
            filterValueId: filterValueID
        }).selected = selected;
    },
    /**
     * Refreshes the content of the bo WITHOUT saving any possibly changed content
     * @param {any} context - Decision on which context the UI recides on
     */
    refreshPromotion: function (context) {
        var refreshGrid = false;
        if (context && context === "tree") refreshGrid = true;
        var me = this;
        this._hidden.lists.forEach(id => {
            me[id].removeAllItems();
        });
        var promises = this.preLoad();
        when.all(promises).then(function (dataArray) {
            if (me.onLoad) me.onLoad(); // Internal callback
            me.postLoad();     //post laod
            me.loadGrid(JSON.parse(me.getManual_Calculation_Input__c()));
            //reset all filters and get back to promotion
            me.resetAllFilters();
            //enable toolbar.
            UI_EVENT_BUS.put(EVENTS.UI_BINDING, {enableToolbar: true});
        });
    },

    addProductsFilter: function (tacticID, products) {
        console.log('ADD_PRODUCTS');

        //Let's update the tactic productFilter
        if (tacticID == this.LOTacticProductFilter.getItems()[0].tacticId) {
            //Let's update the tactic productFilter
            _.find(this.LOTactic.getItems(), {Id: tacticID}).objectStatus |= STATE.DIRTY;
            var productfilter = this.LOTacticProductFilter.getItems()[0].productfilter;
            if (!productfilter.manualproducts) productfilter.manualproducts = [];
            products.map((prod) => {
                var manualProd = _.find(productfilter.manualproducts, {productid: prod.Id});
                if (manualProd) {
                    manualProd.included = true;
                } else {
                    productfilter.manualproducts.push({productid: prod.Id, included: true});
                }
            });
        }

        //Now let's update the LOExtProduct
        products.map((prod) => {
            var existingProduct = this.LOExtProduct.getItemById(prod.Id);
            if (existingProduct) {
                //Update relationship
                var tacticRelation = _.find(existingProduct.Tactics, {tacticId: tacticID})
                if (tacticRelation) {
                    tacticRelation.relationship = 'INCLUDED';
                } else {
                    existingProduct.Tactics.push({
                        tacticId: tacticID,
                        relationship: 'INCLUDED'
                    });
                }
            } else {
                //Add new LOExtProduct
                var prodData = {
                    Category: prod.Category__c,
                    Container_Size_Unit: prod.Container_Size_Unit__c,
                    Container_Size: prod.Container_Size__c,
                    Container_Type: prod.Container_Type__c,
                    Criterion_3_Product_Code: prod.Criterion_3_Product_Code__c,
                    Criterion_3_Product_Description: prod.Criterion_3_Product_Description__c,
                    Description_1: prod.Description_1__c,
                    Id: prod.Id,
                    Name: prod.Name,
                    Pack_Size_Unit: prod.Pack_Size_Unit__c,
                    Pack_Size: prod.Pack_Size__c,
                    Short_Description: prod.Short_Description__c,
                    ProductGroupId: 'TO BE DONE',
                    ProductGroupDescription: 'TO BE DONE',
                    Tactics: [
                        {
                            tacticId: tacticID,
                            relationship: 'INCLUDED'
                        }
                    ]
                };
                this.LOExtProduct.addItems([prodData]);
            }
        });
        this.changeHandler();
    },

    searchForProducts: function (productSample) {
        console.log('searchForProducts'); //TODO Call APEX Controller

        if (productSample === null)
            productSample = {};
        var promoContent = this.serializePromotion();
        promoContent.filterExpressions = productSample;

        this.LOFilteredProducts.apex_read(JSON.stringify(promoContent)).then(productList => {
            UI_EVENT_BUS.put(EVENTS.UI_BINDING, {productSearch: productList.data});
            this.LOFilteredProducts.removeAllItems();
            this.LOFilteredProducts.addItems(productList.data);
        });
    },
    /**
     * Add a fund to the LO. The system checks if there is already a relation to this fund.
     * If yes, then it will be added, otherwise it is updated
     * @param {Array} funds - List of fund to be added
     * @param {string} tacticId - Id of the tactic to which the funds should be added
     */
    addFunds: function (funds, tacticId) {
        funds.map((fund) => {
            var existingFund = this.LOFund.getItemById(fund.Id);
            if (existingFund) {
                if (existingFund.objectStatus === STATE.DELETED) {
                    existingFund.objectStatus = STATE.PERSISTED;
                    existingFund.Tactics = [{
                        'tacticId': tacticId
                    }];
                }
                else {
                    existingFund.Tactics.push({'tacticId': tacticId});
                }
                this.LOFund.applyFilters();
            }
            else {
                fund.Tactics = [{
                    'tacticId': tacticId
                }];
                this.LOFund.addItem(fund);
            }
        });
    },

    deleteFunds: function (fundsId, tacticId) {
        fundsId.forEach((fundId) => {
            var loFund = _.filter(this.LOFund.getItems(), fund => fund.Id === fundId)[0]; //  this.LOFund.getItemById(fundId);
            _.remove(loFund.Tactics, {'tacticId': tacticId});
            if (loFund.Tactics.length > 0) {
                this.LOFund.applyFilters();
            } else {
                loFund.setObjectStatus(STATE.DELETED);
            }
        });
    },

    getProductGroupsForTacticID: function (tacticID) {
        var productsForTactic = this.getProductsForTacticID(tacticID);
        return _.uniqBy(productsForTactic, 'ProductGroupDescription');
    },

    serializeTree: function () {
        var me = this;
        var promotionJSON = {
            _meta: this.getSfMeta(),
            _acl: this.getACL(),
            type: 'PROMOTION',
            desc: AppManager.getLabel('PP_TIT_PROMO_SUMMARY') || 'Promotion Summary',//TODO:TRANSLATE
            Date_From__c: new Date(this.Date_From__c),
            Date_Thru__c: new Date(this.Date_Thru__c),
            Placement_Date_From__c: new Date(this.Placement_Date_From__c),
            Placement_Date_Thru__c: new Date(this.Placement_Date_Thru__c),
            Order_Date_From__c: new Date(this.Order_Date_From__c),
            Order_Date_Thru__c: new Date(this.Order_Date_Thru__c),
            Delivery_Date_From__c: new Date(this.Delivery_Date_From__c),
            Delivery_Date_Thru__c: new Date(this.Delivery_Date_Thru__c),
            Commit_Date__c: new Date(this.Commit_Date__c),
            duration: this.getDurationInWeeks(),
            Active__c: this.Active__c,
            tacticTemplates: this.LOTactic_Template.getAllItems(),
            Id: this.Id,
            Phase__c: this.Phase__c,
            Slogan__c: this.Slogan__c,
            Manual_Calculation_Input__c: JSON.parse(this.Manual_Calculation_Input__c),
            AggregatedKPIs: {
                roi_actual: 0,
                roi_planned: 0,
                costs_actual: 0,
                costs_planned: 0
            },
            isKPIInvalid: this.isKPIInvalid,//How to map it??
            children: []
        };
        //Editable function
        promotionJSON.isEditable = this.getACL().isEditable(0, "Promotion__c");
        //promotionJSON.isEditable = this.isEditable;
        //Adding the promotion Template
        var template = _.find(this.LOPromotion_Template.getAllItems(), {Id: this.Promotion_Template__c});
        promotionJSON.Promotion_Template__c = (template) ? template.Description__c : '';
        //Adding the promotion Account
        var account = _.find(this.LOAccount.getAllItems(), {Id: this.Anchor_Account__c});
        promotionJSON.Anchor_Account__c = (account) ? account.Name : '';
        var accountSet = _.find(this.LOAccountSet.getAllItems(), {Id: this.Anchor_Account_Set__c});
        promotionJSON.Anchor_Account_Set__c = (accountSet) ? accountSet.Description__c : '';
        //Adding the KPIs
        _.filter(this.LOExtChartValues.getAllItems(), {'id': promotionJSON.Id, 'level': 'measures'}).map((KPI) => {
            promotionJSON.AggregatedKPIs[KPI.kpiId] = KPI.value;
        });
        this.LOTactic.getAllItems().map((tactic) => {
            if (tactic.getObjectStatus() !== STATE.DELETED) {
                var tacticJSON = {
                    _meta: tactic.getSfMeta(),
                    type: 'TACTIC',
                    Amount__c: tactic.getAmount__c(),
                    Date_From__c: tactic.getDate_From__c(),
                    Date_Thru__c: tactic.getDate_Thru__c(),
                    Shipment_Date_From__c: tactic.getShipment_Date_From__c(),
                    Shipment_Date_Thru__c: tactic.getShipment_Date_Thru__c(),
                    Compensation_Model__c: tactic.getCompensation_Model__c(),
                    Tactic_Template__r: '',
                    Id: tactic.getId(),
                    Lift__c: tactic.getLift__c(),
                    Name: tactic.getName(),
                    Pct_of_Stores__c: tactic.getPct_of_Stores__c(),
                    Payment_Method__c: tactic.getPayment_Method__c(),
                    children: []
                };
                var ttemplate = _.find(this.LOTactic_Template.getAllItems(), {Id: tactic.Tactic_Template__c});
                tacticJSON.Tactic_Template = (ttemplate) ? ttemplate.Description__c : '';

                var products = me.getProductsForTacticID(tactic.Id, 'MATCH').concat(me.getProductsForTacticID(tactic.Id, 'INCLUDED'));

                var productGroups = _.uniqBy(products, 'ProductGroupDescription');
                productGroups.map((pg) => {
                    var productGroup = {
                        Name: pg.ProductGroupDescription,
                        Id: pg.ProductGroupId,
                        type: 'CATEGORY',
                        children: []
                    };
                    var productsPerPG = _.filter(products, {ProductGroupDescription: pg.ProductGroupDescription});
                    productsPerPG.map((prod) => {
                        var product = {
                            Id: prod.Id,
                            Name: prod.Description_1,
                            type: 'PRODUCT'
                        };
                        productGroup.children.push(product);
                    });
                    tacticJSON.children.push(productGroup);
                });
                promotionJSON.children.push(tacticJSON);
            }
        });
        return Utils.callCustomFunction(this, 'serializeToUI', null, promotionJSON);
    },

    serializeSelectedTactic: function () {
        if (this.LOTactic._filters.length > 0 && this.LOTactic.getItems().length > 0) {
            var tactic = this.LOTactic.getItems()[0];
            var tacticJSON = {
                _meta: tactic.getSfMeta(),
                type: 'TACTIC',
                Amount__c: tactic.getAmount__c(),
                Date_From__c: tactic.getDate_From__c(),
                Date_Thru__c: tactic.getDate_Thru__c(),
                Shipment_Date_From__c: tactic.getShipment_Date_From__c(),
                Shipment_Date_Thru__c: tactic.getShipment_Date_Thru__c(),
                Instore_Date_From__c: tactic.getInstore_Date_From__c(),
                Instore_Date_Thru__c: tactic.getInstore_Date_Thru__c(),
                Compensation_Model__c: tactic.getCompensation_Model__c(),
                Payment_Method__c: tactic.getPayment_Method__c(),
                Tactic_Template__r: '',
                Id: tactic.getId(),
                Lift__c: tactic.getLift__c(),
                Name: tactic.getName(),
                Pct_of_Stores__c: tactic.getPct_of_Stores__c(),
                AggregatedKPIs: {
                    roi_actual: 0,
                    roi_planned: 0,
                    costs_actual: 0,
                    costs_planned: 0
                },
                //isKPIInvalid: promotionJSON.isKPIInvalid,//How to map it??
                children: []
            };
            var ttemplate = _.find(this.LOTactic_Template.getAllItems(), {Id: tactic.Tactic_Template__c});
            tacticJSON.Tactic_Template__c = (ttemplate) ? ttemplate.Description__c : '';

            tacticJSON.funds = this.LOFund.getItems();
            tacticJSON.AvailableFunds = _.differenceBy(this.LOFilteredFunds.getAllItems(), this.LOFund.getItems(), 'Id');
            tacticJSON._acl = this.LOTactic.getACL();
            //Adding the KPIs
            _.filter(this.LOExtChartValues.getAllItems(), {'id': tacticJSON.Id, 'level': 'Tactic'}).map((KPI) => {
                tacticJSON.AggregatedKPIs[KPI.kpiId] = KPI.value;
            });
            return Utils.callCustomFunction(this, 'serializeSelectedTacticToUI', null, tacticJSON);
        } else {
            return null;
        }
    },
    loadGrid: function (Manual_Calculation_Input) {
        var me = this;
        me.LOExtPromotionGrid.apex_getMeta(JSON.stringify(this.serializePromotion())).then(metaData => {

            if (metaData.data) {
                APEXAbstraction.readCustomLabels(metaData.data.measures.reduce((result, v) => {

                    if (v.display && v.display.enabled) {
                        var prefix = '';
                        //   if (ACSFNamespace) prefix = ACSFNamespace+'.';
                        // if (v.customized) prefix = '';

                        result.push(prefix + v.name);

                    }
                    return result;
                }, [])).then(function (readCustomLabelsResult) {
                    if (readCustomLabelsResult.__Status && readCustomLabelsResult.data) {
                        var kpiLabels = readCustomLabelsResult.data;
                        me.LOExtProduct.addLabels(kpiLabels);
                    }

                });
            }

            var errorHappened = false;
            try {
                if (metaData.__Status) {
                    metaData = metaData.data;
                    me.LOExtPromotionGrid.apex_getData(JSON.stringify(me.serializePromotion())).then(data => {
                        if (data.__Status) {
                            data = data.data;
                            /**CAUTION: We are sending a functional object instead of only data. In a multithread environment this won't work*/
                            var tree = Tree.instantiate(("string" == typeof data) ? JSON.parse(data) : data, metaData, metaData.variables, Manual_Calculation_Input);
                            UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
                                tree: tree,
                                idToLabelMapping: this.LOExtProduct._hidden.idToLabelMapping
                            });
                        }

                    });
                } else {
                    errorHappened = true;
                    LogManager.getLogger('PromotionPlanning').error('Status of the metaData JSON is false');
                }

            } catch (e) {
                errorHappened = true;
                LogManager.getLogger('PromotionPlanning').error(e.message);
            }
            if (errorHappened) {
                UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                    title: 'Error loading grid',
                    message: 'Error occurred, please contact the administrator.',
                    type: 'E'
                });

            }
        });

    },
    serializeProductFilters: function () {
        //Hardcoded for the moment
        var tacticID = null
        if (this.LOTactic._filters.length > 0 && this.LOTactic.getItems().length > 0) {
            tacticID = this.LOTactic.getItems()[0].Id;
        } else {
            return null;
        }
        var productFilters = [];
        this.LOExtProductFilter.getItems().map((prodFilter) => {
            productFilters.push({
                filterId: prodFilter.filterId,
                filterLabel: prodFilter.filterLabel,
                filterValueId: prodFilter.filterValueId,
                filterValueLabel: prodFilter.filterValueLabel,
                selected: prodFilter.selected,
                tacticId: prodFilter.tacticId
            })
        });

        var products = this.LOExtProduct.getItems();
        products.map((pd) => {
            pd.relationship = _.find(pd.Tactics, {tacticId: tacticID}).relationship
        });
        products = _.orderBy(products, 'relationship', 'desc');
        return {
            productMetadata: this.LOFilteredProducts.itemType.prototype.getSfMeta(),
            filters: productFilters,
            products: products
        };
    },
    onUIError: function (message) {
        this.modalMessages.push(message);
        AppManager.init().then(() => UI_EVENT_BUS.put(EVENTS.UI_BINDING, {modalMessages: this.modalMessages}));
    },
    onDispatcher: function (payload) {
        var action = payload;
        var me = this;
        switch (action.actionType) {
            case PromotionActionConstants.PROMOTION_LOAD:
                this.load(this.Id);
                break;
            case PromotionActionConstants.PROMOTION_LOAD_GRID:
                this.loadGrid(action.payload.Manual_Calculation_Input);
                break;
            case PromotionActionConstants.PROMOTION_SAVE:
                this.editMode = false;
                this.saveAndRefresh();
                break;

            case PromotionActionConstants.PROMOTION_SAVE_AND_REFRESH :
                this.saveAndRefresh();
                break;
            case PromotionActionConstants.PROMOTION_EDIT:
                this.editMode = true;
                break;
            case PromotionActionConstants.PROMOTION_CANCEL:
                this.editMode = false;
                this.refreshPromotion(payload.Context);
                break;

            case PromotionActionConstants.PROMOTION_SET_FIELD:
                if (action.payload.Id == this.Id) {
                    var setter = this['set' + action.payload.fieldName];
                    if (setter) {
                        setter.call(this, action.payload.fieldValue);
                        if (this.editMode) this.isKPIInvalid = true;
                        this.changeHandler();
                    } else {
                        Log.error('No setter for field ' + action.payload.fieldName)
                    }
                }
                break;

            case PromotionActionConstants.TACTIC_SELECTED:
                if (action.payload == null) {
                    //PROMOTION SELECTED. Clear all filters
                    this.resetAllFilters();
                }
                else {
                    //TACTIC SELECTED. Filter related collections
                    this.setFilter(action.payload.Id);
                }
                this.changeHandler();
                break;

            case PromotionActionConstants.TACTIC_SET_FIELD:
                if (action.payload.Id == this.LOTactic.getItems()[0].Id) {
                    var tactic = this.LOTactic.getItems()[0];
                    var setter = tactic['set' + action.payload.fieldName];
                    if (setter) {
                        setter.call(tactic, action.payload.fieldValue);
                        this.changeHandler();
                    } else {
                        Log.error('No setter for tactic field ' + action.payload.fieldName)
                    }
                }
                break;

            case PromotionActionConstants.TACTIC_ADD:
                this.addTactic(action.payload);
                break;

            case PromotionActionConstants.TACTIC_DUPLICATE:
                this.duplicateTactic(action.payload);
                break;

            case PromotionActionConstants.TACTIC_DELETE:
                this.deleteTactic(action.payload);
                break;

            case PromotionActionConstants.APPLY_PRODUCT_FILTER:
                this.applyProductFilter(action.payload.tacticId, action.payload.productFilter);

                break;

            case PromotionActionConstants.SEARCH_FOR_PRODUCTS:
                this.searchForProducts(action.payload);
                break;

            case PromotionActionConstants.CLEAR_SEARCH_FOR_PRODUCTS:
                this.LOFilteredProducts.removeAllItems();
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {productSearch: []});
                break;

            case PromotionActionConstants.ADD_PRODUCTS:
                this.addProductsFilter(action.payload.tacticId, action.payload.products);
                break;

            case PromotionActionConstants.SEARCH_FOR_FUNDS:
                if (this.LOFilteredFunds.getCount() == 0) { //Just load funds once
                    this.LOFilteredFunds.apex_read(JSON.stringify(this.serializePromotion())).then(fundList => {
                        this.LOFilteredFunds.removeAllItems();
                        this.LOFilteredFunds.addItems(fundList.data);
                        this.changeHandler();
                    });
                }
                break;

            case PromotionActionConstants.ADD_FUNDS:
                this.addFunds(action.payload.funds, action.payload.tacticId);
                this.changeHandler();
                break;

            case PromotionActionConstants.DELETE_FUNDS:
                this.deleteFunds(action.payload.fundsId, action.payload.tacticId);
                this.changeHandler();
                break;

            case PromotionActionConstants.TOGGLE_TACTIC_PRODUCT_FILTER:
                this.toggleTacticProductFilter(action.payload.filterId, action.payload.filterValueId, action.payload.tactic, action.payload.selected);
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {productFilters: this.serializeProductFilters()});
                break;

            case PromotionActionConstants.CHANGE_TACTIC_PRODUCT_RELATIONSHIP:
                if (action.payload.tacticId == this.LOTacticProductFilter.getItems()[0].tacticId) {
                    //Let's update the tactic productFilter
                    _.find(this.LOTactic.getItems(), {Id: action.payload.tacticId}).objectStatus |= STATE.DIRTY;
                    var productfilter = this.LOTacticProductFilter.getItems()[0].productfilter;
                    if (!productfilter['manualproducts'])
                        productfilter.manualproducts = [];
                    if (action.payload.relationship == 'MATCH') {
                        productfilter.manualproducts.push({productid: action.payload.productId, included: false});
                    } else if (action.payload.relationship == 'EXCLUDED' || action.payload.relationship == 'INCLUDED') {
                        //Remove from collection
                        _.remove(productfilter.manualproducts, {productid: action.payload.productId});
                    }

                    //Now let's update the LOExtProduct
                    var product = _.find(this.LOExtProduct.getItems(), {Id: action.payload.productId});
                    var tactic_relationship = _.find(product.Tactics, {tacticId: action.payload.tacticId});
                    if (action.payload.relationship == 'MATCH') {
                        tactic_relationship.relationship = 'EXCLUDED'
                    } else if (action.payload.relationship == 'EXCLUDED') {
                        tactic_relationship.relationship = 'MATCH'
                    } else if (action.payload.relationship == 'INCLUDED') {
                        tactic_relationship.relationship = 'DELETED'
                    }
                }
                console.log('CHANGE_TACTIC_PRODUCT_RELATIONSHIP');
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {
                    promotion: this.serializeTree(),
                    selectedTactic: this.serializeSelectedTactic(),
                    productFilters: this.serializeProductFilters()
                });
                break;
            default:
                Utils.callCustomFunction(this, 'onDispatcher', null, action);
                break;
        }
    }
};

module.exports = Promotion;
