<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="Microsoft.Win32" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Check .NET Framework Version</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Current .NET Framework Version: <%# GetDotNetVersion() %>
        </div>
    </form>

    <script runat="server">
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            // Ensure that data binding expressions are evaluated
            this.Page.DataBind();
        }

        private string GetDotNetVersion()
        {
            try
            {
                const string subkey = @"SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\";
                using (RegistryKey ndpKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32)
                                                     .OpenSubKey(subkey))
                {
                    if (ndpKey != null && ndpKey.GetValue("Release") != null)
                    {
                        int releaseKey = (int)ndpKey.GetValue("Release");
                        return CheckFor45PlusVersion(releaseKey);
                    }
                    else
                    {
                        return ".NET Framework Version 4.5 or later is not detected.";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error retrieving .NET Framework version: {ex.Message}";
            }
        }

        private string CheckFor45PlusVersion(int releaseKey)
        {
            // Mapping based on Microsoft documentation
            if (releaseKey >= 528040)
                return "4.8 or later";
            if (releaseKey >= 461808)
                return "4.7.2";
            if (releaseKey >= 461308)
                return "4.7.1";
            if (releaseKey >= 460798)
                return "4.7";
            if (releaseKey >= 394802)
                return "4.6.2";
            if (releaseKey >= 394254)
                return "4.6.1";
            if (releaseKey >= 393295)
                return "4.6";
            if (releaseKey >= 379893)
                return "4.5.2";
            if (releaseKey >= 378675)
                return "4.5.1";
            if (releaseKey >= 378389)
                return "4.5";
            // Add more mappings if necessary
            return "Unknown .NET Framework Version";
        }
    </script>
</body>
</html>
