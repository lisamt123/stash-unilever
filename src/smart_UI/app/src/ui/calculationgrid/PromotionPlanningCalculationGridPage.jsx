'use strict';
var React = require('react');
var ReactDOM = require('react-dom');
var Button = require('react-lightning-design-system').Button;
var Icon = require('react-lightning-design-system').Icon;
var _ = require('lodash');
var classNames = require('classnames');

var HighlightCells = false;

/*******************************
 *  Main component for the Grid page.
 */
var PromotionPlanningCalculationGridPage = React.createClass({
    propTypes: {
        tree: React.PropTypes.object, //MAtrix object for calculation
        editMode: React.PropTypes.bool //Flag for enabling editing window
    },

    getInitialState: function () {
        return {
            tree: this.props.tree,
            editMode: this.props.editMode
        }
    },

    render: function () {
        return (
            <div className='tpm-calc-grid'>
                {(this.props.tree == null) ?
                    <div style={{flex:'1 0 0',paddingTop:'15em'}}
                         className="slds-grid slds-grid--vertical-align-center slds-grid--align-center">
                        <div className="slds-spinner_container">
                            <div className="slds-spinner--brand slds-spinner slds-spinner--large" aria-hidden="false"
                                 role="alert">
                                <div className="slds-spinner__dot-a"></div>
                                <div className="slds-spinner__dot-b"></div>
                            </div>
                        </div>
                        <div style={{fontSize:'2em',marginLeft:'2em'}}>Loading content...</div>
                    </div>
                    : <PromotionPlanningCalculationGrid tree={this.props.tree}
                                                        object={this.props.tree.getRootNode()}
                                                        editMode={this.props.editMode}
                                                        idToLabelMapping={this.props.idToLabelMapping}
                                                        acl={this.props.acl}/>}
                                                        
            </div>
        )
    }
});

/*******************************
 *  Grid component for the Calculation of KPIs.
 */
var PromotionPlanningCalculationGrid = React.createClass({
    MAXIMUM_NUMBER_OF_COLUMNS_TO_DISPLAY: 6,

    propTypes: {
        tree: React.PropTypes.object,   // Reference to the Tree
        object: React.PropTypes.object, // Reference to the RootNode of the Tree
        editMode: React.PropTypes.bool  // Defines whether the editMode is active or not
    },

    getInitialState: function () {
        var maxCols = this.MAXIMUM_NUMBER_OF_COLUMNS_TO_DISPLAY;
        var timeDetails = this.props.tree.getTimeDetails();
        var numberOfDataColumns = timeDetails.length; //(excluding the totalcolumn)
        var dataEndIndex = _.min([numberOfDataColumns, maxCols]);

        return {
            dataStartIndex: 0,
            dataEndIndex: dataEndIndex,
            numberOfDataColumns: numberOfDataColumns,
            numberOfColumnsToDisplay: maxCols
        }
    },

    getMaxCols: function () {

        var MAX_NUMBER_COLS = this.MAXIMUM_NUMBER_OF_COLUMNS_TO_DISPLAY;
        var maxNumberOfColumns = this.getPossibleDisplayableNumberOfColumns();

        return _.min([maxNumberOfColumns, MAX_NUMBER_COLS]);
    },

    getPossibleDisplayableNumberOfColumns: function() {
        var sizePerColumn = 110;
        var assumedUsedPageSize = 550; // does not consider a collapsed sidebar

        var screenWidth = window.innerWidth;
        var nodeRect = ReactDOM.findDOMNode(this).getBoundingClientRect();
        var dataWidth = screenWidth - assumedUsedPageSize - nodeRect.left;

        return Math.floor(dataWidth / sizePerColumn);
    },

    handleResize: function (e) {
        this.calculateResizedValues(this.state.numberOfDataColumns);
    },

    calculateResizedValues: function(numberOfDataColumns) {
        var maxCols = this.getMaxCols();
        var dataStartIndex = this.state.dataStartIndex;

        // update the EndIndex based on the new viewable number of columns and the original StartIndex
        var dataEndIndex = dataStartIndex + maxCols;

        // update the StartIndex in case the end of the grid has been reached but more columns could be displayed
        if(dataEndIndex > numberOfDataColumns) {
            var difference = dataEndIndex - numberOfDataColumns;

            dataStartIndex = _.max([0, dataStartIndex - difference]);
            dataEndIndex = numberOfDataColumns;
        }

        this.setState({
            dataStartIndex: dataStartIndex,
            dataEndIndex: dataEndIndex,
            numberOfColumnsToDisplay: maxCols
        });
    },

    componentWillReceiveProps: function(nextProps) {
        if(nextProps.tree !== null && nextProps.tree !== undefined) {
            var newTimeDetails = nextProps.tree.getTimeDetails();
            var numberOfDataColumns = newTimeDetails.length;

            if(this.state.numberOfDataColumns !== numberOfDataColumns) {
                this.setState({numberOfDataColumns: numberOfDataColumns});
                this.calculateResizedValues(numberOfDataColumns);
            }
        }
    },

    componentDidMount: function () {
        window.addEventListener('resize', this.handleResize);
        this.handleResize();
    },

    componentDidUpdate: function () {
        HighlightCells = true;
    },

    componentWillUnmount: function () {
        window.removeEventListener('resize', this.handleResize);
    },

    //Shouldn't be weeks, redundant code.
    prevWeeks: function () {
        HighlightCells = false;

        var dataStartIndex = this.state.dataStartIndex - this.state.numberOfColumnsToDisplay;
        dataStartIndex = _.max([dataStartIndex, 0]);

        var dataEndIndex = dataStartIndex + this.state.numberOfColumnsToDisplay;
        dataEndIndex = _.min([dataEndIndex, this.state.numberOfDataColumns]);

        this.setState({
            dataStartIndex: dataStartIndex,
            dataEndIndex: dataEndIndex
        })
    },

    nextWeeks: function () {
        HighlightCells = false;

        var dataStartIndex = this.state.dataStartIndex + this.state.numberOfColumnsToDisplay;
        dataStartIndex = _.min([dataStartIndex, this.state.numberOfDataColumns]);

        var dataEndIndex = dataStartIndex + this.state.numberOfColumnsToDisplay;
        dataEndIndex = _.min([dataEndIndex, this.state.numberOfDataColumns]);

        this.setState({
            dataStartIndex: dataStartIndex,
            dataEndIndex: dataEndIndex
        })
    },

    renderHeader: function () {
        var timeDetails = this.props.tree.getTimeDetails();
        // Get only a part of the data which shall be visible (excluding the TotalColumn)
        var shownColumnHeaderValues = timeDetails.slice(this.state.dataStartIndex, this.state.dataEndIndex);
        var disablePrev = (this.state.dataStartIndex === 0);
        var disableNext = (this.state.dataEndIndex === this.state.numberOfDataColumns);

        // FixMe: Localize the Buttons!
        return (
            <div className="grid-header">
                <div className="grid-header-row">
                    <div className="grid-header-label-cell">
                        {<Button type='neutral' icon='chevronleft' size='x-small' iconAlign='left'
                                 disabled={disablePrev}
                                 onClick={() => this.prevWeeks()}>Previous</Button>}
                        {<Button type='neutral' icon='chevronright' size='x-small' iconAlign='left'
                                 disabled={disableNext}
                                 onClick={() => this.nextWeeks()}>Next</Button>}
                    </div>
                    {<div className="grid-header-cell" key={0}><ColumnHead value={"Total"}/></div>}
                    {shownColumnHeaderValues.map((columnHeaderValue, columnHeaderIndex) => {
                        return (<div className="grid-header-cell" key={columnHeaderIndex}><ColumnHead
                            value={columnHeaderValue.calendaryear+"/"+columnHeaderValue.week}/></div>)
                    })}
                </div>
            </div>
        );
    },

    render: function () {
        var acl = this.props.acl;
        return (
            <div style={{position:'absolute',height:100+'%',display:'flex',flexDirection:'column'}}>
                <div className='grid-table' style={{height:100+'%'}}>
                    {this.renderHeader()}
                    <div className='grid-body  slds-scrollable--y'>
                        {this.props.object.getChildren().map((treeNode) => {
                            return (<PromotionPlanningCalculationRow
                                key={treeNode.id}
                                treeNode={treeNode}
                                root={true}
                                dataStartIndex={this.state.dataStartIndex}
                                dataEndIndex={this.state.dataEndIndex}
                                editMode={this.props.editMode}
                                idToLabelMapping={this.props.idToLabelMapping}
                                editable = {acl.isEditable(1,treeNode._measureDefinition.name)}
                                />)
                        })}
                    </div>
                </div>
            </div>
        )
    }
});

var ColumnHead = React.createClass({
    propTypes: {
        value: React.PropTypes.string // Title of column
    },

    render: function () {
        return <div>{this.props.value}</div>
    }
});

/*******************************
 *  Auxiliary component for the returning different DOM elements.
 */
function statelessWrapper(props) {
    return props.children;
}

/*******************************
 *  Row component for the Calculation grid.
 */
var rootLevelNodes = [];

var PromotionPlanningCalculationRow = React.createClass({
    propTypes: {
        dataStartIndex: React.PropTypes.number,
        dataEndIndex: React.PropTypes.number,
        editMode: React.PropTypes.bool,
        root: React.PropTypes.bool, // Indicates if this element is the root of the grid-rows
        treeNode: React.PropTypes.object, //Matrix.js object
        parentUpdate: React.PropTypes.func // Function to update the parent
    },

    getInitialState: function () {
        return {
            opened: false,
            version: 0
        }
    },

    toggle: function () {
        this.setState({opened: !this.state.opened});
    },

    update: function () {
        this.setState({version: this.state.version + 1});

        // If the method to update the parent node is specified execute it
        if (this.props.parentUpdate) {
            this.props.parentUpdate();
        }
        else {
            var measureDefinition = this.props.treeNode.getMeasureDefinition();
            var dependingMeasures = measureDefinition.dependingMeasures;

            for (var measureIndex = 0; measureIndex < dependingMeasures.length; measureIndex++) {
                if (dependingMeasures[measureIndex] !== undefined) {
                    rootLevelNodes.forEach(function (keyValuePair) {
                        if (keyValuePair[1] === dependingMeasures[measureIndex].name) {
                            keyValuePair[0].update();
                        }
                    });
                }
            }
        }
    },

    /**
     * Gets the current level
     * 1-based!
     * @return {number}
     */
    getLevel: function () {
        return this.props.treeNode.getLevel() + 1;
    },

    componentDidMount: function () {
        if (this.props.root) {
            rootLevelNodes.push([this, this.props.treeNode.getMeasureDefinition().name]);
        }
    },

    createPadders: function (currentLevel) {
        var padders = [];

        for (var i = 1; i < currentLevel; i++) {
            padders.push(<div key={i} className="padder"></div>)
        }

        return padders;
    },

    createChildSelector: function () {
        var childSelector = null;

        if (this.props.treeNode.showChildren()) {
            childSelector = ((this.state.opened) ? <Icon key="open" className="handler" icon="chevrondown" size='x-small'/> :
                <Icon key="closed" className="handler" icon="chevronright" size='x-small'/>);
        }

        return childSelector;
    },

    renderLabelCell: function (level) {
        var nodeLabel = this.props.treeNode.getLabel();

        //root labels are coming from configuration itself

       // if (boPromotion) {
         //   var text = boPromotion.LOExtProduct.getLabel(nodeLabel);
        if (this.props.idToLabelMapping) {
            var text =this.props.idToLabelMapping[nodeLabel];
            if (text == undefined)
                text = '#' + nodeLabel;
        }
        else
            text = '#' + nodeLabel;
        var padders = this.createPadders(level);
        var childSelector = this.createChildSelector();

        return (
            <div className="sub-row">
                {padders}
                <div className="label-cell" onClick={()=>this.toggle()}><span>{childSelector} {text}</span></div>
            </div>);
    },

    renderValueCells: function (treeNode, showData) {
        var version = this.state.version;
        var Rounding = treeNode.getRounding();
        return showData.map((cellValue, cellIndex) => {
            var correctedCellIndex = cellIndex + this.props.dataStartIndex;
            return (
                <div className="data-cell" key={treeNode.id + "." + correctedCellIndex}>
                    <PromotionPlanningCalculationCell
                        className="cellValue"
                        precision={Rounding}
                        value={cellValue}
                        editable={this.props.editMode  && this.props.editable && treeNode.isEditAllowed(correctedCellIndex)}
                        version={version}
                        setter={value => {treeNode.set(correctedCellIndex, value);
                                    this.update();
                                }}/>
                </div>); //TODO
        });
    },

    render: function () {
        var treeNode = this.props.treeNode;
        var data = treeNode.getData();

        var showData = data.slice(this.props.dataStartIndex + 1, this.props.dataEndIndex + 1);
        showData.unshift(data[0]);

        var level = this.getLevel();

        var rowClassName = 'level' + level + '-row row';
        var measureEAR = this.props.editable;
        var currentRow = (!treeNode.showInUI() ? null :
            <div className={rowClassName}>
                {this.renderLabelCell(level)}
                {this.renderValueCells(treeNode, showData)}
            </div>);

        var childrenRows = (this.state.opened) ?
            this.props.treeNode.getChildren().map((childNode) => {
                return (<PromotionPlanningCalculationRow
                    key={childNode.id}
                    treeNode={childNode}
                    root={false}
                    dataStartIndex={this.props.dataStartIndex}
                    dataEndIndex={this.props.dataEndIndex}
                    parentUpdate={this.update}
                    editMode={this.props.editMode}
                    idToLabelMapping={this.props.idToLabelMapping}
                    editable={measureEAR}
                    />)
            })
            : null;

        return (currentRow ? <statelessWrapper>{currentRow}{childrenRows}</statelessWrapper> : null)
    }
});

/*******************************
 *  Cell component for the Calculation grid.
 */
var PromotionPlanningCalculationCell = React.createClass({
    propTypes: {
        className: React.PropTypes.string,
        precision: React.PropTypes.number,
        editable: React.PropTypes.bool,
        version: React.PropTypes.number,
        setter: React.PropTypes.func,
        value: React.PropTypes.number
    },

    getInitialState: function () {
        return {
            clickedOn: false,
            value: this.props.value,
            version: this.props.version
        }
    },

    close: function () {
        var newValue = parseFloat(this.state.value);
        if (Number.isNaN(newValue)) {
            newValue = null;
        }

        if (newValue + '' != this.props.value) {
            this.props.setter(newValue);
        }
        this.setState({clickedOn: false});
    },

    componentWillReceiveProps: function (next) {
        if (this.props.value != next.value && HighlightCells) {
            var node = ReactDOM.findDOMNode(this);
            node = this.props.rowCell ? node : node.parentNode;
            node.className += " HighlightedCell";
            setTimeout(() => node.className = node.className.replace(" HighlightedCell", ""), 1500);
        }
        this.setState({
            value: next.value,
            version: next.version
        });
    },

    componentDidUpdate: function () {
        if (this.state.clickedOn) {
            ReactDOM.findDOMNode(this.refs.inputCell).focus();
        }
    },

    changeValue: function (event) {
        this.setState({value: event.target.value});
    },

    closeOnEnterKey: function (event) {
        if (event.key == "Enter") {
            this.close();
        }
    },

    onKeyPress: function (e) {
        Utils.Validators.onlyKeyEventNumber(e);
    },

    setAsClickedIfEditable: function () {
        return this.props.editable && this.setState({clickedOn: true});
    },

    render: function () {
        var props = this.props;
        var resultElement;

        if (this.state.clickedOn) {
            var inputValue = '';
            if (this.state.value !== null && this.state.value !== undefined && !isNaN(this.state.value)) {
                inputValue = Utils.Converters.NumberRound(this.state.value, props.precision);
            }

            resultElement =
                <div className={classNames(props.className)}>
                    <input type="text" ref="inputCell"
                           value={inputValue} size="8"
                           className="EdiCellInput"
                           onKeyDown={this.closeOnEnterKey}
                           onBlur={this.close}
                           onKeyPress={this.onKeyPress}
                           onChange={this.changeValue}/>
                </div>;
        } else {
            var displayValue = '';
            if (this.state.value !== null && this.state.value !== undefined && !isNaN(this.state.value)) {
                displayValue = Utils.Formatters.formatNumber(this.state.value, this.props.precision, this.props.precision);
            } else {
                displayValue = "\u00A0\u00A0\u00A0\u00A0\u00A0";
            }

            resultElement = <span className={classNames(props.className,{'editableValue': props.editable})}
                                  onClick={this.setAsClickedIfEditable}>
                                {displayValue}
                            </span>;
        }

        return resultElement;
    }
});

module.exports = PromotionPlanningCalculationGridPage;
