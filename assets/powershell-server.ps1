$VerbosePreference = "SilentyContinue"
$listener = New-Object System.Net.HttpListener
$port="8080"
$listener.Prefixes.Add("http://+:$port/") 
$listener.Start()
write-host "Listening On Port: $port"
$req = $null
 
while ($true) {
    $context = $listener.GetContext() 
    $request = $context.Request
    $response = $context.Response   
    $requestvars = ([String]$request.Url).split("/");
    Write-Verbose -Message "Received request: $($request.Url)"
    Write-Verbose -Message "Request Details:`n $($request | fl * -force | Out-String -Stream)"
    $message = "Welcome to Powershell Server"
    $body = $request.InputStream
    $QueryStrings = New-Object System.Collections.ArrayList
    foreach($queryKey in $request.QueryString.Keys) {
            Write-Verbose -Message "Adding queryString $queryKey --> $($request.QueryString.GetValues($queryKey))"
            $queryString = @{
                $queryKey = $($request.QueryString.GetValues($queryKey))
            }
            $null=$QueryStrings.Add($queryString)
        }
    $parameters = @{
            queryStrings = $QueryStrings
            body = $body
        }
    try {
            Write-Verbose -Message "Executing $PSScriptRoot\$($application.name)\$($application.subname)\index.ps1"
            $result = & "$PSScriptRoot\$($requestvars[3])\$($requestvars[4].split("?")[0])\index.ps1" @parameters 
            $message = $result.output | Out-String
            $response.ContentType = $result.contentType;
        }
    catch {
            $message += "<br/>Details<br/>$_.Exception";
            $response.ContentType = 'text/html' ;
        }
    finally { 
            [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
            $response.ContentLength64 = $buffer.length
            $output = $response.OutputStream
            $output.Write($buffer, 0, $buffer.length)
            $output.Close()
            $response.Close()
            #Free memory
        }
    }
$listener.Stop()
