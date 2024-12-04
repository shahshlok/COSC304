<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
// TODO: Get order id
String orderIdParam = request.getParameter("orderId");
if (orderIdParam == null) {
	out.println("<p style='color:red;'>Error: Order ID is missing.</p>");
	return;
}

int orderId = Integer.parseInt(orderIdParam);
boolean success = true;
StringBuilder message = new StringBuilder();

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
	con.setAutoCommit(false);
	String orderItemsQuery = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
		try (PreparedStatement orderStmt = con.prepareStatement(orderItemsQuery)) {
			orderStmt.setInt(1, orderId);
			ResultSet orderRs = orderStmt.executeQuery();
			String inventoryQuery = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
			String updateInventory = "UPDATE productinventory SET quantity = ? WHERE productId = ? AND warehouseId = 1";
			PreparedStatement inventoryStmt = con.prepareStatement(inventoryQuery);
			PreparedStatement updateStmt = con.prepareStatement(updateInventory);

			while (orderRs.next()) {
				int productId = orderRs.getInt("productId");
				int orderQuantity = orderRs.getInt("quantity");
				inventoryStmt.setInt(1, productId);
				ResultSet inventoryRs = inventoryStmt.executeQuery();

				if (inventoryRs.next()) {
					int currentInventory = inventoryRs.getInt("quantity");
					if (currentInventory >= orderQuantity) {
						int newInventory = currentInventory - orderQuantity;
						updateStmt.setInt(1, newInventory);
						updateStmt.setInt(2, productId);
						updateStmt.executeUpdate();

						message.append("Ordered product: ").append(productId)
							.append(" Qty: ").append(orderQuantity)
							.append(" Previous productinventory: ").append(currentInventory)
							.append(" New productinventory: ").append(newInventory).append("<br>");
					} else {
						success = false;
						message.append("<p style='color:red;'>Shipment not done. Insufficient productinventory for product id: ")
							.append(productId).append("</p>");
						con.rollback();
						break;
					}
				} else {
					success = false;
					message.append("<p style='color:red;'>Shipment not done. Product id: ").append(productId)
						.append(" not found in productinventory.</p>");
					con.rollback();
					break;
				}
			}
			if (success) {
				con.commit();
				message.append("<p>Shipment successfully processed.</p>");
			}
		} catch (SQLException e) {
			success = false;
			message.append("<p style='color:red;'>Error processing shipment: ").append(e.getMessage()).append("</p>");
			con.rollback();
		} finally {
			con.setAutoCommit(true);
		}

	} catch (SQLException e) {
		message.append("<p style='color:red;'>Error: ").append(e.getMessage()).append("</p>");
}

out.println("<h2>Ray's Grocery</h2>");
out.println(message.toString());
%>                       				



</body>
</html>
