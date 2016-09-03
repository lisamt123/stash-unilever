({ 
    //On page load get the news article all the details using news article Id
	doInit : function(component, event, helper) {   
        var NewsId=component.get("v.newsId");
        component.set("v.carouselIndex",0);
        component.set("v.carouselSize",0);                
        var action = component.get("c.getNewsDetail");
        action.setParams({
			"NewsId": NewsId
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){
        			component.set("v.newsArticle", response.getReturnValue());
                    var richtextBody=response.getReturnValue().NewsBody;     
                    if(richtextBody!='' && richtextBody!=null){
                    	var richtextBodyTemp = richtextBody.replace(/height:/g, "height");
                    	richtextBody = richtextBodyTemp.replace(/width:/g, "width"); 
                    } 
                    component.set("v.NewsRichText",richtextBody);
                    component.set("v.LikeValue",response.getReturnValue().Liked);
                    component.set("v.defaultImage",!(response.getReturnValue().DefaultImage));
                    console.log('-----------Detail data----------'+component.get("v.newsArticle.NewsId"));
                    if(response.getReturnValue().RelatedNewsDetail!=null && response.getReturnValue().RelatedNewsDetail.length>=response.getReturnValue().CarouselLimit){
                        component.set("v.carouselSize",response.getReturnValue().CarouselLimit);
                    } else if (response.getReturnValue().RelatedNewsDetail!=null && response.getReturnValue().RelatedNewsDetail.length>0){
                        component.set("v.carouselSize",response.getReturnValue().RelatedNewsDetail.length);
                    }
                }
                else {
                    component.set("v.ErrorMessage", true);
                }
        	}
                            
        });
        $A.enqueueAction(action);
    },
    //Return to previous page
    buttonClick :function(component, event, helper) {
        var NewsType=component.get("v.NewsType");
        var selectEvent = $A.get("e.c:Core_NC_BackButtonEvent");
        selectEvent.setParams({"NewsType": NewsType}).fire();
    },
    //Increase the like count on click of the news article like
    LikeNews:function(component, event, helper) {
        var NewsId=component.get("v.newsId");
        var action = component.get("c.putLikeForNews");
        action.setParams({
			"NewsId": NewsId
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){
                    component.set("v.LikeValue",true);
                    component.set("v.newsArticle.LikeCount",response.getReturnValue());
                }
                else {
                    component.set("v.ErrorMessage", true);
                }
        	}
        });
        $A.enqueueAction(action);
    },
    //move to next carousel information
    nextCarousel:function(component, event, helper) {
        var carouselIndex=component.get("v.carouselIndex")+1;
        if(carouselIndex >= component.get("v.carouselSize")){            
        	component.set("v.carouselIndex",0);
        } else {
            component.set("v.carouselIndex",carouselIndex);
        }
    },
    //onclick of carousel indicator directly redirect to that particular carousel
    changeActiveCarousel:function(component, event, helper) {
        component.set("v.carouselIndex",event.getParam("selectedCarousel"));
    },
    //move to previous carousel information
    previousCarousel:function(component, event, helper) {
        var carouselIndex=component.get("v.carouselIndex")-1;
        if(carouselIndex >= 0){            
        	component.set("v.carouselIndex",carouselIndex);
        } else {
            component.set("v.carouselIndex",component.get("v.carouselSize")-1);
        }
    },
    //redirect Chatter Share page
    ShareNews:function(component, event, helper) {
        var newsArticle = component.get("v.newsArticle");
        var NewsType=component.get("v.NewsType");
        var selectEvent = $A.get("e.c:Core_NC_SharePage");
        selectEvent.setParams({"NewsDetail": newsArticle,"NewsType": NewsType }).fire();
    },
    //Redirect to news detail, onclick of carousel Indicator banner
    gotoBannerNewsDetail : function(component, event, helper) {
        var carouselIndex=component.get("v.carouselIndex");
        var newArticleList=component.get("v.newsArticle");
        var selectEvent = $A.get("e.c:CORE_NC_SelectNewsId");
        selectEvent.setParams({"selectedNewsDetail":newArticleList.RelatedNewsDetail[carouselIndex].NewsId,"NewsType":component.get("v.NewsType") }).fire();
	},
    navigateToComment : function(component,evt) {
        var middleElem = component.find("bottomCommentSection").getElement();
        helper.scrollToLocation(component, middleElem);
    },
    postChatterInfo: function(component, event, helper){
        var action = { "executionComponent":{  
              "descriptor":"markup://force:quickActionRunnable",
              "isEvent":false,
              "isClientSideCreatable":true,
              "attributes":{  
                 "subjectId":component.get("v.newsId"),
                 "quickActionDefinition":{  
                    "actionId":"FeedItem.TextPost",
                    "componentName":"forceChatter:textPost",
                    "publisherType":"TEXT_POST",
                    "attributes":{  
                       "contextualMessages":[          
                       ],
                       "quickActionLabel":"Post",
                       "publisherId":"publisher"+new Date().getTime(),
                       "publisherFeedType":"Record",
                       "quickActionApiName":"FeedItem.TextPost",
                       "visibilityOptions":{  
                          "defaultMessage":"this TODO:INSERT_OBJECT_LABEL",
                          "visibilityOptions":[          
                          ],
                          "showOptionsInsteadOfDefaultMessage":false,
                          "toLabel":"To"
                       }
                    }
                 }
              }
           },
           "devNameOrId":"FeedItem.TextPost",
        }        
        action = $A.newcomponent({
        componentDef : "markup://force:action",
          attributes : {
              values : {
                action: action
              }
          }
        });        
        action.get("e.trigger").fire();
    },
     navigateToBottomElement : function(component, event, helper) {
		helper.scrollToLocation(component, "bottom");
    },
    navigateToMiddleElement : function(component, event, helper) {
        var middleElem = component.find("middlediv").getElement();
        helper.scrollToLocation(component, middleElem);
    },    
    scrollToTop : function(component, event, helper){   
		helper.scrollToLocation(component, "top");
    }
})