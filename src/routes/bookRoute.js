const express = require("express");
const route = express.Router();
const createController = require("../controllers/bookController");
const path = require("path");
// router.get("/create", createController.createBook);

route.get("/", createController.addBook);
route.post("/store", createController.storeBookToDB);

module.exports = route;