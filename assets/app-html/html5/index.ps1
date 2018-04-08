Param($queryStrings,$body)
$name = "Ziyaretci"
if($queryStrings.Keys -eq "name")
{
  $name = $queryStrings.Values
}
$html = @"
<!DOCTYPE html>
<html>
<head>
<title>Powershell Server</title>
</head>
<body>
<h1>Merhaba $name</h1>
<p>Paragraph</p>

</body>
</html>
"@
$result = @{
    output = $html
    ContentType = "text/html"
}

return $result