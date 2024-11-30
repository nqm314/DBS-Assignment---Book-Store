const express = require("express");
const route = express.Router();
const bookController = require("../controllers/bookController");
const path = require("path");

// router.get("/create", createController.createBook);
route.get("/", bookController.addBook);

route.post("/store", bookController.storeBookToDB);

module.exports = route;