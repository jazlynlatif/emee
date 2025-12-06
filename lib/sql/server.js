import express from "express";
import authRoutes from "./auth.js";
import dataRoutes from "./data.js";
import chatRoutes from "./chat.js";

const app = express();

app.use(express.json());

app.use(authRoutes);
app.use(dataRoutes);
app.use(chatRoutes);

app.listen(5001, () => {
  console.log("Server running on 5001");
});
