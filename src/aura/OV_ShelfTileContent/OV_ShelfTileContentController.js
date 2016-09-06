({
    doInit : function(component, event, helper) {
        var inCallback = function(response) {
            // check if data is available
            if (!response || response.status !== '0' || !response.data || !response.data.structure) {
                $A.error('An error occured');
                return;
            }

            // group data in variables
            var foundHeaders  = [];
            var groups        = {};

            for (var heading in response.data.structure) {
                // skip functions etc
                if (typeof heading !== 'string') {
                    continue;
                }
                // record heading
                foundHeaders.push(heading);
                // record groups
                groups[heading] = response.data.structure[heading].folderLevelMembers;
            }

            component.set('v.headingList', groups);
            component.set('v.headingTitleList', foundHeaders);

            helper.getTileReports(component, inCallback);
        };
        helper.getTileReports(component, inCallback);
    }
})