    /**** Header and container CSS ****/        
        
        .darkGreen{color: #44883E  ;}
        .mainGreen{color: #6BA539;}
        h2{ font-size: 130%;}
        h3{font-size: 14px;}

        .Oblix_header_logo{
        position:relative;
        top:5px;
        }
        
        .Oblix_header_title{
            font-family: DIN, Arial;
            font-size: 30px;
            margin: 4px;   
           /* padding-top: 7px; */  
            position: relative;
            top: 5px;              
        }

        
           .Oblix_header_arrowTitle{
            font-family: DIN, Arial;
            font-size: 18px;
            margin: 4px;   
            padding-top: 24px;
            text-align: center;
        }
        
        
          .Oblix_header_Arrow_none{ 
          background-color: transparent;      
            background: initial;
            background-repeat: no-repeat;
            font-family: DIN, Arial;
            color:white;
            padding-left: 10px;
            width:160px;
            height: 90px;
            text-align: center;
            position: absolute;
        }
        
       
         .header_pos_1 {
            top: 2px;
            left:113px;
            }
        .header_pos_2 {
            top: 2px;
            left:270px;
            }
        .header_pos_3 {
            top: 2px;
            left:427px;
        }
        
        .Oblix_header_desc{
            text-align:center;
            /* line-height: 140%; */
            position:relative;
            font-size: 10px;
            top:-10px;

        }
        .Oblix_header td{
             font-family: DIN, Arial;
        }
        /**** Content CSS ****/
               
       .Oblix_sowDetail{
            display: block;
            padding: 9.5px;
            margin: 0 58px 23px;
            line-height: 1.42857143;
            color: #333;
            word-break: normal;
            word-wrap: break-word;
            border: 2px solid;
            border-color: rgba(107,165,57,0.5);
            background-color: rgba(240,250,240,0.9);
            border-radius: 15px;
            font-family: DIN, Arial,'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
            font-size: 120%;
            }
            
        .bg_selected{
            background-color:#44883E !important;
        }
        table tr th h1{
            font-size: 18px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .topAlign tr{
            vertical-align: top;
        }
        .Oblix_sowDashboard{
            height:300px;
        }
		.Oblix_tableDetails {
    		border-spacing: 10px 0px;
    		border-collapse: separate;
    
		}
        .Oblix_tableDetails tr h1{
            font-size:16px;
        }
        .search_init{
            transition: all .2s linear;
            background: #fff;
            padding: 5px 9px;
            margin: 0;
            border-radius: 4px;
            width: 100%;
            font-size: 13px;
            height: 32px;
        }        
        .Oblix_attachment{
            width:85% !important;
        }
        .column1,.column2 {
            /*width: 49%; */
            float: left;
        }
        .column3{
            width: 100%; 
            float: left;
        }   
        .column5{
             /*width: 45%; */
            float: right;
            vertical-align:center;
        }
		.columnMiddle{vertical-align:middle}
        .column4{
            /*width: 38%; */
            float: left;
        }
        .column4 h1{
             font-size:17px;
        }
        .Oblix_Dash{
                display:{!if(seriesProject == '' || seriesProject == '[]','none','block')};
                padding: 9.5px;
                margin: 0 58px 23px;
                font-size: 13px;
                line-height: 1.42857143;
                color: #333;
                word-break: normal;
                word-wrap: break-word;
                background-color: #f5f5f5;
                border: 1px solid #ccc;
                border-radius: 4px;
        }
         .Oblix_table{
                display:block;
                padding: 9.5px;
                margin: 0 58px 23px;
                font-size: 13px;
                line-height: 1.42857143;
                word-break: normal;
                word-wrap: break-word;
                background-color: #fff;
                border: 2px solid;
                border-color: rgba(107,165,57,0.5);
                border-radius: 15px;
        }
  
        /**** Button CSS ****/
        
        .row_g:active {
        background: #44883E;
        color: #fff;
        }
        
  
        
        .select_filter{
            word-wrap: break-word;
            word-break: normal;
            }
        input.btn, button, .Oblix_large_btn, .Oblix_btn  {
            background: #6BA539;
            background-image: none;
            color: #fff;
            padding: 4px 10px 3px 10px  !important;
            height: 30px;

        }
        input.btn:active, input.btn:hover, button:hover, .Oblix_large_btn:hover, .Oblix_btn:hover {
             background: #44883E;
             color: #fff;
        }
        
         .disabled, input.btn:disabled, input.btn:disabled, button:disabled, .Oblix_large_btn:disabled, .Oblix_btn:disabled {
             background: #6BA539;
             opacity: 0.5;
             color: #fff;

        }
        
        
        .medGreenB{
             background-color: #6BA539;
             color: #fff;
        }
 
           .medGreenB:active, .medGreenB:hover{
             background-color: #00573F;
             color: #fff;
        }
        
         .GreenB{
             background-color: #44883E;
             color: #fff;
        }
 
           .GreenB:active, .GreenB:hover{
             background-color: #00573F;
             color: #fff;
        }
        
        .tintGreenB{
             background-color: #C2DBB6;
             color: #000;
        
        }
        
        .tintGreenB:active, .tintGreenB:hover{
             background-color: #00573F;
             color: #fff;
        }
         .Oblix_large_btn{
		  border-style:none;
		  width: 200px !important;
		  height: 30px;
		  background-position: 0 0;
		  border : 1px solid rgb(158, 145, 145);
		   }       
		 .Oblix_large_btn:hover{
			border-style:none;
		  border : 1px solid rgb(223, 213, 213);
		  background-position: 0 0;
		 }
		 .Oblix_large_btn:active{
		  border-style:none;
		  border : 1px solid rgb(223, 213, 213);
		  background-position: 0 0;
		 }
		  .Oblix_btn{
			  border-style:none;
			  width: 95px !important;
			  height: 30px;
			  background-position: 0 0;
			  border : 1px solid rgb(158, 145, 145);
		 }
		 
		 .Oblix_btn:hover{
		  border-style:none;
		  border : 1px solid rgb(223, 213, 213);
		  background-position: 0 0;
		 }
		 .Oblix_btn:active{
		  border-style:none;
		  border : 1px solid rgb(223, 213, 213);
		  background-position: 0 0;
		 }
        .Oblix_notes{
            PADDING-right: 5px;
    		max-height: 15em;
    		overflow: auto;
        }
        
       .Oblix_filter_btn{
           color: #fff;
            border: 1px solid #b5b5b5 !important;
            display: inline-block;
            padding: 4px 12px !important;
            width:100px;
            margin-bottom: 0;
            font-weight: normal;
            line-height: 1.42857143;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            -ms-touch-action: manipulation;
            touch-action: manipulation;
            cursor: pointer;
            -webkit-user-select: none;
        }
       
       .Oblix_filter_btn:hover, .Oblix_filter_btn:active{
           background: #44883E !important;
           border: 1px solid #C2DBB6 !important;
       }    
       /**** ui tooltip CSS ****/
       .ui-tooltip, .arrow:after {
        background: black;
        border: 2px solid white;
      }
      .ui-tooltip {
        padding: 10px;
        color: white;
        width:150px;
        border-radius: 2px;
        border-color:black;
        font-size:12px;
        box-shadow: 0 0 2px black;
        text-align:center;
      }
      .arrow {
        width: 70px;
        height: 16px;
        overflow: hidden;
        position: absolute;
        left: 50%;
        border-color:black;
        margin-left: -35px;
        bottom: -16px;
      }
      .arrow.top {
        top: -16px;
        bottom: auto;
      }
      .arrow.left {
        left: 20%;
      }
      .arrow:after {
        content: "";
        position: absolute;
        left: 20px;
        top: -20px;
        width: 25px;
        height: 25px;
        border-color:black;
        box-shadow: 6px 5px 9px -9px black;
        -webkit-transform: rotate(45deg);
        -ms-transform: rotate(45deg);
        transform: rotate(45deg);
      }
      .arrow.top:after {
        bottom: -20px;
        top: auto;
      }
      
      .cnter {
    text-align: center;
    }
	
	           
	.bg_selected{
		background-color:#44883E !important;
	}
	 .cnter > div, .center > table /* insert any other block-level elements here */ {
        margin-left: auto;
        margin-right: auto;
    }

    /* for 900px or less */
    @media screen and (max-width: 1200px) {
     
        .column1,.column2,.column3,.column4,.column5{
            width: 100%;
        }
    }
   
    a.Oblix_btn:hover{
        text-decoration: none;
    }
    a.Oblix_btn{
        text-decoration: none;
        background: #6BA539 none repeat scroll 0% 0%;
        color: #FFF;
        padding: 4px 10px 3px !important;
        height: 30px;
        font-weight: bold;
        font-size: 0.9em;
        border-radius: 3px;
        border-width: 1px;
        border-style: solid;
        border-color: #B5B5B5 #B5B5B5 #7F7F7F;
        -moz-border-top-colors: none;
        -moz-border-right-colors: none;
        -moz-border-bottom-colors: none;
        -moz-border-left-colors: none;
        border-image: none;
        margin: 1px;
        display:block;
        width: 78px !important;
        height: 20px;
        text-align: center;
    }
    .column1,.column2,.column3,.column4,.column5{
            width: 100%;
    }
	.SOWName{
        cursor:pointer;
    }   