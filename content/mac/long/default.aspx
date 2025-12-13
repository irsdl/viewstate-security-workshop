<%@ Page Language="C#" AutoEventWireup="true" maxPageStateFieldLength="20"%>
<form id="form1" runat="server">
	<div>
		test
	</div>
</form>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("/error",false); // long redirect
		//Response.Redirect("/default.aspx",true);
		//Response.Redirect("/a1/b/c1/d1/e1/redirect.aspx/a",false);
		
		//Server.Transfer("/default.aspx");
    }
</script>