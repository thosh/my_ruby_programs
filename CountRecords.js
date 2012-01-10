function CountRecords(Parameters) {

 var url = "";
 url += "https://www.quickbase.com/db/" + Parameters.dbid;
 url += "?act=API_DoQuery";
 url += "&query=" + Parameters.query;

 var nrecords;
 $.get(url,function(xml) {
  nrecords=$("record",xml).length;
 });
 return nrecords;
}

$.ajaxSetup({async: false});

$.getScript("https://www.quickbase.com/db/be9mdbwz7?a=dbpage&pagename=json_parse.js");

var url="";
url += "https://www.quickbase.com/db/be9mdbw34";
url += "?act=API_DoQuery";
url += "&qid=1";
url += "&clist=a";

var csv="";
$.get(url,function(xml) {
 $("record",xml).each(function() {
  var rid=$("record_id_",this).text();
  var FunctionName=$("function",this).text();
  var Parameters=json_parse($("parameters",this).text());
  csv += rid + "," + window[FunctionName](Parameters) + "\n";
 });
});

var urlcsv="";
urlcsv += "https://www.quickbase.com/db/be9mdbw34";
urlcsv += "?act=API_ImportFromCSV";

var request ="";
request += "<qdbapi>";
request += "<clist>3.7</clist>";
request += "<skipfirst>0</skipfirst>";
request += "<records_csv><![CDATA[";
request += csv;
request += "]]></records_csv>";
request += "</qdbapi>";

$.ajax({
 type: "POST",
 contentType: 'text/xml',
 async: false,
 url: urlcsv,
 dataType: "xml",
 processData: false,
 data: request,
 success: function(response) {
  document.location.href="https://www.quickbase.com/db/be9mdbwz7";
 }
});