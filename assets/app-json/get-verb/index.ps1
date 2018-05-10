Param($QueryStrings,$Body)
$result = @{
    output = $(Get-Verb) # Set the output of your script to "$result.output". "$result.output" parameter will be used as response body. In this example we will just use "Get-Verb" cmdlet as our script
    ContentType = "application/json" # Set content type for response.
}
foreach ($queryString in $QueryStrings) { # Response body will be filtered regarding querystrings. 
    $result.output = $result.output | where-object {$_."$($queryString.Keys)" -eq $($queryString.Values)}
}
$result.output = $result.output | convertto-json # Because of the "application/json" selection as content type, json conversion is needed for response body.
return $result
