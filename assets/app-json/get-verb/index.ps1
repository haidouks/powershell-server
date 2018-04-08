Param($QueryStrings,$Body)
$result = @{
    output = $(Get-Verb)
    ContentType = "application/json"
}
foreach ($queryString in $QueryStrings){
    $result.output = $result.output | where-object {$_."$($queryString.Keys)" -eq $($queryString.Values)}
}
$result.output = $result.output | convertto-json
return $result
