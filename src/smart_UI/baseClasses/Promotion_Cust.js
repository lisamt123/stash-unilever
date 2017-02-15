var Promotion_Cust = {
    /**
     * Customize extension to the core preLoad function. Will be called at the end of the core method.
     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
     * @returns {promise[]} Array of promises adapted in customizing
     */
    preLoad: function (instantiatePromises) {
        this.uploads = {};
        this.modalMessages = [];

        return instantiatePromises;
    },
    /**
     * Customize extension to the core postLoad function. Will be called at the end of the core method.
     * Input parameter is a list of promises of LOs which should be loaded. Can be extended or manipulated in this place.
     * @param {promise[]} instantiatePromises - Array of promises created by load actions done in core.
     * @returns {promise[]} Array of promises adapted in customizing
     */
    postLoad: function (instantiatePromises) {
        var promoObject = this.serializePromotion();
        for (let key of Object.keys(promoObject.BOPromotion)) if (key.match(/Promotion_ID__c$/)) delete promoObject.BOPromotion[key];
        for (let tactic of promoObject.BOPromotion.LOTactic) for (let key of Object.keys(tactic)) if (key.match(/Record_Link__c$/)) delete tactic[key];

        //PMA - START CODE - TPM-1498 - Audit Trail
        this.LOPromotionHistory.apex_read(this.getId()).then(line => {
            this.LOPromotionHistory.removeAllItems();
            this.LOPromotionHistory.addItems(line.data || []);
            this.changeHandler();
        });
        //PMA - END CODE - TPM-1498 - Audit Trail */

        this.LOExtChildAccounts.apex_read(JSON.stringify(
            AppManager.addACSFNamespace(promoObject)
        )).then(children => {
            this.LOExtChildAccounts.removeAllItems();
            this.LOExtChildAccounts.addItems(children.data || []);
            this.changeHandler();
        });

        this.LOExtPromotionAttachment.apex_read(this.getId())
            .then(attachments => {
                this.LOExtPromotionAttachment.addItems(
                    attachments.data.map(att => {
                        var attachment = att.PromotionAttachment;
                        attachment.previewUrl = att.previewUrl;
                        attachment.attachmentUrl = att.attachmentUrl;
                        attachment.Type__c = attachment.Type__c || 'application/octet-stream';
                        return attachment;
                    })
                );
                this.changeHandler();
            });

        this.LOExtTacticTiers.load().then(() => this.changeHandler());

        this.LOFilteredFunds.apex_read(JSON.stringify(promoObject)).then(children => {
            this.LOFilteredFunds.removeAllItems();
            this.LOFilteredFunds.addItems(children.data || []);
            this.changeHandler();
        });

        return instantiatePromises;
    },
    /**
     * Customize extension to the core serializeToAPEX function. Will be called at the end of the core method.
     * Input parameter is the already serialized BO as core would send it to the APEX layer.
     * The project and manipulate the JSON to match its requirements. The reponse should again be a promotion JSON.
     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the APEX layer
     * @returns {JSON} Serialized version of the BO adpated for project requirements
     */
    serializeToAPEX: function (serializedObject) {
        /**
         * Don't use below code. Once the metadata for ExtChildAccount is available, below can be replaced by only
         * serializedObject.LOExtChildAccounts = SerializationHelper.serializeWithStatus(this.LOExtChildAccounts);
         */
        serializedObject.LOExtChildAccounts = this.LOExtChildAccounts.getAllItems();
        if (serializedObject.LOExtChildAccounts)
            serializedObject.LOExtChildAccounts = serializedObject.LOExtChildAccounts.map(account => {
                account.__ObjectStatus = account.getObjectStatus();
                return _.pick(account, ['ChildAccountID', 'ChildAccountName', 'Included', 'CustomerUnique', 'PushedPromoID', 'PromotionSlogan', '__ObjectStatus']);
            });

        serializedObject.LOExtTacticTiers = this.LOExtTacticTiers.getAllItems();
        if (serializedObject.LOExtTacticTiers)
            serializedObject.LOExtTacticTiers = serializedObject.LOExtTacticTiers.map(tacticTiers => {
                return {
                    tacticId: tacticTiers.tacticId,
                    JSONTier: JSON.parse(tacticTiers.JSONTier || '[]'),
                    __ObjectStatus: tacticTiers.getObjectStatus()
                };
            });

        //PMA - START CODE - TPM-1498 - Audit Trail
        serializedObject.LOPromotionHistory = this.LOPromotionHistory.getAllItems();
        //PMA - END CODE - TPM-1498 - Audit Trail */

        return serializedObject;
    },
    /**
     * Customize extension to the core serializeToUI function. Will be called at the end of the core method.
     * Input parameter is the already serialized BO as core would send it to the UI layer.
     * The project and manipulate the JSON to match its requirements. The reponse should again be a promotion state JSON.
     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
     * @returns {JSON} Serialized version of the BO adpated for project requirements
     */
    serializeToUI: function (serializedObject) {
        var promotionJSON = {
            //Soco
            UL_Lift__c: this.getUL_Lift__c(),
            UL_Front_Margin__c: this.getUL_Front_Margin__c(),
            UL_IIBB_Tax__c: this.getUL_IIBB_Tax__c(),
            UL_Volume_Type__c: this.getUL_Volume_Type__c(),
            UL_Current_Status__c: this.getUL_Current_Status__c(),
            UL_Free_Text__c: this.getUL_Free_Text__c(),
            loadPhase: this.loadPhase,
            //PMA - START CODE - 2017-01-12 - New custom field
            UL_Cannibalisation_Rate__c: this.getUL_Cannibalisation_Rate__c(),
            UL_Market__c: this.getUL_Market__c(),
            //PMA - END CODE - 2017-01-12 - New custom field
             //API - START CODE - TPM-1499 - New Layout + TPM-2436
            UL_Promotion_ID__c: this.getName(),
            //API - END CODE - TPM-1499 - New Layout
            //uki
            UL_Delivery_Profile__c: this.getUL_Delivery_Profile__c(),
            UL_Mechanic__c: this.getUL_Mechanic__c(),
            UL_Sub_Mechanic__c: this.getUL_Sub_Mechanic__c(),
            UL_Pre_Evaluation_Comment__c: this.getUL_Pre_Evaluation_Comment__c(),
            UL_Primary_Objective__c: this.getUL_Primary_Objective__c(),
            UL_Secondary_Objective__c: this.getUL_Secondary_Objective__c(),
            UL_Promotion_Type__c: this.getUL_Promotion_Type__c(),
            UL_Feature__c: this.getUL_Feature__c(),
            UL_Category__c: this.getUL_Category__c(),
            UL_Brand__c: this.getUL_Brand__c(),
            UL_Cannibalisation_Override__c: this.getUL_Cannibalisation_Override__c(),
            UL_Post_Dip_End_Date__c: new Date(this.getUL_Post_Dip_End_Date__c()),
            UL_Account__c: this.getUL_Account__c(),
        };
        //Adding child accounts
        //WARNING: Remove get all items below and use the serialize method once the metadata for ExtChildAccount is implemented.
        promotionJSON.ChildAccounts = this.LOExtChildAccounts.getAllItems();
        promotionJSON.attachments = this.LOExtPromotionAttachment.getItems();
        //PMA - START CODE - TPM-1498 - Audit Trail
        promotionJSON.PromotionHistory = this.LOPromotionHistory.getAllItems();
        //PMA - END CODE - TPM-1498 - Audit Trail */
        //API - START CODE - TPM-2436 - Customer name fetch fix
        //Adding the promotion Account
        var account = _.find(this.LOAccount.getAllItems(), {Id: this.UL_Account__c});
        console.log("Accounts List", account);
        promotionJSON.UL_Account__c = (account) ? account.Name : '';
        //API - END CODE
        
        Object.assign(serializedObject, promotionJSON);

        return serializedObject;
    },
    /**
     * Customize extension to the core serializeSelectedTacticToUI function. Will be called at the end of the core method.
     * Input parameter is the already serialized BO as core would send it to the UI layer.
     * The project and manipulate the JSON to match its requirements. The response should again be a promotion state JSON.
     * @param {JSON} serializedObject - Serialized version of the BO to be used as parameter for the UI layer
     * @returns {JSON} Serialized version of the BO adapted for project requirements
     */
    serializeSelectedTacticToUI: function (serializedObject) {
        var tactic = this.LOTactic.getItems()[0];
        var tacticJSON = {
            UL_Off_On_Invoice__c: tactic.getUL_Off_On_Invoice__c(),
            UL_Take_Up_Rate__c: tactic.getUL_Take_Up_Rate__c(),
            UL_Order_Date_From__c: new Date(tactic.getUL_Order_Date_From__c()),
            UL_Order_Date_Thru__c: new Date(tactic.getUL_Order_Date_Thru__c()),
            UL_Payment_Method__c: tactic.getUL_Payment_Method__c(),
            UL_Condition_Type__c: tactic.getUL_Condition_Type__c(),
            UL_Investment_Method__c: tactic.getUL_Investment_Method__c(),
            UL_Redemption__c: tactic.getUL_Redemption__c(),
            RecordTypeId: tactic.getRecordTypeId(),
            UL_IsPushed__c: tactic.getUL_IsPushed__c(),
            InvalidTiers: tactic.InvalidTiers || false,
            InvalidFunds: tactic.InvalidFunds || false
        };
        var currentTacticTiers = _.find(this.LOExtTacticTiers.getAllItems(), (tacticTiers) => {
            return tacticTiers.tacticId == tactic.Id;
        });

        tacticJSON.TacticTiers = (currentTacticTiers && currentTacticTiers.JSONTier ? JSON.parse(currentTacticTiers.JSONTier).tier : []);

        tacticJSON.AvailableFunds = [];
        tacticJSON.AvailableFunds = _.unionBy(this.LOFund.getAllItems().filter(
            fund => !!_.find(fund.Tactics, item => item.tacticId == tactic.Id)
        ).map(
            fund => Object.assign(fund, _.find(fund.Tactics, item => item.tacticId == tactic.Id))
        ), this.LOFilteredFunds.getItems(), 'Id');

        //UL_Allocation__c & UL_Amount_Allocated__c (string -> float):
        if (tacticJSON.AvailableFunds && tacticJSON.AvailableFunds.length > 0) {
            _.forEach(tacticJSON.AvailableFunds, (fund) => {
                if (fund.Tactics && fund.Tactics.length > 0) {
                    _.forEach(fund.Tactics, (tacticFund) => {
                        tacticFund.UL_Allocation__c = parseFloat(tacticFund.UL_Allocation__c);
                        tacticFund.UL_Amount_Allocated__c = parseFloat(tacticFund.UL_Amount_Allocated__c);
                    });
                }
            });
        }

        Object.assign(serializedObject, tacticJSON);

        return serializedObject;
    },
    /**
     *
     */
    addTactic_beforeAPEX: function (payload) {
        return payload;
    },
    /**
     *
     */
    addTactic_afterAPEX: function (payload) {
        return payload;
    },
    /**
     *
     */
    addTactic_post: function () {
        //PMA - START CODE - 2017-01-17 - Copy Lift from Promotion to Tactic
        this.LOTactic.current.Lift__c = this.UL_Lift__c
        //PMA - END CODE - 2017-01-17 - Copy Lift from Promotion to Tactic
        return null;
    },
    /**
     * Customize extension to the core onDispatcher function. Will be called if an UI event is not found in core code.
     * @param {JSON} payload - Payload as provided by the UI event bus
     */
    onDispatcher: function (action) {
        switch (action.actionType) {

            case PromotionActionConstants.PUSH_CHILD_ACCOUNT: {
                let promoContent = this.serializePromotion(),
                    totalChildAccounts = _.filter(promoContent.BOPromotion.LOExtChildAccounts, function (childAccount) {
                        return childAccount.Included;
                    }).length,

                    {uploadId} = action.payload,
                    cancelled = false,
                    i = 0;
                this.uploads[uploadId] = () => {
                    cancelled = true;
                    UI_EVENT_BUS.put(uploadId, {
                        total: totalChildAccounts,
                        done: totalChildAccounts
                    });
                    delete this.uploads[uploadId];
                };

                let push = () => {
                    UI_EVENT_BUS.put(uploadId, {
                        total: totalChildAccounts,
                        done: i
                    });

                    if (i < totalChildAccounts) {
                        let temp = promoContent.BOPromotion.LOExtChildAccounts;
                        promoContent.BOPromotion.LOExtChildAccounts = [promoContent.BOPromotion.LOExtChildAccounts[i]];
                        let json = JSON.stringify(promoContent);
                        promoContent.BOPromotion.LOExtChildAccounts = temp;
                        this.apex_CreatePush(json).then((result) => {
                            if (result) {
                                if (cancelled) return;
                                i++;
                                push();

                            } else {
                                let showError = () => UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                                    title: AppManager.getLabel('PP_TIT_PUSH_ERROR') || 'Error pushing child promotion',
                                    message: AppManager.getLabel('PP_LBL_PUSH_ERROR') || 'An error occurred while trying to push the child promotion account',
                                    type: 'E'
                                });
                                showError();
                            }
                        });
                    }
                };

                this.apex_cleanUpPush(JSON.stringify(promoContent)).then((result) => {
                    if (result) {
                        push();
                    } else {
                        let showError = () => UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                            title: AppManager.getLabel('PP_TIT_CLEAN_PUSH_ERROR') || 'Error cleaning child promotions',
                            message: AppManager.getLabel('PP_LBL_CLEAN_PUSH_ERROR') || 'An error occurred while trying to clean the child promotions account',
                            type: 'E'
                        });
                        showError();
                    }
                });

                //this.refreshPromotion();
                break;
            }

            case PromotionActionConstants.FINALIZE_PUSH_CHILD_ACCOUNTS: {
                let promoContent = this.serializePromotion();
                this.apex_finalizePush(JSON.stringify(promoContent));
                console.log('FINALIZE_PUSH for promotion : ' + action.payload);
                break;
            }

            case PromotionActionConstants.TOGGLE_CHILD_ACCOUNT : {
                console.log("PERFORMED ACTION Toggle Child Account for ID:" + action.payload.ChildAccountID);
                _.forEach(this.LOExtChildAccounts.getAllItems(), function (childAccount) {
                    if (childAccount.ChildAccountID == action.payload.ChildAccountID)
                        childAccount.Included = !action.payload.Included;
                });
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {promotion: this.serializeTree()});
                break;
            }

            case PromotionActionConstants.TOGGLE_ALL_CHILD_ACCOUNTS : {
                console.log("PERFORMED ACTION Toggle All Child Accounts for Promotion ID:" + this.Id);
                _.forEach(this.LOExtChildAccounts.getAllItems(), function (childAccount) {
                    childAccount.Included = !action.payload.Included;
                });
                UI_EVENT_BUS.put(EVENTS.UI_BINDING, {promotion: this.serializeTree()});
                break;
            }

            case PromotionActionConstants.OPEN_PROMOTION: {
                var path = (location.hostname == 'localhost') ? 'index.html' : 'MyPromotionPlanning';
                console.log('OPEN_PROMOTION for promotion : ' + action.payload);
                window.open(path + '?id=' + action.payload);
                break;
            }

            /** Pull Forward attachment */
            case PromotionActionConstants.CANCEL_UPLOAD:
                let {uploadId} = action.payload;
                if (this.uploads[uploadId]) this.uploads[uploadId]();
                break;

            case PromotionActionConstants.UPLOAD_ATTACHMENT: {
                var me = this;
                let {attachment, uploadId} = action.payload,
                    promotionAttachment;

                let showError = () => this.onUIError({
                    title: AppManager.getLabel('PP_TIT_UPLOAD_ERROR') || 'Error uploading',
                    message: AppManager.getLabel('PP_LBL_UPLOAD_ERROR') || 'An error occurred while trying to upload the file',
                    type: 'E'
                });

                this.LOExtPromotionAttachment.apex_create(JSON.stringify(
                    _.omit(attachment, ['file', 'previewUrl', 'attachmentUrl', 'LastModifiedDate', 'CreatedDate'])
                )).then(att => {

                    if (!att.__Status) throw new Error();
                    promotionAttachment = att.data;

                    return Utils.getThumbnail({
                        file: attachment.file,
                        width: 280,
                        height: 210
                    });

                }).then(
                    dataURI => [attachment.file, {
                        name: attachment.file.name,
                        description: '#Preview#',
                        data: dataURI
                    }],
                    error => {
                        if (promotionAttachment) return [attachment.file];
                        throw error;
                    }
                ).then(files =>
                    Attachment.upload(files, promotionAttachment.Id, progress => {
                        UI_EVENT_BUS.put(uploadId, Math.min(progress, 1 - 1e-7));
                    }, cancel => this.uploads[uploadId] = cancel)
                ).then(
                    result => {
                        delete this.uploads[uploadId];
                        UI_EVENT_BUS.put(uploadId, 1);
                        if (!result.length) return;
                        if (result[0].getBoolean("success") && (!result[1] || result[1].getBoolean("success"))) {

                            promotionAttachment.objectStatus = STATE.NEW;
                            promotionAttachment.attachmentUrl = '/servlet/servlet.FileDownload?file=' + result[0].get('id');
                            if (result[1]) {
                                promotionAttachment.previewUrl = '/servlet/servlet.FileDownload?file=' + result[1].get('id');
                            }

                            me.LOExtPromotionAttachment.addItem(promotionAttachment);
                            this.changeHandler();
                        } else {
                            showError();
                        }
                    },
                    error => {
                        delete this.uploads[uploadId];
                        UI_EVENT_BUS.put(uploadId, 1);
                        showError();
                    }
                );
                break;
            }

            case PromotionActionConstants.ATTACHMENT_DELETE: {
                let attachmentId = action.payload,
                    attachment = _.find(this.LOExtPromotionAttachment.getAllItems(), {Id: attachmentId});

                attachment.setObjectStatus(STATE.DELETED);
                this.changeHandler();
                break;
            }

            case PromotionActionConstants.CHANGE_WF_STATE: {
                var saveObject = this.serializePromotion();
                saveObject.target="Salesforce";
                this.apex_invokeWF(this.getId(), action.payload.wfstate, JSON.stringify(saveObject)).then(result => {
                    if (result.__Status) {
                        this.refreshPromotion();
                        console.log('wfstate changed');
                    }
                });
                break;
            }

            //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
            case PromotionActionConstants.COPY_PROMOTION_DATEFROM_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setDate_From__c(action.payload.date);
                });
                this.changeHandler();
                break;
            }

            case PromotionActionConstants.COPY_PROMOTION_DATETHRU_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setDate_Thru__c(action.payload.date);
                });
                this.changeHandler();
                break;
            }

            case PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATEFROM_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setShipment_Date_From__c(action.payload.date);
                });
                this.changeHandler();
                break;
            }

            case PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATETHRU_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setShipment_Date_Thru__c(action.payload.date);
                });
                this.changeHandler();
                break;
            }

            case PromotionActionConstants.COPY_PROMOTION_INSTOREDATEFROM_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setInstore_Date_From__c(action.payload.date);
                });
                this.changeHandler();
                break;
            }

            case PromotionActionConstants.COPY_PROMOTION_INSTOREDATETHRU_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setInstore_Date_Thru__c(action.payload.date);
                });
                this.changeHandler();
                break;
            }
            //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic

            //PMA - START CODE - 2017-01-17 - Copy Lift from Promotion to Tactic
            case PromotionActionConstants.COPY_PROMOTION_LIFT_TO_TACTICS: {
                this.LOTactic.getAllItems().map(tactic => {
                    if (tactic.getObjectStatus() !== STATE.DELETED)
                        tactic.setLift__c(action.payload.lift);
                });
                this.changeHandler();
                break;
            }
            //PMA - END CODE - 2017-01-17 - Copy Lift from Promotion to Tactic

            //PMA - START CODE - 2017-01-13 - Threshold button
            case  PromotionActionConstants.BTN_INVOKETHRESHOLD: {
                console.log('action.payload', action.payload);
                var me = this;
                this.apex_invokePromotionThresholdCheck(this.getId()).then(result => {
                    if (result.__Status) {
                        console.log('BTN_INVOKETHRESHOLD : OK' + result.data);
                        var prmobj = action.payload.prmobj;
                        var message = {
                            title: 'Threshold Check Result',
                            message: (result.data != '') ? '' : 'No thresholds',
                            messagejson: (result.data != '') ? result.data : '',
                            cancelHandler: function () {
                                prmobj.setState({message: null});
                            }
                        };
                        prmobj.setState({message: message});
                    }
                });
                /* Code for local testing
                 var prmobj = action.payload.prmobj;
                 var message = {
                 title: 'Threshold Check Result',
                 message: 'No thresholds',
                 messagejson: '',
                 cancelHandler: function () {
                 prmobj.setState({message: null});
                 }
                 };
                 prmobj.setState({message: message});
                 */
                break;
            }
            //PMA - START CODE - 2017-01-13 - Threshold button

            case  PromotionActionConstants.BTN_INVOKEAUDITTRAIL: {
                console.log('BTN_INVOKEAUDITTRAIL - START');
                this.apex_invokeAuditTrail(this.getId()).then(result => {
                    console.log('BTN_INVOKEAUDITTRAIL - RESULT ' + result.__Status);
                    if (result.__Status) {
                        console.log('BTN_INVOKEAUDITTRAIL - DATA ' + result.data);
                        let showError = () => UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                            title: 'TEST',
                            message: result.data.toString(),
                            type: 'W'
                        });
                        showError();
                    }
                });
                break;
            }

            case PromotionActionConstants.UPDATE_ENABLE_PUSH: {
                let promoContent = this.serializePromotion();
                console.log("PERFORMED ACTION Release Child Accounts for Promotion ID:" + this.Id);
                this.apex_UpdateEnablePush(JSON.stringify(promoContent)).then((response) => {
                    if (response.__Status) {
                        this.changeHandler();
                    } else {
                        let showError = () => UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
                            title: AppManager.getLabel('PP_TIT_RELEASE_ERROR') || 'Error updating child promotions',
                            message: AppManager.getLabel('PP_LBL_RELEASE_ERROR') || 'An error occurred while trying to release the child promotions account',
                            type: 'E'
                        });
                        showError();
                    }
                });
                break;
            }

            case PromotionActionConstants.VALIDATE_TACTIC_TIERS: {
                let newTacticTiers = action.payload.TacticTiers;
                console.log("PERFORMED ACTION Validate Tactic Tiers for Tactic ID:" + action.payload.TacticId);
                this.LOExtTacticTiers.apex_validate(JSON.stringify({"tier": newTacticTiers})).then((response) => {
                    if (response.__Status) {

                        let tacticTiers = _.find(this.LOExtTacticTiers.getAllItems(), (item) => {
                            return item.tacticId == action.payload.TacticId;
                        });
                        if (tacticTiers) {
                            if (!tacticTiers.setJSONTier)
                                tacticTiers.setJSONTier = function (value) {
                                    tacticTiers.JSONTier = value;
                                    tacticTiers.objectStatus |= STATE.DIRTY;
                                };
                            tacticTiers.setJSONTier(JSON.stringify({"tier": newTacticTiers}));
                        } else {
                            this.LOExtTacticTiers.addItem({
                                tacticId: action.payload.TacticId,
                                JSONTier: JSON.stringify({"tier": newTacticTiers})
                            });
                        }

                        this.LOTactic.getAllItems().map(tactic => {
                            if (tactic.Id === action.payload.TacticId)
                                tactic.InvalidTiers = false;
                        });

                        this.changeHandler();
                    } else {

                        this.LOTactic.getAllItems().map(tactic => {
                            if (tactic.Id === action.payload.TacticId)
                                tactic.InvalidTiers = true;
                        });

                        this.changeHandler();
                    }
                });
                break;
            }

            case PromotionActionConstants.VALIDATE_FUNDS: {
                let newFunds = action.payload.funds;
                console.log("PERFORMED ACTION Validate Funds for Tactic ID:" + action.payload.tacticId);
                this.LOFund.apex_validate(JSON.stringify(_.filter(newFunds, 'selected'))).then((response) => {
                    if (response.__Status) {

                        newFunds.map((fund) => {

                            let existingFund = this.LOFund.getItemById(fund.Id),
                                tactics = {
                                    'tacticId': action.payload.tacticId,
                                    'UL_Allocation__c': fund.UL_Allocation__c,
                                    'UL_Amount_Allocated__c': fund.UL_Amount_Allocated__c
                                };

                            if (fund.selected) {
                                //Add
                                if (existingFund) {
                                    if (existingFund.objectStatus === STATE.DELETED) {
                                        existingFund.objectStatus = STATE.PERSISTED;
                                        existingFund.Tactics = [tactics];
                                    }
                                    else {
                                        _.remove(existingFund.Tactics, {'tacticId': tactics.tacticId});
                                        existingFund.Tactics.push(tactics);
                                    }
                                    this.LOFund.applyFilters();
                                }
                                else {
                                    delete fund.selected;
                                    fund.Tactics = [tactics];
                                    this.LOFund.addItem(fund);
                                }
                            }
                            else {
                                //Delete
                                if (existingFund) {
                                    _.remove(existingFund.Tactics, {'tacticId': tactics.tacticId});
                                    if (existingFund.Tactics.length > 0) {
                                        this.LOFund.applyFilters();
                                    } else {
                                        existingFund.setObjectStatus(STATE.DELETED);
                                    }
                                }
                            }

                        });

                        this.LOTactic.getAllItems().map(tactic => {
                            if (tactic.Id === action.payload.tacticId)
                                tactic.InvalidFunds = false;
                        });

                        this.changeHandler();
                    } else {

                        this.LOTactic.getAllItems().map(tactic => {
                            if (tactic.Id === action.payload.tacticId)
                                tactic.InvalidFunds = true;
                        });

                        this.changeHandler();
                    }
                });
                break;
            }

            /*
             case PromotionActionConstants.MYACTION:
             // Do something here
             break;
             */
            default:
                console.log('Unknown action type ${payload.actionType} detected. Cannot call appropriate action.');
                break;
        }
    }
};

module.exports = Promotion_Cust;