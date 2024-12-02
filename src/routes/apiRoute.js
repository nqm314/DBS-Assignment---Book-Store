const { Router } = require('express');
const controllers = require('../controllers');

const route = Router()


//Book route
route.get('/book/get-all', controllers.bookController.getAllBook)
route.get('/book/search', controllers.bookController.searchBook)
route.get('/book/:book_id', controllers.bookController.getBookByID);
route.post('/book/store', controllers.bookController.storeBookToDB);
route.delete('/book/:book_id', controllers.bookController.deleteBook);
route.put('/book/:book_id', controllers.bookController.updateBook);
route.get('/filter-book', controllers.bookController.filterBooks);

//Order route
route.get('/order/get-all', controllers.orderController.getAllOrder)

// Dashboard route
route.get('/dashboard', controllers.dashboardController.getDashboardData)

module.exports = route