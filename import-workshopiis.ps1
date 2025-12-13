<# 
    import-workshopiis.ps1

    Interactive IIS import script for the "workshop" lab site.

    Usage (from repo root after clone, in elevated PowerShell):

        .\import-workshopiis.ps1
#>

# ---------- Helper: Read-Host with default ----------
function Read-WithDefault {
    param(
        [string]$Prompt,
        [string]$Default
    )

    if ([string]::IsNullOrWhiteSpace($Default)) {
        return Read-Host $Prompt
    }
    else {
        $input = Read-Host "$Prompt [$Default]"
        if ([string]::IsNullOrWhiteSpace($input)) { return $Default }
        return $input
    }
}

# ---------- Figure out paths relative to script ----------
$scriptRoot      = Split-Path -Parent $MyInvocation.MyCommand.Path
$defaultConfig   = Join-Path $scriptRoot "workshop-iis-config.json"
$defaultContent  = Join-Path $scriptRoot "content"

# ---------- Ask user for inputs ----------
$configPath = Read-WithDefault "Path to config JSON" $defaultConfig

while (-not (Test-Path $configPath)) {
    Write-Host "Config file not found at '$configPath'." -ForegroundColor Yellow
    $configPath = Read-WithDefault "Please enter a valid config path" $defaultConfig
}

$defaultSiteName = "workshop"
$siteName = Read-WithDefault "IIS site name" $defaultSiteName

$defaultRootPath = "C:\workshop\websites\wwwdata"
$rootPath = Read-WithDefault "Physical root path for site content" $defaultRootPath

$defaultPort = 80
$httpPortString = Read-WithDefault "HTTP port" ([string]$defaultPort)
[int]$httpPort = $defaultPort
if (-not [int]::TryParse($httpPortString, [ref]$httpPort)) {
    Write-Host "Invalid port '$httpPortString', falling back to $defaultPort." -ForegroundColor Yellow
    $httpPort = $defaultPort
}

Write-Host ""
Write-Host "== Import settings ==" -ForegroundColor Cyan
Write-Host "Config JSON : $configPath"
Write-Host "Site name   : $siteName"
Write-Host "Root path   : $rootPath"
Write-Host "HTTP port   : $httpPort"
Write-Host "Content src : $defaultContent"
Write-Host ""

# ---------- Ensure IIS scripting tools ----------
if (-not (Get-Module -ListAvailable WebAdministration)) {
    try {
        Import-Module ServerManager -ErrorAction Stop
        Install-WindowsFeature Web-Server, Web-Scripting-Tools -IncludeManagementTools -ErrorAction Stop
    }
    catch {
        throw "WebAdministration module not available and automatic installation failed. Ensure IIS + management tools are installed, then rerun."
    }
}

Import-Module WebAdministration

# ---------- Load config ----------
$json   = Get-Content $configPath -Raw
$config = $json | ConvertFrom-Json

$oldRoot = $config.Site.PhysicalPath

# ---------- Ensure root directory exists ----------
if (-not (Test-Path $rootPath)) {
    Write-Host "Creating root directory '$rootPath'..."
    New-Item -Path $rootPath -ItemType Directory -Force | Out-Null
}

# ---------- Copy content (if present in repo) ----------
if (Test-Path $defaultContent) {
    Write-Host "Copying content from '$defaultContent' to '$rootPath'..."
    # robocopy to mirror content
    robocopy $defaultContent $rootPath /MIR /R:2 /W:5 /COPY:DAT /SL /NFL /NDL /NP | Out-Null
}
else {
    Write-Host "WARNING: content folder '$defaultContent' not found. Only IIS config will be applied." -ForegroundColor Yellow
}

# ---------- Ensure app pools exist ----------
$appPoolNames = @()
$appPoolNames += $config.Site.ApplicationPool
$appPoolNames += ($config.Children | Where-Object { $_.ApplicationPool } | Select-Object -ExpandProperty ApplicationPool)
$appPoolNames = $appPoolNames | Sort-Object -Unique

foreach ($pool in $appPoolNames) {
    if (-not (Get-Item "IIS:\AppPools\$pool" -ErrorAction SilentlyContinue)) {
        Write-Host "Creating app pool '$pool'..."
        New-WebAppPool -Name $pool | Out-Null

        # Optional: if the pool is literally named ".NET v2.0", try to set its runtime
        if ($pool -eq ".NET v2.0") {
            Set-ItemProperty "IIS:\AppPools\$pool" -Name managedRuntimeVersion -Value "v2.0"
        }
    }
    else {
        Write-Host "App pool '$pool' already exists."
    }
}

# ---------- Create or update the site ----------
$existingSite = Get-Website -Name $siteName -ErrorAction SilentlyContinue

if (-not $existingSite) {
    Write-Host "Creating site '$siteName' at '$rootPath'..."
    New-Website -Name $siteName `
                -PhysicalPath $rootPath `
                -ApplicationPool $config.Site.ApplicationPool `
                -Port $httpPort `
                -IPAddress "*" `
                -HostHeader "" | Out-Null
}
else {
    Write-Host "Site '$siteName' already exists, updating physical path to '$rootPath'..."
    Set-ItemProperty "IIS:\Sites\$siteName" -Name physicalPath -Value $rootPath
}

# Rebuild bindings: use config for IP/hostname, but override HTTP port with chosen one
Write-Host "Configuring bindings for site '$siteName'..."
Get-WebBinding -Name $siteName | ForEach-Object {
    Remove-WebBinding -Name $siteName -BindingInformation $_.bindingInformation -Protocol $_.protocol
}

foreach ($b in $config.Site.Bindings) {
    $port = if ($b.Protocol -eq "http") { $httpPort } else { [int]$b.Port }
    New-WebBinding -Name $siteName `
                   -Protocol $b.Protocol `
                   -Port $port `
                   -IPAddress $b.IP `
                   -HostHeader $b.Hostname | Out-Null
}

# ---------- Recreate child applications ----------
foreach ($child in $config.Children) {
    if ($child.Type -ne "application") { continue }

    $relPath    = $child.Path.TrimStart('/')   # e.g. "mac/extless"
    $newPhysical = $child.PhysicalPath.Replace($oldRoot, $rootPath)

    $appPath = "IIS:\Sites\$siteName\$relPath"

    if (-not (Test-Path $appPath)) {
        Write-Host "Creating application '$relPath' with '$newPhysical' (pool '$($child.ApplicationPool)')..."
        New-WebApplication -Site $siteName `
                           -Name $relPath `
                           -PhysicalPath $newPhysical `
                           -ApplicationPool $child.ApplicationPool | Out-Null
    }
    else {
        Write-Host "Application '$relPath' exists, updating physicalPath to '$newPhysical'..."
        Set-ItemProperty $appPath -Name physicalPath -Value $newPhysical
    }
}

Write-Host ""
Write-Host "Import finished. Site '$siteName' should now be available on HTTP port $httpPort." -ForegroundColor Green
