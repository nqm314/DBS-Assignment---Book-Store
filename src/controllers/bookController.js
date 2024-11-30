const { bookService } = require('../services');
const path = require('path') 
const db = require('../config/db');
const { error } = require('console');

const getAllBook = async (req, res) => {
    try {
        const books = await bookService.getAll();
        return res.status(200).json(books);
    } catch (error) {
        console.error(error);
        return res.status(500);
    }
}

const searchBook = async (req, res) => {
    try {
        const books = await bookService.search(req.query.q);
        return res.status(200).json(books);
    } catch (error) {
        console.error(error);
        return res.status(500);
    }
}

const addBook = (req, res) => {
    res.render('pages/addBook')
}

const getBookByID = async (req, res) => {
    const bookID = req.params.book_id;
    try {
        const book = await bookService.getBookByID(bookID);
        return res.status(200).json(book);
    } catch (error) {
        console.error(error);
        return res.status(500).send("An error occurred while fetching the book.")
    }
}

const storeBookToDB = async (req, res) => {
    const {
        book_id,
        title,
        link_img,
        description,
        volume_number,
        book_type,
        pub_id,
        series_id
    } = req.body; 

    if (!book_id || !title || !link_img || !book_type || !pub_id) {
        return res.render('pages/addBook', { error: "Thiếu thông tin cần thiết" });
    }

    const seriesIDValue = book_type === 'Sách tham khảo' || book_type === 'Tiểu thuyết' ? series_id : null;

    try {
        const query = `
        INSERT INTO book (book_id, title, link_image, volume_number, book_type, description, pub_id, series_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `
        await db.query(query, [
            book_id,
            title,
            link_img,
            volume_number,
            book_type,
            description,
            pub_id,
            seriesIDValue,
        ]);
        res.redirect('/')
    }
    catch (err) {
        console.error('Lỗi khi thêm sách: ', err);
        if (err.code === 'ER_DUP_ENTRY'){
            return res.render('pages/addBook', { error: "BookID đã tồn tại"});
        }
        return res.render('pages/addBook', {
            error: "Lỗi khi thêm sách vào cơ sở dữ liệu"
        })
    }
}

const deleteBook = async (req, res) => {
    const bookID = req.params.book_id;
    try {
        const query = 'delete from book where book_id = ?'
        await db.query(query, [bookID], (err, result) => {
            if (err) {
                console.log("Lỗi: ", err)
                return res.status(500).send("Lỗi khi xóa sách khỏi cơ sở dữ liệu");
            }
            res.status(200).json({ message: "Sách đã được xóa thành công" });
        })
    }
    catch (err) {
        console.log("Lỗi: ", err);
        return res.status(500).send("Lỗi khi xóa sách khỏi cơ sở dữ liệu");
    }
}

module.exports = {
    getAllBook,
    searchBook,
    addBook, 
    getBookByID,
    storeBookToDB,
    deleteBook
}