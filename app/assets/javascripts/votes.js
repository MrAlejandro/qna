$(document).on('turbolinks:load', function () {
  $('.vote-links-container').on('ajax:success', function (e) {
    var response = e.detail[0];
    if (!'rating' in response) {
      return;
    }

    var $link = $(e.target);
    var targetId = $link.data('targetId');

    $('#' + targetId).find('span.rating').html(response.rating);
  });
});

