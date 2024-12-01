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
    return res.sendFile(path.join(__dirname, "../public/views/pages/addBook.html"));
}

const getBookByID = async (req, res) => {
    const bookID = req.params.book_id;
    console.log("bookController nha ", bookID);
    try {
        const book = await bookService.getBookByID(bookID);

        if (!book) {
            return res.status(404).json({ message: "Không tìm thấy sách." });
        }

        res.status(200).json(book);
    } catch (error) {
        console.error(error);
        return res.status(500).send("An error occurred while fetching the book.")
    }
}

const storeBookToDB = async (req, res) => {
    console.log('Body data: ', req.body);
    const { book_id, title, link_img, description, volumn_number, book_type, pub_id, series_id } = req.body;

    // if (!book_id || !title || !link_img || !book_type || !pub_id) {
    //     return res.status(400).send('Thiếu thông tin cần thiết!');
    // }
    if (!book_id) return res.status(400).send('Thieu book_id');
    if (!title) return res.status(400).send("Thieu title");
    if (!link_img) return res.status(400).send("Thieu link_img");
    if (!book_type) return res.status(400).send("Thieu book_type");
    if (!pub_id) return res.status(400).send("Thieu pub_id")
    try {
        const query = `
        INSERT INTO book (BookID, Title, Image, VolumeNumber, BookType, Description, PubID, SeriesID) 
        VALUES  (?, ?, ?, ?, ?, ?, ?, ?)
        `;
        await db.query(query, [
            book_id,
            title,
            link_img,
            volumn_number,
            book_type,
            description,
            pub_id,
            book_type === 'Sách tham khảo' || book_type === 'Tiểu thuyết' ? series_id : null,
        ]);
        res.status(201).send('Thêm sách thành công!');
    } catch (err) {
        console.error(err);
        res.status(500).send('Lỗi khi thêm sách!');
    }
}

const deleteBook = async (req, res) => {
    const bookID = req.params.book_id;
    try {
        const query = 'delete from book where BookID = ?'
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

const updateBook = async (req, res) => {
    try {
        const bookID = req.params.book_id;
        const {
            Title,
            Image,
            Description,
            VolumeNumber,
            BookType,
            SeriesID,
            PubID,
          } = req.body; 

        const result = await bookService.updateBookByID(bookID, {
            Title,
            Image,
            Description,
            VolumeNumber,
            BookType,
            SeriesID,
            PubID,
        });

        if (result.affectedRows === 0) {
            return res.status(404).send("Không tìm thấy sách với ID này.");
        }

        res.status(200).send("Cập nhật thông tin sách thành công.")
    } catch (error) {
        console.error("Lỗi khi cập nhật sách:", error);
        res.status(500).send("Có lỗi xảy ra khi cập nhật sách.");
    }
};

module.exports = {
    getAllBook,
    searchBook,
    addBook, 
    getBookByID,
    storeBookToDB,
    deleteBook,
    updateBook,
}