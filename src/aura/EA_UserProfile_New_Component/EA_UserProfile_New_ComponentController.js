({
    doInit : function(component, event, helper) {
        var action=component.get("c.getUserDetail"); 
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue();
                component.set("v.userDetail", response.getReturnValue());
                var a=items[0].activity_points ;
                component.set("v.CurrentPoints",a);
            } 
        });
        $A.enqueueAction(action);
        //to get progress bar points
        var action1=component.get("c.getProgressBarPoints"); 
        action1.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue();
                var NewBee=items[3].Points__c;
                var Bronze=items[1].Points__c;
                var Gold=items[2].Points__c;
                var Silver=items[0].Points__c;
                var CP=component.get("v.CurrentPoints");
                helper.helperMethod(component,CP,NewBee,Gold);
                //BronzeWidth=((Bronze-NewBee)/(Gold-NewBee))*100;
                BronzeWidth=(100*Bronze)/Gold;
                $('.point-1').width(BronzeWidth+'%');
                $('.points-icon-1').width(BronzeWidth+'%');
                //SilverWidth1=(((Silver-NewBee)/(Gold-NewBee))*100).toFixed(0);
                SilverWidth1=(100*Silver)/Gold;
                SilverWidth=SilverWidth1-BronzeWidth;
                $('.point-2').width(SilverWidth+'%');
                $('.points-icon-2').width(SilverWidth+'%');
                goldWidth=100-SilverWidth1;
                $('.point-3').width(goldWidth+'%');
                $('.points-icon-3').width(goldWidth+'%');
                if(CP == NewBee){
                    component.set("v.NewBee","0");
                    document.getElementById('point-1').style.color="transparent";
                }
                else{
                    component.set("v.NewBee",NewBee);
                }
                if(CP == Bronze){
                    component.set("v.Bronze","30");
                    document.getElementById('point-2').style.color="transparent";
                }
                else{
                    component.set("v.Bronze",Bronze);
                    document.getElementById('point-2').style.color="black";
                }
                if(CP == Silver){
                    component.set("v.Silver","70");
                    document.getElementById('point-3').style.color="transparent";
                }
                else{
                    component.set("v.Silver",Silver);
                    document.getElementById('point-3').style.color="blank";
                }
                if(CP == Gold){
                    component.set("v.Gold","120");
                    document.getElementById('point-4').style.color="transparent";
                }
                else{
                    component.set("v.Gold",Gold);
                    document.getElementById('point-4').style.color="black";
                }
                
                if(CP==Bronze || CP>Bronze){
                 document.getElementById("bronze_inactive").style.content="URL('/resource/EA_StaticResource/images/icon-bronze.png')";   
                }
                if(CP==Silver || CP>Silver){
                 document.getElementById("siver_inactive").style.content="URL('/resource/EA_StaticResource/images/icon-silver.png')";   
                }
                if(CP==Gold || CP>Gold){
                 document.getElementById("gold_inactive").style.content="URL('/resource/EA_StaticResource/images/icon-gold.png')";   
                }
            } 
        });
        $A.enqueueAction(action1);
    },
    
})