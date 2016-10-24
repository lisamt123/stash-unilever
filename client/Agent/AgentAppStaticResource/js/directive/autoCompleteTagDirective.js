define(["require","module/module"],function(require){var myApp=require("module/module");myApp.directive("tagmanager",function(){return{restrict:"E",scope:{tags:"=tags",autocompleteData:"=autocompletetag"},template:'<div class="tags"><div ng-repeat="(idx, tag) in tags" class="tag label label-success">{{tag}} <a class="close" href ng-click="remove(idx)">×</a></div></div><div class="input-group"><input type="text" class="form-control" placeholder="add a tag..." ng-model="newValue" /> <span class="input-group-btn"><a class="btn btn-default" ng-click="add()">Add</a></span></div>',link:function($scope,$element){console.log("Objet : "+JSON.stringify($element));var input=angular.element($element).find("input");$scope.autocompleteData&&($scope.autocompleteFocus=function(event,ui){return input.val(ui.item.value),!1},$scope.autocompleteSelect=function(event,ui){return $scope.newValue=ui.item.value,$scope.$apply($scope.add),!1},$($element).find("input").autocompleteData({minLength:0,source:function(request,response){var item;return response(function(){var _i,_len,_ref,_results;for(_ref=$scope.autocompleteData,_results=[],_i=0,_len=_ref.length;_len>_i;_i++)item=_ref[_i],-1!==item.toLowerCase().indexOf(request.term.toLowerCase())&&_results.push(item);return _results}())},focus:function(_this){return function(event,ui){return $scope.autocompleteFocus(event,ui)}}(this),select:function(_this){return function(event,ui){return $scope.autocompleteSelect(event,ui)}}(this)})),$scope.add=function(){-1==$scope.tags.indexOf($scope.newValue)&&$scope.tags.push($scope.newValue),$scope.newValue=""},$scope.remove=function(idx){$scope.tags.splice(idx,1)},input.bind("keypress",function(event){13==event.keyCode&&$scope.$apply($scope.add)})}}})});