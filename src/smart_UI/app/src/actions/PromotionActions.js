"use strict";

global._ = require('lodash');
_.mixin({keyMirror: require('fbjs/lib/keyMirror')});

global.PromotionActionConstants = _.keyMirror({
    PROMOTION_LOAD: null,
    PROMOTION_LOAD_GRID: null,
    PROMOTION_SAVE: null,
    PROMOTION_SAVE_AND_REFRESH: null,
    PROMOTION_CANCEL: null,
    PROMOTION_SET_FIELD: null,
    TACTIC_SET_FIELD: null,
    TACTIC_ADD: null,
    TACTIC_DUPLICATE: null,
    TACTIC_DELETE: null,
    TACTIC_SELECTED: null,
    APPLY_PRODUCT_FILTER: null,
    SEARCH_FOR_PRODUCTS: null,
    CLEAR_SEARCH_FOR_PRODUCTS: null,
    ADD_PRODUCTS: null,
    SEARCH_FOR_FUNDS: null,
    ADD_FUNDS: null,
    DELETE_FUNDS: null,
    CHANGE_TACTIC_PRODUCT_RELATIONSHIP: null,
    TOGGLE_TACTIC_PRODUCT_FILTER: null,
    /*  Unilever Start */
    // Workflow function
    CHANGE_WF_STATE: null,
    //CopyLift
    COPY_PROMOTION_LIFT_TO_TACTICS: null,
    //Attachments
    UPLOAD_ATTACHMENT: null,
    CANCEL_UPLOAD: null,
    ATTACHMENT_DELETE: null,
    //Child accounts
    PUSH_CHILD_ACCOUNT: null,
    FINALIZE_PUSH_CHILD_ACCOUNTS: null,
    TOGGLE_CHILD_ACCOUNT: null,
    TOGGLE_ALL_CHILD_ACCOUNTS: null,
    UPDATE_ENABLE_PUSH: null,
    //Tactic tiers
    VALIDATE_TACTIC_TIERS: null,
    //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
    COPY_PROMOTION_DATEFROM_TO_TACTICS: null,
    COPY_PROMOTION_DATETHRU_TO_TACTICS: null,
    COPY_PROMOTION_SHIPMENTDATEFROM_TO_TACTICS: null,
    COPY_PROMOTION_SHIPMENTDATETHRU_TO_TACTICS: null,
    COPY_PROMOTION_INSTOREDATEFROM_TO_TACTICS: null,
    COPY_PROMOTION_INSTOREDATETHRU_TO_TACTICS: null,
    //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
    //PMA - START CODE - 2017-01-13 - Threshold button
    BTN_INVOKETHRESHOLD: null,
    BTN_INVOKEAUDITTRAIL: null,
    //PMA - END CODE - 2017-01-13 - Threshold button
    VALIDATE_FUNDS: null
});

var PromotionActions = {

    load: function (payload) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PROMOTION_LOAD,
            payload: payload
        });
    },

    loadPromotionGrid: function (promotionId, Manual_Calculation_Input) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PROMOTION_LOAD_GRID,
            payload: {Id: promotionId, Manual_Calculation_Input: Manual_Calculation_Input}
        });
    },

    save: function (id) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PROMOTION_SAVE,
            payload: {Id: id}
        });
    },

    saveAndRefresh: function (id) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PROMOTION_SAVE_AND_REFRESH,
            payload: {Id: id}
        });
    },

    cancelEdit: function (id, context) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PROMOTION_CANCEL,
            payload: {Id: id, Context: context}
        });
    },

    setPromotionField: function (id, fieldName, fieldValue) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PROMOTION_SET_FIELD,
            payload: {Id: id, fieldName: fieldName, fieldValue: fieldValue}
        });
    },

    selectPromotion: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TACTIC_SELECTED,
            payload: null
        });
    },

    selectTactic: function (id) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TACTIC_SELECTED,
            payload: {Id: id}
        });
    },

    setTacticField: function (id, fieldName, fieldValue) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TACTIC_SET_FIELD,
            payload: {Id: id, fieldName: fieldName, fieldValue: fieldValue}
        });
    },

    addTactic: function (tacticTemplate) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TACTIC_ADD,
            payload: tacticTemplate
        });
    },

    duplicateTactic: function (tacticId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TACTIC_DUPLICATE,
            payload: tacticId
        });
    },

    deleteTactic: function (tacticId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TACTIC_DELETE,
            payload: tacticId
        });
    },

    applyProductFilter: function (tacticId, productFilter) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.APPLY_PRODUCT_FILTER,
            payload: {tacticId: tacticId, productFilter: productFilter}
        });
    },

    searchForProducts: function (productSample) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.SEARCH_FOR_PRODUCTS,
            payload: productSample
        });
    },

    clearSearchForProducts: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.CLEAR_SEARCH_FOR_PRODUCTS,
            payload: null
        });
    },

    addProducts: function (products, tacticID) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.ADD_PRODUCTS,
            payload: {tacticId: tacticID, products: products}
        });
    },

    changeTacticProductRelationship(productID, tacticID, relationship){
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.CHANGE_TACTIC_PRODUCT_RELATIONSHIP,
            payload: {tacticId: tacticID, productId: productID, relationship: relationship}
        });
    },

    toggleTacticProductFilter(filterID, filterValue, tacticObj, bselected){
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TOGGLE_TACTIC_PRODUCT_FILTER,
            payload: {filterId: filterID, filterValueId: filterValue, tactic: tacticObj, selected: bselected}
        });
    },

    searchForFunds: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.SEARCH_FOR_FUNDS,
            payload: null
        });
    },

    addFunds: function (funds, tacticID) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.ADD_FUNDS,
            payload: {tacticId: tacticID, funds: funds}
        });
    },

    deleteFunds: function (fundsId, tacticID) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.DELETE_FUNDS,
            payload: {tacticId: tacticID, fundsId: fundsId}
        });

    },

    validateFunds: function (funds, tacticID) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.VALIDATE_FUNDS,
            payload: {tacticId: tacticID, funds: funds}
        });
    },

    //Workflow Function call
    changeWfState: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.CHANGE_WF_STATE,
            payload: {wfstate: value}
        });
    },

    //Copy Promotion Lift
    copyLiftToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_LIFT_TO_TACTICS,
            payload: {lift: value}
        });
    },

    uploadAttachment: function (attachment, uploadId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.UPLOAD_ATTACHMENT,
            payload: {attachment, uploadId}
        });
    },

    cancelUpload: function (uploadId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.CANCEL_UPLOAD,
            payload: {uploadId}
        });
    },

    deleteAttachment: function (attachmentId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.ATTACHMENT_DELETE,
            payload: attachmentId
        });
    },

    pushChildAccount: function (uploadId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.PUSH_CHILD_ACCOUNT,
            payload: {uploadId}
        });
    },

    finalizePushChildAccounts: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.FINALIZE_PUSH_CHILD_ACCOUNTS,
            payload: {promotionId}
        });
    },

    toggleChildAccount: function (childAccountId, included) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TOGGLE_CHILD_ACCOUNT,
            payload: {ChildAccountID: childAccountId, Included: included}
        });
    },

    toggleAllChildAccounts: function (childAccounts, included) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.TOGGLE_ALL_CHILD_ACCOUNTS,
            payload: {ChildAccounts: childAccounts, Included: included}
        });
    },

    updateEnablePush: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.UPDATE_ENABLE_PUSH,
            payload: {}
        });
    },

    validateTacticTiers: function (tacticTiers, tacticId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.VALIDATE_TACTIC_TIERS,
            payload: {TacticTiers: tacticTiers, TacticId: tacticId}
        });
    },

    openPromotion: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.OPEN_PROMOTION,
            payload: promotionId
        });
    },

    //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
    copyDateFromToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_DATEFROM_TO_TACTICS,
            payload: {date: value}
        });
    },

    copyDateThruToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_DATETHRU_TO_TACTICS,
            payload: {date: value}
        });
    },

    copyDeliveryDateFromToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATEFROM_TO_TACTICS,
            payload: {date: value}
        });
    },

    copyDeliveryDateThruToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATETHRU_TO_TACTICS,
            payload: {date: value}
        });
    },

    copyInstoreDateFromToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_INSTOREDATEFROM_TO_TACTICS,
            payload: {date: value}
        });
    },

    copyInstoreDateThruToTactics: function (value) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.COPY_PROMOTION_INSTOREDATETHRU_TO_TACTICS,
            payload: {date: value}
        });
    },
    //PMA - END CODE - 2017-01-12 - Copy date from Promotion to Tactic

    //PMA - START CODE - 2017-01-13 - Threshold button
    invokeThreshold: function (objectid, prmobj) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.BTN_INVOKETHRESHOLD,
            payload: {objectid: objectid, prmobj: prmobj}
        });
    },
    //PMA - END CODE - 2017-01-13 - Threshold button
 
    invokeAuditTrail: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromotionActionConstants.BTN_INVOKEAUDITTRAIL,
            payload: null
        });
    }

};

module.exports.PromotionActions = PromotionActions;
module.exports.PromotionActionConstants = PromotionActionConstants;
