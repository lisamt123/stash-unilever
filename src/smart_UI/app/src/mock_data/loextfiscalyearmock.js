var loextfiscalyearmock = {
    generatePeriods(startDate, endDate, startChild){
        var periods = [];
        var ParentNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var dStart = new Date(startDate);
        var dEnd = new Date(endDate);
        var appendEndYear = false;
        if (dStart.getFullYear() != dEnd.getFullYear)
            appendEndYear = true;
        while (dStart < dEnd) {
            var s = new Date(dStart);

            var e = dStart.setDate(dStart.getDate() + 6);
            periods.push({
                'Parent': (!(appendEndYear && s.getFullYear() == dEnd.getFullYear()) ) ? ParentNames[s.getMonth()] : ParentNames[s.getMonth()] + ' ' + dEnd.getFullYear().toString().substring(2),
                'Date_From': s.getTime(),
                'Date_Thru': e,
                'Child': startChild
            });
            startChild++;
            dStart.setDate(dStart.getDate() + 1);
        }
        return periods;
    },

    readAll: function (promotionId) {
        var result = {
            '__Model': 'LOExtFiscalYear',
            '__Status': true,
            'data': [{
                'Id': 'a0a58000001QYEwAAO',
                'Date_From': '2016-02-01 00:00:00',
                'Date_Thru': '2017-01-31 00:00:00',

                'Periods': this.generatePeriods('2016-02-01 00:00:00', '2017-01-31 00:00:00', 1)


            }]
        };

        return result;
    },

    read: function (promotionId) {
        var d = new Date(promotionId.Reference_Date);
        var date_from = new Date(d.getFullYear(), 1, 24);
        var date_thru = new Date(d.getFullYear() + 1, 1, 1);
        var result = {
            '__Model': 'LOExtFiscalYear',
            '__Status': true,
            'data': [{
                'Id': 'a0a58000001QYEwAAO',
                'Date_From': date_from.getTime(),
                'Date_Thru': date_thru.getTime(),
                'Periods': this.generatePeriods(date_from.getTime(), date_thru.getTime(), 1)
            }]
        };

        return result;
    }

    /* Example data below.
     [{
     "Parent": "February",
     "Date_From": 1454281200000,
     "Date_Thru": 1454799600000,
     "Child": 1
     },
     {
     "Parent": "February",
     "Date_From": 1454886000000,
     "Date_Thru": 1455404400000,
     "Child": 2
     },
     {
     "Parent": "February",
     "Date_From": 1455490800000,
     "Date_Thru": 1456009200000,
     "Child": 3
     },
     {
     "Parent": "February",
     "Date_From": 1456095600000,
     "Date_Thru": 1456614000000,
     "Child": 4
     },
     {
     "Parent": "February",
     "Date_From": 1456700400000,
     "Date_Thru": 1457218800000,
     "Child": 5
     },
     {
     "Parent": "March",
     "Date_From": 1457305200000,
     "Date_Thru": 1457823600000,
     "Child": 6
     },
     {
     "Parent": "March",
     "Date_From": 1457910000000,
     "Date_Thru": 1458428400000,
     "Child": 7
     },
     {
     "Parent": "March",
     "Date_From": 1458514800000,
     "Date_Thru": 1459033200000,
     "Child": 8
     },
     {
     "Parent": "March",
     "Date_From": 1459116000000,
     "Date_Thru": 1459634400000,
     "Child": 9
     },
     {
     "Parent": "April",
     "Date_From": 1459720800000,
     "Date_Thru": 1460239200000,
     "Child": 10
     },
     {
     "Parent": "April",
     "Date_From": 1460325600000,
     "Date_Thru": 1460844000000,
     "Child": 11
     },
     {
     "Parent": "April",
     "Date_From": 1460930400000,
     "Date_Thru": 1461448800000,
     "Child": 12
     },
     {
     "Parent": "April",
     "Date_From": 1461535200000,
     "Date_Thru": 1462053600000,
     "Child": 13
     },
     {
     "Parent": "May",
     "Date_From": 1462140000000,
     "Date_Thru": 1462658400000,
     "Child": 14
     },
     {
     "Parent": "May",
     "Date_From": 1462744800000,
     "Date_Thru": 1463263200000,
     "Child": 15
     },
     {
     "Parent": "May",
     "Date_From": 1463349600000,
     "Date_Thru": 1463868000000,
     "Child": 16
     },
     {
     "Parent": "May",
     "Date_From": 1463954400000,
     "Date_Thru": 1464472800000,
     "Child": 17
     },
     {
     "Parent": "May",
     "Date_From": 1464559200000,
     "Date_Thru": 1465077600000,
     "Child": 18
     },
     {
     "Parent": "June",
     "Date_From": 1465164000000,
     "Date_Thru": 1465682400000,
     "Child": 19
     },
     {
     "Parent": "June",
     "Date_From": 1465768800000,
     "Date_Thru": 1466287200000,
     "Child": 20
     },
     {
     "Parent": "June",
     "Date_From": 1466373600000,
     "Date_Thru": 1466892000000,
     "Child": 21
     },
     {
     "Parent": "June",
     "Date_From": 1466978400000,
     "Date_Thru": 1467496800000,
     "Child": 22
     },
     {
     "Parent": "July",
     "Date_From": 1467583200000,
     "Date_Thru": 1468101600000,
     "Child": 23
     },
     {
     "Parent": "July",
     "Date_From": 1468188000000,
     "Date_Thru": 1468706400000,
     "Child": 24
     },
     {
     "Parent": "July",
     "Date_From": 1468792800000,
     "Date_Thru": 1469311200000,
     "Child": 25
     },
     {
     "Parent": "July",
     "Date_From": 1469397600000,
     "Date_Thru": 1469916000000,
     "Child": 26
     },
     {
     "Parent": "August",
     "Date_From": 1470002400000,
     "Date_Thru": 1470520800000,
     "Child": 27
     },
     {
     "Parent": "August",
     "Date_From": 1470607200000,
     "Date_Thru": 1471125600000,
     "Child": 28
     },
     {
     "Parent": "August",
     "Date_From": 1471212000000,
     "Date_Thru": 1471730400000,
     "Child": 29
     },
     {
     "Parent": "August",
     "Date_From": 1471816800000,
     "Date_Thru": 1472335200000,
     "Child": 30
     },
     {
     "Parent": "August",
     "Date_From": 1472421600000,
     "Date_Thru": 1472940000000,
     "Child": 31
     },
     {
     "Parent": "September",
     "Date_From": 1473026400000,
     "Date_Thru": 1473544800000,
     "Child": 32
     },
     {
     "Parent": "September",
     "Date_From": 1473631200000,
     "Date_Thru": 1474149600000,
     "Child": 33
     },
     {
     "Parent": "September",
     "Date_From": 1474236000000,
     "Date_Thru": 1474754400000,
     "Child": 34
     },
     {
     "Parent": "September",
     "Date_From": 1474840800000,
     "Date_Thru": 1475359200000,
     "Child": 35
     },
     {
     "Parent": "October",
     "Date_From": 1475445600000,
     "Date_Thru": 1475964000000,
     "Child": 36
     },
     {
     "Parent": "October",
     "Date_From": 1476050400000,
     "Date_Thru": 1476568800000,
     "Child": 37
     },
     {
     "Parent": "October",
     "Date_From": 1476655200000,
     "Date_Thru": 1477173600000,
     "Child": 38
     },
     {
     "Parent": "October",
     "Date_From": 1477260000000,
     "Date_Thru": 1477778400000,
     "Child": 39
     },
     {
     "Parent": "October",
     "Date_From": 1477868400000,
     "Date_Thru": 1478386800000,
     "Child": 40
     },
     {
     "Parent": "November",
     "Date_From": 1478473200000,
     "Date_Thru": 1478991600000,
     "Child": 41
     },
     {
     "Parent": "November",
     "Date_From": 1479078000000,
     "Date_Thru": 1479596400000,
     "Child": 42
     },
     {
     "Parent": "November",
     "Date_From": 1479682800000,
     "Date_Thru": 1480201200000,
     "Child": 43
     },
     {
     "Parent": "November",
     "Date_From": 1480287600000,
     "Date_Thru": 1480806000000,
     "Child": 44
     },
     {
     "Parent": "December",
     "Date_From": 1480892400000,
     "Date_Thru": 1481410800000,
     "Child": 45
     },
     {
     "Parent": "December",
     "Date_From": 1481497200000,
     "Date_Thru": 1482015600000,
     "Child": 46
     },
     {
     "Parent": "December",
     "Date_From": 1482102000000,
     "Date_Thru": 1482620400000,
     "Child": 47
     },
     {
     "Parent": "December",
     "Date_From": 1482706800000,
     "Date_Thru": 1483225200000,
     "Child": 48
     },
     {
     "Parent": "January 17",
     "Date_From": 1483311600000,
     "Date_Thru": 1483830000000,
     "Child": 49
     },
     {
     "Parent": "January 17",
     "Date_From": 1483916400000,
     "Date_Thru": 1484434800000,
     "Child": 50
     },
     {
     "Parent": "January 17",
     "Date_From": 1484521200000,
     "Date_Thru": 1485039600000,
     "Child": 51
     },
     {
     "Parent": "January 17",
     "Date_From": 1485126000000,
     "Date_Thru": 1485644400000,
     "Child": 52
     },
     {
     "Parent": "January 17",
     "Date_From": 1485730800000,
     "Date_Thru": 1486249200000,
     "Child": 53
     }]*/
};

module.exports = loextfiscalyearmock;
