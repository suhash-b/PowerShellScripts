#Powershell Script
#
#--------------------------------------------------------------------------------------------------------------------------
# SCRIPT NAME       : convertCsvToJson.ps1
# DESCRIPTION       : The script creates a JSON file from a CSV or delimited file with unlimited columns.
#                     Script will take in an output parameter called file name and an output parameter called viewpoint name 
#                     along with an input parameter for the file to read along with its delimiter.
# AUTHOR            : Suhash Baidya
# CREATED           : May 6 2022
#--------------------------------------------------------------------------------------------------------------------------

clear

$input_csv = Read-Host "Please enter the Input CSV file : "
$d = Read-Host "Please enter the delimiter of the CSV file : "
$output_json = Read-Host "Please enter the Output file name (with .json extension) : "
$viewpoint_name = Read-Host "Please enter the Viewpoint name : "

$csv = Import-Csv -Path $input_csv -delimiter $d
$headers = ($csv | Get-Member -MemberType NoteProperty).Name
$jObj =@()
foreach ($row in $csv) {
    $iObj = @()
    foreach ($header in $headers) {
	$i=@([pscustomobject]@{header=$header; value = $row.$header; })
	$iObj += $i
    }
    $j = ([pscustomobject]@{viewpoint=$viewpoint_name; data = $iObj; })
    $jObj += $j
}
@{filename=$input_csv; items = $jObj;} | ConvertTo-Json -Depth 100 | Out-File -FilePath output.json

Write-Host "Input file converted to JSON. Output present in the file:" $output_json
