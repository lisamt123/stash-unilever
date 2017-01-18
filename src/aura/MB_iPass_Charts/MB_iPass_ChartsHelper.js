({
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

     helperMethodforpieChartsColumn3 : function(component,res) {
      var actiPass=(res.totalIpassUsageIn);
        var avgiPass=(res.totalAverageIpassUsageIn); 
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