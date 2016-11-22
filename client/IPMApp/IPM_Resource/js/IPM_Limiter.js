/******************************************************************************
*@Description:This script is used for character limit in IPM Gate Document page
*@Author: Cognizant
*@Created Date: 28/05/2015 
******************************************************************************/
/* Below script works on different key events. Based on the number of keys entered it shows the remaining characters and also once the user
enters the total number of characters matching the limit, it stops the user to enter furthermore characters. */
(function ( $ ) {
    $.fn.extend({
        limiter: function(limit, remaining, total) {
            $("#charCountRemainingText").show();
            var $this = $(this);
            $this.on("keydown keyup focus paste", function() {
                $("#charCountRemainingText").show();
                setCount(this);
            });
            $this.on("keyup keypress blur", function(e) {
                setCount(this, remaining, total);
                if (e.which < 0x20) {
                    return; // Do nothing
                }
                if (this.value.length === limit) {
                    e.preventDefault();
                } else if (this.value.length > limit) {
                    // Maximum exceeded
                    this.value = this.value.substring(0, limit);
                }
            });
            function setCount(src) {
                var charsCurrent = src.value.length;
                var chars = 0;
                $(".limitdesc").each(function(index, value) {
                    chars += $(value).val().length
                });
                if (chars > limit) {
                    chars = limit;
                }
                remaining.html(limit - chars);
                total.html(chars);
            }
            setCount($this[0]);
        }
    });
}( jQuery ));