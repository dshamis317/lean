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

function renderSearchChart(data) {
  var data = data;

  var margin = {top: 20, right: 20, bottom: 30, left: 40},
      width = 1200 - margin.left - margin.right,
      height = 450 - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
      .rangeRoundBands([0, width], .1);

  var y = d3.scale.linear()
      .range([height, 0]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .ticks(10, "%");

  var color = d3.scale.linear()
      .domain([1, 0])
      .range(["#FF0000", "#006600"]);

  var svg = d3.select(".chart").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  data.forEach(function(d) {
    x.domain(data.map(function(d) { return d.name; }));
    // y.domain([0, d3.max(data, function(d) { return d.value; })]);
    y.domain([0, 1]);

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)
      .selectAll(".tick text")
        .call(wrap, x.rangeBand());

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Sentiment Level");

    svg.selectAll(".bar")
        .data(data)
      .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.name); })
        .attr("width", x.rangeBand())
        .attr("y", function(d) { return y(d.value); })
        .attr("height", 0.1)
        .transition()
          .duration(2000)
          .attr("height", function(d) { return height - y(d.value); })
          .attr("fill", function(d) { return color(d.value) });
  });
}

function type(d) {
  d.value = +d.value;
  return d;
}

function wrap(text, width) {
  text.each(function() {
    var text = d3.select(this),
        words = text.text().split(/\s+/).reverse(),
        word,
        line = [],
        lineNumber = 0,
        lineHeight = 1.1, // ems
        y = text.attr("y"),
        dy = parseFloat(text.attr("dy")),
        tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
    while (word = words.pop()) {
      line.push(word);
      tspan.text(line.join(" "));
      if (tspan.node().getComputedTextLength() > width) {
        line.pop();
        tspan.text(line.join(" "));
        line = [word];
        tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
      }
    }
  });
}

function visualInitializers() {
  $('.title').hover(function() {
    $(this).addClass('animated swing');
  }, function() {
    $(this).removeClass('animated swing');
  });


}
