"use strict";

global._ = require('lodash');
_.mixin({keyMirror: require('fbjs/lib/keyMirror')});

global.PromCalendarActionConstants = _.keyMirror({
    CALENDAR_LOAD: null,
    ADD_PROMOTION: null,
    PREVIOUS_PERIOD: null,
    NEXT_PERIOD: null,
    CHANGE_FILTER: null,
    GET_PROMOTION_DETAIL: null,
    OPEN_PROMOTION_DETAIL: null,
    DERIVE_PROMOTION_DETAIL: null,
    COPY_PROMOTION_DETAIL: null,
    DELETE_PROMOTION_DETAIL: null,
    CANCEL_CHANGE_FILTER: null
});

var PromCalendarActions = {
    load: function (payload) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.CALENDAR_LOAD,
            payload: payload
        });
    },

    addPromotion: function (promotion) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.ADD_PROMOTION,
            payload: promotion
        });
    },

    prevPeriod: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.PREVIOUS_PERIOD,
            payload: null
        });
    },

    nextPeriod: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.NEXT_PERIOD,
            payload: null
        });
    },

    changeCalendarFilter: function (filterValue) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.CHANGE_FILTER,
            payload: filterValue
        });
    },
    cancelChangeCalendarFilter: function () {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.CANCEL_CHANGE_FILTER,
            payload: null
        });
    },

    getPromotionDetail: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.GET_PROMOTION_DETAIL,
            payload: promotionId
        });
    },

    openPromotionDetail: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.OPEN_PROMOTION_DETAIL,
            payload: promotionId
        });
    },

    derivePromotionDetail: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.DERIVE_PROMOTION_DETAIL,
            payload: promotionId
        });
    },

    copyPromotionDetail: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.COPY_PROMOTION_DETAIL,
            payload: promotionId
        });
    },

    deletePromotionDetail: function (promotionId) {
        UI_EVENT_BUS.put(EVENTS.FLUX, {
            actionType: PromCalendarActionConstants.DELETE_PROMOTION_DETAIL,
            payload: promotionId
        });
    }
};

module.exports.PromCalendarActions = PromCalendarActions;
module.exports.PromCalendarActionConstants = PromCalendarActionConstants;
