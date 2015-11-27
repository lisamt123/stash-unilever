'use strict';

var Ps = Ps || {};
/**
 * Utitli
 * @type _L5.Anonym$0
 */
Ps.Chatter = (function(angular, chatter) {
    /**
     * Prom text displayed in chatter feed input
     *
     * @type {String}
     */
    var _promptText = '';

    /**
     * WIN@POS group name
     * @type {String}
     */
    var _userGroupName = 'Global WIN@POS';

    function convertEntities(input) {

        return angular.element('<div>').html(input).text();
    }
    /**
     * Called when in chatter post is completed
     * @returns {Boolean}
     */
    function _onChatterComplete() {

        var element = angular.element('#announcementPost');

        if (!element.length) {
            return false;
        }
        //call
        if (!!element.scope()) {
            try {
                return element.scope().getAnnouncement();
            } catch (e) {
                console.error(e);
                return false;
            }
        }
        
        return false;

    }
    /**
     * Blur on #publishereditablearea
     *
     * @param  {Event} event Blur event
     * @return {void}
     */
    function _onChatterInputBlurHandler(event) {

        var textArea = angular.element(event.currentTarget);
        
        if ('Share with ' + _userGroupName === textArea.val()) {
            textArea.val(_promptText);
        }
    }

    /**
     * Focus on #publishereditablearea
     *
     * @param  {Event} event Focus Event
     * @return {void}
     */
    function _onChatterInputFocusHandler(event) {

        angular.element(event.currentTarget).val('');        
    }
    /**
     * Attach blur, focus events to chatter input.
     *
     * Controls ghost text, workaround for chatter library bug.
     * When rerendered by Sf ghost text is always the same for all entities
     *
     * @param  {angular.element} chatterInput  jqLite or angular element
     * @return {void}
     */
    function _attachChatterInputHandlers(chatterInput) {

        chatterInput.off('blur').on('blur', _onChatterInputBlurHandler);
        chatterInput.off('focus').on('focus', _onChatterInputFocusHandler);
    }
    /**
     * Called when Salesforce chatter action is complete
     *
     * @returns {void}
     */
    function _onChatterActionCallComplete() {

        //chatter input handlers        
        _promptText = angular.element('#publisherprompttext').val();
        _attachChatterInputHandlers(angular.element('#publishereditablearea'));
        angular.element('#publishereditablearea').val(_promptText);

        //this one is for setting proper keyowrd search
        var element = angular.element('#searchResults');

        if (!element.length) {
            return false;
        }

        var keyWord = angular.element('#searchResults').scope().keyWord;

        if (keyWord) {
            keyWord = convertEntities(keyWord);
            chatter.getFeed().expandSearchAndHideMenu(keyWord);
            chatter.getFeed().runSearch();
            chatter.getFeed().closeSearchBox();
            return true;
        }
        return false;
    }

    return {
        onChatterComplete: _onChatterComplete,
        onActionCallComplete: _onChatterActionCallComplete,
        setUserGroupName : function(userGroupName) {
            _userGroupName = userGroupName + '';
        }
    };

}(angular, chatter));
var VisualforceRemotingManager = angular.module('VisualforceRemotingManager', ['appConfig']);

VisualforceRemotingManager.service('VisualforceRemoting', ['$http', 'resourceBasePath',
    function($http, resourceBasePath) {


        function fakeUrl(data, mockBase) {            

            var url = mockBase;

            for (var i = 0; i < data.length; i++) {

                var separtor = '_';
                var value = data[i];
                if (data[i] === '' || data[i] === undefined) {
                    value = null;
                }

                url += separtor + value;
            }

            url += '.json';
            return url;
        }

        //set map for file URL generation
        this.invokeAction = function() {

            //clone
            var args = Array.prototype.slice.call(arguments, 0);

            var actionName = args.shift();
            var callback = args.pop();
            var mockBase = resourceBasePath + 'mocks/' + actionName;

            var url = fakeUrl(args, mockBase);                        

            $http.get(url).success(function(data) {                
                callback(data.result, data);
            }).error(function(){
                $http.get(mockBase + ".json").success(function(data) {
                    callback(data.result, data);
                });
            });
        };
    }    
]);

VisualforceRemotingManager.factory('VisualforceRemotingManager', ['$injector', 'environment',
    function($injector, environment) {

        if ('SF' === environment) {
            return Visualforce.remoting.Manager;

        }
        return $injector.get('VisualforceRemoting');
    }
]);
'use strict';
/**
 * @ngdoc overview
 * @name unileverApp
 * @description
 * #unileverApp
 *
 * Main module of the application.
 */
var unileverApp =
    angular
    .module('unileverApp', [
        'ngAnimate',
        'ngCookies',
        'ngResource',
        'ngRoute',
        'ngSanitize',
        'ui.router',
        'appConfig',
        'infinite-scroll',
        'ngDialog', 
        'VisualforceRemotingManager'
    ]);
//@TODO could go to separte file
unileverApp.constant('filterNameMap', {

    'brands': {
        'paramName': 'brandId',        
        'filterName' : 'Brands',
        'isMultiSelect' : false
    },'categories': {
        'paramName': 'categoryId',        
        'filterName' : 'Categories',
        'isMultiSelect' : false
    },'keyword': {
        'paramName': 'keyWord',        
        'filterName' : 'keyWord',
        'isMultiSelect' : false
    },
    'assetTypes' : {
        'paramName': 'assetType',        
        'filterName' : 'Asset Types',
        'isMultiSelect' : false
    },
    'assetChannels' : {
        'paramName': 'assetChannel',        
        'filterName' : 'Channels',
        'isMultiSelect' : false
    },
    'assetClusters' : {
        'paramName': 'assetCluster',        
        'filterName' : 'Clusters',
        'isMultiSelect' : false
    },
    'placements' : {
        'paramName': 'assetPlacement',        
        'filterName' : 'Placements',
        'isMultiSelect' : false
    },    
    'countries' : {
        'paramName': 'country',        
        'filterName' : 'Countries',
        'isMultiSelect' : false
    }
});

unileverApp.constant('searchNameMap', {
    'categories': {
        'paramName': 'categoryId',
        'searchType': 'categorySearch',
        'searchTitle' : 'Category',
        'reminderVisible' : true,
        'isCarousel' : true
    },
    'brands': {
        'paramName': 'brandId',
        'searchType': 'brandSearch',
        'searchTitle' : 'Brand',
        'reminderVisible' : true,
        'isCarousel' : true
    },
    'instore' : {
        'searchType': 'instoreSearch',
        'searchTitle' : 'Instore Executions',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : false
    },
    'innovation' : {
        'searchType': 'innovationSearch',
        'searchTitle' : 'Innovation Guidelines',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : false
    },
    'cta' : {
        'searchType': 'ctaSearch',
        'searchTitle' : 'Call To Action',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : false
    },
    'bestpractices' : {
        'searchType': 'bestPracticesSearch',
        'searchTitle' : 'Best Practices',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : false
    },
    'repetable' : {
        'searchType': 'repetableSearch',
        'searchTitle' : 'Repeatable Models',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : false
    },
    'keyword': {
        'searchType': 'keywordSearch',
        'paramName' : 'keyWord',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : true
    }, 
    'detail': {
        'searchType': 'detail',
        'searchTitle' : '',        
        'reminderVisible' : true,
        'isCarousel' : true
    }, 
    'home': {
        'searchType': 'home',
        'searchTitle' : '',
        'chatterTitle' : 'Recent & Relevant',
        'reminderVisible' : false,
        'isCarousel' : true
    }
});

unileverApp.config(function($stateProvider, $urlRouterProvider, resourceBasePath, searchNameMap) {

    $urlRouterProvider.otherwise('/home');

    $stateProvider.state('home', {
        url: '/home',
        views : {
            '' : {                    
                templateUrl: resourceBasePath + 'views/home.html',
                controller: 'HomeCtrl'
            }, 
            'annoucement' : {
                templateUrl: resourceBasePath + 'views/announcement.html',
                controller: 'AnnouncementCtrl'            
            }
        }

    }).state(searchNameMap.categories.searchType, {
        url: '/search/category/:' + searchNameMap.categories.paramName + '/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.brands.searchType, {
        url: '/search/brand/:' + searchNameMap.brands.paramName + '/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.keyword.searchType, {
        url: '/search/keyword/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.instore.searchType, {
        url: '/search/instore/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.innovation.searchType, {
        url: '/search/innovation/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.cta.searchType, {
        url: '/search/cta/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.bestpractices.searchType, {
        url: '/search/bestpractices/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state(searchNameMap.repetable.searchType, {
        url: '/search/repetable/:' + searchNameMap.keyword.paramName,
        templateUrl: resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state('detail', {
        url: '/detail/:assetid',
        templateUrl: resourceBasePath + 'views/detail.html',
        controller: 'DetailCtrl'
    });

}).run(function($rootScope, $state, $stateParams, psState, searchNameMap) {
    
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;
    //init search variables    
    $rootScope.searchType = searchNameMap.keyword.searchType;

    //observe state changes manipulate fiters
    $rootScope.$on('$stateChangeStart', psState.onStateChangeStartHandler);

});

//this is for 'anti CSRF' fix reported by Checkmars
angular.element(document).ready(
    function(){
        //call upsert user data        
        var $injector = angular.injector(['ng','VisualforceRemotingManager','appConfig']);
        var service = $injector.get('VisualforceRemotingManager');
        service.invokeAction('WinAtPOSHomeController.upsertAppUsage',function(){});
        //add group name
        Ps.Chatter.setUserGroupName($injector.get('userGroupName'));
    }
);
'use strict';
/**
 * @ngdoc function
 * @name unileverApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
  .controller('MainCtrl', ['$scope', '$state', '$rootScope','VisualforceRemotingManager', 'environment', 'searchNameMap',
    function($scope, $state, $rootScope, VisualforceRemotingManager, environment, searchNameMap) {

      var processMenuData = function(data) {
        for (var i = 0; i < data.length; i++) {
          if (data[i].items) {
            data[i].items = addRoute(data[i].items, data[i].name.toLowerCase().trim(), searchNameMap);

          }
        }
        return data;
      };

      $scope.categoryUrlMap = {};

      var addRoute = function(items, type, searchNameMap) {
        var paramName = searchNameMap[type].paramName;
        var searchType = searchNameMap[type].searchType;

        for (var i = 0; i < items.length; i++) {
          var params = {};
          params[paramName] = items[i].itemId;
          items[i].href = $state.href(searchType, params);
          items[i][paramName] = items[i].itemId;

          if (type === 'categories') {
            $scope.categoryUrlMap[items[i].itemId] = [];
            if (items[i].categoryUrl) {
              $scope.categoryUrlMap[items[i].itemId][0] = items[i].categoryUrl;
            }
            if (items[i].categoryUrl2) {
              $scope.categoryUrlMap[items[i].itemId][1] = items[i].categoryUrl2;
            }
          } else if (type === 'categories' && items[i].categoryUrl) {

          }
        }

        return items;
      };

      $scope.handleData = function(data, event) {
        //@TODO shoud create utils module for this since every request will be handeled the same
        if (200 !== event.statusCode) {
          return;
        }

        if (data.status !== 0) {
          //@TODO error
          //@TODO display data.result.mesage
          //for development
          console.log(data.error);
        }
        //now add data to $scope
        $rootScope.menu = $scope.menu = processMenuData(data.data);
        //salesforce workaround, will throw error whichis caught anyway but logged into console
        if ('SF' === environment) {
          $scope.$apply();
        }
      };

      //init
      $scope.menu = [];
      $rootScope.chatterClass = '';
      $rootScope.chatterHeaderLabel = 'RECENT & RELEVANT';
      $rootScope.reminderVisible = false;

      VisualforceRemotingManager.invokeAction('WinAtPOSHomeController.getMenu', $scope.handleData);
    }
  ]);
'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:HomeCtrl
 * @description
 * # HomeCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
  .controller('HomeCtrl', ['$scope', '$rootScope', 'VisualforceRemotingManager', '$state', 'searchNameMap', 'environment', 'userGroupId', 'ngDialog',
    function ($scope, $rootScope, VisualforceRemotingManager, $state, searchNameMap, environment, userGroupId, ngDialog) {
        
        $scope.keyWord = null;
        //chatter groupId
        $scope.userGroupId = userGroupId;
        
        VisualforceRemotingManager.invokeAction('WinAtPOSHomeController.getHomePageCarusel', function(data, event) {
            if (200 !== event.statusCode) {
                return;
            }
            
            if (data.status !== 0) {
                console.log(data.error);
            }        

            $scope.carouselItems = data.data;
            
            if('SF' === environment) {
                $scope.$apply();
            }
        });
    
        $scope.search = function(keyWord) {               
            $state.go(searchNameMap.keyword.searchType, {'keyWord': keyWord});
        };

        //user preferences, suspdned
//        $scope.clickToOpen = function () {
//            var dialog = ngDialog.open({ 
//                template: resourceBasePath + 'views/directives/psuserpreferences.html', 
//                className: 'ngdialog-theme-userpreferences',
//                closeByDocument : false,
//                showClose : false,
//                controller: 'UserpreferencesCtrl',
//                scope: $scope
//            });
//        };
  }]);

'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:SearchCtrl
 * @description
 * # SearchCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
        .controller('SearchCtrl', ['$scope', '$window', '$stateParams', 'psSearch', 'resourceBasePath', 'userGroupId', 
        'ngDialog', '$state', 'psState', 'psActions', 'environment', 'psUtil', 'customUrls',      
        function($scope, $window, $stateParams, psSearch, resourceBasePath, userGroupId, ngDialog, $state, psState, psActions, environment, psUtil, customUrls) {                
                               
                /**
                 * Handler for rejected promises.
                 * 
                 * Should display dialog with error message
                 * 
                 * @param {String} message
                 * @returns {void}
                 */
                function handleError(message) {
                    console.log(message);
                }
                
                function init() {
                    if ($stateParams.keyWord) {
                        $scope.keyWord = psUtil.convertEntities($stateParams.keyWord);                        
                    }

                    $scope.pageSize = psSearch.calculatePageSize();

                    $scope.filters = [];
                    $scope.infiniteBusy = false;
                    $scope.scrollDisabled = true;
                    $scope.resourceBasePath = resourceBasePath;
                    $scope.dialogSemaphore = true;

                    $scope.userGroupId = userGroupId;
                    
                    //@TODO isCategorySearch
                    if ('categorySearch' === psState.getSearchType()) {
                        $scope.userGroupId = $stateParams.categoryId;
                    }

                    if ('brandSearch' === psState.getSearchType()) {
                        $scope.userGroupId = $stateParams.brandId;
                    }
                    
                    $scope.refreshChatter = false;
                    $scope.searchTitle = psState.getSearchTitle();
                    $scope.searchType = psState.getSearchType();

                    $scope.carousel = null; 

                    $scope.search(true);
                }

                $scope.search = function(resetPageNumber) { 
                    if ($scope.infiniteBusy) {
                        return;
                    }
                    $scope.infiniteBusy =  true;
                    $scope.noResults = false;

                    if (resetPageNumber) {  
                        $scope.infinitePage = 1;
                        //$scope.refreshChatter should be always different to run watcher
                        $scope.refreshChatter = Math.random() * (1000 - 1) + 1;
                    }
                    var params = psSearch.prepareParamsObject($stateParams, $scope);

                    psSearch.search(params).then(
                        function(data) {
                            $scope.noResults = true;
                            if (data.data.length) {
                                if ($scope.infinitePage === 1) {
                                    $scope.filters = psSearch.processFilterData(data.data);
                                }
                                    
                                //titles
                                $scope.searchTitle = psState.getSearchTitle();                
                                    
                                var items = psSearch.processAssetsData(data.data);

                                if (items !== undefined) {
                                    $scope.noResults = false;

                                    if ($scope.infinitePage === 1) {
                                        $scope.assetSearchResults = items;
                                    } else {
                                        for (var i = 0; i < items.length; i++) {
                                            $scope.assetSearchResults.push(items[i]);
                                        }
                                    }

                                    if (items.length === $scope.pageSize) {
                                        $scope.scrollDisabled = false;
                                    } else {
                                        $scope.scrollDisabled = true;
                                    }

                                    $scope.infinitePage = $scope.infinitePage + 1;
                                    //back to normal state
                                    $scope.refreshChatter = false;

                                } else {
                                    $scope.assetSearchResults = [];
                                    $scope.noResults = true;
                                }                              
                            }
                            $scope.infiniteBusy = false;
                        }, handleError
                    );
                    //applyScope();
                    $scope.getGlobalsCarousel(params);
                };
                
                $scope.searchTerm = function(keyWord) {                    
                    $state.go('.', {'keyWord': keyWord});
                };
       
                $scope.getGlobalsCarousel = function(params) {
                    $scope.carousel = null;
                    if (psState.getIsCarousel()) {
                        psSearch.getGlobalsCarousel(params).then(
                            function(data) {
                                $scope.carousel = null;
                                if (data.length) {
                                    $scope.carousel = data[0];
                                }
                                $scope.searchTitle = psState.getSearchTitle();

                            }, handleError
                        );
                    }
                };

                $scope.getSearchResultListPdf = function() {
                    var params = psSearch.prepareParamsObject($stateParams, $scope);
                    
                    if ($scope.dialogSemaphore === true){
                        $scope.dialogSemaphore = false;

                        $scope.searchResultPdf = null;
                        if (! $scope.noResults) {
                            psSearch.getSearchResultListPdf(params).then(
                                function(data) {
                                    if (parseInt(data.status) === -1) {
                                        //display dialog
                                        $scope.searchResultPdf = data.urlToPdfFile;

                                        var dialog = ngDialog.open({ 
                                            template: resourceBasePath + 'views/directives/psdownloadpopup.html', 
                                            className: 'ngdialog-theme-downloadpopup',
                                            closeByDocument : false,
                                            showClose : false,
                                            controller: 'DownloadpopupCtrl',
                                            scope: $scope
                                        });
                                        
                                    }else{
                                        var url = data.urlToPdfFile.replace(/&amp;/g, '&');
                                        $window.open(url, '_blank');
                                    }
                                    $scope.dialogSemaphore = true;                            
                                }, function (message) {
                                    console.log(message);
                                    $scope.dialogSemaphore = true;
                                }
                            );
                        }
                    }
                };

                $scope.follow = function(assetId) {
                    psActions.follow(assetId).then(
                        function() {
                            $scope.carousel.isUserFollowRecord = true;
                        }, handleError
                    );
                };
                
                $scope.unfollow = function(assetId) {
                    psActions.unfollow(assetId).then(
                        function() {
                            $scope.carousel.isUserFollowRecord = false;
                        }, handleError
                    );
                };

                $scope.getLinkImageSrc = function(suffix) {
                    if ($scope.carousel) {
                        return resourceBasePath + 'images/links/' + $scope.carousel.name.replace(' ', '-') + '-' + suffix + '.png';
                    } else {
                        return '';
                    }
                };

                $scope.urls = customUrls;
                
                angular.element($window).bind('resize', function() {
                    if ($scope.pageSize !== psSearch.calculatePageSize()) {
                        $scope.search($scope);
                    }
                });

                init();
            }
        ]);
'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:DetailsCtrl
 * @description
 * # DetailsCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
  .controller('DetailCtrl', 
    ['$scope', '$stateParams', '$rootScope', 'userGroupId', 'resourceBasePath', '$window', 'psDetail', 'psState', 'psActions',
    function ($scope, $stateParams, $rootScope,  userGroupId, resourceBasePath, $window, psDetail, psState, psActions) {
        
        if ($stateParams.assetid) {
            $scope.assetid = $stateParams.assetid;
        }
        
        $scope.userGroupId = userGroupId;

        $scope.activeElement = 0;

        /**
         * Handler for rejected promises.
         * 
         * Should display dialog with error message
         * 
         * @param {String} message
         * @returns {void}
         */
        function handleError(message) {
            console.log(message);
        }

        $scope.getDetails = function(assetId) {
            psDetail.getDetails(assetId).then(
                function(data) {
                    $scope.carousel = null;
                    if (data.length) {
                        $scope.detailItems = data[0].assetItems;
                        $scope.assetGroupId = data[0].assetGroupId;
                        $scope.isGroup     = (data[0].showAssetGroupView === true);
                        $scope.userFollowTheCollection = (data[0].userFollowTheCollection === true);
                        $scope.assetGroupdownloadPdfUrl = data[0].assetGroupdownloadPdfUrl;
                        $scope.assetGroupName = data[0].assetGroupName;
                        $scope.resourceBasePath = resourceBasePath;

                        if ( $scope.isGroup ) {
                            psState.setChatterTitle('CHATTER ABOUT THIS ASSET GROUP');
                        }else{
                            psState.setChatterTitle('CHATTER ABOUT THIS ASSET');
                        }


                        $scope.carousel = data[0];
                    }
                    $scope.searchTitle = psState.getSearchTitle();

                }, handleError
            );            
        };

        $scope.getDetails($scope.assetid);

        $scope.follow = function(assetId, isGroup) {
            $scope.followGroup = isGroup;

            psActions.follow(assetId).then(
                function(data) {
                    if ($scope.followGroup === true) {
                        $scope.userFollowTheCollection = true;
                    } else{
                        $scope.detailItems[$scope.activeElement].userFollowAsset = true;
                    }
                }, handleError
            );      
        };

        $scope.unfollow = function(assetId, isGroup) {
            $scope.followGroup = isGroup;

            psActions.unfollow(assetId).then(
                function(data) {
                    if ($scope.followGroup === true) {
                        $scope.userFollowTheCollection = false;
                    } else{
                        $scope.detailItems[$scope.activeElement].userFollowAsset = false;
                    }     
                }, handleError
            );      
        };

        $scope.downloadAsset = function(feedId, assetPrimaryFileId, downloadUrl, targetBlank) {
            $scope.downloadAssetUrl = downloadUrl;

            psDetail.downloadDetail(feedId, assetPrimaryFileId).then(
                function(data) {
                    if (targetBlank === true){
                        $scope.downloadPdf($scope.downloadAssetUrl);
                    }else{
                        $window.location.href = $scope.downloadAssetUrl;
                    }
                    
                }, handleError
            );      
        };

        $scope.downloadPdf = function(downloadUrl) {
            $window.open(downloadUrl, '_blank');
        };
  }]);

'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:UserpreferencesCtrl
 * @description
 * # UserpreferencesCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
    .controller('UserpreferencesCtrl', ['$scope', 'ngDialog',
        function($scope, ngDialog ) {
            $scope.closeMyDialog = function () {
                $scope.closeThisDialog();
            };

            $scope.clearAllDialog = function() {
                var checkboxes = window.angular.element.find('.unilever-searchsettings-container input');
                for(var i=0;i<checkboxes.length;i++){
                  checkboxes[i].checked = false;
                }
            }
        }
    ]);
'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:DownloadpopupCtrl
 * @description
 * # DownloadpopupCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
    .controller('DownloadpopupCtrl', ['$scope', 'ngDialog',
        function($scope, ngDialog ) {
            $scope.closeMyDialog = function () {
                $scope.closeThisDialog();
            };

            $scope.downloadPdf = function(downloadUrl) {
                var url = downloadUrl.replace(/&amp;/g, '&');
                window.open(url, '_blank');
            };
        }
    ]);
'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psMenu
 * @description
 * # psMenu
 */
angular.module('unileverApp')
  .directive('psMenu',['resourceBasePath','$window', 'newTabs',  function (resourceBasePath, $window, newTabs) {

    var $ = $window.jQuery;

    return {
      templateUrl: resourceBasePath + 'views/directives/psmenu.html',
      restrict: 'A',
      scope : {
        menu : '=psBindTo'
      },
      link : function($scope, element) {

        var newTabsArr = newTabs ? newTabs.toLowerCase().split('|') : [];

        $scope.delay = 900;

        $scope.resourceBasePath = resourceBasePath;

        $scope.checkIsNew = function(str) {
          return (newTabsArr.indexOf(str.toLowerCase()) !== -1);
        };

        $scope.calculateContainerHeight = function(){
          $scope.containerHeight = element.find('.menu-items-container').height();
        };
          
        $scope.getNum = function(num, div) {          
            return new Array(div - num);
        };

        $scope.collapseMenu = function(param) {
          if( $scope.showBrands === true ||  $scope.showCategories === true){
            $('.overlay').animate({opacity: 0}, $scope.delay, function(){
                $(this).remove();
            });
            $scope.calculateContainerHeight();
            element.find('.container').animate({
              'margin-top': -$scope.containerHeight 
            }, $scope.delay, function(){
              element.find('.caret-Categories').removeClass('active');
              element.find('.caret-Brands').removeClass('active');
              $scope.showCategories = false;
              $scope.showBrands = false;
              element.find('.menu-Categories').hide();
              element.find('.menu-Brands').hide();
              element.find('.container').css({'margin-top': 0});
            });
          }  
        };
        
        $scope.expandMenu = function(param) {
          //element.find('.empty-items').empty();
          $scope.containerHeight = 0;

          var overlayMenu = function() {
              if (param === 'Brands' && $scope.showBrands === true) {
                  $('.overlay').animate({opacity: 0}, $scope.delay, function(){
                      $(this).remove();
                      $('.winatpos').removeClass('overflow');
                  });
              }
              else if (param === 'Categories' && $scope.showCategories === true) {
                  $('.overlay').animate({opacity: 0}, $scope.delay, function(){
                      $(this).remove();
                      $('.winatpos').removeClass('overflow');
                  });
              }
              else if (
                        ($scope.showCategories === false || typeof $scope.showCategories === 'undefined') &&
                        ($scope.showBrands === false || typeof $scope.showBrands === 'undefined')
                      ) {
                  var $overlay = $('<div class="overlay"></div>');
                  $('.winatpos').addClass('overflow');
                  $('.winatpos').append($overlay);
                  $overlay.animate({opacity: 1}, $scope.delay);
              }
          };     

          var showBrandsContainers = function(){
            element.find('.menu-Brands').show();
            element.find('.menu-Categories').hide();            
          };

          var showCategoriesContainers = function(){
            element.find('.menu-Categories').show();
            element.find('.menu-Brands').hide();
          };

          var showBrands = function(){
            if($scope.showBrands === true){
              $scope.calculateContainerHeight();
              element.find('.container').animate({
                'margin-top': -$scope.containerHeight 
              }, $scope.delay); 
              $scope.showBrands = false;
              element.find('.caret-Brands').removeClass('active');                            
            }else{
              element.find('.caret-Categories').removeClass('active');

              showBrandsContainers();
              $scope.calculateContainerHeight();
              element.find('.container').css({'margin-top': - $scope.containerHeight});
              
              element.find('.container').animate({
                'margin-top': 0 
              }, $scope.delay);  
              $scope.showBrands = true;  
              element.find('.caret-Brands').addClass('active');
            }
          };

          var showCategories = function(){
            if($scope.showCategories === true){
              $scope.calculateContainerHeight();
              element.find('.container').animate({
                'margin-top': -$scope.containerHeight 
              }, $scope.delay); 
              $scope.showCategories = false;
              element.find('.caret-Categories').removeClass('active');
            }else{
              element.find('.caret-Brands').removeClass('active');

              showCategoriesContainers();
              $scope.calculateContainerHeight();              
              element.find('.container').css({'margin-top': - $scope.containerHeight});
              
              element.find('.container').animate({
                'margin-top': 0 
              }, $scope.delay); 
              element.find('.caret-Categories').addClass('active');

              $scope.showCategories = true;  
            }
          };

          if( param === 'Brands' || param === 'Categories'){
            overlayMenu();
            if(param === 'Brands'){
              if($scope.showCategories === true){
                $scope.calculateContainerHeight();

                element.find('.container').animate({
                  'margin-top': -$scope.containerHeight 
                }, $scope.delay, function(){
                  showBrands();
                }); 
                $scope.showCategories = false;
              }else{
                showBrands();
              }
            }else{
              if($scope.showBrands === true){
                $scope.calculateContainerHeight();
                element.find('.container').animate({
                  'margin-top': -$scope.containerHeight 
                }, $scope.delay, function(){
                  showCategories();
                });
                $scope.showBrands = false;
              }else{
                showCategories();
              }
            }
          }else{
            $scope.collapseMenu();       
          }
        };
      }
    };
  }]);

'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psSearchCarousel
 * @description
 * # psSearchCarousel
 */
angular.module('unileverApp')
        .directive('psSearchCarousel', ['resourceBasePath', '$window', '$timeout', 'VisualforceRemotingManager', 'environment', function (resourceBasePath, $window, $timeout, VisualforceRemotingManager, environment) {

    return {
      templateUrl: resourceBasePath + 'views/directives/pssearchcarousel.html',
      restrict: 'A',
      scope : {
        carousel : '=psSearchCarousel'
      },
      link : function($scope, element){
        $scope.downloadAsset = function(feedId, fileId, downloadUrl) {
          $scope.downloadAssetUrl = downloadUrl;
          var source = 'WinAtPOSHomeController.addRecordToDonwloadStatistics';   

          VisualforceRemotingManager.invokeAction(source, feedId, fileId, function(data, event) {
              if (200 !== event.statusCode) {
                  return;
              }
              
              $window.location.href = $scope.downloadAssetUrl;
              
              if('SF' === environment) {
                $scope.$apply();
              }
            }
          );
        };
      }
    };
  }
]).directive('psCarousel',['resourceBasePath', '$window', '$timeout', function (resourceBasePath, $window, $timeout) {
    return {
      link : function($scope, element){
        if ($scope.$last){
          var $ = $window.jQuery;
          
          $timeout(function(){     
            var parents = element.parents();
            parents.find('.carousel').jcarousel();

            parents.find('.carousel-control-prev')
            .on('jcarouselcontrol:active', function() {
              $(this).removeClass('inactive');
            })
            .on('jcarouselcontrol:inactive', function() {
              $(this).addClass('inactive');
            })
            .jcarouselControl({
              target: '-=1'
            });


            parents.find('.carousel-control-next')
            .on('jcarouselcontrol:active', function() {
              $(this).removeClass('inactive');
            })
            .on('jcarouselcontrol:inactive', function() {
              $(this).addClass('inactive');
            })
            .jcarouselControl({
              target: '+=1'
            });
          }, 0);
        }
      }
    };
  }]);

'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psFilter
 * @description
 * # psFilter
 */
angular.module('unileverApp')
  .directive('psFilter',['resourceBasePath', '$window', '$state', 'searchNameMap', '$rootScope', 
    function (resourceBasePath, $window, $state, searchNameMap, $rootScope) {

    return {
      templateUrl: resourceBasePath + 'views/directives/psfilter.html',
      restrict: 'A',
      scope : {
        filterItem : '=filter' 
      },
      link : function($scope, element) {
        $scope.firstTime = true;
        $scope.element = element;

        var findElement = function (arr, propName, propValue) {
          var propNameConverted = propName.replace(/&/g, '&amp;');
          var propValueConverted = propValue.replace(/&/g, '&amp;');
          for (var i=0; i < arr.length; i++){
            if (arr[i][propName] === propValue){
              return arr[i];
            }else if (arr[i][propNameConverted] === propValueConverted){
              return arr[i];
            } 
          }            
        }; 
        
        $scope.renderFilterId = function(value) {
            value = value.replace(/&amp;/g, '_');
            return value.replace(/ /g, '_');
        };   

        $scope.renderLabel = function(item){
          var label = decodeURI(item.label);
          var _label = '';
          if(item.parentCategory !== undefined){
            _label = decodeURI(item.parentCategory);
          }

          if (_label.length > 1) {
            return label + ' <span class="desc"> - ' + _label + '</span>';
          } else {
            return label;
          }
        };     
        
        $scope.selectFilter = function(filterObject, value) {  
          //@TODO search for correct solution 
          value = value.replace(/&amp;/g, '&');

          //because filter change their names to values actually selected
          var filterName = filterObject.filterName;
          var elem = findElement($scope.$parent.filters, 'filterName', filterName);
          if ( filterObject.filterNameOryginal !== undefined ){
            filterName = filterObject.filterNameOryginal;
            elem = findElement($scope.$parent.filters, 'filterNameOryginal', filterName);
          }
          
          if (typeof elem !== 'undefined' ) { 
            if (filterObject.isMultiselect !== false){
              //to be sure that data from backend are populated
              if($scope.firstTime === true && elem.selectedValue !== undefined ){
                //@TODO search for correct solution
                elem.tmpSelectedValues = elem.selectedValue.replace(/&amp;/g, '&');
                $scope.firstTime = false;
              }

              if (value === ''){
                //if all values selected then deselect other
                var inputs = $scope.element.find('form').find('input');
                for(var i=0;i<inputs.length;i++){
                  $scope.element.find('form').find('input')[i].checked = false;
                }
                $scope.element.find('form').find('input')[0].checked = true;
                elem.tmpSelectedValues = '';
              }else{
                 //multi selection - request and populate only after approve button clicked      
                if(elem.hasOwnProperty('tmpSelectedValues')){
                  if (elem.tmpSelectedValues.indexOf(value) > -1){
                    elem.tmpSelectedValues = elem.tmpSelectedValues.replace(value+';', '');
                  }else{
                    elem.tmpSelectedValues += value + ';';
                  }                               
                }else{
                  elem.tmpSelectedValues = value + ';';
                } 

                if(elem.tmpSelectedValues === ''){
                  $scope.element.find('form').find('input')[0].checked = true;
                }else{
                  $scope.element.find('form').find('input')[0].checked = false;
                }                    
              }             
            }else{
              //single selection - click, request and populate
              elem.selectedValue = value;
              //save selection and call backend
              $scope.processRequest();
            }   
          }
        };

        $scope.applyMultiFilter = function(filterName) {
          var elem = findElement($scope.$parent.filters, 'filterName', filterName);
          elem.selectedValue = elem.tmpSelectedValues;
          $scope.processRequest();
        };

        $scope.processRequest = function() {
          $scope.$parent.search(true);
        };

        $scope.searchFor = function(filterName) {
          var val = $scope.element.find('.mySearch')[0].value;
          if(val === '') {
            $scope.element.find('form').find('.filter-checkbox').show();
          } else {
              var rex = new RegExp(val, 'i');
              var elements = $scope.element.find('form').find('.filter-checkbox');
              elements.hide();
              elements.filter(function(){
                  return rex.test($window.jQuery(this).find('label').text());
              }).show();
          }
        };
      }
    };
  }])
  .directive('psFilterScroll', ['resourceBasePath', '$window',  function () {
    return {
      scope : {
        item : '=item'
      },        
      link : function($scope, element) {
          
          if ($scope.item.filterValues.length > 10) {
              element.addClass('scroller');
              element.niceScroll({
                  'cursorcolor': '#cacaca',
                  'cursorwidth': 6,
                  'autohidemode': false,
                  'background': '#f7f7f7'
              });
          }
      }   
   };
}]);

'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psHomeCarousel
 * @description
 * # psHomeCarousel
 */
angular.module('unileverApp')
        .directive('psHomeCarousel', ['resourceBasePath', '$window', function (resourceBasePath, $window) {

    return {
        templateUrl: resourceBasePath + 'views/directives/pshomecarousel.html',
        restrict: 'A',
        scope: {
            homecarousel: '=psBindTo',
            carouselItems : '=carouselitems'
        },
        link: function ($scope, element) {
            $scope.resourceBasePath = resourceBasePath;
        }
    };
}]).directive('parseUrl', ['resourceBasePath', '$window', '$timeout',  function (resourceBasePath, $window, $timeout) {
            
    return {
        scope: {
            item: '=parseUrl',
        },
        link: function(scope, element) {
            var item = scope.item;
            item = String(item).replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"');
            element.attr('style', 'background-image: url('+item+');');       
        }
    };
}]).directive('initHomeCarousel', ['resourceBasePath', '$window', '$timeout', '$interval',  function (resourceBasePath, $window, $timeout, $interval) {
    var $ = $window.jQuery;
    var colors =     ['light-green', 'green', 'dark-green'];
    var directions = ['rtl', 'ltr'];
    var lastRandCol;
    var lastRandDir;
    var homeSlickInterval;
    
    function randomClass(){
        function random(len, last) {
            var rand = Math.floor((Math.random() * len));
            if (rand !== last) {
                return rand;
            } else {
                return random(len, last);
            }
        }
        var randCol = random(colors.length, lastRandCol);
        lastRandCol = randCol;
        var randDir = random(directions.length, lastRandDir);
        lastRandDir = randDir;
        return colors[randCol] + ' ' + directions[randDir];
    }
    
    return {
        restrict: 'A',
        link: function(scope, element) {
            element.find('.slide').addClass(randomClass());    
            if (scope.$first) {
                $interval.cancel(homeSlickInterval);
            }
            if (scope.$last){
                $timeout(function(){
                    var $captions = element.parents().find('.slide-caption');
                    $.each($captions, function(){
                       $(this).data('height', $(this).outerHeight(true)); 
                    });             
                    var $slick = element.parents().find('.home-carousel');
                    $slick.slick({
                        variableWidth: true,    
                        centerMode: true,
                        infinite: scope.$parent.carouselItems.length > 2 ? true : false,
                        centerPadding: '0px',
                        slidesToShow: 1,
                        useCSS: true,
                        speed: 600,
                        slide: '.home-slick',
                        draggable: false,
                        autoplay: false,
                        onInit: function() {
                            $('.slick-center').find('.topics-row').addClass('show');
                            $('.slick-center').find('.links-row').addClass('show');
                            var $text = $('.slick-center').find('.slide-text-holder');
                            $text.height($text.children('.slide-text').outerHeight(true));
                        },
                        onBeforeChange: function() {
                            $('.slick-center').find('.slide-text').removeClass('visible-text');
                            $('.slick-center').find('.topics-row').removeClass('show');
                            $('.slick-center').find('.links-row').removeClass('show');
                            $('.slick-center').find('.slide-text-holder').height(0);
                            var $caption = $('.slick-center').find('.slide-caption');
                            $caption.css({height: $caption.data('height')});
                        },
                        onAfterChange: function() {
                            $('.slick-center').find('.slide-caption').height('auto');
                            $('.slick-center').find('.slide-text').addClass('visible-text');
                            $('.slick-center').find('.topics-row').addClass('show');
                            $('.slick-center').find('.links-row').addClass('show');
                            var $text = $('.slick-center').find('.slide-text-holder');
                            $text.height($text.children('.slide-text').outerHeight(true));                    
                        }
                    });
                    
                    /*
                     * if $slick.slickGoTo(1) - 2nd asset active
                     * if $slick.slickGoto(0) - 1st asset active
                     */
                    $slick.slickGoTo(1);
                    
                    var $next = $slick.find('.slick-next');
                    var $prev = $slick.find('.slick-prev');
                    
                    $prev.on('click', function(){
                        $interval.cancel(homeSlickInterval);
                        homeSlickInterval = $interval(function() {$slick.slickNext();}, 3000);    
                    });
                    
                    $next.on('click', function(){
                        $interval.cancel(homeSlickInterval);
                        homeSlickInterval = $interval(function() {$slick.slickNext();}, 3000);    
                    });
                    
                    homeSlickInterval = $interval(function() {$slick.slickNext();}, 3000);
                    
                }, 0);
            }
        }
    };
}]);
'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psDetail
 * @description
 * # psHomeCarousel
 */
angular.module('unileverApp')
        .directive('psDetail', ['resourceBasePath', '$window', '$timeout', 'VisualforceRemotingManager', 'environment', 'psDetail', function (resourceBasePath, $window, $timeout, VisualforceRemotingManager, environment, psDetail) {

    return {
        templateUrl: resourceBasePath + 'views/directives/psdetailcarousel.html',
        restrict: 'A',
        scope: {
            detailItems : '=detailitems',
            resourceBasePath : '=resourcebasepath'
        }, 
        link: function ($scope, element) { 
            var $ = $window.jQuery;              

            $scope.clickCarouselItem = function(elementNumber, $event, assetId, assetPrimaryFileId) {
              var parent = $scope.$parent.$parent;
              parent.assetid = assetId;
              parent.activeElement = elementNumber;               

              psDetail.retriveStatistics(assetPrimaryFileId, assetId).then(
                function(data) {
                  var element = parent.detailItems[parent.activeElement];             
                  element.downloadStatistics =  data.downloadStatistics;
                  element.followStatistics = data.followStatistics;          
                }, function (message) {
                    console.log(message);
                }
              );   

              $('.carousel-item-square.active').removeClass('active');
              $($event.currentTarget).find('.carousel-item-square').addClass('active');
            };
        }
    };
  }
]).directive('initDetailCarousel', ['resourceBasePath', '$window', '$timeout',  function (resourceBasePath, $window, $timeout) {    
    return {
        link: function(scope, element) {
          if (scope.$last){
            var $ = $window.jQuery;            
            $timeout(function(){
                var parents = element.parents();
                parents.find('.carousel').jcarousel();

                parents.find('.carousel-control-prev')
                .on('jcarouselcontrol:active', function() {
                  $(this).removeClass('inactive');
                })
                .on('jcarouselcontrol:inactive', function() {
                  $(this).addClass('inactive');
                })
                .jcarouselControl({
                  target: '-=1'
                });


                parents.find('.carousel-control-next')
                  .on('jcarouselcontrol:active', function() {
                  $(this).removeClass('inactive');
                })
                .on('jcarouselcontrol:inactive', function() {
                  $(this).addClass('inactive');
                })
                .jcarouselControl({
                  target: '+=1'
                });
            }, 0);
          }
        }
    };
}]);
'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psMenu
 * @description
 * # psParseUrl
 */
angular.module('unileverApp')
  .directive('psHtml',[function () {
    
    return {
      restrict: 'A',
      scope : {
        item: '=psHtml',
      },
      link : function($scope, element) {
        var item = $scope.item;
        element.html(item);
        element.html(element.text());
        
        $scope.$watch('item', function(newValue) {
           element.html(newValue);
           element.html(element.text());
        });
      }
    };
}]);

'use strict';

/**
 * @ngdoc directive
 * @description
 * # psCollapse
 */
angular.module('unileverApp')
  .directive('psCollapse', ['$compile', function($compile) {
    return {
        restrict: 'A',
        scope: true,
        link: function(scope, element, attrs) {

            scope.collapsed = false;

            scope.toggle = function() {
                scope.collapsed = !scope.collapsed;
            };

            attrs.$observe('psCollapseText', function(text) {
                var maxLength = scope.$eval(attrs.maxLength);

                if (text.length > maxLength) {
                    var firstPart = String(text).substring(0, maxLength);
                    var secondPart = String(text).substring(maxLength, text.length);
                    if((firstPart.match(/\n/g) || []).length> 2){
                        firstPart = String(text).substring(0, text.split('\n', 3).join('\n').length);
                        secondPart = String(text).substring(text.split('\n', 3).join('\n').length, text.length);
                    }                    

                    var firstSpan = $compile('<span>' + firstPart + '</span>')(scope);
                    var secondSpan = $compile('<span ng-show="collapsed" class="collapsed-span">' + secondPart + '</span>')(scope);
                    var moreIndicatorSpan = $compile('<span ng-show="!collapsed">... </span>')(scope);
                    var lineBreak = $compile('<br ng-show="collapsed">')(scope);
                    var toggleButton = $compile('<span class="collapse-text-toggle {{collapsed ? \'right\' : \'more\'}}" ng-click="toggle()">{{collapsed ? "hide" : "more"}}</span>')(scope);

                    element.empty();
                    element.append(firstSpan);
                    element.append(secondSpan);
                    element.append(moreIndicatorSpan);
                    element.append(lineBreak);
                    element.append(toggleButton);
                }else if((text.match(/\n/g) || []).length> 2){
                    var firstPart = String(text).substring(0, text.split('\n', 3).join('\n').length);
                    var secondPart = String(text).substring(text.split('\n', 3).join('\n').length, text.length);

                    var firstSpan = $compile('<span>' + firstPart + '</span>')(scope);
                    var secondSpan = $compile('<span ng-show="collapsed" class="collapsed-span">' + secondPart + '</span>')(scope);
                    var moreIndicatorSpan = $compile('<span ng-show="!collapsed">... </span>')(scope);
                    var lineBreak = $compile('<br ng-show="collapsed">')(scope);
                    var toggleButton = $compile('<span class="collapse-text-toggle {{collapsed ? \'right\' : \'more\'}}" ng-click="toggle()">{{collapsed ? "hide" : "more"}}</span>')(scope);

                    element.empty();
                    element.append(firstSpan);
                    element.append(secondSpan);
                    element.append(moreIndicatorSpan);
                    element.append(lineBreak);
                    element.append(toggleButton);
                }
                else {
                    element.empty();
                    element.html(text);
                }
            });
        }
    };
}]);
'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psMenu
 * @description
 * # psParseUrl
 */
angular.module('unileverApp')
  .filter('psParseUrl',function () {

    return function (text) {
      text = String(text).replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g,'\'');
      return text;
    };
});

'use strict';

/**
 * @ngdoc filter
 * @name unileverApp.filter:psTextCut
 * @description
 * # psTextCut
 */
angular.module('unileverApp')
  .filter('psTextCut',function () {

    return function (value, wordwise, max, tail) {
        if (!value) return '';

        max = parseInt(max, 10);
        if (!max) return value;
        if (value.length <= max) return value;

        value = value.substr(0, max);
        if (wordwise) {
            var lastspace = value.lastIndexOf(' ');
            if (lastspace != -1) {
                value = value.substr(0, lastspace);
            }
        }

        return value + (tail || ' …');
    };
});

'use strict';

/**
 * @ngdoc service
 * @name unileverApp.psSearch
 * @description
 * # psSearch
 * Service in the unileverApp. 
 */
angular.module('unileverApp')
    .service('psSearch',['psState', 'VisualforceRemotingManager', '$q', 'filterNameMap', 'psUtil',

    function psSearch(psState, VisualforceRemotingManager, $q, filterNameMap, psUtil) {

        var findElement = function(arr, propName, propValue) {
            
            
            var propNameConverted = psUtil.convertEntities(propName);
            var propValueConverted = psUtil.convertEntities(propValue);

            for (var i = 0; i < arr.length; i++) {
                if (arr[i][propName] === propValue) {
                    return arr[i];
                } else if (arr[i][propNameConverted] === propValueConverted) {
                    return arr[i];
                }
            }
        };

        var shortName = function(name, isMulti){
            var howMany = (isMulti === true) ? 12 : 14;
            name = name.replace(/&amp;/g, '&');
            if (name.length > howMany) {
                name = name.substring(0, howMany) + '...';
            }
            return name;
        };

        this.search = function(params) {
            var deferred = $q.defer();
            var source = 'WinAtPOSHomeController.search';
            VisualforceRemotingManager.invokeAction(
                source, params.searchType,
                params.brandId, params.categoryId, params.keyWord, params.assetType,
                params.assetChannel, params.assetCluster, params.assetPlacement, params.country,
                params.pageSize, params.pageNumber, params.withFilters,
                function(data, event) {
                    console.log(source, data);
                    
                    if (200 !== parseInt(event.statusCode)) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    if (parseInt(data.status) !== 0) {
                        deferred.reject('Status is ' + data.status);
                    }
                    deferred.resolve(data);
                }
            );
            return deferred.promise;
        };

        /**
         * Parse stateParams and rootScope data to format acceptable by service
         *
         *
         * Remote action params are
         * (String searchType,
         * String brandId,
         * String categoryId,
         * String keyWord,
         * String assetType,
         * String assetChannel,
         * String assetCluster,
         * String assetPlacement,
         * String country,
         * Integer pageSize,
         * Integer pageNumber,
         * Boolean withFilters)
         *         
         * @param  {Object} $stateParams  [description]
         * @param  {Object} $scope        [description]         
         * @return {Object}               [description]
         */
        this.prepareParamsObject = function(stateParams, scope) {

            var params = {'searchType' : psState.getSearchType()};            
                        
            //root filter settings
            for (var i in filterNameMap) {

                if (filterNameMap.hasOwnProperty(i) && filterNameMap[i].paramName) {

                    var paramName = filterNameMap[i].paramName;
                    var value = null;

                    if(stateParams[paramName]) {
                        value = stateParams[paramName];
                    }

                    for (var j = 0; j < scope.filters.length ; j++) {

                        if(scope.filters[j].filterNameOryginal !== undefined){
                            if (scope.filters[j].filterNameOryginal === filterNameMap[i].filterName) {
                                value = scope.filters[j].selectedValue;
                                value = value.replace(/&amp;/g, '&');
                                break;    
                            }
                        }else{
                            if (scope.filters[j].filterName === filterNameMap[i].filterName) {
                                value = scope.filters[j].selectedValue;
                                value = value.replace(/&amp;/g, '&');
                                break;    
                            }
                        }
                        
                    }

                    params[filterNameMap[i].paramName] = value;
                }
            }         
            //add page number and size  and query
            params.keyWord =  scope.keyWord ? scope.keyWord : '';         
            params.pageSize = scope.pageSize ? scope.pageSize : 15;
            params.pageNumber = scope.infinitePage ? scope.infinitePage : 1;
            params.withFilters = scope.infinitePage > 1 ? false : true; //Boolean(scope.withFilters);

            return params;
        };

        this.processFilterData = function(data) {
            var filters = data[0].searchFilters;
            var element = null;

            if (filters.length > 1) {
                if (filters[0].selectedValue !== '' && filters[0].filterName === 'Categories' && filters[1].filterName === 'Brands') {
                    filters[0].isRelatedFilterLeft = true;
                    filters[1].isRelatedFilterRight = true;
                }
            }

            for (var i = 0; i < filters.length; i++) {
                var filterValues = filters[i].filterValues;
                
                if (filters[i].isMultiselect === true) {
                    var labels = 0;
                    var valuesText = filters[i].selectedValue;
                    //@TODO search for correct solution
                    valuesText = valuesText.replace(/&amp;/g, '&');

                    if (valuesText === '') {
                        element = findElement(filterValues, 'value', '');
                        if (typeof element !== 'undefined') {
                            element.isSelected = true;
                        }
                    } else {
                        var valuesArray = valuesText.split(';');
                        for (var j = 0; j < valuesArray.length; j++) {
                            if (valuesArray[j] !== '') {
                                element = findElement(filterValues, 'value', valuesArray[j]);
                                if (typeof element !== 'undefined') {
                                    element.isSelected = true;
                                    if(labels === 0){
                                        filters[i].filterNameOryginal = filters[i].filterName;
                                        filters[i].filterName = shortName(element.label, true);

                                        labels++;
                                    }else{
                                        labels++;
                                    }
                                }
                            }
                        }
                        if(labels > 1){
                           filters[i].filterName += ' (+'+(labels-1)+')'; 
                        }
                    }
                } else {
                    element = findElement(filterValues, 'value', filters[i].selectedValue);

                    if (typeof element !== 'undefined') {
                        element.isSelected = true;
                        //change the label of filter
                        if(filters[i].selectedValue !== ''){
                            filters[i].filterNameOryginal = filters[i].filterName;
                            filters[i].filterName = shortName(element.label, false);
                        }
                    }
                } 
            }

            //parse filters if needed
            return data[0].searchFilters;
        };
        
        this.calculatePageSize = function() {
            if (!angular.element.find('.elements').length) {
                return 5;
            }

            var offsetTop = angular.element.find('.elements')[0].offsetTop;
            var windowHeight = window.innerHeight;
            var elementHeight = 185;
            var column = 5;

            var pageSize = parseInt((windowHeight - offsetTop) / elementHeight) * 5;
            //add one more row to have right scroll if there is enough number of elements
            pageSize = pageSize + column;
            return pageSize;
        };

        this.processAssetsData = function(data) {
            //parse filters if needed
            return data[0].assetSearchResult;
        };

        this.getGlobalsCarousel = function(params) {
            var deferred = $q.defer();
            
            var source = 'WinAtPOSHomeController.getCaruselForBrandOrCategory';
            VisualforceRemotingManager.invokeAction(source,
                params.searchType,
                params.brandId,
                params.categoryId,
                params.keyWord,
                function(data, event) {                    

                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    if (parseInt(data.status) !== 0) {
                        deferred.reject('Status is ' + data.status);
                        return;
                    }

                    if (data.data !== undefined) {
                        
                        if (data.data.length) {
                            psState.setBrandOrCategoryName(data.data[0].name);                            
                        }
                        
                        deferred.resolve(data.data);
                    }
                }
            );
    
            return deferred.promise;
        };

        this.getSearchResultListPdf = function(params) {
            var deferred = $q.defer();
            
            var source = 'WinAtPOSHomeController.getSearchResultListPdf';
            VisualforceRemotingManager.invokeAction(
                source, params.searchType,
                params.brandId, params.categoryId, params.keyWord, params.assetType,
                params.assetChannel, params.assetCluster, params.assetPlacement, params.country,
                params.pageSize, params.pageNumber,
                function(data, event) {                    

                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    deferred.resolve(data);
                }
            );
    
            return deferred.promise;
        };
    }]);
'use strict';

/**
 * @ngdoc service
 * @name unileverApp.psState
 * @description
 * # psState
 * Service in the unileverApp.
 */
angular.module('unileverApp')
        .service('psState', ['searchNameMap', 'psUtil',
            function psState(searchNameMap, psUtil) {
                
                /**
                 * Map and configuration object
                 * @type type
                 */
                var _searchNameMap = searchNameMap;
                /**
                 * Search title displayed on search results
                 * @type String
                 */
                var _searchTitle = '';
                /**
                 * Chatter column title
                 * @type String
                 */
                var _chatterTitle = '';

                /**
                 * Seqarch type that is sent to serach service later
                 * @type String
                 */
                var _searchType = '';
                /**
                 * Should remnider be visible
                 * @type Boolean
                 */
                var _isReminderVisible = false;
                /**
                 * Brand or category name depending on searchType
                 * @type String
                 */
                var _name = '';
                
                /**
                 * Chatter class
                 * @type String
                 */
                var _chatterClass = 'rtl';
                
                /**
                 * Display brand or category csrousel for this state
                 * @type Boolean
                 */
                var _isCarousel = false;
                /**
                 * Set name of Brand or category name depending on searchType
                 * 
                 * @param {String} name
                 * @returns {psState}
                 */
                function _setName(name) {

                    _name = name;
                    if (_searchType === searchNameMap.brands.searchType || 
                        _searchType === searchNameMap.categories.searchType ) {
                        _searchTitle = psUtil.convertEntities(_name + ' Assets');
                        _chatterTitle = psUtil.convertEntities('Latest ' + _name + ' Chatter');
                    }
                    return this;
                }

                /**
                 * Checks if transition that occured should change values
                 *
                 * @param  {Object} toState    [description]
                 * @param  {Object} fromState  [description]
                 * @param  {Object} toParams   [description]
                 * @param  {Object} stateData [description]                 
                 * @return {Bool}              TRUE when change occured
                 */
                function checkTransition(toState, fromState, toParams, stateData) {

                    if (toState.name !== stateData.searchType) {
                        return false;
                    }
                    _chatterClass = '';
                    //data for bubble reminder
                    _isReminderVisible = stateData.reminderVisible;
                    _isCarousel = stateData.isCarousel;
                    
                    //static search title
                    if (stateData.searchTitle) {
                        _searchTitle = psUtil.convertEntities(stateData.searchTitle);
                    }
                    //static chatter title
                    if (stateData.chatterTitle) {
                        _chatterTitle = psUtil.convertEntities(stateData.chatterTitle);
                    }

                    //we are entering new state
                    if (stateData.searchType !== toState.name ||
                            toState.name === fromState.name) {
                        return false;
                    }

                    if (!stateData.searchType) {
                        return false;
                    }

                    _searchType = stateData.searchType;

                    return true;
                }

                /**
                 * Handler called when there is transition form one state to another.
                 *                 * 
                 *
                 * @param  {Object} event     [description]
                 * @param  {Object} toState   [description]
                 * @param  {Object} toParams  [description]
                 * @param  {Object} fromState [description]
                 * @return {Bool}             [description]
                 */
                function _onStateChangeStartHandler(event, toState, toParams, fromState) {
                    
                    //do nothing this sate resets all
                    if (searchNameMap.home.searchType === toState.name) {                        
                        _searchType = searchNameMap.home.searchType;
                        _searchTitle = searchNameMap.home.searchTitle;
                        _chatterTitle = searchNameMap.home.chatterTitle;                                               
                        _isReminderVisible = searchNameMap.home.reminderVisible;
                        _chatterClass = 'rtl';
                        _isCarousel = false;
                        
                        return true;
                    }
                    //detail state
                    if (searchNameMap.detail.searchType === toState.name) {
                        _searchType = searchNameMap.detail.searchType;
                        _searchTitle = searchNameMap.detail.searchTitle;                        
                        _isReminderVisible = searchNameMap.detail.reminderVisible;
                        _chatterClass = '';
                        _isCarousel = false;
                        return true;
                    }
                    //for other defined check 
                    for (var i in _searchNameMap) {
                        if (_searchNameMap.hasOwnProperty(i)) {
                            checkTransition(toState, fromState, toParams, _searchNameMap[i]);
                        }
                    }

                    return true;
                }
                ;


                return {
                    onStateChangeStartHandler: _onStateChangeStartHandler,
                    getSearchType: function() {
                        return _searchType;
                    },
                    getSearchTitle: function() {
                        return _searchTitle;
                    },
                    getChatterTitle: function() {
                        return _chatterTitle;
                    },
                    setChatterTitle: function(chatterTitle) {
                        _chatterTitle = chatterTitle + '';
                        return this;
                    },
                    getChatterClass: function() {
                      return _chatterClass;  
                    },
                    setBrandOrCategoryName: _setName,
                    getIsReminderVisible: function() {
                        return _isReminderVisible;
                    },
                    getIsCarousel : function() {
                        return _isCarousel;
                    }
                };
            }
        ]);
'use strict';

/**
 * @ngdoc service
 * @name unileverApp.psActions
 * @description
 * # psActions
 * Service in the unileverApp.
 */

angular.module('unileverApp')
    .service('psActions', ['VisualforceRemotingManager', '$q',
        function psActions(VisualforceRemotingManager, $q) {

            this.follow = function(assetId) {
                var deferred = $q.defer();
                var source = 'WinAtPOSHomeController.addFollower';   

                VisualforceRemotingManager.invokeAction(source, assetId, function(data, event) {
                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    deferred.resolve();
                });
                return deferred.promise;
            }

            this.unfollow = function(assetId) {
                var deferred = $q.defer();
                var source = 'WinAtPOSHomeController.removeFollower';   

                VisualforceRemotingManager.invokeAction(source, assetId, function(data, event) {
                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    deferred.resolve(); 
                });
                return deferred.promise;
            }
        }]
    );
'use strict';

/**
 * @ngdoc service
 * @name unileverApp.psDetail
 * @description
 * # psDetail
 * Service in the unileverApp. 
 */
angular.module('unileverApp')
    .service('psDetail',['VisualforceRemotingManager', '$q',
    function psDetail(VisualforceRemotingManager, $q) { 

        this.getDetails = function(assetId) {
            var deferred = $q.defer();

            var source = 'WinAtPOSHomeController.getAssetDetailData';
            VisualforceRemotingManager.invokeAction(
                source, assetId, 
                function(data, event) {
                    console.log(source, data);
                    
                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    if (parseInt(data.status) !== 0) {
                        deferred.reject('Status is ' + data.status);
                        return;
                    }

                    if (data.data !== undefined) {
                        deferred.resolve(data.data);
                    }
                }
            );
            return deferred.promise;
        }

        this.downloadDetail = function(feedId, assetPrimaryFileId) {
            var deferred = $q.defer();

            var source = 'WinAtPOSHomeController.addRecordToDonwloadStatistics';
            VisualforceRemotingManager.invokeAction(
                source, feedId, assetPrimaryFileId,
                function(data, event) {
                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    //@TODO: check if status needs to be checked
                    // if (parseInt(data.status) !== 0) {
                    //     deferred.reject('Status is ' + data.status);
                    //     return;
                    // }

                    deferred.resolve();
                }
            );
            return deferred.promise;
        }

        this.retriveStatistics = function(assetPrimaryFileId, assetId) {
            var deferred = $q.defer();

            var source = 'WinAtPOSHomeController.retriveStatistics';
            VisualforceRemotingManager.invokeAction(
                source, assetPrimaryFileId, assetId,
                function(data, event) {
                    if (200 !== event.statusCode) {
                        deferred.reject('Code different than 200');
                        return;
                    }

                    deferred.resolve(data);
                }
            );
            return deferred.promise;
        }
    }]);
'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psChatterManager
 * @description
 * # psChatterManager
 */
angular.module('unileverApp')
        .directive('psChatterManager', ['$rootScope', 'psChatter', 'isCommunityUser', function($rootScope, psChatter, isCommunityUser) {

                function chatterSearchQuery(query) {
                    if (query !== undefined) {
                        psChatter.getFeed().expandSearchAndHideMenu(query);
                        psChatter.getFeed().runSearch();
                        psChatter.getFeed().closeSearchBox();
                    }
                }

                function postLink(scope) {
                    scope.$watch('runSearch', function(newValue) {

                        if (false !== newValue && newValue !== undefined) {
                            chatterSearchQuery(scope.keyWord);
                        }
                    });

                    if (isCommunityUser === 'true' && $rootScope.$state.current.name === 'home') {
                        $('#chatter-container').hide();
                    } else if (scope.entityId) {
                        $('#chatter-container').show();

                        // if (isCommunityUser) {
                        //     console.log('UpdateChatterFeedCommunity: ' + scope.entityId);
                        //     UpdateChatterFeedCommunity(scope.entityId);
                        // } else {
                        //     console.log('UpdateChatterFeed: ' + scope.entityId);
                        //     UpdateChatterFeed(scope.entityId);
                        // }

                        console.log('UpdateChatterFeed: ' + scope.entityId);
                        UpdateChatterFeed(scope.entityId);
                    } else {
                        $('#chatter-container').hide();
                    }
                }

                return {
                    template: '',
                    restrict: 'A',
                    link: postLink,
                    scope: {
                        keyWord: '=psKeyWord',
                        entityId: '=psEntityId',
                        runSearch: '=psRunSearch'
                    }
                };
            }]);

'use strict';

/**
 * @ngdoc service
 * @name unileverApp.psChatter
 * @description Wrapper for Salesforce chatter service to easa at testing
 * # psChatter
 * Service in the unileverApp.
 */
angular.module('unileverApp')
  .service('psChatter', function psChatter() {
    return chatter;
  });

'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:AnnoucementCtrl
 * @description
 * # AnnoucementCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
  .controller('AnnouncementCtrl',['$scope', 'VisualforceRemotingManager','environment', function ($scope , VisualforceRemotingManager, environment) {
      
      $scope.announcement = null;
      
      //get annoucement      
      $scope.getAnnouncement = function() {          
          var source = 'WinAtPOSHomeController.getAnnouncementForGroup';
          //VisualforceRemotingManager.invokeAction(source, $scope.entityId, function(data, event) {
          VisualforceRemotingManager.invokeAction(source, '', function(data, event) {
              if (200 !== event.statusCode) {
                  return;
              }

              if (data.status !== 0) {
                  console.log(data.error);
              }
              
              if (data.data) {
                $scope.announcement = data.data[0];              
              }
              
              if('SF' === environment) {
                  $scope.$apply();
              }
          }
          );
      };
      
      $scope.getAnnouncement();
  }]);

'use strict';

/**
 * @ngdoc service
 * @name unileverApp.psUtil
 * @description
 * # psUtil
 * Service in the unileverApp.
 */
angular.module('unileverApp')
  .service('psUtil', function psUtil() {
      
      function _convertEntities(input) {          
          return angular.element('<div/>').html(input).text();
      }
      
      return {
          convertEntities : _convertEntities
      };
  });

'use strict';

/**
 * @ngdoc directive
 * @name unileverApp.directive:psChatterHeader
 * @description
 * # psChatterHeader
 */
angular.module('unileverApp')
  .directive('psChatterDisplay',['psState' ,'resourceBasePath', 'environment', function (psState, resourceBasePath, environment) {
          
    function _link(scope) {
            
         scope.chatterHeaderLabel = psState.getChatterTitle();
         scope.chatterClass = psState.getChatterClass();
         scope.reminderVisible = psState.getIsReminderVisible();
         
         scope.$watch(function () {
                return psState.getChatterTitle();
            }, function(newVal) {
                scope.chatterHeaderLabel = newVal;
            });
            
         scope.$watch(function () {
                return psState.getIsReminderVisible();
            }, function(newVal) {
                scope.reminderVisible = newVal;
            });
            
        scope.$watch(function () {
                return psState.getChatterClass();
            }, function(newVal) {
                scope.chatterClass = newVal;
            });
    }
    
    var _templateUrl = resourceBasePath + 'views/directives/pschatterdisplay.html';
          
    return {
      templateUrl: _templateUrl,
      restrict: 'A',
      link: _link
      
    };
  }]);
