({
    creteTreeNode: function(parentNode, type, filters, nodeId) {
        parentNode = $(parentNode);
        var ul = $('<ul>');
        if (parentNode[0].nodeName === 'UL') {
            ul = parentNode;
        }
        if (!!nodeId) {
            ul.attr('id', nodeId);
        }
        for (var i in filters) {
            var li = $('<li>');
            var a = $('<a>');
            a.attr('data-type', type);
            a.attr('data-value', filters[i].Id);
            a.attr('data-name', filters[i].Name);
            a.text(filters[i].Name)
            li.append(a);
            //debugger;
            if ($.isArray(filters[i].Children) && filters[i].Children.length) {
                //debugger;
                var inner = this.creteTreeNode(li, type, filters[i].Children);
                li.append(inner);
            }
            ul.append(li);
        }
        if (parentNode[0].nodeName !== 'UL') {
            $(parentNode).append(ul);
        }
        return parentNode;
    }
})