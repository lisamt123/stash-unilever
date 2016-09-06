({
    // Handle component initialization
    doInit: function(component, event, helper) {
        var createFeed = function() {
            $A.run(function(){
                if (!component.isValid()) {
                    return;
                }

                var reportId = component.get("v.reportId");
                if (!reportId || reportId === 'dummyId') {
                    setTimeout(createFeed, 1000);
                    return;
                }

                // Dynamically create the feed with the specified type
                $A.componentService.newComponentAsync(
                    this,
                    function(feed) {
                        var feedContainer = component.find("feedContainer");
                        feedContainer.set("v.body", feed);
                    }, {
                        componentDef: "markup://forceChatter:feed",
                        attributes: {
                            values: {
                                subjectId : reportId,
                                type      : 'Record'
                            }
                        }
                    }
                );
            });
        };

        if (component.isValid()) {
            setTimeout(createFeed, 1000);
        }
    },

    postToChatter: function(component, event, helper)
    {
        var action = {
            "executionComponent": {
                "descriptor"            : "markup://force:quickActionRunnable",
                "isEvent"               : false,
                "isClientSideCreatable" : true,
                "attributes"            : {
                    "subjectId"             : component.get("v.reportId"),
                    "quickActionDefinition" : {
                        "actionId"      : "FeedItem.TextPost",
                        "componentName" : "forceChatter:textPost",
                        "publisherType" : "TEXT_POST",
                        "attributes"    : {
                            "contextualMessages" : [],
                            "quickActionLabel"   : "Post",
                            "publisherId"        : "publisher" + new Date().getTime(),
                            "publisherFeedType"  : "Record",
                            "quickActionApiName" : "FeedItem.TextPost",
                            "visibilityOptions"  : {
                                "defaultMessage"                     : component.get("v.reportData.reportTitle"),
                                "visibilityOptions"                  : [],
                                "showOptionsInsteadOfDefaultMessage" : false,
                                "toLabel"                            : "To followers of",
                            },
                            "isCommunityTemplateRecordPublisherContext": true
                        }
                    }
                }
            },
            "devNameOrId": "FeedItem.TextPost"
        };

        action = $A.newCmp({
            componentDef : "markup://force:action",
            attributes   : {
                values : {
                    action : action
                }
            }
        });

        action.get("e.trigger").fire();
    }
})