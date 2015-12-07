/**
 * import base stylings first
 *
 */
/**
 * Create fonts as placeholders in this file
 *
 * eg.,
 * %aBoldFont {
 *     font-size: 20px;
 *     font-weight: bold;
 *
 * }
 */
.report .report-header, .cOV_ShelfTileContent .heading, .cOV_ReportKPIs .heading, .cOV_ShelfTileContent .reportItem .details-title, .cOV_ReportKPIs .reportItem .details-title {
  font-size: 16px;
  font-weight: bold; }

/**
 * Import individual components here
 */
.OVBS .nav {
  background-color: #F2F2F2; }

.OVBS .nav-tabs > li {
  text-align: center;
  display: inline-block;
  float: none; }

.OVBS .nav-tabs > li > a, .OVBS .nav-tabs > li > a:hover, .OVBS .nav-tabs > li > a:focus {
  box-sizing: border-box;
  border-color: transparent;
  background-color: transparent;
  color: #666666; }

.OVBS .nav-tabs > li.active > a, .OVBS .nav-tabs > li.active > a:hover, .OVBS .nav-tabs > li.active > a:focus {
  box-sizing: border-box;
  border-color: transparent;
  border-bottom: 5px solid #2a94d6;
  background-color: transparent;
  color: #2a94d6;
  font-weight: bold; }

.OVBS .tab-content.cOV_TabContent {
  padding: 0 15px; }

.OVBS {
  background-color: #FFFFFF; }
  .OVBS .clickable {
    cursor: pointer; }

.bootstrap-sf1.OVBS, .bootstrap-sf1 .OVBS, .OVBS .bootstrap-sf1 {
  font-family: 'Unilever'; }

.hidden {
  display: none;
  visibility: hidden; }

.report .report-header {
  padding: 10px;
  box-sizing: border-box;
  border-bottom: 1px solid #CCCCCC;
  background-color: #FFFFFF; }
  .report .report-header .col-xs-12 {
    position: relative; }
  .report .report-header .link-icon {
    position: absolute;
    top: 0;
    right: 15px;
    font-weight: normal; }
    .report .report-header .link-icon img {
      margin-left: 10px;
      max-height: 32px;
      max-width: 32px; }
  .report .report-header .icon {
    width: 32px;
    height: 32px;
    display: inline-block;
    color: #FFFFFF;
    font-size: 32px;
    line-height: 32px;
    background-color: #e37325;
    vertical-align: middle;
    border-radius: 4px;
    margin: 0 8px 0 0;
    float: left; }
    .OV_phone .report .report-header .icon {
      width: 32px;
      height: 32px;
      font-size: 32px;
      line-height: 32px; }
  .report .report-header .title {
    font-size: 16pt;
    line-height: 32px; }
.report .nav {
  background-color: #F2F2F2; }
.report .nav-tabs {
  border-bottom: 2px solid #CCCCCC;
  font-size: 14px; }
.report .nav-tabs > li, .report .nav-tabs > li:hover, .report .nav-tabs > li:focus {
  box-sizing: border-box;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  background-color: transparent; }
.report .nav-tabs > li.active, .report .nav-tabs > li.active:hover, .report .nav-tabs > li.active:focus {
  box-sizing: border-box;
  background-color: #FFFFFF;
  margin-bottom: -2px;
  border-bottom: 2px solid #FFFFFF;
  border-top: 1px solid #CCCCCC;
  border-left: 1px solid #CCCCCC;
  border-right: 1px solid #CCCCCC;
  margin-top: -1px; }
.report .nav-tabs > li > a, .report .nav-tabs > li > a:hover, .report .nav-tabs > li > a:focus {
  font-weight: normal;
  color: #666666;
  border-bottom: none;
  font-size: 10px; }
.report .nav-tabs > li.active > a, .report .nav-tabs > li.active > a:hover, .report .nav-tabs > li.active > a:focus {
  color: #b6bf34;
  font-weight: bold;
  border-bottom: none; }
.report .dates {
  margin-top: 20px;
  margin-bottom: 20px;
  display: block; }
  .OV_desktop .report .dates .col-xs-4 {
    margin-top: 10px;
    width: 16.666667%; }
  .report .dates .col-xs-4:first-child {
    border-right: 1px solid #CCCCCC; }
  .report .dates .col-xs-4:nth-child(2) {
    border-left: 1px solid #CCCCCC;
    border-right: 1px solid #CCCCCC;
    margin: 0 -1px; }
  .report .dates .col-xs-4:nth-child(3) {
    border-left: 1px solid #CCCCCC; }
  .OV_phone .report .dates .col-xs-6.clear {
    clear: both; }
  .OV_tablet .report .dates .col-xs-6, .OV_phone .report .dates .col-xs-6 {
    margin-top: 10px; }
  .OV_desktop .report .dates .col-xs-6 {
    width: 25%; }
.report .people {
  margin-bottom: 20px; }
.report .dates span, .report .people span {
  font-size: 13px;
  font-weight: bold;
  display: block; }
  .report .dates span.small, .report .people span.small {
    font-size: 11px;
    font-weight: normal; }
  .OV_tablet .report .dates span, .OV_desktop .report .dates span, .OV_tablet .report .people span, .OV_desktop .report .people span {
    font-size: 11pt; }
    .OV_tablet .report .dates span.small, .OV_desktop .report .dates span.small, .OV_tablet .report .people span.small, .OV_desktop .report .people span.small {
      font-size: 11pt; }
.report .avatar {
  margin-right: 10px;
  height: 45px;
  width: 45px; }
  .OV_tablet .report .avatar, .OV_desktop .report .avatar {
    margin-top: 10px; }
.report .avatar-desc {
  margin-top: 10px;
  padding-left: 55px; }
  .report .avatar-desc .avatar-name {
    font-size: 11px;
    color: #b6bf34; }
    .OV_tablet .report .avatar-desc .avatar-name, .OV_desktop .report .avatar-desc .avatar-name {
      font-size: 11pt; }
.report .report-details-content {
  padding: 0 15px;
  background-color: #FFFFFF; }
  .OV_tablet .report .report-details-content, .OV_desktop .report .report-details-content {
    font-size: 14pt; }
.report.report-desktop {
  padding: 15px; }
.report .report-preview {
  padding: 15px 0; }
  .report .report-preview img {
    max-width: 100%; }

.post-button {
  background-color: #2a94d6 !important; }
  .post-button span {
    color: #FFFFFF !important;
    opacity: 0.5; }

.cShelf-title {
  padding: 15px 0 0;
  width: 100%;
  color: #284973;
  font-size: 18px;
  font-weight: bold;
  text-transform: uppercase; }
  .OV_phone .cShelf-title {
    line-height: 64px;
    height: 64px;
    font-size: 15pt;
    font-weight: normal; }
  .OV_tablet .cShelf-title {
    font-size: 16pt; }

.cOV_ShelfTile-base {
  min-height: 44px;
  box-sizing: border-box;
  padding: 10px;
  border-bottom: 1px solid #CCCCCC;
  cursor: pointer;
  vertical-align: top;
  background-color: #FFFFFF; }
  .OV_tablet .cOV_ShelfTile-base {
    padding: 8pt; }
  .cOV_ShelfTile-base .cOV_ShelfTile-icon {
    display: inline-block;
    width: 32px;
    height: 32px;
    margin: 0 10px 0 0;
    color: #FFFFFF;
    font-size: 32px;
    line-height: 32px;
    background-color: #e37325;
    vertical-align: middle;
    border-radius: 4px; }
    .OV_phone .cOV_ShelfTile-base .cOV_ShelfTile-icon {
      font-size: 32px;
      line-height: 32px; }
  .cOV_ShelfTile-base .cOV_ShelfTile-iconBig {
    display: none;
    visibility: hidden;
    opacity: 0.2; }
  .cOV_ShelfTile-base .cOV_ShelfTile-title {
    display: inline-block;
    vertical-align: top;
    line-height: 1;
    font-size: 16px;
    font-weight: bold; }
  .cOV_ShelfTile-base .cOV_ShelfTile-viewTally {
    visibility: hidden;
    display: none;
    float: right;
    margin: 8px 10px;
    font-size: 26px;
    padding: 3px;
    color: #ffffff; }

.shelfTile-contentTitle .heading {
  background-color: #FFFFFF; }
  .OV_desktop .shelfTile-contentTitle .heading {
    display: none; }
  .OV_phone .shelfTile-contentTitle .heading .title {
    line-height: 32px; }
  .OV_tablet .shelfTile-contentTitle .heading .title {
    line-height: 32px; }
  .OV_phone .shelfTile-contentTitle .heading .title {
    font-size: 16pt; }
  .OV_tablet .shelfTile-contentTitle .heading .title {
    font-size: 16pt; }

.shelfTile-contentList .col-tile {
  background-color: #FFFFFF; }

.OV_desktop .cOV_ShelfTile-base {
  width: 150px;
  height: 100px; }
.OV_desktop .cOV_ShelfTile-iconBig {
  top: -20%;
  right: -60px;
  font-size: 700%; }

.OV_tablet .cOV_ShelfTile-base {
  width: 140px;
  height: 110px;
  padding: 8px; }
  .OV_tablet .cOV_ShelfTile-base .cOV_ShelfTile-title {
    font-size: 14pt; }
.OV_tablet .cOV_ShelfTile-iconBig {
  top: -20%;
  right: -60px;
  font-size: 750%; }

.OV_phone .cOV_ShelfTile-base .cOV_ShelfTile-title {
  font-size: 15pt;
  font-weight: bold;
  line-height: 32px; }

.OV_desktop .cOV_ShelfTile-reportsContainer {
  margin: 5px 0 10px; }

.OV_desktop .cOV_ShelfTile-reportsContainer .shelfTile-contentList, .OV_tablet .cOV_ShelfTile-reportsContainer .shelfTile-contentList {
  background-color: #F2F2F2;
  border: 1px solid #CCCCCC; }
  .OV_desktop .cOV_ShelfTile-reportsContainer .shelfTile-contentList .col-tile:not(.reportItem), .OV_tablet .cOV_ShelfTile-reportsContainer .shelfTile-contentList .col-tile:not(.reportItem) {
    background-color: #F2F2F2; }
.OV_desktop .reportListShown .cOV_ShelfTile-base, .OV_tablet .reportListShown .cOV_ShelfTile-base {
  background-color: #FFFFFF;
  color: #e37325; }
  .OV_desktop .reportListShown .cOV_ShelfTile-base .cOV_ShelfTile-icon, .OV_tablet .reportListShown .cOV_ShelfTile-base .cOV_ShelfTile-icon {
    color: rgba(227, 115, 37, 0.35); }
.OV_desktop .cOV_ShelfTile-base, .OV_tablet .cOV_ShelfTile-base {
  position: relative;
  display: inline-block;
  box-sizing: border-box;
  border: none;
  overflow: hidden;
  background-color: #e37325;
  color: #FFFFFF;
  border: 2px solid #e37325;
  font-size: 20px;
  font-weight: 700;
  border-radius: 5px;
  box-shadow: 0px 0px 8px 2px rgba(102, 102, 102, 0.25); }
  .OV_desktop .cOV_ShelfTile-base .cOV_ShelfTile-icon, .OV_tablet .cOV_ShelfTile-base .cOV_ShelfTile-icon {
    display: none;
    visibility: hidden; }
  .OV_desktop .cOV_ShelfTile-base .cOV_ShelfTile-iconBig, .OV_tablet .cOV_ShelfTile-base .cOV_ShelfTile-iconBig {
    display: block;
    visibility: visible;
    position: absolute;
    height: auto;
    width: auto;
    background-color: transparent; }
  .OV_desktop .cOV_ShelfTile-base .cOV_ShelfTile-viewTally, .OV_tablet .cOV_ShelfTile-base .cOV_ShelfTile-viewTally {
    font-weight: normal;
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    margin: 0;
    visibility: hidden;
    display: none;
    float: none;
    padding: 5px 10px; }
    .OV_desktop .cOV_ShelfTile-base .cOV_ShelfTile-viewTally .glyphicon, .OV_tablet .cOV_ShelfTile-base .cOV_ShelfTile-viewTally .glyphicon {
      margin-right: 10px; }

.col-tile {
  float: left; }
  .OV_tablet .col-tile {
    padding: 5px 0px 10px 15px; }
  .OV_desktop .col-tile {
    padding: 5px 0px 10px 15px; }
  .OV_phone .col-tile {
    width: 100%; }

/* 
@media only screen and (max-width: 767px) {
    .col-tile{
        width: 100%;
    }
} */
.OV_phone.cOV_ShelfTileContent .heading .icon {
  width: 32px;
  height: 32px;
  font-size: 32px;
  line-height: 32px; }

.OV_phone.cOV_ShelfTileContent .details, .OV_phone .cOV_ReportKPIs .details {
  position: relative; }
  .OV_phone.cOV_ShelfTileContent .details .link-icon, .OV_phone .cOV_ReportKPIs .details .link-icon {
    position: absolute;
    top: 0;
    left: -32px; }
    .OV_phone.cOV_ShelfTileContent .details .link-icon img, .OV_phone .cOV_ReportKPIs .details .link-icon img {
      max-width: 20px; }

.OV_tablet.cOV_ShelfTileContent .details .link-icon, .OV_tablet .cOV_ReportKPIs .details .link-icon {
  position: absolute;
  top: 8px;
  right: 8px; }
  .OV_tablet.cOV_ShelfTileContent .details .link-icon img, .OV_tablet .cOV_ReportKPIs .details .link-icon img {
    max-width: 20px; }
.OV_tablet.cOV_ShelfTileContent .details .details-title, .OV_tablet .cOV_ReportKPIs .details .details-title {
  height: 44px;
  padding-right: 33px; }

.OV_desktop.cOV_ShelfTileContent .details .link-icon, .OV_desktop .cOV_ReportKPIs .details .link-icon {
  position: absolute;
  top: 10px;
  right: 10px; }
  .OV_desktop.cOV_ShelfTileContent .details .link-icon img, .OV_desktop .cOV_ReportKPIs .details .link-icon img {
    max-width: 20px; }
.OV_desktop.cOV_ShelfTileContent .details .details-title, .OV_desktop .cOV_ReportKPIs .details .details-title {
  height: 44px;
  padding-right: 25px; }

.cOV_ShelfTileContent, .cOV_ReportKPIs {
  box-sizing: border-box; }
  .cOV_ShelfTileContent .heading, .cOV_ReportKPIs .heading {
    width: 100%;
    height: 100px;
    padding: 10px;
    box-sizing: border-box;
    border-bottom: 1px solid #CCCCCC;
    /*         @media only screen and (min-width: 768px) {
            display: none;
        } */ }
    .cOV_ShelfTileContent .heading .icon, .cOV_ReportKPIs .heading .icon {
      width: 32px;
      height: 32px;
      display: inline-block;
      margin: 10px 10px 10px 10px;
      color: #FFFFFF;
      font-size: 32px;
      line-height: 32px;
      background-color: #e37325;
      vertical-align: middle;
      margin: 0 8px 0 15px;
      float: left;
      border-radius: 4px; }
  .cOV_ShelfTileContent .reportItem, .cOV_ReportKPIs .reportItem {
    width: 100%;
    height: 100px;
    padding: 10px;
    padding-left: 60px;
    box-sizing: border-box;
    border-bottom: 1px solid #CCCCCC;
    vertical-align: top;
    background-color: #FFFFFF; }
    .cOV_ShelfTileContent .reportItem .trend, .cOV_ReportKPIs .reportItem .trend {
      /**
             * Hide this until we have the data
             */
      display: none;
      margin-top: 20px;
      text-align: right;
      float: right; }
    .cOV_ShelfTileContent .reportItem .trend-direction, .cOV_ReportKPIs .reportItem .trend-direction {
      display: inline-block;
      width: 24px;
      height: 24px;
      border-radius: 100%;
      background-color: orange; }
    .cOV_ShelfTileContent .reportItem .trend-value, .cOV_ReportKPIs .reportItem .trend-value {
      font-size: 28px;
      font-weight: bold; }
    .cOV_ShelfTileContent .reportItem .trend-unit, .cOV_ReportKPIs .reportItem .trend-unit {
      font-size: 10px;
      text-align: center;
      color: #CCCCCC; }
    .cOV_ShelfTileContent .reportItem .details-title, .cOV_ReportKPIs .reportItem .details-title {
      margin: 0 0 5px;
      max-width: 100%;
      text-overflow: ellipsis;
      overflow: hidden;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      display: block;
      display: -webkit-box; }
      .OV_tablet .cOV_ShelfTileContent .reportItem .details-title, .cOV_ShelfTileContent .reportItem .details-title .OV_desktop, .OV_tablet .cOV_ReportKPIs .reportItem .details-title, .cOV_ReportKPIs .reportItem .details-title .OV_desktop {
        height: 44px; }
      .OV_desktop .cOV_ShelfTileContent .reportItem .details-title, .OV_desktop .cOV_ReportKPIs .reportItem .details-title {
        padding-right: 25px; }
      .OV_tablet .cOV_ShelfTileContent .reportItem .details-title, .OV_tablet .cOV_ReportKPIs .reportItem .details-title {
        padding-right: 33px; }
    .cOV_ShelfTileContent .reportItem .details-published, .cOV_ShelfTileContent .reportItem .details-owner, .cOV_ShelfTileContent .reportItem .details-social, .cOV_ReportKPIs .reportItem .details-published, .cOV_ReportKPIs .reportItem .details-owner, .cOV_ReportKPIs .reportItem .details-social {
      margin-bottom: 5px;
      font-size: 10px;
      color: #CCCCCC; }
    .cOV_ShelfTileContent .reportItem .details-published-date, .cOV_ShelfTileContent .reportItem .details-owner-author, .cOV_ReportKPIs .reportItem .details-published-date, .cOV_ReportKPIs .reportItem .details-owner-author {
      color: #000000; }
    .cOV_ShelfTileContent .reportItem .details-reporting-period, .cOV_ReportKPIs .reportItem .details-reporting-period {
      font-weight: bold;
      color: #000000; }
    .cOV_ShelfTileContent .reportItem .details-social, .cOV_ReportKPIs .reportItem .details-social {
      /**
             * Hide this until we have the data
             */
      display: block; }
      .cOV_ShelfTileContent .reportItem .details-social .details-social-favourite, .cOV_ReportKPIs .reportItem .details-social .details-social-favourite {
        padding: 5px 20px 15px 5px;
        margin: -5px -20px -15px -10px;
        float: left;
        color: #e37325; }
        .cOV_ShelfTileContent .reportItem .details-social .details-social-favourite > span, .cOV_ReportKPIs .reportItem .details-social .details-social-favourite > span {
          font-size: 25px; }

.OV_tablet .cOV_ShelfTileContent.shelfTileContent_wrapper, .OV_tablet .cOV_ReportKPIs.shelfTileContent_wrapper {
  padding: 0 15px; }

.OV_desktop .shelfTile-contentList {
  padding: 10px 0 5px; }

.OV_tablet .shelfTile-contentList {
  padding: 0 15px; }

.OV_tablet.cOV_ShelfTileContent .heading, .OV_tablet.cOV_ReportKPIs .heading {
  padding: 15px; }

.OV_desktop.cOV_ShelfTileContent .heading, .OV_desktop.cOV_ReportKPIs .heading {
  padding-left: 10px; }

.OV_tablet.cOV_ShelfTileContent .heading, .OV_tablet .cOV_ReportKPIs .heading, .OV_desktop.cOV_ShelfTileContent .heading, .OV_desktop .cOV_ReportKPIs .heading {
  padding-left: 10px;
  box-sizing: border-box;
  border-width: 0; }
.OV_tablet.cOV_ShelfTileContent .reportItem, .OV_tablet .cOV_ReportKPIs .reportItem, .OV_desktop.cOV_ShelfTileContent .reportItem, .OV_desktop .cOV_ReportKPIs .reportItem {
  width: 175px;
  height: 110px;
  position: relative;
  display: inline-block;
  padding-left: 10px;
  border: 2px solid #e37325;
  border-bottom-width: 7px;
  border-radius: 5px;
  background-color: #FFFFFF;
  box-shadow: 0px 0px 8px 2px rgba(102, 102, 102, 0.25); }
  .OV_tablet.cOV_ShelfTileContent .reportItem .icon, .OV_tablet .cOV_ReportKPIs .reportItem .icon, .OV_desktop.cOV_ShelfTileContent .reportItem .icon, .OV_desktop .cOV_ReportKPIs .reportItem .icon {
    display: none;
    visibility: hidden; }
  .OV_tablet.cOV_ShelfTileContent .reportItem .details-published-date, .OV_tablet .cOV_ReportKPIs .reportItem .details-published-date, .OV_desktop.cOV_ShelfTileContent .reportItem .details-published-date, .OV_desktop .cOV_ReportKPIs .reportItem .details-published-date {
    font-weight: bold; }
  .OV_tablet.cOV_ShelfTileContent .reportItem .details-owner-author, .OV_tablet .cOV_ReportKPIs .reportItem .details-owner-author, .OV_desktop.cOV_ShelfTileContent .reportItem .details-owner-author, .OV_desktop .cOV_ReportKPIs .reportItem .details-owner-author {
    font-weight: bold;
    color: #b6bf34; }
  .OV_tablet.cOV_ShelfTileContent .reportItem .details-period, .OV_tablet .cOV_ReportKPIs .reportItem .details-period, .OV_desktop.cOV_ShelfTileContent .reportItem .details-period, .OV_desktop .cOV_ReportKPIs .reportItem .details-period {
    position: absolute;
    bottom: 3px;
    font-weight: normal;
    color: #666666; }
    .OV_tablet.cOV_ShelfTileContent .reportItem .details-period > span, .OV_tablet .cOV_ReportKPIs .reportItem .details-period > span, .OV_desktop.cOV_ShelfTileContent .reportItem .details-period > span, .OV_desktop .cOV_ReportKPIs .reportItem .details-period > span {
      display: block; }
  .OV_tablet.cOV_ShelfTileContent .reportItem .details-social, .OV_tablet .cOV_ReportKPIs .reportItem .details-social, .OV_desktop.cOV_ShelfTileContent .reportItem .details-social, .OV_desktop .cOV_ReportKPIs .reportItem .details-social {
    display: block;
    position: absolute;
    bottom: 0;
    margin-top: 10px;
    background-color: transparent;
    left: 0;
    right: 0;
    margin: 0; }
    .OV_tablet.cOV_ShelfTileContent .reportItem .details-social .details-social-favourite, .OV_tablet .cOV_ReportKPIs .reportItem .details-social .details-social-favourite, .OV_desktop.cOV_ShelfTileContent .reportItem .details-social .details-social-favourite, .OV_desktop .cOV_ReportKPIs .reportItem .details-social .details-social-favourite {
      margin: -15px 0 -8px -15px;
      padding: 15px 5px 8px 15px;
      float: right; }
.OV_tablet.cOV_ShelfTile-details, .OV_desktop.cOV_ShelfTile-details {
  border: 1px solid #CCCCCC;
  background-color: #FFFFFF;
  padding: 20px 0; }
  .OV_tablet.cOV_ShelfTile-details .details-title, .OV_desktop.cOV_ShelfTile-details .details-title {
    font-size: 20px;
    color: #000000;
    text-align: left; }
  .OV_tablet.cOV_ShelfTile-details .dates, .OV_tablet.cOV_ShelfTile-details .people, .OV_desktop.cOV_ShelfTile-details .dates, .OV_desktop.cOV_ShelfTile-details .people {
    font-size: 16px;
    color: #000000;
    font-weight: bold; }
    .OV_tablet.cOV_ShelfTile-details .dates .small, .OV_tablet.cOV_ShelfTile-details .people .small, .OV_desktop.cOV_ShelfTile-details .dates .small, .OV_desktop.cOV_ShelfTile-details .people .small {
      color: #666666;
      font-weight: normal; }
      .OV_tablet.cOV_ShelfTile-details .dates .small:after, .OV_tablet.cOV_ShelfTile-details .people .small:after, .OV_desktop.cOV_ShelfTile-details .dates .small:after, .OV_desktop.cOV_ShelfTile-details .people .small:after {
        content: ": "; }
    .OV_tablet.cOV_ShelfTile-details .dates .col-xs-4:not(:last-child), .OV_tablet.cOV_ShelfTile-details .dates .col-xs-6:not(:last-child), .OV_tablet.cOV_ShelfTile-details .people .col-xs-4:not(:last-child), .OV_tablet.cOV_ShelfTile-details .people .col-xs-6:not(:last-child), .OV_desktop.cOV_ShelfTile-details .dates .col-xs-4:not(:last-child), .OV_desktop.cOV_ShelfTile-details .dates .col-xs-6:not(:last-child), .OV_desktop.cOV_ShelfTile-details .people .col-xs-4:not(:last-child), .OV_desktop.cOV_ShelfTile-details .people .col-xs-6:not(:last-child) {
      border-right: 1px solid #CCCCCC; }
  .OV_tablet.cOV_ShelfTile-details .people, .OV_desktop.cOV_ShelfTile-details .people {
    color: #e37325; }
  .OV_tablet.cOV_ShelfTile-details .avatar, .OV_desktop.cOV_ShelfTile-details .avatar {
    display: none;
    visibility: hidden; }
  .OV_tablet.cOV_ShelfTile-details .report-description, .OV_desktop.cOV_ShelfTile-details .report-description {
    margin-top: 15px; }

.kpiContent-controls {
  margin: 10px 0; }

.kpiContent-controls-new {
  float: right;
  margin-right: 10px; }
  .kpiContent-controls-new .s1icon {
    font-size: 34px;
    width: 34px;
    height: 34px;
    vertical-align: baseline; }
  .kpiContent-controls-new > span {
    color: #007DBB;
    line-height: 34px;
    vertical-align: text-bottom; }
    .OV_phone .kpiContent-controls-new > span:first-child {
      display: none; }

.kpiContent-controls-title {
  margin-left: 10px;
  font-weight: bold;
  float: left;
  color: #284973;
  font-size: 18px; }
  .kpiContent-controls-title span:first-of-type {
    margin-right: 5px; }

.kpiControls {
  display: none; }

.kpiControls-dialog {
  width: 100%;
  height: 100%;
  background-color: #FFFFFF; }
  .kpiControls-dialog .card {
    border-bottom: none !important; }
  .kpiControls-dialog .card-list {
    border: none;
    margin-bottom: 0; }
    .kpiControls-dialog .card-list .card-list-heading {
      border-bottom: none; }
  .kpiControls-dialog .titleBar {
    position: fixed;
    width: 100%;
    background-color: #FFFFFF; }
    .kpiControls-dialog .titleBar .btn {
      margin: 5px; }
  .kpiControls-dialog .kpiSave {
    float: right; }

.kpiControls-dialogBody {
  padding-top: 45px; }
  .kpiControls-dialogBody .form-control {
    height: 32px; }

.kpiContent-kpi-list {
  background-color: #F2F2F2;
  padding-bottom: 15px; }

.kpiRoot {
  position: relative;
  display: inline-block;
  width: 50%;
  margin: 15px 0 0 15px;
  box-sizing: border-box;
  vertical-align: top;
  border: 1px solid #ccc;
  border-radius: 5px;
  overflow: hidden;
  box-shadow: 0px 0px 8px 2px rgba(102, 102, 102, 0.25); }
  .kpiRoot.lrg {
    width: 100%; }

.kpiRoot-close {
  position: absolute;
  top: 10px;
  right: 10px;
  cursor: pointer;
  font-size: 20px; }

.kpiRoot-panel {
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  background-color: #FFFFFF;
  padding: 10px 10px 0; }

.kpiRoot-graphic {
  width: 100%;
  height: auto;
  background-color: white;
  font-size: 40px;
  color: black;
  text-align: center;
  padding-top: 20px; }
  .kpiRoot-graphic > span {
    font-size: 30px;
    margin-right: -1em;
    vertical-align: middle;
    margin-top: -15px; }
  .kpiRoot-graphic .arrowUp, .kpiRoot-graphic .arrowDown {
    display: none; }
  .kpiRoot-graphic.Up .arrowUp {
    color: #78BE20;
    display: inline-block;
    transform: rotate(90deg);
    -webkit-transform: rotate(90deg); }
  .kpiRoot-graphic.Down .arrowDown {
    color: #BF0D3E;
    display: inline-block;
    -webkit-transform: rotate(-90deg); }

.kpiRoot-details {
  /*     .card-detail {
        display: none;
    } */ }
  .kpiRoot-details .icon {
    display: inline-block;
    margin: 0 10px 0 0;
    color: #FFFFFF;
    background-color: #007DBB;
    vertical-align: middle;
    border-radius: 4px;
    vertical-align: middle;
    /*         .OV_desktop &{
            font-size: 28px;
            line-height: 28px;
            width: 28px;
            height: 28px;            
        } */
    font-size: 34px;
    line-height: 34px;
    width: 34px;
    height: 34px; }
  .kpiRoot-details .expand-button {
    display: inline-block;
    margin: 0;
    float: right;
    color: #666666;
    background-color: transparent;
    vertical-align: middle;
    font-size: 20px;
    line-height: 34px;
    height: 34px; }
  .kpiRoot-details .kpi-heading {
    display: inline-block;
    vertical-align: middle;
    font-weight: bold; }
    .OV_desktop .kpiRoot-details .kpi-heading {
      font-size: 18px;
      line-height: 28px; }
    .OV_phone .kpiRoot-details .kpi-heading {
      font-size: 20px;
      line-height: 34px; }
    .OV_tablet .kpiRoot-details .kpi-heading {
      font-size: 20px;
      line-height: 34px; }
  .kpiRoot-details .kpi-filters {
    margin-left: 44px;
    /*         .OV_tablet &  {
            display: none;
        }    */ }
    .kpiRoot-details .kpi-filters ul {
      max-height: 88px;
      padding-left: 0;
      list-style: none;
      overflow: hidden; }
      .kpiRoot-details .kpi-filters ul li {
        line-height: 22px;
        max-width: 100%;
        overflow: hidden;
        text-overflow: ellipsis; }
      .kpiRoot-details .kpi-filters ul.expanded {
        max-height: inherit; }
      .OV_desktop .kpiRoot-details .kpi-filters ul {
        font-size: 16px; }
      .OV_phone .kpiRoot-details .kpi-filters ul {
        font-size: 14px; }
      .OV_tablet .kpiRoot-details .kpi-filters ul {
        font-size: 14px; }

.notify-checkbox {
  display: inline-block; }
  .notify-checkbox label {
    padding-right: 5px; }

.kpiFavouriteReports .title {
  padding-top: 10px;
  width: 100%;
  color: #284973;
  font-size: 18px;
  font-weight: bold; }

@media only screen and (min-width: 768px) {
  .kpiContent {
    overflow: hidden;
    white-space: nowrap; }

  .kpiRoot {
    width: 250px; }
    .kpiRoot.lrg {
      width: 400px; }

  .kpiRoot-graphic {
    width: 100%;
    height: auto;
    font-size: 60px; }

  .kpiRoot-details .card-detail {
    display: block;
    padding-left: 15px;
    font-size: 12px;
    margin-bottom: 0; }
 }