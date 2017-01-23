"use strict";

var React = require('react');
var Checkbox = require('react-lightning-design-system').Checkbox;
var Icon = require('react-lightning-design-system').Icon;

module.exports = React.createClass({
    displayName: 'ProductGrid',

    getInitialState: function () {
        var itemsToAdd = 50;
        return {
            items: [],
            itemsToAdd: itemsToAdd
        };
    },

    componentWillMount: function () {
        //this._loadItems();
    },

    renderProductRow: function (product, ix) {
        var icon = 'task2';
        var textColor = 'default';
        if (product.relationship == 'INCLUDED') {
            icon = 'task';
        }
        if (product.relationship == 'EXCLUDED') {
            icon = 'unmatched';
            textColor = 'error'
        }
        if (product.relationship == 'DELETED') {
            return null;
        }
        return (
            <tr key={"productGrid" + ix}>
                <td>
                    <Icon onClick={()=>this.props.toggleHandler(product)} category="standard" fillColor="none"
                          textColor={textColor} icon={icon} size="x-medium" className="slds-m-right--medium"/>
                </td>
                <td>
                    <div className="slds-truncate">{product.Name}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Description_1}</div>
                </td>

                <td>
                    <div className="slds-truncate">{product.Pack_Size}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Pack_Size_Unit}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Container_Size}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Container_Size_Unit}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Product_Form}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Container_Type}</div>
                </td>
            </tr>
        )
    },

    _loadItems: function () {
        var me = this;
        var length = me.state.items.length + me.state.itemsToAdd;
        var list = me.state.items;

        for (var i = list.length; i < length; i++) {
            if (i < me.props.productFilters.products.length) {
                list.push(me.renderProductRow(me.props.productFilters.products[i], i));
            }
            else {
                break;
            }
        }
        me.setState({items: list});
    },

    scrollTable: function (e) {
        var offset = - e.target.scrollLeft;
        var headers = e.target.querySelectorAll('table thead th');

        for (var i = 0; i < headers.length; i++) {
            headers[i].querySelector('div').style.left = offset + 'px';
            offset += headers[i].offsetWidth;
        }
    },

    render: function () {
        var me = this;
        var productMeta = this.props.productFilters.productMetadata;
        //var titleCols=['Select','Description','Brand','Pack Size', 'Pack Size Unit','Container Size', 'Container Size Unit','Category','Container Type']
        var titleCols = [AppManager.getLabel('PP_LBL_INCLUDED'), productMeta.Name.label, productMeta.Description_1__c.label, productMeta.Pack_Size__c.label,
            productMeta.Pack_Size_Unit__c.label, productMeta.Container_Size__c.label, productMeta.Container_Size_Unit__c.label, productMeta.Product_Form__c.label,
            productMeta.Container_Type__c.label];

        return (
            <div className="table-wrapper"> 
              <div className="slds-grid slds-scrollable--x">
                <div className="table--fixed-header slds-m-vertical--large slds-m-top--large">
                    <section onScroll={(event) => this.scrollTable(event)}>
                        <table className="slds-table--bordered slds-table--cell-buffer">
                            <thead>
                            <tr className="slds-text-heading--label">
                                {titleCols.map((title, ix)=> <th key={ix} scope="col" title={title}>
                                    {title}
                                    <div className="slds-truncate">{title}</div>
                                </th>)}
                            </tr>
                            </thead>
                            <tbody>
                            {me.props.productFilters.products.map((product, ix) => me.renderProductRow(product, ix))}
                            {this.state.items}
                            </tbody>
                        </table>
                    </section>
                  </div>
              </div>
            </div>
        )
    }
});
