<%@ Page Language="C#" AutoEventWireup="true" %>
<form id="form1" runat="server">
	<div>
		test
	</div>
</form>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("./test/default.aspx");
    }
</script>