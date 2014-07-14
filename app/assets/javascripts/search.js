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
                     .html(array.title + "  ");
  var $i = $('<i>').addClass('fa fa-share');
  var $a = $('<a>').attr('href', array.site_url)
                   .attr('target', '_blank')
                   .append($i);
  var $span = $('<span>').append($a);
  var $h5 = $('<h5>').addClass('search_description')
                     .html(array.description + ' Updated: ' + array.modified);
  $h3.append($span);
  $div.append($h3)
      .append($h5);

  var $storyDiv = parseStories(array.stories)
  $div.append($storyDiv);
  return $div;
}

function parseStories(array) {
  var stories = array;
  var $storyDiv = $('<div>').addClass('stories');
  if (stories.length > 0) {
    for (var j = 0; j < stories.length; j++) {
      var $ul = $('<ul>').addClass('story_list')
                         .appendTo($storyDiv);
      var $storyA = $('<a>').attr('href', stories[j].story_url)
                            .attr('target', '_blank')
                            .html(stories[j].title);
      var sentimentScore = Math.round((parseFloat(stories[j].sentiment_score) + 1) * 50);
      var sentiment = $('<p>').addClass('sentiment')
                              .html('Sentiment Score: ' + sentimentScore +'/100 = ');
      var sentSpan = $('<span>').addClass('sentiment_type')
                                .html(stories[j].sentiment_type);
      sentiment.append(sentSpan)
      var $li = $('<li>').addClass('story')
                         .append($storyA)
                         .append(sentiment)
                         .appendTo($ul);
      $storyDiv.append($ul);
    }
  } else {
    var $p = $('<p>').html('Nothing to see here, check back later...')
                     .appendTo($storyDiv);
    $storyDiv.append($p);
  }
  return $storyDiv
}
