#Internet Related tasks"

$sysurl = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
# using bits transfer as it will give continuity through restarts

# This works in foreground
Import-Module BitsTransfer
Start-BitsTransfer -Source $sysurl 


#This works in background
Import-Module BitsTransfer
Start-BitsTransfer -Source $sysurl -Destination C:\Demo\sys.zip -Asynchronous 

# to check the status
Get-BitsTransfer | fl *

Invoke-WebRequest -Uri $sysurl -OutFile "C:\Demo\Sys.zip" 

#Check by using -PassThru

#to get all links from page
(Invoke-WebRequest -Uri "http://msdn.microsoft.com/en-us/library/aa973757(v=vs.85).aspx").Links.Href


# Rest API
Invoke-RestMethod -Uri https://blogs.msdn.microsoft.com/powershell/feed/ | Format-Table -Property Title, pubDate


$packageURI = "http://demo.ckan.org/api/3/action/package_list"
Invoke-RestMethod -Uri $packageURI




$testusers="https://reqres.in/api/users?page=2"
$testresult=Invoke-RestMethod -Uri $testusers 



$adduserapi="https://reqres.in/api/users"

$data='{
    "name": "dinesh",
    "job": "consultant"
}'

Invoke-RestMethod -Uri $adduserapi -Method Post -Body $data -ContentType 'application/json' 


$getuserapi = "https://reqres.in/api/users/2"

$userdata='{
    "name": "dinesh"
    }'

Invoke-RestMethod -Uri $getuserapi -Method Post -Body $userdata -ContentType 'application/json'


$request = 'http://musicbrainz.org/ws/2/artist/5b11f4ce-a62d-471e-81fc-a69a8278c7da?inc=aliases&fmt=json'



"http://services.groupkt.com/state/get/USA/all"





# Regular Expression

<# 
Placeholder Description
. Any character except newline (Equivalent: [^\n])
[^abc] All characters except the ones specified
[^a-z] All characters except those in the region specified
[abc] One of the characters
[a-z] One of the characters in the region
\a Bell (ASCII 7)
\c Any character allowed in XML names
\cA-\cZ Control+A to Control+Z, ASCII 1 to ASCII 26
\d Any number (Equivalent: [0-9])
\D Any non-number
\e Escape (ASCII 27)
\f Form Feed, (ASCII 12)
\n Line break
\r Carriage return
\s Any whitespace (space, tab, new line)
\S Any non-whitespace
\t tab
\w Letter, number or underline
\W Non-letter, number, or underline
#>



<#
Quantifier Description
* Any (no occurrence, once, many times)
? No occurrence or one occurrence
{n,} At least n occurrences
{n,m} At least n occurrences, maximum m occurrences
{n} Exactly n occurrences
+ One or many occurrences

$ End of text
^ Start of text
\b Word boundary
\B No word boundary
\G After last match (no overlaps)

#>



‘Unit1,Unit2,Unit3’ -replace ‘[,\t]’, ‘;’



$newContent = foreach ($line in (Get-Content $env:windir\WindowsUpdate.log -ReadCount 0))
{
$line -replace ‘\t’, ‘,’
}
$header = Write-Output Date Time Code1 Code2 Type Topic Response DetailedError Code3 Code4 ID Code5
Code6 Origin InstallResult Action ActionResponse Remark
$newContent | ConvertFrom-Csv -Header $header | Out-GridView





$text = ‘PC678 had a problem’
$pattern = ‘PC(\d{3})’
$text -match $pattern



(ipconfig) -match ‘IPv4’



dir "C:\Windows\System32" -Recurse | Where-Object {$_.Name -match ‘\d.*?\.dll’} 


‘Test*’ -match ‘\*’

‘Test*’.Contains(‘*’)
