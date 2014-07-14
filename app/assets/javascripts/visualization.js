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

function renderDataChart(data) {
  var data = data;

  var width = 420,
      barHeight = 20;

  var x = d3.scale.linear()
      .range([0, width]);

  var chart = d3.select(".chart")
      .attr("width", width);

  data.forEach(function(d) {
      x.domain([0, d3.max(data, function(d) { return d.value; })]);

  chart.attr("height", barHeight * data.length);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });

  bar.append("rect")
      .attr("width", function(d) { return x(d.value); })
      .attr("height", barHeight - 1);

  bar.append("text")
      .attr("x", function(d) { return x(d.value) - 3; })
      .attr("y", barHeight / 2)
      .attr("dy", ".35em")
      .text(function(d) { return d.value; });
});

function type(d) {
  d.value = +d.value; // coerce to number
  return d;
}
}
