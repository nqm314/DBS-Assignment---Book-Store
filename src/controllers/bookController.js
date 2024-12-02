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
    console.log('Body data: ', req.body);  // Kiểm tra dữ liệu

    // Sử dụng tên các trường đúng như trong dữ liệu
    const { Title, Description, VolumeNumber, Type, PubName, SeriesName } = req.body;

    if (!Title || !PubName) {
        return res.status(400).send('Thiếu thông tin cần thiết!');
    }

    try {
        const query = `CALL insertBook(?, ?, ?, ?, ?, ?)`;
        await db.execute(query, [
            Title,           // Thay 'title' bằng 'Title'
            Description,     // Thay 'description' bằng 'Description'
            VolumeNumber,    // Thay 'volumn_number' bằng 'VolumeNumber'
            Type,            // Thay 'book_type' bằng 'Type'
            PubName,         // Thay 'publisher_name' bằng 'PubName'
            SeriesName       // Thay 'series_name' bằng 'SeriesName'
        ]);
        res.status(200).json({ message: "Thêm sách thành công!" });
    } catch (err) {
        console.error(err);
        res.status(500).send('Lỗi khi thêm sách!');
    }
};


const deleteBook = async (req, res) => {
    const bookID = req.params.book_id;
    try {
        // Gọi procedure deleteBook
        const query = 'CALL deleteBook(?)';
        const [rows, fields] = await db.execute(query, [bookID]);

        // Kiểm tra kết quả trả về từ procedure (Message)
        if (rows && rows.length > 0) {
            res.status(200).json({ message: rows[0].Message });
        } else {
            res.status(400).send('Lỗi khi xóa sách khỏi cơ sở dữ liệu');
        }
    } catch (err) {
        console.log("Lỗi: ", err);
        return res.status(500).send("Lỗi khi xóa sách khỏi cơ sở dữ liệu");
    }
};


const updateBook = async (req, res) => {
    try {
        const bookID = req.params.book_id; // Lấy ID sách từ URL
        const {
            Title,
            Description,
            VolumeNumber,
            Type,
            PubName,
            SeriesName,
        } = req.body; // Lấy dữ liệu từ request body

        // Đảm bảo các tham số không phải undefined, thay vào đó là null nếu không được cung cấp
        const titleValue = Title || null;
        const descriptionValue = Description || null;
        const volumeNumberValue = VolumeNumber || null;
        const typeValue = Type || null;
        const publisherNameValue = PubName || null;
        const seriesNameValue = SeriesName || null;
        // const discountIDValue = null;

        // Gọi procedure updateBook
        const query = 'CALL updateBook(?, ?, ?, ?, ?, ?, ?)';
        const [rows, fields] = await db.execute(query, [
            bookID,
            titleValue,
            descriptionValue,
            volumeNumberValue,
            typeValue,
            publisherNameValue,
            seriesNameValue,
            // discountIDValue,
        ]);

        res.status(200).json({message: "Cập nhật sách thành công!"});
    } catch (error) {
        console.error("Lỗi khi cập nhật sách:", error);
        res.status(500).send("Có lỗi xảy ra khi cập nhật sách.");
    }
};


const filterBooks = async (req, res) => {
    console.log('Full request URL: ', req.originalUrl);
    console.log('Query parameters: ', req.query); // Log lại

    const type = req.query.type;
    const priceRange = req.query.priceRange;
    const rating = req.query.rating;
    console.log('Type: ', type);
    console.log('Price Range: ', priceRange);
    console.log('Rating: ', rating);

    try {
        // Calling the stored procedure
        const [books] = await db.execute(
            'CALL book_filter(?, ?, ?)', 
            [type || null, priceRange || null, rating || null]
        );
        // console.log(books[0]);

        res.status(200).json(books[0]); // Send back the filtered books
    } catch (error) {
        console.error("Error while filtering books: ", error);
        res.status(500).send("An error occurred while filtering books.");
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
    filterBooks,
}