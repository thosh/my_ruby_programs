var QB_url1 ="";
QB_url1 += "www.quickbase.com/db/bfkavuvrv?act=API_GetRecordInfo&rid=";
QB_url1 += kRid;

$.get(QB_url1, { fid : 6 }, function(resp) {
    alert(resp);
});
-----
$.get("https://www.quickbase.com/db/" + gReqDBID + "?act=API_DoQuery&query={3.EX." + kRid + "}&clist=6",function(xml){
var serializer = new XMLSerializer();
var xmlstring = serializer.serializeToString(xml);
alert(xmlstring);
});
-----
$.get("https://www.quickbase.com/db/" + gReqDBID + "?act=API_DoQuery&query={3.EX." + kRid + "}&clist=6",function(xml){
var wonum = $("#s4PageName").html($("qdbapi record work_order__",xml).text());
alert(wonum);
});