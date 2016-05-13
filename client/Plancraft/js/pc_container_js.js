// active link setup
var setActiveLink = function(itemId) {
    jQuery('.menuTabs a.active').removeClass('active');
    jQuery('#' + itemId).addClass('active');
};

initContainer = function(logoId) {
	
	// avoid multiple nested windows
    if (window.top !== window.self) {
        window.top.location = window.location;
    }

    // loading of specific page in inframe if param defined ...
    var defaultSrc = '/apex/PC_HOME';
    src = defaultSrc;

    try {
        var urlParams  = (function () {
            var match,
                pl     = /\+/g,  // Regex for replacing addition symbol with a space
                search = /([^&=]+)=?([^&]*)/g,
                decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
                query  = window.location.search.substring(1);

            var result = {};
            while (match = search.exec(query)) {
               result[decode(match[1])] = decode(match[2]);
            }
            return result;
        })();

        if (urlParams.TrainingPlanId) {
            src = '/apex/TrainingPlanPreview?id=' + urlParams.TrainingPlanId;
            setActiveLink('pbs');
        }
    } catch (e) {
        // do nothing, fallback is to default url
    }

    var iframe         = document.createElement('iframe');
    iframe.name        = 'innerFrame';
    // set src
    iframe.src         = src;
	//$('#iframe').attr('src', '/apex/TrainingPlanPreview?id=' + urlParams.TrainingPlanId);
    // set styles
    iframe.width       = '100%';
    iframe.height      = '3400px';
    iframe.frameBorder = '0';	
    iframe.scrolling   = 'no';
    iframe.sandbox     = 'allow-forms allow-same-origin allow-scripts allow-top-navigation allow-popups';

    document.getElementById('bodyWrapper').appendChild(iframe);

    // move search form to new location
    var form = document.getElementById('phSearchForm');
    form.remove();
    form.target = '_blank';

    var logo = document.getElementById(logoId);
    logo.parentNode.appendChild(form);

    // cleanup
    try {
        var tmp;
        tmp = document.getElementById('AppBodyHeader');
        if (tmp) {
            tmp.remove();
            tmp = null;
        }
        tmp = document.getElementsByClassName('bPageFooter');
        if (tmp && tmp.lenght) {
            tmp[0].remove();
            tmp = null;
        }
    } catch (e) {

    }

    // add scrolling to background image
    window.onscroll = function() {
        var speed = 2.0;
        document.body.style.backgroundPosition = (-100+ (-window.pageYOffset / speed)) + 'px 0';
    };

    var receiveMessage = function(event) {
        if (event.data && event.data.itemId) {
            setActiveLink(event.data.itemId);
        }
    };

    window.addEventListener("message", receiveMessage, false);
};