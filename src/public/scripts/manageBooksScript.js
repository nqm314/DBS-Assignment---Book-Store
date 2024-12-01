// Script for manageBookd.html

const search = document.getElementById('search-area');
const form = document.getElementById('form');
const bookList = document.getElementById('book-list');

//Delete
const confirmationDelBox = document.getElementById("confirmation-delete-box");
const confirmationEditBox = document.getElementById("confirmation-edit-box");
const confirmDelete = document.getElementById("confirm-delete");
const cancelDelete = document.getElementById("cancel-delete");
let bookToDeleteId = null; // Biến lưu trữ ID sách cần xóa
let bookTitle = null;

//Edit 
const confirmEdit = document.getElementById("confirm-edit");
const cancleEdit = document.getElementById("cancle-edit");
let bookToEdit = null; // Biến lưu trữ ID sách cần edit

fetchBooks('http://localhost:3000/api/book/get-all');

function fetchBooks(url) {
    fetch(url)
        .then(response => response.json())
        .then(data => {
            displayBook(data); 
        })
        .catch(error => console.error('Lỗi khi tải sách: ', error));
}

function displayBook(data) {
    bookList.innerHTML = ''; // Xóa sách hiện tại trước khi hiển thị sách mới

    if (data.length === 0) {
        bookList.innerHTML = '<p>Không tìm thấy sách nào.</p>';
        return;
    }
    
    data.forEach(book => {
        const bookDiv = document.createElement('div');
        bookDiv.classList.add('book-card');

        const div_row = document.createElement('div');
        div_row.setAttribute('class', 'row');

        const div_column = document.createElement('div');
        div_column.setAttribute('class', 'column');

        const image = document.createElement('img');
        image.setAttribute('class', 'poster');
        image.src = `${book.Image}`;

        const center = document.createElement('center');
        const type = document.createElement('p');
        type.innerHTML = `<strong>Thể loại</strong>: ${book.BookType}`;

        // Icon del
        const deleteButton = document.createElement("button");
        deleteButton.classList.add("delete-book-btn");
        deleteButton.innerHTML = '<i class="fas fa-trash-alt"></i> Xóa';

        deleteButton.onclick = () => {
            bookToDeleteId = book.BookID; // Lưu ID sách
            bookTitle = book.Title;
            confirmationDelBox.style.display = "flex"; // Hiển thị khung xác nhận
        };

        // Edit button 
        const editButton = document.createElement("button");
        editButton.classList.add("edit-book-btn");
        editButton.innerHTML = '<i class="fas fa-trash-alt"></i> Sửa';

        editButton.onclick = () => {
            bookToEdit = book.BookID; // Lưu ID sách
            bookTitle = book.Title;
            confirmationEditBox.style.display = "flex"; // Hiển thị khung xác nhận
        };

        center.appendChild(image);
        bookDiv.appendChild(center);
        bookDiv.appendChild(type);
        bookDiv.appendChild(editButton);
        bookDiv.appendChild(deleteButton); // Thêm nút xóa vào bookDiv
        div_column.appendChild(bookDiv);
        div_row.appendChild(div_column);

        bookList.appendChild(div_row);
    });
}

form.addEventListener('submit', (e) => {
    e.preventDefault();
    bookList.innerHTML = '';
    const query = search.value.toLowerCase();
    if (query) {
        fetch(`http://localhost:3000/api/book/search?q=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(data => displayBook(data))
        .catch(error => console.error("Lỗi khi tìm kiếm sách: ", error)); 
    }
    else {
        fetchBooks('http://localhost:3000/api/book/get-all');
    }
    search.value = ""; 
});

function deleteBook(bookId, bookTitle) {
    fetch(`http://localhost:3000/api/book/${bookId}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then(function (response) {
        response.json();
      })
      .then(fetchBooks("http://localhost:3000/api/book/get-all"));
    alert(`Đã xóa thành công sách: ${bookTitle}`);
};
  
  // Confirm delete button click handler
confirmDelete.onclick = () => {
    if (bookToDeleteId) {
      console.log(bookToDeleteId);
      deleteBook(bookToDeleteId, bookTitle); // Gọi hàm xóa sách
      bookToDeleteId = null; // Reset ID sách
      bookTitle = null;
      confirmationDelBox.style.display = "none"; // Ẩn khung xác nhận
    }
};

cancelDelete.onclick = () => {
    bookToDeleteId = null; // Reset ID sách
    bookTitle = null;
    confirmationDelBox.style.display = "none"; // Ẩn khung xác nhận
};

confirmEdit.onclick = () => {
    // console.log(bookToEdit)
    // editBook(bookToEdit)
    window.location.href = `/admin/edit-book?id=${bookToEdit}`;
    // confirmationEditBox.style.display = "none"; // Ẩn khung xác nhận
}

cancleEdit.onclick = () => {
    confirmationEditBox.style.display = "none"; // Ẩn khung xác nhận
}
