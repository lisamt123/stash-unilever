"use strict";


global.APEXAbstraction = require('./apex-abstraction_bl');
global.BOPromotionMock = require('./bopromotionmock');
global.LOTacticMock = require('./lotacticmock');
global.LOAccountMock = require('./loaccountmock');
global.LOExtProductMock = require('./loextproductmock');
global.LOExtProductFilterMock = require('./loextproductfiltermock');
global.LOFilteredProductsMock = require('./lofilteredproductsmock');
global.LOExtChartValuesMock = require('./loextchartvaluesmock');
global.LOFundMock = require('./lofundmock');
global.LOFilteredFundsMock = require('./lofilteredfundsmock');
global.LOTactic_TemplateMock = require('./lotactictemplatemock'); 
global.LOPromotion_TemplateMock = require('./lopromotiontemplatemock');

global.LOExtPrdFiltersMock = require('./loextprdfiltersmock');
global.LOTacticProductFilterMock = require('./lotacticproductfiltermock');

global.LOExtPromotionGridMock = require('./loextpromotiongridmock');
global.MetaDataService = require('./metadata').MetaDataService;
global.LogConfigMock = require('./logconfigmock');

//--> Remove the mocks
//global.LogService = require('./logservice').LogService; 
//global.MetaDataService = require('./metadata').MetaDataService;

global.LOCalendarViewMock = require('./localendarviewmock');
global.LOCalPromotionsMock = require('./localpromotionsmock');
global.LOExtFiscalYearMock = require('./loextfiscalyearmock');
global.LOAccountSetMock = require('./loaccountsetmock');
global.LOExtHoverContentMock = require('./loexthovercontentmock');

global.Tree = require("../ui/calculationgrid/tree.js");
global.LOExtChildAccountsMock = require('./loextchildaccountsmock');
global.LOExtPromotionAttachmentMock = require('./loextpromotionattachmentmock');
global.LOExtTacticTiersMock = require('./loexttactictiersmock');