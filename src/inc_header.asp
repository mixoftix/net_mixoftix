<%@LANGUAGE="VBSCRIPT"%>
<%
Response.Buffer=true

response.expires = 0
response.expiresabsolute = Now() - 1
response.addHeader "pragma","no-cache"
response.addHeader "cache-control","private"
Response.CacheControl = "no-cache"
%>

