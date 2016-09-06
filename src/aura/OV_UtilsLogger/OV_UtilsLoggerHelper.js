({
    logCustom: function() {
        var level = 'log';

        if (arguments.length > 0 && typeof arguments[0] === 'string') {
            level = arguments[0].toLowerCase();
            // translate levels
            switch (level) {
                case 'warning':
                    level = 'warn';
                break;

                case 'assert':
                    level = 'debug';
                break;

                default:
                    break;
            }

            // defalt to "log" level
            if (['log', 'info', 'error', 'warn', 'debug', 'dir'].indexOf(level) === -1) {
                level = 'log';
            }
        }

        if (console && typeof console[level] === 'function') {
            console[level].apply(console, [(new Date().toJSON()), '[[LOG]]: '].concat(Array.prototype.slice.call(arguments)));
        }
    }
})