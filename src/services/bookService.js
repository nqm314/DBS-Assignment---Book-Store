const db = require('../config/db');

const getAll = async () => {
    try {
        const results = await db.execute('select * from book limit 10');
        return results[0];
    } catch (error) {
        throw error;
    }
}

const search = async (query) => {
    try {
        const results = await db.execute('select * from book where title like ? limit 10',[`%${query}%`]);
        return results[0];
    } catch (error) {
        throw error;
    }
}

const getBookByID = async (bookId) => {
    try {
      const result = await db.execute("SELECT * FROM book WHERE BookID = ?", [
        bookId,
      ]);
      return result[0];
    } catch (error) {
      throw error;
    }
};

const updateBookByID = (bookId, updatedFields) => {
    const q = `UPDATE book
    SET 
      Title = ?,
      Image = ?,
      Description = ?,
      VolumeNumber = ?,
      BookType = ?,
      SeriesID = ?,
      PubID = ?
    WHERE BookID = ?`;

    const values = [
        updatedFields.Title,
        updatedFields.Image,
        updatedFields.Description,
        updatedFields.VolumeNumber,
        updatedFields.BookType,
        updatedFields.SeriesID,
        updatedFields.PubID,
        bookId,
    ];

    return new Promise((resolve, reject) => {
        db.query(q, values, (err, result) => {
          if (err) return reject(err);
          resolve(result);
        });
    });
}

module.exports = {
    getAll,
    search,
    getBookByID,
    updateBookByID,
}