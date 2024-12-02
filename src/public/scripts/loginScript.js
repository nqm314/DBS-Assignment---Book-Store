document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.querySelector('form');
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const username = loginForm.querySelector('input[type="text"]').value.trim();
        const password = loginForm.querySelector('input[type="password"]').value.trim();

        try {
            const response = await fetch('http://localhost:3000/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ username, password }),
            });

            const data = await response.json();
            if (response.ok) {
                alert('Đăng nhập thành công!');
                // Điều hướng đến trang khác nếu cần
                window.location.href = '/home.html';
            } else {
                alert(data.message || 'Đăng nhập thất bại!');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Có lỗi xảy ra. Vui lòng thử lại!');
        }
    });
});
