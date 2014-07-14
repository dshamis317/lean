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
      var scores = getSentimentScores(data);
      debugger;
      // renderDataChart(scores);
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
    $results.fadeIn();
  }
}

$( document ).tooltip();

function parseSearchData(array) {
  var $div = $('<div>').addClass('search_div');
  var $h3 = $('<h3>').addClass('search_title');
  var $tooltipA = $('<a>').attr('title', array.description)
                          .attr('href', '#')
                          .html(array.title + "  ");
  var $i = $('<i>').addClass('fa fa-share');
  var $siteLinkA = $('<a>').attr('href', array.site_url)
                   .attr('target', '_blank')
                   .append($i);
  var $span = $('<span>').append($siteLinkA);
  var $h5 = $('<h5>').addClass('search_description')
                     .html('Updated: ' + new Date(array.modified));
  $h3.append($tooltipA);
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
                              .html('Sentiment: ' + stories[j].sentiment_type);
      var $canvas = makeSentimentCircle(sentimentScore)

      var $li = $('<li>').addClass('story')
                         .append($storyA)
                         .append(sentiment)
                         .append($canvas)
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

function getSentimentScores(array) {
  var data = [];
  $.each(array, function(idx, datum) {
    var stories = datum.stories;
    if (stories.length > 0) {
      var scores = [];
      $.each(stories, function(id, elem) {
        scores.push((parseFloat(elem.sentiment_score) + 1) *50);
      })
      var counter = 0;
      var sum = 0;
      $.each(scores, function(i, num) {
        sum += num;
        counter ++;
      })
      data.push({name: datum.title, value: sum/counter});
    } else {
      data.push({name: datum.title, value: 0});
    }
  })
  return data;
}

