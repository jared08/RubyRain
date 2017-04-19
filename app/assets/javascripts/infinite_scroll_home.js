$(document).on('ready page:load', function () {
  var isLoading = false;
  if ($('#infinite-scrolling-home').size() > 0) {
    $(window).on('scroll', function() {
      var more_feed_url = $('.pagination a.next_page').attr('href');
      if (!isLoading && more_feed_url && (($(window).scrollTop() > $(document).height() - $(window).height() - 120) ||
        ($(window).scrollTop() > ($('#home_feed').height() - 600)))) {
        isLoading = true;
        $.getScript(more_feed_url).done(function (data,textStatus,jqxhr) {
          isLoading = false;
        }).fail(function() {
          isLoading = false;
        });
      }
    });
  }
});
