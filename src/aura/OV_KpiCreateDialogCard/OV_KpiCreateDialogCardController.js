({
    onSelectChange: function(component, event, helper) {
        var selectedText  = '';
        var selectedValue = component.find('selectboxElement').get('v.value');

        // do not send name if no value is selected
        if (selectedValue !== '0' && !!selectedValue === true) {
            var options       = component.get('v.optionList');
            for (var i = 0, len = options.length; i < len; i++) {
                if (options[i].value === selectedValue) {
                    selectedText = options[i].label;
                    break;
                }
            }
        }

        $A.get('e.c:OV_SelectboxChange').setParams({
            selectboxName  : component.get('v.selectboxName'),
            selectboxValue : selectedValue,
            selectboxLabel : selectedText
        }).fire();
    }
})