Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Sub TruckPaperwork(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim WONumber As String
    Dim fileNameArray() As String
    Dim fileType As String


    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If

'creates text file to record filename and path along with WO number
Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Paperwork.txt", True)
    For Each attachedFile In MyMail.Attachments
        x = x + 1
        fileType = Right(attachedFile.FileName, Len(attachedFile.FileName) - InStr(attachedFile.FileName, "."))
        attachedFileName = Trim(outlookMail.Subject)
        attachedFileName = Replace(attachedFileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        fileNameArray() = Split(attachedFileName)
        WONumber = fileNameArray(UBound(fileNameArray))
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & " " & x & " " & attachedFileName & "." & fileType
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Conduit2.0\Attachments\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Conduit2.0\Attachments\" & attachedFileName & "," & WONumber)
    Next attachedFile
textFile.Close

    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

Dim sYourCommand As String

sYourCommand = "c:\ruby\PaperworkToQb.bat"
Shell "cmd /c " & sYourCommand, vbHide

    Sleep 5000

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub

NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError



End Sub
Sub Proposal_SVChannel(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Proposal_SVChannel.txt", True)
    theSubject = Trim(outlookMail.Subject)
    TheBody = Trim(outlookMail.Body)
    textFile.WriteLine (theSubject)
    textFile.WriteLine (TheBody)
    textFile.Close
    
    Dim sYourCommand As String
    sYourCommand = "C:\Ruby\Proposal_SVChannel.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 2000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
End Sub

Sub Cancel_SVChannel(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Cancel_SVChannel.txt", True)
    theSubject = Trim(outlookMail.Subject)
    TheBody = Trim(outlookMail.Body)
    textFile.WriteLine (TheBody)
    textFile.Close
    
    Dim sYourCommand As String
    sYourCommand = "C:\Ruby\Cancel_SVChannel.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 2000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
End Sub

Sub WOnote_SVChannel(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\WOnote_SVChannel.txt", True)
    theSubject = Trim(outlookMail.Subject)
    TheBody = Trim(outlookMail.Body)
    textFile.WriteLine (theSubject)
    textFile.WriteLine (TheBody)
    textFile.Close
    
    Dim sYourCommand As String
    sYourCommand = "C:\Ruby\WOnote_SVChannel.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 2000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
End Sub



Sub SVChannel(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\SVChannel.txt", True)
    theSubject = Trim(outlookMail.Subject)
    TheBody = Trim(outlookMail.Body)
    textFile.WriteLine (theSubject)
    textFile.WriteLine (TheBody)
    textFile.Close
    
    Dim sYourCommand As String
    sYourCommand = "C:\Ruby\SVChannel.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 2000
    
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "Accept"
    replyEmail.Send
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
End Sub
Sub FSAPPROVE(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\FSAPPROVED.txt", True)
    textFile.WriteLine (outlookMail.Body)
    textFile.Close
    
    Dim sYourCommand As String
    sYourCommand = "c:\ruby\FSAPPROVEDtoQB.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 2000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

End Sub

Sub CHANGELOG(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    mySubject = Replace(outlookMail.Subject, ":", " ")
    mySubject = Replace(mySubject, Chr(34), " ")
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\CONDUIT2CHANGELOG.txt", True)
    textFile.WriteLine (outlookMail.Body)
    textFile.Close
    
    Sleep 4000
    
    Dim sYourCommand As String
    sYourCommand = "c:\ruby\CONDUIT2CHANGELOG.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 4000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

End Sub

Sub FacilitySource(MyMail As MailItem)
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\FSEMAIL.txt", True)
    
    textFile.WriteLine (outlookMail.Subject)
    textFile.WriteLine (outlookMail.Body)
    textFile.Close
    
    Dim sYourCommand As String
    sYourCommand = "c:\ruby\FSEMAIL.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 4000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

End Sub



Sub AttachToAutoLink(MyMail As MailItem)


On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim my_record_id As String
    Dim replyEmail As Outlook.MailItem
    Dim subjArray() As String
    Dim max As Integer
    Dim subj As String
    Dim emailbody_array() As String
    
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)


    
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\AttachmentToLink.txt", True)
    
        
    file = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & Replace(Right(outlookMail.Subject, Len(outlookMail.Subject) - 7), "#", "")
    
    emailbody_array() = Split(Trim(outlookMail.Body), ",")
    
    my_record_id = emailbody_array(0)
    
    my_related_wo = emailbody_array(1)
    
    my_related_wo_type = emailbody_array(2)
    
        my_download_path = Trim("\\Regfileshare01\rms\Conduit2.0\Attachments\" & file)
        
        my_link_path = Trim("file:\\R:\rms\Conduit2.0\Attachments\" & file)
        
        my_line = Trim(my_record_id & "," & my_download_path & "," & my_link_path & "," & my_related_wo & "," & my_related_wo_type)
    
    textFile.WriteLine (my_line)

    
    textFile.Close

    Sleep 4000

    Dim sYourCommand As String
    sYourCommand = "c:\ruby\AttachmentToLink.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 4000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
    

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub
    
End Sub


Sub TowerPO(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim WONumber As String
    Dim fileNameArray() As String
    Dim replyEmail As Outlook.MailItem
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If
        
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\TowerPO.txt", True)

    For Each attachedFile In MyMail.Attachments
        attachedFileName = Replace(attachedFile.FileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        fileNameArray() = Split(attachedFileName)
        WONumber = fileNameArray(UBound(fileNameArray))
        WONumber = Left(WONumber, InStr(WONumber, ".") - 1)
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Cell Site Quotes\POs\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Cell Site Quotes\POs\" & attachedFileName & "," & WONumber)
    Next attachedFile
    
textFile.Close

    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

Dim sYourCommand As String
sYourCommand = "c:\ruby\TowerPO.bat"
Shell "cmd /c " & sYourCommand, vbHide


    Sleep 5000

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub

NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError
    


End Sub

Sub TowerInvoice(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim WONumber As String
    Dim fileNameArray() As String
    
 
    Dim forwardEmail As Outlook.MailItem
    Dim forwardEmailRecipient As Outlook.Recipient
    Const FORWARD_TO As String = "ap.rms@regencylighting.com"
    Dim replyEmail As Outlook.MailItem
    
            
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If
    
    'Forward a copy to accounting
    Set forwardEmail = outlookMail.Forward
    Set forwardEmailRecipient = forwardEmail.Recipients.Add(FORWARD_TO)
        forwardEmailRecipient.Resolve
        If forwardEmailRecipient.Resolved Then
            forwardEmail.Send
        End If
    
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\TowerInvoice.txt", True)

    For Each attachedFile In MyMail.Attachments
        attachedFileName = Replace(attachedFile.FileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        fileNameArray() = Split(attachedFileName)
        WONumber = fileNameArray(UBound(fileNameArray))
        WONumber = Left(WONumber, InStr(WONumber, ".") - 1)
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Cell Site Quotes\Invoices\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Cell Site Quotes\Invoices\" & attachedFileName & "," & WONumber)
    Next attachedFile
    
textFile.Close

    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

Dim sYourCommand As String
sYourCommand = "c:\ruby\TowerInvoice.bat"
Shell "cmd /c " & sYourCommand, vbHide


    Sleep 5000

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub

NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError
    


End Sub

Sub PaperworkHandler(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim WONumber As String
    Dim fileNameArray() As String


    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If

'creates text file to record filename and path along with WO number
Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Paperwork.txt", True)
    For Each attachedFile In MyMail.Attachments
        attachedFileName = attachedFile.FileName
        attachedFileName = Replace(attachedFile.FileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        fileNameArray() = Split(attachedFileName)
        WONumber = fileNameArray(UBound(fileNameArray))
        WONumber = Left(WONumber, InStr(WONumber, ".") - 1)
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Conduit2.0\Attachments\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Conduit2.0\Attachments\" & attachedFileName & "," & WONumber)
    Next attachedFile
textFile.Close

    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

Dim sYourCommand As String

sYourCommand = "c:\ruby\PaperworkToQb.bat"
Shell "cmd /c " & sYourCommand, vbHide

    Sleep 5000

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub

NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError



End Sub

Sub InvoiceHandler(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim WONumber As String
    Dim fileNameArray() As String
    
 
    Dim forwardEmail As Outlook.MailItem
    Dim forwardEmailRecipient As Outlook.Recipient
    Const FORWARD_TO As String = "ap.rms@regencylighting.com"
    Dim replyEmail As Outlook.MailItem
    
            
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If
    
    'Forward a copy to accounting
    Set forwardEmail = outlookMail.Forward
    Set forwardEmailRecipient = forwardEmail.Recipients.Add(FORWARD_TO)
        forwardEmailRecipient.Resolve
        If forwardEmailRecipient.Resolved Then
            forwardEmail.Send
        End If
    
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Invoice.txt", True)

    For Each attachedFile In MyMail.Attachments
        attachedFileName = attachedFile.FileName
        attachedFileName = Replace(attachedFile.FileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        fileNameArray() = Split(attachedFileName)
        WONumber = fileNameArray(UBound(fileNameArray))
        WONumber = Left(WONumber, InStr(WONumber, ".") - 1)
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Conduit2.0\Attachments\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Conduit2.0\Attachments\" & attachedFileName & "," & WONumber)
    Next attachedFile
    
textFile.Close

    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

Dim sYourCommand As String
sYourCommand = "c:\ruby\InvoiceToQbC2.bat"
Shell "cmd /c " & sYourCommand, vbHide


    Sleep 6000

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub

NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError
    


End Sub

Sub NoAttachment(outlookMail)
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
End Sub

Sub HoldOn(MyMail As MailItem)
Sleep 5000
End Sub


Sub UpdateEmailToFile(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim workOrderNumber As String
    Dim subjArray() As String
    Dim max As Integer
    Dim subj As String
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
        
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\UpdateEmail.txt", True)
    
    subj = Trim(outlookMail.Subject)
    
    For i = 0 To 31
    subj = Replace(subj, Chr(i), "")
    Next i
    
    For i = 127 To 255
    subj = Replace(subj, Chr(i), "")
    Next i
    
    subj = Replace(subj, "#", " ")
    
    subjArray() = Split(subj)
    
    max = UBound(subjArray)
    
    workOrderNumber = subjArray(max)
    
    
    For i = 0 To 31
    emailBody = Replace(outlookMail.Body, Chr(i), "")
    Next i
    
    For i = 127 To 255
    emailBody = Replace(emailBody, Chr(i), "")
    Next i
    
    For x = 1 To 5
    emailBody = Replace(emailBody, Chr(13) & Chr(10) & Chr(13) & Chr(10), Chr(13) & Chr(10))
    Next x
    
    textFile.WriteLine (workOrderNumber)
    textFile.WriteLine (emailBody)
    
    textFile.Close

    Sleep 2000

    Dim sYourCommand As String
    sYourCommand = "c:\ruby\UpdateToQB.bat"
    Shell "cmd /c " & sYourCommand, vbHide
    
    Sleep 2000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
    

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Exit Sub
    

    
End Sub
Sub KYK(MyMail As MailItem)

Dim myMailEntryID As String
Dim outlookNameSpace As Outlook.NameSpace
Dim outlookMail As Outlook.MailItem
myMailEntryID = MyMail.EntryID
Set outlookNameSpace = Application.GetNamespace("MAPI")
Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)

theSubject = Right(outlookMail.Subject, Len(outlookMail.Subject) - 5)
theSubject = Replace(theSubject, Chr(146), "_")

Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Kayak2.txt", True)
    

textFile.WriteLine (theSubject)
textFile.WriteLine (outlookMail.Body)
textFile.Close


Dim sYourCommand As String
sYourCommand = "c:\ruby\KAYAK2.bat"
Shell "cmd /c " & sYourCommand, vbHide

Sleep 4000


outlookMail.FlagIcon = olOrangeFlagIcon
outlookMail.Save
outlookMail.UnRead = False


GotAnError:
Set outlookNameSpace = Nothing
Set outlookMail = Nothing
Set attachedFile = Nothing
Exit Sub



End Sub
Sub KAYAK(MyMail As MailItem)

Dim myMailEntryID As String
Dim outlookNameSpace As Outlook.NameSpace
Dim outlookMail As Outlook.MailItem
myMailEntryID = MyMail.EntryID
Set outlookNameSpace = Application.GetNamespace("MAPI")
Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
theCC = outlookMail.Recipients(2).AddressEntry.GetExchangeUser().PrimarySmtpAddress
theSubject = Right(outlookMail.Subject, Len(outlookMail.Subject) - 6)

Set recip = outlookNameSpace.CreateRecipient(outlookMail.SenderEmailAddress)
        Set exUser = recip.AddressEntry.GetExchangeUser()
        sAddress = exUser.PrimarySmtpAddress

For i = 0 To 12
emailBody = Replace(outlookMail.Body, Chr(i), "")
Next i

For i = 14 To 31
emailBody = Replace(emailBody, Chr(i), "")
Next i

For i = 128 To 255
emailBody = Replace(emailBody, Chr(i), "")
Next i

Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
Set textFile = fileSystemObject.CreateTextFile("c:\ruby\Kayak.txt", True)
    
textFile.WriteLine (sAddress)
textFile.WriteLine (theCC)
textFile.WriteLine (theSubject)

If MyMail.Attachments.Count > 0 Then
For Each attachedFile In MyMail.Attachments
attachedFileName = Replace(attachedFile.FileName, "#", " ")
attachedFileName = Replace(attachedFileName, ",", " ")
attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
attachedFile.SaveAsFile ("\\Regfileshare01\rms\Kayak\Attachments\" & attachedFileName)
textFile.WriteLine ("file:\\R:\RMS\Kayak\Attachments\" & attachedFileName)
Next attachedFile
Else: textFile.WriteLine ("no attachment")
End If


textFile.WriteLine (emailBody)
textFile.Close


Dim sYourCommand As String
sYourCommand = "c:\ruby\KAYAK.bat"
Shell "cmd /c " & sYourCommand, vbHide

Sleep 4000


outlookMail.FlagIcon = olOrangeFlagIcon
outlookMail.Save
outlookMail.UnRead = False


GotAnError:
Set outlookNameSpace = Nothing
Set outlookMail = Nothing
Set attachedFile = Nothing
Exit Sub



End Sub
Sub ContractorChange(MyMail As MailItem)

On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim emailBody As String
    Dim emailSubject As String
    Dim myStr As String
    
    

    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    emailSubject = Right(outlookMail.Subject, Len(outlookMail.Subject) - 7)
    emailBody = Replace(outlookMail.Body, Chr(13) & Chr(10) & Chr(13) & Chr(10), "")
    myStr = emailSubject & emailBody
    
    'creates text file to record info
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\ContractorChangeEmail.txt", True)
    
    textFile.WriteLine (myStr)
'    textFile.WriteLine (emailBody)
    textFile.Close
    
    Sleep 1000

    Dim sYourCommand As String
    sYourCommand = "c:\ruby\ContractorToQB.bat"
    Shell "cmd /c " & sYourCommand, vbNormalNoFocus

    Sleep 1000
        
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
    
GotAnError:
            Set outlookNameSpace = Nothing
            Set outlookMail = Nothing
            Set attachedFile = Nothing
    Exit Sub
    
End Sub

Sub Complaint(MyMail As MailItem)


On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim replyEmail As Outlook.MailItem
    Dim emailBody As String
    rplymsg = "<html><body><p style=" & Chr(34) & "font-family: sans-serif" & Chr(34) & ">We have received and logged your complaint.  Thank you for your feedback.<br /><br />  Someone will be in touch with you shortly about this matter.<br /><br />Thanks,<br />Regency Lighting Maintenance Services</body></html>"
        
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    
    emailBody = outlookMail.Body
    
    If UCase$(outlookMail.SenderEmailType) = "EX" Then
        Set recip = outlookNameSpace.CreateRecipient(outlookMail.SenderEmailAddress)
        Set exUser = recip.AddressEntry.GetExchangeUser()
        sAddress = exUser.PrimarySmtpAddress
    Else
        sAddress = outlookMail.SenderEmailAddress
    End If
    
    
    For i = 0 To 12
    emailBody = Replace(outlookMail.Body, Chr(i), "")
    Next i
    
    For i = 14 To 31
    emailBody = Replace(emailBody, Chr(i), "")
    Next i
    
    For i = 128 To 255
    emailBody = Replace(emailBody, Chr(i), "")
    Next i
    
    For x = 1 To 5
    emailBody = Replace(emailBody, Chr(13) & Chr(10) & Chr(13) & Chr(10), Chr(13) & Chr(10))
    Next x

    If Right(emailBody, 2) = Chr(13) & Chr(10) Then
        emailBody = Left(emailBody, Len(emailBody) - 2)
    End If
    If Left(emailBody, 2) = Chr(13) & Chr(10) Then
        emailBody = Right(emailBody, Len(emailBody) - 2)
    End If



    
    'creates text file to record info
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\ComplaintEmail.txt", True)
    
    textFile.WriteLine (sAddress)
    textFile.WriteLine (outlookMail.SenderName)
    textFile.WriteLine (outlookMail.Subject)
    textFile.WriteLine (emailBody)
    textFile.Close
    
    Set replyEmail = outlookMail.Reply
    replyEmail.Subject = "Your complaint was received"
    replyEmail.HTMLBody = rplymsg
    replyEmail.Send

    Sleep 1000
    
    Dim sYourCommand As String
    sYourCommand = "c:\ruby\ComplaintToQB.bat"
    Shell "cmd /c " & sYourCommand, vbNormalNoFocus
    
    Sleep 1000
    
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
    

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub
    

    
    End Sub
Sub QuoteEmailToFile(MyMail As MailItem)


On Error GoTo GotAnError

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim replyEmail As Outlook.MailItem
    Dim emailBody As String
    Dim X1, X2, X3 As String
    X1 = "<html><body><p style=" & Chr(34) & "font-family: sans-serif" & Chr(34) & ">Thank you for your recent quote submission using the LightSpeed quote desk.  We have received and logged in your quote and will have pricing back to you within 72 hours.  If you need this expedited for a particular project, please call 800-284-2024 and speak to Michelle (x3456) or Morgan (x3423).<br /><br />"
    X2 = "It is our goal to provide you with quick and highly competitive quotes in a timely manner.  If you have any suggestions for improvement to our system or on our pricing levels, please contact Doug Flaig at doug.flaig@regencylighting.com or 800-284-2024 x3363 with your feedback.<br /><br />"
    X3 = "We appreciate your business!<br /><br />Regency Lighting<br />LightSpeed Quotes Team<br /><br /></p><p style=" & Chr(34) & "font-family: sans-serif; color:red" & Chr(34) & ">***NOTE: PLEASE DO NOT REPLY TO THIS EMAIL ADDRESS.  THIS IS AN AUTOMATED ADDRESS AND YOUR RESPONSES WILL NOT BE REVIEWED.  IF YOU NEED A RESPONSE, PLEASE CONTACT YOUR REGENCY LIGHTING SERVICE REPRESENTATIVE.  THANK YOU FOR YOUR UNDERSTANDING***</p></body></html>"
    rplymsg = X1 & X2 & X3
    
   
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    
    emailBody = outlookMail.Body
    
    If UCase$(outlookMail.SenderEmailType) = "EX" Then
        Set recip = outlookNameSpace.CreateRecipient(outlookMail.SenderEmailAddress)
        Set exUser = recip.AddressEntry.GetExchangeUser()
        sAddress = exUser.PrimarySmtpAddress
    Else
        sAddress = outlookMail.SenderEmailAddress
    End If
    
    
    For i = 0 To 12
    emailBody = Replace(outlookMail.Body, Chr(i), "")
    Next i
    
    For i = 14 To 31
    emailBody = Replace(emailBody, Chr(i), "")
    Next i
    
    For i = 128 To 255
    emailBody = Replace(emailBody, Chr(i), "")
    Next i
    
    For x = 1 To 5
    emailBody = Replace(emailBody, Chr(13) & Chr(10) & Chr(13) & Chr(10), Chr(13) & Chr(10))
    Next x

    If Right(emailBody, 2) = Chr(13) & Chr(10) Then
        emailBody = Left(emailBody, Len(emailBody) - 2)
    End If
    If Left(emailBody, 2) = Chr(13) & Chr(10) Then
        emailBody = Right(emailBody, Len(emailBody) - 2)
    End If



    
    'creates text file to record info
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\QuoteEmail.txt", True)
    
    textFile.WriteLine (sAddress)
    textFile.WriteLine (outlookMail.SenderName)
    
    If MyMail.Attachments.Count > 0 Then
        For Each attachedFile In MyMail.Attachments
            attachedFileName = Replace(attachedFile.FileName, "#", " ")
            attachedFileName = Replace(attachedFileName, ",", " ")
            attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
            attachedFile.SaveAsFile ("\\Regfileshare01\rms\LightSpeed Attachments\" & attachedFileName)
            textFile.WriteLine ("file:\\R:\RMS\LightSpeed Attachments\" & attachedFileName)
        Next attachedFile
        Else: textFile.WriteLine ("no attachment")
    End If
        
    textFile.WriteLine (emailBody)
    textFile.Close
    
    Set replyEmail = outlookMail.Reply
    replyEmail.Subject = "Quote request received"
    replyEmail.HTMLBody = rplymsg
    replyEmail.Send

    Sleep 1000
    
    Dim sYourCommand As String
    sYourCommand = "c:\ruby\QuoteToQB.bat"
    Shell "cmd /c " & sYourCommand, vbNormalNoFocus
    
    Sleep 1000
    
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False
    

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub
    

    
End Sub
Sub E3ToFile(MyMail As MailItem)

    Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim ProjectNumber As String
    Dim forwardEmail As Outlook.MailItem
    Dim forwardEmailRecipient As Outlook.Recipient
    Dim numberOfPeriods As Integer
    Const FORWARD_TO As String = "RESInvoices@regencylighting.com"
    Dim replyEmail As Outlook.MailItem
    Dim subjArray() As String
    
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    
    'Forward a copy to accounting
    Set forwardEmail = outlookMail.Forward
    Set forwardEmailRecipient = forwardEmail.Recipients.Add(FORWARD_TO)
        forwardEmailRecipient.Resolve
        If forwardEmailRecipient.Resolved Then
            forwardEmail.Send
        End If
    
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If
    
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\E3.txt", True)

    'save attachments
    'adds creation time to filename to prevent name collision
    For Each attachedFile In MyMail.Attachments
        attachedFileName = attachedFile.FileName
        attachedFileName = Replace(attachedFile.FileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        subjArray() = Split(attachedFileName)
        For i = 0 To UBound(subjArray)
            If InStr(subjArray(i), "E3-") > 0 Then
                numberOfPeriods = InStr(subjArray(i), ".")
                ProjectNumber = Left(subjArray(i), numberOfPeriods - 1)
                ProjectNumber = Right(ProjectNumber, Len(ProjectNumber) - 3)
            End If
        Next i
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Energy 3.0 Attachments\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Energy 3.0 Attachments\" & attachedFileName & ", " & ProjectNumber)
    Next attachedFile
    textFile.Close
    
    Sleep 5000

    Dim sYourCommand As String
    sYourCommand = "c:\ruby\E3toQB.bat"
    Shell "cmd /c " & sYourCommand, vbHide

    Sleep 5000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub
    
NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError

End Sub

Sub E4ToFile(MyMail As MailItem)

        Dim myMailEntryID As String
    Dim outlookNameSpace As Outlook.NameSpace
    Dim outlookMail As Outlook.MailItem
    Dim attachedFile As Attachment
    Dim attachedFileName As String
    Dim ProjectNumber As String
    Dim forwardEmail As Outlook.MailItem
    Dim forwardEmailRecipient As Outlook.Recipient
    Dim numberOfPeriods As Integer
    Const FORWARD_TO As String = "RESInvoices@regencylighting.com"
    Dim replyEmail As Outlook.MailItem
    Dim subjArray() As String
    
    
    myMailEntryID = MyMail.EntryID
    Set outlookNameSpace = Application.GetNamespace("MAPI")
    Set outlookMail = outlookNameSpace.GetItemFromID(myMailEntryID)
    
    'Forward a copy to accounting
    Set forwardEmail = outlookMail.Forward
    Set forwardEmailRecipient = forwardEmail.Recipients.Add(FORWARD_TO)
        forwardEmailRecipient.Resolve
        If forwardEmailRecipient.Resolved Then
            forwardEmail.Send
        End If
    
    If outlookMail.Attachments.Count = 0 Then
        GoTo NoAttachment
    End If
    
    'creates text file to record filename and path along with WO number
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    Set textFile = fileSystemObject.CreateTextFile("c:\ruby\E4.txt", True)

    'save attachments
    'adds creation time to filename to prevent name collision
    For Each attachedFile In MyMail.Attachments
        attachedFileName = attachedFile.FileName
        attachedFileName = Replace(attachedFile.FileName, "#", " ")
        attachedFileName = Replace(attachedFileName, ",", " ")
        subjArray() = Split(attachedFileName)
        For i = 0 To UBound(subjArray)
            If InStr(subjArray(i), "E4-") > 0 Then
                numberOfPeriods = InStr(subjArray(i), ".")
                ProjectNumber = Left(subjArray(i), numberOfPeriods - 1)
                ProjectNumber = Right(ProjectNumber, Len(ProjectNumber) - 3)
            End If
        Next i
        attachedFileName = Format(MyMail.CreationTime, "yyyymmdd_hhnnss_") & attachedFileName
        attachedFile.SaveAsFile ("\\Regfileshare01\rms\Energy 4.0 Attachments\" & attachedFileName)
        textFile.WriteLine ("file:\\R:\rms\Energy 4.0 Attachments\" & attachedFileName & ", " & ProjectNumber)
    Next attachedFile
    textFile.Close
    
    Sleep 5000

    Dim sYourCommand As String
    sYourCommand = "c:\ruby\E4toQB.bat"
    Shell "cmd /c " & sYourCommand, vbHide

    Sleep 5000
    
    outlookMail.FlagIcon = olOrangeFlagIcon
    outlookMail.Save
    outlookMail.UnRead = False

GotAnError:
    Set outlookNameSpace = Nothing
    Set outlookMail = Nothing
    Set attachedFile = Nothing
    Exit Sub
    
NoAttachment:
    Set replyEmail = outlookMail.Reply
    replyEmail.Body = "No Attachment, please re-send."
    replyEmail.Send
    GoTo GotAnError

End Sub


