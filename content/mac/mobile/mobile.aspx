<%@ Page Language="C#" Inherits="System.Web.UI.MobileControls.MobilePage" %>
<%@ Register TagPrefix="Mobile" Namespace="System.Web.UI.MobileControls" Assembly="System.Web.Mobile" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>Inline MobilePage Example</title>
</head>
<body>
  <Mobile:Form ID="Form1" runat="server">
    <Mobile:Label ID="Label1" runat="server">Hello, Mobile World!</Mobile:Label>
    <script runat="server">
      protected void Page_Load(object sender, EventArgs e)
      {
          // Update the label text each time the page loads
          Label1.Text = "Page loaded at " + DateTime.Now.ToString("T");
      }
    </script>
  </Mobile:Form>
</body>
</html>
