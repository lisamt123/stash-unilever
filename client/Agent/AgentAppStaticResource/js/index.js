var myApp=angular.module("myApp",["ngRoute"]);myApp.config(function($routeProvider){$routeProvider.when("/",{templateUrl:"pages/contact_page.html",controller:"contactController"}).when("/nextPage",{templateUrl:"pages/nextPage.html",controller:"nextPageController"})}),myApp.controller("contactController","$location","userData",function($scope,$location,userData){$scope.message="Everyone come and see how good I look!";var formData;$scope.nextPage=function(){$location.url("/nextPage"),formData=$scope.user,userData.set(formData)}}),myApp.factory("userData",function(){var savedData={},set=function(data){savedData=data,console.log("set func"+JSON.stringify(savedData))},get=function(){return savedData};return{set:set,get:get}}),myApp.controller("nextPageController","$location","userData",function($scope,$location,userData){$scope.detailsData=userData.get(),$scope.userDetails=JSON.parse($scope.detailsData),alert("details"+JSON.stringify($scope.userDetails)),console.log("details"+JSON.stringify($scope.userDetails))});