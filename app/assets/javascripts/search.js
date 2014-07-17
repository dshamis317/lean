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
      $('.buttons').fadeIn();
      $('.search_field').val('');
      $('.topics').val(topicId);
      $('#results').show();
      renderSearchChart(data.scores);
      renderSearchData(data.search_results);
      renderHistoricalData(data.historical_data);
    }
  })
};

function renderSearchData(array) {
  console.log(array)
  var $results = $('#results');
  for (var i = 0; i < array.length; i++) {
    var $div = parseSearchData(array[i]);
    $results.append($div)
    // $results.fadeIn();
  }
};

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
};

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
      if (stories[j].sentiment_score === null) {
        var sentimentScore = 50;
      } else {
        var sentimentScore = Math.round((parseFloat(stories[j].sentiment_score) + 1) * 50);
      }
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
};

function saveScoresToDB(term, topicID) {
  var searchTerm = term;
  var topic = topicID;
  $.ajax({
    url: '/history/' + topic + '/' + searchTerm,
    method: 'post',
    data: {search: searchTerm, topic: topic},
    dataType: 'json',
    success: function(data) {
      console.log('SAVED TO DB');
      console.log(data);
    }
  })
};

function clearPageData() {
  $('#term').html('');
  $('#topic').html('');
  $('#results').html('').hide();
  $('#chart').html('').hide();
  $('#historical_chart').html('').hide();
  $('.buttons').hide();
};

function automatedSearches() {
  setInterval(function() {
    saveScoresToDB('obama', 11);
  }, 21600000);

  setInterval(function() {
    saveScoresToDB('kardashian', 12);
  }, 21700000)

  setInterval(function() {
    saveScoresToDB('lebron', 15);
  }, 21800000);

  setInterval(function() {
    saveScoresToDB('google', 13);
  }, 21900000)

  setInterval(function() {
    saveScoresToDB('facebook', 13);
  }, 22000000)
};

function getTickerInfo() {
  $.ajax({
    url: '/ticker',
    method: 'get',
    dataType: 'json',
    success: function(data) {
      console.log(data);
      renderTicker(data);
    }
  })
}

function renderTicker(array) {
  var ticker = $('.ticker')

  $.each(array, function(i, item) {
    var $li = $('<li>').html(item)
                       .addClass('jq-news-ticker-item');
    ticker.append($li);
  });

  $('.news-ticker').easyTicker({
    direction: 'up',
    easing: 'swing',
    speed: 'fast',
    interval: 1500,
    height: 'auto',
    visible: 1,
    mousePause: 1,
    controls: {
      up: '',
      down: '',
      toggle: '',
      playText: 'Play',
      stopText: 'Stop'
    }
  });
}
