/*Get Individual Invoices and Email*/

function ExtractAndEmail()
{
	var poArray = new Array();
	var pgArray = new Array();
	for (var page = 0; page < this.numPages; page++)
		{
			var numWords = this.getPageNumWords(page);
			for (var i=40; i<numWords ; i++)
			{
				if ( this.getPageNthWord(page,i) == "PO" )
                        	{
				poArray.push(this.getPageNthWord(page,i+2));
				pgArray.push(page);
				break;
				}
			}
		}
	for (var j = 0; j < poArray.length; j++)
	{
		//extract pages pgArray[j] to pgArray[j+1]-1
		var beginPage = pgArray[j];
		if (pgArray[j+1] != undefined )
		{
			var endPage = pgArray[j+1] - 1;
		}
		else
		{
			var endPage = this.numPages - 1;
		}
		var oNewDoc = this.extractPages({nStart:beginPage,nEnd:endPage});
		//email doc with filename "invoice " + poArray[j] + ".pdf"
		var cFlName = "Invoice for WO " +  poArray[j] + ".pdf";
		var cPath = oNewDoc.path.replace(oNewDoc.documentFileName,cFlName);
		oNewDoc.saveAs(cPath);
		oNewDoc.mailDoc({
			bUI: false,
			cTo: "reg.rms@regencylighting.com",
			cSubject: cFlName
		});
		oNewDoc.closeDoc(false);
	}
}
ExtractAndEmail()