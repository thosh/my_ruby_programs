/*Check for Earliest EACH in SLS Invoice file*/

function CheckForEaches()
{
    var ReportDoc = new Report();
	var hugeArray = new Array();
	var invNum
	var itmPrice
	
	function IsNumeric(sText)
	{
		if (sText == "")
		{
			IsNumber = false;
			return IsNumber;
		}
		var IsNumber=true;
		if (sText.indexOf(".") == -1) 
		{
			IsNumber = false;
		}
		return IsNumber;

	}
	
	function GetPrice(pageNumber,wordNumber)
	{
		for (var x=1; x<11; x++)
		{
			if ( IsNumeric(this.getPageNthWord(pageNumber,wordNumber+x)))
			{
				itmPrice = this.getPageNthWord(pageNumber,wordNumber+x);
				return itmPrice;
			}
		}
	}
	
	for (var page = 0; page < this.numPages; page++)
	{
		var numWords = this.getPageNumWords(page);
		for (var l=40; l<numWords ; l++)
		{
			if ( this.getPageNthWord(page,l) == "Invoice" )
			{
				invNum = this.getPageNthWord(page,l+2);
				break;
			}
		}
		for (var i=0; i<numWords ; i++)
		{
			if ( (this.getPageNthWord(page,i) == "Material") && (this.getPageNthWord(page,i+1) == "Total") )
			{
				GetPrice(page,i+1);
				hugeArray.push("'"+invNum + "Material Total, " + "Material Total, " + itmPrice);
			}
			if ( (this.getPageNthWord(page,i) == "Labor") && (this.getPageNthWord(page,i+1) == "Total") )
			{
				GetPrice(page,i+1);
				hugeArray.push("'"+invNum + "Labor Total, " + "Labor Total, " + itmPrice);
			}
			if ( (this.getPageNthWord(page,i) == "Other") && (this.getPageNthWord(page,i+1) == "Total") )
			{
				GetPrice(page,i+1);
				hugeArray.push("'"+invNum + "Other Total, " + "Other Total, " + itmPrice);
			}
			if ( (this.getPageNthWord(page,i) == "ACT"))
			{
				GetPrice(page,i+1);
				hugeArray.push("'"+invNum + "ShowUp, " + "ShowUp, " + itmPrice);
			}
			if ( this.getPageNthWord(page,i) == "EA")
			{
				GetPrice(page,i+1);
				hugeArray.push("'"+invNum + this.getPageNthWord(page,i+1) + ", " + this.getPageNthWord(page,i-1)+ ", " + itmPrice);
			}
			if ( (this.getPageNthWord(page,i) == "ZDU") )
			{
				GetPrice(page,i+1);
				hugeArray.push("'"+invNum + this.getPageNthWord(page,i+1) + ", " + this.getPageNthWord(page,i-1)+ ", " + itmPrice);
			}
		}
	}
	for (var j = 0; j < hugeArray.length ; j++)
	{
		var chkPAGE = j % 75
		if( j>0 && chkPAGE  == 0)
		{
			ReportDoc.breakPage();
		}
		ReportDoc.writeText(hugeArray[j]);
	}
	ReportDoc.save("/C/Documents and Settings/tom.shannon/Desktop/Acrobat/TESTEACHES.pdf");
}
CheckForEaches()