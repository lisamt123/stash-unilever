({
	helperMethod : function(component , a) {
        var points;
        var badge;
        var actualpointsNewbee;
        var actualpointsBronze;
        var actualpointsSilver;
        var actualpointsGold;
        var ShowActualPointKey;
        var ShowNextPointKey=true;;
        if(a>=0 && a<30){
            points=30-a;
            badge="Bronze";
            if(a==0)
            {
                actualpointsNewbee="00";
            }
            else if(a==5)
            {
                actualpointsNewbee="05";
            }
            else
            {
                actualpointsNewbee=a;
            }
            
            actualpointsBronze=30;
            actualpointsSilver=70;
            actualpointsGold=120;
            
        }
        else if(a>=30 && a<70){
            points=70-a;
            
             badge="Silver";
            actualpointsBronze=a;
            actualpointsNewbee="00";
            actualpointsSilver=70;
            actualpointsGold=120;
            
        }
        else if(a>=70 && a<120){
            points=120-a;
             
             badge="Gold";
            actualpointsSilver=a;
            actualpointsNewbee="00";
            actualpointsBronze=30;
            actualpointsGold=120;
            
        }
            else{
                if(a>=120){ShowNextPointKey=false;}
                badge="Gold";
                actualpointsGold=a;
                actualpointsNewbee ="00";
            actualpointsBronze=30;
            actualpointsSilver=70;
            
            }
        
        component.set("v.netpoints",points);
        component.set("v.badgeTo",badge);
         
        
        component.set("v.actualpointsNewbee",actualpointsNewbee);
         component.set("v.actualpointsBronze",actualpointsBronze);
         component.set("v.actualpointsSilver",actualpointsSilver);
        component.set("v.actualpointsGold",actualpointsGold);
        
        
            component.set("v.showpointsN",true);
        component.set("v.ShowNextPointKey",ShowNextPointKey);
       
        
		
	}
})