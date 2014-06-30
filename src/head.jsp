<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.ResultSetMetaData"%>
<%@ page import="java.sql.SQLException"%>
	
<%!
	static String driverClass = "com.mysql.jdbc.Driver";
	static String host     = "";
	static String sqlport  = "";
	static String user     = "";
	static String url      = "";
	static String password = "";
	static String database = "";

// opens the .my.cnf file in the home directory of this tomcat user
// and retrieves ALL the name-value pair properties listed under "[client]"
// and returns them in a hashtable

static Hashtable<String,String> getClientProperties() throws IOException {

	Hashtable<String,String> clientProps = new Hashtable<String,String>();

	String mycnfPath = System.getProperty("user.home")+"/.my.cnf";

	BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(mycnfPath)));

	String clientProperties = "";

	boolean inClientSpecs=false;

	String line = br.readLine();

	while (line != null) {
		line = line.trim();

		if(line.equals("[client]")) 
			inClientSpecs=true;

		else 
			if (inClientSpecs) {	
				if (line.startsWith("[")) 
					inClientSpecs=false;
				else 
					if (!line.equals("")) 
						clientProperties += line+"\n";
			}
		line = br.readLine();
	}

	br.close();

	String[] clientPropertiesList = clientProperties.split("\n");
	for(String s:clientPropertiesList) {
		if (s.contains("=")) {
			String[] nvpairs=s.split("=");
			clientProps.put(nvpairs[0],nvpairs[1]);
		}
	}
	return clientProps;
}

// if necessary, sets up the key static String property variables for
// use in mysql access


static void setupClientProperties() throws IOException {
	if (url != null && url.length() > 0) return;

	Hashtable<String,String> clientProperties = getClientProperties();

	user     = clientProperties.get("user");
	password = clientProperties.get("password");
	database = clientProperties.get("database");
	sqlport  = clientProperties.get("port");
	host     = clientProperties.get("host");
	
	if (host == null || host.equals("")) 
		host = "localhost";

	if (sqlport == null || sqlport.equals("")) sqlport = "3306";
		url = "jdbc:mysql://"+host+":"+sqlport+"/"+user;
}
	
%>

<%
	// Sets up fields with SQL data & creates driver/connection for SQL access
		setupClientProperties();
		com.mysql.jdbc.Driver d = new com.mysql.jdbc.Driver();
		Connection con = DriverManager.getConnection(url, user, password);
%>

<%
	// Global login variable and password to check in login form
		String login = (String) session.getAttribute("login");
		String password = (String) session.getAttribute("password");
	
	// Variables for subscriber login
		String subName = (String) session.getAttribute("subName");
		String subAddr = (String) session.getAttribute("subAddr");
		String subCity = (String) session.getAttribute("subCity");
		String subState = (String) session.getAttribute("subState");
		String subZip = (String) session.getAttribute("subZip");
		String subMail = (String) session.getAttribute("subMail");
		String subLogin = (String) session.getAttribute("subLogin");
		String subPass = (String) session.getAttribute("subPass");
	
	// Variables for company login
		String comName = (String) request.getAttribute("comName");
		String comAddr = (String) request.getAttribute("comAddr");
		String comCity = (String) request.getAttribute("comCity");
		String comState = (String) request.getAttribute("comState");
		String comZip = (String) request.getAttribute("comZip");
		String comLogin = (String) request.getAttribute("comLogin");
		String comPass = (String) request.getAttribute("comPass");
	
	// Boolean to indicate if logged in as company or subscriber
		String loginType = (String) request.getAttribute("loginType");
		String planName = (String) request.getAttribute("planName");
		String paid = (String) request.getAttribute("planName");
		String _months = (String) request.getAttribute("planName");
	
%>