html {
    overflow-x: hidden;
    width: 100%;
}
@import url(https://fonts.googleapis.com/css?family=Roboto+Condensed:400,700);
/* written by riliwan balogun http://www.facebook.com/riliwan.rabo*/
a {
   outline: 0;
}
.board{
    width:100%;
    padding-left: 15px;
    padding-right: 15px;
    padding-bottom:20px;
    margin: 20px auto;
    
/*box-shadow: 10px 10px #ccc,-10px 20px #ddd;*/
}
.board .nav-tabs {
    position: relative;
    /* border-bottom: 0; */
    /* width: 80%; */
    margin: 20px auto;
    margin-bottom: 0;
    box-sizing: border-box;

}

.board > div.board-inner{
   <!-- background: #fafafa url(http://subtlepatterns.com/patterns/geometry2.png);-->
    background-size: 30%;
    position: relative;
}



.nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {
    color: #555555;
    cursor: default;
    /* background-color: #ffffff; */
    border: 0;
    border-bottom-color: transparent;
    outline: 0;
    background: transparent;
}
span.round-tabs{
    width: 90px;
    height: 90px;
    line-height: 90px;
    display: inline-block;
    border-radius:100px;
    background: white;
    z-index: 2;
    position: absolute;
    left: 0;
    text-align: center;
    font-size: 25px;
}

round-tabs p{
  margin-top:10px;
  
}



li.active span{
  background: #fff !important;
    border: 4px solid green;
    color: rgb(34, 194, 34);
}
li.completed span{
    background: #fff !important;
    border: 4px solid blue;
    color: rgb(34, 194, 34);
}
li.disabled span{
     background: #fff !important;
    border: 4px solid yellow;
    color: rgb(34, 194, 34);
}


.nav-tabs > li.active > a span.round-tabs{
    background: #fafafa;
    outline: 0;
}
.nav-tabs > li {
    width: 25%;
}

li:after {
    content: " ";
    position: absolute;
    left: 45%;
   opacity:0;
    margin: 0 auto;
    bottom: 0px;
    border: 5px solid transparent;
    border-bottom-color: green;
    transition:0.1s ease-in-out;
    
}
li.active:after {
    content: " ";
    position: absolute;
    left: 45%;
   opacity:1;
    margin: 0 auto;
    bottom: 0px;
    border: 10px solid transparent;
    border-bottom-color: green;
    outline: 0;
    
}
.nav-tabs > li a{
   width: 90px;
   height: 90px;
   margin: 10px auto;
   border-radius: 100%;
   padding: 0;
   outline: 0;
}

.nav-tabs > li a:hover{
    background: transparent;
    outline: 0;
}

.tab-content{
}
.tab-pane{
   position: relative;
padding-top: 50px;
}
.tab-content .head{
    font-family: 'Roboto Condensed', sans-serif;
    font-size: 25px;
    text-transform: uppercase;
    padding-bottom: 10px;
}
.btn-outline-rounded{
    padding: 10px 40px;
    margin: 20px 0;
    border: 2px solid transparent;
    border-radius: 25px;
}

.btn.green{
    background-color:#5cb85c;
    /*border: 2px solid #5cb85c;*/
    color: #ffffff;
}


@media( max-width : 585px ){
    
    .board {
width: 90%;
height:auto !important;
}
    span.round-tabs {
        font-size:16px;
width: 50px;
height: 50px;
line-height: 50px;
    }
    .tab-content .head{
        font-size:20px;
        }
    .nav-tabs > li a {
width: 50px;
height: 50px;
line-height:50px;
}

li.active:after {
content: " ";
position: absolute;
left: 35%;
}

.btn-outline-rounded {
    padding:12px 20px;
    }
}

.connecting-line {
    height: 6px;
    background: goldenrod;
    position: absolute;
    width: 70%;
    margin: 0 auto;
    left: 0;
    right: 0;
    top: 33%;
    z-index: 1;
}