/******************************************************************************
 *@Description:This script is used for comments modal view specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
******************************************************************************/
var jq = jQuery.noConflict();
/* Below script is related to the comments box. It will add a class for the textbox. Also it removes the style attribute if the condition is true. */
jq("textarea[placeholder]").each(function() {
    var $this = jq(this);
    $this.addClass('txtAreaStyle');
    if ($this.text() !== "Add your comments here") {
        $this.text($this.attr("placeholder")).focus(function() {
            if ($this.text() === $this.attr("placeholder")) {
                $this.text("").removeAttr("style");
            }
        }).blur(function() {
            if ($this.text() === "Add your comments here") {
                $this.text($this.attr("placeholder")).addClass('txtAreaStyle');
            }
        });
    }
});