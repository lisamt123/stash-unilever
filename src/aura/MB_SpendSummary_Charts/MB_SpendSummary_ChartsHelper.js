({
    helperMethodforpieCharts : function(component,res) {
        
        var pie = new d3pie("pie1", {
            "size": {
                "canvasHeight": 160,
                "canvasWidth": 160,
                "pieOuterRadius": "88%"
            },
            "data": {
                "content": [
                    {
                        "label": "International",
                        "value": res.totalDomesticDataUsage,
                        "color": "#0C8EFF"
                    },
                    {
                        "label": "International",
                        "value": res.totalInternationalDataUsage,
                        "color": "#4F6A92"
                    }
                ]
            },
            "labels": {
                "outer": {
                    "format": "none",
                    "pieDistance": 32
                },
                "inner": {
                    "format": "none"
                },
                "mainLabel": {
                    "color": "#d6e4df",
                    "font": "verdana"
                },
                "percentage": {
                    "color": "#e1e1e1",
                    "font": "verdana",
                    "decimalPlaces": 0
                },
                "value": {
                    "color": "#e1e1e1",
                    "font": "verdana"
                },
                "truncation": {
                    "enabled": true
                }
            },
            "effects": {
                "pullOutSegmentOnClick": {
                    "effect": "none",
                    "speed": 400,
                    "size": 8
                }
            }
        });   
        
    },
    helperMethodforpieCharts1 : function(component,res) {
        
        var pie = new d3pie("pie2", {
            "size": {
                "canvasHeight": 160,
                "canvasWidth": 160,
                "pieOuterRadius": "88%"
            },
            "data": {
                "content": [
                    {
                        "label": "International",
                        "value": res.totalDomesticCallUsage,
                        "color": "#0C8EFF"
                    },
                    {
                        "label": "International",
                        "value": res.totalInternationalCallUsage,
                        "color": "#4F6A92"
                    }
                ]
            },
            "labels": {
                "outer": {
                    "format": "none",
                    "pieDistance": 32
                },
                "inner": {
                    "format": "none"
                },
                "mainLabel": {
                    "color": "#d6e4df",
                    "font": "verdana"
                },
                "percentage": {
                    "color": "#e1e1e1",
                    "font": "verdana",
                    "decimalPlaces": 0
                },
                "value": {
                    "color": "#e1e1e1",
                    "font": "verdana"
                },
                "truncation": {
                    "enabled": true
                }
            },
            "effects": {
                "pullOutSegmentOnClick": {
                    "effect": "none",
                    "speed": 400,
                    "size": 8
                }
            }
        });     
    },
    helperMethodforpieCharts2 : function(component,res) {
        
        var pie = new d3pie("pie3", {
            "size": {
                "canvasHeight": 160,
                "canvasWidth": 160,
                "pieOuterRadius": "88%"
            },
            "data": {
                "content": [
                    {
                        "label": "International",
                        "value": res.totalDomesticSMSUsage,
                        "color": "#0C8EFF"
                    },
                    {
                        "label": "International",
                        "value": res.totalInternationalSMSUsage,
                        "color": "#4F6A92"
                    }
                ]
            },
            "labels": {
                "outer": {
                    "format": "none",
                    "pieDistance": 32
                },
                "inner": {
                    "format": "none"
                },
                "mainLabel": {
                    "color": "#d6e4df",
                    "font": "verdana"
                },
                "percentage": {
                    "color": "#e1e1e1",
                    "font": "verdana",
                    "decimalPlaces": 0
                },
                "value": {
                    "color": "#e1e1e1",
                    "font": "verdana"
                },
                "truncation": {
                    "enabled": true
                }
            },
            "effects": {
                "pullOutSegmentOnClick": {
                    "effect": "none",
                    "speed": 400,
                    "size": 8
                }
            }
        });   
        
    },
    helperMethodforpieCharts3 : function(component,res) {
        
        var pie = new d3pie("pie4", {
            "size": {
                "canvasHeight": 160,
                "canvasWidth": 160,
                "pieOuterRadius": "88%"
            },
            "data": {
                "content": [
                    {
                        "label": "International",
                        "value": res.totalDomesticIpassUsage,
                        "color": "#0C8EFF"
                    },
                    {
                        "label": "International",
                        "value": res.totalInternationalIpassUsage,
                        "color": "#4F6A92"
                    }
                ]
            },
            "labels": {
                "outer": {
                    "format": "none",
                    "pieDistance": 32
                },
                "inner": {
                    "format": "none"
                },
                "mainLabel": {
                    "color": "#d6e4df",
                    "font": "verdana"
                },
                "percentage": {
                    "color": "#e1e1e1",
                    "font": "verdana",
                    "decimalPlaces": 0
                },
                "value": {
                    "color": "#e1e1e1",
                    "font": "verdana"
                },
                "truncation": {
                    "enabled": true
                }
            },
            "effects": {
                "pullOutSegmentOnClick": {
                    "effect": "none",
                    "speed": 400,
                    "size": 8
                }
            }
        });   
        
    },
    helperMethodforpieChartsColumn : function(component,res1) {
         var actdata=res1.totalDataUsage;
        var avgdata=res1.totalAverageDataUsage;
        component.set("v.DataYou",actdata);
        component.set("v.DataColleagues",avgdata);
        var actdata1=component.get("v.DataYou"); 
        var avgdata1=component.get("v.DataColleagues");
        var avgdata2=(avgdata1/ (0.5*avgdata1+actdata1))*100;
        var actdata2=(actdata1/ (0.5*avgdata1+actdata1))*100;
        $('.line_bar_data').height(actdata2+'px');
        $('.line_bars_data').height(avgdata2+'px'); 
    },
    helperMethodforpieChartsColumn1 : function(component,res1) {
         var actCalls=(res1.totalCallUsage);
        var avgCalls=(res1.totalAverageCallUsage);
        component.set("v.CallsYou",actCalls);
        component.set("v.CallsColleagues",avgCalls);
        var actCalls1=component.get("v.CallsYou"); 
        var avgCalls1=component.get("v.CallsColleagues");
        var avgCalls2=(avgCalls1/ (0.5*avgCalls1+actCalls1))*100;  
        var actCalls2=(actCalls1 / (0.5*avgCalls1+actCalls1))*100;
        $('.line_bar_calls').height(actCalls2+'px');
        $('.line_bars_calls').height(avgCalls2+'px'); 
    },  
    helperMethodforpieChartsColumn2 : function(component,res1) {
         var actSMS=(res1.totalMessageUsage);
        var avgSMS=(res1.totalAverageMessageUsage);
        component.set("v.SMSYou",actSMS);
        component.set("v.SMSColleagues",avgSMS); 
        var actSMS1=component.get("v.SMSYou");
        var avgSMS1=component.get("v.SMSColleagues");
        var avgSMS2=(avgSMS1/ (0.5*avgSMS1+actSMS1))*100;
        var actSMS2=(actSMS1 / (0.5*avgSMS1+actSMS1))*100;
        $('.line_bar_SMS').height(actSMS2+'px');
        $('.line_bars_SMS').height(avgSMS2+'px'); 
    },  
     helperMethodforpieChartsColumn3 : function(component,res1) {
        var actiPass=(res1.totalIpassUsage);
        var avgiPass=(res1.totalAverageIpassUsage);  
         component.set("v.iPassYou",actiPass);
         component.set("v.iPassColleagues",avgiPass);
        var actiPass1=component.get("v.iPassYou");
        var avgiPass1=component.get("v.iPassColleagues");
        var avgiPass2=(avgiPass1/ (0.5*avgiPass1+actiPass1))*100;
        var actiPass2=(actiPass1 / (0.5*avgiPass1+actiPass1))*100; 
        $('.line_bars_ipass').height(parseInt(actiPass2)+'px');
        $('.line_bar_ipass').height(parseInt(avgiPass2)+'px');       
    },  
});