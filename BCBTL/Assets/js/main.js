// Duy Anh Watch - Main Client JavaScript

document.addEventListener('DOMContentLoaded', function () {
    // 1. Back to top button
    var btnBackToTop = document.getElementById('btnBackToTop');
    if (btnBackToTop) {
        window.addEventListener('scroll', function () {
            if (window.pageYOffset > 300) {
                btnBackToTop.style.display = 'flex';
            } else {
                btnBackToTop.style.display = 'none';
            }
        });

        btnBackToTop.addEventListener('click', function () {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }

    // 2. Tabs in ProductDetail
    var tabBtns = document.querySelectorAll('.tab-nav-btn');
    var tabPanels = document.querySelectorAll('.tab-panel');

    tabBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            var targetTab = this.getAttribute('data-tab');

            tabBtns.forEach(function (b) { b.classList.remove('active'); });
            tabPanels.forEach(function (p) { p.classList.remove('active'); });

            this.classList.add('active');
            var activePanel = document.getElementById(targetTab);
            if (activePanel) {
                activePanel.classList.add('active');
            }
        });
    });

    // 3. Quantity changer helper in ProductDetail
    var btnMinus = document.getElementById('btnQtyMinus');
    var btnPlus = document.getElementById('btnQtyPlus');
    var txtQty = document.getElementById('txtQuantity');

    if (btnMinus && btnPlus && txtQty) {
        btnMinus.addEventListener('click', function (e) {
            e.preventDefault();
            var val = parseInt(txtQty.value) || 1;
            if (val > 1) {
                txtQty.value = val - 1;
            }
        });

        btnPlus.addEventListener('click', function (e) {
            e.preventDefault();
            var val = parseInt(txtQty.value) || 1;
            var max = parseInt(txtQty.getAttribute('max')) || 99;
            if (val < max) {
                txtQty.value = val + 1;
            }
        });
    }

    // 4. Hero Slider simple auto-rotation if multiple slides exist
    var slides = document.querySelectorAll('.hero-slider-wrap .slider-slide');
    if (slides.length > 1) {
        var currentSlide = 0;
        slides.forEach(function (s, idx) {
            if (idx !== 0) s.style.display = 'none';
        });

        setInterval(function () {
            slides[currentSlide].style.display = 'none';
            currentSlide = (currentSlide + 1) % slides.length;
            slides[currentSlide].style.display = 'block';
        }, 5000);
    }
});
