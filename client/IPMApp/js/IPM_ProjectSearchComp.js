/*  
*************************************************************************
*@Description:This script is used for project search page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
*************************************************************************
*/ 
/* Since we are using global variables we will not be able to create multiple functions. 
If we split the script to multiple functions the functionality will break. 
Also variables have to be kept global to make the functionality work. */
 jq(document).ready(function() {                           
                            
    var geoAll;
    var clusters = [];  
    var mcos = [];
    var countries = [];
    var unAssigned = 'false';
    var iTORange1 = -1;
    var brandPositions = [];
    var iTORange2 = -1;

/* Below function is to load the projects */
    function searchProjects() {
        loadProjects(jq('#srchTxt').val());
    }
    
    jq(document).on('click', '#resetFilterBtnNew', function() {
        location.reload();
    });

/* Below code is to filter the TLD's */
    function filterTLDs() {
        filterTLD(jq('#tldFrom').val(), jq('#tldTo').val());
    }

/* Below code is to check or uncheck the checkboxes based on the selected values */
    function wrapGeography() {
        geoAll = jq('#geographyAll').is(":checked");
        clusters = [];mcos=[];countries=[];
        jq('.clusterCheck').each(function() {
            if (jq(this).is(":checked") == true &&  jq(this).val() != 'Unassigned' ) {
                clusters.push(jq(this).val());
            }
            if(jq(this).is(":checked") == true && jq(this).val() == 'Unassigned'){
                    unAssigned = 'true';
            }
            
        });
        jq('.mcoCheck').each(function() {
            if (jq(this).is(":checked") == true) {
                mcos.push(jq(this).val());
            }
        });
        jq('.countryCheck').each(function() {
            if (jq(this).is(":checked") == true) {
                countries.push(jq(this).val());
            }
        });
    }

    function unCheckChildren(str) {
        jq('.' + str).each(function() {
            if (jq(this).val() != 'all') {
                jq(this).attr("checked", false);
            }
        });
    }

    function checkChildren(str) {
        jq('.' + str).each(function() {
            jq(this).attr("checked", true);
        });
    }

    function unCheckParent(str) {
        jq('.' + str).each(function() {
            if (jq(this).val() == 'all') {
                jq(this).attr("checked", false);
            }
        });
    }
    jq("#applyFilter").on("click", function() { 
        applyFilter();
    });
	
/* Below code is to push the selected values from the filter */
    function applyFilter() {
            var checkedPhases = [];
            var checkedProjectTypes = [];
            jq('.phase').each(function() {
                if (jq(this).is(":checked") ){
                    checkedPhases.push(jq(this).val());
                }
            });
            jq('.projectType').each(function() {
                 if (jq(this).is(":checked")){
                 checkedProjectTypes.push(jq(this).val());
             }
            });

            wrapGeography();                
            if (jq('.iTORange1').val() != '') {
                iTORange1 = jq('.iTORange1').val();
            }
            if (jq('.iTORange2').val() != '') {
                iTORange2 = jq('.iTORange2').val();
            }
            applyFltr(checkedPhases.toString(), jq('.tldFrom').val(), jq('.tldTo').val(), jq('.my').is(":checked"), jq('.aPro').is(":checked"), geoAll, clusters, mcos, countries.toString(), iTORange1, iTORange2, brandPositions.toString(),checkedProjectTypes.toString(),jq('#ActiveProjects').is(':checked'),jq('#StoppedProjects').is(':checked'),unAssigned);   
        }
    
     jq(".dueDate,.comDate").each(function() {
        jq(this).text(jq(this).text().replace('00:00:00 GMT', ''));
    });

    jq('tr:nth-child(4n),tr:nth-child(4n-1)').addClass('greyColr').removeClass('noBackground');
    jq('tr:nth-child(4n)').addClass('genRowOdd');

    jq('#srchTxt').keypress(function(e) {
        if (e.which == 13) {
            loadProjects(jq('#srchTxt').val());
            return false;
        }
    });
    jq('#srchBrand').keypress(function(e) {
        if (e.which == 13) {
            loadProjects(jq('#srchBrand').val());
            return false;
        }
    });
  
    jq(".docFilter").on("click", ".checkAll", function() {
        if (jq(this).is(":checked")) {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]:not('[disabled]')").prop("checked", true);
            jq(this).closest("ul").find("input[type=checkbox]:not('[disabled]')").next().addClass("selected");
        } else {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]:not('[disabled]')").prop("checked", false);
            jq(this).closest("ul").find("input[type=checkbox]:not('[disabled]')").next().removeClass("selected");
        }
    });
	
/* Below code is to check the selected checkboxes */
    jq(".docFilter").on("click", ".checkSub", function() {
        var checkSub = jq(this).closest("ul").find(".checkSub:checked").closest("li").length;
        var checkNot = jq(this).closest("ul").find(".checkSub").closest("li").length;

        if (jq(this).hasClass('countryCheck')) {
            if (jq(this).is(':checked')) {
                jq(this).closest("ul").find("li input.checkAll").prop("checked", true);
                jq(this).closest("ul").find("li input.checkAll").next("label").addClass("selected");
            } else {
                checkSub = jq(this).closest("ul").find(".checkSub:checked:not('.mcoCheck')").closest("li").length;
                if (checkSub == 0) {
                    jq(this).closest("ul").find("li input.checkAll").prop("checked", false);
                    jq(this).closest("ul").find("li input.checkAll").next("label").removeClass("selected");
                }
            }
        } else if (jq(this).hasClass('mcoCheck')) {
            if (jq(this).is(':checked')) {
                jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", true);
                jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').next("label").addClass("selected");

                jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", true);
                jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').next("label").addClass("selected");
            } else {
                checkSub = jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find(".mcoCheck.checkSub:checked").length;

                if (checkSub == 0) {
                    jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", false);
                    jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').next("label").removeClass("selected");

                    jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", false);
                    jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').next("label").removeClass("selected");
                }
            }
        } else if (jq(this).hasClass('clusterCheck')) {
            checkSub = jq(this).closest("ul").closest('ul.geographyAllUl').find('.clusterCheckLi').find(".clusterCheck.checkSub:checked").length;
            checkNot = jq(this).closest("ul").closest('ul.geographyAllUl').find('.clusterCheckLi').find(".clusterCheck.checkSub").length;
            if (checkNot != checkSub) {
                jq('input.geographyAllLevel1').prop("checked", false);
                jq('input.geographyAllLevel1').next("label").removeClass('selected');
            }
            if (checkNot == checkSub) {
                jq('input.geographyAllLevel1').prop("checked", true);
                jq('input.geographyAllLevel1').next("label").addClass('selected');
            }
        } else {
            if (checkNot != checkSub) {
                if (jq(this).hasClass('clusterCheck')) {
                    jq('input.geographyAllLevel1').prop("checked", false);
                    jq('input.geographyAllLevel1').next("label").removeClass('selected');
                }
                jq(this).closest("ul").find("li input.checkAll").prop("checked", false);
                jq(this).closest("ul").find("li input.checkAll").next("label").removeClass("selected");
            }
            if (checkNot == checkSub) {
                if (jq(this).hasClass('clusterCheck')) {
                    jq('input.geographyAllLevel1').prop("checked", true);
                    jq('input.geographyAllLevel1').next("label").addClass('selected');
                }
                jq(this).closest("ul").find("li input.checkAll").prop("checked", true);
                jq(this).closest("ul").find("li input.checkAll").next("label").addClass("selected");
            }
        }
    });

    
/* Below code is for the auto complete functionality */   
    jq(".filterBrand").autocomplete({
        source: brandList,
        select: function(event, ui) {
            jq('.filterBrand').html('');
            if(jq.inArray( ui.item.value, brandPositions) == -1) {
                brandPositions.push(ui.item.value);
                return jq('<li class="brndFilter"></li>').append('<div class="selectedBrand">' + ui.item.value + '</div>').appendTo(jq('ul.filterBrandList'));
            }
        }
    });
     jq(".filterBrandList").on("click", ".brndFilter", function() {
        brandPositions.splice( jq.inArray(jq(this).text(), brandPositions), 1 );
        jq(this).remove();
    });
    
});
