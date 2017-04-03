$(document).on('ready page:load', function () {
  var isLoading = false;
  if ($('#home_news_feed').size() > 0) {
    $(window).on('scroll', function() {
      var more_posts_url = $('.pagination a.next_page').attr('href');
      if (!isLoading && more_news_feed_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        isLoading = true;
        $.getScript(more_news_feed__url).done(function (data,textStatus,jqxhr) {
          isLoading = false;
        }).fail(function() {
          isLoading = false;
        });
      }
    });
  }
});
