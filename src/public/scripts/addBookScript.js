let announceError = document.getElementById('announce-error')
let bookModal = document.getElementById('book-modal')
const bookType = document.getElementById('book-type')
const seriesContainer = document.getElementById('series-container')
const responseModal = document.getElementById('response-modal');
const responseMessage = document.getElementById('response-message');
const okBtn = document.getElementById('ok-btn');
const form = document.getElementById('form-add-book-content');


if (typeof error !== 'undefined' && error) {
    announceError.innerHTML = error;
}

function closeModal() {
    window.location.href = '/admin/manage-books';
}

form.addEventListener('submit', (e) => {
    e.preventDefault(); 

    const formData = {
        Title: document.getElementById("book-title").value,
        // Image: document.getElementById("link-book-img").value,
        Description: document.getElementById("book-description").value,
        VolumeNumber: document.getElementById("book-chapters").value,
        Type: document.getElementById("book-type").value,
        PubName: document.getElementById("publisher").value,
        SeriesName: document.getElementById("series").value,
    }

    // Send the data via fetch API (AJAX request)
    fetch('/api/book/store', {
        method: 'POST',
        headers: {
            'Content-Type': "application/json",
        },
        body: JSON.stringify(formData),
    })
    .then(response => response.json())
    .then(data => {
        // console.log("data: ", data);
        if (data.message ==='Thêm sách thành công!') {
            // Success
            responseMessage.innerHTML = "Thêm sách thành công!";
            responseModal.style.display = 'block';
            okBtn.addEventListener('click', function() {
                window.location.href = '/admin/manage-books';
            });
        } else {
            // Error
            responseMessage.innerHTML = "Thêm sách không thành công. Vui lòng thử lại!";
            responseModal.style.display = 'block';
            okBtn.addEventListener('click', function() {
                responseModal.style.display = 'none'; // Ẩn modal khi nhấn Ok
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        responseMessage.innerHTML = "Có lỗi xảy ra, vui lòng thử lại!";
        responseModal.style.display = 'block';
        okBtn.addEventListener('click', function() {
            responseModal.style.display = 'none'; // Ẩn modal khi nhấn Ok
        });
    });
});

