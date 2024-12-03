const { orderService } = require("../services");

const getAllOrder = async (req, res) => {
  try {
    const orders = await orderService.getAll();
    return res.status(200).json(orders);
  } catch (error) {
    console.error(error);
    return res.status(500);
  }
};

const getOrderDetail = async (req, res) => {
  const orderID = req.params.orderId;
  try {
    const order = await orderService.getDetailOrder(orderID);
    return res.status(200).json(order);
  } catch (error) {
    throw error;
  }
};

const getOrdersAboveThreshold = async (req, res) => {
  const { threshold } = req.query;

  if (!threshold || isNaN(threshold)) {
    return res.status(400).json({ error: "Invalid threshold value." });
  }

  try {
    const orders = await orderService.getOrdersAboveThreshold(
        parseInt(threshold)
    );
    if (orders.length === 0) {
      return res
        .status(200)
        .json({ message: "No orders found above the threshold." });
    }
    res.status(200).json({ orders });
  } catch (error) {
    console.error("Error fetching orders above threshold:", error.message);
    res.status(400).json({ error: error.message }); // Send MySQL error message to the client
  }
};

module.exports = {
  getAllOrder,
  getOrderDetail,
  getOrdersAboveThreshold,
};