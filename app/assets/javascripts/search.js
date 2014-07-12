function getSearchData(userInput, topicId) {
  var input = userInput;
  var topicId = parseInt(topicId);
  $.ajax({
    url: '/',
    method: 'post',
    data: {search: input, topics: topicId},
    dataType: 'json',
    beforeSend: function() {
      $('.load').show();
    },
    success: function(data) {
      $('.load').hide();
      $('.search_field').val('');
      $('.topics').val('1')
      console.log(data)
    }
  })
}
