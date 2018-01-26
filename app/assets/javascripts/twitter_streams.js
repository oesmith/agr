$(function() {
  $('.tweet-data-show').click(function(evt) {
    var el = $(evt.target).closest('.tweet-data');
    el.removeClass('tweet-data-closed');
    el.addClass('tweet-data-open');
    return false;
  });

  $('.tweet-data-hide').click(function(evt) {
    var el = $(evt.target).closest('.tweet-data');
    el.removeClass('tweet-data-open');
    el.addClass('tweet-data-closed');
    return false;
  });
});