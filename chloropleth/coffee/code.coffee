
margin =
  top: 20
  right: 20
  bottom: 30
  left: 50


height = 500 - margin.top - margin.bottom
width = 960 - margin.left - margin.right

svg = d3.select("body")
  .append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

d3.json "gz_2010_us_040_00_500k.json", (json) ->
	projection = d3.geo.albersUsa().translate([
		width / 2
		height / 2
	]).scale([1000])

	path = d3.geo.path().projection(projection)

	svg.selectAll("path")
		.data(json.features)
		.enter()
		.append("path")
		.attr "d", path

	dataset = []

	d3.csv "all_day.csv", (error, data) ->
		dataset = data.map((d) ->
			[
				+d["longitude"]
				+d["latitude"]
				+d["mag"]
				+d["depth"]
			])

		svg.selectAll("circle")
			.data(dataset)
			.enter()
			.append("circle")
			.attr("cx", (d) ->
				try
					projection([
						d[0]
						d[1]
					])[0]
				catch err
					0
			).attr("cy", (d) ->
				try
					projection([
						d[0]
						d[1]
					])[1]
				catch err
					0
			).attr("r", (d) ->
				try
					return 0  if d[3] < 1
					return Math.exp(d[2] / d[3]) * 2.5
				catch err
					0
			).style("fill", "red")
