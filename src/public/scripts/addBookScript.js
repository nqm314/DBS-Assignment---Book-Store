let announceError = document.getElementById('announce-error')
let bookModal = document.getElementById('book-modal')
const bookType = document.getElementById('book-type')
const seriesContainer = document.getElementById('series-container')

if (typeof error !== 'undefined' && error) {
    announceError.innerHTML = error;
}

function closeModal() {
    window.location.href = '/';
}

function toggleSeriesInput() {
    if (bookType === "Tiểu thuyết" || bookType === "Sách tham khảo") {
        seriesContainer.style.display = 'block';
    }
    else {
        seriesContainer.style.display = 'none';
        document.getElementById('series').value = ''; 
    }
}

