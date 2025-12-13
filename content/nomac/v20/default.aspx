<%@ Page Language="C#" EnableViewStateMac="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="Microsoft.Win32" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Check .NET Framework Version</title>
    <!-- Example: Register an embedded JavaScript file -->
    <script type="text/javascript" src="<%= ClientScript.GetWebResourceUrl(GetType(), "MyNamespace.MyScript.js") %>"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Current .NET Framework Version: <%# GetDotNetVersion() %>
        </div>
    </form>

    <script runat="server">
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            Session["Anything"] = DateTime.Now;
        }
        
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
                string subkey = @"SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727";
                using (RegistryKey ndpKey = Registry.LocalMachine.OpenSubKey(subkey))
                {
                    if (ndpKey != null && ndpKey.GetValue("Version") != null)
                    {
                        return "Version " + ndpKey.GetValue("Version").ToString();
                    }
                    else
                    {
                        return ".NET Framework 2.0 is not detected.";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error retrieving .NET Framework version: " + ex.Message;
            }
        }
    </script>
</body>
</html>
