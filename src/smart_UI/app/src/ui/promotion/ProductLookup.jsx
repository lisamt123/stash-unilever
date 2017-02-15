"use strict";

var React = require('react');
var Input = require('react-lightning-design-system').Input;

var Picklist = require('react-lightning-design-system').Picklist;
var PicklistItem = require('react-lightning-design-system').PicklistItem;
var Button = require('react-lightning-design-system').Button;
var Checkbox = require('react-lightning-design-system').Checkbox;

module.exports = React.createClass({
    displayName: 'ProductLookup',

    getInitialState: function () {
        return {
            productSample: {
                Description_1__c: '',
                Name: '',
                Pack_Size__c: '',
                Pack_Size_Unit__c: '',
                Container_Size__c: '',
                Container_Size_Unit__c: '',
                Product_Form__c: '',
                Container_Type__c: '',
                UL_Material_Type__c: ''
            },
            selectedProducts: [],
            productSearch: []
        }
    },

    componentWillUnmount: function () {
        PromotionActions.clearSearchForProducts(); //Clearing the collection
    },

    onFieldChange: function (name, value) {
        this.state.productSample[name] = value;
        this.setState({ productSample: this.state.productSample });
    },

    onAdd: function () {
        this.props.addHandler(this.state.selectedProducts);
    },

    onSearch: function () {
        this.props.searchHandler(this.state.productSample);
    },

    onCancel: function () {
        this.props.cancelHandler();
    },

    toggleSelection: function (product) {
        var productIndex = this.state.selectedProducts.indexOf(product);
        if (productIndex == -1) {
            this.state.selectedProducts.push(product);
        }
        else {
            this.state.selectedProducts.splice(productIndex, 1);
        }
        this.forceUpdate();
    },

    renderProductRow: function (product, ix) {
        return (
            <tr key={"productGrid" + ix}>
                <td>
                    <Checkbox onChange={() => this.toggleSelection(product)}
                        checked={this.state.selectedProducts.indexOf(product) != -1} />
                </td>
                <td>
                    <div className="slds-truncate">{product.Name}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Description_1__c}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Pack_Size__c}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Pack_Size_Unit__c}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Container_Size__c}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Container_Size_Unit__c}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Product_Form__c}</div>
                </td>
                <td>
                    <div className="slds-truncate">{product.Container_Type__c}</div>
                </td>
            </tr>
        )
    },

    scrollTable: function (e) {
        var offset = 8 - e.target.scrollLeft;
        var headers = e.target.querySelectorAll('table thead th');

        for (var i = 0; i < headers.length; i++) {
            headers[i].querySelector('div').style.left = offset + 'px';
            offset += headers[i].offsetWidth;
        }
    },

    renderProductSearchGrid: function () {
        var me = this;
        var productMeta = this.props.productFilters.productMetadata;
        var titleCols = [AppManager.getLabel('PP_LBL_SELECT') || 'Select', productMeta.Name.label, productMeta.Description_1__c.label, productMeta.Pack_Size__c.label,
        productMeta.Pack_Size_Unit__c.label, productMeta.Container_Size__c.label, productMeta.Container_Size_Unit__c.label,
        productMeta.Product_Form__c.label, productMeta.Container_Type__c.label];
        return (
            <div className="table--fixed-header slds-m-vertical--large slds-m-top--large" style={{ height: '334px' }}>
                <section onScroll={(event) => this.scrollTable(event)} style={{ height: '299px' }}>
                    <table className="slds-table--bordered slds-table--cell-buffer">
                        <thead>
                            <tr className="slds-text-heading--label">
                                {titleCols.map((title, ix) => <th key={ix} scope="col" title={title}>
                                    {title}
                                    <div className="slds-truncate">{title}</div>
                                </th>)}
                            </tr>
                        </thead>
                        <tbody>
                            {this.props.productSearch.map((product, ix) => me.renderProductRow(product, ix))}
                        </tbody>
                    </table>
                </section>
            </div>
        )
    },

    renderProductSearchForm: function () {
        var productMeta = this.props.productFilters.productMetadata;
        return (
            <div className="slds-grid ">
                <div className="slds-col--padded">
                    <Input label={productMeta.Description_1__c.label} type='text' value={this.state.Description_1__c}
                        onChange={(e, value) => this.onFieldChange('Description_1__c', value)} />
                    <Input label={productMeta.Name.label} type='text' value={this.state.Name}
                        onChange={(e, value) => this.onFieldChange('Name', value)} />
                    <Picklist label={productMeta.UL_Material_Type__c.label} value={this.state.UL_Material_Type__c}
                                onValueChange={(value) => this.onFieldChange('UL_Material_Type__c', value)}>
                                <PicklistItem key='0' value='' label='All' />
                                {productMeta.UL_Material_Type__c.picklistValues.map((a, i) => {
                                    return <PicklistItem key={i + 1} value={a.value} label={a.label} />;
                                })}
                            </Picklist>
                </div>
                <div className="slds-col--padded">

                    <div className="slds-grid ">
                        <div className="slds-col--padded">
                            <Input label={productMeta.Pack_Size__c.label} type='text' value={this.state.Pack_Size__c}
                                onChange={(e, value) => this.onFieldChange('Pack_Size__c', value)} />
                        </div>
                        <div className="slds-col--padded">
                            <Picklist label={productMeta.Pack_Size_Unit__c.label} value={this.state.Pack_Size_Unit__c}
                                onValueChange={(value) => this.onFieldChange('Pack_Size_Unit__c', value)}>
                                <PicklistItem key='0' value='' label='All' />
                                {productMeta.Pack_Size_Unit__c.picklistValues.map((a, i) => {
                                    return <PicklistItem key={i + 1} value={a.value} label={a.label} />;
                                })}
                            </Picklist>
                        </div>
                    </div>
                    <div className="slds-grid ">
                        <div className="slds-col--padded">
                            <Input label={productMeta.Container_Size__c.label} type='text'
                                value={this.state.Container_Size__c}
                                onChange={(e, value) => this.onFieldChange('Container_Size__c', value)} />
                        </div>
                        <div className="slds-col--padded">
                            <Picklist label={productMeta.Container_Size_Unit__c.label}
                                value={this.state.Container_Size_Unit__c}
                                onValueChange={(value) => this.onFieldChange('Container_Size_Unit__c', value)}>
                                <PicklistItem key='0' value='' label='All' />
                                {productMeta.Container_Size_Unit__c.picklistValues.map((a, i) => {
                                    return <PicklistItem key={i + 1} value={a.value} label={a.label} />;
                                })}
                            </Picklist>
                        </div>
                    </div>
                </div>
                <div className="slds-col--padded">
                    <Picklist label={productMeta.Product_Form__c.label} value={this.state.Product_Form__c}
                        onValueChange={(value) => this.onFieldChange('Product_Form__c', value)}>
                        <PicklistItem key='0' value='' label='All' />
                        {productMeta.Product_Form__c.picklistValues.map((a, i) => {
                            return <PicklistItem key={i + 1} value={a.value} label={a.label} />;
                        })}
                    </Picklist>

                    <Picklist label={productMeta.Container_Type__c.label} value={this.state.Container_Type__c}
                        onValueChange={(value) => this.onFieldChange('Container_Type__c', value)}>
                        <PicklistItem key='0' value='' label='All' />
                        {productMeta.Container_Type__c.picklistValues.map((a, i) => {
                            return <PicklistItem key={i + 1} value={a.value} label={a.label} />;
                        })}
                    </Picklist>

                </div>
            </div>
        )
    },

    render: function () {
        return (
            <div>
                <div className="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">
                    <div className="slds-modal__container" style={{ minWidth: '70rem' }}>
                        <div className="slds-modal__header">
                            <h2 className="slds-text-heading--medium">{AppManager.getLabel('PP_TIT_PROD_LOOKUP') || 'Product Lookup'}</h2>
                        </div>
                        <div className="slds-modal__content slds-p-around--medium">
                            <div>
                                {this.renderProductSearchForm()}

                                <section className="slds-clearfix slds-m-top--medium">
                                    <div className="slds-float--right">
                                        <Button type='neutral'
                                            onClick={() => this.onSearch()}>{AppManager.getLabel('PP_BTN_SEARCH') || 'Search'}</Button>
                                    </div>
                                </section>
                                <div className="slds-m-top--medium"></div>

                                {this.renderProductSearchGrid()}

                            </div>
                        </div>
                        <div className="slds-modal__footer">
                            <button className="slds-button slds-button--neutral"
                                onClick={() => this.onCancel()}>{AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}</button>
                            <button className="slds-button slds-button--neutral slds-button--brand"
                                onClick={() => this.onAdd()}>{AppManager.getLabel('PP_BTN_ADD') || 'Add'}</button>
                        </div>
                    </div>
                </div>
                <div className="slds-backdrop slds-backdrop--open"></div>
            </div>
        )
    }
});
