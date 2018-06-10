$VerbosePreference = "SilentyContinue"
$listener = New-Object System.Net.HttpListener
$port="8080"
$listener.Prefixes.Add("http://+:$port/") 
$listener.Start()
write-host "Listening On Port: $port"
while ($true) {
    $context = $listener.GetContext()
    $requestvars = ([String]$context.Request.Url).split("/");
    Write-Verbose -Message "Received request: $($context.Request.Url)"
    Write-Verbose -Message "Request Details:`n $($context.Request | fl * -force | Out-String -Stream)"
    $message = "Welcome to Powershell Server"
    $body = $context.Request.InputStream
    $QueryStrings = New-Object System.Collections.ArrayList
    
    try {
      foreach($queryKey in $context.Request.QueryString.Keys) {
            Write-Verbose -Message "Adding queryString $queryKey --> $($context.Request.QueryString.GetValues($queryKey))"
            $queryString = @{
                $queryKey = $($context.Request.QueryString.GetValues($queryKey))
            }
            $null=$QueryStrings.Add($queryString)
        }
      $parameters = @{
            queryStrings = $QueryStrings
            body = $body
        }
            Write-Verbose -Message "Executing $PSScriptRoot\$($application.name)\$($application.subname)\index.ps1"
            $message = $(& "$PSScriptRoot\$($requestvars[3])\$($requestvars[4].split("?")[0])\index.ps1" @parameters).output | Out-String
            $context.Response.ContentType = $result.contentType;
        }
    catch {
            $message += "<br/>Details<br/>$_.Exception";
            $context.Response.ContentType = 'text/html' ;
        }
    finally { 
            [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
            $context.Response.ContentLength64 = $buffer.length
            $context.Response.OutputStream.Write($buffer, 0, $buffer.length)
            $context.Response.OutputStream.Close()
            $context.Response.Close()
            #Free memory
        }
    }
$listener.Stop()
