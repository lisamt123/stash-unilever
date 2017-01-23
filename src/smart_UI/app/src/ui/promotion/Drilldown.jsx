"use strict";

var React = require('react');
var Icon = require('react-lightning-design-system').Icon;

var Truncate = require('../components/Truncate');
var ACLCheck = require('../components/ACLCheck');

module.exports = React.createClass({
    propTypes: {
        root: React.PropTypes.object, // This must be the promotion structure tree
        onSelect: React.PropTypes.func, // Handler for selected node
        selectedTactic: React.PropTypes.object
    },

    getInitialState: function () {
        return {
            selectedNode: this.props.root,
            selectedProduct: null
        };
    },

    componentDidMount: function () {
        UI_EVENT_BUS.subscribe(EVENTS.UI_BINDING, this.onUIBinding);
        this.setParent(this.state.selectedNode, 0);
        this.selectNode(this.props.root);
    },

    onUIBinding: function (payload) {
        if (this.isMounted())
            this.setState(payload)
    },

    componentWillReceiveProps: function (props) {
        if (!_.isEqual(this.props.root, props.root)) {
            this.setParent(props.root, 0);

            var selectedNode = this.lookforNode(props.root, this.state.selectedNode.Id);
            if (selectedNode) {
                this.setState({
                    selectedNode: selectedNode
                });
            } else {
                this.setState({
                    selectedNode: props.root
                });
            }
        }
    },

    lookforNode: function (item, id) {
        if (item.Id == id) {
            return item;
        }
        if (item['children'] && item.children.length > 0) {
            for (var i = 0; i < item.children.length; i++) {
                var node = this.lookforNode(item.children[i], id);
                if (node) return node;
            }
        }
        return null;
    },

    setParent: function (item, deepLevel) {
        switch (deepLevel) {
            case 0:
                item.type = 'PROMOTION';
                break;
            case 1:
                item.type = 'TACTIC';
                break;
            case 2:
                item.type = 'CATEGORY';
                break;
            default:
                item.type = 'PRODUCT';
                break;
        }
        if (item['children'] && item.children.length > 0) {
            for (var i = 0; i < item.children.length; i++) {
                item.children[i].parent = item;
                this.setParent(item.children[i], deepLevel + 1)
            }
        }
    },

    selectNode: function (item) {
        var me = this;
        var emitSelect = function () {
            if (me.props.onSelect) {
                me.props.onSelect(item);
            }
        };

        if (item.type == 'PRODUCT') //Leaf node: "PRODUCT"
            this.setState({selectedProduct: item}, emitSelect);
        else
            this.setState({selectedNode: item, selectedProduct: null}, emitSelect);
    },

    getParentTitle: function (item) {
        var title = '';

        if (item.type == 'PROMOTION') {
            title = item.Slogan__c;
        }

        if (item.type == 'TACTIC') {
            title = item.Tactic_Template;
        }

        if (item.type == 'CATEGORY') {
            title = item.Name;
        }

        if (item.type == 'PRODUCT') {
        }

        return title;
    },

    getParentSubtitle: function (item) {
        var subitems = '';

        if (item.type == 'PROMOTION') {
            subitems = 'Tactics';
        }

        if (item.type == 'TACTIC') {
            subitems = 'Product Groups';//TODO LOCALIZE
        }

        if (item.type == 'CATEGORY') {
            subitems = 'Products';
        }

        if (item.type == 'PRODUCT') {
        }

        return '(' + item.children.length + ' ' + subitems + ')';
    },

    renderParentOpenNode: function (item, ix) {
        if (item.type == 'PRODUCT')
            return null;
        var parentText = <span>{this.getParentTitle(item)} {this.getParentSubtitle(item)}</span>
        return (
            <div key={ix} className="parentitem open">
                <div className="title">
                    <a href="#" onClick={()=>this.selectNode(item)}>
                        <Truncate lines={2} children={parentText}></Truncate>
                    </a>
                </div>
            </div>
        )
    },

    renderTacticNode: function (item, index) {
        var childSelector = null;
        if (item['children'] && item.children.length > 0) {
            childSelector = <Icon icon="chevronright" className="handler"/>;
        }
        else {
            childSelector = <div className="handler"/>;
        }

        var fromDate = (item.Date_From__c) ? Utils.Formatters.formatDate(new Date(item.Date_From__c)) : '';
        var toDate = (item.Date_Thru__c) ? Utils.Formatters.formatDate(new Date(item.Date_Thru__c)) : '';
        var metadata = item._meta;

        return (
            <div key={index} className="item">
                <a href="#" onClick={()=>this.selectNode(item)}>
                    <div className="itemInfo">
                        <div className="itemTitle">
                            <div className="desc">{item.Tactic_Template}</div>
                            <div className="itemSubtitle">{fromDate} - {toDate}</div>
                        </div>
                        <div className="itemBody">
                            <div className="itemContent">
                                <div className="itemProp">
                                    <label>{metadata.Pct_of_Stores__c.label}</label>
                                    <span>{Utils.Formatters.formatNumber(item.Pct_of_Stores__c)}</span>
                                </div>
                                <ACLCheck object={this.state.selectedNode} field="TacticLift">
                                <div className="itemProp">
                                    <label>{metadata.Lift__c.label}</label>
                                    <span>{Utils.Formatters.formatNumber(item.Lift__c)}</span>
                                </div>
                                </ACLCheck>
                                <div className="itemProp">
                                    <label>{metadata.Amount__c.label}</label>
                                    <span>{Utils.Formatters.formatNumber(item.Amount__c)}</span>
                                </div>
                                <div className="itemProp large">
                                    <label>{metadata.Compensation_Model__c.label}</label>
                                    <span>{item.Compensation_Model__c}</span>
                                </div>

                                <div className="itemProp">
                                    <label>{metadata.Payment_Method__c.label}</label>
                                    <span>{item.Payment_Method__c}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    {childSelector}
                </a>
            </div>
        )
    },

    renderProductGroupNode: function (item, index) {
        var childSelector = null;
        if (item['children'] && item.children.length > 0) {
            childSelector = <Icon icon="chevronright" className="handler"/>
        }

        var classItem = 'item';
        if (this.state.selectedProduct == item)
            classItem += ' selected';

        return (
            <div key={index} className={classItem}>
                <a href="#" onClick={()=>this.selectNode(item)}>
                    <div className="itemTitle">
                        <div className="desc">{item.Name}</div>
                        {childSelector}
                    </div>
                </a>
            </div>
        )
    },

    renderProductNode: function (item, index) {
        var childSelector = null;

        var classItem = 'item';
        if (this.state.selectedProduct == item)
            classItem += ' selected';

        return (
            <div key={index} className={classItem}>
                <a href="#" onClick={()=>this.selectNode(item)}>
                    <div className="itemTitle">
                        <div className="desc">{item.Name}</div>
                    </div>
                </a>
            </div>
        )
    },

    renderSelectedNode: function (item, index) {
        var selectedText = <span>{this.getParentTitle(item)} {this.getParentSubtitle(item)}</span>
        return (
            <div key={index}>
                <div className="parentitem selected">
                    <div key="0" className="title">
                        <a href="#" onClick={()=>this.selectNode(item)}>
                            <Truncate lines={2} children={selectedText}></Truncate>
                        </a>
                    </div>
                    {item.children
                        .map((item, i) => {
                            if (item.type == 'TACTIC')
                                return this.renderTacticNode(item, i + 1);
                            else if (item.type == 'CATEGORY')
                                return this.renderProductGroupNode(item, i + 1);
                            else
                                return this.renderProductNode(item, i + 1);
                        })
                    }
                </div>
            </div>
        )
    },

    render: function () {
        var openNodes = [];
        if (this.props.root == null) {
            return (
                <div className="drilldown">{AppManager.getLabel('PP_LBL_NODATA') || 'No data'}</div>
            )
        }
        var selectedParentNode = this.state.selectedNode.parent;
        var ix = 1;
        while (selectedParentNode != null) {
            openNodes.unshift(this.renderParentOpenNode(selectedParentNode, ix++));
            selectedParentNode = selectedParentNode.parent;
        }
        return (
            <div className="drilldown slds-scrollable--y">
                {openNodes}
                {this.renderSelectedNode(this.state.selectedNode, ix++)}
            </div>
        )
    }
});
