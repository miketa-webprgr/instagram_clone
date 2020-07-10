// せっかくなので、3D Flip Effectを試しに実装してみた
// https://swiperjs.com/demos/#3D_flip_effect
$(function() {
    new Swiper('.swiper-container', {
        effect: 'flip',
        grabCursor: true,
        pagination: {
            el: '.swiper-pagination',
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    })
});
