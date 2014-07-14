function getSearchData(userInput, topicId) {
  var input = userInput;
  var topicId = parseInt(topicId);
  $.ajax({
    url: '/',
    method: 'post',
    data: {search: input, topics: topicId},
    dataType: 'json',
    beforeSend: function() {
      $('.load').fadeIn();
    },
    success: function(data) {
      $('.load').hide();
      $('.search_field').val('');
      $('.topics').val(topicId);
      renderSearchData(data);
    }
  })
}

function renderSearchData(array) {
  console.log(array)
  var $results = $('.results');
  for (var i = 0; i < array.length; i++) {
    var $div = parseSearchData(array[i]);
    $results.append($div)
  }
}

function parseSearchData(array) {
  var $div = $('<div>').addClass('search_div');
  var $h3 = $('<h3>').addClass('search_title')
                     .html(array.title);
  var $a = $('<a>').attr('href', array.site_url);
  var $h5 = $('<h5>').addClass('search_description')
                     .html(array.description + ' Updated: ' + array.modified);
  $a.append($h3);
  $div.append($a)
      .append($h5);

  var stories = array.stories;
  if (stories.length > 0) {
    for (var j = 0; j < stories.length; j++) {
      var $storyDiv = $('<div>').addClass('stories');
      var $ul = $('<ul>').addClass('story_list')
                         .appendTo($storyDiv);
      var $storyA = $('<a>').attr('href', stories[j].story_url)
                            .html(stories[j].title);
      var sentiment = $('<p>').html(' Sentiment: ' + stories[j].sentiment_type);
      var $li = $('<li>').addClass('story')
                         .append($storyA)
                         .append(sentiment)
                         .appendTo($ul);
      $div.append($storyDiv);
    }
  } else {
    var $storyDiv = $('<div>').addClass('stories');
    var $p = $('<p>').html('Nothing to see here, check back later...')
                     .appendTo($storyDiv);
    $div.append($storyDiv);
  }
  return $div;
}
