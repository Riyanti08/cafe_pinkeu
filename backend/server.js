const express = require("express");
const cors = require("cors");
const midtransClient = require("midtrans-client");

const app = express();
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST"],
    allowedHeaders: ["Content-Type"],
  })
);
app.use(express.json());

let snap = new midtransClient.Snap({
  isProduction: false,
  serverKey: "SB-Mid-server-FbFbrto4QfBFdQbZedp_RM57",
  clientKey: "SB-Mid-client-eEPM4onFLOfobjOV",
  merchantId: "G206616065",
});

let core = new midtransClient.CoreApi({
  isProduction: false,
  serverKey: "SB-Mid-server-xxbgQY3Vhh8ewNI2IOHiaZad",
  clientKey: "SB-Mid-client-L_J-CtXY1CPdAyfa",
});

app.post("/create-payment", async (req, res) => {
  try {
    const { orderId, amount, userId, email, name, items } = req.body;
    console.log("Creating payment:", { orderId, amount, items });

    const itemsTotal = items.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0
    );

    if (itemsTotal !== amount) {
      console.error(
        `Amount mismatch: expected ${amount}, got sum ${itemsTotal}`
      );
      console.error("Items:", JSON.stringify(items, null, 2));
      return res.status(400).json({
        error: "Amount mismatch",
        expected: amount,
        calculated: itemsTotal,
        items: items,
      });
    }

    let parameter = {
      transaction_details: {
        order_id: orderId,
        gross_amount: amount,
      },
      customer_details: {
        email: email,
        first_name: name,
        custom_field1: userId,
      },
      item_details: items.map((item) => ({
        id: item.id,
        price: item.price,
        quantity: item.quantity,
        name: item.name,
      })),
      expiry: {
        duration: 5,
        unit: "minutes",
      },
      callbacks: {
        finish: "cafepinkeu://payment-complete",
        error: "cafepinkeu://payment-error",
        pending: "cafepinkeu://payment-pending",
      },
    };

    const transaction = await snap.createTransaction(parameter);
    console.log("Payment URL created:", transaction.redirect_url);

    res.json({
      token: transaction.token,
      redirectUrl: transaction.redirect_url,
      orderId: orderId,
    });
  } catch (error) {
    console.error("Payment creation error:", error);
    res.status(500).json({ error: error.message });
  }
});

app.get("/status/:orderId", async (req, res) => {
  try {
    console.log(`Checking status for order: ${req.params.orderId}`);

    try {
      const statusResponse = await core.transaction.status(req.params.orderId);
      console.log("Core API Status Response:", statusResponse);
      return res.json(statusResponse);
    } catch (coreError) {
      console.log("Core API Error:", coreError);

      try {
        const snapStatus = await snap.transaction.status(req.params.orderId);
        console.log("Snap API Status Response:", snapStatus);
        return res.json(snapStatus);
      } catch (snapError) {
        console.log("Snap API Error:", snapError);
        throw snapError;
      }
    }
  } catch (error) {
    console.error("Final error:", error);
    res.status(404).json({
      status: "error",
      transaction_status: "not_found",
      message: error.message,
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log("Midtrans configuration:", {
    isProduction: false,
    merchantId: "G206616065",
  });
});
