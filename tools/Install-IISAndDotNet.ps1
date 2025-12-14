# ------------------------------------------------------------
# Install IIS + Application Development Features
# Matching your lab configuration
# ------------------------------------------------------------
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Install-WindowsFeature -Name Web-WebServer
Install-WindowsFeature -Name Web-Common-Http
Install-WindowsFeature -Name Web-Default-Doc
Install-WindowsFeature -Name Web-Dir-Browsing
Install-WindowsFeature -Name Web-Http-Errors
Install-WindowsFeature -Name Web-Static-Content

# Application Development Features
Install-WindowsFeature -Name Web-App-Dev
Install-WindowsFeature -Name Web-Net-Ext            # .NET Extensibility 3.5
Install-WindowsFeature -Name Web-Net-Ext45         # .NET Extensibility 4.5+
Install-WindowsFeature -Name Web-Asp-Net           # ASP.NET 3.5
Install-WindowsFeature -Name Web-Asp-Net45         # ASP.NET 4.5–4.8
Install-WindowsFeature -Name Web-ISAPI-Ext
Install-WindowsFeature -Name Web-ISAPI-Filter

# Security Components (recommended)
Install-WindowsFeature -Name Web-Filtering
Install-WindowsFeature -Name Web-Basic-Auth
Install-WindowsFeature -Name Web-Windows-Auth

# ------------------------------------------------------------
# Install .NET Framework 3.5 (includes .NET 2.0 + 3.0)
#
# OPTION 1 (Recommended): Install using ISO source files
# Requires mounting a Windows Server ISO to D:
# ------------------------------------------------------------
# Install-WindowsFeature Net-Framework-Core -Source "D:\sources\sxs"

# ------------------------------------------------------------
# OPTION 2 (Internet Required):
# Attempts to download .NET 3.5 payloads from Windows Update.
# This only works if the server has full internet connectivity.
# ------------------------------------------------------------
Install-WindowsFeature Net-Framework-Core

# ------------------------------------------------------------
# Install .NET Framework 4.8 Features
# ------------------------------------------------------------
Install-WindowsFeature Net-Framework-45-Core
Install-WindowsFeature Net-Framework-45-ASPNET
Install-WindowsFeature Web-Asp-Net45

# Optional: WCF Services
# Install-WindowsFeature Net-WCF-Services45
