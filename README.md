# viewstate-security-workshop

This repository is for the **Exploiting ASP.NET ViewState with YSoNet (YSOSerial.NET)** workshop.

## Security Warning

**This is an intentionally insecure lab environment for security testing and educational purposes only.**

- The server uses publicly disclosed machine keys, making it vulnerable to ViewState deserialization attacks
- **DO NOT** deploy this application on any publicly accessible network
- **ALWAYS** run this lab in an isolated environment (VM, container, or air-gapped network)
- The vulnerabilities in this lab can lead to Remote Code Execution (RCE) if exploited

This lab is designed to help security professionals improve their testing capabilities for ASP.NET ViewState vulnerabilities. Use responsibly and only in controlled environments.

## Tools

### Install-IISAndDotNet.ps1

Prepares a Windows Server for the lab by installing IIS and .NET Framework components.

**Location:** `tools/Install-IISAndDotNet.ps1`

**Usage:**
```powershell
# Run as Administrator
.\tools\Install-IISAndDotNet.ps1
```

**What it installs:**
- IIS Web Server with management tools
- Common HTTP features (default documents, directory browsing, static content)
- Application Development features (ASP.NET 3.5, ASP.NET 4.5+, ISAPI extensions/filters)
- .NET Framework 3.5 (includes 2.0 and 3.0)
- .NET Framework 4.5/4.8 features
- Security components (request filtering, basic/Windows authentication)
- WCF Services (optional)

**Note:** For .NET Framework 3.5 installation on isolated servers, you may need to mount a Windows Server ISO and uncomment the source-based installation option in the script.

### Disable-DefenderProtection.ps1

Disables Windows Defender protections to allow exploitation tools to run in the lab environment.

**Location:** `tools/Disable-DefenderProtection.ps1`

**Usage:**
```powershell
# Run as Administrator
.\tools\Disable-DefenderProtection.ps1
```

**What it disables:**
- Real-time antivirus monitoring
- AMSI/script scanning
- Web/download scanning (IOAV protection)
- Behavior monitoring
- Cloud "first seen" blocking

### Enable-DefenderProtection.ps1

Re-enables Windows Defender protections after lab use.

**Location:** `tools/Enable-DefenderProtection.ps1`

**Usage:**
```powershell
# Run as Administrator
.\tools\Enable-DefenderProtection.ps1
```

**What it enables:**
- Real-time antivirus monitoring
- AMSI/script scanning
- Web/download scanning (IOAV protection)
- Behavior monitoring
- Cloud "first seen" blocking