Formula Definition:

"<img qbu=\"module\" src=\"/i/clear2x2.gif\" " &
" QBU=='undefined'){QBU={};$.getScript('" &
URLRoot() &
"db/" &
Dbid() &
"?a=dbpage&pagename=module.js&rand='+Math.random())}\">"

==================================================
File: module.js

(function(){

 var querystring=document.location.search;

 if (/dlta=mog/.test(querystring)) {
  //GRID EDIT PAGE ========================================
  alert("You are on the Grid Edit Page");

 } else if(/a=er/.test(querystring)) {
  //EDIT RECORD PAGE ========================================
  alert("You are on the Edit Record Page");

 } else if (/GenNewRecord/.test(querystring)) {
  //ADD RECORD PAGE ========================================
  //alert("You are on the Add Record Page");

  $("#s4PageName").html("My Title Not QuickBase's Title");
  $("#czThisBut").html("This Space for Rent");
  //$("td#czThisBut").css("background-image", "url(http://www.shamenterprises.com/images/rent-icon.jpg)");


  //$("#dbFormContainer").html("<h1>Foo Bar</h1>");

  $("input[]").val("  Do It  ");
  $("input[]").val("  Do It Again  ");
  $("input[]").val("  Don\'t Do It At All ");

  $("input[]").attr("onClick","alert('Do It')");
  $("input[]").attr("onClick","alert('Do It Again')");
  $("input[]").attr("onClick",'alert("Don\'t Do It")');

  $("#dbFormContainer").load("https://www.quickbase.com/db/bfu356kye?a=dbpage&pagename=myform.html");

 } else if(/a=dr/.test(querystring)) {
  //DISPLAY RECORD PAGE
  alert("You are on the Display Record Page");

 } else if(/a=q/.test(querystring)) {
  //REPORT PAGE ========================================
  alert("You are on the Report Listing Page");

 } else {
  //OTHER PAGE ========================================
  alert("You are on the Some Other Page");
 }

})();

==================================================
File: myform.html
http://assets0.pastie.org/images/paste_button.png?1289430470
<h1>Put Any HTML You Want Here</h2>