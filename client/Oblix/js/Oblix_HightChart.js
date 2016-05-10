    (function () {
          
    

    // create new set of data structure for rendering chart

    var groupUnitData = _.groupBy(leaseData, 'unitName');
    var uniqueUnitNames = _.sortBy(_.keys(groupUnitData), function (name) {
        return name;
    });
    console.log(JSON.stringify(groupUnitData, null, 4));


    var getLeaseIntervals = function (unitLeases, unitName) {
        // Find highest rent for the unit
        var highestRent = _.max(unitLeases, function (unitLease) {
            return unitLease.rent;
        })['rent'];

        // Get all the intervals for the unit
        var leaseIntervals = [];
        
        $.each(unitLeases, function (i, unitLeaseVal) {
            
            leaseIntervals.push({
                    x: unitLeaseVal.beginTimestamp,
                    y: _.indexOf(uniqueUnitNames, unitName),
                    start: unitLeaseVal.beginTimestamp,
                    end: unitLeaseVal.endTimestamp,
                    name:"Project Start date "
                },{
                    x:unitLeaseVal.endTimestamp,
                    y:_.indexOf(uniqueUnitNames, unitName),
                    start:unitLeaseVal.beginTimestamp,
                    end:unitLeaseVal.endTimestamp,
                    name:"Project Finish date "
                },{
                    x: unitLeaseVal.x1Timestamp,
                    y: _.indexOf(uniqueUnitNames, unitName),
                    start: unitLeaseVal.beginTimestamp,
                    end: unitLeaseVal.endTimestamp,
                    name:"Project Completion date "
                },{
                    x:unitLeaseVal.x2Timestamp,
                    y:_.indexOf(uniqueUnitNames, unitName),
                    start:unitLeaseVal.beginTimestamp,
                    end:unitLeaseVal.endTimestamp,
                    name:"First Air date "
                },{
                    x:unitLeaseVal.x3Timestamp,
                    y:_.indexOf(uniqueUnitNames, unitName),
                    start:unitLeaseVal.beginTimestamp,
                    end:unitLeaseVal.endTimestamp,
                    name:"Production Completion date "
                }
                );
            if (unitLeases[i + 1]) {
                leaseIntervals.push(
                    [(unitLeaseVal.endTimestamp + unitLeases[i + 1].beginTimestamp)/2 , null]
                )
            }
        });

        return leaseIntervals;

    };

    var leaseRent = _.map(groupUnitData, function (unitLeases, unitName) {
        var lease = getLeaseIntervals(
            _.sortBy(unitLeases, function (obj) {
                return obj.beginTimestamp;
            }),
            unitName
        );

        return {
            name:unitName,
			 marker: {
                symbol: 'square'
            },
			states: {
				hover: {
					enabled: false
				}
             },
            data:lease
        };

    });
    //Sort the data, otherwise Highchart will complain error15
    var series = _.sortBy(leaseRent, function (obj) {
        return obj.name;
    });

    console.log(series);
    //Render Gantt Chart
    var chart = new Highcharts.Chart({
        chart:{
            renderTo:'lease-gantt-chart',
            backgroundColor: null
        },
        title:{
            text:''
        },
        xAxis:{
            type:'datetime'
        },
        yAxis:{
            tickInterval:1,
            startOnTick:true,
            endOnTick:false,
            labels:{
                // apartment names
                formatter:function () {
                    if (series[this.value]) {
                        return uniqueUnitNames[this.value];
                    }
                }
            },

            title:{
                text:"Projects"
            },
            minPadding:0.2,
            maxPadding:0.2

        },
        credits: {
                  enabled: false
            },
       
        legend:{
            enabled:false
        },
        tooltip:{
            formatter:function () {
               
                return '<b>' + uniqueUnitNames[this.y] + ' : </b> <br/>'
                     +this.point.options.name +'<br/>'
                     +Highcharts.dateFormat('%e, %b %Y', this.point.options.x);
            }
        },
        plotOptions: {
            spline: {
                marker: {
                    radius: 4,
                    lineColor: '#666666',
                    lineWidth: 1
                }
            }
        },
        series:series,
        exporting: {
            buttons: {
                contextButton: {
                        menuItems: [{
                            textKey: 'downloadPNG',
                            onclick: function () {
                                this.exportChart();
                            }
                        }, {
                            textKey: 'downloadJPEG',
                            onclick: function () {
                                this.exportChart({
                                    type: 'image/jpeg'
                                });
                            }
                        }]
                }
            }
        }
    });

})();
