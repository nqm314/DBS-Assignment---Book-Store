const db = require('../db'); // Kết nối MySQL
const bcrypt = require('bcrypt');

exports.login = async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ message: 'Vui lòng nhập đầy đủ thông tin!' });
    }

    try {
        const query = 'SELECT * FROM users WHERE username = ?';
        const [rows] = await db.execute(query, [username]);

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Người dùng không tồn tại!' });
        }

        const user = rows[0];
        const isPasswordMatch = await bcrypt.compare(password, user.password);

        if (!isPasswordMatch) {
            return res.status(401).json({ message: 'Sai mật khẩu!' });
        }

        // Đăng nhập thành công
        res.json({ message: 'Đăng nhập thành công!', user: { id: user.id, username: user.username } });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Lỗi máy chủ!' });
    }
};
