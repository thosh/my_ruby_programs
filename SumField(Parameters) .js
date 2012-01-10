function SumField(Parameters) {

 var url = "";
 url += "https://www.quickbase.com/db/" + Parameters.dbid;
 url += "?act=API_DoQuery";
 url += "&query=" + Parameters.query;
 url += "&clist=" + Parameters.fid;

 var sum=0;
 $.get(url,function(xml) {
  $("record",xml).each(function() {
   sum += parseInt($(":first-child",this).text());
  });
 });
 return sum;
}

//Example Parameters
{
 "dbid" : "8emtadvk",
 "query" : "{6.CT.report}",
 "fid": 82
}