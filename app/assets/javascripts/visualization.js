function makeSentimentCircle(sentimentScore) {
  var $canvas = $('<canvas>').addClass('sentiment_visual')
                             .attr('width', 52)
                             .attr('height', 52)
                             .width(52)
                             .height(52)

  if (sentimentScore > 50) {
    $canvas.mambo({
      percentage: sentimentScore,
      circleColor: '#006600',
      ringColor: "#00CC00",
      drawShadow: true
    })
  } else {
    $canvas.mambo({
      percentage: sentimentScore,
      circleColor: '#FF0000',
      ringColor: "#CC0000",
      drawShadow: true
    })
  }
  return $canvas
}
