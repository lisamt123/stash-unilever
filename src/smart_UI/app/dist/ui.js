webpackJsonp([2],{

/***/ 0:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	__webpack_require__(275);
	__webpack_require__(279);
	__webpack_require__(281);

	//Import 3rd party libraries
	global.React = __webpack_require__(283);
	global.ReactDOM = __webpack_require__(313);
	global.PromotionCalendar = __webpack_require__(459);
	global.PromotionPlanning = __webpack_require__(619);
	global.Modal = __webpack_require__(659);
	global.Top = __webpack_require__(660);
	global.PromotionActions = __webpack_require__(643).PromotionActions;
	global.UI = { moment: __webpack_require__(50) }; //[US] 366271 
	var _reactLightningDesignSystem = __webpack_require__(461);

	//SF resources
	if (typeof sfldsURL !== 'undefined') {
	    _reactLightningDesignSystem.util.setAssetRoot(sfldsURL);
	}

	//Common things
	var preventDefault = function preventDefault(e) {
	    return e.preventDefault();
	};

	addEventListener('dragover', preventDefault);
	addEventListener('drop', preventDefault);

	AppManager.init().then(function () {
	    __webpack_require__(50).locale(AppSettings.get('locale'));
	});
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 279:
/***/ function(module, exports) {

	// removed by extract-text-webpack-plugin

/***/ },

/***/ 281:
/***/ function(module, exports) {

	// removed by extract-text-webpack-plugin

/***/ },

/***/ 459:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var AppHeader = __webpack_require__(460);
	var SidePanel = __webpack_require__(605);

	var CalendarHeader = __webpack_require__(606);
	var PromotionCalendarGrid = __webpack_require__(612);
	var CalendarFilter = __webpack_require__(615);
	var InitCalendar = __webpack_require__(618);

	var PromCalendarActions = __webpack_require__(607).PromCalendarActions;

	module.exports = React.createClass({
	    displayName: 'PromotionCalendar',

	    getInitialState: function getInitialState() {
	        return {
	            calendar: null,
	            promotionDetailData: null,
	            showFilter: false
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        this.busHandlerID = UI_EVENT_BUS.subscribe(EVENTS.UI_BINDING, this.onUIBinding);
	        window.addEventListener('resize', this.handleResize);
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        UI_EVENT_BUS.unsubscribe(this.busHandlerID);
	        window.removeEventListener('resize', this.handleResize);
	    },

	    handleResize: function handleResize() {
	        this.forceUpdate();
	    },

	    onUIBinding: function onUIBinding(payload) {
	        this.setState(payload);
	    },

	    toggleFilter: function toggleFilter() {
	        var me = this;
	        PromCalendarActions.cancelChangeCalendarFilter();
	        this.setState({ showFilter: !this.state.showFilter }, function () {
	            me.refs.CalendarGrid.forceUpdate();
	        });
	    },

	    saveFilter: function saveFilter(filterData) {
	        var me = this;
	        PromCalendarActions.changeCalendarFilter(this.state.calendar.FilterCriteria);
	        this.setState({ showFilter: !this.state.showFilter }, function () {
	            me.refs.CalendarGrid.forceUpdate();
	        });
	    },

	    addPromotion: function addPromotion(promotion) {
	        console.log('addPromotion...');
	        PromCalendarActions.addPromotion(promotion);
	    },

	    saveSettingsHandler: function saveSettingsHandler(filterData) {
	        this.state.calendar.showInitialSettings = false;
	        this.setState({ calendar: this.state.calendar });
	        PromCalendarActions.changeCalendarFilter(this.state.calendar.FilterCriteria);
	    },

	    cancelSettingsHandler: function cancelSettingsHandler() {
	        this.state.calendar.showInitialSettings = false;
	        this.setState({ calendar: this.state.calendar });
	        PromCalendarActions.changeCalendarFilter(null);
	    },

	    render: function render() {
	        var _this = this;

	        return React.createElement(
	            'div',
	            { className: 'mainSection promotionCalendar' },
	            this.state.calendar && this.state.calendar.showInitialSettings ? React.createElement(InitCalendar, { calendar: this.state.calendar, saveHandler: this.saveSettingsHandler,
	                cancelHandler: this.cancelSettingsHandler }) : null,
	            React.createElement(CalendarHeader, { showFilter: this.state.showFilter, toggleFilter: this.toggleFilter,
	                addPromotion: this.addPromotion, calendar: this.state.calendar }),
	            React.createElement(
	                'div',
	                { className: 'vertical-flex' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-col slds-grid slds-grid--vertical-stretch' },
	                    React.createElement(PromotionCalendarGrid, { ref: 'CalendarGrid', calendar: this.state.calendar,
	                        promotionDetailData: this.state.promotionDetailData }),
	                    this.state.showFilter ? React.createElement(CalendarFilter, {
	                        calendar: this.state.calendar, closeHandler: this.toggleFilter,
	                        saveHandler: function saveHandler() {
	                            return _this.saveFilter();
	                        } }) : null
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 460:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Icon = __webpack_require__(461).Icon;

	var Truncate = __webpack_require__(603);

	module.exports = React.createClass({
	    displayName: 'exports',

	    render: function render() {
	        var icon = null;

	        if (this.props.icon && this.props.icon.indexOf('.') == -1) {
	            icon = React.createElement(Icon, { category: 'standard', icon: this.props.icon, size: 'large' });
	        } else {
	            icon = React.createElement(
	                'span',
	                { className: 'slds-avatar' },
	                React.createElement('img', { src: Utils.HTTP.getImgUrl(this.props.icon), alt: 'promo' })
	            );
	        }

	        return React.createElement(
	            'div',
	            { className: 'slds-page-header', role: 'banner' },
	            React.createElement(
	                'div',
	                { className: 'slds-media slds-media--center' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-media__figure' },
	                    icon
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-media__body' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-page-header__title slds-truncate slds-align-middle' },
	                        React.createElement(Truncate, { lines: 1,
	                            children: this.props.title })
	                    ),
	                    React.createElement(
	                        'p',
	                        { className: 'slds-text-body--small slds-page-header__info' },
	                        this.props.subtitle,
	                        ' '
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 603:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Truncate = __webpack_require__(604);

	module.exports = React.createClass({
	    displayName: 'exports',


	    getInitialState: function getInitialState() {
	        return {
	            truncate: false
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        var canvas = document.createElement('canvas');
	        this.canvas = canvas.getContext('2d');

	        var style = window.getComputedStyle(this.refs.container);

	        var font = [style['font-weight'], style['font-style'], style['font-size'], style['font-family']].join(' ');

	        this.canvas.font = font;

	        this.checkWidth(this.props.children);

	        window.addEventListener('resize', this.onResize);
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        window.removeEventListener('resize', this.onResize);
	    },

	    onResize: function onResize() {
	        this.checkWidth(this.props.children);
	    },

	    checkWidth: function checkWidth(text) {
	        var textWidth = this.canvas.measureText(text).width;

	        var parentNode = this.refs.container.parentNode; //span - not truncated
	        if (!parentNode) {
	            parentNode = this.refs.container.refs.target.parentNode; //truncate component
	        }

	        var targetWidth = parentNode.getBoundingClientRect().width;

	        this.setState({
	            truncate: textWidth !== targetWidth
	        });
	    },

	    componentDidUpdate: function componentDidUpdate(prevProps) {
	        if (this.props.children !== prevProps.children) {
	            this.checkWidth(this.props.children);
	        }
	    },


	    render: function render() {
	        if (this.state.truncate) return React.createElement(Truncate, { ref: 'container', lines: this.props.lines,
	            onTruncate: this.props.onTruncate,
	            children: this.props.children });else return React.createElement(
	            'span',
	            { ref: 'container' },
	            this.props.children
	        );
	    }
		});

/***/ },

/***/ 604:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

	var _react = __webpack_require__(283);

	var _react2 = _interopRequireDefault(_react);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

	var Truncate = function (_Component) {
	    _inherits(Truncate, _Component);

	    function Truncate() {
	        var _ref;

	        _classCallCheck(this, Truncate);

	        for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
	            args[_key] = arguments[_key];
	        }

	        var _this = _possibleConstructorReturn(this, (_ref = Truncate.__proto__ || Object.getPrototypeOf(Truncate)).call.apply(_ref, [this].concat(args)));

	        _this.state = {};
	        _this.styles = {
	            ellipsis: {
	                position: 'fixed',
	                visibility: 'hidden',
	                top: 0,
	                left: 0
	            }
	        };


	        _this.onResize = _this.onResize.bind(_this);
	        _this.onTruncate = _this.onTruncate.bind(_this);
	        _this.calcTargetWidth = _this.calcTargetWidth.bind(_this);
	        _this.measureWidth = _this.measureWidth.bind(_this);
	        _this.getLines = _this.getLines.bind(_this);
	        _this.renderLine = _this.renderLine.bind(_this);
	        return _this;
	    }

	    _createClass(Truncate, [{
	        key: 'componentDidMount',
	        value: function componentDidMount() {
	            var _refs = this.refs,
	                text = _refs.text,
	                ellipsis = _refs.ellipsis,
	                calcTargetWidth = this.calcTargetWidth,
	                onResize = this.onResize;


	            var canvas = document.createElement('canvas');
	            this.canvas = canvas.getContext('2d');

	            // Keep node in document body to read .offsetWidth
	            document.body.appendChild(ellipsis);

	            calcTargetWidth(function () {
	                // Node not needed in document tree to read its content
	                if (text) {
	                    text.parentNode.removeChild(text);
	                }
	            });

	            window.addEventListener('resize', onResize);
	        }
	    }, {
	        key: 'componentDidUpdate',
	        value: function componentDidUpdate(prevProps) {
	            // Render was based on outdated refs and needs to be rerun
	            if (this.props.children !== prevProps.children) {
	                this.forceUpdate();
	            }
	        }
	    }, {
	        key: 'componentWillUnmount',
	        value: function componentWillUnmount() {
	            var ellipsis = this.refs.ellipsis,
	                onResize = this.onResize,
	                timeout = this.timeout;


	            ellipsis.parentNode.removeChild(ellipsis);

	            window.removeEventListener('resize', onResize);

	            cancelAnimationFrame(timeout);
	        }

	        // Shim innerText to consistently break lines at <br/> but not at \n

	    }, {
	        key: 'innerText',
	        value: function innerText(node) {
	            var div = document.createElement('div');
	            div.innerHTML = node.innerHTML.replace(/\r\n|\r|\n/g, ' ');

	            var text = div.innerText;

	            var test = document.createElement('div');
	            test.innerHTML = 'foo<br/>bar';

	            if (test.innerText.replace(/\r\n|\r/g, '\n') !== 'foo\nbar') {
	                div.innerHTML = div.innerHTML.replace(/<br.*?[\/]?>/gi, '\n');
	                text = div.innerText;
	            }

	            return text;
	        }
	    }, {
	        key: 'onResize',
	        value: function onResize() {
	            this.calcTargetWidth();
	        }
	    }, {
	        key: 'onTruncate',
	        value: function onTruncate(didTruncate) {
	            var onTruncate = this.props.onTruncate;


	            if (typeof onTruncate === 'function') {
	                this.timeout = requestAnimationFrame(function () {
	                    onTruncate(didTruncate);
	                });
	            }
	        }
	    }, {
	        key: 'calcTargetWidth',
	        value: function calcTargetWidth(callback) {
	            var target = this.refs.target,
	                calcTargetWidth = this.calcTargetWidth,
	                canvas = this.canvas;

	            // Calculation is no longer relevant, since node has been removed

	            if (!target) {
	                return;
	            }

	            var targetWidth = target.parentNode.getBoundingClientRect().width;

	            // Delay calculation until parent node is inserted to the document
	            // Mounting order in React is ChildComponent, ParentComponent
	            if (!targetWidth) {
	                return requestAnimationFrame(function () {
	                    return calcTargetWidth(callback);
	                });
	            }

	            var style = window.getComputedStyle(target);

	            var font = [style['font-weight'], style['font-style'], style['font-size'], style['font-family'], style['letter-spacing'], style['word-spacing']].join(' ');

	            canvas.font = font;

	            this.setState({
	                targetWidth: targetWidth
	            }, callback);
	        }
	    }, {
	        key: 'measureWidth',
	        value: function measureWidth(text) {
	            return this.canvas.measureText(text).width;
	        }
	    }, {
	        key: 'ellipsisWidth',
	        value: function ellipsisWidth(node) {
	            return node.offsetWidth;
	        }
	    }, {
	        key: 'getLines',
	        value: function getLines() {
	            var refs = this.refs,
	                _props = this.props,
	                numLines = _props.lines,
	                ellipsis = _props.ellipsis,
	                targetWidth = this.state.targetWidth,
	                innerText = this.innerText,
	                measureWidth = this.measureWidth,
	                onTruncate = this.onTruncate;


	            var lines = [];
	            var text = innerText(refs.text);
	            var textLines = text.split('\n').map(function (line) {
	                return line.split(' ');
	            });
	            var didTruncate = true;
	            var ellipsisWidth = this.ellipsisWidth(this.refs.ellipsis);

	            for (var line = 1; line <= numLines; line++) {
	                var textWords = textLines[0];

	                // Handle newline
	                if (textWords.length === 0) {
	                    lines.push();
	                    textLines.shift();
	                    line--;
	                    continue;
	                }

	                var resultLine = textWords.join(' ');

	                if (measureWidth(resultLine) <= targetWidth) {
	                    if (textLines.length === 1) {
	                        // Line is end of text and fits without truncating
	                        didTruncate = false;

	                        lines.push(resultLine);
	                        break;
	                    }
	                }

	                if (line === numLines) {
	                    // Binary search determining the longest possible line inluding truncate string
	                    var textRest = textWords.join(' ');

	                    var lower = 0;
	                    var upper = textRest.length - 1;

	                    while (lower <= upper) {
	                        var middle = Math.floor((lower + upper) / 2);

	                        var testLine = textRest.slice(0, middle + 1);

	                        if (measureWidth(testLine) + ellipsisWidth <= targetWidth) {
	                            lower = middle + 1;
	                        } else {
	                            upper = middle - 1;
	                        }
	                    }

	                    resultLine = _react2.default.createElement(
	                        'span',
	                        null,
	                        textRest.slice(0, lower),
	                        ellipsis
	                    );
	                } else {
	                    // Binary search determining when the line breaks
	                    var _lower = 0;
	                    var _upper = textWords.length - 1;

	                    while (_lower <= _upper) {
	                        var _middle = Math.floor((_lower + _upper) / 2);

	                        var _testLine = textWords.slice(0, _middle + 1).join(' ');

	                        if (measureWidth(_testLine) <= targetWidth) {
	                            _lower = _middle + 1;
	                        } else {
	                            _upper = _middle - 1;
	                        }
	                    }

	                    // The first word of this line is too long to fit it
	                    if (_lower === 0) {
	                        // Jump to processing of last line
	                        line = numLines - 1;
	                        continue;
	                    }

	                    resultLine = textWords.slice(0, _lower).join(' ');
	                    textLines[0].splice(0, _lower);
	                }

	                lines.push(resultLine);
	            }

	            onTruncate(didTruncate);

	            return lines;
	        }
	    }, {
	        key: 'renderLine',
	        value: function renderLine(line, i, arr) {
	            if (i === arr.length - 1) {
	                return _react2.default.createElement(
	                    'span',
	                    { key: i },
	                    line
	                );
	            } else {
	                var br = _react2.default.createElement('br', { key: i + 'br' });

	                if (line) {
	                    return [_react2.default.createElement(
	                        'span',
	                        { key: i },
	                        line
	                    ), br];
	                } else {
	                    return br;
	                }
	            }
	        }
	    }, {
	        key: 'render',
	        value: function render() {
	            var target = this.refs.target,
	                _props2 = this.props,
	                children = _props2.children,
	                ellipsis = _props2.ellipsis,
	                lines = _props2.lines,
	                spanProps = _objectWithoutProperties(_props2, ['children', 'ellipsis', 'lines']),
	                targetWidth = this.state.targetWidth,
	                getLines = this.getLines,
	                renderLine = this.renderLine,
	                onTruncate = this.onTruncate;

	            var text = void 0;

	            var mounted = !!(target && targetWidth);

	            if (typeof window !== 'undefined' && mounted) {
	                if (lines > 0) {
	                    text = getLines().map(renderLine);
	                } else {
	                    text = children;

	                    onTruncate(false);
	                }
	            }

	            delete spanProps.onTruncate;

	            return _react2.default.createElement(
	                'span',
	                _extends({}, spanProps, { ref: 'target' }),
	                text,
	                _react2.default.createElement(
	                    'span',
	                    { ref: 'text' },
	                    children
	                ),
	                _react2.default.createElement(
	                    'span',
	                    { ref: 'ellipsis', style: this.styles.ellipsis },
	                    ellipsis
	                )
	            );
	        }
	    }]);

	    return Truncate;
	}(_react.Component);

	Truncate.propTypes = {
	    children: _react.PropTypes.node,
	    ellipsis: _react.PropTypes.node,
	    lines: _react.PropTypes.oneOfType([_react.PropTypes.oneOf([false]), _react.PropTypes.number]),
	    onTruncate: _react.PropTypes.func
	};
	Truncate.defaultProps = {
	    children: '',
	    ellipsis: '…',
	    lines: 1
	};
	exports.default = Truncate;
	;
	module.exports = exports['default'];

/***/ },

/***/ 605:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Button = __webpack_require__(461).Button;

	module.exports = React.createClass({
	    displayName: 'exports',

	    render: function render() {
	        var klass = 'slds-col side-panel ' + (this.props.animated ? 'animated ' : '') + (this.props.invalid ? 'invalid' : '');

	        return React.createElement(
	            'div',
	            { className: klass },
	            React.createElement(
	                'div',
	                { className: 'side-panel-header slds-clearfix slds-p-around--small slds-text-heading--medium' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-float--left ' },
	                    React.createElement(
	                        'p',
	                        null,
	                        AppManager.getLabel("PC_LBL_FILTERS") || 'Filters'
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-float--right' },
	                    React.createElement(Button, { className: 'close-button', icon: 'forward', size: 'small', onClick: this.props.closeHandler })
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'side-panel-body' },
	                this.props.children
	            )
	        );
	    }
		});

/***/ },

/***/ 606:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var ButtonGroup = __webpack_require__(461).ButtonGroup;
	var Button = __webpack_require__(461).Button;
	var DropdownButton = __webpack_require__(461).DropdownButton;
	var MenuItem = __webpack_require__(461).MenuItem;
	var Icon = __webpack_require__(461).Icon;

	var PromCalendarActions = __webpack_require__(607).PromCalendarActions;
	var Popover = __webpack_require__(609);

	var NewPromotion = __webpack_require__(610);

	module.exports = React.createClass({
	    displayName: 'CalendarHeader',

	    getInitialState: function getInitialState() {
	        return { showNewPromotion: false };
	    },

	    showNewPromotion: function showNewPromotion() {
	        this.setState({ showNewPromotion: true });
	    },

	    cancelNewPromotion: function cancelNewPromotion() {
	        this.setState({ showNewPromotion: false });
	    },

	    saveNewPromotion: function saveNewPromotion(promotion) {
	        this.setState({ showNewPromotion: false });
	        this.props.addPromotion(promotion);
	    },

	    render: function render() {
	        var _this = this;

	        var filterIcon = 'Filter' + (this.props.calendar && this.props.calendar.isFilterSet ? '-set' : '') + (this.props.showFilter ? '_active' : '') + '.png';
	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-page-header' },
	            React.createElement(
	                'div',
	                { className: 'slds-col' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-media slds-media--center' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-media__figure' },
	                        React.createElement('img', { src: Utils.HTTP.getImgUrl('Icon_Calendar.png') })
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-media__body' },
	                        React.createElement(
	                            'p',
	                            { className: 'slds-text-heading--medium ' },
	                            'Trade Calendar'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-col' }),
	            React.createElement(
	                'div',
	                { className: 'slds-col header-buttons' },
	                React.createElement(
	                    Button,
	                    { type: this.props.showFilter ? 'brand' : 'neutral',
	                        onClick: function onClick() {
	                            return _this.props.toggleFilter();
	                        } },
	                    React.createElement('img', {
	                        src: Utils.HTTP.getImgUrl(filterIcon) })
	                ),
	                React.createElement(Button, { type: this.state.showNewPromotion ? 'brand' : 'neutral', ref: 'new-promotion', icon: 'add',
	                    iconAlign: 'left', iconMore: '', label: 'New ',
	                    onClick: function onClick() {
	                        return _this.showNewPromotion();
	                    }, className: 'new-button' }),
	                !this.state.showNewPromotion ? null : React.createElement(
	                    Popover,
	                    { parent: this.refs["new-promotion"], direction: 'vertical', nubbinMargin: 12,
	                        onClickOutside: this.cancelNewPromotion },
	                    React.createElement(NewPromotion, {
	                        cancelHandler: this.cancelNewPromotion, saveHandler: this.saveNewPromotion,
	                        calendar: this.props.calendar })
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 607:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	global._ = __webpack_require__(202);
	_.mixin({ keyMirror: __webpack_require__(608) });

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
	    load: function load(payload) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.CALENDAR_LOAD,
	            payload: payload
	        });
	    },

	    addPromotion: function addPromotion(promotion) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.ADD_PROMOTION,
	            payload: promotion
	        });
	    },

	    prevPeriod: function prevPeriod() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.PREVIOUS_PERIOD,
	            payload: null
	        });
	    },

	    nextPeriod: function nextPeriod() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.NEXT_PERIOD,
	            payload: null
	        });
	    },

	    changeCalendarFilter: function changeCalendarFilter(filterValue) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.CHANGE_FILTER,
	            payload: filterValue
	        });
	    },
	    cancelChangeCalendarFilter: function cancelChangeCalendarFilter() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.CANCEL_CHANGE_FILTER,
	            payload: null
	        });
	    },

	    getPromotionDetail: function getPromotionDetail(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.GET_PROMOTION_DETAIL,
	            payload: promotionId
	        });
	    },

	    openPromotionDetail: function openPromotionDetail(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.OPEN_PROMOTION_DETAIL,
	            payload: promotionId
	        });
	    },

	    derivePromotionDetail: function derivePromotionDetail(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.DERIVE_PROMOTION_DETAIL,
	            payload: promotionId
	        });
	    },

	    copyPromotionDetail: function copyPromotionDetail(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.COPY_PROMOTION_DETAIL,
	            payload: promotionId
	        });
	    },

	    deletePromotionDetail: function deletePromotionDetail(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.DELETE_PROMOTION_DETAIL,
	            payload: promotionId
	        });
	    }
	};

	module.exports.PromCalendarActions = PromCalendarActions;
	module.exports.PromCalendarActionConstants = PromCalendarActionConstants;
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 608:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(process) {/**
	 * Copyright (c) 2013-present, Facebook, Inc.
	 * All rights reserved.
	 *
	 * This source code is licensed under the BSD-style license found in the
	 * LICENSE file in the root directory of this source tree. An additional grant
	 * of patent rights can be found in the PATENTS file in the same directory.
	 *
	 * @typechecks static-only
	 */

	'use strict';

	var invariant = __webpack_require__(289);

	/**
	 * Constructs an enumeration with keys equal to their value.
	 *
	 * For example:
	 *
	 *   var COLORS = keyMirror({blue: null, red: null});
	 *   var myColor = COLORS.blue;
	 *   var isColorValid = !!COLORS[myColor];
	 *
	 * The last line could not be performed if the values of the generated enum were
	 * not equal to their keys.
	 *
	 *   Input:  {key1: val1, key2: val2}
	 *   Output: {key1: key1, key2: key2}
	 *
	 * @param {object} obj
	 * @return {object}
	 */
	var keyMirror = function keyMirror(obj) {
	  var ret = {};
	  var key;
	  !(obj instanceof Object && !Array.isArray(obj)) ? process.env.NODE_ENV !== 'production' ? invariant(false, 'keyMirror(...): Argument must be an object.') : invariant(false) : void 0;
	  for (key in obj) {
	    if (!obj.hasOwnProperty(key)) {
	      continue;
	    }
	    ret[key] = key;
	  }
	  return ret;
	};

	module.exports = keyMirror;
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(204)))

/***/ },

/***/ 609:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var classNames = __webpack_require__(566);

	module.exports = React.createClass({
	    displayName: 'Popover',

	    getInitialState: function getInitialState() {
	        return {
	            top: 0,
	            left: 0,
	            parent: {
	                top: 0,
	                left: 0,
	                width: 0,
	                height: 0
	            },
	            container: {
	                width: 0,
	                height: 0
	            }
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        if (this.props.onClickOutside) {
	            document.addEventListener("click", this.outsideClickHandler);
	        }

	        this.setPopoverPosition();
	    },

	    componentDidUpdate: function componentDidUpdate() {
	        this.setPopoverPosition();
	    },

	    setPopoverPosition: function setPopoverPosition() {
	        var parentElement = this.props.parent ? ReactDOM.findDOMNode(this.props.parent) : ReactDOM.findDOMNode(this).parentNode;
	        var parent = parentElement.getBoundingClientRect();
	        var container = this.refs.container.getBoundingClientRect();
	        var backgroundColor = this.props.backgroundColor || {};
	        var nubbinSize = this.props.nubbinMargin || 0;

	        var nubbinCornerTop = 37;
	        var nubbinCornerBottom = 40;
	        var nubbinCornerHorizontal = 33;
	        var exceedsTop = parent.top + parent.height / 2 < container.height / 2;
	        var exceedsBottom = parent.top + parent.height / 2 + container.height / 2 > window.innerHeight;
	        var exceedsLeft = parent.left + parent.width / 2 < container.width / 2;
	        var exceedsRight = parent.left + parent.width / 2 + container.width / 2 > window.innerWidth;

	        if (this.shouldPopoverUpdate(parent, container)) {
	            var position = null;
	            if (this.props.direction === 'horizontal') {
	                // if popover exceeds bottom side of the screen, change position to top
	                if (exceedsBottom) {
	                    if (exceedsLeft) {
	                        position = "right-top";
	                    } else if (exceedsRight) {
	                        position = "left-top";
	                    } else {
	                        position = "top";
	                    }
	                }
	                // if popover exceeds top side of the screen, change position to bottom
	                else if (exceedsTop) {
	                        if (exceedsLeft) {
	                            position = "right-bottom";
	                        } else if (exceedsRight) {
	                            position = "left-bottom";
	                        } else {
	                            position = "bottom";
	                        }
	                    } else if (parent.left > window.innerWidth / 2) {
	                        position = "left";
	                    } else {
	                        position = "right";
	                    }
	            } else if (this.props.direction === 'vertical') {
	                // if popover exceeds right side of the screen, change position to left
	                if (exceedsRight) {
	                    if (exceedsTop) {
	                        position = "bottom-left";
	                    } else if (exceedsBottom) {
	                        position = "top-left";
	                    } else {
	                        position = "left";
	                    }
	                }
	                // if popover exceeds left side of the screen, change position to left
	                else if (exceedsLeft) {
	                        if (exceedsTop) {
	                            position = "bottom-right";
	                        } else if (exceedsBottom) {
	                            position = "top-right";
	                        } else {
	                            position = "right";
	                        }
	                    } else if (parent.top > window.innerHeight / 2) {
	                        position = "top";
	                    } else {
	                        position = "bottom";
	                    }
	            }

	            switch (position) {
	                case "top":
	                    this.setState({
	                        position: "top",
	                        top: parent.top - (container.height + nubbinSize),
	                        left: parent.left + parent.width / 2 - container.width / 2,
	                        color: backgroundColor.top
	                    });
	                    break;
	                case "top-left":
	                    this.setState({
	                        position: "top-left",
	                        top: parent.top - (container.height + nubbinSize),
	                        left: parent.left + parent.width / 2 + nubbinCornerHorizontal - container.width,
	                        color: backgroundColor.top
	                    });
	                    break;
	                case "top-right":
	                    this.setState({
	                        position: "top-right",
	                        top: parent.top - (container.height + nubbinSize),
	                        left: parent.left + parent.width / 2 - nubbinCornerHorizontal,
	                        color: backgroundColor.top
	                    });
	                    break;
	                case "bottom":
	                    this.setState({
	                        position: "bottom",
	                        top: parent.top + parent.height + nubbinSize,
	                        left: parent.left + parent.width / 2 - container.width / 2,
	                        color: backgroundColor.bottom
	                    });
	                    break;
	                case "bottom-left":
	                    this.setState({
	                        position: "bottom-left",
	                        top: parent.top + parent.height + nubbinSize,
	                        left: parent.left + parent.width / 2 + nubbinCornerHorizontal - container.width,
	                        color: backgroundColor.bottom
	                    });
	                    break;
	                case "bottom-right":
	                    this.setState({
	                        position: "bottom-right",
	                        top: parent.top + parent.height + nubbinSize,
	                        left: parent.left + parent.width / 2 - nubbinCornerHorizontal,
	                        color: backgroundColor.bottom
	                    });
	                    break;
	                case "left":
	                    this.setState({
	                        position: "left",
	                        top: parent.top + parent.height / 2 - container.height / 2,
	                        left: parent.left - (container.width + nubbinSize),
	                        color: backgroundColor.left
	                    });
	                    break;
	                case "left-bottom":
	                    this.setState({
	                        position: "left-bottom",
	                        top: parent.top + parent.height / 2 - nubbinCornerTop,
	                        left: parent.left - (container.width + nubbinSize),
	                        color: backgroundColor.left
	                    });
	                    break;
	                case "left-top":
	                    this.setState({
	                        position: "left-top",
	                        top: parent.top + parent.height / 2 + nubbinCornerBottom - container.height,
	                        left: parent.left - (container.width + nubbinSize),
	                        color: backgroundColor.left
	                    });
	                    break;
	                case "right":
	                    this.setState({
	                        position: "right",
	                        top: parent.top + parent.height / 2 - container.height / 2,
	                        left: parent.left + parent.width + nubbinSize,
	                        color: backgroundColor.right
	                    });
	                    break;
	                case "right-bottom":
	                    this.setState({
	                        position: "right-bottom",
	                        top: parent.top + parent.height / 2 - nubbinCornerTop,
	                        left: parent.left + parent.width + nubbinSize,
	                        color: backgroundColor.right
	                    });
	                    break;
	                case "right-top":
	                    this.setState({
	                        position: "right-top",
	                        top: parent.top + parent.height / 2 + nubbinCornerBottom - container.height,
	                        left: parent.left + parent.width + nubbinSize,
	                        color: backgroundColor.right
	                    });
	                    break;
	            }
	        }
	    },

	    shouldPopoverUpdate: function shouldPopoverUpdate(nextParent, nextContainer) {
	        var parent = this.state.parent;
	        var container = this.state.container;
	        var update = false;

	        if (parent.top !== nextParent.top || parent.left !== nextParent.left || parent.height !== nextParent.height || parent.width !== nextParent.width) {
	            this.setState({
	                parent: {
	                    top: nextParent.top,
	                    left: nextParent.left,
	                    width: nextParent.width,
	                    height: nextParent.height
	                }
	            });
	            update = true;
	        }

	        if (container.height !== nextContainer.height || container.width !== nextContainer.width) {
	            this.setState({
	                container: {
	                    width: nextContainer.width,
	                    height: nextContainer.height
	                }
	            });
	            update = true;
	        }

	        return update;
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        if (this.props.onClickOutside) {
	            document.removeEventListener("click", this.outsideClickHandler);
	        }
	    },

	    outsideClickHandler: function outsideClickHandler(event) {
	        var container = ReactDOM.findDOMNode(this.refs.container);

	        if (!container.contains(event.target)) {
	            this.props.onClickOutside();
	        }
	    },

	    render: function render() {
	        var stylePopover = {
	            position: 'fixed',
	            top: this.state.top,
	            left: this.state.left,
	            background: this.state.color
	        };

	        var style = _.assign(stylePopover, this.props.style);

	        var popoverClass = classNames({
	            'slds-popover': true,
	            'slds-popover--panel': true,
	            'slds-nubbin--top': this.state.position === 'bottom',
	            'slds-nubbin--top-right': this.state.position === 'bottom-left',
	            'slds-nubbin--top-left': this.state.position === 'bottom-right',
	            'slds-nubbin--right': this.state.position === 'left',
	            'slds-nubbin--right-top': this.state.position === 'left-bottom',
	            'slds-nubbin--right-bottom': this.state.position === 'left-top',
	            'slds-nubbin--bottom': this.state.position === 'top',
	            'slds-nubbin--bottom-right': this.state.position === 'top-left',
	            'slds-nubbin--bottom-left': this.state.position === 'top-right',
	            'slds-nubbin--left': this.state.position === 'right',
	            'slds-nubbin--left-top': this.state.position === 'right-bottom',
	            'slds-nubbin--left-bottom': this.state.position === 'right-top'
	        }, this.props.className);

	        return React.createElement(
	            'div',
	            { className: popoverClass, role: 'dialog', ref: 'container', style: style },
	            this.props.children
	        );
	    }
		});

/***/ },

/***/ 610:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var Input = __webpack_require__(461).Input;
	var DateInput = __webpack_require__(461).DateInput;
	var Picklist = __webpack_require__(461).Picklist;
	var PicklistItem = __webpack_require__(461).PicklistItem;
	var Row = __webpack_require__(461).Row;
	var Form = __webpack_require__(611);

	module.exports = React.createClass({
	    displayName: 'NewPromotion',

	    getInitialState: function getInitialState() {
	        var initialPromotionTemplate = null;
	        if (this.props.calendar.active_promotion_templates.length > 0) {
	            initialPromotionTemplate = this.props.calendar.active_promotion_templates[0];
	        }

	        var initialAccount = null;
	        if (this.props.calendar.accounts.length > 0) {
	            initialAccount = this.props.calendar.accounts[0].Id;
	        }

	        var initialAccountSet = null;
	        if (this.props.calendar.accountSet.length > 0) {
	            initialAccountSet = this.props.calendar.accountSet[0].Id;
	        }

	        return {
	            promotion: {
	                Slogan__c: '',
	                Date_From__c: new Date(),
	                account: initialAccount,
	                accountSet: initialAccountSet,
	                promotion_template: initialPromotionTemplate,
	                period: 'week',
	                duration: 1
	            },

	            periods: [{ value: 'day', label: AppManager.getLabel('PC_LBL_DAYS') || 'Days' }, { value: 'week', label: AppManager.getLabel('PC_LBL_WEEKS') || 'Weeks' }, { value: 'month', label: AppManager.getLabel('PC_LBL_MONTHS') || 'Months' }]
	        };
	    },

	    onFieldChange: function onFieldChange(field, newValue) {
	        var modifiedPromotion = this.state.promotion;
	        modifiedPromotion[field] = newValue;
	        this.setState({ promotion: modifiedPromotion });
	    },

	    onSave: function onSave() {
	        this.props.saveHandler(this.state.promotion);
	    },

	    onCancel: function onCancel() {
	        this.props.cancelHandler();
	    },

	    render: function render() {
	        var _this = this;

	        var accountDropdown = null;
	        var promotion_template = this.state.promotion.promotion_template;

	        if (promotion_template !== null) {
	            if (promotion_template.Anchor_Type === 'Customer') {
	                accountDropdown = React.createElement(
	                    'div',
	                    null,
	                    React.createElement(
	                        'div',
	                        { className: 'new-promotion-label' },
	                        React.createElement(
	                            'span',
	                            { className: 'required' },
	                            '*'
	                        ),
	                        React.createElement(
	                            'span',
	                            null,
	                            ' ' + AppManager.getLabel('PC_LBL_ANCHOR_CUSTOMER') || 'Anchor Customer'
	                        )
	                    ),
	                    React.createElement(
	                        Picklist,
	                        { value: this.state.promotion.account,
	                            onValueChange: function onValueChange(value) {
	                                return _this.onFieldChange('account', value);
	                            } },
	                        this.props.calendar.accounts.map(function (a, i) {
	                            return React.createElement(PicklistItem, { key: i + 1, value: a.Id, label: a.Label });
	                        })
	                    )
	                );
	            } else if (promotion_template.Anchor_Type === 'CustomerSet') {
	                accountDropdown = React.createElement(
	                    'div',
	                    null,
	                    React.createElement(
	                        'div',
	                        { className: 'new-promotion-label' },
	                        React.createElement(
	                            'span',
	                            { className: 'required' },
	                            '*'
	                        ),
	                        React.createElement(
	                            'span',
	                            null,
	                            ' ' + AppManager.getLabel('PC_LBL_ANCHOR_CUSTOMER_SET') || 'Anchor Customer Set'
	                        )
	                    ),
	                    React.createElement(
	                        Picklist,
	                        { value: this.state.promotion.accountSet,
	                            onValueChange: function onValueChange(value) {
	                                return _this.onFieldChange('accountSet', value);
	                            } },
	                        this.props.calendar.accountSet.map(function (a, i) {
	                            return React.createElement(PicklistItem, { key: i + 1, value: a.Id, label: a.Label });
	                        })
	                    )
	                );
	            }
	        }

	        var fields = [{
	            component: React.createElement(
	                'div',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'new-promotion-label' },
	                    React.createElement(
	                        'span',
	                        { className: 'required' },
	                        '*'
	                    ),
	                    React.createElement(
	                        'span',
	                        null,
	                        ' ' + AppManager.getLabel('PC_LBL_SLOGAN') || 'Slogan'
	                    )
	                ),
	                React.createElement(Input, { type: 'text',
	                    className: 'slds-m-bottom--medium',
	                    onChange: function onChange(e, value) {
	                        return _this.onFieldChange('Slogan__c', value);
	                    },
	                    onClick: function onClick(e) {
	                        return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                    },
	                    value: this.state.promotion.Slogan__c })
	            ),
	            required: true,
	            value: this.state.promotion.Slogan__c
	        }, {
	            component: React.createElement(
	                'div',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'new-promotion-label' },
	                    React.createElement(
	                        'span',
	                        { className: 'required' },
	                        '*'
	                    ),
	                    React.createElement(
	                        'span',
	                        null,
	                        ' ' + AppManager.getLabel('PC_LBL_START') || 'Start'
	                    )
	                ),
	                React.createElement(DateInput, { placeholder: AppSettings.get('dateFormat'),
	                    onValueChange: function onValueChange(value) {
	                        return _this.onFieldChange('Date_From__c', value);
	                    },
	                    dateFormat: AppSettings.get('dateFormat'),
	                    onClick: function onClick(e) {
	                        return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                    },
	                    value: Utils.Converters.TS2Date(this.state.promotion.Date_From__c, 'YYYY-MM-DD') })
	            ),
	            required: true,
	            isValid: function isValid(val) {
	                return val != '' && val.toString() != 'Invalid date';
	            },
	            value: Utils.Converters.TS2Date(this.state.promotion.Date_From__c, 'YYYY-MM-DD')
	        }, {
	            component: React.createElement(
	                'div',
	                { className: 'slds-form-element slds-m-top--medium slds-m-bottom--medium' },
	                React.createElement(
	                    'label',
	                    { className: 'slds-form-element__label' },
	                    React.createElement(
	                        'span',
	                        { className: 'required' },
	                        '*'
	                    ),
	                    React.createElement(
	                        'span',
	                        null,
	                        ' ' + AppManager.getLabel('PP_LBL_DURATION') || 'Duration'
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-m-right--medium' },
	                        React.createElement(Input, { className: 'new-promotion-duration-input',
	                            type: 'text',
	                            onChange: function onChange(e, value) {
	                                return _this.onFieldChange('duration', value);
	                            },
	                            onClick: function onClick(e) {
	                                return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                            },
	                            value: this.state.promotion.duration,
	                            maxLength: 3 })
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col' },
	                        React.createElement(
	                            Picklist,
	                            { value: this.state.promotion.period,
	                                onValueChange: function onValueChange(value) {
	                                    return _this.onFieldChange('period', value);
	                                } },
	                            this.state.periods.map(function (a, i) {
	                                return React.createElement(PicklistItem, { key: i + 1, value: a.value, label: a.label });
	                            })
	                        )
	                    )
	                )
	            ),
	            required: true,
	            isValid: function isValid(val) {
	                return !isNaN(val) && parseInt(val) > 0;
	            },
	            value: this.state.promotion.duration
	        }, {
	            component: React.createElement(
	                'div',
	                { className: 'slds-m-bottom--medium' },
	                React.createElement(
	                    'div',
	                    { className: 'new-promotion-label' },
	                    React.createElement(
	                        'span',
	                        { className: 'required' },
	                        '*'
	                    ),
	                    React.createElement(
	                        'span',
	                        null,
	                        ' ' + AppManager.getLabel('PC_LBL_PROMOTION_TEMPLATE') || 'Promotion Template'
	                    )
	                ),
	                React.createElement(
	                    Picklist,
	                    { value: this.state.promotion.promotion_template,
	                        onValueChange: function onValueChange(value) {
	                            return _this.onFieldChange('promotion_template', value);
	                        } },
	                    this.props.calendar.active_promotion_templates.map(function (a, i) {
	                        return React.createElement(PicklistItem, { key: i + 1, value: a, label: a.Label });
	                    })
	                )
	            ),
	            required: true,
	            value: 'value'
	        }, {
	            component: accountDropdown,
	            required: true,
	            value: 'value'
	        }];

	        return React.createElement(
	            'div',
	            { className: 'slds-popover__body new-promotion' },
	            React.createElement(Form, { 'class': ' slds-p-around--large', fields: fields, onSave: this.onSave, onCancel: this.onCancel })
	        );
	    }
		});

/***/ },

/***/ 611:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var React = __webpack_require__(283);

	var Button = __webpack_require__(461).Button;

	module.exports = React.createClass({
	    displayName: 'Form',

	    isButtonDisabled: function isButtonDisabled() {
	        var buttonDisabled = false;
	        var valueString;

	        this.props.fields.map(function (field) {
	            valueString = field.value.toString().trim();
	            if (field.isValid && !field.isValid(field.value)) buttonDisabled = true;
	            if (field.required && valueString == '') {
	                buttonDisabled = true;
	            }
	        });

	        return buttonDisabled;
	    },
	    render: function render() {
	        var _this = this;

	        return React.createElement(
	            'div',
	            { className: this.props.class },
	            React.createElement(
	                'ul',
	                null,
	                this.props.fields.map(function (item) {
	                    return React.createElement(
	                        'li',
	                        null,
	                        item.component
	                    );
	                })
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-text-align--right slds-p-top--large icon-button-group' },
	                React.createElement(
	                    Button,
	                    { type: 'neutral', icon: 'close', iconAlign: 'left', className: 'icon-button',
	                        onClick: function onClick() {
	                            return _this.props.onCancel();
	                        } },
	                    ' ',
	                    AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'
	                ),
	                React.createElement(
	                    Button,
	                    { type: 'brand', icon: 'check', iconAlign: 'left', className: 'icon-button',
	                        onClick: function onClick() {
	                            return _this.props.onSave();
	                        }, disabled: this.isButtonDisabled() },
	                    ' ',
	                    AppManager.getLabel('PC_BTN_SAVE') || 'Save'
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 612:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var React = __webpack_require__(283);
	var PromotionDetail = __webpack_require__(613);
	var classNames = __webpack_require__(566);
	var Button = __webpack_require__(461).Button;

	var PromCalendarActions = __webpack_require__(607).PromCalendarActions;

	var Popover = __webpack_require__(609);
	var Truncate = __webpack_require__(603);

	var PromotionCalendarLabel = React.createClass({
	    displayName: 'PromotionCalendarLabel',

	    getInitialState: function getInitialState() {
	        return {
	            isTruncated: false,
	            hover: false
	        };
	    },

	    render: function render() {
	        var _this = this;

	        return React.createElement(
	            'statelessWrapper',
	            null,
	            React.createElement(
	                'div',
	                { className: 'label-column slds-text-heading--small',
	                    onMouseEnter: function onMouseEnter(e) {
	                        return _this.setState({ hover: true });
	                    },
	                    onMouseLeave: function onMouseLeave(e) {
	                        return _this.setState({ hover: false });
	                    } },
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate slogan-text' },
	                    React.createElement(Truncate, { lines: 2,
	                        onTruncate: function onTruncate(isTruncated) {
	                            isTruncated !== _this.state.isTruncated && _this.setState({ isTruncated: isTruncated });
	                        },
	                        children: this.props.slogan })
	                )
	            ),
	            this.state.hover && this.state.isTruncated ? React.createElement(
	                Popover,
	                { direction: 'horizontal', className: 'slogan-tooltip' },
	                this.props.slogan
	            ) : null
	        );
	    }

	});

	module.exports = React.createClass({
	    displayName: 'PromotionCalendarGrid',

	    getInitialState: function getInitialState() {
	        return {
	            promotionDetailPopOver: null,
	            showWeeks: true,
	            initialLegendContent: null
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        //this.handleResize();
	        window.addEventListener('resize', this.handleResize);
	        this.handleLegendScroll();
	    },

	    componentDidUpdate: function componentDidUpdate() {
	        var me = this;
	        var weeks = _.flatMap(_.uniqBy(this.props.calendar.periods, 'Child'));
	        var weekWidth = this.refs.months.getBoundingClientRect().width / weeks.length;
	        if (this.state.showWeeks && weekWidth < 18) {
	            this.setState({
	                showWeeks: false
	            });
	        } else if (!this.state.showWeeks && weekWidth > 18) {
	            this.setState({
	                showWeeks: true
	            });
	        }
	        for (var i = 0; i < this.refs.months.children.length; i++) {
	            var monthDOM = this.refs.months.children[i];
	            if (monthDOM.innerText.length && monthDOM.scrollWidth > monthDOM.clientWidth) {
	                //OVERFLOW!
	                //Solution 1: clip text
	                monthDOM.innerText = monthDOM.innerText.substring(0, Math.floor(monthDOM.clientWidth / 18));
	                //Solution 2: apply css class
	                //if (monthDOM.className.indexOf('overflowMonth')==-1)
	                //    monthDOM.className+=' overflowMonth';
	            }
	        }
	        this.handleLegendScroll();
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        window.removeEventListener('resize', this.handleResize);
	    },

	    handleResize: function handleResize() {
	        this.forceUpdate();
	    },

	    onPreviousPeriod: function onPreviousPeriod() {
	        PromCalendarActions.prevPeriod();
	    },

	    onNextPeriod: function onNextPeriod() {
	        PromCalendarActions.nextPeriod();
	    },

	    renderPastTime: function renderPastTime() {
	        var today = new Date();
	        var width = this.getLeft(today - this.props.calendar.initDate);
	        if (width < 0) return null;
	        if (width > this.getTotalWidth()) width = this.getTotalWidth();
	        var height = this.getCalendarHeight();
	        return React.createElement('div', { className: 'past-time', style: { width: width + 'px', height: '100%' } });
	    },

	    renderYearLine: function renderYearLine() {
	        if (this.props.calendar.endDate.getFullYear() != this.props.calendar.initDate.getFullYear()) {
	            var l = this.getLeft(new Date(this.props.calendar.endDate.getFullYear(), 0, 0) - this.props.calendar.initDate);
	            l += 154; // Width of the first column
	            var height = this.getCalendarHeight();
	            return React.createElement('div', { className: 'past-time year-line',
	                style: { left: l + 'px', width: '2px', height: '100%' } });
	        }
	    },

	    getWeeks: function getWeeks() {
	        var today = new Date().getTime();
	        return _.flatMap(_.uniqBy(this.props.calendar.periods, 'Child'), function (i) {
	            var padded = '0' + i.Child;
	            return {
	                Week: padded.substring(padded.length - 2),
	                Month: i.Parent,
	                Current: i.Date_From < today && today < i.Date_Thru
	            };
	        });
	    },

	    renderHeader: function renderHeader() {
	        var weeks = this.getWeeks();
	        var colHeight = this.getCalendarHeight();
	        var lastMonth = '';
	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-grid--vertical-stretch calendarGrid-columns' },
	            React.createElement('div', { className: 'label-column ', ref: 'colName' }),
	            weeks.map(function (w, i) {
	                var colClass = classNames({
	                    'slds-col': true,
	                    'col-odd': i % 2 == 0,
	                    'col-even': i % 2 != 0,
	                    'month-week': i > 0 && lastMonth != w.Month
	                });
	                lastMonth = w.Month;
	                return React.createElement('div', { className: colClass, style: { height: '100%' } });
	            })
	        );
	    },

	    renderMonths: function renderMonths() {
	        var _this2 = this;

	        var weeks = this.getWeeks();
	        var lastMonth = '';

	        return React.createElement(
	            'div',
	            { className: 'slds-grid calendarGrid-months' },
	            React.createElement('div', { className: 'label-column' }),
	            React.createElement(
	                'div',
	                { className: 'calendar-months', ref: 'months' },
	                React.createElement(
	                    'div',
	                    { className: 'prev-period' },
	                    React.createElement(Button, { icon: 'chevronleft', onClick: function onClick() {
	                            return _this2.onPreviousPeriod();
	                        } })
	                ),
	                weeks.map(function (w) {
	                    var m = window.innerWidth < 1280 ? w.Month.substring(0, 3) : w.Month;
	                    var colSpan = 1;
	                    var current = '';
	                    var currentWeek = _.find(weeks, { Current: true });
	                    var currentMonth = currentWeek ? currentWeek.Month : '';
	                    if (m != lastMonth) {
	                        lastMonth = m;
	                        colSpan = _.filter(weeks, { Month: w.Month }).length;
	                        current = currentMonth == w.Month ? 'month-current' : '';
	                    } else {
	                        return null;
	                    }
	                    return React.createElement(
	                        'div',
	                        { style: { flex: colSpan },
	                            className: "slds-text-align--center " + current },
	                        m
	                    );
	                }),
	                React.createElement(
	                    'div',
	                    { className: 'next-period' },
	                    React.createElement(Button, { icon: 'chevronright', onClick: function onClick() {
	                            return _this2.onNextPeriod();
	                        } })
	                )
	            )
	        );
	    },

	    renderWeeks: function renderWeeks() {
	        var weeks = this.getWeeks();

	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-grid--vertical-stretch calendar-weeks' },
	            React.createElement('div', { className: 'label-column' }),
	            weeks.map(function (w, i) {
	                return React.createElement(
	                    'div',
	                    { className: 'slds-col slds-text-align--center' },
	                    w.Week
	                );
	            })
	        );
	    },

	    toPreviousLegend: function toPreviousLegend() {
	        var legendContent = this.refs.calendarlegendcontent,
	            firstChild = legendContent.firstChild.cloneNode(true);
	        if (!this.state.initialLegendContent) {
	            this.state.initialLegendContent = legendContent.innerHTML;
	        }
	        legendContent.removeChild(legendContent.firstChild);
	        legendContent.appendChild(firstChild);
	    },

	    toNextLegend: function toNextLegend() {
	        var legendContent = this.refs.calendarlegendcontent,
	            lastChild = legendContent.lastChild.cloneNode(true);
	        if (!this.state.initialLegendContent) {
	            this.state.initialLegendContent = legendContent.innerHTML;
	        }
	        legendContent.removeChild(legendContent.lastChild);
	        legendContent.insertBefore(lastChild, legendContent.firstChild);
	    },

	    handleLegendScroll: function handleLegendScroll() {
	        if (this.refs.calendarlegendcontent) {
	            var legend = this.refs.calendarlegend,
	                scrollLeft = legend.querySelector('.scroll-left'),
	                scrollRight = legend.querySelector('.scroll-right'),
	                legendContent = this.refs.calendarlegendcontent,
	                legendContentWidth = legendContent.clientWidth,
	                legendsWidth = 0,
	                nodes = legendContent.querySelectorAll('.calendar-legend-text');
	            for (var i = 0; nodes[i]; i++) {
	                legendsWidth += nodes[i].clientWidth + 16;
	            }
	            if (legendContentWidth <= legendsWidth) {
	                scrollLeft.style.display = 'flex';
	                scrollRight.style.display = 'flex';
	            } else if (scrollLeft.style.display != 'none' && scrollRight.style.display != 'none') {
	                scrollLeft.style.display = 'none';
	                scrollRight.style.display = 'none';
	                if (this.state.initialLegendContent) this.restoreLegend();
	            }
	        }
	    },

	    restoreLegend: function restoreLegend() {
	        this.refs.calendarlegendcontent.innerHTML = this.state.initialLegendContent;
	    },

	    renderLegend: function renderLegend() {
	        var _this3 = this;

	        return React.createElement(
	            'div',
	            { className: 'slds-grid calendar-legend', ref: 'calendarlegend' },
	            React.createElement('div', { className: 'label-column' }),
	            React.createElement(
	                'div',
	                { className: 'scroll-left' },
	                React.createElement(Button, { icon: 'chevronleft', onClick: function onClick() {
	                        return _this3.toPreviousLegend();
	                    } })
	            ),
	            React.createElement(
	                'div',
	                { className: 'calendar-legend-content', ref: 'calendarlegendcontent' },
	                this.props.calendar.legend.map(function (l, i) {
	                    return React.createElement(
	                        'div',
	                        { className: 'calendar-legend-text' },
	                        React.createElement('div', { className: 'calendar-legend-circle',
	                            style: { backgroundColor: l.Commit_Color.replace('0x', '#') } }),
	                        l.Name
	                    );
	                })
	            ),
	            React.createElement(
	                'div',
	                { className: 'scroll-right' },
	                React.createElement(Button, { icon: 'chevronright', onClick: function onClick() {
	                        return _this3.toNextLegend();
	                    } })
	            )
	        );
	    },

	    getBgColor: function getBgColor(promotion) {
	        return promotion.Commit_Color.replace('0x', '#');
	    },

	    getOpacity: function getOpacity(promotion) {
	        return promotion.isReady ? 1 : 0.3;
	    },

	    getLeft: function getLeft(date) {
	        var DAY = 1000 * 60 * 60 * 24;
	        var days = date / DAY;
	        var totalWidth = this.getTotalWidth();

	        var totalDays = Math.floor((this.props.calendar.endDate - this.props.calendar.initDate) / DAY);

	        return Math.round(days * totalWidth / totalDays);
	    },

	    getTotalWidth: function getTotalWidth() {
	        var calendarGrid = this.refs.calendarscrollarea;
	        if (this.refs['colName']) {
	            var firstCol = this.refs.colName;
	            return calendarGrid.clientWidth - firstCol.clientWidth;
	        } else {
	            calendarGrid = this.refs.calendarcontainer;
	            return calendarGrid.clientWidth - 164;
	        }
	    },

	    getCalendarHeight: function getCalendarHeight() {
	        var weekHeaderHeight = 22;
	        var calendarRowHeight = 40;
	        return weekHeaderHeight + this.props.calendar.promotions.length * calendarRowHeight;
	    },

	    getPromotionTemplate: function getPromotionTemplate(promotionTemplateId) {
	        var promotionTemplate = _.filter(this.props.calendar.promotion_templates, function (promotionTemplate) {
	            return promotionTemplate.Id == promotionTemplateId;
	        });
	        return promotionTemplate[0].Label;
	    },

	    renderPromotion: function renderPromotion(promotion) {
	        var _this4 = this;

	        var me = this,
	            bgColor = this.getBgColor(promotion),
	            previousWidth = 0;

	        var promotion_template = this.getPromotionTemplate(promotion.Promotion_Template_Id);

	        return React.createElement(
	            'div',
	            { className: 'slds-grid promotion-row' },
	            React.createElement(PromotionCalendarLabel, { slogan: promotion.slogan }),
	            promotion.dates.map(function (period, i) {
	                var width = me.getLeft(period.to - period.from),
	                    left = me.getLeft(period.from - me.props.calendar.initDate);
	                if (i > 0) {
	                    previousWidth += width;
	                    left -= previousWidth;
	                }
	                if (left < 0) {
	                    width += left;
	                    left = 0;
	                }
	                if (width < 0) {
	                    return null;
	                }
	                if (width > _this4.getTotalWidth() - left) {
	                    width = _this4.getTotalWidth() - left;
	                }

	                var opacity = _this4.getOpacity(period);

	                var showDetail = _this4.state.promotionDetailPopOver != null && _this4.state.promotionDetailPopOver.promotion.slogan == promotion.slogan && _this4.state.promotionDetailPopOver.period.from == period.from;
	                var detailPanel = null;
	                var border = 'none';
	                if (showDetail) {
	                    detailPanel = React.createElement(PromotionDetail, _extends({ promotionDetail: _this4.state.promotionDetailPopOver,
	                        icon: 'promo.png' }, _this4.props));
	                    opacity = 1;
	                    border = '2px solid rgba(0,0,0,0.3)';
	                }

	                return React.createElement(
	                    'div',
	                    { className: 'promotion-bar',
	                        style: {
	                            backgroundColor: bgColor,
	                            opacity: opacity,
	                            width: width + 'px',
	                            left: left + 'px',
	                            border: border
	                        },
	                        onMouseEnter: function onMouseEnter(e) {
	                            return _this4.showPromotionDetail(e, promotion, period, promotion_template);
	                        },
	                        onMouseLeave: function onMouseLeave(e) {
	                            return _this4.hidePromotionDetail(e, promotion, period);
	                        },
	                        onClick: function onClick(e) {
	                            if (e.target.className == 'promotion-bar') PromCalendarActions.openPromotionDetail(period.Id);
	                        } },
	                    detailPanel
	                );
	            })
	        );
	    },

	    showPromotionDetail: function showPromotionDetail(event, promotion, period, promotion_template) {
	        var self = this;
	        var calendarGrid = this.refs.calendarcontainer;
	        var promotionDetailPopOver = {
	            promotion: promotion,
	            period: period,
	            promotion_template: promotion_template
	        };
	        this.timer = window.setTimeout(function () {
	            self.setState({ promotionDetailPopOver: promotionDetailPopOver });
	        }, 300);
	        window.clearTimeout(this.timerHide);
	    },

	    hidePromotionDetail: function hidePromotionDetail(event, promotion, period) {
	        var self = this;
	        window.clearTimeout(this.timer);
	        this.timerHide = window.setTimeout(function () {
	            self.setState({ promotionDetailPopOver: null });
	        }, 300);
	    },

	    render: function render() {
	        var me = this;
	        return React.createElement(
	            'div',
	            { className: 'calendarGrid', ref: 'calendarcontainer' },
	            this.props.calendar == null ? React.createElement(
	                'div',
	                { className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center loading-container' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-spinner_container' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-spinner--brand slds-spinner slds-spinner--large', 'aria-hidden': 'false',
	                            role: 'alert' },
	                        React.createElement('div', { className: 'slds-spinner__dot-a' }),
	                        React.createElement('div', { className: 'slds-spinner__dot-b' })
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'loading-content' },
	                    '\'Loading content...\''
	                )
	            ) : React.createElement(
	                'div',
	                null,
	                this.renderMonths(),
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid calendarGrid-container' },
	                    this.renderHeader(),
	                    this.renderPastTime(),
	                    React.createElement(
	                        'div',
	                        { className: 'calendarGrid-content' },
	                        this.state.showWeeks ? this.renderWeeks() : null,
	                        React.createElement(
	                            'div',
	                            { className: 'slds-scrollable--y', ref: 'calendarscrollarea' },
	                            this.props.calendar.promotions.map(function (p) {
	                                return me.renderPromotion(p);
	                            })
	                        )
	                    ),
	                    this.renderYearLine()
	                ),
	                this.renderLegend()
	            )
	        );
	    }
		});

/***/ },

/***/ 613:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var Button = __webpack_require__(461).Button;
	var Icon = __webpack_require__(461).Icon;

	var PromCalendarActions = __webpack_require__(607).PromCalendarActions;

	var Popover = __webpack_require__(609);
	var ConfirmPopup = __webpack_require__(614);
	var Truncate = __webpack_require__(603);

	module.exports = React.createClass({
	  displayName: 'PromotionDetail',

	  getInitialState: function getInitialState() {
	    return {
	      hover: false,
	      isTruncated: false,
	      confirmMessage: null
	    };
	  },

	  componentDidMount: function componentDidMount() {
	    console.log(this.props.promotionDetail);
	    PromCalendarActions.getPromotionDetail(this.props.promotionDetail.period.Id);
	  },

	  deletePromotion: function deletePromotion(promotion) {
	    var me = this;
	    var confirmMessage = {
	      title: 'Confirmation',
	      message: 'Do you want to delete the promotion?',
	      cancelHandler: function cancelHandler() {
	        me.setState({ confirmMessage: null });
	      },
	      okHandler: function okHandler() {
	        PromCalendarActions.deletePromotionDetail(promotion.period.Id);
	        me.setState({ confirmMessage: null });
	      }
	    };

	    this.setState({ confirmMessage: confirmMessage });
	  },
	  render: function render() {
	    var _this = this;

	    var icon = null;

	    if (this.props.icon && this.props.icon.indexOf('.') == -1) {
	      icon = React.createElement(Icon, { category: 'standard', icon: this.props.icon, size: 'large' });
	    } else {
	      icon = React.createElement(
	        'span',
	        { className: 'slds-avatar' },
	        React.createElement('img', { src: Utils.HTTP.getImgUrl(this.props.icon), alt: 'promo' })
	      );
	    }

	    return React.createElement(
	      Popover,
	      { direction: 'vertical', nubbinMargin: 5, className: 'promotion-detail' },
	      this.state.confirmMessage ? React.createElement(ConfirmPopup, { title: this.state.confirmMessage.title, message: this.state.confirmMessage.message,
	        cancelHandler: this.state.confirmMessage.cancelHandler,
	        okHandler: this.state.confirmMessage.okHandler }) : null,
	      React.createElement(
	        'div',
	        { className: 'slds-popover__body promotion-detail' },
	        React.createElement(
	          'dl',
	          { className: 'slds-popover__body-list' },
	          React.createElement(
	            'dt',
	            { className: 'slds-m-bottom--medium' },
	            React.createElement(
	              'div',
	              { className: 'slds-media slds-media--center' },
	              React.createElement(
	                'div',
	                { className: 'slds-media__figure' },
	                icon
	              ),
	              React.createElement(
	                'div',
	                { className: 'slds-media__body' },
	                React.createElement(
	                  'div',
	                  { className: 'slds-text-body--small slds-text--caps' },
	                  this.props.promotionDetail.promotion_template
	                ),
	                React.createElement(
	                  'a',
	                  { onClick: function onClick() {
	                      return PromCalendarActions.openPromotionDetail(_this.props.promotionDetail.period.Id);
	                    },
	                    onMouseEnter: function onMouseEnter(e) {
	                      return _this.setState({ hover: true });
	                    },
	                    onMouseLeave: function onMouseLeave(e) {
	                      return _this.setState({ hover: false });
	                    },
	                    className: 'slds-text-heading--medium' },
	                  React.createElement(
	                    'div',
	                    { className: 'slds-truncate slogan-text' },
	                    React.createElement(Truncate, { lines: 2,
	                      onTruncate: function onTruncate(isTruncated) {
	                        isTruncated !== _this.state.isTruncated && _this.setState({ isTruncated: isTruncated });
	                      },
	                      children: this.props.promotionDetail.promotion.slogan })
	                  )
	                ),
	                this.state.hover && this.state.isTruncated ? React.createElement(
	                  Popover,
	                  { direction: 'horizontal', nubbinMargin: 10, className: 'slogan-tooltip' },
	                  this.props.promotionDetail.promotion.slogan
	                ) : null
	              )
	            )
	          ),
	          React.createElement(
	            'dt',
	            { className: 'slds-m-bottom--small' },
	            React.createElement(
	              'label',
	              { className: 'slds-text-body--small' },
	              AppManager.getLabel('PC_LBL_FROM_THRU') || 'FROM/THRU'
	            ),
	            React.createElement(
	              'div',
	              { className: 'slds-text-heading--small' },
	              Utils.Formatters.formatDate(this.props.promotionDetail.period.from) + ' - ' + Utils.Formatters.formatDate(this.props.promotionDetail.period.to)
	            )
	          ),
	          React.createElement(
	            'dt',
	            { className: 'slds-m-bottom--small' },
	            React.createElement(
	              'label',
	              { className: 'slds-text-body--small' },
	              AppManager.getLabel('PC_LBL_STATUS') || 'STATUS'
	            ),
	            React.createElement(
	              'div',
	              { className: 'slds-text-heading--small' },
	              this.props.promotionDetail.period.phase
	            )
	          ),
	          React.createElement(
	            'dt',
	            { className: 'slds-m-bottom--small' },
	            React.createElement(
	              'label',
	              { className: 'slds-text-body--small' },
	              AppManager.getLabel('PC_LBL_ANCHOR') || 'ANCHOR'
	            ),
	            React.createElement(
	              'div',
	              { className: 'slds-text-heading--small' },
	              this.props.promotionDetail.promotion.Account_Name
	            )
	          ),
	          this.props.promotionDetailData && this.props.promotionDetailData.Id == this.props.promotionDetail.period.Id ? React.createElement(
	            'dt',
	            { className: 'slds-m-bottom--small' },
	            React.createElement(
	              'label',
	              { className: 'slds-text-body--small' },
	              AppManager.getLabel('PC_LBL_TACTICS_FROM_THRU') || 'TACTICS FROM/THRU'
	            ),
	            this.props.promotionDetailData.Tactics.map(function (tactic) {
	              return React.createElement(
	                'div',
	                { className: 'slds-text-heading--small' },
	                Utils.Formatters.formatDate(tactic.Date_From),
	                '- ',
	                Utils.Formatters.formatDate(tactic.Date_Thru),
	                ' - ',
	                tactic.Description
	              );
	            })
	          ) : null
	        ),
	        React.createElement(
	          'dt',
	          { className: 'slds-clearfix' },
	          React.createElement(
	            'section',
	            { className: 'slds-float--left slds-p-left--small' },
	            React.createElement(
	              Button,
	              { type: 'neutral',
	                onClick: function onClick() {
	                  return PromCalendarActions.openPromotionDetail(_this.props.promotionDetail.period.Id);
	                } },
	              AppManager.getLabel('PC_BTN_OPEN') || 'Open'
	            )
	          ),
	          React.createElement(
	            'section',
	            { className: 'slds-float--right slds-p-right--small' },
	            React.createElement(
	              Button,
	              { type: 'neutral',
	                disabled: 'true',
	                onClick: function onClick() {
	                  return PromCalendarActions.derivePromotionDetail(_this.props.promotionDetail.period.Id);
	                } },
	              AppManager.getLabel('PC_BTN_DERIVE') || 'Derive'
	            ),
	            React.createElement(
	              Button,
	              { type: 'neutral',
	                onClick: function onClick() {
	                  return _this.deletePromotion(_this.props.promotionDetail);
	                } },
	              AppManager.getLabel('PC_BTN_DELETE') || 'Delete'
	            )
	          )
	        ),
	        React.createElement('dt', { className: 'slds-p-bottom--small' })
	      )
	    );
	  }
		});

/***/ },

/***/ 614:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	module.exports = React.createClass({
	    displayName: 'ConfirmPopup',

	    componentDidMount: function componentDidMount() {},

	    render: function render() {
	        var _this = this;

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                'div',
	                { 'aria-hidden': 'false', 'aria-labelledby': 'prompt-heading-id', 'aria-describedby': 'prompt-message-wrapper',
	                    role: 'alertdialog', className: 'slds-modal slds-modal--prompt slds-fade-in-open' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-modal__container slds-modal--prompt', role: 'document',
	                        id: 'prompt-message-wrapper', tabIndex: '0' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__header slds-theme--warning slds-theme--alert-texture' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--medium', id: 'prompt-heading-id' },
	                            this.props.title
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__content slds-p-around--medium' },
	                        React.createElement(
	                            'div',
	                            null,
	                            React.createElement(
	                                'p',
	                                null,
	                                this.props.message
	                            )
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__footer slds-theme--default' },
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this.props.cancelHandler();
	                                } },
	                            AppManager.getLabel("PP_BTN_CANCEL") || 'Cancel'
	                        ),
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this.props.okHandler();
	                                } },
	                            AppManager.getLabel("PP_BTN_OK") || 'Ok'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	        );
	    }
		});

/***/ },

/***/ 615:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var React = __webpack_require__(283);

	var ButtonGroup = __webpack_require__(461).ButtonGroup;
	var Button = __webpack_require__(461).Button;
	var DropdownButton = __webpack_require__(461).DropdownButton;
	var MenuItem = __webpack_require__(461).MenuItem;
	var Icon = __webpack_require__(461).Icon;
	var Picklist = __webpack_require__(461).Picklist;
	var PicklistItem = __webpack_require__(461).PicklistItem;
	var Input = __webpack_require__(461).Input;
	var Multiselection = __webpack_require__(616);
	var Popover = __webpack_require__(609);

	var PromCalendarActions = __webpack_require__(607).PromCalendarActions;
	var RemovablePill = __webpack_require__(617);

	/*************************************************************/

	var CalendarFilterItem = React.createClass({
	    displayName: 'CalendarFilterItem',

	    toggleValue: function toggleValue(valueId) {
	        var opt = _.find(this.props.filterItem.values, { Id: valueId });
	        opt.Selected = !opt.Selected;
	        this.forceUpdate();
	    },

	    render: function render() {
	        var _this = this;

	        var values = this.props.filterItem.values;
	        var disabledFieldCombo = this.props.availableFields == null;

	        return React.createElement(
	            Popover,
	            { className: 'filter-popover', direction: 'horizontal', nubbinMargin: 12, onClickOutside: this.props.closeHandler },
	            React.createElement(
	                'div',
	                { className: 'slds-popover__body' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-p-around--small' },
	                    disabledFieldCombo ? React.createElement(Input, { label: AppManager.getLabel("PC_LBL_FIELD") || 'Field', type: 'text', disabled: 'true',
	                        value: this.props.filterItem.label }) : React.createElement(
	                        Picklist,
	                        { label: AppManager.getLabel("PC_LBL_FIELD") || 'Field',
	                            value: this.props.filterItem.fieldId,
	                            onValueChange: this.props.changeField },
	                        this.props.availableFields.map(function (a, i) {
	                            return React.createElement(PicklistItem, { key: i + 1, value: a.fieldId, label: a.label });
	                        })
	                    ),
	                    React.createElement(Multiselection, { label: AppManager.getLabel("PC_LBL_VALUE") || 'Value', required: 'false',
	                        className: 'slds-m-top--small',
	                        values: values,
	                        toggleHandler: this.toggleValue }),
	                    React.createElement(
	                        'section',
	                        { className: 'slds-clearfix slds-m-top--small' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-float--right' },
	                            React.createElement(
	                                Button,
	                                { className: 'close-button slds-float--right', type: 'neutral',
	                                    onClick: function onClick() {
	                                        return _this.props.closeHandler();
	                                    } },
	                                AppManager.getLabel("PP_BTN_DONE") || 'Done'
	                            )
	                        )
	                    )
	                )
	            )
	        );
	    }
	});

	/*************************************************************/

	var CalendarFilterSection = React.createClass({
	    displayName: 'CalendarFilterSection',

	    getInitialState: function getInitialState() {
	        return {
	            openedFilterItem: null,
	            addingNewFilter: null
	        };
	    },

	    getPlaceholder: function getPlaceholder(values) {
	        return _.map(_.filter(values, { Selected: true }), 'Label').join(', ');
	    },

	    emptyFilter: function emptyFilter(array) {
	        array.map(function (item) {
	            item.Selected = false;
	        });
	        this.props.modifiedHandler();
	        this.forceUpdate();
	    },

	    addFilter: function addFilter(filtersToAdd) {
	        this.setState({ openedFilterItem: null, addingNewFilter: filtersToAdd[0] });
	    },

	    addNewFilter: function addNewFilter() {
	        this.setState({ openedFilterItem: null, addingNewFilter: null });
	        this.props.modifiedHandler();
	    },

	    changeFieldNewFilter: function changeFieldNewFilter(fieldItem) {
	        this.state.addingNewFilter.values.map(function (val) {
	            val.Selected = false;
	        });
	        this.setState({ addingNewFilter: fieldItem });
	    },

	    openFilter: function openFilter(filterItem) {
	        this.setState({ openedFilterItem: filterItem });
	    },

	    closeFilter: function closeFilter() {
	        this.setState({ openedFilterItem: null });
	        this.props.modifiedHandler();
	    },

	    renderFilterItem: function renderFilterItem(filterItem) {
	        return React.createElement(CalendarFilterItem, { filterItem: filterItem,
	            closeHandler: this.closeFilter });
	    },

	    render: function render() {
	        var _this2 = this;

	        var filtersAdded = _.filter(this.props.filterSection, function (item) {
	            return _.some(item.values, { Selected: true });
	        });

	        var filtersToAdd = _.difference(this.props.filterSection, filtersAdded);
	        var canAddNewFilter = this.props.filterSection.length != filtersAdded.length && !this.state.addingNewFilter;

	        return React.createElement(
	            'section',
	            null,
	            React.createElement(
	                'div',
	                { className: 'filter-title' },
	                this.props.title
	            ),
	            filtersAdded.map(function (filterItem) {
	                return React.createElement(
	                    RemovablePill,
	                    _extends({
	                        className: filterItem == _this2.state.openedFilterItem ? "slds-m-top--medium tpm-open-pill" : "slds-m-top--medium ",
	                        closeHandler: function closeHandler() {
	                            return _this2.emptyFilter(filterItem.values);
	                        },
	                        openHandler: function openHandler() {
	                            return _this2.openFilter(filterItem);
	                        },
	                        label: filterItem.label, value: _this2.getPlaceholder(filterItem.values)
	                    }, _this2.props),
	                    filterItem == _this2.state.openedFilterItem ? _this2.renderFilterItem(filterItem) : null
	                );
	            }),
	            this.state.addingNewFilter ? React.createElement(
	                RemovablePill,
	                _extends({ className: 'slds-m-top--medium tpm-open-pill',
	                    closeHandler: function closeHandler() {
	                        return _this2.emptyFilter(_this2.state.addingNewFilter.values);
	                    },
	                    openHandler: function openHandler() {
	                        return _this2.openFilter(_this2.state.addingNewFilter);
	                    },
	                    label: 'New Filter *' }, this.props),
	                React.createElement(CalendarFilterItem, { filterItem: this.state.addingNewFilter, availableFields: filtersToAdd,
	                    changeField: function changeField(fieldId) {
	                        _this2.changeFieldNewFilter(_.find(filtersToAdd, { fieldId: fieldId }));
	                    },
	                    closeHandler: this.addNewFilter })
	            ) : null,
	            canAddNewFilter ? React.createElement(
	                Button,
	                { icon: 'add', className: 'slds-m-top--small add-filter', onClick: function onClick() {
	                        _this2.addFilter(filtersToAdd);
	                    } },
	                ' ',
	                AppManager.getLabel('PC_BTN_ADD_FILTER') || 'Add filter'
	            ) : null
	        );
	    }
	});

	/*************************************************************/

	module.exports = React.createClass({
	    displayName: 'CalendarFilter',

	    getInitialState: function getInitialState() {
	        return { modified: false };
	    },

	    render: function render() {
	        var _this3 = this;

	        return React.createElement(
	            'div',
	            { className: 'slds-col side-panel' },
	            this.state.modified ? React.createElement(
	                'div',
	                { className: 'side-panel-header slds-text-align--right slds-p-around--medium ' },
	                React.createElement(
	                    Button,
	                    { icon: 'close', type: 'neutral', iconAlign: 'left', className: 'icon-button',
	                        onClick: this.props.closeHandler },
	                    ' ',
	                    AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'
	                ),
	                React.createElement(
	                    Button,
	                    { icon: 'check', type: 'brand', iconAlign: 'left', className: 'icon-button',
	                        onClick: this.props.saveHandler },
	                    ' ',
	                    AppManager.getLabel('PC_BTN_SAVE') || 'Save'
	                )
	            ) : React.createElement(
	                'div',
	                { className: 'side-panel-header slds-clearfix slds-p-around--small' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-float--left ' },
	                    React.createElement(
	                        'p',
	                        null,
	                        AppManager.getLabel('PC_LBL_FILTERS') || 'Filters'
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'back-arrow' },
	                    React.createElement(Button, { className: 'close-button', icon: 'forward', size: 'small',
	                        onClick: this.props.closeHandler })
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'side-panel-body' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-m-top--small calendar-filter' },
	                    React.createElement(CalendarFilterSection, { title: AppManager.getLabel('PC_TIT_ACCOUNTS') || 'Accounts',
	                        filterSection: this.props.calendar.FilterCriteria.accountfilter,
	                        modifiedHandler: function modifiedHandler() {
	                            _this3.setState({ modified: true });
	                        } }),
	                    React.createElement(CalendarFilterSection, { title: AppManager.getLabel('PC_TIT_PROMOTIONS') || 'Promotions',
	                        filterSection: this.props.calendar.FilterCriteria.promotionfilter,
	                        modifiedHandler: function modifiedHandler() {
	                            _this3.setState({ modified: true });
	                        } }),
	                    React.createElement(CalendarFilterSection, { title: AppManager.getLabel('PC_TIT_PRODUCTS') || 'Products',
	                        filterSection: this.props.calendar.FilterCriteria.productfilter,
	                        modifiedHandler: function modifiedHandler() {
	                            _this3.setState({ modified: true });
	                        } })
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 616:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var DropdownButton = __webpack_require__(461).DropdownButton;
	var MenuItem = __webpack_require__(461).MenuItem;
	var Icon = __webpack_require__(461).Icon;

	DropdownButton.prototype.onMenuItemClick = function () {

	    if (this.props.onMenuItemClick) {
	        var _props;

	        (_props = this.props).onMenuItemClick.apply(_props, arguments);
	    }
	};
	module.exports = React.createClass({
	    displayName: 'Multiselection',

	    toggle: function toggle(id, event) {
	        this.props.toggleHandler(id);
	    },

	    componentDidMount: function componentDidMount() {
	        var ddDOM = ReactDOM.findDOMNode(this.refs.dropdown.refs.dropdown);
	        if (ddDOM.className.indexOf(" slds-scrollable--y") == -1) ddDOM.className += " slds-scrollable--y";
	    },

	    getPlaceholder: function getPlaceholder() {
	        var selection = (AppManager.getLabel("PC_LBL_SELECT") || 'Select') + '...';
	        var selected = _.filter(this.props.values, { Selected: true });
	        if (selected.length >= 3) {
	            selection = selected.length + " " + (AppManager.getLabel("PC_LBL_VALUES_SELECTED") || 'values selected');
	        } else if (selected.length > 0) {
	            selection = _.map(_.filter(this.props.values, { Selected: true }), 'Label').join(', ');
	        }
	        return selection;
	    },

	    render: function render() {
	        var _this = this;

	        var klass = 'multiselection slds-form-element ' + this.props.className;

	        return React.createElement(
	            'div',
	            { className: klass },
	            React.createElement(
	                'label',
	                { className: 'slds-form-element__label' },
	                this.props.label
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-form-element__control' },
	                React.createElement(
	                    DropdownButton,
	                    { type: 'neutral', menuAlign: 'left', label: this.getPlaceholder(), ref: 'dropdown' },
	                    this.props.values.map(function (item, ix) {
	                        return React.createElement(
	                            MenuItem,
	                            { key: ix,
	                                onClick: function onClick(event) {
	                                    return _this.toggle(item.Id, event);
	                                },
	                                className: 'slds-has-icon slds-has-icon--left' },
	                            item.Selected ? React.createElement(Icon, { icon: 'check', size: 'x-small', className: 'slds-icon--left' }) : React.createElement(Icon, { icon: 'none', size: 'x-small', className: 'slds-icon--left' }),
	                            item.Label
	                        );
	                    })
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 617:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Button = __webpack_require__(461).Button;

	module.exports = React.createClass({
	    displayName: 'exports',


	    render: function render() {
	        var _this = this;

	        var klass = 'pill-panel slds-p-around--small ' + this.props.className;

	        return React.createElement(
	            'div',
	            null,
	            this.props.children,
	            React.createElement(
	                'div',
	                { className: klass },
	                React.createElement(Button, { className: 'close-button slds-float--right', icon: 'close', iconSize: 'small',
	                    onClick: function onClick() {
	                        return _this.props.closeHandler();
	                    } }),
	                React.createElement(
	                    'div',
	                    { className: 'pill-body', onClick: function onClick() {
	                            return _this.props.openHandler();
	                        } },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-text-body--small filter-label' },
	                        this.props.label
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: ' filter-value' },
	                        this.props.value
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 618:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var Input = __webpack_require__(461).Input;
	var Button = __webpack_require__(461).Button;
	var Icon = __webpack_require__(461).Icon;

	var Multiselection = __webpack_require__(616);

	module.exports = React.createClass({
	    displayName: 'InitCalendar',

	    getInitialState: function getInitialState() {
	        return {};
	    },

	    onSave: function onSave() {
	        this.props.saveHandler(this.state);
	    },

	    onCancel: function onCancel() {
	        this.props.cancelHandler();
	    },

	    toggleSelection: function toggleSelection(arrayItems, itemId) {
	        var opt = _.find(arrayItems, { Id: itemId });
	        opt.Selected = !opt.Selected;
	        this.forceUpdate();
	    },

	    toggleAccount: function toggleAccount(itemId) {
	        //TODO: MOVE TO STATE!!!
	        this.toggleSelection(this.props.calendar.FilterCriteria.accountfilter[0].values, itemId);
	    },

	    togglePromotionTemplate: function togglePromotionTemplate(itemId) {
	        this.toggleSelection(this.props.calendar.FilterCriteria.promotionfilter[0].values, itemId);
	    },

	    toggleTacticTemplate: function toggleTacticTemplate(itemId) {
	        this.toggleSelection(this.props.calendar.FilterCriteria.promotionfilter[1].values, itemId);
	    },

	    toggleProductCategory: function toggleProductCategory(itemId) {
	        this.toggleSelection(this.props.calendar.FilterCriteria.productfilter[0].values, itemId);
	    },

	    renderContent: function renderContent() {
	        var message = AppManager.getLabel('PC_LBL_INIT_CALENDAR_MSG_1') || 'Hi, your user settings haven\'t completed yet. ';
	        var message2 = AppManager.getLabel('PC_LBL_INIT_CALENDAR_MSG_2') || ' To avoid longer loading times, please fill them in before you continue.';

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                'div',
	                { className: 'slds-notify slds-p-around--x-small slds-theme--warning', role: 'alert' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-notify__content slds-grid' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col--padded' },
	                        React.createElement(Icon, { icon: 'warning' })
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col slds-align-left' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--small' },
	                            message
	                        ),
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--small' },
	                            message2
	                        )
	                    )
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-grid' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-col slds-p-around--x-small slds-size--1-of-2' },
	                    React.createElement(Multiselection, { label: AppManager.getLabel('PC_LBL_CUSTOMER') || 'Customer', required: 'true',
	                        values: this.props.calendar.FilterCriteria.accountfilter[0].values,
	                        toggleHandler: this.toggleAccount })
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-col slds-p-around--x-small slds-size--1-of-2' },
	                    React.createElement(Multiselection, { label: AppManager.getLabel('PC_LBL_PROMOTION_TYPE') || 'Promotion Type',
	                        required: 'false',
	                        values: this.props.calendar.FilterCriteria.promotionfilter[0].values,
	                        toggleHandler: this.togglePromotionTemplate })
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-grid ' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-col slds-p-around--x-small slds-size--1-of-2' },
	                    React.createElement(Multiselection, { label: AppManager.getLabel('PC_LBL_PRODUCT_CATEGORY') || 'Product Category',
	                        required: 'true',
	                        values: this.props.calendar.FilterCriteria.productfilter[0].values,
	                        toggleHandler: this.toggleProductCategory })
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-col slds-p-around--x-small slds-size--1-of-2' },
	                    React.createElement(Multiselection, { label: AppManager.getLabel('PC_LBL_TACTIC_TYPE') || 'Tactic Type',
	                        required: 'false',
	                        values: this.props.calendar.FilterCriteria.promotionfilter[1].values,
	                        toggleHandler: this.toggleTacticTemplate })
	                )
	            )
	        );
	    },

	    render: function render() {
	        var _this = this;

	        if (this.props.calendar == null) return null;
	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                'div',
	                { className: 'slds-modal slds-fade-in-open', 'aria-hidden': 'false', role: 'dialog' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-modal__container' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__header' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--medium' },
	                            AppManager.getLabel('PC_TIT_EDIT_SETTINGS') || 'Edit your Settings'
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__content overflow-visible' },
	                        this.renderContent()
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__footer' },
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this.onCancel();
	                                } },
	                            AppManager.getLabel('PC_BTN_CONTINUE') || 'Continue anyways'
	                        ),
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral slds-button--brand',
	                                onClick: function onClick() {
	                                    return _this.onSave();
	                                } },
	                            AppManager.getLabel('PC_BTN_SAVE') || 'Save'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	        );
	    }
		});

/***/ },

/***/ 619:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var AppHeader = __webpack_require__(460);
	var ReactCSSTransitionGroup = __webpack_require__(620);
	var DrillDown = __webpack_require__(633);
	var PromotionOverview = __webpack_require__(635);
	var TacticOverview = __webpack_require__(649);

	var PromotionPlanningCalculationGridPage = __webpack_require__(657);
	var PromotionActions = __webpack_require__(643).PromotionActions;

	var ButtonGroup = __webpack_require__(461).ButtonGroup;
	var Button = __webpack_require__(461).Button;
	var DropdownButton = __webpack_require__(461).DropdownButton;
	var MenuItem = __webpack_require__(461).MenuItem;
	var MessagePopup = __webpack_require__(658);

	var ConfirmPopup = __webpack_require__(614);

	module.exports = React.createClass({
	    displayName: 'PromotionPlanning',

	    getInitialState: function getInitialState() {
	        return {
	            editMode: false,
	            pushMode: false,
	            viewGrid: false,
	            enableToolbar: true,
	            selectedItem: null,
	            showAttachments: false,
	            isPromotionSelected: false,
	            productSearch: [],
	            confirmMessage: null,
	            tree: null,
	            type: 'neutral',
	            message: null
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        this.busHandlerID = UI_EVENT_BUS.subscribe(EVENTS.UI_BINDING, this.onUIBinding);
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        UI_EVENT_BUS.unsubscribe(this.busHandlerID);
	    },

	    onUIBinding: function onUIBinding(payload) {
	        this.setState(payload);
	    },

	    promoChanged: function promoChanged() {
	        this.setState({
	            promotion: this.props.promotion.serializeTree(),
	            productFilters: this.props.promotion.serializeProductFilters(),
	            selectedTactic: this.props.promotion.serializeSelectedTactic()
	        });
	    },

	    /**HANDLERS**/
	    /*When an item is selected in the drillDown*/
	    selectItem: function selectItem(item) {
	        var isPromotionSelected = true;
	        if (item.type == 'PROMOTION') {
	            PromotionActions.selectPromotion();
	        }
	        if (item.type == 'TACTIC') {
	            PromotionActions.selectTactic(item.Id);
	            isPromotionSelected = false;
	        }
	        this.setState({ selectedItem: item, isPromotionSelected: isPromotionSelected });
	    },

	    addTactic: function addTactic(tacticTemplate) {
	        PromotionActions.addTactic({ Id: tacticTemplate.Id, Type: tacticTemplate.Type });
	    },

	    duplicateTactic: function duplicateTactic(tactic) {
	        PromotionActions.duplicateTactic(tactic.Id);
	    },

	    deleteTactic: function deleteTactic(tactic) {
	        var me = this;
	        var confirmMessage = {
	            title: 'Confirmation',
	            message: 'Do you want to delete the tactic?',
	            cancelHandler: function cancelHandler() {
	                me.setState({ confirmMessage: null });
	            },
	            okHandler: function okHandler() {
	                PromotionActions.deleteTactic(tactic.Id);
	                me.setState({ confirmMessage: null });
	            }
	        };

	        this.setState({ confirmMessage: confirmMessage });
	    },

	    updateTactic: function updateTactic(id, name, value) {
	        PromotionActions.setTacticField(id, name, value);
	    },

	    updatePromotion: function updatePromotion(id, name, value) {
	        PromotionActions.setPromotionField(id, name, value);
	    },

	    /*When save button is clicked*/
	    save: function save() {
	        if (this.state.tree && this.state.tree != null) {
	            PromotionActions.setPromotionField(this.state.promotion.Id, 'Manual_Calculation_Input__c', JSON.stringify(this.state.tree.getManualChanges()));
	        }
	        PromotionActions.save(this.state.promotion.Id);
	        this.setState({ editMode: false });
	    },

	    saveAndRefresh: function saveAndRefresh() {
	        if (this.state.tree && this.state.tree != null) {
	            PromotionActions.setPromotionField(this.state.promotion.Id, 'Manual_Calculation_Input__c', JSON.stringify(this.state.tree.getManualChanges()));
	        }
	        this.setState({ enableToolbar: false });
	        PromotionActions.saveAndRefresh(this.state.promotion.Id);
	    },
	    //Unilever Function to call the Workflow change
	    changeWf: function changeWf(e) {
	        console.log(e);
	        PromotionActions.changeWfState(e);
	    },

	    //PMA - START CODE - 2017-01-13 - Threshold button
	    invokeThreshold: function invokeThreshold() {
	        PromotionActions.invokeThreshold(this.state.promotion.Id, this);
	    },
	    //PMA - END CODE - 2017-01-13 - Threshold button

	    //PMA - START CODE - 2017-01-17 - Audit Trail button
	    invokeAuditTrail: function invokeAuditTrail() {
	        PromotionActions.invokeAuditTrail();
	    },
	    //PMA - END CODE - 2017-01-17 - Audit Trail button

	    /*When edit button is clicked*/
	    edit: function edit() {
	        this.setState({ editMode: true });
	    },

	    cancel: function cancel() {
	        var me = this;
	        this.setState({ enableToolbar: false });
	        PromotionActions.cancelEdit(this.state.promotion.Id, this.state.tree && this.state.tree != null ? "tree" : "ui");

	        this.setState({ editMode: false });
	    },

	    pushMode: function pushMode() {
	        this.setState({ pushMode: true });
	    },

	    pushModeEnd: function pushModeEnd() {
	        this.setState({ pushMode: false });
	    },

	    updateEnablePush: function updateEnablePush() {
	        PromotionActions.updateEnablePush();
	    },

	    loadPlanningData: function loadPlanningData() {
	        PromotionActions.setPromotionField(this.state.promotion.Id, 'Manual_Calculation_Input__c', JSON.stringify(this.state.tree.getManualChanges()));
	        this.setState({ viewGrid: false });
	    },

	    loadGridData: function loadGridData(showGrid) {
	        var me = this;
	        if (showGrid) {
	            this.setState({ viewGrid: true });
	            PromotionActions.loadPromotionGrid(this.state.promotion.Id, this.state.promotion.Manual_Calculation_Input__c);
	        }
	    },

	    /**RENDERING*/
	    renderModeButtonGroup: function renderModeButtonGroup() {
	        var _this = this;

	        return React.createElement(
	            ButtonGroup,
	            null,
	            React.createElement(Button, { className: 'view-switch icon-button', type: this.state.viewGrid ? 'neutral' : 'brand',
	                icon: 'side_list', disabled: !this.state.enableToolbar,
	                onClick: function onClick() {
	                    return _this.loadPlanningData();
	                } }),
	            React.createElement(Button, { className: 'view-switch icon-button', type: !this.state.viewGrid ? 'neutral' : 'brand',
	                icon: 'table',
	                disabled: !this.state.enableToolbar,
	                onClick: function onClick() {
	                    return _this.loadGridData(true);
	                } })
	        );
	    },

	    isVisible: function isVisible(attribute) {
	        var acl = this.state.promotion._acl;
	        return acl.isVisible(1, attribute);
	    },


	    renderToolbarView: function renderToolbarView() {
	        var _this2 = this;

	        var editButton,
	            approveButton,
	            cancelButton,
	            kickOffWorkflowButton,
	            pushButton,
	            releaseButton,
	            thresholdButton,
	            simulationButton,
	            modelButton,
	            plannedButton,
	            submittedForApprovalButton,
	            rejectedButton,
	            finalisedButton,
	            cancelledButton,
	            stoppedButton,
	            auditTrailButton,
	            endDateButton = null;

	        if (this.state.promotion != null && this.state.promotion.isEditable && (this.state.viewGrid || !this.state.viewGrid && this.state.selectedItem != null && (this.state.selectedItem.type == 'PROMOTION' || this.state.selectedItem.type == 'TACTIC'))) {
	            editButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral', icon: 'edit', iconAlign: 'left',
	                    onClick: function onClick() {
	                        return _this2.edit();
	                    } },
	                AppManager.getLabel('PP_BTN_EDIT') || 'Edit'
	            );

	            //Custom buttons available in the left side of the toolbar
	            //PMA - START CODE - 2017-01-12 - Toolbar buttons visibility
	            //START SoCo Buttons
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_SUBMIT")) kickOffWorkflowButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('SUBMIT');
	                    } },
	                AppManager.getLabel('PP_BTN_SUBMIT') || 'Submit'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_APPROVE")) approveButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('APPROVE');
	                    } },
	                AppManager.getLabel('PP_BTN_APPROVE') || 'Approve'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_REJECT")) cancelButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('REJECT');
	                    } },
	                AppManager.getLabel('PP_BTN_REJECT') || 'Reject'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_ENDDATE")) endDateButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('EndDate');
	                    } },
	                AppManager.getLabel('PP_BTN_ENDDATE') || 'End Date'
	            );
	            //START UK Buttons
	            //PMA - START CODE - 2017-01-16 - New UK Button
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_SIMULATION")) simulationButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Simulation');
	                    } },
	                AppManager.getLabel('PP_BTN_SIMULATION') || 'Simulation'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_MODEL")) modelButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Model');
	                    } },
	                AppManager.getLabel('PP_BTN_MODEL') || 'Model'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_PLANNED")) plannedButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Planned');
	                    } },
	                AppManager.getLabel('PP_BTN_PLANNED') || 'Planned'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_SUBMITTEDFORAPPROVAL")) submittedForApprovalButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Submitted for Approval');
	                    } },
	                AppManager.getLabel('PP_BTN_SUBMITTEDFORAPPROVAL') || 'Submitted for Approval'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_REJECTED")) rejectedButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Rejected');
	                    } },
	                AppManager.getLabel('PP_BTN_REJECTED') || 'Rejected'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_FINALISED")) finalisedButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Finalised');
	                    } },
	                AppManager.getLabel('PP_BTN_FINALISED') || 'Finalised'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_CANCELLED")) cancelledButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Cancelled');
	                    } },
	                AppManager.getLabel('PP_BTN_CANCELLED') || 'Cancelled'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_STOPPED")) stoppedButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.changeWf('Stopped');
	                    } },
	                AppManager.getLabel('PP_BTN_STOPPED') || 'Stopped'
	            );
	            //PMA - END CODE - 2017-01-16 - New UK Button
	            //PMA - START CODE - 2017-01-13 - Threshold button
	            if (this.state.promotion != null) thresholdButton = React.createElement(
	                Button,
	                { className: 'margin-large', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.invokeThreshold();
	                    } },
	                AppManager.getLabel('PP_BTN_INVOKETHRESHOLD') || 'Threshold'
	            );
	            //PMA - END CODE - 2017-01-13 - Threshold button

	            //Custom buttons available in the right side of the toolbar
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_AUDITTRAIL")) auditTrailButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral',
	                    onClick: function onClick(e) {
	                        return _this2.invokeAuditTrail();
	                    } },
	                AppManager.getLabel('PP_BTN_AUDITTRAIL') || 'Audit Trail'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_PUSH")) pushButton = React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral', disabled: this.state.pushMode || !this.state.isPromotionSelected,
	                    onClick: function onClick(e) {
	                        return _this2.pushMode();
	                    } },
	                AppManager.getLabel('PP_BTN_PUSH') || 'Push'
	            );
	            if (this.state.promotion != null && this.isVisible("TOOLBAR_BTN_RELEASE")) releaseButton = React.createElement(
	                Button,
	                { className: 'margin-large', type: 'neutral', disabled: !this.state.isPromotionSelected,
	                    onClick: function onClick(e) {
	                        return _this2.updateEnablePush();
	                    } },
	                AppManager.getLabel('PP_BTN_RELEASE') || 'Release'
	            );
	            //PMA - END CODE - 2017-01-12 - Toolbar buttons visibility
	        }

	        return (
	            //add buttons in here
	            React.createElement(
	                'div',
	                { className: 'slds-grid' },
	                this.renderModeButtonGroup(),
	                editButton,
	                kickOffWorkflowButton,
	                approveButton,
	                rejectedButton,
	                cancelButton,
	                endDateButton,
	                simulationButton,
	                modelButton,
	                plannedButton,
	                submittedForApprovalButton,
	                finalisedButton,
	                cancelledButton,
	                stoppedButton,
	                thresholdButton,
	                React.createElement('div', { className: 'slds-col--bump-right' }),
	                this.state.promotion && this.state.promotion.ChildAccounts && this.state.promotion.ChildAccounts.length > 0 ? React.createElement(
	                    'div',
	                    { className: 'slds-container--right' },
	                    auditTrailButton,
	                    pushButton,
	                    releaseButton
	                ) : React.createElement(
	                    'div',
	                    { className: 'slds-container--right' },
	                    auditTrailButton
	                ),
	                !this.state.viewGrid ? React.createElement(Button, { className: 'ui-attachment__button icon-button',
	                    type: this.state.showAttachments ? 'brand' : 'neutral',
	                    icon: 'attach',
	                    disabled: !this.state.isPromotionSelected,
	                    onClick: function onClick() {
	                        return _this2.setState({ showAttachments: !_this2.state.showAttachments });
	                    } }) : null
	            )
	        );
	    },

	    // Change Button color onClick
	    noFocus: function noFocus(option) {
	        this.setState({
	            type: 'neutral'
	        });
	    },

	    changeButtonTypeOnClick: function changeButtonTypeOnClick() {
	        if (this.state.type == 'neutral') {
	            this.setState({
	                type: 'brand'
	            });
	        } else {
	            this.setState({
	                type: 'neutral'
	            });
	        }
	    },

	    renderToolbarEdit: function renderToolbarEdit() {
	        var _this3 = this;

	        var menuItems = [];
	        var enableToolbar = this.state.enableToolbar;
	        return React.createElement(
	            'div',
	            { className: 'slds-grid' },
	            this.renderModeButtonGroup(),
	            !this.state.viewGrid && this.state.selectedTactic == null && this.isVisible("TOOLBAR_BTN_ADDTACTIC") ? React.createElement(
	                DropdownButton,
	                { className: 'margin-large icon-dropdown',
	                    type: this.state.type, onBlur: this.noFocus, onMenuItemClick: this.noFocus,
	                    onClick: this.changeButtonTypeOnClick,
	                    icon: 'add', iconAlign: 'left',
	                    iconMore: '',
	                    label: 'Add',
	                    disabled: !enableToolbar,
	                    menuAlign: 'center', nubbinTop: true },
	                React.createElement(
	                    'label',
	                    { className: 'menuItemLabel' },
	                    AppManager.getLabel('PP_LBL_TACTIC') || 'TACTIC'
	                ),
	                this.state.promotion.tacticTemplates.map(function (tacticTemplate, ix) {
	                    return React.createElement(
	                        MenuItem,
	                        { key: ix,
	                            onClick: function onClick() {
	                                return _this3.addTactic(tacticTemplate);
	                            } },
	                        tacticTemplate.Description__c
	                    );
	                })
	            ) : null,
	            !this.state.viewGrid && this.state.selectedTactic != null ? React.createElement(
	                Button,
	                { className: 'margin-large icon-button', type: 'neutral', icon: 'relate', iconAlign: 'left',
	                    disabled: !enableToolbar,
	                    onClick: function onClick() {
	                        return _this3.duplicateTactic(_this3.state.selectedTactic);
	                    } },
	                AppManager.getLabel('PP_BTN_DUPLICATE') || 'Duplicate'
	            ) : null,
	            !this.state.viewGrid && this.state.selectedTactic != null ? React.createElement(
	                Button,
	                { className: 'margin-small icon-button', type: 'neutral', icon: 'delete', iconAlign: 'left',
	                    disabled: !enableToolbar,
	                    onClick: function onClick() {
	                        return _this3.deleteTactic(_this3.state.selectedTactic);
	                    } },
	                AppManager.getLabel('PP_BTN_DELETE') || 'Delete'
	            ) : null,
	            React.createElement('div', { className: 'slds-col--bump-right' }),
	            React.createElement(
	                Button,
	                { type: 'neutral', icon: 'refresh', iconAlign: 'left', className: 'icon-button', disabled: !enableToolbar,
	                    onClick: function onClick() {
	                        return _this3.saveAndRefresh();
	                    } },
	                AppManager.getLabel('PP_BTN_SAVE_REFRESH') || 'Save & Refresh'
	            ),
	            React.createElement(
	                Button,
	                { className: 'margin-small icon-button', type: 'neutral', icon: 'close', iconAlign: 'left',
	                    disabled: !enableToolbar,
	                    onClick: function onClick() {
	                        return _this3.cancel();
	                    } },
	                AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'
	            ),
	            React.createElement(
	                Button,
	                { className: 'margin-small icon-button', type: 'neutral', icon: 'check', iconAlign: 'left',
	                    disabled: !enableToolbar,
	                    onClick: function onClick() {
	                        return _this3.save();
	                    } },
	                AppManager.getLabel('PP_BTN_DONE') || 'Done'
	            ),
	            !this.state.viewGrid ? React.createElement(Button, { className: 'ui-attachment__button icon-button',
	                type: this.state.showAttachments ? 'brand' : 'neutral',
	                icon: 'attach',
	                disabled: !enableToolbar || !this.state.isPromotionSelected,
	                onClick: function onClick() {
	                    return _this3.setState({ showAttachments: !_this3.state.showAttachments });
	                } }) : null
	        );
	    },

	    renderMainSectionView: function renderMainSectionView() {
	        var overviewItem = null;
	        if (this.state.selectedItem != null) {
	            if (this.state.selectedItem.type == 'PROMOTION' || this.state.selectedTactic == null) {
	                overviewItem = React.createElement(PromotionOverview, { promotion: this.state.promotion,
	                    editMode: this.state.editMode, update: this.updatePromotion,
	                    showAttachments: this.state.showAttachments,
	                    editToggle: this.edit, pushMode: this.state.pushMode,
	                    pushModeEnd: this.pushModeEnd });
	            } else {
	                //if (this.state.selectedItem.type == 'TACTIC') {
	                overviewItem = React.createElement(TacticOverview, { item: this.state.selectedTactic, editMode: this.state.editMode,
	                    update: this.updateTactic, productFilters: this.state.productFilters,
	                    productSearch: this.state.productSearch, onSelect: this.selectItem });
	            }
	            /*else if (this.state.selectedItem.type == 'CATEGORY') {
	             overviewItem = <ProductGroupOverview item={this.state.selectedItem}/>
	             } else if (this.state.selectedItem.type == 'PRODUCT') {
	             overviewItem = <ProductOverview item={this.state.selectedItem}/>
	             }*/
	        }
	        return React.createElement(
	            'div',
	            { className: 'mainBodySection slds-grid' },
	            React.createElement(
	                'div',
	                { className: 'slds-grid slds-nowrap slds-grid--vertical-stretch', style: { width: '100%' } },
	                React.createElement(DrillDown, { root: this.state.promotion, onSelect: this.selectItem,
	                    selectedTactic: this.state.selectedTactic }),
	                React.createElement(
	                    'div',
	                    { className: 'flex-grow slds-scrollable--y', style: { maxWidth: 'calc(100% - 360px)' } },
	                    overviewItem
	                )
	            )
	        );
	    },

	    renderGridSectionView: function renderGridSectionView() {
	        return React.createElement(
	            'div',
	            { className: 'slds-scrollable--y mainBodySection slds-grid' },
	            React.createElement(
	                'div',
	                { className: 'slds-size--1-of-1 slds-grid slds-wrap slds-grid--vertical-stretch' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-size--1-of-3 tile calc-grid' },
	                    React.createElement(PromotionPlanningCalculationGridPage, { tree: this.state.tree, editMode: this.state.editMode,
	                        idToLabelMapping: this.state.idToLabelMapping,
	                        acl: this.state.promotion._acl })
	                )
	            )
	        );
	    },

	    showLog: function showLog(e) {
	        if (e.ctrlKey && e.altKey) {
	            console.group('DEBUGGER INFORMATION');
	            console.dir(this.state.promotion);
	            console.log("State");
	            console.dir(this.state);
	            console.groupEnd();
	        }
	    },

	    render: function render() {
	        var toolbar = this.state.editMode ? this.renderToolbarEdit() : this.renderToolbarView();
	        var mainSection = this.state.viewGrid ? this.renderGridSectionView() : this.renderMainSectionView();

	        var appHeader = null;
	        if (this.state.promotion != null) {
	            var fromDate = /*(_.isDate(this.props.promotion.Date_From__c)) ?*/Utils.Formatters.formatDate(this.state.promotion.Date_From__c) /* : this.props.promotion.Date_From__c*/;
	            var toDate = /*(_.isDate(this.props.promotion.Date_Thru__c)) ? */Utils.Formatters.formatDate(this.state.promotion.Date_Thru__c) /*: this.props.promotion.Date_Thru__c*/;
	            var account = this.state.promotion.Anchor_Account__r != null ? this.state.promotion.Anchor_Account__r.Name : '';
	            appHeader = React.createElement(AppHeader, { title: this.state.promotion.Slogan__c, subtitle: account + ' ' + fromDate + ' - ' + toDate,
	                icon: 'promo.png' });
	        }

	        return React.createElement(
	            'div',
	            { className: 'mainSection ' },
	            this.state.message ? React.createElement(MessagePopup, { title: this.state.message.title, message: this.state.message.message,
	                messagejson: this.state.message.messagejson,
	                cancelHandler: this.state.message.cancelHandler }) : null,
	            this.state.confirmMessage ? React.createElement(ConfirmPopup, { title: this.state.confirmMessage.title, message: this.state.confirmMessage.message,
	                cancelHandler: this.state.confirmMessage.cancelHandler,
	                okHandler: this.state.confirmMessage.okHandler }) : null,
	            appHeader,
	            React.createElement(
	                'div',
	                { className: 'slds-page-header promotion-toolbar', onClick: this.showLog },
	                toolbar
	            ),
	            this.state.promotion != null ? mainSection : null
	        );
	    }
		});

/***/ },

/***/ 633:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Icon = __webpack_require__(461).Icon;

	var Truncate = __webpack_require__(603);
	var ACLCheck = __webpack_require__(634);

	module.exports = React.createClass({
	    displayName: 'exports',

	    propTypes: {
	        root: React.PropTypes.object, // This must be the promotion structure tree
	        onSelect: React.PropTypes.func, // Handler for selected node
	        selectedTactic: React.PropTypes.object
	    },

	    getInitialState: function getInitialState() {
	        return {
	            selectedNode: this.props.root,
	            selectedProduct: null
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        UI_EVENT_BUS.subscribe(EVENTS.UI_BINDING, this.onUIBinding);
	        this.setParent(this.state.selectedNode, 0);
	        this.selectNode(this.props.root);
	    },

	    onUIBinding: function onUIBinding(payload) {
	        if (this.isMounted()) this.setState(payload);
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(props) {
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

	    lookforNode: function lookforNode(item, id) {
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

	    setParent: function setParent(item, deepLevel) {
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
	                this.setParent(item.children[i], deepLevel + 1);
	            }
	        }
	    },

	    selectNode: function selectNode(item) {
	        var me = this;
	        var emitSelect = function emitSelect() {
	            if (me.props.onSelect) {
	                me.props.onSelect(item);
	            }
	        };

	        if (item.type == 'PRODUCT') //Leaf node: "PRODUCT"
	            this.setState({ selectedProduct: item }, emitSelect);else this.setState({ selectedNode: item, selectedProduct: null }, emitSelect);
	    },

	    getParentTitle: function getParentTitle(item) {
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

	        if (item.type == 'PRODUCT') {}

	        return title;
	    },

	    getParentSubtitle: function getParentSubtitle(item) {
	        var subitems = '';

	        if (item.type == 'PROMOTION') {
	            subitems = 'Tactics';
	        }

	        if (item.type == 'TACTIC') {
	            subitems = 'Product Groups'; //TODO LOCALIZE
	        }

	        if (item.type == 'CATEGORY') {
	            subitems = 'Products';
	        }

	        if (item.type == 'PRODUCT') {}

	        return '(' + item.children.length + ' ' + subitems + ')';
	    },

	    renderParentOpenNode: function renderParentOpenNode(item, ix) {
	        var _this = this;

	        if (item.type == 'PRODUCT') return null;
	        var parentText = React.createElement(
	            'span',
	            null,
	            this.getParentTitle(item),
	            ' ',
	            this.getParentSubtitle(item)
	        );
	        return React.createElement(
	            'div',
	            { key: ix, className: 'parentitem open' },
	            React.createElement(
	                'div',
	                { className: 'title' },
	                React.createElement(
	                    'a',
	                    { href: '#', onClick: function onClick() {
	                            return _this.selectNode(item);
	                        } },
	                    React.createElement(Truncate, { lines: 2, children: parentText })
	                )
	            )
	        );
	    },

	    renderTacticNode: function renderTacticNode(item, index) {
	        var _this2 = this;

	        var childSelector = null;
	        if (item['children'] && item.children.length > 0) {
	            childSelector = React.createElement(Icon, { icon: 'chevronright', className: 'handler' });
	        } else {
	            childSelector = React.createElement('div', { className: 'handler' });
	        }

	        var fromDate = item.Date_From__c ? Utils.Formatters.formatDate(new Date(item.Date_From__c)) : '';
	        var toDate = item.Date_Thru__c ? Utils.Formatters.formatDate(new Date(item.Date_Thru__c)) : '';
	        var metadata = item._meta;

	        return React.createElement(
	            'div',
	            { key: index, className: 'item' },
	            React.createElement(
	                'a',
	                { href: '#', onClick: function onClick() {
	                        return _this2.selectNode(item);
	                    } },
	                React.createElement(
	                    'div',
	                    { className: 'itemInfo' },
	                    React.createElement(
	                        'div',
	                        { className: 'itemTitle' },
	                        React.createElement(
	                            'div',
	                            { className: 'desc' },
	                            item.Tactic_Template
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'itemSubtitle' },
	                            fromDate,
	                            ' - ',
	                            toDate
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'itemBody' },
	                        React.createElement(
	                            'div',
	                            { className: 'itemContent' },
	                            React.createElement(
	                                'div',
	                                { className: 'itemProp' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    metadata.Pct_of_Stores__c.label
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    Utils.Formatters.formatNumber(item.Pct_of_Stores__c)
	                                )
	                            ),
	                            React.createElement(
	                                ACLCheck,
	                                { object: this.state.selectedNode, field: 'TacticLift' },
	                                React.createElement(
	                                    'div',
	                                    { className: 'itemProp' },
	                                    React.createElement(
	                                        'label',
	                                        null,
	                                        metadata.Lift__c.label
	                                    ),
	                                    React.createElement(
	                                        'span',
	                                        null,
	                                        Utils.Formatters.formatNumber(item.Lift__c)
	                                    )
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'itemProp' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    metadata.Amount__c.label
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    Utils.Formatters.formatNumber(item.Amount__c)
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'itemProp large' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    metadata.Compensation_Model__c.label
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    item.Compensation_Model__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'itemProp' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    metadata.Payment_Method__c.label
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    item.Payment_Method__c
	                                )
	                            )
	                        )
	                    )
	                ),
	                childSelector
	            )
	        );
	    },

	    renderProductGroupNode: function renderProductGroupNode(item, index) {
	        var _this3 = this;

	        var childSelector = null;
	        if (item['children'] && item.children.length > 0) {
	            childSelector = React.createElement(Icon, { icon: 'chevronright', className: 'handler' });
	        }

	        var classItem = 'item';
	        if (this.state.selectedProduct == item) classItem += ' selected';

	        return React.createElement(
	            'div',
	            { key: index, className: classItem },
	            React.createElement(
	                'a',
	                { href: '#', onClick: function onClick() {
	                        return _this3.selectNode(item);
	                    } },
	                React.createElement(
	                    'div',
	                    { className: 'itemTitle' },
	                    React.createElement(
	                        'div',
	                        { className: 'desc' },
	                        item.Name
	                    ),
	                    childSelector
	                )
	            )
	        );
	    },

	    renderProductNode: function renderProductNode(item, index) {
	        var _this4 = this;

	        var childSelector = null;

	        var classItem = 'item';
	        if (this.state.selectedProduct == item) classItem += ' selected';

	        return React.createElement(
	            'div',
	            { key: index, className: classItem },
	            React.createElement(
	                'a',
	                { href: '#', onClick: function onClick() {
	                        return _this4.selectNode(item);
	                    } },
	                React.createElement(
	                    'div',
	                    { className: 'itemTitle' },
	                    React.createElement(
	                        'div',
	                        { className: 'desc' },
	                        item.Name
	                    )
	                )
	            )
	        );
	    },

	    renderSelectedNode: function renderSelectedNode(item, index) {
	        var _this5 = this;

	        var selectedText = React.createElement(
	            'span',
	            null,
	            this.getParentTitle(item),
	            ' ',
	            this.getParentSubtitle(item)
	        );
	        return React.createElement(
	            'div',
	            { key: index },
	            React.createElement(
	                'div',
	                { className: 'parentitem selected' },
	                React.createElement(
	                    'div',
	                    { key: '0', className: 'title' },
	                    React.createElement(
	                        'a',
	                        { href: '#', onClick: function onClick() {
	                                return _this5.selectNode(item);
	                            } },
	                        React.createElement(Truncate, { lines: 2, children: selectedText })
	                    )
	                ),
	                item.children.map(function (item, i) {
	                    if (item.type == 'TACTIC') return _this5.renderTacticNode(item, i + 1);else if (item.type == 'CATEGORY') return _this5.renderProductGroupNode(item, i + 1);else return _this5.renderProductNode(item, i + 1);
	                })
	            )
	        );
	    },

	    render: function render() {
	        var openNodes = [];
	        if (this.props.root == null) {
	            return React.createElement(
	                'div',
	                { className: 'drilldown' },
	                AppManager.getLabel('PP_LBL_NODATA') || 'No data'
	            );
	        }
	        var selectedParentNode = this.state.selectedNode.parent;
	        var ix = 1;
	        while (selectedParentNode != null) {
	            openNodes.unshift(this.renderParentOpenNode(selectedParentNode, ix++));
	            selectedParentNode = selectedParentNode.parent;
	        }
	        return React.createElement(
	            'div',
	            { className: 'drilldown slds-scrollable--y' },
	            openNodes,
	            this.renderSelectedNode(this.state.selectedNode, ix++)
	        );
	    }
		});

/***/ },

/***/ 634:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	module.exports = React.createClass({
	    displayName: "exports",

	    render: function render() {
	        var acl = this.props.object._acl;
	        var isVisible = true;
	        if (acl) isVisible = acl.isVisible(1, this.props.field);
	        return isVisible ? this.props.children : null;
	    }
		});

/***/ },

/***/ 635:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Tile = __webpack_require__(636);
	var ReactCSSTransitionGroup = __webpack_require__(620);
	var LineChart = __webpack_require__(637);
	var StackedChart = __webpack_require__(639);
	var HorizontalChart = __webpack_require__(640);
	var HorizontalBarChart = __webpack_require__(641);
	var ACLCheck = __webpack_require__(634);
	var PromotionAttachments = __webpack_require__(642);

	var PromotionPlanningPromotionEdit = __webpack_require__(646);
	var PromotionChildAccounts = __webpack_require__(648);

	module.exports = new React.createClass({
	    displayName: 'PromotionOverview',

	    propTypes: {
	        promotion: React.PropTypes.object, //Promotion details
	        editMode: React.PropTypes.bool, //Flag for showing Edit window
	        showAttachments: React.PropTypes.bool //Flag for showing Attachments
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-wrap tile-area' },
	            this.props.showAttachments ? React.createElement(
	                ReactCSSTransitionGroup,
	                { component: 'div',
	                    className: 'slds-size--1-of-1',
	                    transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                    transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                    transitionLeaveTimeout: 1500 },
	                React.createElement(PromotionAttachments, { promotion: this.props.promotion, editMode: this.props.editMode,
	                    editToggle: this.props.editToggle })
	            ) : null,
	            React.createElement(
	                ReactCSSTransitionGroup,
	                { component: 'div',
	                    className: 'slds-size--1-of-1',
	                    transitionName: {
	                        enter: "animated",
	                        enterActive: "flipInX",
	                        leave: "animated",
	                        leaveActive: "flipOutX"
	                    },
	                    transitionEnterTimeout: 500, transitionLeaveTimeout: 500 },
	                React.createElement(PromotionPlanningPromotionEdit, { ref: 'editPanel', promotion: this.props.promotion,
	                    update: this.props.update, editMode: this.props.editMode })
	            ),
	            this.props.promotion && this.props.promotion.ChildAccounts && this.props.promotion.ChildAccounts.length > 0 ? React.createElement(
	                ReactCSSTransitionGroup,
	                { component: 'div',
	                    className: 'slds-size--1-of-1',
	                    transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                    transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                    transitionLeaveTimeout: 1500 },
	                React.createElement(PromotionChildAccounts, { promotion: this.props.promotion, editMode: this.props.editMode,
	                    pushMode: this.props.pushMode, pushModeEnd: this.props.pushModeEnd })
	            ) : null,
	            React.createElement(
	                ACLCheck,
	                { object: this.props.promotion, field: 'AggregatedKPI' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-col--padded-right slds-col--padded-top slds-size--1-of-2' },
	                    React.createElement(
	                        ReactCSSTransitionGroup,
	                        { transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                            transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                            transitionLeaveTimeout: 1500 },
	                        React.createElement(
	                            Tile,
	                            { key: 'tile21', animated: true, invalid: this.props.promotion.isKPIInvalid },
	                            React.createElement(HorizontalChart, { title: AppManager.getLabel('PP_TIT_CHART_ROI') || 'ROI',
	                                formatter: Utils.Formatters.formatPct,
	                                positiveKPI: true,
	                                mainvalue: this.props.promotion.AggregatedKPIs.LROI,
	                                planned: this.props.promotion.AggregatedKPIs.PROI })
	                        )
	                    )
	                )
	            ),
	            React.createElement(
	                ACLCheck,
	                { object: this.props.promotion, field: 'AggregatedKPI' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-col--padded-top slds-size--1-of-2' },
	                    React.createElement(
	                        ReactCSSTransitionGroup,
	                        { transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                            transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                            transitionLeaveTimeout: 1500 },
	                        React.createElement(
	                            Tile,
	                            { key: 'tile31', animated: true, invalid: this.props.promotion.isKPIInvalid },
	                            React.createElement(HorizontalChart, { title: AppManager.getLabel('PP_TIT_CHART_COSTS') || 'COSTS',
	                                formatter: Utils.Formatters.formatCurrency,
	                                positiveKPI: false,
	                                mainvalue: this.props.promotion.AggregatedKPIs.LETP,
	                                planned: this.props.promotion.AggregatedKPIs.PTPC })
	                        )
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 636:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Icon = __webpack_require__(461).Icon;

	module.exports = React.createClass({
	    displayName: 'exports',

	    render: function render() {
	        var klass = 'tile ' + (this.props.animated ? 'animated ' : '') + (this.props.invalid ? 'invalid' : '');

	        return React.createElement(
	            'div',
	            { key: 'tile', className: klass },
	            this.props.invalid ? React.createElement(
	                'div',
	                { className: 'mask' },
	                React.createElement(Icon, { category: 'utility', icon: 'undo', size: 'x-medium', className: 'slds-align--absolute-center' })
	            ) : null,
	            this.props.children
	        );
	    }
		});

/***/ },

/***/ 637:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Chartist = __webpack_require__(638);

	module.exports = React.createClass({
	    displayName: 'exports',

	    componentDidMount: function componentDidMount() {
	        this.updateChart(this.props.data);
	    },

	    updateChart: function updateChart(data) {
	        var options = {
	            axisX: {
	                showLabel: true,
	                showGrid: false
	            },
	            showPoint: false,
	            lineSmooth: false,
	            fullWidth: true,
	            height: '245px',
	            chartPadding: {
	                top: 15,
	                right: 15,
	                bottom: 5,
	                left: 10
	            }
	        };

	        var chart = new Chartist.Line('.linechart', data, options);
	        chart.on('draw', function (data) {
	            if (data.type === 'line' || data.type === 'area') {
	                data.element.animate({
	                    d: {
	                        begin: 500 * data.index,
	                        dur: 1000,
	                        from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
	                        to: data.path.clone().stringify(),
	                        easing: Chartist.Svg.Easing.easeOutQuint
	                    }
	                });
	            }
	        });
	        return chart;
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            { className: 'chart-tile' },
	            React.createElement(
	                'div',
	                { className: 'title' },
	                this.props.title
	            ),
	            React.createElement('div', { className: 'linechart' }),
	            React.createElement(
	                'div',
	                { className: 'legend' },
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-a legend-box' }),
	                    this.props.data.legends[0]
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-b legend-box' }),
	                    this.props.data.legends[1]
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 639:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Chartist = __webpack_require__(638);

	module.exports = React.createClass({
	    displayName: 'exports',

	    componentDidMount: function componentDidMount() {
	        this.updateChart(this.props.data);
	    },

	    updateChart: function updateChart(data) {
	        var options = {
	            axisX: {
	                showLabel: true,
	                showGrid: false
	            },
	            showPoint: false,
	            lineSmooth: false,
	            fullWidth: true,
	            stackBars: true,
	            height: '245px',
	            chartPadding: {
	                top: 15,
	                right: 15,
	                bottom: 5,
	                left: 10
	            }
	        };
	        var chart = new Chartist.Bar('.stackedchart', data, options);

	        chart.on('draw', function (data) {
	            if (data.type === 'bar') {
	                data.element.animate({
	                    y2: {
	                        begin: 200 * data.index,
	                        dur: 1000,
	                        from: data.y1,
	                        to: data.y2,
	                        easing: Chartist.Svg.Easing.easeOutQuint
	                    }
	                });
	            }
	        });
	        return chart;
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            { className: 'chart-tile' },
	            React.createElement(
	                'div',
	                { className: 'title' },
	                this.props.title
	            ),
	            React.createElement('div', { className: 'stackedchart' }),
	            React.createElement(
	                'div',
	                { className: 'legend' },
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-a legend-box' }),
	                    this.props.data.legends[0]
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-b legend-box' }),
	                    this.props.data.legends[1]
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-c legend-box' }),
	                    this.props.data.legends[2]
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 640:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	module.exports = React.createClass({
	    displayName: "exports",

	    renderEmpty: function renderEmpty() {
	        return React.createElement(
	            "div",
	            { className: "chart-tile empty-chart" },
	            React.createElement(
	                "div",
	                { className: "title" },
	                this.props.title
	            ),
	            React.createElement(
	                "div",
	                { className: "main-value" },
	                this.props.formatter(0)
	            ),
	            React.createElement(
	                "div",
	                { className: "sub-value" },
	                this.props.formatter(0)
	            ),
	            React.createElement(
	                "div",
	                { className: "horizontal-chart" },
	                React.createElement(
	                    "div",
	                    { className: "back-chart" },
	                    "Sorry, no data available yet"
	                )
	            )
	        );
	    },
	    render: function render() {
	        if (this.props.mainvalue == null) return this.renderEmpty();

	        var classChart = "chart-tile";
	        var sign = this.props.positiveKPI ? '+' : '-';
	        var diff = Math.floor(Math.abs(this.props.mainvalue - this.props.planned) * 100) / 100;

	        var pctWidth = Math.abs((1 - diff / this.props.mainvalue) * 100);
	        var labelStyle = { left: pctWidth + '%', textAlign: 'right' };

	        if (pctWidth > 80) {
	            labelStyle = { left: 'auto', right: 0 };
	        }

	        if (pctWidth < 10) {
	            labelStyle = { left: '10%', textAlign: 'right' };
	        }

	        if (this.props.positiveKPI) {
	            //ROI
	            if (this.props.mainvalue < this.props.planned) {
	                //negative.aligning to the right
	                classChart += ' negative';
	                sign = this.props.positiveKPI ? '-' : '+';
	                labelStyle = { left: 'auto', right: 0 };
	            }
	        } else {
	            //COST
	            if (this.props.mainvalue > this.props.planned) {
	                //negative.aligning to the right
	                classChart += ' negative';
	                sign = this.props.positiveKPI ? '-' : '+';
	            } else {
	                //positive.align to the left side of the ROI bar
	                labelStyle = { left: 'auto', right: 0 };
	            }
	        }

	        return React.createElement(
	            "div",
	            { className: classChart },
	            React.createElement(
	                "div",
	                { className: "title" },
	                this.props.title
	            ),
	            React.createElement(
	                "div",
	                { className: "main-value" },
	                this.props.formatter(this.props.mainvalue)
	            ),
	            React.createElement(
	                "div",
	                { className: "sub-value" },
	                sign,
	                this.props.formatter(diff)
	            ),
	            React.createElement(
	                "div",
	                { className: "horizontal-chart" },
	                React.createElement("div", { className: "back-chart" }),
	                React.createElement("div", { className: "front-chart", style: { width: pctWidth + '%' } }),
	                React.createElement(
	                    "div",
	                    { className: "legend" },
	                    React.createElement(
	                        "span",
	                        { className: "val initial" },
	                        this.props.formatter(0)
	                    ),
	                    React.createElement(
	                        "span",
	                        { className: "val final",
	                            style: labelStyle },
	                        AppManager.getLabel('PP_LBL_PLANNED') || 'Planned',
	                        " ",
	                        this.props.formatter(this.props.planned)
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 641:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Chartist = __webpack_require__(638);

	module.exports = React.createClass({
	    displayName: 'exports',

	    componentDidMount: function componentDidMount() {
	        this.updateChart(this.props.data);
	    },

	    updateChart: function updateChart(data) {
	        var options = {
	            axisX: {
	                showLabel: true,
	                showGrid: true,
	                labelInterpolationFnc: function labelInterpolationFnc(value) {
	                    return '$' + value / 1000000 + 'M';
	                }
	            },
	            axisY: {
	                showLabel: true,
	                showGrid: true,
	                offset: 50
	            },
	            showPoint: false,
	            lineSmooth: false,
	            fullWidth: true,
	            stackBars: false,
	            horizontalBars: true,
	            height: '245px',
	            chartPadding: {
	                top: 15,
	                right: 15,
	                bottom: 5,
	                left: 10
	            }
	        };

	        var chart = new Chartist.Bar('.horizontalchart', data, options);
	        chart.on('draw', function (data) {
	            if (data.type === 'bar') {
	                data.element.animate({
	                    x2: {
	                        begin: 200 * data.index,
	                        dur: 1000,
	                        from: data.x1,
	                        to: data.x2,
	                        easing: Chartist.Svg.Easing.easeOutQuint
	                    }
	                });
	            }
	        });
	        return chart;
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            { className: 'chart-tile' },
	            React.createElement(
	                'div',
	                { className: 'title' },
	                this.props.title
	            ),
	            React.createElement('div', { className: 'horizontalchart' }),
	            React.createElement(
	                'div',
	                { className: 'legend' },
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-a legend-box' }),
	                    this.props.data.legends[0]
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-b legend-box' }),
	                    this.props.data.legends[1]
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'legendItem' },
	                    React.createElement('div', { className: 'ct-series-c legend-box' }),
	                    this.props.data.legends[2]
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 642:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Input = __webpack_require__(461).Input;
	var Icon = __webpack_require__(461).Icon;

	var PromotionActions = __webpack_require__(643).PromotionActions;

	var ImagePopup = __webpack_require__(644);
	var UploadPopup = __webpack_require__(645);
	var ConfirmPopup = __webpack_require__(614);

	module.exports = React.createClass({
	    displayName: 'PromotionAttachments',

	    getInitialState: function getInitialState() {
	        return {
	            selectedAttachment: null,
	            selectedAttachmentIndex: null,
	            onFileHoverClass: false,
	            newAttachment: this.getEmptyAttachment(),
	            modalOpen: false,
	            uploading: false,
	            confirmMessage: false,
	            attachments: this.getAttachments(this.props.promotion.attachments)
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        this.deactivateAttachments();
	    },

	    componentWillMount: function componentWillMount() {
	        this.selectAttachment(this.state.attachments[0]);
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(props) {
	        var _this = this;

	        var state = {
	            attachments: this.getAttachments(props.promotion.attachments)
	        };
	        this.setState(state);
	        if (this.state.newAttachment.file) {
	            var i = _.findIndex(state.attachments, function (att) {
	                return att.Name == _this.state.newAttachment.file.name;
	            } /* && ... */
	            );
	            if (i != -1) {
	                this.selectAttachment(state.attachments[i]);
	                this.setState({
	                    newAttachment: this.getEmptyAttachment()
	                });
	            } else this.selectAttachment(state.attachments[0]);
	        } else this.selectAttachment(state.attachments[0]);
	    },

	    getEmptyAttachment: function getEmptyAttachment() {
	        return {
	            previewUrl: null,
	            attachmentUrl: null,
	            Description_Language_1__c: '',
	            Type__c: '',
	            Size__c: 0,
	            Name: null,
	            CreatedDate: new Date(),
	            LastModifiedDate: new Date()
	        };
	    },

	    getAttachments: function getAttachments(attachments) {
	        return attachments.map(function (att) {
	            att = Object.create(att, { _model: { value: att } });
	            if (typeof localVF !== 'undefined') {
	                if (att.attachmentUrl) att.attachmentUrl = 'https://' + VF_REMOTING_HOST + att.attachmentUrl;
	                if (att.previewUrl) att.previewUrl = 'https://' + VF_REMOTING_HOST + att.previewUrl;
	            }
	            return att;
	        });
	    },

	    isReadable: function isReadable(attachment) {
	        var isReadable = true;
	        try {
	            new FileReader().readAsBinaryString(attachment.slice(0, 5));
	        } catch (e) {
	            isReadable = false;
	        }
	        return isReadable;
	    },

	    onFileSelection: function onFileSelection(event) {
	        event.stopPropagation();
	        event.preventDefault();
	        var files = event.target.files || event.dataTransfer.files;

	        if (files.length < 2 && this.isReadable(files[0])) {
	            if (files[0].name.length <= 80) {
	                if (files[0].size > 0 && files[0].size < 26214400) {

	                    this.setState({
	                        newAttachment: _.assign(this.state.newAttachment, {
	                            file: files[0],
	                            Type__c: files[0].type,
	                            Name: files[0].name,
	                            Size__c: files[0].size,
	                            Description_Language_1__c: files[0].name,
	                            Description_Language_2__c: files[0].name,
	                            Description_Language_3__c: files[0].name,
	                            Description_Language_4__c: files[0].name
	                        }),
	                        onFileHoverClass: false
	                    });

	                    this.openUploadModal();
	                } else {
	                    UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                        title: AppManager.getLabel("PP_TIT_UPLOAD_ATTACHMENT_ERROR") || 'Upload Error',
	                        message: AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENT_SIZE_ERROR") || 'File incorrect size. The attachment has to be less than 25MB.',
	                        type: 'E'
	                    });
	                }
	            } else {
	                UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                    title: AppManager.getLabel("PP_TIT_UPLOAD_ATTACHMENT_ERROR") || 'Upload Error',
	                    message: AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENT_FILENAME_SIZE_ERROR") || 'The filename is too long (max. 80 chars)',
	                    type: 'E'
	                });
	            }
	        } else {
	            UI_EVENT_BUS.put(EVENTS.UI_ERROR, {
	                title: AppManager.getLabel("PP_TIT_UPLOAD_ATTACHMENT_ERROR") || 'Upload Error',
	                message: AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENT_NUMBER_OF_FILES_ERROR") || 'Only one file allowed per upload',
	                type: 'E'
	            });
	        }

	        if (event.target.files) event.target.value = '';
	    },

	    onFileLeave: function onFileLeave() {
	        this.setState({ onFileHoverClass: false });
	    },

	    onFileHover: function onFileHover(event) {
	        event.stopPropagation();
	        event.preventDefault();
	        var itemKind = event.dataTransfer.items[0].kind;
	        if (itemKind == 'file') {
	            this.setState({ onFileHoverClass: true });
	        }
	    },

	    deactivateAttachments: function deactivateAttachments() {
	        for (var i = 0; i < this.state.attachments.length; ++i) {
	            this.state.attachments[i].active = false;
	        }
	    },

	    selectAttachment: function selectAttachment(attachment) {
	        this.deactivateAttachments();
	        if (attachment) attachment.active = true;
	        this.setState({ selectedAttachment: attachment });
	    },

	    openAttachment: function openAttachment(attachment) {
	        window.open(attachment.attachmentUrl);
	    },

	    renderOpenAttachment: function renderOpenAttachment(attachment, index) {
	        if (attachment.Type__c.indexOf('image') != -1) {
	            this.setState({
	                modalOpen: true,
	                selectedAttachment: attachment,
	                selectedAttachmentIndex: index
	            });
	        } else {
	            this.setState({ modalOpen: false });
	            window.open(attachment.attachmentUrl);
	        }
	    },

	    closeImagesModal: function closeImagesModal() {
	        this.setState({ modalOpen: false });
	    },

	    getFileIcon: function getFileIcon(file) {
	        var icon = "unknown",
	            mimeType = file.Type__c,
	            fileExt = file.Name.split('.').pop(),
	            type = mimeType.split('/')[0],
	            subtype = mimeType.split('/')[1];
	        if (fileExt && _.indexOf(['exe', 'csv', 'zip', 'ai', 'eps'], fileExt) != -1) {
	            icon = fileExt;
	        } else if (subtype && _.indexOf(['pdf', 'xml', 'rtf', 'html'], subtype) != -1) {
	            icon = subtype;
	        } else if (subtype && (subtype.indexOf('psd') != -1 || subtype.indexOf('photoshop') != -1)) {
	            icon = "psd";
	        } else if (subtype && (subtype.indexOf('ms-msword') != -1 || subtype.indexOf('wordprocessingml') != -1)) {
	            icon = "word";
	        } else if (subtype && (subtype.indexOf('ms-powerpoint') != -1 || subtype.indexOf('presentationml') != -1)) {
	            icon = "ppt";
	        } else if (subtype && (subtype.indexOf('ms-excel') != -1 || subtype.indexOf('spreadsheetml') != -1)) {
	            icon = "excel";
	        } else if (type && _.indexOf(['image', 'video', 'audio'], type) != -1) {
	            icon = type;
	        } else if (type == "text") {
	            icon = "txt";
	        }
	        return icon;
	    },

	    deleteAttachment: function deleteAttachment(attachmentID) {
	        var me = this;
	        var confirmMessage = {
	            title: AppManager.getLabel("PP_TIT_CONFIRMATION") || 'Confirmation',
	            message: AppManager.getLabel("PP_LBL_CONFIRMATION_DELETE_ATTACHMENT") || 'Do you want to delete selected attachment?',
	            cancelHandler: function cancelHandler() {
	                me.setState({ confirmMessage: null });
	            },
	            okHandler: function okHandler() {
	                me.setState({ confirmMessage: null });
	                PromotionActions.deleteAttachment(attachmentID);
	            }
	        };
	        this.setState({ confirmMessage: confirmMessage });
	    },

	    openUploadModal: function openUploadModal() {
	        this.setState({ uploading: true });
	    },

	    closeUploadModal: function closeUploadModal() {
	        this.setState({ uploading: false });
	    },

	    renderPreview: function renderPreview() {
	        var _this2 = this;

	        var attachment = this.state.selectedAttachment ? this.state.selectedAttachment : this.state.attachments[0];
	        var previewThumbnail = null;
	        if (attachment) {
	            if (attachment.previewUrl && (attachment.Type__c.indexOf('image') == 0 || attachment.Type__c.indexOf('video') == 0)) {
	                previewThumbnail = React.createElement('a', { onClick: function onClick(event) {
	                        event.preventDefault();
	                    },
	                    href: attachment.attachmentUrl,
	                    className: 'ui-previewThumbnail',
	                    style: { backgroundImage: 'url(\'' + attachment.previewUrl + '\')' } });
	            } else {
	                previewThumbnail = React.createElement(Icon, { style: { width: '150px', height: '150px' }, icon: this.getFileIcon(attachment),
	                    category: 'doctype' });
	            }

	            return React.createElement(
	                'div',
	                { className: 'tile tile--responsive' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid slds-wrap' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-3 tile-item__borderBottom' },
	                        this.renderEditList()
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs slds-col--no-padded slds-grid--vertical-align-center slds-grid--align-center' },
	                        previewThumbnail
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'ui-attachment-edit__description slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid slds-p-bottom--medium' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right--small slds-size--1-of-2' },
	                                React.createElement(Input, { label: AppManager.getLabel("PP_LBL_NAME_ATTACHMENT") || 'Name',
	                                    disabled: 'true',
	                                    type: 'text',
	                                    placeholder: AppManager.getLabel("PP_LBL_NAME_ATTACHMENT") || 'Name',
	                                    onClick: function onClick(e) {
	                                        return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                                    },
	                                    value: attachment.Name,
	                                    readOnly: 'true' })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-left--small slds-size--1-of-2' },
	                                React.createElement(Input, { label: AppManager.getLabel("PP_LBL_SIZE_ATTACHMENT") || 'Size',
	                                    disabled: 'true',
	                                    type: 'text',
	                                    placeholder: AppManager.getLabel("PP_LBL_SIZE_ATTACHMENT") || 'Size',
	                                    onClick: function onClick(e) {
	                                        return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                                    },
	                                    value: attachment.Size__c })
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-p-bottom--medium' },
	                            React.createElement(Input, { label: AppManager.getLabel("PP_LBL_DESCRIPTION_ATTACHMENT") || 'Description',
	                                type: 'text',
	                                placeholder: AppManager.getLabel("PP_LBL_DESCRIPTION_ATTACHMENT") || 'Description',
	                                onClick: function onClick(e) {
	                                    return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                                },
	                                onChange: function onChange(e, value) {
	                                    attachment._model.setDescription_Language_1__c(value);
	                                    _this2.setState({});
	                                },
	                                value: attachment.Description_Language_1__c })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right--small slds-size--1-of-2' },
	                                React.createElement(Input, {
	                                    label: AppManager.getLabel("PP_LBL_CREATION_DATE_ATTACHMENT") || 'Creation Date',
	                                    type: 'text', disabled: 'true',
	                                    value: Utils.Converters.TS2Date(attachment.CreatedDate, 'YYYY-MM-DD') })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-left--small slds-size--1-of-2' },
	                                React.createElement(Input, {
	                                    label: AppManager.getLabel("PP_LBL_LAST_UPDATE_DATE_ATTACHMENT") || 'Last Update Date',
	                                    type: 'text', disabled: 'true',
	                                    value: Utils.Converters.TS2Date(attachment.LastModifiedDate, 'YYYY-MM-DD') })
	                            )
	                        )
	                    )
	                )
	            );
	        } else {
	            return null;
	        }
	    },

	    renderEditList: function renderEditList() {
	        var _this3 = this;

	        return React.createElement(
	            'ul',
	            { className: 'ui-attachment-edit__fileList slds-has-dividers--bottom slds-scrollable--y' },
	            this.state.attachments.map(function (file) {
	                return React.createElement(
	                    'li',
	                    { ref: function ref(li) {
	                            return li && file.active && li.scrollIntoViewIfNeeded ? li.scrollIntoViewIfNeeded() : null;
	                        },
	                        onClick: function onClick() {
	                            return _this3.selectAttachment(file);
	                        },
	                        className: 'ui-attachment-edit__fileItems slds-item ' + (file.active ? "is-Selected" : "") },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-p-around--x-small slds-grid--vertical-align-center' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col slds-truncate' },
	                            React.createElement(Icon, { icon: _this3.getFileIcon(file), className: 'ui-icon__attachment',
	                                category: 'doctype' }),
	                            React.createElement(
	                                'span',
	                                { className: 'slds-m-left--small' },
	                                ' ',
	                                file.Name,
	                                ' '
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--bump-left' },
	                            React.createElement(Icon, { icon: 'delete', className: 'ui-icon__attachment ui-icon__attachment--deleted',
	                                category: 'utility',
	                                onClick: function onClick() {
	                                    return _this3.deleteAttachment(file.Id);
	                                } })
	                        )
	                    )
	                );
	            })
	        );
	    },

	    renderEdit: function renderEdit() {
	        var _this4 = this;

	        return React.createElement(
	            'div',
	            { className: 'ui-attachments__edit' },
	            React.createElement(
	                'div',
	                { className: 'ui-attachments__add-box slds-align--absolute-center ' + (this.state.onFileHoverClass ? "is-Hover" : ""),
	                    onDragOver: this.onFileHover, onDragLeave: this.onFileLeave, onDrop: this.onFileSelection },
	                AppManager.getLabel("PP_LBL_DRAG_ATTACHMENTS") || 'Drag attachments here or',
	                React.createElement(
	                    'a',
	                    { className: 'slds-m-left--x-small' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-file-selector slds-file-selector--files' },
	                        React.createElement('input', { className: 'slds-file-selector__input slds-assistive-text', accept: '*/*', type: 'file',
	                            id: 'file-upload-input-01', 'aria-describedby': 'file-selector-id',
	                            onChange: this.onFileSelection }),
	                        React.createElement(
	                            'label',
	                            { className: 'ui-file-selector__text slds-text-link', htmlFor: 'file-upload-input-01' },
	                            AppManager.getLabel("PP_LBL_UPLOAD_ATTACHMENTS") || 'Upload Files'
	                        )
	                    )
	                )
	            ),
	            this.renderPreview(),
	            this.state.uploading ? React.createElement(UploadPopup, { title: AppManager.getLabel("PP_LBL_UPLOADING_ATTACHMENTS") || 'Uploading...',
	                onClose: function onClose() {
	                    return _this4.closeUploadModal();
	                },
	                file: this.state.newAttachment, fileIcon: this.getFileIcon(this.state.newAttachment) }) : null
	        );
	    },

	    renderView: function renderView() {
	        var _this5 = this;

	        var images = _.filter(this.state.attachments, function (item) {
	            return item.Type__c.indexOf('image') != -1;
	        });
	        var videos = _.filter(this.state.attachments, function (item) {
	            return item.Type__c.indexOf('video') != -1;
	        });
	        var files = _.difference(this.state.attachments, _.concat(images, videos));

	        return React.createElement(
	            'div',
	            { className: 'ui-attachments__view' },
	            this.state.attachments.length ? React.createElement(
	                'div',
	                { className: 'slds-grid slds-wrap' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3' },
	                    React.createElement(
	                        'div',
	                        { className: 'ui-attachment__title slds-text-heading--small slds-m-bottom--small' },
	                        React.createElement(Icon, { icon: 'image',
	                            category: 'utility' }),
	                        ' ',
	                        AppManager.getLabel("PP_LBL_IMAGES_ATTACHMENTS") || 'Images'
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'ui-attachment__list slds-grid slds-wrap' },
	                        images.map(function (image, i) {
	                            return React.createElement(
	                                'a',
	                                { onClick: function onClick(event) {
	                                        event.preventDefault();
	                                    },
	                                    href: image.attachmentUrl,
	                                    className: 'ui-attachment__listItem slds-grid--vertical-align-center' },
	                                image.previewUrl && image.previewUrl.length > 1 ? React.createElement(
	                                    'div',
	                                    { onClick: function onClick() {
	                                            return _this5.renderOpenAttachment(image, i);
	                                        },
	                                        style: { backgroundImage: 'url(\'' + image.previewUrl + '\')' },
	                                        className: 'ui-attachment__listThumbnail' },
	                                    React.createElement(
	                                        'span',
	                                        { className: 'ui-overlay' },
	                                        React.createElement(Icon, { icon: 'search', category: 'utility' })
	                                    )
	                                ) :
	                                //Show Icon as we don't have a thumbnail.
	                                React.createElement(
	                                    'div',
	                                    { className: 'ui-attachment__listThumbnail',
	                                        onClick: function onClick() {
	                                            return _this5.renderOpenAttachment(image, i);
	                                        } },
	                                    React.createElement(
	                                        'span',
	                                        null,
	                                        React.createElement(Icon, { icon: 'photo', category: 'utility' })
	                                    ),
	                                    React.createElement(
	                                        'span',
	                                        { className: 'ui-overlay' },
	                                        React.createElement(Icon, { icon: 'search', category: 'utility' })
	                                    )
	                                )
	                            );
	                        }),
	                        images.length % 3 == 1 || images.length % 3 == 2 ? React.createElement('div', { className: 'slds-col--padded-right slds-size--1-of-3' }) : null,
	                        images.length % 3 == 1 ? React.createElement('div', { className: 'slds-col--padded-right slds-size--1-of-3' }) : null
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs' },
	                    React.createElement(
	                        'div',
	                        { className: 'ui-attachment__title slds-text-heading--small slds-m-bottom--small' },
	                        React.createElement(Icon, { icon: 'video',
	                            category: 'utility' }),
	                        ' ',
	                        AppManager.getLabel("PP_LBL_VIDEOS_ATTACHMENTS") || 'Videos'
	                    ),
	                    React.createElement(
	                        'ul',
	                        { className: 'slds-has-dividers--bottom' },
	                        videos.map(function (video) {
	                            return React.createElement(
	                                'li',
	                                { onClick: function onClick() {
	                                        return _this5.openAttachment(video);
	                                    },
	                                    className: 'slds-grid slds-grid--vertical-align-center slds-m-bottom--small slds-p-bottom--x-small slds-item' },
	                                React.createElement(
	                                    'div',
	                                    { className: 'ui-previewThumbnail-wrapper' },
	                                    video.previewUrl && video.previewUrl.length > 1 ? React.createElement('div', { className: 'ui-previewThumbnail ui-previewThumbnail--video',
	                                        style: { backgroundImage: 'url(\'' + video.previewUrl + '\')' } }) : React.createElement(Icon, { icon: 'video', category: 'doctype',
	                                        className: 'slds-icon slds-icon-text-default ui-icon__attachment' })
	                                ),
	                                React.createElement(
	                                    'span',
	                                    { className: 'slds-link slds-truncate' },
	                                    ' ',
	                                    video.Name,
	                                    ' '
	                                )
	                            );
	                        })
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    {
	                        className: 'ui-attachment-file slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs slds-col--no-padded' },
	                    React.createElement(
	                        'div',
	                        { className: 'ui-attachment__title slds-text-heading--small slds-m-bottom--small' },
	                        React.createElement(Icon, { icon: 'file',
	                            category: 'utility' }),
	                        ' ',
	                        AppManager.getLabel("PP_LBL_FILES_ATTACHMENTS") || 'Files'
	                    ),
	                    React.createElement(
	                        'ul',
	                        { className: 'ui-attachment-file__list slds-has-dividers--bottom' },
	                        files.map(function (file) {
	                            return React.createElement(
	                                'li',
	                                { onClick: function onClick() {
	                                        return _this5.openAttachment(file);
	                                    },
	                                    className: 'ui-attachment-file__listItem slds-grid slds-grid--vertical-align-center slds-m-bottom--small slds-p-bottom--x-small slds-item' },
	                                React.createElement(
	                                    'div',
	                                    { className: 'ui-icon__wrapper' },
	                                    React.createElement(Icon, { icon: _this5.getFileIcon(file), category: 'doctype',
	                                        className: 'ui-icon__attachment' })
	                                ),
	                                React.createElement(
	                                    'span',
	                                    { className: 'ui-attachment-file__listName slds-link slds-truncate' },
	                                    ' ',
	                                    file.Name,
	                                    ' '
	                                )
	                            );
	                        })
	                    )
	                )
	            ) : React.createElement(
	                'div',
	                { className: 'slds-grid slds-wrap' },
	                React.createElement(
	                    'div',
	                    { className: 'ui-attachments__edit-box slds-align--absolute-center' },
	                    AppManager.getLabel("PP_LBL_NO_ATTACHMENTS_UPLOADED_1") || 'No Attachments uploaded, yet. Switch to the',
	                    React.createElement(
	                        'label',
	                        { className: 'ui-file-selector__text slds-p-left--xx-small slds-p-right--xx-small slds-text-link',
	                            onClick: function onClick() {
	                                return _this5.props.editToggle();
	                            } },
	                        AppManager.getLabel("PP_LBL_EDIT_MODE_ATTACHMENTS") || 'Edit Mode'
	                    ),
	                    AppManager.getLabel("PP_LBL_NO_ATTACHMENTS_UPLOADED_2") || 'to Upload some Files.'
	                )
	            )
	        );
	    },

	    renderSpinner: function renderSpinner() {
	        return React.createElement(
	            'div',
	            { className: 'ui-spinner_container' },
	            React.createElement(
	                'div',
	                { className: 'slds-spinner--brand slds-spinner slds-spinner--large', 'aria-hidden': 'false', role: 'alert' },
	                React.createElement('div', { className: 'slds-spinner__dot-a' }),
	                React.createElement('div', { className: 'slds-spinner__dot-b' })
	            )
	        );
	    },

	    render: function render() {
	        var _this6 = this;

	        var images = _.filter(this.state.attachments, function (item) {
	            return item.Type__c.indexOf('image') != -1;
	        });

	        return React.createElement(
	            'div',
	            { className: 'tile tile--responsive slds-m-bottom--medium animated' },
	            React.createElement(
	                'div',
	                { className: 'title slds-grid' },
	                React.createElement(
	                    'label',
	                    null,
	                    AppManager.getLabel("PP_TIT_ATTACHMENTS") || 'Attachments'
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'ui-attachments slds-grid slds-grid--vertical-align-center slds-grid--align-center',
	                    key: 'attachments' },
	                this.props.promotion.loadPhase == 'preload' ? this.renderSpinner() : this.props.editMode ? this.renderEdit() : this.renderView()
	            ),
	            this.state.confirmMessage ? React.createElement(ConfirmPopup, { title: this.state.confirmMessage.title,
	                message: this.state.confirmMessage.message,
	                cancelHandler: this.state.confirmMessage.cancelHandler,
	                okHandler: this.state.confirmMessage.okHandler }) : null,
	            this.state.modalOpen ? React.createElement(ImagePopup, { onClose: function onClose() {
	                    return _this6.closeImagesModal();
	                },
	                images: images, selectedImage: this.state.selectedAttachment,
	                selectedImageIndex: this.state.selectedAttachmentIndex }) : null
	        );
	    }
		});

/***/ },

/***/ 643:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	global._ = __webpack_require__(202);
	_.mixin({ keyMirror: __webpack_require__(608) });

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

	    load: function load(payload) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PROMOTION_LOAD,
	            payload: payload
	        });
	    },

	    loadPromotionGrid: function loadPromotionGrid(promotionId, Manual_Calculation_Input) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PROMOTION_LOAD_GRID,
	            payload: { Id: promotionId, Manual_Calculation_Input: Manual_Calculation_Input }
	        });
	    },

	    save: function save(id) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PROMOTION_SAVE,
	            payload: { Id: id }
	        });
	    },

	    saveAndRefresh: function saveAndRefresh(id) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PROMOTION_SAVE_AND_REFRESH,
	            payload: { Id: id }
	        });
	    },

	    cancelEdit: function cancelEdit(id, context) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PROMOTION_CANCEL,
	            payload: { Id: id, Context: context }
	        });
	    },

	    setPromotionField: function setPromotionField(id, fieldName, fieldValue) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PROMOTION_SET_FIELD,
	            payload: { Id: id, fieldName: fieldName, fieldValue: fieldValue }
	        });
	    },

	    selectPromotion: function selectPromotion() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TACTIC_SELECTED,
	            payload: null
	        });
	    },

	    selectTactic: function selectTactic(id) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TACTIC_SELECTED,
	            payload: { Id: id }
	        });
	    },

	    setTacticField: function setTacticField(id, fieldName, fieldValue) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TACTIC_SET_FIELD,
	            payload: { Id: id, fieldName: fieldName, fieldValue: fieldValue }
	        });
	    },

	    addTactic: function addTactic(tacticTemplate) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TACTIC_ADD,
	            payload: tacticTemplate
	        });
	    },

	    duplicateTactic: function duplicateTactic(tacticId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TACTIC_DUPLICATE,
	            payload: tacticId
	        });
	    },

	    deleteTactic: function deleteTactic(tacticId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TACTIC_DELETE,
	            payload: tacticId
	        });
	    },

	    applyProductFilter: function applyProductFilter(tacticId, productFilter) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.APPLY_PRODUCT_FILTER,
	            payload: { tacticId: tacticId, productFilter: productFilter }
	        });
	    },

	    searchForProducts: function searchForProducts(productSample) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.SEARCH_FOR_PRODUCTS,
	            payload: productSample
	        });
	    },

	    clearSearchForProducts: function clearSearchForProducts() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.CLEAR_SEARCH_FOR_PRODUCTS,
	            payload: null
	        });
	    },

	    addProducts: function addProducts(products, tacticID) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.ADD_PRODUCTS,
	            payload: { tacticId: tacticID, products: products }
	        });
	    },

	    changeTacticProductRelationship: function changeTacticProductRelationship(productID, tacticID, relationship) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.CHANGE_TACTIC_PRODUCT_RELATIONSHIP,
	            payload: { tacticId: tacticID, productId: productID, relationship: relationship }
	        });
	    },
	    toggleTacticProductFilter: function toggleTacticProductFilter(filterID, filterValue, tacticObj, bselected) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TOGGLE_TACTIC_PRODUCT_FILTER,
	            payload: { filterId: filterID, filterValueId: filterValue, tactic: tacticObj, selected: bselected }
	        });
	    },


	    searchForFunds: function searchForFunds() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.SEARCH_FOR_FUNDS,
	            payload: null
	        });
	    },

	    addFunds: function addFunds(funds, tacticID) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.ADD_FUNDS,
	            payload: { tacticId: tacticID, funds: funds }
	        });
	    },

	    deleteFunds: function deleteFunds(fundsId, tacticID) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.DELETE_FUNDS,
	            payload: { tacticId: tacticID, fundsId: fundsId }
	        });
	    },

	    validateFunds: function validateFunds(funds, tacticID) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.VALIDATE_FUNDS,
	            payload: { tacticId: tacticID, funds: funds }
	        });
	    },

	    //Workflow Function call
	    changeWfState: function changeWfState(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.CHANGE_WF_STATE,
	            payload: { wfstate: value }
	        });
	    },

	    //Copy Promotion Lift
	    copyLiftToTactics: function copyLiftToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_LIFT_TO_TACTICS,
	            payload: { lift: value }
	        });
	    },

	    uploadAttachment: function uploadAttachment(attachment, uploadId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.UPLOAD_ATTACHMENT,
	            payload: { attachment: attachment, uploadId: uploadId }
	        });
	    },

	    cancelUpload: function cancelUpload(uploadId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.CANCEL_UPLOAD,
	            payload: { uploadId: uploadId }
	        });
	    },

	    deleteAttachment: function deleteAttachment(attachmentId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.ATTACHMENT_DELETE,
	            payload: attachmentId
	        });
	    },

	    pushChildAccount: function pushChildAccount(uploadId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.PUSH_CHILD_ACCOUNT,
	            payload: { uploadId: uploadId }
	        });
	    },

	    finalizePushChildAccounts: function finalizePushChildAccounts(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.FINALIZE_PUSH_CHILD_ACCOUNTS,
	            payload: { promotionId: promotionId }
	        });
	    },

	    toggleChildAccount: function toggleChildAccount(childAccountId, included) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TOGGLE_CHILD_ACCOUNT,
	            payload: { ChildAccountID: childAccountId, Included: included }
	        });
	    },

	    toggleAllChildAccounts: function toggleAllChildAccounts(childAccounts, included) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.TOGGLE_ALL_CHILD_ACCOUNTS,
	            payload: { ChildAccounts: childAccounts, Included: included }
	        });
	    },

	    updateEnablePush: function updateEnablePush() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.UPDATE_ENABLE_PUSH,
	            payload: {}
	        });
	    },

	    validateTacticTiers: function validateTacticTiers(tacticTiers, tacticId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.VALIDATE_TACTIC_TIERS,
	            payload: { TacticTiers: tacticTiers, TacticId: tacticId }
	        });
	    },

	    openPromotion: function openPromotion(promotionId) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromCalendarActionConstants.OPEN_PROMOTION,
	            payload: promotionId
	        });
	    },

	    //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
	    copyDateFromToTactics: function copyDateFromToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_DATEFROM_TO_TACTICS,
	            payload: { date: value }
	        });
	    },

	    copyDateThruToTactics: function copyDateThruToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_DATETHRU_TO_TACTICS,
	            payload: { date: value }
	        });
	    },

	    copyDeliveryDateFromToTactics: function copyDeliveryDateFromToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATEFROM_TO_TACTICS,
	            payload: { date: value }
	        });
	    },

	    copyDeliveryDateThruToTactics: function copyDeliveryDateThruToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_SHIPMENTDATETHRU_TO_TACTICS,
	            payload: { date: value }
	        });
	    },

	    copyInstoreDateFromToTactics: function copyInstoreDateFromToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_INSTOREDATEFROM_TO_TACTICS,
	            payload: { date: value }
	        });
	    },

	    copyInstoreDateThruToTactics: function copyInstoreDateThruToTactics(value) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.COPY_PROMOTION_INSTOREDATETHRU_TO_TACTICS,
	            payload: { date: value }
	        });
	    },
	    //PMA - END CODE - 2017-01-12 - Copy date from Promotion to Tactic

	    //PMA - START CODE - 2017-01-13 - Threshold button
	    invokeThreshold: function invokeThreshold(objectid, prmobj) {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.BTN_INVOKETHRESHOLD,
	            payload: { objectid: objectid, prmobj: prmobj }
	        });
	    },
	    //PMA - END CODE - 2017-01-13 - Threshold button

	    invokeAuditTrail: function invokeAuditTrail() {
	        UI_EVENT_BUS.put(EVENTS.FLUX, {
	            actionType: PromotionActionConstants.BTN_INVOKEAUDITTRAIL,
	            payload: null
	        });
	    }

	};

	module.exports.PromotionActions = PromotionActions;
	module.exports.PromotionActionConstants = PromotionActionConstants;
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 644:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var Modal = __webpack_require__(461).Modal;
	var Icon = __webpack_require__(461).Icon;

	var Header = Modal.Header,
	    Content = Modal.Content,
	    Footer = Modal.Footer;


	module.exports = React.createClass({
	    displayName: 'ImagePopup',

	    getInitialState: function getInitialState() {
	        return {
	            selectedImage: this.props.selectedImage,
	            selectedImageIndex: this.props.selectedImageIndex,
	            images: this.props.images
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        var images = this.state.images;
	        for (var i = 0, len = images.length; i < len; ++i) {
	            images[i].active = false;
	        }
	        images[this.state.selectedImageIndex].active = true;
	        this.setState({ images: images });
	        document.body.classList.add('no-scroll');
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(props) {
	        this.setState({ selectedImage: props.selectedImage });
	    },

	    changeImage: function changeImage(image, index, event) {
	        var images = this.state.images;
	        event.preventDefault();
	        for (var i = 0, len = images.length; i < len; ++i) {
	            images[i].active = false;
	        }
	        images[index].active = true;
	        this.setState({ selectedImage: image, images: images });
	    },

	    getWidthCarouselList: function getWidthCarouselList() {
	        if (this.refs.carouselList) {
	            var carouselListItem = this.refs.carouselList,
	                nodes = carouselListItem.querySelectorAll('.ui-modal-carousel__listItem'),
	                carouselListWidth = 0;
	            for (var i = 0; nodes[i]; i++) {
	                carouselListWidth += nodes[i].clientWidth + 6;
	            }
	        }
	        return carouselListWidth;
	    },

	    closeModal: function closeModal() {
	        this.props.onClose();
	        document.body.classList.remove('no-scroll');
	    },

	    render: function render() {
	        var _this = this;

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                Modal,
	                { opened: true, onHide: function onHide() {
	                        return _this.closeModal();
	                    }, className: 'ui-modal-carousel' },
	                React.createElement(Header, { title: this.state.selectedImage.Name, closeButton: true }),
	                React.createElement(
	                    Content,
	                    { className: 'ui-modal-carousel__container' },
	                    React.createElement('a', { onClick: function onClick(event) {
	                            event.preventDefault();
	                        },
	                        href: this.state.selectedImage.attachmentUrl,
	                        className: 'ui-modal-carousel__picture slds-grid slds-grid--vertical-align-center',
	                        style: { backgroundImage: 'url(\'' + this.state.selectedImage.attachmentUrl + '\')' } }),
	                    React.createElement(
	                        'div',
	                        { className: 'ui-modal-carousel__content slds-scrollable--x' },
	                        React.createElement(
	                            'ul',
	                            { className: 'ui-modal-carousel__list', ref: 'carouselList',
	                                style: { 'width': this.getWidthCarouselList() } },
	                            this.props.images.map(function (image, i) {
	                                return React.createElement(
	                                    'li',
	                                    { ref: function ref(li) {
	                                            return li && image.active && li.scrollIntoViewIfNeeded ? li.scrollIntoViewIfNeeded() : null;
	                                        },
	                                        className: 'ui-modal-carousel__listItem' },
	                                    React.createElement(
	                                        'a',
	                                        { onClick: function onClick(event) {
	                                                return _this.changeImage(image, i, event);
	                                            },
	                                            href: image.attachmentUrl,
	                                            style: image.previewUrl && image.previewUrl.length > 1 ? { backgroundImage: 'url(\'' + image.previewUrl + '\')' } : {},
	                                            className: 'ui-modal-carousel__thumbnail ' + (image.active ? "is-Selected" : "") },
	                                        image.previewUrl && image.previewUrl.length > 1 ? null : React.createElement(Icon, { icon: 'photo', category: 'utility' })
	                                    )
	                                );
	                            })
	                        )
	                    )
	                ),
	                React.createElement(
	                    Footer,
	                    { className: 'slds-modal__footer--white' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-wrap ui-modal-carousel__info' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-size--1-of-1 slds-p-bottom--x-small' },
	                            React.createElement(
	                                'p',
	                                { className: 'ui-modal-carousel__infoLabel slds-form-element__label' },
	                                AppManager.getLabel('PP_LBL_IMAGE_DESCRIPTION') || 'Description'
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'ui-modal-carousel__infoInput slds-truncate' },
	                                this.state.selectedImage.Description_Language_1__c
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-size--1-of-2 slds-col--padded-right--small' },
	                            React.createElement(
	                                'p',
	                                { className: 'ui-modal-carousel__infoLabel slds-form-element__label' },
	                                AppManager.getLabel('PP_LBL_IMAGE_CREATION_DATE') || 'Creation Date'
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'ui-modal-carousel__infoInput' },
	                                Utils.Formatters.formatDate(this.state.selectedImage.CreatedDate)
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-size--1-of-2 slds-col--padded-left--small' },
	                            React.createElement(
	                                'p',
	                                { className: 'ui-modal-carousel__infoLabel slds-form-element__label' },
	                                AppManager.getLabel('PP_LBL_IMAGE_LAST_UPDATE') || 'Last Update'
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'ui-modal-carousel__infoInput' },
	                                Utils.Formatters.formatDate(this.state.selectedImage.LastModifiedDate)
	                            )
	                        )
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 645:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	var React = __webpack_require__(283);

	var Modal = __webpack_require__(461).Modal;
	var Icon = __webpack_require__(461).Icon;

	var PromotionActions = __webpack_require__(643).PromotionActions;

	var Header = Modal.Header,
	    Content = Modal.Content,
	    _global = global,
	    UI_EVENT_BUS = _global.UI_EVENT_BUS;


	module.exports = React.createClass({
	    displayName: 'UploadPopup',

	    getInitialState: function getInitialState() {
	        return {
	            progress: 0
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        var _this = this;

	        var uploadId = Utils.guid();

	        this._subscription = UI_EVENT_BUS.subscribe(uploadId, function (progress) {
	            _this.setState({
	                progress: (progress * 100).toFixed(3)
	            });
	            if (progress == 1) {
	                _this.props.onClose();
	                document.body.classList.remove('no-scroll');
	            }
	        });

	        this._uploadId = uploadId;
	        PromotionActions.uploadAttachment(this.props.file, uploadId);
	        document.body.classList.add('no-scroll');
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        UI_EVENT_BUS.unsubscribe(this._subscription);
	    },

	    cancelUpload: function cancelUpload() {
	        PromotionActions.cancelUpload(this._uploadId);
	        this.props.onClose();
	        document.body.classList.remove('no-scroll');
	    },

	    render: function render() {
	        var _this2 = this;

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                Modal,
	                { opened: true, onHide: function onHide() {
	                        return _this2.cancelUpload();
	                    }, className: 'ui-uploadPopup' },
	                React.createElement(Header, { title: this.props.title, closeButton: true }),
	                React.createElement(
	                    Content,
	                    { className: 'ui-uploadPopup__attachment slds-p-around--none' },
	                    React.createElement(
	                        'div',
	                        { className: 'ui-uploadPopup__attachmentInfo slds-grid--vertical-align-center slds-grid--vertical-align-start slds-truncate' },
	                        React.createElement(
	                            'span',
	                            null,
	                            React.createElement(
	                                'span',
	                                { className: 'ui-uploadPopup__attachmentIcon' },
	                                React.createElement(Icon, { icon: this.props.fileIcon, category: 'doctype' })
	                            ),
	                            React.createElement(
	                                'span',
	                                { className: 'ui-uploadPopup__attachmentName' },
	                                this.props.file.Name
	                            )
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'ui-progressBar' },
	                        React.createElement('span', { className: 'ui-progressMeter', style: { width: this.state.progress + '%' } })
	                    )
	                )
	            )
	        );
	    }
		});
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 646:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var Variant = __webpack_require__(647);
	var Button = __webpack_require__(461).Button;

	module.exports = React.createClass({
	    displayName: 'exports',

	    getInitialState: function getInitialState() {
	        return {
	            promotion: this.props.promotion
	        };
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
	        if (nextProps.promotion != null) this.setState({ promotion: nextProps.promotion });
	    },

	    onFieldChange: function onFieldChange(name, e, value) {
	        var obj = this.state.promotion;

	        this.props.update(obj.Id, name, value);

	        //Unilver changes for copy lift factor
	        if (name == "UL_Lift__c") PromotionActions.copyLiftToTactics(value);

	        //PMA - START CODE - 2017-01-12 - Copy date from Promotion to Tactic
	        if (name == "Date_From__c") PromotionActions.copyDateFromToTactics(value);
	        if (name == "Date_Thru__c") PromotionActions.copyDateThruToTactics(value);
	        if (name == "Delivery_Date_From__c") PromotionActions.copyDeliveryDateFromToTactics(value);
	        if (name == "Delivery_Date_Thru__c") PromotionActions.copyDeliveryDateThruToTactics(value);
	        if (name == "Placement_Date_From__c") PromotionActions.copyInstoreDateFromToTactics(value);
	        if (name == "Placement_Date_Thru__c") PromotionActions.copyInstoreDateThruToTactics(value);
	        //PMA - END CODE - 2017-01-12 - Copy date from Promotion to Tactic
	    },

	    getContent: function getContent() {
	        return this.state.promotion;
	    },

	    render: function render() {
	        if (this.state.promotion == null) {
	            return React.createElement(
	                'div',
	                { style: { flex: '1 0 0' },
	                    className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center' },
	                React.createElement(
	                    'div',
	                    null,
	                    AppManager.getLabel('PP_TIT_NOCONTENT') || 'NO CONTENT'
	                )
	            );
	        } else {
	            return React.createElement(
	                'div',
	                { className: 'tile' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid title' },
	                    AppManager.getLabel('PP_LBL_MAIN_INFO') || 'Main Information'
	                ),
	                React.createElement('div', { className: 'slds-m-top--medium' }),
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid slds-wrap' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3' },
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(Variant, { object: this.state.promotion, field: 'Slogan__c', onValueChange: this.onFieldChange,
	                            editable: this.props.editMode }),
	                        this.state.promotion.Anchor_Account__c ? React.createElement(
	                            'div',
	                            null,
	                            React.createElement('div', { className: 'slds-m-top--medium' }),
	                            React.createElement(Variant, { object: this.state.promotion, field: 'Anchor_Account__c', editable: false })
	                        ) : React.createElement(
	                            'div',
	                            null,
	                            React.createElement('div', { className: 'slds-m-top--medium' }),
	                            React.createElement(Variant, { object: this.state.promotion, field: 'Anchor_Account_Set__c',
	                                editable: false })
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Promotion_Template__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Lift__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Volume_Type__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Front_Margin__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-form-element__label slds-form-element__label--title' },
	                            AppManager.getLabel('PP_LBL_DATES') || 'Dates'
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Date_From__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Date_Thru__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Placement_Date_From__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Placement_Date_Thru__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Delivery_Date_From__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Delivery_Date_Thru__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        {
	                            className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs  slds-col--padded-left' },
	                        AppManager.getLabel('PP_LBL_STATUS') || 'Status',
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Current_Status__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Phase__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_ThresholdViolated__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Active__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'Parent_Promotion__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        )
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-m-top--large' },
	                    React.createElement(Variant, { object: this.state.promotion, field: 'UL_Free_Text__c',
	                        onValueChange: this.onFieldChange, editable: this.props.editMode }),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-m-top--large' },
	                        React.createElement(Variant, { object: this.state.promotion, field: 'UL_Delivery_Profile__c',
	                            onValueChange: this.onFieldChange,
	                            editable: this.props.editMode })
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid' },
	                    React.createElement('div', { className: 'slds-m-top--large' }),
	                    React.createElement(
	                        'div',
	                        {
	                            className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs ' },
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Mechanic__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Cannibalisation_Override__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-grid ' },
	                            React.createElement(
	                                'div',
	                                { className: 'slds-col--padded-right' },
	                                React.createElement(Variant, { object: this.state.promotion, field: 'UL_Promotion_Type__c',
	                                    onValueChange: this.onFieldChange, editable: this.props.editMode })
	                            )
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        {
	                            className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs slds-col--padded-right ' },
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.promotion, field: 'UL_Sub_Mechanic__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.promotion, field: 'UL_Feature__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.promotion, field: 'UL_Account__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 ' },
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.promotion, field: 'UL_Primary_Objective__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.promotion, field: 'UL_Post_Dip_End_Date__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.promotion, field: 'UL_Pre_Evaluation_Comment__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        {
	                            className: 'slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 slds-col--padded-left--xs' },
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(Variant, { object: this.state.promotion, field: 'UL_Secondary_Objective__c',
	                            onValueChange: this.onFieldChange, editable: this.props.editMode }),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(Variant, { object: this.state.promotion, field: 'UL_Cannibalisation_Rate__c',
	                            onValueChange: this.onFieldChange, editable: this.props.editMode }),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(Variant, { object: this.state.promotion, field: 'UL_Market__c',
	                            onValueChange: this.onFieldChange, editable: this.props.editMode }),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(Variant, { object: this.state.promotion, field: 'UL_Category__c',
	                            onValueChange: this.onFieldChange, editable: this.props.editMode }),
	                        React.createElement('div', { className: 'slds-m-top--medium' }),
	                        React.createElement(Variant, { object: this.state.promotion, field: 'UL_Brand__c',
	                            onValueChange: this.onFieldChange, editable: this.props.editMode })
	                    )
	                )
	            );
	        }
	    }
		});

/***/ },

/***/ 647:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	var Input = __webpack_require__(461).Input;
	var FieldSet = __webpack_require__(461).FieldSet;
	var Row = __webpack_require__(461).Row;
	var DateInput = __webpack_require__(461).DateInput;
	var Picklist = __webpack_require__(461).Picklist;
	var PicklistItem = __webpack_require__(461).PicklistItem;
	var Checkbox = __webpack_require__(461).Checkbox;

	module.exports = React.createClass({
	    displayName: 'exports',

	    propTypes: {
	        object: React.PropTypes.object, // This must be the BO/LI associated
	        field: React.PropTypes.string, // The field associated
	        onValueChange: React.PropTypes.func,
	        editable: React.PropTypes.bool
	    },

	    isEditable: function isEditable() {
	        if (this.props.object._acl) {
	            if (this.props['editable'] !== undefined) return this.props['editable'] && this.props.object._acl.isEditable(1, this.props.field);else return this.props.object._acl.isEditable(1, this.props.field);
	        } else return true;
	    },

	    isVisible: function isVisible() {
	        if (this.props.object._acl) {
	            var acl = this.props.object._acl;
	            return acl.isVisible(1, this.props.field);
	        } else return true;
	    },

	    render: function render() {
	        var _this = this;

	        var metadata = this.props.object._meta[this.props.field];
	        if (!this.isVisible()) return null;else {
	            if (metadata.type.toLowerCase() == "string" || metadata.type.toLowerCase() == "reference") {
	                return React.createElement(Input, {
	                    label: metadata.label, disabled: !this.isEditable(),
	                    type: 'text', placeholder: metadata.label,
	                    onChange: function onChange(e, value) {
	                        return _this.props.onValueChange(_this.props.field, {}, value);
	                    },
	                    onClick: function onClick(e) {
	                        return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                    },
	                    value: this.props.object[this.props.field],
	                    title: this.props.object[this.props.field]
	                });
	            } else if (metadata.type.toLowerCase() == "double" || metadata.type.toLowerCase() == "percent") {
	                return React.createElement(Input, {
	                    label: metadata.label, disabled: !this.isEditable(),
	                    type: 'text', placeholder: metadata.label,
	                    onChange: function onChange(e, value) {
	                        return _this.props.onValueChange(_this.props.field, {}, value);
	                    },
	                    onClick: function onClick(e) {
	                        return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                    },
	                    onKeyPress: Utils.Validators.onlyKeyEventNumber,
	                    value: this.isEditable() ? this.props.object[this.props.field] : Utils.Formatters.formatNumber(this.props.object[this.props.field])
	                });
	            } else if (metadata.type.toLowerCase() == "date") {
	                if (!this.isEditable()) {
	                    return React.createElement(Input, { className: 'variant-input-placeholder',
	                        label: metadata.label,
	                        disabled: !this.isEditable(),
	                        type: 'text',
	                        placeholder: metadata.label,
	                        title: this.props.object[this.props.field],
	                        value: Utils.Converters.TS2Date(this.props.object[this.props.field], AppSettings.get('dateFormat') || 'YYYY-MM-DD')
	                    });
	                } else {
	                    return React.createElement(DateInput, { label: metadata.label,
	                        placeholder: AppSettings.get('dateFormat'),
	                        disabled: !this.isEditable(),
	                        onValueChange: function onValueChange(value) {
	                            return _this.props.onValueChange(_this.props.field, {}, value);
	                        },
	                        dateFormat: AppSettings.get('dateFormat'),
	                        onClick: function onClick(e) {
	                            return e.currentTarget.setSelectionRange(0, e.currentTarget.value.length);
	                        },
	                        value: Utils.Converters.TS2Date(this.props.object[this.props.field], 'YYYY-MM-DD')
	                    });
	                }
	            } else if (metadata.type.toLowerCase() == "picklist") {
	                if (this.isEditable()) {
	                    return React.createElement(
	                        Picklist,
	                        { label: metadata.label,
	                            value: this.props.object[this.props.field],
	                            onValueChange: function onValueChange(value) {
	                                return _this.props.onValueChange(_this.props.field, {}, value);
	                            } },
	                        metadata.picklistValues.map(function (a, i) {
	                            return React.createElement(PicklistItem, { key: i + 1, value: a.value, label: a.label });
	                        })
	                    );
	                } else {
	                    return React.createElement(Input, { label: metadata.label, type: 'text', disabled: 'true',
	                        value: this.props.object[this.props.field] });
	                }
	            } else if (metadata.type.toLowerCase() == "boolean") {
	                return React.createElement(Checkbox, { disabled: !this.isEditable(),
	                    label: metadata.label, checked: this.props.object[this.props.field],
	                    onChange: function onChange() {
	                        return _this.props.onValueChange(_this.props.field, {}, !_this.props.object[_this.props.field]);
	                    } });
	            } else {
	                return React.createElement(
	                    'div',
	                    null,
	                    ' FIELD TYPE ',
	                    metadata.type,
	                    ' NOT SUPPORTED '
	                );
	            }
	        }
	    }
		});

/***/ },

/***/ 648:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	var React = __webpack_require__(283);
	var Modal = __webpack_require__(461).Modal;
	var Checkbox = __webpack_require__(461).Checkbox;
	var Icon = __webpack_require__(461).Icon;
	var Button = __webpack_require__(461).Button;

	var ConfirmPopup = __webpack_require__(614);

	var PromotionActions = __webpack_require__(643).PromotionActions;

	var Header = Modal.Header,
	    Content = Modal.Content,
	    _global = global,
	    UI_EVENT_BUS = _global.UI_EVENT_BUS;


	module.exports = React.createClass({
	    displayName: 'PromotionChildAccounts',

	    getInitialState: function getInitialState() {
	        return {
	            confirmMessage: null,
	            pushed: 0,
	            total: _.filter(this.props.promotion.ChildAccounts, function (childAccount) {
	                return childAccount.Included;
	            }).length
	        };
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(props) {
	        var _this = this;

	        if (props.pushMode) {

	            var uploadId = Utils.guid();
	            if (this._subscription) UI_EVENT_BUS.unsubscribe(this._subscription);
	            this._subscription = UI_EVENT_BUS.subscribe(uploadId, function (_ref) {
	                var total = _ref.total,
	                    done = _ref.done;

	                _this.setState({
	                    total: total,
	                    pushed: done
	                });
	                if (total == done) {
	                    _this.cancelPush();
	                }
	            });
	            this._uploadId = uploadId;

	            PromotionActions.pushChildAccount(uploadId);
	            document.body.classList.add('no-scroll');
	        }
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        if (this.props.pushMode) UI_EVENT_BUS.unsubscribe(this._subscription);
	    },

	    cancelPush: function cancelPush() {
	        var _this2 = this;

	        PromotionActions.cancelUpload(this._uploadId);
	        document.body.classList.remove('no-scroll');
	        this.props.pushModeEnd();
	        var confirmMessage = {
	            title: AppManager.getLabel("PP_TIT_CONFIRMATION") || 'Confirmation',
	            message: AppManager.getLabel("PP_LBL_PUSH_FINALIZED") || 'Push child promotion accounts finalized',
	            okHandler: function okHandler() {
	                _this2.setState({ confirmMessage: null });
	                PromotionActions.finalizePushChildAccounts(_this2.props.promotion.Id);
	                PromotionActions.save(_this2.props.promotion.Id);
	            }
	        };
	        this.setState({ confirmMessage: confirmMessage });
	    },

	    allChildAccountsIncluded: function allChildAccountsIncluded() {
	        return _.every(this.props.promotion.ChildAccounts, { 'Included': true });
	    },

	    toggleChildAccount: function toggleChildAccount(childAccount) {
	        PromotionActions.toggleChildAccount(childAccount.ChildAccountID, childAccount.Included);
	    },

	    toggleAllChildAccounts: function toggleAllChildAccounts(Included) {
	        PromotionActions.toggleAllChildAccounts(this.props.promotion.ChildAccounts, Included);
	    },

	    renderProgressModal: function renderProgressModal() {
	        var _this3 = this;

	        var progress = this.state.pushed * 100 / this.state.total;
	        return React.createElement(
	            Modal,
	            { opened: true, onHide: function onHide() {
	                    return _this3.cancelPush();
	                }, className: 'ui-pushModal' },
	            React.createElement(Header, { title: AppManager.getLabel("PP_TIT_PUSH_PROMOTION") || 'Push Promotion', closeButton: true }),
	            React.createElement(
	                Content,
	                { className: 'slds-p-around--none' },
	                React.createElement(
	                    'div',
	                    { className: 'ui-pushModal__info slds-grid--vertical-align-center slds-grid--vertical-align-start slds-truncate' },
	                    AppManager.getLabel("PP_LBL_PUSH_PROCESS_PROGRESS") || 'Push process progress.',
	                    '\xA0',
	                    this.state.pushed,
	                    ' / ',
	                    this.state.total,
	                    '\xA0',
	                    AppManager.getLabel("PP_LBL_PROMOTIONS_DONE") || 'Promotions done'
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'ui-progressBar' },
	                    React.createElement('span', { className: 'ui-progressMeter', style: { width: progress + '%' } })
	                )
	            )
	        );
	    },

	    renderChildRow: function renderChildRow(childAccount, ix) {
	        var _this4 = this;

	        return React.createElement(
	            'tr',
	            { key: "ChildAccountRow_" + ix },
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-button-group', role: 'group' },
	                        !this.props.editMode ? childAccount.Included ? React.createElement(Icon, { className: 'slds-m-right--medium', category: 'standard', fillColor: 'none',
	                            icon: 'task2', size: 'x-medium' }) : null : React.createElement(Checkbox, { checked: childAccount.Included,
	                            onChange: function onChange(e) {
	                                return _this4.toggleChildAccount(childAccount);
	                            } })
	                    )
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    childAccount.ChildAccountName
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    childAccount.CustomerUnique
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    React.createElement(
	                        'span',
	                        { className: 'slds-text-link',
	                            onClick: function onClick(e) {
	                                return PromotionActions.openPromotion(childAccount.PushedPromoID);
	                            } },
	                        childAccount.PushedPromoID
	                    )
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    childAccount.PromotionSlogan
	                )
	            )
	        );
	    },

	    scrollTable: function scrollTable(e) {
	        var offset = -e.target.scrollLeft;
	        var headers = e.target.querySelectorAll('table thead th');

	        for (var i = 0; i < headers.length; i++) {
	            headers[i].querySelector('div').style.left = offset + 'px';
	            offset += headers[i].offsetWidth;
	        }
	    },

	    render: function render() {
	        var _this5 = this;

	        var titleCols = [AppManager.getLabel('PP_LBL_INCLUDED'), AppManager.getLabel('PP_TIT_ACCOUNT'), AppManager.getLabel('PP_LBL_CUSTOMER_UNIQUE'), AppManager.getLabel('PP_LBL_PROMOTION_ID'), AppManager.getLabel('PP_TIT_PROMOTION_SLOGAN')];

	        return React.createElement(
	            'div',
	            { className: 'ui-child-accounts tile slds-m-top--medium' },
	            React.createElement(
	                'div',
	                { className: 'title slds-grid' },
	                React.createElement(
	                    'label',
	                    null,
	                    AppManager.getLabel("PP_TIT_CHILD_PROMOTION_ACCOUNTS") || 'Child Promotion Accounts'
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center' },
	                React.createElement(
	                    'div',
	                    { className: 'table--fixed-header slds-m-vertical--large slds-m-top--large' },
	                    React.createElement(
	                        'section',
	                        { className: this.props.editMode ? 'editMode' : 'viewMode',
	                            onScroll: function onScroll(event) {
	                                return _this5.scrollTable(event);
	                            } },
	                        React.createElement(
	                            'table',
	                            { className: 'slds-table--bordered slds-table--cell-buffer' },
	                            React.createElement(
	                                'thead',
	                                null,
	                                React.createElement(
	                                    'tr',
	                                    { className: 'slds-text-heading--label' },
	                                    titleCols.map(function (title, ix) {
	                                        return React.createElement(
	                                            'th',
	                                            { key: ix, scope: 'col',
	                                                title: _this5.props.editMode && ix == 0 ? AppManager.getLabel("PP_TIT_INCLUDE_EXCLUDE_ALL") || 'Include/Exclude All' : title },
	                                            title,
	                                            React.createElement(
	                                                'div',
	                                                { className: 'slds-truncate' },
	                                                _this5.props.editMode && ix == 0 ? React.createElement(Checkbox, { checked: _this5.allChildAccountsIncluded(),
	                                                    onChange: function onChange(e) {
	                                                        return _this5.toggleAllChildAccounts(_this5.allChildAccountsIncluded());
	                                                    } }) : title
	                                            )
	                                        );
	                                    })
	                                )
	                            ),
	                            React.createElement(
	                                'tbody',
	                                null,
	                                this.props.promotion.ChildAccounts.map(function (childAccount, ix) {
	                                    return _this5.renderChildRow(childAccount, ix);
	                                })
	                            )
	                        )
	                    )
	                )
	            ),
	            this.state.confirmMessage ? React.createElement(
	                'div',
	                null,
	                React.createElement(
	                    'div',
	                    { 'aria-hidden': 'false', 'aria-labelledby': 'prompt-heading-id',
	                        'aria-describedby': 'prompt-message-wrapper',
	                        role: 'alertdialog', className: 'slds-modal slds-modal--prompt slds-fade-in-open' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__container slds-modal--prompt', role: 'document',
	                            id: 'prompt-message-wrapper', tabIndex: '0' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-modal__header slds-theme--warning slds-theme--alert-texture' },
	                            React.createElement(
	                                'h2',
	                                { className: 'slds-text-heading--medium',
	                                    id: 'prompt-heading-id' },
	                                this.state.confirmMessage.title
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-modal__content slds-p-around--medium' },
	                            React.createElement(
	                                'div',
	                                null,
	                                React.createElement(
	                                    'p',
	                                    null,
	                                    this.state.confirmMessage.message
	                                )
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-modal__footer slds-theme--default' },
	                            React.createElement(
	                                'button',
	                                { className: 'slds-button slds-button--neutral',
	                                    onClick: function onClick() {
	                                        return _this5.state.confirmMessage.okHandler();
	                                    } },
	                                AppManager.getLabel("PP_BTN_OK") || 'Ok'
	                            )
	                        )
	                    )
	                ),
	                React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	            ) : null,
	            this.props.pushMode ? this.renderProgressModal() : null
	        );
	    }
		});
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 649:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var React = __webpack_require__(283);
	var Tile = __webpack_require__(636);
	var ReactCSSTransitionGroup = __webpack_require__(620);

	var HorizontalChart = __webpack_require__(640);
	var TacticFunds = __webpack_require__(650);
	var TacticTiers = __webpack_require__(652);
	var PromotionPlanningTacticEdit = __webpack_require__(653);

	module.exports = new React.createClass({
	    displayName: 'TacticOverview',

	    propTypes: {
	        item: React.PropTypes.object, //Promotion details
	        editMode: React.PropTypes.bool //Flag for showing Edit window
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-wrap tile-area' },
	            React.createElement(
	                ReactCSSTransitionGroup,
	                { component: 'div',
	                    className: 'slds-size--1-of-1',
	                    transitionName: { enter: "animated", enterActive: "flipInX", leave: "animated", leaveActive: "flipOutX" },
	                    transitionEnterTimeout: 500, transitionLeaveTimeout: 500 },
	                React.createElement(PromotionPlanningTacticEdit, _extends({ ref: 'editPanel', tactic: this.props.item,
	                    update: this.props.update }, this.props))
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-size--1-of-1 slds-col--padded-top' },
	                React.createElement(
	                    ReactCSSTransitionGroup,
	                    { transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                        transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                        transitionLeaveTimeout: 1500 },
	                    React.createElement(
	                        Tile,
	                        { key: 'tile21', animated: true },
	                        React.createElement(TacticTiers, { item: this.props.item, editMode: this.props.editMode })
	                    )
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-size--1-of-1 slds-col--padded-top' },
	                React.createElement(
	                    ReactCSSTransitionGroup,
	                    { transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                        transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                        transitionLeaveTimeout: 1500 },
	                    React.createElement(
	                        Tile,
	                        { key: 'tile21', animated: true },
	                        React.createElement(TacticFunds, this.props)
	                    )
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-size--1-of-2 slds-col--padded-top' },
	                React.createElement(
	                    ReactCSSTransitionGroup,
	                    { transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                        transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                        transitionLeaveTimeout: 1500 },
	                    React.createElement(
	                        Tile,
	                        { key: 'tile21', animated: true },
	                        React.createElement(HorizontalChart, { title: AppManager.getLabel('PP_TIT_CHART_ROI') || 'ROI',
	                            formatter: Utils.Formatters.formatPct,
	                            positiveKPI: true,
	                            mainvalue: this.props.item.AggregatedKPIs.LROI,
	                            planned: this.props.item.AggregatedKPIs.PROI })
	                    )
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-size--1-of-2 slds-col--padded-left slds-col--padded-top' },
	                React.createElement(
	                    ReactCSSTransitionGroup,
	                    { transitionName: { appear: "zoomIn" }, transitionAppear: true,
	                        transitionAppearTimeout: 1500, transitionEnterTimeout: 1500,
	                        transitionLeaveTimeout: 1500 },
	                    React.createElement(
	                        Tile,
	                        { key: 'tile31', animated: true },
	                        React.createElement(HorizontalChart, { title: AppManager.getLabel('PP_TIT_CHART_COSTS') || 'COSTS',
	                            formatter: Utils.Formatters.formatCurrency,
	                            positiveKPI: false,
	                            mainvalue: this.props.item.AggregatedKPIs.LETP,
	                            planned: this.props.item.AggregatedKPIs.PTPC })
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 650:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Button = __webpack_require__(461).Button;
	var FundLookup = __webpack_require__(651);

	var PromotionActions = __webpack_require__(643).PromotionActions;

	module.exports = React.createClass({
	    displayName: 'TacticFunds',

	    getInitialState: function getInitialState() {
	        return {
	            editingFunds: false
	        };
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
	        if (nextProps.item.InvalidFunds) this.setState({ editingFunds: true });else this.setState({ editingFunds: false });
	    },

	    componentWillMount: function componentWillMount() {
	        PromotionActions.searchForFunds();
	    },

	    openFundsLookup: function openFundsLookup() {
	        this.setState({ editingFunds: true });
	    },

	    onCancelFundsLookup: function onCancelFundsLookup() {
	        this.setState({ editingFunds: false });
	    },

	    onApplyFundsLookup: function onApplyFundsLookup(funds) {
	        PromotionActions.validateFunds(funds, this.props.item.Id);
	    },

	    isVisible: function isVisible(attribute) {
	        var acl = this.props.item._acl;
	        return acl.isVisible(1, attribute);
	    },


	    render: function render() {
	        var _this = this;

	        if (this.props.item == null) return null;

	        return React.createElement(
	            'div',
	            null,
	            this.state.editingFunds ? React.createElement(FundLookup, { applyHandler: this.onApplyFundsLookup, cancelHandler: this.onCancelFundsLookup,
	                item: this.props.item }) : null,
	            React.createElement(
	                'div',
	                { className: 'tactic-tile' },
	                React.createElement(
	                    'div',
	                    { className: 'title slds-grid' },
	                    React.createElement(
	                        'label',
	                        null,
	                        'Funds'
	                    ),
	                    this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_TIERS") ? React.createElement(
	                        Button,
	                        { className: 'slds-container--right', type: 'neutral', icon: 'custom_apps', iconAlign: 'left',
	                            onClick: function onClick() {
	                                return _this.openFundsLookup();
	                            } },
	                        AppManager.getLabel('PP_BTN_MANAGE_FUND') || 'Manage Funds'
	                    ) : null
	                ),
	                this.props.item.funds.length > 0 ? React.createElement(
	                    'div',
	                    { className: 'funds-grid slds-scrollable slds-m-vertical--medium' },
	                    this.props.item.funds.map(function (fund, i) {
	                        return React.createElement(
	                            'div',
	                            { className: 'funds-props', key: i },
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Fund Name'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Name
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Description'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Description__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Fund Type'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Fund_Template_Description__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Available to Spend'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Amount__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    '% Allocated'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Allocation__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Amount Allocated'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Amount_Allocated__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Anchor Customer'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Anchor_Customer__c
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'tactic-item' },
	                                React.createElement(
	                                    'label',
	                                    null,
	                                    'Anchor Product'
	                                ),
	                                React.createElement(
	                                    'span',
	                                    null,
	                                    fund.Anchor_Product__c
	                                )
	                            )
	                        );
	                    })
	                ) : React.createElement(
	                    'div',
	                    { className: 'slds-m-vertical--medium' },
	                    React.createElement(
	                        'span',
	                        null,
	                        AppManager.getLabel('PP_LBL_NO_FUNDS') || 'No Funds associated to this tactic'
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 651:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Input = __webpack_require__(461).Input;
	var Icon = __webpack_require__(461).Icon;
	var Checkbox = __webpack_require__(461).Checkbox;

	module.exports = React.createClass({
	    displayName: 'FundLookup',

	    getInitialState: function getInitialState() {
	        return {
	            funds: this.getFunds(this.props.item.availableFunds),
	            invalidFields: [],
	            focusIn: ''
	        };
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        this.setState({ invalidFields: [], focusIn: '' });
	    },

	    componentDidUpdate: function componentDidUpdate() {
	        if (typeof this.state.focusIn != 'undefined' && this.state.focusIn !== '') document.getElementsByClassName(this.state.focusIn)[0].focus();else if (this.state.funds.length > 0 && this.state.invalidFields.length > 0) document.getElementsByClassName(this.state.invalidFields[0])[0].focus();
	        this.state.focusIn = '';
	    },

	    getFunds: function getFunds(funds) {
	        var _this = this;

	        var collection = [];
	        _.forEach(funds, function (fund) {
	            var selected = _.filter(fund.Tactics, function (item) {
	                return item.tacticId == _this.props.item.Id;
	            }).length > 0;
	            collection.push({
	                Id: fund.Id,
	                Name: fund.Name,
	                Description__c: fund.Description__c,
	                Fund_Template_Description__c: fund.Fund_Template_Description__c,
	                Amount__c: fund.Amount__c,
	                Allocation__c: fund.Allocation__c,
	                Amount_Allocated__c: fund.Amount_Allocated__c,
	                Anchor_Customer__c: fund.Anchor_Customer__c,
	                Anchor_Product__c: fund.Anchor_Product__c,
	                selected: selected
	            });
	        });
	        return collection;
	    },

	    applyFundsLookup: function applyFundsLookup() {
	        if (!this.hasInvalidFields(false)) {
	            this.props.applyHandler(_.filter(this.state.funds, 'selected'));
	        }
	    },

	    cancelFundsLookup: function cancelFundsLookup() {
	        this.props.cancelHandler();
	    },

	    toggleSelection: function toggleSelection(fund) {
	        fund.selected = !fund.selected;
	        fund.Allocation__c = fund.Allocation__c || 0;
	        fund.Amount_Allocated__c = fund.Amount_Allocated__c || 0.00;
	        this.forceUpdate();
	    },

	    fieldChange: function fieldChange(fund, val) {
	        var calc = parseInt(val) * parseFloat(fund.Amount__c) / 100;
	        fund['Allocation__c'] = parseInt(val);
	        fund['Amount_Allocated__c'] = calc < 0 ? 0 : parseFloat(calc).toFixed(2);
	        this.hasInvalidFields(fund.Id);
	    },

	    isValidPercentage: function isValidPercentage(n) {
	        return !isNaN(parseFloat(n)) && isFinite(n) && n > 0 && n <= 100;
	    },

	    hasInvalidFields: function hasInvalidFields(focusIn) {
	        var fields = [];
	        for (var i = 0; i < this.state.funds.length; i++) {
	            var fund = this.state.funds[i];
	            if (fund.selected && !this.isValidPercentage(fund.Allocation__c)) fields.push(fund.Id);
	        }
	        this.setState({ invalidFields: fields, focusIn: focusIn ? focusIn : fields.length > 0 ? fields[0] : '' });
	        return fields.length > 0;
	    },

	    scrollTable: function scrollTable(e) {
	        var offset = -e.target.scrollLeft;
	        var headers = e.target.querySelectorAll('table thead th');

	        for (var i = 0; i < headers.length; i++) {
	            headers[i].querySelector('div').style.left = offset + 'px';
	            offset += headers[i].offsetWidth;
	        }
	    },

	    renderFundRow: function renderFundRow(fund, ix) {
	        var _this2 = this;

	        return React.createElement(
	            'tr',
	            { key: "fund_" + ix },
	            React.createElement(
	                'td',
	                null,
	                React.createElement(Checkbox, { className: 'slds-text-align--lef', onChange: function onChange() {
	                        return _this2.toggleSelection(fund);
	                    },
	                    checked: fund.selected })
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-text-align--left' },
	                    fund.Name
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-text-align--left slds-truncate' },
	                    fund.Description__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-text-align--left slds-truncate' },
	                    fund.Fund_Template_Description__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-m-horizontal--small' },
	                    fund.Amount__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                !fund.selected ? React.createElement('div', { className: 'slds-m-horizontal--small' }) : React.createElement(
	                    'div',
	                    { className: 'slds-form-element' },
	                    React.createElement(Input, { type: 'number', defaultValue: fund.Allocation__c, className: fund.Id,
	                        onChange: function onChange(e, value) {
	                            return _this2.fieldChange(fund, value);
	                        },
	                        error: this.state.invalidFields.indexOf(fund.Id) != -1,
	                        onClick: function onClick() {
	                            return _this2.state.focusIn = fund.Id;
	                        },
	                        ref: function ref(i) {
	                            return i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null;
	                        } }),
	                    React.createElement(Icon, { icon: 'edit', size: 'x-small', className: 'slds-icon--left' })
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-m-horizontal--small' },
	                    fund.selected ? fund.Amount_Allocated__c : null
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-text-align--left' },
	                    fund.Anchor_Customer__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-text-align--left' },
	                    fund.Anchor_Product__c
	                )
	            )
	        );
	    },

	    renderFundSearchGrid: function renderFundSearchGrid() {
	        var _this3 = this;

	        var titleCols = [AppManager.getLabel('PP_LBL_SELECT') || 'Select', 'Fund Name', 'Description', 'Fund Type', 'Available to Spend', '% Allocated', 'Amount Allocated', 'Anchor Customer', 'Anchor Product'];

	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center funds-lookup' },
	            React.createElement(
	                'div',
	                { className: 'table--fixed-header slds-m-vertical--medium slds-m-top--medium' },
	                React.createElement(
	                    'section',
	                    { onScroll: function onScroll(event) {
	                            return _this3.scrollTable(event);
	                        } },
	                    React.createElement(
	                        'table',
	                        { className: 'slds-table--bordered slds-table--cell-buffer' },
	                        React.createElement(
	                            'thead',
	                            null,
	                            React.createElement(
	                                'tr',
	                                { className: 'slds-text-heading--label' },
	                                titleCols.map(function (title, ix) {
	                                    return React.createElement(
	                                        'th',
	                                        { key: ix, scope: 'col', title: title },
	                                        title,
	                                        React.createElement(
	                                            'div',
	                                            { className: 'slds-truncate' },
	                                            title
	                                        )
	                                    );
	                                })
	                            )
	                        ),
	                        React.createElement(
	                            'tbody',
	                            null,
	                            this.state.funds.map(function (fund, ix) {
	                                return _this3.renderFundRow(fund, ix);
	                            })
	                        )
	                    )
	                )
	            )
	        );
	    },

	    render: function render() {
	        var _this4 = this;

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                'div',
	                { className: 'slds-modal slds-fade-in-open', 'aria-hidden': 'false', role: 'dialog' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-modal__container', style: { minWidth: '70rem' } },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__header' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--medium' },
	                            AppManager.getLabel('PP_TIT_FUND_LOOKUP') || 'Fund Lookup'
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__content' },
	                        this.renderFundSearchGrid()
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__footer' },
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this4.cancelFundsLookup();
	                                } },
	                            AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'
	                        ),
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral slds-button--brand',
	                                onClick: function onClick() {
	                                    return _this4.applyFundsLookup();
	                                } },
	                            AppManager.getLabel('PP_BTN_APPLY_FUND') || 'Apply Fund'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	        );
	    }
		});

/***/ },

/***/ 652:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Input = __webpack_require__(461).Input;
	var Icon = __webpack_require__(461).Icon;
	var Button = __webpack_require__(461).Button;

	var PromotionActions = __webpack_require__(643).PromotionActions;

	module.exports = React.createClass({
	    displayName: 'TacticTiers',

	    getInitialState: function getInitialState() {
	        return {
	            tacticTiers: this.getTacticTiers(this.props.item.TacticTiers),
	            managingTiers: false,
	            selectedTiers: [],
	            invalidFields: [],
	            focusIn: ''
	        };
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
	        if (nextProps.item.InvalidTacticTiers) this.setState({ managingTiers: true });else this.setState({ managingTiers: false, selectedTiers: [], focusIn: '' });
	    },

	    componentDidUpdate: function componentDidUpdate() {
	        if (this.state.managingTiers && !this.state.tacticTiers.length > 0) this.newTier();else if (this.state.managingTiers && typeof this.state.focusIn != 'undefined' && this.state.focusIn !== '') document.getElementsByClassName(this.state.focusIn)[0].focus();else if (this.state.managingTiers && this.state.tacticTiers.length > 0 && this.state.invalidFields.length > 0) document.getElementsByClassName(this.state.invalidFields[0])[0].focus();
	        this.state.focusIn = '';
	    },

	    getTacticTiers: function getTacticTiers(tacticTiers) {
	        var collection = [];
	        _.forEach(tacticTiers, function (tacticTier) {
	            collection.push({
	                fromValue: tacticTier.fromValue,
	                toValue: tacticTier.toValue,
	                amount: tacticTier.amount
	            });
	        });
	        return collection;
	    },

	    manageTiers: function manageTiers() {
	        this.setState({ managingTiers: true });
	    },

	    fieldChange: function fieldChange(tacticTier, name, value, ix) {
	        tacticTier[name] = value ? name == "amount" ? parseFloat(value) : parseInt(value) : null;
	        this.hasInvalidFields(name + '_' + ix);
	    },

	    toggleSelection: function toggleSelection(ix) {
	        var tacticTierIndex = this.state.selectedTiers.indexOf(ix);
	        if (tacticTierIndex == -1) this.state.selectedTiers.push(ix);else this.state.selectedTiers.splice(tacticTierIndex, 1);
	        this.forceUpdate();
	    },

	    deleteTiers: function deleteTiers() {
	        var me = this,
	            selectedTiers = _.sortBy(this.state.selectedTiers);
	        for (var i = this.state.tacticTiers.length; i--;) {
	            if (selectedTiers.indexOf(i) != -1) {
	                me.state.tacticTiers.splice(i, 1);
	            }
	        }
	        this.forceUpdate();
	        this.setState({ selectedTiers: [], focusIn: '' });
	        if (this.state.tacticTiers.length == 0) {
	            this.newTier();
	        }
	        this.hasInvalidFields(false);
	    },

	    cancelTiers: function cancelTiers() {
	        this.setState({
	            tacticTiers: this.getTacticTiers(this.props.item.TacticTiers),
	            managingTiers: false,
	            selectedTiers: [],
	            invalidFields: [],
	            focusIn: ''
	        });
	    },

	    newTier: function newTier() {
	        if (!this.hasInvalidFields(false)) {
	            var tacticTiers = this.state.tacticTiers,
	                lastToValue = tacticTiers.length > 0 ? _.last(tacticTiers).toValue : 0;
	            this.state.tacticTiers.push({
	                fromValue: lastToValue + 1,
	                toValue: null,
	                amount: null
	            });
	            this.forceUpdate();
	            this.setState({ focusIn: 'toValue_' + (tacticTiers.length - 1) });
	        }
	    },

	    applyTiers: function applyTiers() {
	        if (!this.hasInvalidFields(false)) {
	            PromotionActions.validateTacticTiers(this.state.tacticTiers, this.props.item.Id);
	        }
	    },

	    isNumber: function isNumber(n) {
	        return !isNaN(parseFloat(n)) && isFinite(n);
	    },

	    hasInvalidFields: function hasInvalidFields(focusIn) {
	        var fields = [];
	        for (var i = 0; i < this.state.tacticTiers.length; i++) {
	            var tacticTier = this.state.tacticTiers[i];
	            if (!this.isNumber(tacticTier.fromValue)) fields.push('fromValue_' + i);
	            if (!this.isNumber(tacticTier.toValue)) fields.push('toValue_' + i);
	            if (!this.isNumber(tacticTier.amount)) fields.push('amount_' + i);
	        }
	        this.setState({ invalidFields: fields, focusIn: focusIn ? focusIn : fields.length > 0 ? fields[0] : '' });
	        return fields.length > 0;
	    },

	    scrollTable: function scrollTable(e) {
	        var offset = -e.target.scrollLeft;
	        var headers = e.target.querySelectorAll('table thead th');

	        for (var i = 0; i < headers.length; i++) {
	            headers[i].querySelector('div').style.left = offset + 'px';
	            offset += headers[i].offsetWidth;
	        }
	    },
	    renderRow: function renderRow(tacticTier, ix) {
	        var _this = this;

	        return React.createElement(
	            'tr',
	            { key: Utils.guid(), onClick: function onClick() {
	                    return _this.toggleSelection(ix);
	                },
	                className: this.state.selectedTiers.indexOf(ix) != -1 ? 'selectedTacticTier' : '' },
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-form-element' },
	                    React.createElement(Input, { type: 'number', defaultValue: tacticTier.fromValue, className: "fromValue_" + ix,
	                        onChange: function onChange(e, value) {
	                            return _this.fieldChange(tacticTier, 'fromValue', value, ix);
	                        },
	                        error: this.state.invalidFields.indexOf("fromValue_" + ix) != -1,
	                        onClick: function onClick() {
	                            return _this.state.focusIn = "fromValue_" + ix;
	                        },
	                        ref: function ref(i) {
	                            return i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null;
	                        } }),
	                    React.createElement(Icon, { icon: 'edit', size: 'x-small', className: 'slds-icon--left' })
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-form-element' },
	                    React.createElement(Input, { type: 'number', defaultValue: tacticTier.toValue, className: "toValue_" + ix,
	                        onChange: function onChange(e, value) {
	                            return _this.fieldChange(tacticTier, 'toValue', value, ix);
	                        },
	                        error: this.state.invalidFields.indexOf("toValue_" + ix) != -1,
	                        onClick: function onClick() {
	                            return _this.state.focusIn = "toValue_" + ix;
	                        },
	                        ref: function ref(i) {
	                            return i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null;
	                        } }),
	                    React.createElement(Icon, { icon: 'edit', size: 'x-small', className: 'slds-icon--left' })
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-form-element' },
	                    React.createElement(Input, { type: 'number', defaultValue: tacticTier.amount, className: "amount_" + ix,
	                        onChange: function onChange(e, value) {
	                            return _this.fieldChange(tacticTier, 'amount', value, ix);
	                        },
	                        error: this.state.invalidFields.indexOf("amount_" + ix) != -1,
	                        onClick: function onClick() {
	                            return _this.state.focusIn = "amount_" + ix;
	                        },
	                        ref: function ref(i) {
	                            return i && i.scrollIntoViewIfNeeded ? i.scrollIntoViewIfNeeded() : null;
	                        } }),
	                    React.createElement(Icon, { icon: 'edit', size: 'x-small', className: 'slds-icon--left' })
	                )
	            )
	        );
	    },

	    renderEditDialog: function renderEditDialog() {
	        var _this2 = this;

	        var titleCols = [AppManager.getLabel('PP_TIT_VOLUME_MIN') || 'Volume Min', AppManager.getLabel('PP_TIT_VOLUME_MAX') || 'Volume Max', AppManager.getLabel('PP_TIT_AMOUNT') || 'Amount'];

	        return React.createElement(
	            'div',
	            { ref: 'TacticTiersEditDialog' },
	            React.createElement(
	                'div',
	                { className: 'slds-modal slds-fade-in-open', 'aria-hidden': 'false', role: 'dialog' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-modal__container', style: { minWidth: '50rem' } },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__header' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--medium' },
	                            AppManager.getLabel('PP_TIT_TIERED_INFORMATION') || 'Tiered Information'
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__content slds-p-around--medium' },
	                        React.createElement(
	                            'div',
	                            null,
	                            React.createElement(
	                                'div',
	                                { className: 'slds-grid slds-grid--vertical-align-center' },
	                                React.createElement('div', { className: 'slds-col--bump-right' }),
	                                React.createElement(
	                                    'button',
	                                    { className: 'slds-button slds-float--right slds-button--neutral',
	                                        disabled: this.state.invalidFields.length > 0,
	                                        onClick: function onClick() {
	                                            return _this2.newTier();
	                                        } },
	                                    AppManager.getLabel('PP_BTN_NEW') || 'New'
	                                ),
	                                React.createElement(
	                                    'button',
	                                    { className: 'slds-button slds-float--right slds-button--neutral',
	                                        onClick: function onClick() {
	                                            return _this2.deleteTiers();
	                                        } },
	                                    AppManager.getLabel('PP_BTN_DELETE') || 'Delete'
	                                )
	                            ),
	                            React.createElement(
	                                'div',
	                                { className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center' },
	                                React.createElement(
	                                    'div',
	                                    { className: 'table--fixed-header slds-m-vertical--medium slds-m-top--medium' },
	                                    React.createElement(
	                                        'section',
	                                        { className: 'editMode', onScroll: function onScroll(event) {
	                                                return _this2.scrollTable(event);
	                                            } },
	                                        React.createElement(
	                                            'table',
	                                            { className: 'slds-table--bordered slds-table--cell-buffer' },
	                                            React.createElement(
	                                                'thead',
	                                                null,
	                                                React.createElement(
	                                                    'tr',
	                                                    { className: 'slds-text-heading--label' },
	                                                    titleCols.map(function (title, ix) {
	                                                        return React.createElement(
	                                                            'th',
	                                                            { key: ix, scope: 'col', title: title },
	                                                            title,
	                                                            React.createElement(
	                                                                'div',
	                                                                { className: 'slds-truncate' },
	                                                                title
	                                                            )
	                                                        );
	                                                    })
	                                                )
	                                            ),
	                                            React.createElement(
	                                                'tbody',
	                                                null,
	                                                this.state.tacticTiers.map(function (tacticTier, ix) {
	                                                    return _this2.renderRow(tacticTier, ix);
	                                                })
	                                            )
	                                        )
	                                    )
	                                )
	                            )
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__footer' },
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this2.cancelTiers();
	                                } },
	                            AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'
	                        ),
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral slds-button--brand',
	                                disabled: this.state.invalidFields.length > 0, onClick: function onClick() {
	                                    return _this2.applyTiers();
	                                } },
	                            AppManager.getLabel('PP_BTN_APPLY_TIERS') || 'Apply Tiers'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	        );
	    },

	    isVisible: function isVisible(attribute) {
	        var acl = this.props.item._acl;
	        return acl.isVisible(1, attribute);
	    },


	    render: function render() {
	        var _this3 = this;

	        var titleCols = [AppManager.getLabel('PP_TIT_VOLUME_MIN') || 'Volume Min', AppManager.getLabel('PP_TIT_VOLUME_MAX') || 'Volume Max', AppManager.getLabel('PP_TIT_AMOUNT') || 'Amount'];

	        return React.createElement(
	            'div',
	            { className: 'ui-tactic-tiers' },
	            React.createElement(
	                'div',
	                { className: 'title slds-grid' },
	                React.createElement(
	                    'label',
	                    null,
	                    AppManager.getLabel("PP_TIT_TIERED_INFORMATION") || 'Tiered Information'
	                ),
	                this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_TIERS") ? React.createElement(
	                    'div',
	                    { className: 'slds-container--right' },
	                    React.createElement(
	                        Button,
	                        { type: 'neutral', icon: 'custom_apps', iconAlign: 'left',
	                            onClick: function onClick() {
	                                return _this3.manageTiers();
	                            } },
	                        AppManager.getLabel('PP_BTN_MANAGE_TIERS') || 'Manage Tiers'
	                    )
	                ) : null
	            ),
	            this.props.item.TacticTiers.length > 0 ? React.createElement(
	                'div',
	                { className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center' },
	                React.createElement(
	                    'div',
	                    { className: 'table--fixed-header slds-m-vertical--medium slds-m-top--medium' },
	                    React.createElement(
	                        'section',
	                        { className: 'viewMode', onScroll: function onScroll(event) {
	                                return _this3.scrollTable(event);
	                            } },
	                        React.createElement(
	                            'table',
	                            { className: 'slds-table--bordered slds-table--cell-buffer' },
	                            React.createElement(
	                                'thead',
	                                null,
	                                React.createElement(
	                                    'tr',
	                                    { className: 'slds-text-heading--label' },
	                                    titleCols.map(function (title, ix) {
	                                        return React.createElement(
	                                            'th',
	                                            { key: ix, scope: 'col', title: title },
	                                            title,
	                                            React.createElement(
	                                                'div',
	                                                { className: 'slds-truncate' },
	                                                title
	                                            )
	                                        );
	                                    })
	                                )
	                            ),
	                            React.createElement(
	                                'tbody',
	                                null,
	                                this.props.item.TacticTiers.map(function (tacticTier, ix) {
	                                    return React.createElement(
	                                        'tr',
	                                        { key: "TacticTier_" + ix },
	                                        React.createElement(
	                                            'td',
	                                            null,
	                                            React.createElement(
	                                                'div',
	                                                { className: 'slds-truncate' },
	                                                tacticTier.fromValue
	                                            )
	                                        ),
	                                        React.createElement(
	                                            'td',
	                                            null,
	                                            React.createElement(
	                                                'div',
	                                                { className: 'slds-truncate' },
	                                                tacticTier.toValue
	                                            )
	                                        ),
	                                        React.createElement(
	                                            'td',
	                                            null,
	                                            React.createElement(
	                                                'div',
	                                                { className: 'slds-truncate' },
	                                                tacticTier.amount
	                                            )
	                                        )
	                                    );
	                                })
	                            )
	                        )
	                    )
	                )
	            ) : React.createElement(
	                'div',
	                { className: 'slds-m-vertical--medium' },
	                React.createElement(
	                    'span',
	                    null,
	                    AppManager.getLabel('PP_LBL_NO_TIERS') || 'No Tiers associated to this tactic'
	                )
	            ),
	            this.state.managingTiers ? this.renderEditDialog() : null
	        );
	    }
		});

/***/ },

/***/ 653:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var React = __webpack_require__(283);
	var Input = __webpack_require__(461).Input;
	var FieldSet = __webpack_require__(461).FieldSet;
	var Row = __webpack_require__(461).Row;
	var DateInput = __webpack_require__(461).DateInput;
	var Picklist = __webpack_require__(461).Picklist;
	var PicklistItem = __webpack_require__(461).PicklistItem;
	var Button = __webpack_require__(461).Button;
	var Checkbox = __webpack_require__(461).Checkbox;

	var ProductGrid = __webpack_require__(654);
	var ProductFilter = __webpack_require__(655);
	var ProductLookup = __webpack_require__(656);
	var ConfirmPopup = __webpack_require__(614);

	var Variant = __webpack_require__(647);

	var PromotionActions = __webpack_require__(643).PromotionActions;

	module.exports = React.createClass({
	    displayName: 'exports',

	    getInitialState: function getInitialState() {
	        return {
	            tactic: this.props.tactic,
	            confirmMessage: null,
	            showManageProducts: false
	        };
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
	        if (nextProps.tactic != null) this.setState({ tactic: nextProps.tactic });
	    },

	    onFieldChange: function onFieldChange(name, e, value) {
	        var obj = this.state.tactic;
	        this.props.update(obj.Id, name, value);
	    },

	    getContent: function getContent() {
	        return this.state.tactic;
	    },

	    manageProducts: function manageProducts() {
	        this.setState({ showManageProducts: !this.state.showManageProducts });
	    },

	    openAddProducts: function openAddProducts() {
	        this.setState({ addingProduct: true });
	    },

	    searchForProducts: function searchForProducts(productSample) {
	        PromotionActions.searchForProducts(productSample);
	    },

	    cancelAddProducts: function cancelAddProducts() {
	        this.setState({ addingProduct: false });
	    },

	    addProducts: function addProducts(products) {
	        this.setState({ addingProduct: false });
	        PromotionActions.addProducts(products, this.props.tactic.Id);
	    },

	    applyFilterProducts: function applyFilterProducts() {
	        PromotionActions.applyProductFilter(this.props.tactic.Id, this.refs.prodFilter.getFilterState());
	    },

	    toggleProduct: function toggleProduct(product) {
	        var me = this;
	        var confirmMessage = {
	            title: AppManager.getLabel('PP_TIT_CONFIRMATION') || 'Confirmation',
	            message: AppManager.getLabel('PP_LBL_CONFIRMATION_EXCLUDE_PRODUCT') || 'Do you want to exclude the product?',
	            cancelHandler: function cancelHandler() {
	                me.setState({ confirmMessage: null });
	            },
	            okHandler: function okHandler() {
	                //TODO
	                me.setState({ confirmMessage: null });
	                PromotionActions.changeTacticProductRelationship(product.Id, me.props.tactic.Id, product.relationship);
	            }
	        };

	        if (product.relationship == 'MATCH') {
	            //confirmMessage.message='Do you want to exclude the product?'
	            PromotionActions.changeTacticProductRelationship(product.Id, me.props.tactic.Id, product.relationship);
	        } else if (product.relationship == 'EXCLUDED') {
	            confirmMessage.message = 'Do you want to remove the exclusion for the product?';
	            PromotionActions.changeTacticProductRelationship(product.Id, me.props.tactic.Id, product.relationship);
	        } else if (product.relationship == 'INCLUDED') {
	            confirmMessage.message = 'Do you want to remove the manually included product?';
	            this.setState({ confirmMessage: confirmMessage });
	        }
	    },

	    renderManageProducts: function renderManageProducts() {
	        var _this = this;

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(ProductFilter, _extends({ ref: 'prodFilter', tactic: this.state.tactic }, this.props)),
	            React.createElement(
	                'section',
	                { className: 'slds-clearfix slds-m-top--small' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-float--right' },
	                    React.createElement(
	                        Button,
	                        { type: 'neutral',
	                            onClick: function onClick() {
	                                return _this.openAddProducts();
	                            } },
	                        AppManager.getLabel('PP_BTN_ADD') || 'Add'
	                    ),
	                    React.createElement(
	                        Button,
	                        { type: 'neutral',
	                            onClick: function onClick() {
	                                return _this.applyFilterProducts();
	                            } },
	                        AppManager.getLabel('PP_BTN_APPLY_FILTER') || 'Apply Filter'
	                    )
	                )
	            ),
	            this.state.confirmMessage ? React.createElement(ConfirmPopup, { title: this.state.confirmMessage.title, message: this.state.confirmMessage.message,
	                cancelHandler: this.state.confirmMessage.cancelHandler,
	                okHandler: this.state.confirmMessage.okHandler }) : null,
	            React.createElement(ProductGrid, _extends({ tactic: this.state.tactic }, this.props, { toggleHandler: this.toggleProduct })),
	            this.state.addingProduct ? React.createElement(ProductLookup, _extends({ addHandler: this.addProducts, cancelHandler: this.cancelAddProducts,
	                searchHandler: this.searchForProducts }, this.props)) : null
	        );
	    },

	    isEditable: function isEditable(attribute) {
	        var acl = this.state.tactic._acl;
	        return this.props.editMode && acl.isEditable(0, "Tactic__c") && acl.isEditable(1, attribute);
	    },
	    isVisible: function isVisible(attribute) {
	        var acl = this.state.tactic._acl;
	        return acl.isVisible(1, attribute);
	    },


	    render: function render() {
	        var _this2 = this;

	        var tacticData = this.state.tactic;
	        var metadata = tacticData._meta;
	        var acl = this.state.tactic._acl;

	        return React.createElement(
	            'div',
	            { className: 'tile' },
	            React.createElement(
	                'div',
	                { className: ' title slds-grid' },
	                AppManager.getLabel('PP_TIT_TACTIC_INFO') || 'Tactic Information'
	            ),
	            React.createElement('div', { className: 'slds-m-top--medium' }),
	            React.createElement(
	                'div',
	                { className: 'slds-grid ' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-col--padded-right slds-size--1-of-3' },
	                    React.createElement(Variant, { object: this.state.tactic, field: 'Tactic_Template__c', editable: false }),
	                    React.createElement('div', { className: 'slds-m-top--medium' }),
	                    React.createElement(Variant, { object: this.state.tactic, field: 'Amount__c', onValueChange: this.onFieldChange,
	                        editable: this.props.editMode }),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-m-top--medium' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'UL_Off_On_Invoice__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'UL_Take_Up_Rate__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-m-top--medium' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'UL_Redemption__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-col--padded slds-size--1-of-3' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid ' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Lift__c', onValueChange: this.onFieldChange,
	                                editable: this.props.editMode })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Pct_of_Stores__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-m-top--medium' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Date_From__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Date_Thru__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-m-top--medium' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Instore_Date_From__c', onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Instore_Date_Thru__c', onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-m-top--medium' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Shipment_Date_From__c', onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'Shipment_Date_Thru__c', onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-col--padded slds-size--1-of-3' },
	                    React.createElement(Variant, { object: this.state.tactic, field: 'Compensation_Model__c',
	                        onValueChange: this.onFieldChange, editable: this.props.editMode }),
	                    React.createElement('div', { className: 'slds-m-top--medium' }),
	                    React.createElement(Variant, { object: this.state.tactic, field: 'Payment_Method__c', onValueChange: this.onFieldChange,
	                        editable: this.props.editMode }),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-grid slds-m-top--medium' },
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col--padded-right' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'UL_Condition_Type__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-col' },
	                            React.createElement(Variant, { object: this.state.tactic, field: 'UL_Investment_Method__c',
	                                onValueChange: this.onFieldChange, editable: this.props.editMode })
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-m-top--medium' }),
	            this.props.editMode && this.isVisible("TACTIC_BTN_MANAGE_PRODS") ? React.createElement(
	                'div',
	                { className: 'slds-grid' },
	                React.createElement(
	                    Button,
	                    { type: 'neutral', icon: 'custom_apps', iconAlign: 'left',
	                        onClick: function onClick() {
	                            return _this2.manageProducts();
	                        } },
	                    AppManager.getLabel('PP_BTN_MANAGE_PRODS') || 'Manage Products'
	                )
	            ) : null,
	            this.props.editMode && this.state.showManageProducts ? React.createElement(
	                'div',
	                { className: 'slds-m-top--medium' },
	                this.renderManageProducts()
	            ) : null
	        );
	    }
		});

/***/ },

/***/ 654:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Checkbox = __webpack_require__(461).Checkbox;
	var Icon = __webpack_require__(461).Icon;

	module.exports = React.createClass({
	    displayName: 'ProductGrid',

	    getInitialState: function getInitialState() {
	        var itemsToAdd = 50;
	        return {
	            items: [],
	            itemsToAdd: itemsToAdd
	        };
	    },

	    componentWillMount: function componentWillMount() {
	        //this._loadItems();
	    },

	    renderProductRow: function renderProductRow(product, ix) {
	        var _this = this;

	        var icon = 'task2';
	        var textColor = 'default';
	        if (product.relationship == 'INCLUDED') {
	            icon = 'task';
	        }
	        if (product.relationship == 'EXCLUDED') {
	            icon = 'unmatched';
	            textColor = 'error';
	        }
	        if (product.relationship == 'DELETED') {
	            return null;
	        }
	        return React.createElement(
	            'tr',
	            { key: "productGrid" + ix },
	            React.createElement(
	                'td',
	                null,
	                React.createElement(Icon, { onClick: function onClick() {
	                        return _this.props.toggleHandler(product);
	                    }, category: 'standard', fillColor: 'none',
	                    textColor: textColor, icon: icon, size: 'x-medium', className: 'slds-m-right--medium' })
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Name
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Description_1
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Pack_Size
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Pack_Size_Unit
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Container_Size
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Container_Size_Unit
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Product_Form
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Container_Type
	                )
	            )
	        );
	    },

	    _loadItems: function _loadItems() {
	        var me = this;
	        var length = me.state.items.length + me.state.itemsToAdd;
	        var list = me.state.items;

	        for (var i = list.length; i < length; i++) {
	            if (i < me.props.productFilters.products.length) {
	                list.push(me.renderProductRow(me.props.productFilters.products[i], i));
	            } else {
	                break;
	            }
	        }
	        me.setState({ items: list });
	    },

	    scrollTable: function scrollTable(e) {
	        var offset = -e.target.scrollLeft;
	        var headers = e.target.querySelectorAll('table thead th');

	        for (var i = 0; i < headers.length; i++) {
	            headers[i].querySelector('div').style.left = offset + 'px';
	            offset += headers[i].offsetWidth;
	        }
	    },

	    render: function render() {
	        var _this2 = this;

	        var me = this;
	        var productMeta = this.props.productFilters.productMetadata;
	        //var titleCols=['Select','Description','Brand','Pack Size', 'Pack Size Unit','Container Size', 'Container Size Unit','Category','Container Type']
	        var titleCols = [AppManager.getLabel('PP_LBL_INCLUDED'), productMeta.Name.label, productMeta.Description_1__c.label, productMeta.Pack_Size__c.label, productMeta.Pack_Size_Unit__c.label, productMeta.Container_Size__c.label, productMeta.Container_Size_Unit__c.label, productMeta.Product_Form__c.label, productMeta.Container_Type__c.label];

	        return React.createElement(
	            'div',
	            { className: 'table-wrapper' },
	            React.createElement(
	                'div',
	                { className: 'slds-grid slds-scrollable--x' },
	                React.createElement(
	                    'div',
	                    { className: 'table--fixed-header slds-m-vertical--large slds-m-top--large' },
	                    React.createElement(
	                        'section',
	                        { onScroll: function onScroll(event) {
	                                return _this2.scrollTable(event);
	                            } },
	                        React.createElement(
	                            'table',
	                            { className: 'slds-table--bordered slds-table--cell-buffer' },
	                            React.createElement(
	                                'thead',
	                                null,
	                                React.createElement(
	                                    'tr',
	                                    { className: 'slds-text-heading--label' },
	                                    titleCols.map(function (title, ix) {
	                                        return React.createElement(
	                                            'th',
	                                            { key: ix, scope: 'col', title: title },
	                                            title,
	                                            React.createElement(
	                                                'div',
	                                                { className: 'slds-truncate' },
	                                                title
	                                            )
	                                        );
	                                    })
	                                )
	                            ),
	                            React.createElement(
	                                'tbody',
	                                null,
	                                me.props.productFilters.products.map(function (product, ix) {
	                                    return me.renderProductRow(product, ix);
	                                }),
	                                this.state.items
	                            )
	                        )
	                    )
	                )
	            )
	        );
	    }
		});

/***/ },

/***/ 655:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Checkbox = __webpack_require__(461).Checkbox;
	var PromotionActions = __webpack_require__(643).PromotionActions;

	module.exports = React.createClass({

	    displayName: 'ProductFilter',

	    getInitialState: function getInitialState() {
	        return {
	            productFilters: this.props.productFilters.filters
	        };
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(props) {
	        this.setState({ productFilters: props.productFilters.filters });
	    },

	    toggleFilterValue: function toggleFilterValue(category, value) {
	        //TODO SEND EVENT
	        //var productFilters = this.state.productFilters;
	        var categoryArray = _.groupBy(this.props.productFilters.filters, 'filterId')[category];
	        var item = _.find(categoryArray, { filterValueId: value });
	        item.selected = !item.selected;
	        PromotionActions.toggleTacticProductFilter(category, value, this.props.item, item.selected);
	        //this.setState({productFilters: productFilters});
	    },

	    getFilterState: function getFilterState() {
	        return this.state.productFilters;
	    },

	    render: function render() {
	        var _this = this;

	        var categories = _.toPairs(_.groupBy(this.props.productFilters.filters, 'filterId'));
	        return React.createElement(
	            'div',
	            { className: 'slds-grid slds-scrollable--x product-filter' },
	            categories.map(function (productFilterPair, ix) {
	                //var category = productFilterPair[0];
	                var values = productFilterPair[1];
	                return React.createElement(
	                    'div',
	                    { key: 'categoryFilter' + ix, className: 'slds-col--filter' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-text-heading--small' },
	                        values[0].filterLabel
	                    ),
	                    React.createElement('div', { className: 'slds-m-top--small' }),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-scrollable--y filter-category' },
	                        _.sortBy(values, 'filterValueLabel').map(function (filterItem, ix) {
	                            return React.createElement(Checkbox, { key: 'FilterItem' + ix, label: filterItem.filterValueLabel,
	                                checked: filterItem.selected,
	                                onChange: function onChange() {
	                                    return _this.toggleFilterValue(filterItem.filterId, filterItem.filterValueId);
	                                } });
	                        })
	                    )
	                );
	            })
	        );
	    }

		});

/***/ },

/***/ 656:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);
	var Input = __webpack_require__(461).Input;

	var Picklist = __webpack_require__(461).Picklist;
	var PicklistItem = __webpack_require__(461).PicklistItem;
	var Button = __webpack_require__(461).Button;
	var Checkbox = __webpack_require__(461).Checkbox;

	module.exports = React.createClass({
	    displayName: 'ProductLookup',

	    getInitialState: function getInitialState() {
	        return {
	            productSample: {
	                Description_1__c: '',
	                Name: '',
	                Pack_Size__c: '',
	                Pack_Size_Unit__c: '',
	                Container_Size__c: '',
	                Container_Size_Unit__c: '',
	                Product_Form__c: '',
	                Container_Type__c: ''
	            },
	            selectedProducts: [],
	            productSearch: []
	        };
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        PromotionActions.clearSearchForProducts(); //Clearing the collection
	    },

	    onFieldChange: function onFieldChange(name, value) {
	        this.state.productSample[name] = value;
	        this.setState({ productSample: this.state.productSample });
	    },

	    onAdd: function onAdd() {
	        this.props.addHandler(this.state.selectedProducts);
	    },

	    onSearch: function onSearch() {
	        this.props.searchHandler(this.state.productSample);
	    },

	    onCancel: function onCancel() {
	        this.props.cancelHandler();
	    },

	    toggleSelection: function toggleSelection(product) {
	        var productIndex = this.state.selectedProducts.indexOf(product);
	        if (productIndex == -1) {
	            this.state.selectedProducts.push(product);
	        } else {
	            this.state.selectedProducts.splice(productIndex, 1);
	        }
	        this.forceUpdate();
	    },

	    renderProductRow: function renderProductRow(product, ix) {
	        var _this = this;

	        return React.createElement(
	            'tr',
	            { key: "productGrid" + ix },
	            React.createElement(
	                'td',
	                null,
	                React.createElement(Checkbox, { onChange: function onChange() {
	                        return _this.toggleSelection(product);
	                    },
	                    checked: this.state.selectedProducts.indexOf(product) != -1 })
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Name
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Description_1__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Pack_Size__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Pack_Size_Unit__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Container_Size__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Container_Size_Unit__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Product_Form__c
	                )
	            ),
	            React.createElement(
	                'td',
	                null,
	                React.createElement(
	                    'div',
	                    { className: 'slds-truncate' },
	                    product.Container_Type__c
	                )
	            )
	        );
	    },

	    scrollTable: function scrollTable(e) {
	        var offset = -e.target.scrollLeft;
	        var headers = e.target.querySelectorAll('table thead th');

	        for (var i = 0; i < headers.length; i++) {
	            headers[i].querySelector('div').style.left = offset + 'px';
	            offset += headers[i].offsetWidth;
	        }
	    },

	    renderProductSearchGrid: function renderProductSearchGrid() {
	        var _this2 = this;

	        var me = this;
	        var productMeta = this.props.productFilters.productMetadata;
	        var titleCols = [AppManager.getLabel('PP_LBL_SELECT') || 'Select', productMeta.Name.label, productMeta.Description_1__c.label, productMeta.Pack_Size__c.label, productMeta.Pack_Size_Unit__c.label, productMeta.Container_Size__c.label, productMeta.Container_Size_Unit__c.label, productMeta.Product_Form__c.label, productMeta.Container_Type__c.label];
	        return React.createElement(
	            'div',
	            { className: 'table--fixed-header slds-m-vertical--large slds-m-top--large', style: { height: '334px' } },
	            React.createElement(
	                'section',
	                { onScroll: function onScroll(event) {
	                        return _this2.scrollTable(event);
	                    }, style: { height: '299px' } },
	                React.createElement(
	                    'table',
	                    { className: 'slds-table--bordered slds-table--cell-buffer' },
	                    React.createElement(
	                        'thead',
	                        null,
	                        React.createElement(
	                            'tr',
	                            { className: 'slds-text-heading--label' },
	                            titleCols.map(function (title, ix) {
	                                return React.createElement(
	                                    'th',
	                                    { key: ix, scope: 'col', title: title },
	                                    title,
	                                    React.createElement(
	                                        'div',
	                                        { className: 'slds-truncate' },
	                                        title
	                                    )
	                                );
	                            })
	                        )
	                    ),
	                    React.createElement(
	                        'tbody',
	                        null,
	                        this.props.productSearch.map(function (product, ix) {
	                            return me.renderProductRow(product, ix);
	                        })
	                    )
	                )
	            )
	        );
	    },

	    renderProductSearchForm: function renderProductSearchForm() {
	        var _this3 = this;

	        var productMeta = this.props.productFilters.productMetadata;
	        return React.createElement(
	            'div',
	            { className: 'slds-grid ' },
	            React.createElement(
	                'div',
	                { className: 'slds-col--padded' },
	                React.createElement(Input, { label: productMeta.Description_1__c.label, type: 'text', value: this.state.Description_1__c,
	                    onChange: function onChange(e, value) {
	                        return _this3.onFieldChange('Description_1__c', value);
	                    } }),
	                React.createElement(Input, { label: productMeta.Name.label, type: 'text', value: this.state.Name,
	                    onChange: function onChange(e, value) {
	                        return _this3.onFieldChange('Name', value);
	                    } })
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-col--padded' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid ' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col--padded' },
	                        React.createElement(Input, { label: productMeta.Pack_Size__c.label, type: 'text', value: this.state.Pack_Size__c,
	                            onChange: function onChange(e, value) {
	                                return _this3.onFieldChange('Pack_Size__c', value);
	                            } })
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col--padded' },
	                        React.createElement(
	                            Picklist,
	                            { label: productMeta.Pack_Size_Unit__c.label, value: this.state.Pack_Size_Unit__c,
	                                onValueChange: function onValueChange(value) {
	                                    return _this3.onFieldChange('Pack_Size_Unit__c', value);
	                                } },
	                            React.createElement(PicklistItem, { key: '0', value: '', label: 'All' }),
	                            productMeta.Pack_Size_Unit__c.picklistValues.map(function (a, i) {
	                                return React.createElement(PicklistItem, { key: i + 1, value: a.value, label: a.label });
	                            })
	                        )
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'slds-grid ' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col--padded' },
	                        React.createElement(Input, { label: productMeta.Container_Size__c.label, type: 'text',
	                            value: this.state.Container_Size__c,
	                            onChange: function onChange(e, value) {
	                                return _this3.onFieldChange('Container_Size__c', value);
	                            } })
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-col--padded' },
	                        React.createElement(
	                            Picklist,
	                            { label: productMeta.Container_Size_Unit__c.label,
	                                value: this.state.Container_Size_Unit__c,
	                                onValueChange: function onValueChange(value) {
	                                    return _this3.onFieldChange('Container_Size_Unit__c', value);
	                                } },
	                            React.createElement(PicklistItem, { key: '0', value: '', label: 'All' }),
	                            productMeta.Container_Size_Unit__c.picklistValues.map(function (a, i) {
	                                return React.createElement(PicklistItem, { key: i + 1, value: a.value, label: a.label });
	                            })
	                        )
	                    )
	                )
	            ),
	            React.createElement(
	                'div',
	                { className: 'slds-col--padded' },
	                React.createElement(
	                    Picklist,
	                    { label: productMeta.Product_Form__c.label, value: this.state.Product_Form__c,
	                        onValueChange: function onValueChange(value) {
	                            return _this3.onFieldChange('Product_Form__c', value);
	                        } },
	                    React.createElement(PicklistItem, { key: '0', value: '', label: 'All' }),
	                    productMeta.Product_Form__c.picklistValues.map(function (a, i) {
	                        return React.createElement(PicklistItem, { key: i + 1, value: a.value, label: a.label });
	                    })
	                ),
	                React.createElement(
	                    Picklist,
	                    { label: productMeta.Container_Type__c.label, value: this.state.Container_Type__c,
	                        onValueChange: function onValueChange(value) {
	                            return _this3.onFieldChange('Container_Type__c', value);
	                        } },
	                    React.createElement(PicklistItem, { key: '0', value: '', label: 'All' }),
	                    productMeta.Container_Type__c.picklistValues.map(function (a, i) {
	                        return React.createElement(PicklistItem, { key: i + 1, value: a.value, label: a.label });
	                    })
	                )
	            )
	        );
	    },

	    render: function render() {
	        var _this4 = this;

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                'div',
	                { className: 'slds-modal slds-fade-in-open', 'aria-hidden': 'false', role: 'dialog' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-modal__container', style: { minWidth: '70rem' } },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__header' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--medium' },
	                            AppManager.getLabel('PP_TIT_PROD_LOOKUP') || 'Product Lookup'
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__content slds-p-around--medium' },
	                        React.createElement(
	                            'div',
	                            null,
	                            this.renderProductSearchForm(),
	                            React.createElement(
	                                'section',
	                                { className: 'slds-clearfix slds-m-top--medium' },
	                                React.createElement(
	                                    'div',
	                                    { className: 'slds-float--right' },
	                                    React.createElement(
	                                        Button,
	                                        { type: 'neutral',
	                                            onClick: function onClick() {
	                                                return _this4.onSearch();
	                                            } },
	                                        AppManager.getLabel('PP_BTN_SEARCH') || 'Search'
	                                    )
	                                )
	                            ),
	                            React.createElement('div', { className: 'slds-m-top--medium' }),
	                            this.renderProductSearchGrid()
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__footer' },
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this4.onCancel();
	                                } },
	                            AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'
	                        ),
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral slds-button--brand',
	                                onClick: function onClick() {
	                                    return _this4.onAdd();
	                                } },
	                            AppManager.getLabel('PP_BTN_ADD') || 'Add'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	        );
	    }
		});

/***/ },

/***/ 657:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var React = __webpack_require__(283);
	var ReactDOM = __webpack_require__(313);
	var Button = __webpack_require__(461).Button;
	var Icon = __webpack_require__(461).Icon;
	var _ = __webpack_require__(202);
	var classNames = __webpack_require__(566);

	var HighlightCells = false;

	/*******************************
	 *  Main component for the Grid page.
	 */
	var PromotionPlanningCalculationGridPage = React.createClass({
	    displayName: 'PromotionPlanningCalculationGridPage',

	    propTypes: {
	        tree: React.PropTypes.object, //MAtrix object for calculation
	        editMode: React.PropTypes.bool //Flag for enabling editing window
	    },

	    getInitialState: function getInitialState() {
	        return {
	            tree: this.props.tree,
	            editMode: this.props.editMode
	        };
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            { className: 'tpm-calc-grid' },
	            this.props.tree == null ? React.createElement(
	                'div',
	                { style: { flex: '1 0 0', paddingTop: '15em' },
	                    className: 'slds-grid slds-grid--vertical-align-center slds-grid--align-center' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-spinner_container' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-spinner--brand slds-spinner slds-spinner--large', 'aria-hidden': 'false',
	                            role: 'alert' },
	                        React.createElement('div', { className: 'slds-spinner__dot-a' }),
	                        React.createElement('div', { className: 'slds-spinner__dot-b' })
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { style: { fontSize: '2em', marginLeft: '2em' } },
	                    'Loading content...'
	                )
	            ) : React.createElement(PromotionPlanningCalculationGrid, { tree: this.props.tree,
	                object: this.props.tree.getRootNode(),
	                editMode: this.props.editMode,
	                idToLabelMapping: this.props.idToLabelMapping,
	                acl: this.props.acl })
	        );
	    }
	});

	/*******************************
	 *  Grid component for the Calculation of KPIs.
	 */
	var PromotionPlanningCalculationGrid = React.createClass({
	    displayName: 'PromotionPlanningCalculationGrid',

	    MAXIMUM_NUMBER_OF_COLUMNS_TO_DISPLAY: 6,

	    propTypes: {
	        tree: React.PropTypes.object, // Reference to the Tree
	        object: React.PropTypes.object, // Reference to the RootNode of the Tree
	        editMode: React.PropTypes.bool // Defines whether the editMode is active or not
	    },

	    getInitialState: function getInitialState() {
	        var maxCols = this.MAXIMUM_NUMBER_OF_COLUMNS_TO_DISPLAY;
	        var timeDetails = this.props.tree.getTimeDetails();
	        var numberOfDataColumns = timeDetails.length; //(excluding the totalcolumn)
	        var dataEndIndex = _.min([numberOfDataColumns, maxCols]);

	        return {
	            dataStartIndex: 0,
	            dataEndIndex: dataEndIndex,
	            numberOfDataColumns: numberOfDataColumns,
	            numberOfColumnsToDisplay: maxCols
	        };
	    },

	    getMaxCols: function getMaxCols() {

	        var MAX_NUMBER_COLS = this.MAXIMUM_NUMBER_OF_COLUMNS_TO_DISPLAY;
	        var maxNumberOfColumns = this.getPossibleDisplayableNumberOfColumns();

	        return _.min([maxNumberOfColumns, MAX_NUMBER_COLS]);
	    },

	    getPossibleDisplayableNumberOfColumns: function getPossibleDisplayableNumberOfColumns() {
	        var sizePerColumn = 110;
	        var assumedUsedPageSize = 550; // does not consider a collapsed sidebar

	        var screenWidth = window.innerWidth;
	        var nodeRect = ReactDOM.findDOMNode(this).getBoundingClientRect();
	        var dataWidth = screenWidth - assumedUsedPageSize - nodeRect.left;

	        return Math.floor(dataWidth / sizePerColumn);
	    },

	    handleResize: function handleResize(e) {
	        this.calculateResizedValues(this.state.numberOfDataColumns);
	    },

	    calculateResizedValues: function calculateResizedValues(numberOfDataColumns) {
	        var maxCols = this.getMaxCols();
	        var dataStartIndex = this.state.dataStartIndex;

	        // update the EndIndex based on the new viewable number of columns and the original StartIndex
	        var dataEndIndex = dataStartIndex + maxCols;

	        // update the StartIndex in case the end of the grid has been reached but more columns could be displayed
	        if (dataEndIndex > numberOfDataColumns) {
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

	    componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
	        if (nextProps.tree !== null && nextProps.tree !== undefined) {
	            var newTimeDetails = nextProps.tree.getTimeDetails();
	            var numberOfDataColumns = newTimeDetails.length;

	            if (this.state.numberOfDataColumns !== numberOfDataColumns) {
	                this.setState({ numberOfDataColumns: numberOfDataColumns });
	                this.calculateResizedValues(numberOfDataColumns);
	            }
	        }
	    },

	    componentDidMount: function componentDidMount() {
	        window.addEventListener('resize', this.handleResize);
	        this.handleResize();
	    },

	    componentDidUpdate: function componentDidUpdate() {
	        HighlightCells = true;
	    },

	    componentWillUnmount: function componentWillUnmount() {
	        window.removeEventListener('resize', this.handleResize);
	    },

	    //Shouldn't be weeks, redundant code.
	    prevWeeks: function prevWeeks() {
	        HighlightCells = false;

	        var dataStartIndex = this.state.dataStartIndex - this.state.numberOfColumnsToDisplay;
	        dataStartIndex = _.max([dataStartIndex, 0]);

	        var dataEndIndex = dataStartIndex + this.state.numberOfColumnsToDisplay;
	        dataEndIndex = _.min([dataEndIndex, this.state.numberOfDataColumns]);

	        this.setState({
	            dataStartIndex: dataStartIndex,
	            dataEndIndex: dataEndIndex
	        });
	    },

	    nextWeeks: function nextWeeks() {
	        HighlightCells = false;

	        var dataStartIndex = this.state.dataStartIndex + this.state.numberOfColumnsToDisplay;
	        dataStartIndex = _.min([dataStartIndex, this.state.numberOfDataColumns]);

	        var dataEndIndex = dataStartIndex + this.state.numberOfColumnsToDisplay;
	        dataEndIndex = _.min([dataEndIndex, this.state.numberOfDataColumns]);

	        this.setState({
	            dataStartIndex: dataStartIndex,
	            dataEndIndex: dataEndIndex
	        });
	    },

	    renderHeader: function renderHeader() {
	        var _this = this;

	        var timeDetails = this.props.tree.getTimeDetails();
	        // Get only a part of the data which shall be visible (excluding the TotalColumn)
	        var shownColumnHeaderValues = timeDetails.slice(this.state.dataStartIndex, this.state.dataEndIndex);
	        var disablePrev = this.state.dataStartIndex === 0;
	        var disableNext = this.state.dataEndIndex === this.state.numberOfDataColumns;

	        // FixMe: Localize the Buttons!
	        return React.createElement(
	            'div',
	            { className: 'grid-header' },
	            React.createElement(
	                'div',
	                { className: 'grid-header-row' },
	                React.createElement(
	                    'div',
	                    { className: 'grid-header-label-cell' },
	                    React.createElement(
	                        Button,
	                        { type: 'neutral', icon: 'chevronleft', size: 'x-small', iconAlign: 'left',
	                            disabled: disablePrev,
	                            onClick: function onClick() {
	                                return _this.prevWeeks();
	                            } },
	                        'Previous'
	                    ),
	                    React.createElement(
	                        Button,
	                        { type: 'neutral', icon: 'chevronright', size: 'x-small', iconAlign: 'left',
	                            disabled: disableNext,
	                            onClick: function onClick() {
	                                return _this.nextWeeks();
	                            } },
	                        'Next'
	                    )
	                ),
	                React.createElement(
	                    'div',
	                    { className: 'grid-header-cell', key: 0 },
	                    React.createElement(ColumnHead, { value: "Total" })
	                ),
	                shownColumnHeaderValues.map(function (columnHeaderValue, columnHeaderIndex) {
	                    return React.createElement(
	                        'div',
	                        { className: 'grid-header-cell', key: columnHeaderIndex },
	                        React.createElement(ColumnHead, {
	                            value: columnHeaderValue.calendaryear + "/" + columnHeaderValue.week })
	                    );
	                })
	            )
	        );
	    },

	    render: function render() {
	        var _this2 = this;

	        var acl = this.props.acl;
	        return React.createElement(
	            'div',
	            { style: { position: 'absolute', height: 100 + '%', display: 'flex', flexDirection: 'column' } },
	            React.createElement(
	                'div',
	                { className: 'grid-table', style: { height: 100 + '%' } },
	                this.renderHeader(),
	                React.createElement(
	                    'div',
	                    { className: 'grid-body  slds-scrollable--y' },
	                    this.props.object.getChildren().map(function (treeNode) {
	                        return React.createElement(PromotionPlanningCalculationRow, {
	                            key: treeNode.id,
	                            treeNode: treeNode,
	                            root: true,
	                            dataStartIndex: _this2.state.dataStartIndex,
	                            dataEndIndex: _this2.state.dataEndIndex,
	                            editMode: _this2.props.editMode,
	                            idToLabelMapping: _this2.props.idToLabelMapping,
	                            editable: acl.isEditable(1, treeNode._measureDefinition.name)
	                        });
	                    })
	                )
	            )
	        );
	    }
	});

	var ColumnHead = React.createClass({
	    displayName: 'ColumnHead',

	    propTypes: {
	        value: React.PropTypes.string // Title of column
	    },

	    render: function render() {
	        return React.createElement(
	            'div',
	            null,
	            this.props.value
	        );
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
	    displayName: 'PromotionPlanningCalculationRow',

	    propTypes: {
	        dataStartIndex: React.PropTypes.number,
	        dataEndIndex: React.PropTypes.number,
	        editMode: React.PropTypes.bool,
	        root: React.PropTypes.bool, // Indicates if this element is the root of the grid-rows
	        treeNode: React.PropTypes.object, //Matrix.js object
	        parentUpdate: React.PropTypes.func // Function to update the parent
	    },

	    getInitialState: function getInitialState() {
	        return {
	            opened: false,
	            version: 0
	        };
	    },

	    toggle: function toggle() {
	        this.setState({ opened: !this.state.opened });
	    },

	    update: function update() {
	        this.setState({ version: this.state.version + 1 });

	        // If the method to update the parent node is specified execute it
	        if (this.props.parentUpdate) {
	            this.props.parentUpdate();
	        } else {
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
	    getLevel: function getLevel() {
	        return this.props.treeNode.getLevel() + 1;
	    },

	    componentDidMount: function componentDidMount() {
	        if (this.props.root) {
	            rootLevelNodes.push([this, this.props.treeNode.getMeasureDefinition().name]);
	        }
	    },

	    createPadders: function createPadders(currentLevel) {
	        var padders = [];

	        for (var i = 1; i < currentLevel; i++) {
	            padders.push(React.createElement('div', { key: i, className: 'padder' }));
	        }

	        return padders;
	    },

	    createChildSelector: function createChildSelector() {
	        var childSelector = null;

	        if (this.props.treeNode.showChildren()) {
	            childSelector = this.state.opened ? React.createElement(Icon, { key: 'open', className: 'handler', icon: 'chevrondown', size: 'x-small' }) : React.createElement(Icon, { key: 'closed', className: 'handler', icon: 'chevronright', size: 'x-small' });
	        }

	        return childSelector;
	    },

	    renderLabelCell: function renderLabelCell(level) {
	        var _this3 = this;

	        var nodeLabel = this.props.treeNode.getLabel();

	        //root labels are coming from configuration itself

	        // if (boPromotion) {
	        //   var text = boPromotion.LOExtProduct.getLabel(nodeLabel);
	        if (this.props.idToLabelMapping) {
	            var text = this.props.idToLabelMapping[nodeLabel];
	            if (text == undefined) text = '#' + nodeLabel;
	        } else text = '#' + nodeLabel;
	        var padders = this.createPadders(level);
	        var childSelector = this.createChildSelector();

	        return React.createElement(
	            'div',
	            { className: 'sub-row' },
	            padders,
	            React.createElement(
	                'div',
	                { className: 'label-cell', onClick: function onClick() {
	                        return _this3.toggle();
	                    } },
	                React.createElement(
	                    'span',
	                    null,
	                    childSelector,
	                    ' ',
	                    text
	                )
	            )
	        );
	    },

	    renderValueCells: function renderValueCells(treeNode, showData) {
	        var _this4 = this;

	        var version = this.state.version;
	        var Rounding = treeNode.getRounding();
	        return showData.map(function (cellValue, cellIndex) {
	            var correctedCellIndex = cellIndex + _this4.props.dataStartIndex;
	            return React.createElement(
	                'div',
	                { className: 'data-cell', key: treeNode.id + "." + correctedCellIndex },
	                React.createElement(PromotionPlanningCalculationCell, {
	                    className: 'cellValue',
	                    precision: Rounding,
	                    value: cellValue,
	                    editable: _this4.props.editMode && _this4.props.editable && treeNode.isEditAllowed(correctedCellIndex),
	                    version: version,
	                    setter: function setter(value) {
	                        treeNode.set(correctedCellIndex, value);
	                        _this4.update();
	                    } })
	            ); //TODO
	        });
	    },

	    render: function render() {
	        var _this5 = this;

	        var treeNode = this.props.treeNode;
	        var data = treeNode.getData();

	        var showData = data.slice(this.props.dataStartIndex + 1, this.props.dataEndIndex + 1);
	        showData.unshift(data[0]);

	        var level = this.getLevel();

	        var rowClassName = 'level' + level + '-row row';
	        var measureEAR = this.props.editable;
	        var currentRow = !treeNode.showInUI() ? null : React.createElement(
	            'div',
	            { className: rowClassName },
	            this.renderLabelCell(level),
	            this.renderValueCells(treeNode, showData)
	        );

	        var childrenRows = this.state.opened ? this.props.treeNode.getChildren().map(function (childNode) {
	            return React.createElement(PromotionPlanningCalculationRow, {
	                key: childNode.id,
	                treeNode: childNode,
	                root: false,
	                dataStartIndex: _this5.props.dataStartIndex,
	                dataEndIndex: _this5.props.dataEndIndex,
	                parentUpdate: _this5.update,
	                editMode: _this5.props.editMode,
	                idToLabelMapping: _this5.props.idToLabelMapping,
	                editable: measureEAR
	            });
	        }) : null;

	        return currentRow ? React.createElement(
	            'statelessWrapper',
	            null,
	            currentRow,
	            childrenRows
	        ) : null;
	    }
	});

	/*******************************
	 *  Cell component for the Calculation grid.
	 */
	var PromotionPlanningCalculationCell = React.createClass({
	    displayName: 'PromotionPlanningCalculationCell',

	    propTypes: {
	        className: React.PropTypes.string,
	        precision: React.PropTypes.number,
	        editable: React.PropTypes.bool,
	        version: React.PropTypes.number,
	        setter: React.PropTypes.func,
	        value: React.PropTypes.number
	    },

	    getInitialState: function getInitialState() {
	        return {
	            clickedOn: false,
	            value: this.props.value,
	            version: this.props.version
	        };
	    },

	    close: function close() {
	        var newValue = parseFloat(this.state.value);
	        if (Number.isNaN(newValue)) {
	            newValue = null;
	        }

	        if (newValue + '' != this.props.value) {
	            this.props.setter(newValue);
	        }
	        this.setState({ clickedOn: false });
	    },

	    componentWillReceiveProps: function componentWillReceiveProps(next) {
	        if (this.props.value != next.value && HighlightCells) {
	            var node = ReactDOM.findDOMNode(this);
	            node = this.props.rowCell ? node : node.parentNode;
	            node.className += " HighlightedCell";
	            setTimeout(function () {
	                return node.className = node.className.replace(" HighlightedCell", "");
	            }, 1500);
	        }
	        this.setState({
	            value: next.value,
	            version: next.version
	        });
	    },

	    componentDidUpdate: function componentDidUpdate() {
	        if (this.state.clickedOn) {
	            ReactDOM.findDOMNode(this.refs.inputCell).focus();
	        }
	    },

	    changeValue: function changeValue(event) {
	        this.setState({ value: event.target.value });
	    },

	    closeOnEnterKey: function closeOnEnterKey(event) {
	        if (event.key == "Enter") {
	            this.close();
	        }
	    },

	    onKeyPress: function onKeyPress(e) {
	        Utils.Validators.onlyKeyEventNumber(e);
	    },

	    setAsClickedIfEditable: function setAsClickedIfEditable() {
	        return this.props.editable && this.setState({ clickedOn: true });
	    },

	    render: function render() {
	        var props = this.props;
	        var resultElement;

	        if (this.state.clickedOn) {
	            var inputValue = '';
	            if (this.state.value !== null && this.state.value !== undefined && !isNaN(this.state.value)) {
	                inputValue = Utils.Converters.NumberRound(this.state.value, props.precision);
	            }

	            resultElement = React.createElement(
	                'div',
	                { className: classNames(props.className) },
	                React.createElement('input', { type: 'text', ref: 'inputCell',
	                    value: inputValue, size: '8',
	                    className: 'EdiCellInput',
	                    onKeyDown: this.closeOnEnterKey,
	                    onBlur: this.close,
	                    onKeyPress: this.onKeyPress,
	                    onChange: this.changeValue })
	            );
	        } else {
	            var displayValue = '';
	            if (this.state.value !== null && this.state.value !== undefined && !isNaN(this.state.value)) {
	                displayValue = Utils.Formatters.formatNumber(this.state.value, this.props.precision, this.props.precision);
	            } else {
	                displayValue = '\xA0\xA0\xA0\xA0\xA0';
	            }

	            resultElement = React.createElement(
	                'span',
	                { className: classNames(props.className, { 'editableValue': props.editable }),
	                    onClick: this.setAsClickedIfEditable },
	                displayValue
	            );
	        }

	        return resultElement;
	    }
	});

		module.exports = PromotionPlanningCalculationGridPage;

/***/ },

/***/ 658:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	module.exports = React.createClass({
	    displayName: 'MessagePopup',

	    componentDidMount: function componentDidMount() {},

	    render: function render() {
	        var _this = this;

	        var message = this.props.message;

	        if (this.props.messagejson != '') {
	            var jsonTable = '';
	            var jsonVar = [];
	            var jsonParsed = JSON.parse(this.props.messagejson);
	            for (var x in jsonParsed) {
	                jsonVar.push(jsonParsed[x]);
	            }

	            jsonTable += '<div class="bPageBlock brandSecondaryBrd apexDefaultPageBlock secondaryPalette">';
	            jsonTable += '<div class="pbBody">';
	            jsonTable += '<table border="0" cellpadding="0" cellspacing="0" class="list">';
	            jsonTable += '<colgroup span="' + jsonVar.length + '"></colgroup>';
	            jsonTable += '<thead class="">';
	            jsonTable += '<tr class="headerRow">';
	            for (var key in jsonVar[0]) {
	                jsonTable += '<th class="headerRow" style="text-transform: capitalize;" scope="col" colspan="1">' + key + '</th>';
	            }
	            jsonTable += '<tr></thead>';

	            jsonTable += '<tbody>';
	            for (var i = 0; i < jsonVar.length - 1; i++) {
	                jsonTable += '<tr class=" dataRow odd " onmouseover="if (window.hiOn){hiOn(this);} " onmouseout="if (window.hiOff){hiOff(this);} " onblur="if (window.hiOff){hiOff(this);}" onfocus="if (window.hiOn){hiOn(this);}">';
	                for (var key in jsonVar[i]) {
	                    jsonTable += '<td class="dataCell" colspan="1">' + jsonVar[i][key] + '</td>';
	                }
	                jsonTable += '<tr>';
	            }
	            jsonTable += '</tbody>';
	            jsonTable += '</table>';
	            jsonTable += '</div>';
	            jsonTable += '</div>';
	            message += jsonTable;
	        }

	        return React.createElement(
	            'div',
	            null,
	            React.createElement(
	                'div',
	                { 'aria-hidden': 'false', 'aria-labelledby': 'prompt-heading-id', 'aria-describedby': 'prompt-message-wrapper',
	                    role: 'alertdialog', className: 'slds-modal slds-modal--prompt slds-fade-in-open' },
	                React.createElement(
	                    'div',
	                    { className: 'slds-modal__container slds-modal--prompt', role: 'document',
	                        id: 'prompt-message-wrapper', tabIndex: '0' },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__header slds-theme--warning slds-theme--alert-texture' },
	                        React.createElement(
	                            'h2',
	                            { className: 'slds-text-heading--medium', id: 'prompt-heading-id' },
	                            this.props.title
	                        )
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__content slds-p-around--medium' },
	                        React.createElement('div', { dangerouslySetInnerHTML: { __html: message } })
	                    ),
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__footer slds-theme--default' },
	                        React.createElement(
	                            'button',
	                            { className: 'slds-button slds-button--neutral',
	                                onClick: function onClick() {
	                                    return _this.props.cancelHandler();
	                                } },
	                            AppManager.getLabel("PP_BTN_CANCEL") || 'Cancel'
	                        )
	                    )
	                )
	            ),
	            React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	        );
	    }
		});

/***/ },

/***/ 659:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	module.exports = React.createClass({
	    displayName: 'exports',

	    getInitialState: function getInitialState() {
	        return {
	            messages: [],
	            updateToggleFlag: false
	        };
	    },

	    componentDidMount: function componentDidMount() {
	        UI_EVENT_BUS.subscribe(EVENTS.UI_ERROR, this.onUIError);
	    },

	    onUIError: function onUIError(error) {
	        this.state.messages.push(error);
	        this.setState({ updateToggleFlag: !this.state.updateToggleFlag });
	    },

	    onClick: function onClick() {
	        this.state.messages.shift();
	        this.setState({ updateToggleFlag: !this.state.updateToggleFlag });
	    },

	    render: function render() {
	        if (this.state.messages.length == 0) {
	            return null;
	        } else {
	            var message = this.state.messages[0];
	            var msgLines = message.message.split('\n');

	            var headerCls = message.type == 'E' ? 'error' : 'warning';

	            return React.createElement(
	                'div',
	                null,
	                React.createElement(
	                    'div',
	                    { 'aria-hidden': 'false', 'aria-labelledby': 'prompt-heading-id',
	                        'aria-describedby': 'prompt-message-wrapper',
	                        role: 'alertdialog', className: 'slds-modal slds-modal--prompt slds-fade-in-open',
	                        style: { zIndex: 9003 } },
	                    React.createElement(
	                        'div',
	                        { className: 'slds-modal__container slds-modal--prompt', role: 'document',
	                            id: 'prompt-message-wrapper', tabIndex: '0', style: { width: '30rem', textAlign: 'center' } },
	                        React.createElement(
	                            'div',
	                            {
	                                className: 'slds-modal__header slds-theme--' + headerCls + ' slds-theme--alert-texture' },
	                            React.createElement(
	                                'h2',
	                                { className: 'slds-text-heading--medium', id: 'prompt-heading-id' },
	                                message.title
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-modal__content slds-p-around--medium' },
	                            React.createElement(
	                                'div',
	                                null,
	                                msgLines.map(function (msg) {
	                                    return React.createElement(
	                                        'p',
	                                        null,
	                                        msg
	                                    );
	                                })
	                            )
	                        ),
	                        React.createElement(
	                            'div',
	                            { className: 'slds-modal__footer slds-theme--default' },
	                            React.createElement(
	                                'button',
	                                { className: 'slds-button slds-button--neutral',
	                                    onClick: this.onClick },
	                                ' Ok'
	                            )
	                        )
	                    )
	                ),
	                React.createElement('div', { className: 'slds-backdrop slds-backdrop--open' })
	            );
	        }
	    }
		});

/***/ },

/***/ 660:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var React = __webpack_require__(283);

	module.exports = React.createClass({
	    displayName: 'exports',


	    getInitialState: function getInitialState() {
	        return {
	            page: null
	        };
	    },
	    componentDidMount: function componentDidMount() {
	        ReactDOM.render(React.createElement(Modal), document.getElementById('modal'));
	        var me = this;
	        window.onhashchange = function () {
	            me.processHashUrl(window.location.hash.substring(1));
	        };

	        this.processHashUrl(window.location.hash.substring(1));
	    },

	    processHashUrl: function processHashUrl(hash) {
	        var params = hash.split('/');
	        hash = params[0];
	        params = params.slice(1);

	        switch (hash) {

	            case 'PromotionCalendar':
	                this.loadPage('PromotionCalendar', 'BOExtPromotionCalendar', params); //This could be optimized by naming convention
	                break;

	            case 'PromotionPlanning':
	            default:
	                this.loadPage('PromotionPlanning', 'BOPromotion', params); //This could be optimized by naming convention
	                break;

	        }
	    },

	    //Generic method for loading pages
	    loadPage: function loadPage(controllerId, boId, params) {
	        this.setState({ page: controllerId });
	        AppManager.load([boId]).then(function (res) {
	            BOFactory.instantiate(boId, params);
	        });
	    },

	    render: function render() {
	        if (this.state.page == null) return null;else return React.createElement(window[this.state.page]);
	    }
		});

/***/ }

});
//# sourceMappingURL=ui.js.map