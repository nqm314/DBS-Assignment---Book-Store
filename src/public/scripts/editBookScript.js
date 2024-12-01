// Script for editBook.html

const urlParams = new URLSearchParams(window.location.search);
const bookId = urlParams.get("id")
console.log("editBookScript nha ", bookId);

function fetchBookDetails() {
    console.log("Đang fetch thông tin cho Book ID:", bookId); // Log thêm
    fetch(`http://localhost:3000/api/book/${bookId}`)
    .then((response) => {
        console.log("Response nhận được:", response);
        return response.json();
    })
    .then((data) => {
        console.log("Dữ liệu JSON nhận được:", data);
        const book = data[0];
        if (book) {
            console.log("Thong tin sach: ", book);
            document.getElementById("book-id").value = book.bookId || "";
            // document.getElementById("book-id").innerHTML = data.bookId || "";
            document.getElementById('book-title').value = book.Title || "";
            document.getElementById('link-book-img').value = book.Image || "";
            document.getElementById('book-chapters').value = book.VolumeNumber || "";         
            document.getElementById('book-type').value = book.BookType || "";
            document.getElementById('book-description').value = book.Description || "";
            document.getElementById('series').value = book.SeriesID || "";
            document.getElementById('publisher').value = book.PubID || "";
        }
        else {
            alert("Khong tim thay thong tin sach")
        }
    })
    .catch ((error) => {
        console.error("Loi khi lay thong tin sach: ", error);
        alert("Co loi xay ra khi tai thong tin sach.");
    });
}

document.getElementById('edit-book-form').addEventListener('submit', (e) => {
    e.preventDefault();

    const updatedBook = {
        Title: document.getElementById("book-title").value,
        Image: document.getElementById("link-book-img").value,
        Description: document.getElementById("book-description").value,
        VolumeNumber: document.getElementById("book-chapters").value,
        BookType: document.getElementById("book-type").value,
        SeriesID: document.getElementById("series").value,
        PubID: document.getElementById("publisher").value,
    }

    fetch(`http://localhost:3000/api/book/${bookId}`, {
        method: "PUT",
        headers: {
            'Content-Type': "application/json",
        },
        body: JSON.stringify(updatedBook),
    })
    .then((response) => response.json())
    .then((data) => {
        alert('Sach da duoc cap nhat thanh cong!');
        window.location.href = '/admin/manage-books';
    })
    .catch((error) => {
        console.error("Loi khi cap nhat sach: ", error);
        alert("Co loi khi cap nhat sach.");
    })
})

fetchBookDetails();