<%@ Application Language="C#" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="System.Web" %>

<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
        // Register routes on app start
        RegisterRoutes(RouteTable.Routes);
    }

    public static void RegisterRoutes(RouteCollection routes)
    {
        routes.MapPageRoute(
            "VersionRoute",
            "myversion/{id}",
            "~/pages/welcome.aspx"
        );
    }
</script>
