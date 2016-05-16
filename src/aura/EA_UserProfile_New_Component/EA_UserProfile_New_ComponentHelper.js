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
	},
    helperforProgressbar : function(component, a) {
    if(a>=0 && a<10)
      {   component.set("v.newbee0",true);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.NewBee_badge",true); 
          component.set("v.newbee_img_pos",true);
          component.set("v.bronze_img_pos",false);
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);}
      else if(a>=10 && a<20)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",true);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.NewBee_badge",true); 
          component.set("v.newbee_img_pos",true);
          component.set("v.bronze_img_pos",false);
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false); }  
      else if(a>=20 && a<30)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",true);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.NewBee_badge",true); 
          component.set("v.bronze_img_pos",false);
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",true); }   
      else if(a>=30 && a<40)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",true);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);}   
       else if(a>=40 && a<50)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",true);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);}   
      else if(a>=50 && a<60)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",true);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);} 
         else if(a>=60 && a<70)
      {  component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",true);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);}     
           else if(a>=70 && a<80)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",true);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);}      
        else if(a>=80 && a<90)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",true);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
        else if(a>=90 && a<100)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",true);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
        else if(a>=100 && a<110)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",true);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);}            
       else if(a>=110 && a<120)
      {  component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",true);
          component.set("v.gold",false);
          component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
      else if(a>=120)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",true);
           component.set("v.Gold_badge",true); 
          component.set("v.gold_img_pos",true);
          component.set("v.silver_img_pos",false);
          component.set("v.Bronze_badge",false); 
          component.set("v.newbee_img_pos",false);}    
               
               }
    }
    
})