"use strict";

var React = require('react');

var Button = require('react-lightning-design-system').Button;
var Icon = require('react-lightning-design-system').Icon;

var PromCalendarActions = require('../../actions/PromCalendarActions').PromCalendarActions;

var Popover = require('../components/Popover');
var ConfirmPopup = require('../components/ConfirmPopup');
var Truncate = require('../components/Truncate');

module.exports = React.createClass({
  displayName: 'PromotionDetail',

  getInitialState: function () {
    return {
      hover: false,
      isTruncated: false,
      confirmMessage: null,
    };
  },

  componentDidMount: function () {
    console.log(this.props.promotionDetail);
    PromCalendarActions.getPromotionDetail(this.props.promotionDetail.period.Id);
  },

  deletePromotion: function (promotion) {
    var me = this;
    var confirmMessage = {
      title: 'Confirmation',
      message: 'Do you want to delete the promotion?',
      cancelHandler: function () {
        me.setState({confirmMessage: null});
      },
      okHandler: function () {
        PromCalendarActions.deletePromotionDetail(promotion.period.Id);
        me.setState({confirmMessage: null});
      }
    };

    this.setState({confirmMessage: confirmMessage})
  },
 render: function () {

    var icon = null;

    if (this.props.icon && this.props.icon.indexOf('.') == -1) {
      icon = <Icon category="standard" icon={this.props.icon} size="large" />
    }else {
      icon = <span className="slds-avatar">
             <img src={Utils.HTTP.getImgUrl(this.props.icon)} alt="promo" />
      </span>
    }

    return (
        <Popover direction="vertical" nubbinMargin={5} className="promotion-detail">
            {(this.state.confirmMessage) ?
                    <ConfirmPopup title={this.state.confirmMessage.title} message={this.state.confirmMessage.message}
                                  cancelHandler={this.state.confirmMessage.cancelHandler}
                                  okHandler={this.state.confirmMessage.okHandler} /> : null}
                <div className="slds-popover__body promotion-detail">
                    <dl className="slds-popover__body-list">
                        <dt className="slds-m-bottom--medium">
                            <div className="slds-media slds-media--center">
                                <div className="slds-media__figure">{icon}
                                </div>
                                <div className="slds-media__body">
                                <div className="slds-text-body--small slds-text--caps">{this.props.promotionDetail.promotion_template}</div>
                                    <a onClick={()=> PromCalendarActions.openPromotionDetail(this.props.promotionDetail.period.Id) }
                                       onMouseEnter={(e)=>this.setState({hover: true})}
                                       onMouseLeave={(e)=>this.setState({hover: false})}
                                       className="slds-text-heading--medium">
                                      <div className="slds-truncate slogan-text">
                                        <Truncate lines={2}
                                                  onTruncate={(isTruncated) => {isTruncated !== this.state.isTruncated && this.setState({ isTruncated })}}
                                                  children={this.props.promotionDetail.promotion.slogan}>
                                        </Truncate>
                                      </div>
                                    </a>
                                    {
                                    (this.state.hover && this.state.isTruncated) ?
                                              <Popover direction="horizontal" nubbinMargin={10} className="slogan-tooltip">{this.props.promotionDetail.promotion.slogan}</Popover> : null
                                    }
                                </div>
                            </div>
                        </dt>
                          <dt className="slds-m-bottom--small">
                              <label className="slds-text-body--small">{AppManager.getLabel('PC_LBL_FROM_THRU') || 'FROM/THRU'}</label>

                              <div className="slds-text-heading--small">{Utils.Formatters.formatDate(this.props.promotionDetail.period.from) + ' - ' + Utils.Formatters.formatDate(this.props.promotionDetail.period.to)}
                              </div>
                          </dt>
                          <dt className="slds-m-bottom--small">
                              <label className="slds-text-body--small">{AppManager.getLabel('PC_LBL_STATUS') || 'STATUS'}</label>

                              <div className="slds-text-heading--small">{this.props.promotionDetail.period.phase}
                              </div>
                          </dt>
                          <dt className="slds-m-bottom--small">
                              <label className="slds-text-body--small">{AppManager.getLabel('PC_LBL_ANCHOR') || 'ANCHOR'}</label>

                              <div className="slds-text-heading--small">{this.props.promotionDetail.promotion.Account_Name}
                              </div>
                          </dt>
                        {(this.props.promotionDetailData && this.props.promotionDetailData.Id == this.props.promotionDetail.period.Id) ?
                              <dt className="slds-m-bottom--small">
                                  <label className="slds-text-body--small">{AppManager.getLabel('PC_LBL_TACTICS_FROM_THRU') || 'TACTICS FROM/THRU'}</label>
                                  {
                                  this.props.promotionDetailData.Tactics.map((tactic)=>
                                <div className="slds-text-heading--small">{Utils.Formatters.formatDate(tactic.Date_From)}
                                    - {Utils.Formatters.formatDate(tactic.Date_Thru)} - {tactic.Description}
                                </div>
                                  )
                                  }
                              </dt>
                        : null}
                    </dl>
                    <dt className="slds-clearfix">
                        <section className="slds-float--left slds-p-left--small">
                            <Button type="neutral"
                                    onClick={()=> PromCalendarActions.openPromotionDetail(this.props.promotionDetail.period.Id) }>{AppManager.getLabel('PC_BTN_OPEN') || 'Open'}
                            </Button>
                        </section>
                        <section className="slds-float--right slds-p-right--small">
                          <Button type="neutral"
                                  disabled="true"
                                  onClick={()=> PromCalendarActions.derivePromotionDetail(this.props.promotionDetail.period.Id) }>{AppManager.getLabel('PC_BTN_DERIVE') || 'Derive'}
                          </Button>
                          <Button type="neutral"
                                  onClick={()=> this.deletePromotion(this.props.promotionDetail) }>{AppManager.getLabel('PC_BTN_DELETE') || 'Delete'}
                          </Button>
                        </section>
                    </dt>
                    <dt className="slds-p-bottom--small"></dt>
                </div>
        </Popover>
            )
          }
       });
