
margin = {top: 20, right: 20, bottom: 30, left: 50}
width = 960 - margin.left - margin.right
height = 500 - margin.top - margin.bottom

svg = d3.select("body")
	.append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  	.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

x = d3.time.scale().range([0, width])
y = d3.scale.linear().range([height, 0])

xAxis = d3.svg.axis().scale(x).orient("bottom")
yAxis = d3.svg.axis().scale(y).orient("left")


line = d3.svg.line()
	.x((d) -> x d.date)
	.y((d) -> y d.close)

parseDate = d3.time.format("%Y-%m-%d").parse

d3.csv "tsla.csv", (error, data) ->
	data.forEach (d) ->
	    d.date = parseDate d.Date
	    d.close = +d.Close
	    d.volume = +d.Volume

	x.domain d3.extent data, (d) -> d.date
	y.domain d3.extent data, (d) -> d.close

	svg.append("g") 
		.attr("class", "x axis")
		.attr("transform", "translate(0," + height + ")")
		.call(xAxis)

	svg.append("g")
		  .attr("class", "y axis")
		  .call(yAxis)
		.append("text")
		  .attr("transform", "rotate(-90)")
		  .attr("y", 6)
		  .attr("dy", ".71em")
		  .attr("fill", "white")
		  .style("text-anchor", "end")
		  .text("Price ($)")
		  .style("fill", "black")

	svg.append("path")
		  .datum(data)
		  .attr("class", "line")
		  .attr("d", line)

	max_volume = d3.max(data, (d) -> d.volume)
	max_close = d3.max(data, (d) -> d.close)

	scaleVolume = (value) ->
		(value / max_volume) * max_close

	svg.selectAll(".bar")
	  .data(data)
	.enter().append("rect")
	  .attr("class", "bar")
	  .attr("x", (d) -> x d.date)
	  .attr("width", 1)
	  .attr("y", (d) -> y scaleVolume d.volume)
	  .attr("height", (d) -> height - y scaleVolume d.volume)









